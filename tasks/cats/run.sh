#!/bin/bash

set -ex

domain=$(cat deploy/domain)
cat <<EOF >config.json
{
  api: "api.$domain",
  admin_user: "admin",
  admin_password: "admin",
  apps_domain: "$domain",
  system_domain: "$domain",
  client_secret: "gorouter-secret",
  skip_ssl_validation: true,
  default_timeout: 600,
  long_curl_timeout: 600,
  use_http: true
}
EOF
export CONFIG=$PWD/config.json

git -C micropcf submodule update --init images/releases/cf-release
git -C micropcf/images/releases/cf-release submodule update --init src/github.com/cloudfoundry/cf-acceptance-tests

pushd micropcf/images/releases/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests >/dev/null
  export GOPATH=$PWD/Godeps/_workspace:$PWD/../../../..
  ./bin/test --skip='{NO_DIEGO_SUPPORT}' apps v2 operator internet_dependent
popd >/dev/null
