# #!/bin/sh

# set -e

# echo "Creating KUBECONFIG..";

# IMAGE = $1
# PROJECT = $2
# TAG = $3
# SHA = $4
# DEPLOY  = $5
# PROJECT_ID  = $6
# PROJECT_LOCATION  = $7
# PROJECT_CLUSTERID = $8
# PROJECT_CLUSTER_NAME  = $9

# npx ts-node src/main.ts

# # Capture output
# output="KUBECONFIG generated"

# # Preserve output for consumption by downstream actions
# echo "$output" > "${HOME}/${GITHUB_ACTION}.log"

# # Write output to STDOUT
# echo "$output"
