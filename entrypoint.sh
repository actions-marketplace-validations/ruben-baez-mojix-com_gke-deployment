#!/bin/sh

set -e

IMAGE = $1
PROJECT = $2
TAG = $3
SHA = $4
DEPLOY  = $5
PROJECT_ID  = $6
PROJECT_LOCATION  = $7
PROJECT_CLUSTERID = $8
PROJECT_CLUSTER_NAME  = $9

./kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/$PROJECT_ID/$IMAGE:$TAG
./kustomize build . | kubectl apply -f -
kubectl rollout status deployment/$DEPLOY
kubectl get services -o wide

# Capture output
output="$DEPLOY deploy updated with: $IMAGE"

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.log"

# Write output to STDOUT
echo "$output"
