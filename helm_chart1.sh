#!/bin/bash
# Description: Prepares the environment for the Helm task

NAMESPACE="ckad-helm-challenge"
CHART_REPO="bitnami"
CHART_URL="https://charts.bitnami.com/bitnami"

echo "⚙️  Running Setup..."

# 1. Create a clean workspace namespace
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
echo "✓ Namespace '$NAMESPACE' created."

# 2. Add and update the required Helm repository
helm repo add $CHART_REPO $CHART_URL
helm repo update
echo "✓ Helm repository '$CHART_REPO' added and updated."

# 3. Generate a starter values file for the user to work with
cat <<EOF > custom-values.yaml
# CKAD TASK: Modify this file to set replicaCount to 2 
# and disable internal persistence/auth if required.
replicaCount: 1
auth:
  enabled: true
EOF

echo "✓ Created starter file: 'custom-values.yaml'"
echo -e "\nSetup complete! 🚀 Now perform your Helm install task using this values file."
