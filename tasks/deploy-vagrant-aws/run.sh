#!/bin/bash

set -ex

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

unzip cf-local-bundle-ci/cf-local-bundle-v*.zip

pushd cf-local-bundle-v*/vagrant >/dev/null
  AWS_INSTANCE_NAME=ci-vagrant-aws vagrant up --provider=aws
  export $(vagrant ssh -c "grep '^DOMAIN=' /var/cf-local/setup" 2>/dev/null | tr -d '\r')
popd >/dev/null

echo $DOMAIN > domain
