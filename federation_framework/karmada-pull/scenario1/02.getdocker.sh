number=$1
j=1

for i in $(cat node_exec)
do 
	ssh root@$i . /root/exprbs/edgesys/karmada-pull/stress/script/getlog.sh
	scp root@$i:/root/logs.txt /root/exprbs/edgesys/karmada-pull/stress/results/logs.txt
	scp root@$i:/root/kubetopPodDNS.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodDNS.csv
	scp root@$i:/root/kubetopPodWA.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodWA.csv
	scp root@$i:/root/kubetopPodRA.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodRA.csv
	scp root@$i:/root/kubetopPodVC.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodVC.csv
	scp root@$i:/root/kubetopPodKL.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodKL.csv
	j=$((j+1))	
done
mv kubetopPodCM.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodCM.csv
mv kubetopPodHUB.csv /root/exprbs/edgesys/karmada-pull/stress/results/kubetopPodHUB.csv
mv cross /root/exprbs/edgesys/karmada-pull/stress/results/cross
mv number.txt /root/exprbs/edgesys/karmada-pull/stress/results/number.txt
sleep 5
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/exprbs/edgesys/karmada-pull/stress/results chuang@172.16.111.106:/home/chuang/results$number-$random_number-karmada-pull

echo "-----------------------copy ok -------------------------------"