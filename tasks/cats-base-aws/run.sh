#!/bin/bash

set -ex

micropcf_target=$(cat deploy-vagrant-aws/domain)

curl -O "http://receptor.${micropcf_target}/v1/sync/linux/ltc"
chmod +x ltc

./ltc target "$micropcf_target"
./ltc test -v -t 10m || ./ltc test -v -t 10m
