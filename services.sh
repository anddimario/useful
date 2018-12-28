#!/bin/bash

# import
. ./utils/alerts.sh

args=("$@")
# Load config
source ${args[0]}

informations=""

if [[ $upstart = "true" ]]
  then
  for i in ${upstart_services[@]}; do
    status=`service "$i" status | grep "running"`
    if [[ $status = "" ]]
      then
      informations="$informations $i not running"
    fi
  done
fi

if [[ $supervisord = "true" ]]
  then
  # get all lines without RUNNING state
  status=`supervisorctl status | grep -v "RUNNING"`
  if [[ $status = "" ]]
    then
    informations="$informations $status"
  fi
fi

if [[ $pm2 = "true" ]]
  then
  status=`pm2 ls -m | grep "errored|stopped"`
  if [[ $status = "" ]]
    then
    pm2_info=`pm2 ls -m | grep "+--\\|status"`
    informations="$informations $pm2_info"
  fi
fi

run_command=$services_command
alert
