# Bootstrapping Minimal Hadoop Cluster with Docker

This repo contains a minimal `docker-compose` manifest and configuration files to run a single `namenode`, `datanode`, `nodemanager` and `resoucemanager`
as separate containers and execute several basic operations against the cluster, see `./examples`.

### Running locally

First, build a custom image that bundles `python3` into `hadoop:3.3.6` base image (it only has `2.7` out of the box):

```sh
docker compose pull
docker compose build
```

See `./.docker/` for details. Basically, we install `python3.12` with `uv` and also a minimal `venv` to use in submitted jobs.

Then, run as usual:

```sh
docker compose up -d
```

To stop:

```sh
docker compose down -v
```

### Examples

Shortcuts to run examples are located in the root `Makefile`, refer to it, it is pretty self-explanatory.

### Basic DFS operations

There is a minimal `Makefile` for this example, just run `make test` and `make clean` to cleanup.

### Wordcount

Hello world of `mapreduce` with `python3`: in order to run this example, you will have to `exec` into `nodemanager` container:

```sh
docker compose exec -ti bash
cd /opt/examples/wordcount
sh ./scripts/submit.sh
```

This will upload the data to `hdfs`, create necessary directories and submit a job via `hadoop streaming`.
You can view the logs for the job in `resourcemanager` at `localhost:8088/` (the exact link will be in logs).

### Needle-in-a-haystack

This is basically the same as word count, but it only counts occurencies of a specific needle word from `needle.txt`.
Steps to run are basically the same:

```sh
docker compose exec -ti bash
cd /opt/examples/needle-in-haystack
sh ./scripts/submit.sh
```

I uses multiple (3) splits, with several input files (these are dumps from `wiki` on `hadoop` and its ecosystem).
