#!/bin/bash

set -ex

pushd deploy-terraform-aws/micropcf-bundle-v*/terraform/aws >/dev/null
    terraform destroy -force || terraform destroy -force
popd >/dev/null
