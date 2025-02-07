number=$1

sudo rm -rf /usr/bin/kubectl

sudo curl -LO https://dl.k8s.io/release/v1.32.1/bin/linux/amd64/kubectl

sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl

curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

for i in `seq 0 $number`
do
    sed -i 's/kubernetes-admin/k8s-admin-cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/name: kubernetes/name: cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/cluster: kubernetes/cluster: cluster'$i'/g' ~/.kube/cluster$i
done

for i in `seq 0 $number`
do
    string=$string"/root/.kube/cluster$i:"
done

string=$string | sed "s/.$//g"
KUBECONFIG=$string kubectl config view --flatten > ~/.kube/config

for i in `seq 0 $number`
do
    kubectl config rename-context k8s-admin-cluster$i@kubernetes cluster$i
done

sleep 2

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

cluster=1
for i in $(cat node_list)
do
	ssh-keyscan $i >> /root/.ssh/known_hosts
  scp /usr/local/bin/kubectl-karmada root@$i:/usr/local/bin/kubectl-karmada
	scp /root/.kube/config root@$i:/root/.kube
	ssh root@$i chmod 777 /root/exprbs/edgesys/karmada-pull/worker_node.sh
	ssh root@$i sh /root/exprbs/edgesys/karmada-pull/worker_node.sh $cluster &
	cluster=$((cluster+1))
done

apt-get update
sudo apt-get install vim -y
sudo apt-get install net-tools -y
sudo apt install python3-pip -y
sudo apt-get install jq -y
sudo apt install git -y
sudo apt install ntpdate -y
sudo service ntp stop
sudo ntpdate ntp.midway.ovh
sudo service ntp start

# Install helm3
echo "Helm3"
wget -c https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz
tar xzvf helm-v3.8.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm repo add stable https://charts.helm.sh/stable
helm repo add cilium https://helm.cilium.io/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "install go"
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
cp /usr/local/go/bin/go /usr/local/bin

for i in `seq 0 0`
do
    kubectl config use-context cluster$i
	helm repo update
	helm install cilium cilium/cilium --version 1.13.4 --wait --wait-for-jobs --namespace kube-system --set operator.replicas=1
done

for i in `seq 0 0`
do
  kubectl --context=cluster$i create -f metrics_server.yaml
done
sleep 5


ip=$(cat node_list)

for i in {1..101}
do
  new_ip=$(echo $ip | sed "s/\.1$/.$i/")
  echo "$new_ip" >> node_ip
done

while IFS= read -r ip_address; do
  echo "send to $ip_address"
  scp -o StrictHostKeyChecking=no /root/nginx.tar root@$ip_address:/root/
done < "node_ip"

while IFS= read -r ip_address; do
  echo "import to $ip_address"
  ssh -o StrictHostKeyChecking=no root@$ip_address ctr -n k8s.io images import nginx.tar &
done < "node_ip"


echo "-------------------------------------- OK --------------------------------------"