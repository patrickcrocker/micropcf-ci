#!/bin/bash

set -ex

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

git -C micropcf submodule update --init images/releases/diego-release
git -C micropcf/images/releases/diego-release submodule update --init src/github.com/cloudfoundry-incubator/diego-acceptance-tests

private_ip=$(cd deploy && vagrant ssh -c "ip route get 1 | awk '{print \$NF;exit}'" 2>/dev/null | tr -d '\r')

./micropcf/bin/dats "$(cat deploy/domain)" "$private_ip"
