# RSS feeds to Discord

This is work in progress. 

## Feeds

Add the feed url to the `feeds.txt` file.

## Dependences 

Install curl and sqlite3

```
CREATE TABLE IF NOT EXISTS "urls" (
        `md5sum`        TEXT NOT NULL UNIQUE,
        `datetime`      TEXT,
        `status`        TEXT NOT NULL DEFAULT 'new',
        `url`   TEXT
);
```

## Crontab

Run command takes two parameters, TRUE or FALSE and WEBHOOK_URL

`*/5 * * * * ~/github/discord/rss-bot/run.sh FALSE WEBHOOK_URL`
