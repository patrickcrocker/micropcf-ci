#!/bin/bash

set -e

unzip cf-local-bundle-ci/cf-local-bundle-v*.zip
terraform_dir=$(echo $PWD/cf-local-bundle-v*/terraform/aws)

echo "$AWS_SSH_PRIVATE_KEY" > $terraform_dir/key.pem

cat > $terraform_dir/terraform.tfvars <<EOF
username = "user"
password = "pass"

aws_access_key_id = "$AWS_ACCESS_KEY_ID"
aws_secret_access_key = "$AWS_SECRET_ACCESS_KEY"
aws_ssh_private_key_name = "$AWS_SSH_PRIVATE_KEY_NAME"
aws_ssh_private_key_path = "${terraform_dir}/key.pem"

aws_region = "us-east-1"
cell_count = "2"
EOF

set -x

pushd "$terraform_dir" >/dev/null
    terraform apply || terraform apply
popd >/dev/null
