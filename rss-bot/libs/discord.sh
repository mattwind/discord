#!/bin/bash

source conf/config
source conf/globals

count=0
sql=$( $libs/db_crud.sh queued )

if [ "$sql" != "" ]; then

  while IFS="|" read -r wid md5sum url 
  do
    webhook=`./$libs/db_crud.sh getWebhook "$wid" 2>&1`
    # send to discord
    postDataJson="{\"username\":\"$botname\",\"content\":\"$url\"}"
    curl -s -H "Content-Type: application/json" -X POST -d ${postDataJson} $webhook
    # update db status
    update=`./$libs/db_crud.sh processed "$md5sum" 2>&1`
    count=$((count+1))
  done <<< $sql

fi

echo $count
