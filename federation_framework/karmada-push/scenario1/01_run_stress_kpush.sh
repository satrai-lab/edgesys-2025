cp ../node_list node_list
cp ../node_list_all node_list_all
mkdir results

kubectl apply -f ./propagationpolicy.yaml --kubeconfig /etc/karmada/karmada-apiserver.config

input_file="node_list_all"
output_file="node_exec"

if [ -f "$input_file" ]; then
    last_line=$(tail -n 1 "$input_file")
    
    echo "$last_line" > "$output_file"
    echo "save to $output_file"
else
    echo "fail to open $input_file"
fi

while read -r ip; do
    # 忽略空行和注释行
    if [[ "$ip" =~ ^[[:space:]]*$ || "$ip" =~ ^\s*# ]]; then
        continue
    fi

    # 执行ping命令
    ping -c 2 "$ip" > number.txt  # 这里的-c 4表示ping 4次，您可以根据需要更改
done < "node_list"

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

read -p "please enter the test number(2000, 4000, 6000, 8000, 10000): " number

#scp root@$(cat node_exec):/root/kubeconfig.yaml /root/kubeconfig.yaml
echo $number
echo $number >> number.txt
echo "start deployment" >> number.txt
echo $(date +'%s.%N') >> number.txt
. ./script/$number.sh > /dev/null &

. ./checking_deployment_ocm.sh $number &
. ./checking_ocm.sh $number
g=1

. ./script/tophub.sh > /dev/null &

sudo tcpdump -i ens3 -nn -q '(src net 10.176.0.0/16 and dst net 10.176.0.0/16) and not arp' >> cross &

echo "wait for 18900 secs"
for (( i=900; i>0; i-- )); do
    echo "$i secs..."
    sleep 1
done

. 02.getdocker.sh $number