#!/bin/bash

set -ex

forge_tgz_version=$(cat forge-tgz-version/number)
./forge/release/build "forge-v${forge_tgz_version}.tgz" "$forge_tgz_version"
