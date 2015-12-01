#!/bin/bash

set -ex

next_version=$(cat "next-$DISTRO-box-version/number")

IFS=','
for p in $PROVIDERS; do
  errors=$(curl "https://atlas.hashicorp.com/api/v1/box/micropcf/$DISTRO/version/$next_version/provider/$p?access_token='$ATLAS_TOKEN'" | jq -r .errors)
  if [[ $errors != 'null' ]]; then
    curl "https://atlas.hashicorp.com/api/v1/box/micropcf/$DISTRO/version/$next_version" \
      -X DELETE -d access_token=$ATLAS_TOKEN
    exit 0
  fi
done

