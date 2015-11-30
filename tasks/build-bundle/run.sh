#!/bin/bash

set -ex

forge_version=$(git -C forge describe)
vagrant_box_version=$(cat vagrant-box-version/number)
forge_tgz_url=$(cat forge-tgz/url)

output_dir=forge-bundle-$forge_version
mkdir -p $output_dir/{vagrant,terraform}

box_version_filter="s/config\.vm\.box_version = \"0\"/config.vm.box_version = \"$vagrant_box_version\"/"
echo "FORGE_TGZ_URL = \"$forge_tgz_url\"" > $output_dir/vagrant/Vagrantfile
sed "$box_version_filter" forge/vagrant/Vagrantfile >> $output_dir/vagrant/Vagrantfile

cp -r forge/terraform/aws $output_dir/terraform/
filter='{"variable": (.variable + {"forge_tgz_url": {"default": "'"$forge_tgz_url"'"}})}'
jq "$filter" terraform-ami-metadata/ami-metadata-v* > $output_dir/terraform/aws/forge.tf.json

zip -r ${output_dir}.zip "$output_dir"

