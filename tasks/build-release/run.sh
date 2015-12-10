#!/bin/bash

set -ex

echo "$GITHUB_SSH_KEY" > github_private_key.pem
chmod 0600 github_private_key.pem
eval $(ssh-agent)
ssh-add github_private_key.pem > /dev/null
git -C micropcf fetch --tags

release_version=$(git -C micropcf describe --abbrev=0)
vagrantfile_sha=$(git -C micropcf rev-parse --short "$release_version^{commit}")

echo -n "$release_version" > release-tag

aws s3 cp "s3://$S3_BUCKET_NAME/ci" . --recursive --exclude "*" --include "*-g${vagrantfile_sha}.*"

mv Vagrantfile-v*.base Vagrantfile-${release_version}.base
