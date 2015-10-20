#!/bin/bash

set -ex

cd build-vagrant-prepare

! [[ -f should_build ]] && exit 0

current_version=$(cat current-vagrant-box-version/number)
next_version=$(cat next-vagrant-box-version/number)

if [[ $REMOTE_EXECUTOR_IP == "no-executor" ]]; then
  vagrant-image-changes/vagrant/build -var "version=$next_version" -only=$NAMES

  rm -f vagrant-image-changes/vagrant/*.box
  rm -rf vagrant-image-changes/vagrant/packer_cache

  exit 0
fi

remote_tmp="/tmp/build-vagrant-images-$(date "+%Y-%m-%d-%H%M%S")"
ssh-keyscan -p 22222 $REMOTE_EXECUTOR_IP >> $HOME/.ssh/known_hosts
ssh -i aws_private_key.pem pivotal@$REMOTE_EXECUTOR_IP -p 22222 mkdir -p $remote_tmp

rsync -a -e "ssh -p 22222 -i aws_private_key.pem" * pivotal@$REMOTE_EXECUTOR_IP:$remote_tmp

ssh -i aws_private_key.pem pivotal@$REMOTE_EXECUTOR_IP -p 22222 <<ENDSSH
export PATH=~/.rbenv/shims:/usr/local/go/bin:~/packer:/usr/local/bin:\$PATH
cd $remote_tmp
rbenv local 2.2.3
vagrant-image-changes/vagrant/build -var "version=$next_version" -only=$NAMES
ENDSSH

ssh -i aws_private_key.pem pivotal@$REMOTE_EXECUTOR_IP -p 22222 rm -rf $remote_tmp
