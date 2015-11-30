#!/bin/bash

set -ex

pushd forge >/dev/null
  test -z "$(gofmt -d -e src/$PACKAGE | tee >(cat >&2))"
popd >/dev/null

