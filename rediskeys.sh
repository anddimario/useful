#!/bin/bash

# import
. ./utils/alerts.sh

args=("$@")
# Load config
source ${args[0]}
redis_options=""

if [[ $redis_password != "" ]]
  then
  redis_options="$redis_options -a $redis_password"
fi
if [[ $redis_host != "" ]]
  then
  redis_options="$redis_options -h $redis_host"
fi

memory_usage=`redis-cli $redis_options INFO MEMORY | grep "used_memory:" | cut -d ':' -f 2`
compare=`echo | awk -v T=$redis_trigger -v L=$memory_usage 'BEGIN{if ( L > T){ print "greater"}}'`

if [[ $compare = "greater" ]]
  then
  informations=""
  for i in "${redis_patterns[@]}"
    do
    count=`redis-cli $redis_options --scan --pattern "$i" | wc -l`
    informations="$informations \"$i\" $count"
  done
  run_command=$redis_command
  alert
fi
