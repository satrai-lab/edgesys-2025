TimerForPodks=1
NameForPodks=kubetopPodks.csv
PodksTime=0
update_file_podks() {
  kubectl top pod -A | tr -s '[:blank:]' ',' | tee --append $NameForPodks;
  echo $(date +'%s.%N') | tee --append $NameForPodks;
}

while ((PodksTime < 54000))
do
  update_file_podks
  sleep $TimerForPodks;
  PodksTime=$PodksTime+1
done