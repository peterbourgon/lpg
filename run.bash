#!/usr/bin/env bash

set -e
set -u
set -o pipefail

ulimit -n 24000

trap 'echo ; wait' SIGINT

pushd $1/prometheus
./prometheus --config.file=prometheus.yml 2>&1 | sed -l -e "s/^/[P ] /" &
popd

pushd $1/grafana
./bin/grafana server --config=grafana.ini 2>&1 | sed -l -e "s/^/[ G] /" &
popd

wait
