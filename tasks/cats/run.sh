#!/bin/bash

set -ex

git -C micropcf submodule update --init images/releases/cf-release
git -C micropcf/images/releases/cf-release submodule update --init src/github.com/cloudfoundry/cf-acceptance-tests

./micropcf/scripts/cats $(cat deploy/domain)
