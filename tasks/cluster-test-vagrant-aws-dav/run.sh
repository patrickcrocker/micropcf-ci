#!/bin/bash

set -ex

forge_target=$(cat deploy-vagrant-aws/domain)

curl -O "http://receptor.${forge_target}/v1/sync/linux/ltc"
chmod +x ltc

./ltc target "$forge_target"
./ltc test -v -t 10m || ./ltc test -v -t 10m
