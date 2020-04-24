#!/usr/bin/env bash

set -e

run_query () {
  Q=$1
  echo "Using query $Q"
  while read I; do
    run_query_on_instance $Q $I
  done < grlc-instances.txt
}

run_query_on_instance () {
  Q=$1
  I=$2
  echo "Trying LDF instance $I"
  QX=`echo $Q | sed -r 's/^([^ ]*):(.*)$/\1/'`
  Q=`echo $Q | sed -r 's/^([^ ]*):(.*)$/\2/'`
  IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
  echo "$I $Q $IX $QX"
  mkdir -p output/grlc-files/$IX/$QX
  DATE=$(date +"%Y-%m-%d %T %z")
  (
    time -p curl -X GET "$I$Q" -H "accept: text/csv" \
      > output/grlc-files/$IX/$QX/query-results.csv
  ) \
    > output/grlc-files/$IX/$QX/out.txt 2>&1
  echo -n "$DATE,$QX,$I," >> output/grlc-results.csv
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
