 #!/bin/bash
 
#top -n 1 | grep Cpu
#top -n 1 | grep Cpu | col | sed s/m[0-9]\\+\;[0-9]\\+m\\+K\\?//g
#echo
sar -n ALL 1 1 | head | grep rxpck -A 2 | grep eth0 | awk '{ print "net in: " $3/1024 "MB/s net out: " $4/1024 "MB/s" }' && echo ""
sar -d -p 1 1 | grep 秒 | grep -v md | awk '{ print $2" "$3" "$4" "$5 }' | sort | column -t -s\ 
#line=`sar -D 1 | grep -E '(sd(b|c|d|e) |partition)' | grep -v sda | wc -l`
#if [ ${line} -ne 5 ]; then
#	echo ""
#	echo ""
#	echo ""
#fi
echo ""
df -h | grep VG0 | column -t -s\ 
df -h | grep backup | column -t -s\ 
echo ""
for i in /dev/sd?; do smartctl --all ${i} | grep '^194' | awk "{print \"${i} Temp:\" \$10}"; done && echo ""
# vmstat && echo ""
#vmstat | head -n 1; vmstat | tail -n 2 | column -t -s\ 
echo ""
# pwrstat -status | grep Load | awk '{ print $2 " " $3 $4 }'
sensors 2>&1 | grep Core
echo ""
cat /proc/mdstat
