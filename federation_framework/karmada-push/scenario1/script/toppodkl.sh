TimerForPodKL=1
NameForPodKL=kubetopPodKL.csv
PodKLTime=0
update_file_podKL() {
  kubectl top pod -A -l app=klusterlet | tr -s '[:blank:]' ',' | tee --append $NameForPodKL;
  echo $(date +'%s.%N') | tee --append $NameForPodKL;
}

while ((PodKLTime < 54000))
do
  update_file_podKL
  sleep $TimerForPodKL;
  PodKLTime=$PodKLTime+1
done