#!/bin/bash

set -ex

pushd deploy-terraform-aws/cf-local-bundle-v*/terraform/aws >/dev/null
    terraform destroy -force || terraform destroy -force
popd >/dev/null
