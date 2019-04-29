# Links to gists for creating a cluster with jx
# gke-jx.sh: https://gist.github.com/86e10c8771582c4b6a5249e9c513cd18
# eks-jx.sh: https://gist.github.com/dfaf2b91819c0618faf030e6ac536eac
# aks-jx.sh: https://gist.github.com/6e01717c398a5d034ebe05b195514060
# install.sh: https://gist.github.com/3dd5592dc5d582ceeb68fb3c1cc59233

open "https://github.com/vfarcic/go-demo-6"

GH_USER=[...]

git clone \
  https://github.com/$GH_USER/go-demo-6.git

cd go-demo-6

# orig does not exist?
git checkout orig

git merge -s ours master --no-edit

git checkout master

git merge orig

# this deletes the chart requirements and it's not generated by draft
rm -rf charts

git push

jx repo -b

ls -1

jx import --batch-mode

ls -1

jx get activities -f go-demo-6 --watch

STAGING_ADDR=[...]

# curl -kL to workaround bad ssl and follow redirect
curl "$STAGING_ADDR/demo/hello"

# with tekton this is app=jx-go-demo-6 not app=jx-staging-go-demo-6
kubectl -n jx-staging logs \
    -l app=jx-go-demo-6

kubectl -n jx-staging get pods

kubectl -n jx-staging \
    describe pod \
    -l app=jx-go-demo-6


sed '1,/go-demo-6-db:/!d' charts/go-demo-6/values.yaml | sed '/go-demo-6-db:/d' > charts/go-demo-6/values.yaml.bak
mv charts/go-demo-6/values.yaml.bak charts/go-demo-6/values.yaml

echo "go-demo-6-db:
  replicaSet:
    enabled: true
  usePassword: false
  podAnnotations:
    sidecar.istio.io/inject: \"false\"
" | tee -a charts/go-demo-6/values.yaml

echo "canary:
  enable: true
  service:
    hosts:
    - go-demo-6.istio.example.com
    gateways:
    - jx-gateway.istio-system.svc.cluster.local
  canaryAnalysis:
    interval: 60s
    threshold: 5
    maxWeight: 50
    stepWeight: 10
    metrics:
    - name: istio_requests_total
      # minimum req success rate (non 5xx responses)
      # percentage (0-100)
      threshold: 99
      interval: 60s
    - name: istio_request_duration_seconds_bucket
      # maximum req duration P99
      # milliseconds
      threshold: 500
      interval: 60s
" | tee -a charts/go-demo-6/values.yaml

echo "{{- if eq .Release.Namespace \"jx-production\" }}
{{- if .Values.canary.enable }}
apiVersion: flagger.app/v1alpha2
kind: Canary
metadata:
  # canary name must match deployment name
  name: {{ template \"fullname\" . }}
spec:
  # deployment reference
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ template \"fullname\" . }}
  progressDeadlineSeconds: 60
  service:
    # container port
    port: {{.Values.service.internalPort}}
{{- if .Values.canary.service.gateways }}
    # Istio gateways (optional)
    gateways:
{{ toYaml .Values.canary.service.gateways | indent 4 }}
{{- end }}
{{- if .Values.canary.service.hosts }}
    # Istio virtual service host names (optional)
    hosts:
{{ toYaml .Values.canary.service.hosts | indent 4 }}
{{- end }}
  canaryAnalysis:
    # schedule interval (default 60s)
    interval: {{ .Values.canary.canaryAnalysis.interval }}
    # max number of failed metric checks before rollback
    threshold: {{ .Values.canary.canaryAnalysis.threshold }}
    # max traffic percentage routed to canary
    # percentage (0-100)
    maxWeight: {{ .Values.canary.canaryAnalysis.maxWeight }}
    # canary increment step
    # percentage (0-100)
    stepWeight: {{ .Values.canary.canaryAnalysis.stepWeight }}
{{- if .Values.canary.canaryAnalysis.metrics }}
    metrics:
{{ toYaml .Values.canary.canaryAnalysis.metrics | indent 4 }}
{{- end }}
{{- end }}
{{- end }}" | tee charts/go-demo-6/templates/canary.yaml

git add charts/go-demo-6/templates/canary.yaml

ISTIO_IP=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

sed "s/go-demo-6.istio.example.com/go-demo-6.${ISTIO_IP}.nip.io/" charts/go-demo-6/values.yaml > charts/go-demo-6/values.yaml.bak
mv charts/go-demo-6/values.yaml.bak charts/go-demo-6/values.yaml

git commit -am "Enable canary deployments"

git push

jx get activities -f go-demo-6 -w

# wait for new version to be built

jx get applications

jx promote go-demo-6 --version 1.0.1 --env production

# deploy a new app

sed "s/hello, PR/hello canary, PR/" main.go > main.go.bak
mv main.go.bak main.go
git commit -am "Canary"
git push

# promote to production

jx get applications

jx promote go-demo-6 --version 1.0.2 --env production

kubectl -n istio-system logs -f deploy/flagger

watch curl -skL "http://go-demo-6.${ISTIO_IP}.nip.io/demo/hello"



hub delete -y \
  $GH_USER/environment-jx-rocks-staging

hub delete -y \
  $GH_USER/environment-jx-rocks-production

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*
