read -p "please enter the number of cluster: " number
for i in $(seq 1 $number)
do
  ns="cluster$i"
  kubectl get ns $ns &>/dev/null
  if [ $? -ne 0 ]; then
    echo "缺少命名空间: $ns"
	cluster=$(awk "NR==$i" node_list)
  awk "NR==$i" node_list
	ssh root@$cluster helm uninstall cilium -n kube-system
	ssh root@$cluster helm install cilium cilium/cilium --version 1.13.4 --wait --wait-for-jobs --namespace kube-system --set operator.replicas=1
	ssh root@$cluster 'bash -s' < "run$i.sh"
  sleep 5
  clusteradm accept --clusters cluster$i

  fi
done
sleep 10
kubectl get ns --no-headers | wc -l