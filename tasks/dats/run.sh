#!/bin/bash

set -e

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

set -x

domain=$(cat deploy/domain)
ip=${domain%.xip.io}

echo $ip $domain >> /etc/hosts

git -C micropcf submodule update --init images/releases/diego-release
git -C micropcf/images/releases/diego-release submodule update --init --recursive

private_ip=$(cd deploy && vagrant ssh -c "ip route get 1 | awk '{print \$NF;exit}'" 2>/dev/null | tr -d '\r')

./micropcf/bin/dats $domain $private_ip
