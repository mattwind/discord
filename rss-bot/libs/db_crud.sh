#!/bin/bash
#
# status, timestamp, hyperlink
#

source conf/config

case $1 in
  'new')
    datetime="$2"
    url="$3"
    md5sum=`echo $url | md5sum | cut -c-32`
    sqlite3 $db_file "INSERT INTO $db (datetime,status,md5sum,url) VALUES (\"$datetime\",'new',\"$md5sum\",\"$url\");"
    ;;
  'processed')
    md5sum="$2"
    sqlite3 $db_file "UPDATE $db SET status='processed' WHERE md5sum = \"$md5sum\";"
    ;;
  'queued')
    sqlite3 $db_file "SELECT md5sum FROM $db WHERE status='new';"
    ;;
  'getUrl')
    sqlite3 $db_file "SELECT url FROM $db WHERE md5sum=\"$2\";"
    ;;
  *)
    echo "No match."
    ;;
esac
