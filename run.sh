#!/bin/bash

while read I; do
  echo "LDF instance: $I"
  time comunica-sparql $I -f queries/1-nanopub.rq
done < ldf-instances.txt
