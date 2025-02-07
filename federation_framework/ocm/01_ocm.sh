#!/bin/bash

kubectl config use-context cluster0

clusteradm init --wait --context cluster0 > temp.sh
sleep 30
grep "clusteradm join" temp.sh > run.sh

for i in $(cat node_list)
do
    ssh root@$i kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
done
sleep 10
./auto.sh