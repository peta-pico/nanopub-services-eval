#!/usr/bin/env bash

set -e

cd output
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
tar -czvf nanopub-services-eval-output_$TIMESTAMP.tar.gz *
