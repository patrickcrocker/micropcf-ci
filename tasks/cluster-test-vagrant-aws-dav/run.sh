#!/bin/bash

set -ex

cf_local_target=$(cat deploy-vagrant-aws/domain)

curl -O "http://receptor.${cf_local_target}/v1/sync/linux/ltc"
chmod +x ltc

./ltc target "$cf_local_target"
./ltc test -v -t 10m || ./ltc test -v -t 10m
