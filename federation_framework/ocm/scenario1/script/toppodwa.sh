TimerForPodwa=1
NameForPodwa=kubetopPodWA.csv
PodwaTime=0
update_file_podwa() {
  kubectl top pod -n open-cluster-management-agent | tr -s '[:blank:]' ',' | tee --append $NameForPodwa;
  echo $(date +'%s.%N') | tee --append $NameForPodwa;
}

while ((PodwaTime < 54000))
do
  update_file_podwa
  sleep $TimerForPodwa;
  PodwaTime=$PodwaTime+1
done