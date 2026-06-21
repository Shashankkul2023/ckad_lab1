#!/bin/bash
# Description: Cleans up all resources created during the task

NAMESPACE="ckad-helm-challenge"
RELEASE_NAME="my-web-cache"

echo "🧹 Running Cleanup..."

# 1. Uninstall the Helm release if it exists
if helm status $RELEASE_NAME --namespace $NAMESPACE &> /dev/null; then
    echo "Uninstalling Helm release..."
    helm uninstall $RELEASE_NAME --namespace $NAMESPACE
fi

# 2. Delete the dedicated namespace
if kubectl get namespace $NAMESPACE &> /dev/null; then
    echo "Deleting namespace '$NAMESPACE'..."
    kubectl delete namespace $NAMESPACE --wait=false
fi

# 3. Remove local practice files
if [ -f "custom-values.yaml" ]; then
    rm -f custom-values.yaml
    echo "✓ Removed local 'custom-values.yaml' file."
fi

echo -e "\nCleanup finished! ✨ The cluster workspace is clean."
