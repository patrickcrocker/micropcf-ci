#!/bin/bash

set -ex

micropcf_version=$(git -C micropcf describe)
vagrant_box_version=$(cat vagrant-box-version/number)
micropcf_tgz_url=$(cat micropcf-tgz/url)

output_dir=micropcf-bundle-$micropcf_version
mkdir -p $output_dir/{vagrant,terraform}

box_version_filter="s/config\.vm\.box_version = \"0\"/config.vm.box_version = \"$vagrant_box_version\"/"
echo "MICROPCF_TGZ_URL = \"$micropcf_tgz_url\"" > $output_dir/vagrant/Vagrantfile
sed "$box_version_filter" micropcf/vagrant/Vagrantfile >> $output_dir/vagrant/Vagrantfile

cp -r micropcf/terraform/aws $output_dir/terraform/
filter='{"variable": (.variable + {"micropcf_tgz_url": {"default": "'"$micropcf_tgz_url"'"}})}'
jq "$filter" terraform-ami-metadata/ami-metadata-v* > $output_dir/terraform/aws/micropcf.tf.json

zip -r ${output_dir}.zip "$output_dir"

