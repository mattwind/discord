#!/bin/bash

source conf/config $1 $2

added=0
dups=0

for item in $logs/*.new
do
	filename=$(basename -- "$item")
	extension="${filename##*.}"
	filename="${filename%.*}"
	# stuff logs into the db
	while IFS=' ' read datetime url; do
    sql=`./$libs/db_crud.sh new "$datetime" "$url" 2>&1`
    if [ "$sql" == "Error: UNIQUE constraint failed: urls.md5sum" ]; then
      dups=$((dups+1))
    else
      added=$((added+1))
    fi
	done < $item
  mv $logs/$filename.$extension $logs/$filename.processed
done

echo $added
