#!/bin/bash

rm -f output/results.csv

for Q in queries/*.rq; do
  echo "Using query $Q"
  QX=`echo $Q | sed -r 's/^queries\/(.*)\.rq$/\1/'`
  while read I; do
    echo "Trying LDF instance $I"
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
  done < ldf-instances.txt
done
