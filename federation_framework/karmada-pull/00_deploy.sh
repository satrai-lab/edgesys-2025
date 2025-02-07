cp node_list node_list_all
sed -i '1d' node_list
cp node_list ./mcluster_example/node_list
ls /root/.kube/
ls -1 /root/.kube/ | wc -l
read -p "please enter the last cluster number in .kube: " number

./patch.sh

./combineAll.sh $number