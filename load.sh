#!/bin/bash

# import
. ./utils/alerts.sh

args=("$@")
# Load config
source ${args[0]}

# vars
load=`cat /proc/loadavg | awk '{print $1}'`
compare=`echo | awk -v T=$load_trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`

if [[ $compare = "greater" ]]
  then
  # Get best processes ordered by cpu
  informations=`ps -Ao user,comm,pid,pcpu,pmem --sort=-pcpu | head -n 6`
  run_command=$load_command
  alert
  # kill highest process
  if [[ $kill = "true" ]]
    then
    process=`ps -Ao comm,pid --sort=-pcpu | head -n 2 | awk '{if(NR>1)print}'`
    pid=`echo $process | awk '{print $2}`
    kill -9 $pid
    # write on logs
    echo $date 'Killed '$process >> $logs_dir/loadalert.log
  fi
fi
