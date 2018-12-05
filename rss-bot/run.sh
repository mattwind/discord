#!/bin/bash

curr_folder="$(pwd)"
proj_folder="$(dirname "$0")"

if [ "$curr_folder" != "$proj_folder" ]; then
  cd $proj_folder
fi

source conf/config

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
while IFS=" " read -r name url
do
  $libs/parse.sh <<< $(wget -qO- $url) >> $logs/$log_filename
done < $feeds

# Injest logs into db
rows=`$libs/ingest.sh $debug $webhook 2>&1`
log "Added $rows urls to the database"

# Send to discord
rows=`$libs/discord.sh $debug $webhook 2>&1`
log "Sent $rows urls to discord"

# Clean up processed logs
$libs/cleanup_logs.sh

log "Ended" 

