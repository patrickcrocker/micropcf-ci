#!/bin/bash
lattice_release_version=$(git -C ./lattice-release describe --tags --always)
export GOPATH=$(cd ./lattice-release && pwd)

pushd ./lattice-release/vagrant
  ./build
  tar czf "vagrant-boxes-${lattice_release_version}.tgz" lattice-*.box
popd
