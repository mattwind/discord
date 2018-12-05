#!/bin/bash

xmlgetnext () {
   local IFS='>'
   read -d '<' TAG VALUE
}

cat $1 | while xmlgetnext ; do
   case $TAG in
      'item')
         title=''
         link=''
         pubDate=''
#         description=''
         ;;
      'title')
         title="$VALUE"
         ;;
      'link')
         link="$VALUE"
         ;;
      'pubDate')
         # convert pubDate format for <time datetime="">
         datetime=$( date --date "$VALUE" --iso-8601=minutes )
         pubDate=$( date --date "$VALUE" '+%D %H:%M%P' )
         ;;
      'description')
         # convert '&lt;' and '&gt;' to '<' and '>'
#         description=$( echo "$VALUE" | sed -e 's/&lt;/</g' -e 's/&gt;/>/g' )
         ;;
      '/item')
         cat<<EOF
$datetime $link
EOF
         ;;
      esac
done
