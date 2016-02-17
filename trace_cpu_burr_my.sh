#!/bin/bash

trace_times=${1:-6000}
max_cpu_point=${2:-70}
rm "/tmp/$(basename $0).*.log" &>/dev/null
log_file="/data/$(basename $0).$$.log"

#
#kill myself if disk usage exceed  80%
#
kill_myself()
{
	disk_full=$(df -h | awk '($NF ~ /\/$/ && gensub("%","","G",$5) > 80)' | wc -l)
	if [ ${disk_full} -gt 0 ];then
		kill -9 $$
	fi	
}

#
#capture single proc that use cpu exceed 70%
#
idx=0
while [ $idx -lt ${trace_times} ];do
	cmd_output="$(top -n1 -b | awk -v max_cpu_point=${max_cpu_point} '($0~/^[0-9]/ && int($9) > max_cpu_point){print $0; system(sprintf("ps auxf | grep -A3 -B3 %s", $1))}')"
	[ -z "${cmd_output}" ] || (echo "${cmd_output}" | tee ${log_file})
	sleep 1
	[ $((idx%1000)) -eq 0 ] && kill_myself
	idx=$((idx+1))
done
echo "logfile is ${log_file}"
