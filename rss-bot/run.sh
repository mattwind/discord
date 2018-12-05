#!/bin/bash

curr_folder="$(pwd)"
proj_folder="$(dirname "$0")"

if [ "$curr_folder" != "$proj_folder" ]; then
  cd $proj_folder
fi

source conf/config
source conf/globals

mkdir -p $logs

log "Starting"

# Create database
if [ ! -f $db_file ]; then
  log "Database not found, creating new one."
  touch $db_file
  sqlite3 $db_file < $schema
fi

# Download feeds
log "Downloading feed data"
sql=$( $libs/db_crud.sh getFeeds ) 
while IFS="|" read -r wid url
do
  $libs/parse.sh $wid <<< $(wget -qO- $url) >> $logs/$log_filename
done <<< "$sql"

# Injest logs into db
rows=`$libs/ingest.sh 2>&1`
log "Added $rows urls to the database"

# Send to discord
if [ "$discord" == "on" ]; then
  rows=`$libs/discord.sh 2>&1`
  log "Sent $rows urls to discord"
fi

# Clean up processed logs
$libs/cleanup_logs.sh

log "Ended" 

