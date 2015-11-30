#!/bin/bash

set -ex

micropcf_target=`cat deploy-vagrant-aws/domain`

mkdir -p ~/.micropcf

cat > ~/.micropcf/config.json <<EOF
{
  "target": "${micropcf_target}",
  "active_blob_store": 1,
  "s3_blob_store": {
    "region": "${AWS_REGION}",
    "access_key": "${AWS_ACCESS_KEY_ID}",
    "secret_key": "${AWS_SECRET_ACCESS_KEY}",
    "bucket_name": "${S3_BUCKET_NAME}"
  }
}
EOF

curl -O "http://receptor.${micropcf_target}/v1/sync/linux/ltc"
chmod +x ltc
./ltc test -v -t 10m || ./ltc test -v -t 10m
