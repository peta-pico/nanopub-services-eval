Nanopub Services Evaluation
===========================

This repo contains the files for the evaluation of the [nanopub-services](https://github.com/peta-pico/nanopub-services).

Create Docker image:

    $ docker build -t nanopub/comunica-eval .


## grlc calls

    $ curl -X GET "http://grlc.nanopubs.lod.labs.vu.nl/api/local/local/get_all_users" -H  "accept: text/csv"
