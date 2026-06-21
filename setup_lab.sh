#!/bin/bash
# setup_lab.sh

echo "Creating CKAD probe lab environment..."

# 1. Create Namespace
kubectl create namespace ckad-probes --dry-run=client -o yaml | kubectl apply -f -

echo "Lab environment ready! Namespace 'ckad-probes' created."
echo "You can now solve the tasks using imperative commands or YAML files."
