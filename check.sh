#!bin/bash

hostname=$(hostname)
date=$(date "+%Y-+%m-+%d %H:%M:%S")
cpu=$(top -b -n 1 -d1|grep "Cpu(s)"|awk '{print $2}'|awk -F. 'print $1')
mem=$(free|grep Mem|awk '{print $3/$2 * 100.0}')

echo 'hostname          date&time       cpu-usage       mem(%)' >> /tmp/report
echo "$hostname         $date           $cpu            $mem " >> /tmp/report
