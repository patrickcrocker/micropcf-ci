#!/bin/bash

set -ex

pushd cf-local-ci/tasks/generate-cf-local-bundle-listing >/dev/null
  bundle install
  bundle exec ./generate-listing.rb
popd >/dev/null
