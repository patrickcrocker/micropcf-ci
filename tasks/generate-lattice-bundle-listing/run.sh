#!/bin/bash

set -ex

pushd forge-ci/tasks/generate-forge-bundle-listing >/dev/null
  bundle install
  bundle exec ./generate-listing.rb
popd >/dev/null
