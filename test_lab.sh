#!/bin/bash
# test_lab.sh

NS="ckad-probes"
echo "=== Starting CKAD Probe Verification ==="

# Helper function to check fields
check_field() {
    local val=$1
    local expected=$2
    local msg=$3
    if [ "$val" == "$expected" ]; then
        echo "  [PASS] $msg"
    else
        echo "  [FAIL] $msg (Expected: '$expected', Got: '$val')"
    fi
}

echo ""
echo "--- Testing Task 1: probe-http-pod ---"
if ! kubectl get pod probe-http-pod -n $NS &> /dev/null; then
    echo "  [FAIL] Pod probe-http-pod does not exist in namespace $NS"
else
    # Fetch HTTP probe values
    READI_PATH=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}')
    READI_PORT=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.port}')
    READI_DELAY=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].readinessProbe.initialDelaySeconds}')
    READI_PER=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].readinessProbe.periodSeconds}')
    
    LIVE_PATH=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.path}')
    LIVE_PORT=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}')
    LIVE_FAIL=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.failureThreshold}')
    LIVE_PER=$(kubectl get pod probe-http-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}')

    check_field "$READI_PATH" "/ready" "Readiness path is /ready"
    check_field "$READI_PORT" "80" "Readiness port is 80"
    check_field "$READI_DELAY" "3" "Readiness initialDelaySeconds is 3"
    check_field "$READI_PER" "5" "Readiness periodSeconds is 5"
    
    check_field "$LIVE_PATH" "/live" "Liveness path is /live"
    check_field "$LIVE_PORT" "80" "Liveness port is 80"
    check_field "$LIVE_FAIL" "3" "Liveness failureThreshold is 3"
    check_field "$LIVE_PER" "10" "Liveness periodSeconds is 10"
fi

echo ""
echo "--- Testing Task 2: probe-exec-pod ---"
if ! kubectl get pod probe-exec-pod -n $NS &> /dev/null; then
    echo "  [FAIL] Pod probe-exec-pod does not exist in namespace $NS"
else
    # Fetch Exec probe values
    EXEC_CMD=$(kubectl get pod probe-exec-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.exec.command[*]}')
    EXEC_DELAY=$(kubectl get pod probe-exec-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}')
    EXEC_PER=$(kubectl get pod probe-exec-pod -n $NS -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}')

    check_field "$EXEC_CMD" "cat /tmp/healthy" "Liveness exec command is 'cat /tmp/healthy'"
    check_field "$EXEC_DELAY" "5" "Liveness initialDelaySeconds is 5"
    check_field "$EXEC_PER" "5" "Liveness periodSeconds is 5"
fi

echo ""
echo "=== Verification Complete ==="
