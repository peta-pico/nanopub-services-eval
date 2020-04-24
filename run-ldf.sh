#!/bin/bash

run_query () {
  Q=$1
  echo "Using query $Q"
  while read I; do
    run_query_on_instance $Q $I
  done < ldf-instances.txt
}

run_query_on_instance () {
  Q=$1
  I=$2
  echo "Trying LDF instance $I"
  QX=`echo $Q | sed -r 's/^ldf-queries\/(.*)\.rq$/\1/'`
  IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
  mkdir -p output/ldf-files/$IX/$QX
  DATE=$(date +"%Y-%m-%d %T %z")
  (
    time -p timeout 60 comunica-sparql $I -f $Q \
      > output/ldf-files/$IX/$QX/query-results.json
  ) \
    > output/ldf-files/$IX/$QX/out.txt 2>&1
  echo -n "$DATE,$QX,$I," >> output/ldf-results.csv
  cat output/ldf-files/$IX/$QX/out.txt | grep "real" | head -1 | sed "s/real //" | tr -d \\n >> output/ldf-results.csv
  echo -n "," >> output/ldf-results.csv
  cat output/ldf-files/$IX/$QX/query-results.json | egrep "^{" | wc -l >> output/ldf-results.csv
}

if [ $# -eq 0 ]; then
  rm -f output/ldf-results.csv
  rm -rf output/ldf-files
  for Q in ldf-queries/*.rq; do
    run_query $Q
  done
elif [ $# -eq 1 ]; then
  run_query $@
elif [ $# -eq 2 ]; then
  run_query_on_instance $@
else
  echo "Invalid arguments: $@"
  exit 1
fi
