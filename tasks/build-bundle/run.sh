#!/bin/bash

set -ex

cf_local_release_version=$(git -C cf-local-release describe)
vagrant_box_version=$(cat vagrant-box-version/number)
cf_local_tgz_url=$(cat cf-local-tgz/url)

output_dir=cf-local-bundle-$cf_local_release_version
mkdir -p $output_dir/{vagrant,terraform}

box_version_filter="s/config\.vm\.box_version = \"0\"/config.vm.box_version = \"$vagrant_box_version\"/"
echo "CF_LOCAL_TGZ_URL = \"$cf_local_tgz_url\"" > $output_dir/vagrant/Vagrantfile
sed "$box_version_filter" cf-local-release/vagrant/Vagrantfile >> $output_dir/vagrant/Vagrantfile

cp -r cf-local-release/terraform/aws $output_dir/terraform/
filter='{"variable": (.variable + {"cf_local_tgz_url": {"default": "'"$cf_local_tgz_url"'"}})}'
jq "$filter" terraform-ami-metadata/ami-metadata-v* > $output_dir/terraform/aws/cf-local.tf.json

zip -r ${output_dir}.zip "$output_dir"

