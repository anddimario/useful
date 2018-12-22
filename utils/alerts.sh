alert() {
  date=`date +'%F %T'`
  # Write on log
  echo $date $informations >> $logs_dir/alerts.log

  ### Optionals
  # mail
  if [[ $mail = "true" ]]
    then
    $informations | mail -s"High load on server - [ $load ]" $mail_address
  fi
  # call an url
  if [[ $curl = "true" ]]
    then
    curl -s -S -H "Content-Type: application/json" -XPOST --data $curl_data $curl_address > /dev/null
  fi
  # run command
  if [[ $run_command != "" ]]
    then
    eval $run_command
  fi
}
