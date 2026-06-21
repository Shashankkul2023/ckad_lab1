#!/bin/bash
# cleanup_lab.sh

NS="ckad-probes"
echo "=== Starting CKAD Probe Lab Cleanup ==="

# 1. Delete the pods individually (optional but good for visual feedback)
if kubectl get pod probe-http-pod -n $NS &> /dev/null; then
    echo "Deleting pod probe-http-pod..."
    kubectl delete pod probe-http-pod -n $NS --grace-period=0 --force
fi

if kubectl get pod probe-exec-pod -n $NS &> /dev/null; then
    echo "Deleting pod probe-exec-pod..."
    kubectl delete pod probe-exec-pod -n $NS --grace-period=0 --force
fi

# 2. Delete the entire namespace (this automatically drops any remaining resources inside it)
if kubectl get namespace $NS &> /dev/null; then
    echo "Deleting namespace '$NS' and all remaining resources..."
    kubectl delete namespace $NS
else
    echo "Namespace '$NS' already removed or does not exist."
fi

echo "=== Cleanup Complete! ==="
