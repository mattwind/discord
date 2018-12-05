#!/bin/bash

source conf/config

count=0
sql=$( $libs/db_crud.sh queued )

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

echo $count
