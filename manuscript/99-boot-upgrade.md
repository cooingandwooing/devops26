## TODO

- [ ] Code
- [ ] Write
- [-] Code review static GKE
- [ ] Code review serverless GKE
- [-] Code review static EKS
- [ ] Code review serverless EKS
- [-] Code review static AKS
- [ ] Code review serverless AKS
- [-] Code review existing static cluster
- [-] Code review existing serverless cluster
- [ ] Text review
- [ ] Gist
- [ ] Review titles
- [ ] Proofread
- [ ] Diagrams
- [ ] Add to slides
- [ ] Publish on TechnologyConversations.com
- [ ] Add to Book.txt
- [ ] Publish on LeanPub.com 

# Upgrading The Cluster With JX Boot

https://github.com/jenkins-x/jx/issues/6067
https://github.com/jenkins-x/jx/issues/6066
https://github.com/jenkins-x/jx/issues/6132

NOTE: Should wait for a while until a new version is released

## Cluster

* Create a new **GKE** cluster created **with the Boot**: [gke-jx-boot.sh](https://gist.github.com/1eff2069aa68c4aee29c35b94dd9467f)
* Create a new **EKS** cluster created **with the Boot**: [eks-jx-boot.sh](https://gist.github.com/cdc18fd7c439d4b39cd810e999dd8ce6)

## Upgrades

```bash
export CLUSTER_NAME=[...]

cd environment-$CLUSTER_NAME-dev

jx upgrade boot
```

```
Version stream upgrade available
using default boot config https://github.com/jenkins-x/jenkins-x-boot-config.git
boot config upgrade available
Upgrading from v1.0.56 to v1.0.71
cherry picking commits in the range 090a4ce28d05dfdbd47935169ac5ce6c91f86f68..5430452752631090455fb996e14c64f7d3969723
934a4b48c889838d99d7c6a0ddea2f8361f21a2b - fix: make it easier for users to edit environmentGitPublic
44adc1fbfdbd754eb8ccab4af8b64945f8c407b6 - fix: alphabetical ordering
283b08b08f580c929f3ea9965ad20ec85970158d - fix: Fill mandatory tls field for jxboot chart
40dc27c7d468164e57f1f3f240fac7e30d8cdc1b - fix: use NLB for jxing in AWS
008f4a0f433db26ed80bfb8c89f0e56761730a9a - feat: re-enable the vault BDD
9c91f9dd7e937c29d42c7178bf5cf94171dd3813 - chore: name the cluster name for local bdd consistently
63e9974f4e4506ca30d8306f428af32eb04a87ce - fix: generate the jx auth config in a configmap
2918c5d31263b81dec6c2675a0c6716774274d08 - chore: name properly the jx auth configmap template file
3bd3ebd5287789f6f6a56a377a6a33716f6c0379 - chore: print the content of jx auth configmap before installation
25203220504cbf77d3895b801fcc3d76193fa4ea - chore: print the generated paramters file just for testing
59afbeb0cf17ffd3960350d6d28f610da943907e - chore: print the requirements file used by the template generator
d033704920aa7dc180cbd80472fb05e773219478 - fix: use relative paths when generating the jx auth template
1d2d77772bd1f0782229c0fae6bc490da7a2b293 - chore: remove the cat step used for testing
0d076e6dc776b9d858e926d6c0064ec3f8e9052a - Revert "fix: generate the jx auth config in a configmap"
a8c13a36ef84c99a194a66c2601fbf5127fb5149 - Revert "fix: Revert "fix: generate the jx auth config in a configmap""
649cff7ed20f600b82ec4ed12f0b11b416307855 - feat: Make remote and namespace configurable for staging and production
fb5ebb3ab6d914feab609980ed8622058a98098a - fix: Only use docker-credential-ecr-login for ecr
1252c062af8cfef618a080371992ae7a6274bd9d - Revert "fix: generate the jx auth config in a configmap"
242ae80c197d5454fc76699ff767d6261e043cde - Revert "Revert "fix: generate the jx auth config in a configmap""
fa92b65c0a5b61801ee7ad481ce2e6899318839c - fix: Use cert-manager 0.11 CRDs/APIs with Dex
eb3f3a2af39ce20d35478a650386a56da236ca40 - fix: define the domains of all environments in the external-dns domain filters
0712cc116028db86bdb99b158cd68a719a917edd - feat: fix vault DynamoDB permissions
8f75b81f19b7fe06f30cbdf3164cbaf32a47de9f - feat: add jxui's Service Account to IRSA under S3 Full Access to be able to download logs
5430452752631090455fb996e14c64f7d3969723 - release 1.0.71
Upgrading version stream ref to a85e588f32650bc841aed83ba789ef7d624e0a65
Updating pipeline agent images to gcr.io/jenkinsxio/builder-go:2.0.1126-461
Updating template builder images to gcr.io/jenkinsxio/builder-go:2.0.1126-461
Skipping template builder image update as no changes were detected
? Do you wish to use vfarcic as the user name to use for authenticating with git issues Yes
Created Pull Request: https://github.com/vfarcic/environment-vfarcic2-dev/pull/4
```

```bash
export BRANCH=[...] # e.g., PR-4

jx get activities \
    --filter environment-$CLUSTER_NAME-dev/$BRANCH \
    --watch
```

```
...
vfarcic/environment-vfarcic2-dev/PR-4 #1                   2m46s    2m42s Succeeded 
  meta pipeline                                            2m46s      15s Succeeded 
    Credential Initializer 2hr2k                           2m46s       0s Succeeded 
    Working Dir Initializer 9qhmk                          2m46s       1s Succeeded 
    Place Tools                                            2m45s       1s Succeeded 
    Git Source Meta Vfarcic Environment Vfarci Gzc28       2m44s       4s Succeeded https://github.com/vfarcic/environment-vfarcic2-dev.git
    Git Merge                                              2m40s       2s Succeeded 
    Merge Pull Refs                                        2m38s       1s Succeeded 
    Create Effective Pipeline                              2m37s       4s Succeeded 
    Create Tekton Crds                                     2m33s       2s Succeeded 
  pr checks                                                2m30s    2m26s Succeeded 
    Credential Initializer Mph2h                           2m30s       0s Succeeded 
    Working Dir Initializer Hk8xz                          2m30s       1s Succeeded 
    Place Tools                                            2m29s       1s Succeeded 
    Git Source Vfarcic Environment Vfarcic2 De Kl5hr       2m28s      28s Succeeded https://github.com/vfarcic/environment-vfarcic2-dev.git
    Git Merge                                               2m0s       4s Succeeded 
    Verify Parameters                                      1m56s       1s Succeeded 
    Lint Env Helm                                          1m55s    1m51s Succeeded 
```

```bash
# Stop watching by pressing ctrl+c when statuses of all the steps are `Succeeded`

# Open the PR

# Select the *Files changed* tab and review the proposed updates

# Select the *Conversation* tab

# Click the *Merge pull request* button

jx get activities \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch
```

```
...
vfarcic/environment-vfarcic2-dev/master #12                5m25s    5m13s Succeeded 
  meta pipeline                                            5m25s      28s Succeeded 
    Credential Initializer R7q8g                           5m25s       0s Succeeded 
    Working Dir Initializer 2d6bd                          5m25s       1s Succeeded 
    Place Tools                                            5m24s       1s Succeeded 
    Git Source Meta Vfarcic Environment Vfarci Hbw2p       5m23s       4s Succeeded https://github.com/vfarcic/environment-vfarcic2-dev.git
    Git Merge                                              5m19s       1s Succeeded 
    Merge Pull Refs                                        5m18s       0s Succeeded 
    Create Effective Pipeline                              5m18s       4s Succeeded 
    Create Tekton Crds                                     5m14s      17s Succeeded 
  release                                                  4m56s    4m44s Succeeded 
    Credential Initializer J2g8g                           4m56s       0s Succeeded 
    Working Dir Initializer L4pv5                          4m56s       1s Succeeded 
    Place Tools                                            4m55s       1s Succeeded 
    Git Source Vfarcic Environment Vfarcic2 De R98zs       4m54s       9s Succeeded https://github.com/vfarcic/environment-vfarcic2-dev.git
    Git Merge                                              4m45s       1s Succeeded 
    Validate Git                                           4m44s       1s Succeeded 
    Verify Preinstall                                      4m43s      34s Succeeded 
    Install Jx Crds                                         4m9s      17s Succeeded 
    Install Velero                                         3m52s      32s Succeeded 
    Install Velero Backups                                 3m20s       8s Succeeded 
    Install Nginx Controller                               3m12s      17s Succeeded 
    Create Install Values                                  2m55s       1s Succeeded 
    Install External Dns                                   2m54s      20s Succeeded 
    Install Cert Manager Crds                              2m34s       1s Succeeded 
    Install Cert Manager                                   2m33s      18s Succeeded 
    Install Acme Issuer And Certificate                    2m15s       3s Succeeded 
    Install Vault                                          2m12s      10s Succeeded 
    Create Helm Values                                      2m2s       2s Succeeded 
    Create Jx Auth Config                                   2m0s       1s Succeeded 
    Install Jx Auth Config                                 1m59s       4s Succeeded 
    Install Jenkins X                                      1m55s    1m20s Succeeded 
    Verify Jenkins X Environment                             35s       5s Succeeded 
    Install Repositories                                     30s       6s Succeeded 
    Install Pipelines                                        24s       1s Succeeded 
    Update Webhooks                                          23s      10s Succeeded 
    Verify Installation                                      13s       1s Succeeded 
```

```bash
# Stop watching by pressing ctrl+c when statuses of all the steps are `Succeeded`

git pull

cat jx-requirements.yml

# Open `jx-requirements.yml` in your favorite editor

# Change `autoUpdate.enabled` to `true`

# Change `autoUpdate.schedule` to `"0 0 * * *"`

# Save and close

git add .

git commit -m "Switch to auto-upgrades"

git push

jx get activities \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

# Stop watching by pressing ctrl+c when statuses of all the steps are `Succeeded`

# https://github.com/jenkins-x/jx/issues/6542

# TODO: Show the new cronjob (if there is any)

# TODO: Output the changes from the private cluster
```

## Backups

```bash
# TODO: Move to the top of the chapter

# Create a GCP bucket with the name `jx-backup` (or any other)

# Open `jx-requirements.yml` in your favorite editor

# Open `jx-requirements.yml` in an editor

# Change `storage.backup.enabled` to `true`

# Change `storage.backup.url` to `gs://jx-backup`

# Change `velero.schedule` to `"0 23 * * *"`

# Save and close

git add .

git commit -m "Added backups"

git push

jx get activities \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

kubectl get cronjobs

# TODO: Cronjob was not created

ls -1 systems

ls -1 systems/velero-backups

ls -1 systems/velero-backups/templates

cat systems/velero-backups/templates/default-backup.yaml

kubectl --namespace velero \
    get all

# TODO: Validate that the backups are being created
```

## Update

```bash
# TODO: Upgrade Jenkins X version

# TODO: `autoUpdate` in `jx-requirements.yml`
```

## Recreate The Cluster

```bash
# Destroy the cluster and create a new one
# gke-jx-serverless-boot.sh

jx boot

# https://github.com/jenkins-x/jx/issues/5587

# TODO: Continue after the issue is closed

kubectl --namespace kube-system \
    get service jxing-nginx-ingress-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}"
```

```
34.74.70.149
```

```bash
# Change DNSes of your domain

export DOMAIN=[...]

ping $DOMAIN

# Confirm that it is using the correct IP, and than wait some more

# Change `ingress.domain` (NOT `environments.ingress.domain`) in jx-requirements.yml

# Change `environments.ingress.domain` in jx-requirements.yml

git add .

git commit -m "Changed the domain"

git push

jx get activities \
    --filter environment-$CLUSTER_NAME-dev \
    --watch
```

## Storage

TODO: Code

## Extending The Boot Pipeline

TODO: Code

## Manual and Auto Upgrades

```
 jx step boot upgrade
```

TODO: Enable `autoUpdate` in `jx-requirements.yml`

## Domain & TLS

```bash
# https://github.com/jenkins-x/jx/issues/5715
# https://github.com/jenkins-x/jx/issues/5763

# TODO: Remove
# kubectl --namespace kube-system \
#     get service jxing-nginx-ingress-controller \
#     --output jsonpath="{.status.loadBalancer.ingress[0].ip}"

# TODO: Remove
# Change the DNS in your domain registrar

# TODO: Remove
# DOMAIN=[...]

# TODO: Remove
# ping $DOMAIN

# TODO: Explain how to create a domain in GCP or somewhere

git pull

# Open `jx-requirements.yml` in an editor

# Set `ingress.domain` to the new domain
# Set `ingress.externalDNS` to `true`
# Set `ingress.tls.email` to your email
# Set `ingress.tls.enabled` to `true`
# Set `ingress.tls.production` to `true`

git add .

git commit -m "Changed the domain"

git push

jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

# *ctrl+c*

# TODO: Confirm that it works

# TODO: Change `environments.ingress` in `jx-requirements.yml`
```

## Update

```bash
kubectl get pods | grep docker

# It's empty

cat env/parameters.yaml

cat env/parameters.yaml \
    | sed -e \
    "s@enableDocker: false@enableDocker: true@g" \
    | tee env/parameters.yaml
```

```yaml
adminUser:
  password: vault:jx-boot/adminUser:password
  username: admin
enableDocker: true
pipelineUser:
  email: viktor@farcic.com
  token: vault:jx-boot/pipelineUser:token
  username: vfarcic
prow:
  hmacToken: vault:jx-boot/prow:hmacToken
```

```bash
# If there's something wrong with Jenkins X inside the cluster, we can also run `jx boot` locally.

git status

git add .

git commit -m "Initial setup"

git push

jx get activities \
    --filter environment-$CLUSTER_NAME-dev \
    --watch

# TODO: Continue when https://github.com/jenkins-x/jx/issues/5381 is fixed


kubectl get pods | grep docker

cd ../jx-boot

echo "Testing Docker Hub" \
    | tee README.md

git add .

git commit -m "A silly change"

git push --set-upstream origin master

jx get activity \
    --filter jx-boot/master \
    --watch

# ctrl+c

jx get activity \
    --filter environment-$CLUSTER_NAME-staging/master \
    --watch

# ctrl+c
```

TODO: Use-cases from 14-upgrade.md

## What Now?

```bash
cd ..

export GH_USER=[...]

hub delete -y \
    $GH_USER/environment-$CLUSTER_NAME-staging

hub delete -y \
    $GH_USER/environment-$CLUSTER_NAME-production
```
