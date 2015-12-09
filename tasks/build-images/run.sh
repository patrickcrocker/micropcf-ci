#!/bin/bash

set -e

echo "$GITHUB_SSH_KEY" > github_private_key.pem
chmod 0600 github_private_key.pem
eval $(ssh-agent)
ssh-add github_private_key.pem > /dev/null
rm github_private_key.pem

echo "$REMOTE_EXECUTOR_PRIVATE_KEY" > remote_executor.pem
chmod 0600 remote_executor.pem

set -x

current_version=$(cat "current-$DISTRO-box-version/number")
next_version=$(cat "next-$DISTRO-box-version/number")
current_box_commit=$(cat "$DISTRO-box-commit/base-box-commit")
ignore_paths="$(echo $IGNORE_PATHS | jq -r '":!" + (. // [])[]')"
next_box_commit=$(git -C micropcf log --grep '\[ci skip\]' --invert-grep --format='%H' -1 -- images $ignore_paths)

if [[ $current_box_commit == $next_box_commit ]]; then
  echo -n $current_box_commit > box-commit
  echo -n $current_version > box-version-number
  exit 0
fi

git -C micropcf checkout "$next_box_commit"
git -C micropcf submodule update --init --recursive

micropcf_json=$(cat "micropcf/images/micropcf.json")
post_processor_json=`
cat <<EOF
{
  "post-processors": [[
    {
      "type": "vagrant"
    },
    {
      "type": "atlas",
      "only": ["amazon-ebs"],
      "token": "$ATLAS_TOKEN",
      "artifact": "micropcf/$DISTRO",
      "artifact_type": "vagrant.box",
      "metadata": {
        "provider": "aws",
        "version": "$next_version"
      }
    },
    {
      "type": "atlas",
      "only": ["vmware-iso"],
      "token": "$ATLAS_TOKEN",
      "artifact": "micropcf/$DISTRO",
      "artifact_type": "vagrant.box",
      "metadata": {
        "provider": "vmware_desktop",
        "version": "$next_version"
      }
    },
    {
      "type": "atlas",
      "only": ["virtualbox-iso"],
      "token": "$ATLAS_TOKEN",
      "artifact": "micropcf/$DISTRO",
      "artifact_type": "vagrant.box",
      "metadata": {
        "provider": "virtualbox",
        "version": "$next_version"
      }
    }
  ]]
}
EOF
`

echo $micropcf_json | jq '. + '"$post_processor_json" > "micropcf/images/micropcf.json"

ssh-keyscan $REMOTE_EXECUTOR_ADDRESS >> $HOME/.ssh/known_hosts
remote_path=$(ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS mktemp -d /tmp/build-images.XXXXXXXX)

function cleanup { ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS rm -rf "$remote_path"; }
trap cleanup EXIT

rsync -a -e "ssh -i remote_executor.pem" micropcf vcap@$REMOTE_EXECUTOR_ADDRESS:$remote_path/
rm -rf micropcf || true

ssh -i remote_executor.pem vcap@$REMOTE_EXECUTOR_ADDRESS <<EOF
  export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
  export ATLAS_TOKEN="$ATLAS_TOKEN"
  cd "$remote_path"
  "micropcf/images/$DISTRO/build" -var "version=$next_version" -only=$NAMES
EOF

echo -n $next_box_commit > box-commit
echo -n $next_version > box-version-number
