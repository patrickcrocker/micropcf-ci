#!/bin/bash

set -e

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

set -x

pushd deploy >/dev/null
  vagrant destroy -f
popd >/dev/null
