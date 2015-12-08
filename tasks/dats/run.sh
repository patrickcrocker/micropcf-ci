#!/bin/bash

set -ex

git -C micropcf submodule update --init images/releases/diego-release
git -C micropcf/images/releases/diego-release submodule update --init src/github.com/cloudfoundry-incubator/diego-acceptance-tests

private_ip=$(vagrant ssh -c "ip route get 1 | awk '{print \$NF;exit}'" 2>/dev/null | tr -d '\r')

./micropcf/scripts/dats "$(cat deploy/domain)" "$private_ip"
