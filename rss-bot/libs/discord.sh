#!/bin/bash

source conf/config

# Create array of hahses that need processed
md5hashes=(`./$libs/db_crud.sh queued 2>&1`)

for hash in "${md5hashes[@]}"
do
  url=`./$libs/db_crud.sh getUrl "$hash" 2>&1`
  debug "Sending URL $url"
	# send to discord
	postDataJson="{\"username\":\"spidey-bot\",\"content\":\"$url\"}"
  curl -H "Content-Type: application/json" \
    -X POST \
	  -d ${postDataJson} "$webhook"
	# update db status
	sql=`./$libs/db_crud.sh processed "$hash" 2>&1`
	debug "Processed $hash"
done
