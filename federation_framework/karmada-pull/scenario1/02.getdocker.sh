number=$1
j=1

for i in $(cat node_exec)
do 
	ssh root@$i . /root/edgesys-2025/federation_framework/karmada-pull/scenario1/script/getlog.sh
	scp root@$i:/root/logs.txt /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/logs.txt
	scp root@$i:/root/kubetopPodDNS.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodDNS.csv
	scp root@$i:/root/kubetopPodWA.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodWA.csv
	scp root@$i:/root/kubetopPodRA.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodRA.csv
	scp root@$i:/root/kubetopPodVC.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodVC.csv
	scp root@$i:/root/kubetopPodKL.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodKL.csv
	j=$((j+1))	
done
mv kubetopPodCM.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodCM.csv
mv kubetopPodHUB.csv /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/kubetopPodHUB.csv
mv cross /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/cross
mv number.txt /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results/number.txt
sleep 5
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/edgesys-2025/federation_framework/karmada-pull/scenario1/results chuang@172.16.111.106:/home/chuang/results$number-$random_number-karmada-pull

echo "-----------------------copy ok -------------------------------"