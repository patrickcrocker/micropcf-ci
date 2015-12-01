#!/bin/bash

set -ex

micropcf_version=$(git -C micropcf describe)
box_version=$(cat "$DISTRO-box-version/number")

box_filter="s/config\.vm\.box\b.*/config.vm.box = \"micropcf/$DISTRO\"/"
box_version_filter="s/config\.vm\.box_version\b.*/config.vm.box_version = \"$box_version\"/"
sed "$box_filter" micropcf/Vagrantfile | sed "$box_version_filter" > "Vagrantfile-${micropcf_version}.${DISTRO}"
