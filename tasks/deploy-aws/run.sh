#!/bin/bash

set -ex

export AWS_SSH_PRIVATE_KEY_PATH=$PWD/key.pem
echo "$AWS_SSH_PRIVATE_KEY" > "$AWS_SSH_PRIVATE_KEY_PATH"

AWS_INSTANCE_NAME=concourse-cats vagrant up --provider=aws
export $(vagrant ssh -c "grep '^DOMAIN=' /var/micropcf/setup" 2>/dev/null | tr -d '\r')

echo $DOMAIN > domain
