#!/bin/bash

source conf/config $1 $2

# Create array of hahses that need processed
md5hashes=(`./$libs/db_crud.sh queued 2>&1`)
count=0

for hash in "${md5hashes[@]}"
do
  url=`./$libs/db_crud.sh getUrl "$hash" 2>&1`
	# send to discord
	postDataJson="{\"username\":\"$botname\",\"content\":\"$url\"}"
  curl -s -H "Content-Type: application/json" -X POST -d ${postDataJson} $webhook
	# update db status
	sql=`./$libs/db_crud.sh processed "$hash" 2>&1`
  count=$((count+1))
done

echo $count
