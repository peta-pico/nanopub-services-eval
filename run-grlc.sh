#!/usr/bin/env bash

run_query () {
  Q=$1
  QX=`echo $Q | sed -r 's/^([^ ]*):(.*)$/\2/'`
  echo "Using query $QX"
  while read I; do
    run_query_on_instance $Q $I
  done < grlc-instances.txt
}

run_query_on_instance () {
  QUERY=$1
  INSTANCE=$2
  echo "Trying grlc instance $INSTANCE"
  QX=`echo $QUERY | sed -r 's/^([^ ]*):(.*)$/\1/'`
  QUERY=`echo $QUERY | sed -r 's/^([^ ]*):(.*)$/\2/'`
  IX=`echo $INSTANCE | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
  mkdir -p output/grlc-files/$IX/$QX
  DATE=$(date +"%Y-%m-%d %T %z")
  (
    time -p timeout 60 curl -X GET "$INSTANCE$QUERY" -H "accept: text/csv" \
      > output/grlc-files/$IX/$QX/query-results.csv
  ) \
    > output/grlc-files/$IX/$QX/out.txt 2>&1
  echo -n "$DATE,$QX,$INSTANCE," >> output/grlc-results.csv
  cat output/grlc-files/$IX/$QX/out.txt | egrep "^real" | head -1 | sed "s/real //" | tr -d \\n >> output/grlc-results.csv
  echo -n "," >> output/grlc-results.csv
  cat output/grlc-files/$IX/$QX/query-results.csv | sed '1d' | wc -l >> output/grlc-results.csv
}

if [ $# -eq 0 ]; then
  rm -f output/grlc-results.csv
  rm -rf output/grlc-files
  while read Q; do
    run_query $Q
  done < grlc-queries.txt
elif [ $# -eq 1 ]; then
  run_query $@
elif [ $# -eq 2 ]; then
  run_query_on_instance $@
else
  echo "Invalid arguments: $@"
  exit 1
fi
