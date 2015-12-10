#!/bin/bash

set -ex

domain=$(cat deploy/domain)
ip=${domain%.xip.io}

echo $ip $domain >> /etc/hosts

git -C micropcf submodule update --init images/releases/cf-release
git -C micropcf/images/releases/cf-release submodule update --init src/github.com/cloudfoundry/cf-acceptance-tests

./micropcf/bin/cats $domain
