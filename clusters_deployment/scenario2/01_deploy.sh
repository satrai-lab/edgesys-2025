python3 ./cluster/management.py
sleep 60
python3 ./cluster/m1.py &
python3 ./cluster/m2.py &
python3 ./cluster/m3.py &
python3 ./cluster/m4.py &
python3 ./cluster/m5.py &
python3 ./cluster/m6.py &
python3 ./cluster/m7.py &
python3 ./cluster/m8.py &
python3 ./cluster/m9.py &
python3 ./cluster/m10.py &
python3 ./cluster/m11.py &
python3 ./cluster/m12.py &
python3 ./cluster/m13.py &
python3 ./cluster/m14.py &
python3 ./cluster/m15.py &
python3 ./cluster/m16.py &
python3 ./cluster/m17.py &
python3 ./cluster/m18.py &
python3 ./cluster/m19.py &
python3 ./cluster/m20.py 

chmod 777 02_check.sh
chmod 777 03_system_ready.sh
chmod 777 04_del.sh

echo "wait for 600 secs"
for (( i=600; i>0; i-- )); do
    echo "$i secs..."
    sleep 1
done

. ./03_system_ready.sh