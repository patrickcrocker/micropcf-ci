#!/bin/bash

set -ex

cf_local_tgz_version=$(cat cf-local-tgz-version/number)
./cf-local-release/release/build "cf-local-v${cf_local_tgz_version}.tgz" "$cf_local_tgz_version"
