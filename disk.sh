#!/bin/bash

# import
. ./utils/alerts.sh

args=("$@")
# Load config
source ${args[0]}

informations=""
disk_info=`df -h --output="source,pcent,ipcent"`

df -H --output="source,pcent,ipcent" | grep -vE '^Filesystem|tmpfs|cdrom|File system' | awk '{ print $2 " " $3 " " $1 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  usei=$(echo $output | awk '{ print $2}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $3 }' )
  if [ $usep -ge $disk_space_limit ]; then
    informations="space $partition ($usep%)"
  fi
  if [ $usei -ge $disk_inode_limit ]; then
    informations="inode $partition ($usei%)"
  fi
  # while variable is not propagate outside
  if [[ "$informations" != "" ]]; then
    run_command=$disk_command
    alert
  fi
done
