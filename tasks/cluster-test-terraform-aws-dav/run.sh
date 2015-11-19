#!/bin/bash

set -ex

dot_cf_local_dir=$HOME/.cf-local
terraform_tmp_dir=$PWD/deploy-terraform-aws/cf-local-bundle-v*/terraform/aws

mkdir -p $dot_cf_local_dir

pushd $terraform_tmp_dir >/dev/null
    target=$(terraform output target)
    username=$(terraform output username)
    password=$(terraform output password)
    cat > $dot_cf_local_dir/config.json <<EOF
{
    "target": "${target}",
    "username": "${username}",
    "password": "${password}",
    "active_blob_store": 0,
    "dav_blob_store": {
        "host": "${target}",
        "port": "8444",
        "username": "${username}",
        "password": "${password}"
    }
}
EOF
popd >/dev/null

curl -O "http://receptor.${target}/v1/sync/linux/ltc"
chmod +x ltc

./ltc test -v -t 10m || ./ltc test -v -t 10m
