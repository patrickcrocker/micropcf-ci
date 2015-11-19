#!/bin/bash

set -ex

release_version=$(git -C cf-local-release describe --abbrev=0)
bundle_sha=$(git rev-parse --short "$release_version^{commit}")

echo -n "$release_version" > release-tag

aws s3 cp "s3://$S3_BUCKET_NAME/acceptance" . --recursive --exclude "*" --include "*-g${bundle_sha}.zip"

unzip cf-local-bundle-v*.zip
rm cf-local-bundle-v*.zip
mv cf-local-bundle-v* cf-local-bundle-${release_version}
zip -r cf-local-bundle-${release_version}.zip cf-local-bundle-${release_version}
