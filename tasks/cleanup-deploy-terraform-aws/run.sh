#!/bin/bash

set -ex

pushd deploy-terraform-aws/forge-bundle-v*/terraform/aws >/dev/null
    terraform destroy -force || terraform destroy -force
popd >/dev/null
