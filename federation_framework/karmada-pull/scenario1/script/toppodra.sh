TimerForPodD=1
NameForPodD=kubetopPodRA.csv
PodDTime=0
update_file_podD() {
  kubectl top pod -A -l app=klusterlet-registration-agent | tr -s '[:blank:]' ',' | tee --append $NameForPodD;
  echo $(date +'%s.%N') | tee --append $NameForPodD;
}

while ((PodDTime < 54000))
do
  update_file_podD
  sleep $TimerForPodD;
  PodDTime=$PodDTime+1
done