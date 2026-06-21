#!/bin/bash
set -e

# Configuration
CHART_NAME="ckad-web-app"
NAMESPACE="helm-test"
VALUES_FILE="values-dev.yaml"

echo "=== STEP 1: PREPARE RESOURCES ==="
# Create namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Generate a clean starter Helm chart
if [ -d "$CHART_NAME" ]; then
    echo "Directory $CHART_NAME already exists. Cleaning up older directory..."
    rm -rf "$CHART_NAME"
fi
helm create $CHART_NAME

# Create a custom values file to pass during validation
cat <<EOF > $VALUES_FILE
replicaCount: 3
image:
  repository: nginx
  tag: alpine
service:
  type: ClusterIP
  port: 80
EOF
echo "Generated custom configuration: $VALUES_FILE"


echo -e "\n=== STEP 2: VALIDATE ==="
# 1. Lint the chart syntax
echo "Running helm lint..."
helm lint $CHART_NAME

# 2. Perform a Dry-Run and Template render to ensure valid K8s manifests
echo "Running dry-run template validation..."
helm template $CHART_NAME ./$CHART_NAME --values=$VALUES_FILE --namespace=$NAMESPACE > /dev/null
echo "✓ Chart template rendered successfully with no syntax errors."

# 3. Dry-run installation against the live cluster API
echo "Simulating live installation..."
helm install $CHART_NAME ./$CHART_NAME --values=$VALUES_FILE --namespace=$NAMESPACE --dry-run
echo "✓ Live API validation passed."


echo -e "\n=== STEP 3: CLEANUP ==="
echo "Cleaning up local workspace..."
rm -f $VALUES_FILE
rm -rf $CHART_NAME
kubectl delete namespace $NAMESPACE --wait=false

echo "=== FINISHED SUCCESSFULLY ==="
