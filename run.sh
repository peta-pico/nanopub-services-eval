#!/bin/bash

rm -f results.csv

for Q in queries/*.rq; do
  echo "Using query $Q"
  QX=`echo $Q | sed -r 's/^queries\/(.*)\.rq$/\1/'`
  while read I; do
    echo "Trying LDF instance $I"
    IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
    mkdir -p output/$IX/$QX
    (
      time -p comunica-sparql $I -f $Q \
        > output/$IX/$QX/query-results.json
    ) \
      2> output/$IX/$QX/time.txt
    echo -n "$QX,$I," >> results.csv
    cat output/$IX/$QX/time.txt | grep "real" | sed "s/real //" | tr -d \\n >> results.csv
    echo -n "," >> results.csv
    cat output/$IX/$QX/query-results.json | egrep "^{" | wc -l >> results.csv
  done < ldf-instances.txt
done
