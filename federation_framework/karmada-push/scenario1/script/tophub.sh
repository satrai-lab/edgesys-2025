TimerForPodHUB=1
NameForPodHUB=kubetopPodHUB.csv
PodHUBTime=0
update_file_podHUB() {
  kubectl top pod -A | tr -s '[:blank:]' ',' | tee --append $NameForPodHUB;
  echo $(date +'%s.%N') | tee --append $NameForPodHUB;
}

while ((PodHUBTime < 54000))
do
  update_file_podHUB
  sleep $TimerForPodHUB;
  PodHUBTime=$PodHUBTime+1
done