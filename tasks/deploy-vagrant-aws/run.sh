#!/bin/bash

set -ex

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

unzip forge-bundle-ci/forge-bundle-v*.zip

pushd forge-bundle-v*/vagrant >/dev/null
  AWS_INSTANCE_NAME=ci-vagrant-aws vagrant up --provider=aws
  export $(vagrant ssh -c "grep '^DOMAIN=' /var/forge/setup" 2>/dev/null | tr -d '\r')
popd >/dev/null

echo $DOMAIN > domain
