#!/bin/bash

BASEDIR="$(dirname $0)/.."

if [ ! -f "$BASEDIR/.ovhtravis.gpg" ]; then
    echo "Missing ovhtravis gpg key, won't be able to sign files" >&2
else
    gpg --import "$BASEDIR/.ovhtravis.gpg"
fi

if [ -z "$GPG_PASS" ]; then
    echo "Missing gpg passphrase, signing files may fail" >&2
else
    echo $GPG_PASS > "$BASEDIR/.gpg.passphrase"
fi

echo "install openstack & swift clis" >&2
sudo pip install --upgrade setuptools
sudo pip install --upgrade cryptography
sudo pip install python-openstackclient==3.18.0
sudo pip install python-swiftclient==3.3.0

echo "creating HOME/bin directory" >&2
mkdir -p ~/bin
export PATH="~/bin:$PATH"

echo "installing terraform" >&2
curl -sLo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform.zip
mv terraform ~/bin

echo "installing terraform" >&2
curl -sLo packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
unzip packer.zip
mv packer ~/bin/packer-io
