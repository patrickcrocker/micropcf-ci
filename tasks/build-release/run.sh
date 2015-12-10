#!/bin/bash

set -ex

git -C micropcf fetch --tags
release_version=$(git -C micropcf describe --abbrev=0)
vagrantfile_sha=$(git -C micropcf rev-parse --short "$release_version^{commit}")

echo -n "$release_version" > release-tag

aws s3 cp "s3://$S3_BUCKET_NAME/acceptance" . --recursive --exclude "*" --include "*-g${vagrantfile_sha}.*"

mv Vagrantfile-v*.base Vagrantfile-${release_version}.base
