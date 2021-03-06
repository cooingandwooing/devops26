######################
# Create The Cluster #
######################

gcloud auth login

gcloud container clusters \
    create jx-rocks \
    --region us-east1 \
    --machine-type n1-standard-2 \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 3 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

###################
# Install Ingress #
###################

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml

#####################
# Install Jenkins X #
#####################

export LB_IP=$(kubectl -n ingress-nginx \
    get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

DOMAIN=jenkinx.$LB_IP.nip.io

PROVIDER=gke

INGRESS_NS=ingress-nginx

INGRESS_DEP=nginx-ingress-controller

echo "nexus:
  enabled: false
" | tee myvalues.yaml

jx install \
    --provider $PROVIDER \
    --external-ip $LB_IP \
    --domain $DOMAIN \
    --default-admin-password=admin \
    --ingress-namespace $INGRESS_NS \
    --ingress-deployment $INGRESS_DEP \
    --default-environment-prefix jx-rocks \
    --git-provider-kind github

#######################
# Uninstall Jenkins X #
#######################

jx uninstall \
  --context $(kubectl config current-context) \
  -b

#######################
# Destroy the cluster #
#######################

gcloud container clusters \
    delete jx-rocks \
    --region us-east1 \
    --quiet

gcloud compute disks delete \
    $(gcloud compute disks list \
    --filter="-users:*" \
    --format="value(id)")
