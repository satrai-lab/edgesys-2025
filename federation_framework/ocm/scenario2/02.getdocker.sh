number=$1
j=1

mv kubetopPodks.csv /root/edgesys-2025/federation_framework/ocm/scenario2/results/kubetopPodks.csv
mv cross /root/edgesys-2025/federation_framework/ocm/scenario2/results/cross
mv number.txt /root/edgesys-2025/federation_framework/ocm/scenario2/results/number.txt
sleep 5
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/edgesys-2025/federation_framework/ocm/scenario2/results chuang@172.16.111.106:/home/chuang/results$number-$random_number-ocm

echo "-----------------------copy ok -------------------------------"