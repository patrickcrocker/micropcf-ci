#!/bin/bash

set -ex

cp micropcf-ci/tasks/deploy-vsphere-bosh/bosh.yml .

sed -i "s/VCENTER-ADDRESS/$VCENTER_ADDRESS/g" bosh.yml
sed -i "s/VCENTER-USERNAME/$VCENTER_USERNAME/g" bosh.yml
sed -i "s/VCENTER-PASSWORD/$VCENTER_PASSWORD/g" bosh.yml

cp vsphere-bosh-state/bosh-state.json .

bosh-init deploy bosh.yml
