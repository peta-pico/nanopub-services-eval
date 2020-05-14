Nanopub Services Evaluation
===========================

This repo contains the files for the evaluation of the [nanopub-services](https://github.com/peta-pico/nanopub-services).

Create Docker image:

```bash
$ docker build -t nanopub/services-eval .
```

## Run evaluation

Clone the repository:

```bash
git clone https://github.com/peta-pico/nanopub-services-eval.git
cd nanopub-services-eval
```

Run the test:

```bash
docker-compose up
```

> Alternatively the `./run.sh` script can also be used

* It will run for about 30 minutes. It shouldn't need much of processor time, but it's still good to not run any other heavy processes at the same time.

* The script will first test the LDF services of the network (6 of them)  with a set of queries, and then it will test the grlc services (also 6  of them) on roughly the same set of queries.

* The container will create a directory `docker-output` (or just `output`, if you are not using Docker) and will write files in there. In the end, it will create a `.tar.gz` file with a timestamp containing results of the tests.