#!/bin/bash

set -ex

pushd micropcf-ci/tasks/generate-micropcf-bundle-listing >/dev/null
  bundle install
  bundle exec ./generate-listing.rb
popd >/dev/null
