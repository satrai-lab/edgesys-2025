TimerForPodDNS=1
NameForPodDNS=kubetopPodDNS.csv
PodDNSTime=0
update_file_podDNS() {
  kubectl top pod -A -l vcluster.loft.sh/namespace=kube-system | tr -s '[:blank:]' ',' | tee --append $NameForPodDNS;
  echo $(date +'%s.%N') | tee --append $NameForPodDNS;
}

while ((PodDNSTime < 54000))
do
  update_file_podDNS
  sleep $TimerForPodDNS;
  PodDNSTime=$PodDNSTime+1
done