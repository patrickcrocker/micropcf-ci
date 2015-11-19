#!/bin/bash

set -ex

pushd cf-local-release >/dev/null
  test -z "$(gofmt -d -e src/$PACKAGE | tee >(cat >&2))"
popd >/dev/null

