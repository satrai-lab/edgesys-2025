#!/bin/bash
i=0
manage=$(awk NR==1 node_list)
git clone https://github.com/CKHuangGH/exprbs.git
rm -rf /home/chuang/.ssh/known_hosts

for j in $(cat node_list)
do
scp -r ./exprbs root@$j:/root/ &
scp /home/chuang/images/nginx.tar root@$j:/root/ &
scp /home/chuang/kubectl-karmada root@$j:/usr/local/bin/kubectl-karmada &
scp /home/chuang/.ssh/id_rsa root@$j:/root/.ssh &
done
sleep 200

for j in $(cat node_list)
do
ssh -o StrictHostKeyChecking=no root@$j scp -o StrictHostKeyChecking=no /root/.kube/config root@$manage:/root/.kube/cluster$i
ssh -o StrictHostKeyChecking=no root@$j chmod 777 -R /root/exprbs/
i=$((i+1))
done


ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 chmod 777 -R /root/exprbs/
scp node_list root@$manage:/root/exprbs/edgesys/ocm/node_list
scp node_list root@$manage:/root/exprbs/edgesys/karmada-pull/node_list
scp node_list root@$manage:/root/exprbs/edgesys/karmada-push/node_list
echo "management node is $manage"