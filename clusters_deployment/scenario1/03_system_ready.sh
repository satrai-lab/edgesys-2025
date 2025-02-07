#!/bin/bash
i=0
manage=$(awk NR==1 node_list)
git clone https://github.com/satrai-lab/edgesys-2025
rm -rf /home/chuang/.ssh/known_hosts

for j in $(cat node_list)
do

scp -r ./edgesys-2025 root@$j:/root/ &
scp /home/chuang/images/nginx.tar root@$j:/root/ &
scp /home/chuang/kubectl-karmada root@$j:/usr/local/bin/kubectl-karmada &

scp /home/chuang/.ssh/id_rsa root@$j:/root/.ssh &
done
sleep 20

for j in $(cat node_list)
do
ssh -o StrictHostKeyChecking=no root@$j scp -o StrictHostKeyChecking=no /root/.kube/config root@$manage:/root/.kube/cluster$i
ssh -o StrictHostKeyChecking=no root@$j chmod 777 -R /root/edgesys-2025/
i=$((i+1))
done

scp node_list root@$manage:/root/edgesys-2025/federation_framework/ocm/node_list
scp node_list root@$manage:/root/edgesys-2025/federation_framework/karmada-pull/node_list
scp node_list root@$manage:/root/edgesys-2025/federation_framework/karmada-push/node_list
echo "management node is $manage"