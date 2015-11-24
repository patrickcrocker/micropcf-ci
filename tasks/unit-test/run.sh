#!/bin/bash

set -ex

pushd forge-release >/dev/null
  source .envrc
  go install github.com/onsi/ginkgo/ginkgo
  ginkgo -r --randomizeAllSpecs --randomizeSuites --failOnPending --trace src/$PACKAGE
popd >/dev/null
