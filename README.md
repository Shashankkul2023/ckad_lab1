Here are two realistic CKAD-style tasks covering `livenessProbe` and `readinessProbe` with different execution strategies (HTTP checks and Exec commands).

In this repo I have created a bash script to set up the lab environment, and a verification script to test your solutions.

---

## The CKAD Scenarios

### Task 1: HTTP-Based Probes

* **Namespace:** `ckad-probes`
* **Task:** Create a pod named `probe-http-pod` using the `nginx` image.
* Configure a **Readiness Probe** that hits the path `/ready` on port `80`. It should have an initial delay of `3` seconds and check every `5` seconds.
* Configure a **Liveness Probe** that hits the path `/live` on port `80`. It should have a failure threshold of `3` and check every `10` seconds.

### Task 2: Command-Based (Exec) Probes

* **Namespace:** `ckad-probes`
* **Task:** Create a pod named `probe-exec-pod` using the `busybox` image. The container should run the command `["sh", "-c", "touch /tmp/healthy; sleep 3600"]`.
* Configure a **Liveness Probe** that executes the command `cat /tmp/healthy`. It should start checking after `5` seconds and run every `5` seconds.

---

## 1. Lab Setup Script (`setup_lab.sh`)

Run this script first to set up the environment and create the necessary namespace.

```bash
#!/bin/bash
# setup_lab.sh

echo "Creating CKAD probe lab environment..."

# 1. Create Namespace
kubectl create namespace ckad-probes --dry-run=client -o yaml | kubectl apply -f -

echo "Lab environment ready! Namespace 'ckad-probes' created."
echo "You can now solve the tasks using imperative commands or YAML files."

```

---

## 2. Expected Solutions (For Your Reference)

To complete the tasks, you would create and apply the following YAML manifests.

### Solution for Task 1 (`http-pod.yaml`)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probe-http-pod
  namespace: ckad-probes
spec:
  containers:
  - name: nginx-container
    image: nginx
    readinessProbe:
      httpGet:
        path: /ready
        port: 80
      initialDelaySeconds: 3
      periodSeconds: 5
    livenessProbe:
      httpGet:
        path: /live
        port: 80
      failureThreshold: 3
      periodSeconds: 10

```

### Solution for Task 2 (`exec-pod.yaml`)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probe-exec-pod
  namespace: ckad-probes
spec:
  containers:
  - name: busybox-container
    image: busybox
    command: ["sh", "-c", "touch /tmp/healthy; sleep 3600"]
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5

```

