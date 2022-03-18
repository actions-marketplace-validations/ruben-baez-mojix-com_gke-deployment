#!/bin/sh

set -e

# IMAGE = $1
# PROJECT = $2
# TAG = $3
# SHA = $4
# DEPLOY  = $5
# PROJECT_ID  = $6
# PROJECT_LOCATION  = $7
# PROJECT_CLUSTER_NAME  = $8

output=$(env)
# set
echo "$output" > "${HOME}/${GITHUB_ACTION}.log"
echo "$output"

cd /home
# npx ts-node src/main.ts

echo $INPUT_SA>/opt/sa.json
export GOOGLE_APPLICATION_CREDENTIALS=/opt/sa.json

exec 3>&1 4>&2 #set up extra file descriptors
npm install
npm install -g typescript
npx=$( { npx ts-node src/main.ts 2>&4 1>&3; } 2>&1 )
echo "npx: $npx"

# kubectl config get-contexts --kubeconfig /home/kube-config.yaml
export KUBECONFIG=/home/kube-config.yaml

echo "start updating.."
# ./kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/$INPUT_PROJECT_ID/$IMAGE:$TAG
# ./kustomize build . | kubectl apply -f -
kubectl set image deployment/$INPUT_DEPLOY $INPUT_DEPLOY=$INPUT_IMAGE:$INPUT_TAG -n $INPUT_NAMESPACE
kubectl rollout restart deploy/$INPUT_DEPLOY -n $INPUT_NAMESPACE
kubectl get deploy/$INPUT_DEPLOY -o wide -n $INPUT_NAMESPACE

# Capture output
output=$("$INPUT_DEPLOY deploy updated with: $IMAGE")
current_date=$(date)
echo "deployment time: $current_date"
# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.log"

# Write output to STDOUT
echo "$output"
