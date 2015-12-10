#!/bin/bash

set -e

echo "$REMOTE_EXECUTOR_PRIVATE_KEY" > remote_executor.pem
chmod 0600 remote_executor.pem

set -x

ssh-keyscan $REMOTE_EXECUTOR_ADDRESS >> $HOME/.ssh/known_hosts
remote_path=$(ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS mktemp -td build-dev-image.XXXXXXXX)

function cleanup { ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS rm -rf "$remote_path"; }
trap cleanup EXIT

rsync -a -e "ssh -i remote_executor.pem" image-changes vcap@$REMOTE_EXECUTOR_ADDRESS:$remote_path/
rm -rf image-changes || true

ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS <<EOF
  cd "$remote_path"
  "image-changes/images/$DISTRO/build" -only=vmware-iso -var 'dev=true'
EOF

rsync -e "ssh -i remote_executor.pem" vcap@$REMOTE_EXECUTOR_ADDRESS:$remote_path/image-changes/images/$DISTRO/output/micropcf-$DISTRO-vmware-v0.box $DISTRO.box
