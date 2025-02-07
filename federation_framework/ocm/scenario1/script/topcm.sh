TimerForPodCM=1
NameForPodCM=kubetopPodCM.csv
PodCMTime=0
update_file_podCM() {
  kubectl top pod -A -l app=cluster-manager | tr -s '[:blank:]' ',' | tee --append $NameForPodCM;
  echo $(date +'%s.%N') | tee --append $NameForPodCM;
}

while ((PodCMTime < 54000))
do
  update_file_podCM
  sleep $TimerForPodCM;
  PodCMTime=$PodCMTime+1
done