#!/bin/bash
#
# status, timestamp, hyperlink
#

source conf/config
source conf/globals

case $1 in
  'new')
    wid="$2"
    datetime="$3"
    url="$4"
    md5sum=`echo $url | md5sum | cut -c-32`
    sqlite3 $db_file "INSERT INTO urls (md5sum,wid,datetime,status,url) VALUES (\"$md5sum\",\"$wid\",\"$datetime\",'new',\"$url\");"
    ;;
  'processed')
    md5sum="$2"
    sqlite3 $db_file "UPDATE urls SET status='processed' WHERE md5sum=\"$md5sum\";"
    ;;
  'queued')
    sqlite3 $db_file "SELECT wid,md5sum,url FROM urls WHERE status='new';"
    ;;
  'getWebhook')
    sqlite3 $db_file "SELECT url FROM webhooks WHERE id=\"$2\";"
    ;;
  'getFeeds')
    sqlite3 $db_file "SELECT wid,url FROM feeds;"
    ;;
  *)
    echo "No match."
    ;;
esac
