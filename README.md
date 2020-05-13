Nanopub Services Evaluation
===========================

This repo contains the files for the evaluation of the [nanopub-services](https://github.com/peta-pico/nanopub-services).

Create Docker image:

    $ docker build -t nanopub/services-eval .

## Run evaluation

Clone the repository:

```shell
git clone https://github.com/peta-pico/nanopub-services-eval.git
```

Run the test:

```shell
docker-compose up
```

> Alternatively the `./run.sh` script can also be used