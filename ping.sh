#!/bin/bash

# import
. ./utils/alerts.sh

args=("$@")
# Load config
source ${args[0]}

informations=""
sites=`cat "$ping_file"`

for i in $sites; do
  response=$(curl --write-out %{http_code} --silent --output /dev/null $i)
  if [[ "$response" != "200" ]]
    then
    informations="$informations $i response: $response"
  fi
done

alert
