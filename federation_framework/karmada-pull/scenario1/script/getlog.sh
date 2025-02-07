#!/bin/bash

# Provide the Pod name to search as a parameter
pod_name=vcluster-0

# List all Pods in all namespaces and find the Pod name and its namespace
all_pods=$(kubectl get pods --all-namespaces -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name')

# Loop through to find the namespace of the specified Pod
namespace=""
while IFS= read -r line; do
  pod_namespace=$(echo "$line" | awk '{print $1}')
  pod=$(echo "$line" | awk '{print $2}')
  if [ "$pod" == "$pod_name" ]; then
    namespace="$pod_namespace"
    break
  fi
done <<< "$all_pods"

# If the namespace of the Pod is found
if [ -n "$namespace" ]; then
  echo "Found Pod '$pod_name' in namespace '$namespace'. Getting logs..."
  kubectl logs "$pod_name" -n "$namespace" --all-containers=true > /root/logs.txt
else
  echo "Pod '$pod_name' not found in any namespace."
fi
