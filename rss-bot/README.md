# RSS feeds to Discord

This is work in progress. 

## Dependences 

Install curl and sqlite3

## Config

Copy and edit sample config to `conf/config`


## First Run

Run bot with discord off, this will sync the db before flooding discord. After that period all new urls will be posted.

## Crontab

Add this crontab entry to the run script on a schedule.

`*/5 * * * * ~/github/discord/rss-bot/run.sh`
