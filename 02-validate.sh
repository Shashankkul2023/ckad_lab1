#!/bin/bash
# Description: Validates the user's Helm deployment against criteria

NAMESPACE="ckad-helm-challenge"
RELEASE_NAME="my-web-cache"

echo "🔍 Running Validation..."

# 1. Check if the Helm release actually exists in the correct namespace
if ! helm status $RELEASE_NAME --namespace $NAMESPACE &> /dev/null; then
    echo "❌ FAILED: Helm release '$RELEASE_NAME' not found in namespace '$NAMESPACE'."
    exit 1
else
    echo "✓ PASSED: Helm release '$RELEASE_NAME' is deployed."
fi

# 2. Check if the release status is explicitly 'deployed'
STATUS=$(helm status $RELEASE_NAME --namespace $NAMESPACE -o json | grep -o '"status":"[^"]*' | grep -o '[^"]*$')
if [ "$STATUS" = "deployed" ]; then
    echo "✓ PASSED: Release status is 'deployed'."
else
    echo "❌ FAILED: Release status is '$STATUS', expected 'deployed'."
fi

# 3. Check if the application pods are successfully scaling/running
echo "Checking pod status..."
POD_COUNT=$(kubectl get pods -n $NAMESPACE --no-headers | wc -l)
RUNNING_COUNT=$(kubectl get pods -n $NAMESPACE --field-selector=status.phase=Running --no-headers | wc -l)

if [ "$RUNNING_COUNT" -gt 0 ]; then
    echo "✓ PASSED: Found $RUNNING_COUNT active pod(s) running."
else
    echo "❌ FAILED: Zero pods are currently in the 'Running' state."
fi

echo -e "\nValidation process finished! 🎉"
