number=$1
j=1

mv kubetopPodks.csv /root/exprbs/edgesys/ocm/12m/results/kubetopPodks.csv
mv cross /root/exprbs/edgesys/ocm/12m/results/cross
mv number.txt /root/exprbs/edgesys/ocm/12m/results/number.txt
sleep 5
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/exprbs/edgesys/ocm/12m/results chuang@172.16.111.106:/home/chuang/results$number-$random_number-ocm

echo "-----------------------copy ok -------------------------------"