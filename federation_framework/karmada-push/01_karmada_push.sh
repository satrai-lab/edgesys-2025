#!/bin/bash

kubectl config use-context cluster0

for i in $(cat node_list)
do
    ssh root@$i kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
done

kubectl karmada init
sleep 10

cluster=1
for i in $(cat node_list)
do
    kubectl karmada --kubeconfig /etc/karmada/karmada-apiserver.config  join cluster$cluster --cluster-kubeconfig=$HOME/.kube/cluster$cluster
	cluster=$((cluster+1))
done