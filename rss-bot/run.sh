#!/bin/bash

curr_folder="$(pwd)"
proj_folder="$(dirname "$0")"

if [ "$curr_folder" != "$proj_folder" ]; then
  cd $proj_folder
fi

source conf/config

mkdir -p $logs

log "$rightnow - Bot Started"
debug "Debug $debug"
debug "Webhook set to $2"

# Create database
if [ ! -f $db_file ]; then
  debug "Database not found, creating new one."
  touch $db_file
  sqlite3 $db_file < $schema
fi

# Download feeds
while IFS=" " read -r name url
do
  debug "Downloading data for $name"
  $libs/parse.sh <<< $(wget -qO- $url) >> $logs/$log_filename
done < $feeds

# Injest logs into db
$libs/ingest.sh
# Send to discord
$libs/discord.sh
# Clean up processed logs
$libs/cleanup_logs.sh

debug "Finished."
log "$rightnow - Bot Ended" 

