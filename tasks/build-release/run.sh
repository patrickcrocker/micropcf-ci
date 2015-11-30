#!/bin/bash

set -ex

release_version=$(git -C micropcf describe --abbrev=0)
bundle_sha=$(git rev-parse --short "$release_version^{commit}")

echo -n "$release_version" > release-tag

aws s3 cp "s3://$S3_BUCKET_NAME/acceptance" . --recursive --exclude "*" --include "*-g${bundle_sha}.zip"

unzip micropcf-bundle-v*.zip
rm micropcf-bundle-v*.zip
mv micropcf-bundle-v* micropcf-bundle-${release_version}
zip -r micropcf-bundle-${release_version}.zip micropcf-bundle-${release_version}
