#!/bin/bash

set -ex

release_version=$(git -C forge describe --abbrev=0)
bundle_sha=$(git rev-parse --short "$release_version^{commit}")

echo -n "$release_version" > release-tag

aws s3 cp "s3://$S3_BUCKET_NAME/acceptance" . --recursive --exclude "*" --include "*-g${bundle_sha}.zip"

unzip forge-bundle-v*.zip
rm forge-bundle-v*.zip
mv forge-bundle-v* forge-bundle-${release_version}
zip -r forge-bundle-${release_version}.zip forge-bundle-${release_version}
