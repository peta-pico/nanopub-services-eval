#!/usr/bin/env bash
#
# Run like this:
#
#     $ ./get-errors.sh data/extracted/eval-output_ghent_20200513_103600 > scratch/ghent-errors.csv
#

if [ $# -eq 1 ]; then
  echo "Type,Query,Service URL,Error"
  for Q in ldf-queries/*.rq; do
    QX=`echo $Q | sed -r 's/^ldf-queries\/(.*)\.rq$/\1/'`
    while read I; do
      IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
      E=$(cat $1/ldf-files/$IX/$QX/out.txt | egrep -i "error|failed" | head -1 | wc -l)
      echo "ldf,$QX,$I,$E" 
    done < ldf-instances.txt
  done
  while read Q; do
    QX=`echo $Q | sed -r 's/^([^ ]*):(.*)$/\2/'`
    while read I; do
      QX=`echo $Q | sed -r 's/^([^ ]*):(.*)$/\1/'`
      IX=`echo $I | sed -r 's/https?:\/\/([^\/]*)\/.*/\1/' | sed -r 's/[^0-9a-z]/-/g'`
      DIR=$1/grlc-files/$IX/$QX/
      E=$((cat $DIR/out.txt ; (head -1 $DIR/query-results.csv | sed 's/<html>/error/')) | egrep -i "error|failed" | head -1 | wc -l)
      echo "grlc,$QX,$I,$E" 
    done < grlc-instances.txt
  done < grlc-queries.txt
else
  echo "Invalid arguments: $@"
  exit 1
fi
