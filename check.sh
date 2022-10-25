#!/bin/bash

hostname=$(hostname)
date=$(date "+%Y-%m-%d %H:%M:%S")
cpu=$(top -b -n 1 -d1|grep "Cpu(s)"|awk '{print $2}')
mem=$(free|grep Mem|awk '{print $3/$2 * 100.0}')
uptm=$(uptime)

printf "hostname: $hostname\nuptime: $uptm\ndate & time: $date\ncpu-usage: $cpu\n" > ~/report
echo "memory(%): $mem" >> ~/report

#echo 'hostname          date&time       cpu-usage       mem(%)' >> /tmp/report
#echo "$hostname         $date           $cpu            $mem " >> /tmp/report
