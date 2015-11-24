#!/bin/bash

set -ex

pushd forge-release >/dev/null
  test -z "$(gofmt -d -e src/$PACKAGE | tee >(cat >&2))"
popd >/dev/null

