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
  QX=`echo $Q | sed -r 's/^queries\/(.*)\.rq$/\1/'`
  IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
  mkdir -p output/files/$IX/$QX
  (
    time -p timeout 60 comunica-sparql $I -f $Q \
      > output/files/$IX/$QX/query-results.json
  ) \
    2> output/files/$IX/$QX/time.txt
  echo -n "$QX,$I," >> output/results.csv
  cat output/files/$IX/$QX/time.txt | grep "real" | sed "s/real //" | tr -d \\n >> output/results.csv
  echo -n "," >> output/results.csv
  cat output/files/$IX/$QX/query-results.json | egrep "^{" | wc -l >> output/results.csv
}

if [ $# -eq 0 ]; then
  rm -f output/results.csv
  for Q in queries/*.rq; do
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
