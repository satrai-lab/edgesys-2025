for j in $(cat node_list)
do
ssh -o StrictHostKeyChecking=no root@$j kubectl get node
done
cat -n node_list