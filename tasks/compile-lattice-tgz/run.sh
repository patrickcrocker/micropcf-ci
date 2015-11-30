#!/bin/bash

set -ex

micropcf_tgz_version=$(cat micropcf-tgz-version/number)
./micropcf/release/build "micropcf-v${micropcf_tgz_version}.tgz" "$micropcf_tgz_version"
