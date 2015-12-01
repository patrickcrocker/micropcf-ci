#!/bin/bash

set -ex

pushd micropcf-ci/tasks/generate-vagrantfile-listing >/dev/null
  bundle install
  bundle exec ./generate-listing.rb
popd >/dev/null
