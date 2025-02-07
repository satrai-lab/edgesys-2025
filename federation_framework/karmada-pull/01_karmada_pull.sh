#!/bin/bash

kubectl config use-context cluster0

kubectl karmada init

REGISTER_CMD=$(kubectl karmada token create --print-register-command --kubeconfig=/etc/karmada/karmada-apiserver.config)


for i in $(cat node_list)
do
    ssh root@$i kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
done

for i in $(cat node_list)
do
    ssh root@$i eval "$REGISTER_CMD"
done