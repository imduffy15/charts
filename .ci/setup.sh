#!/bin/bash

set -e
set -o pipefail

[ -z "$HELM_VERSION" ] && HELM_VERSION=3.3.2

echo "HELM_VERSION=$HELM_VERSION"

echo '>> Installing Helm...'
mkdir -p /tmp/helm
pushd /tmp/helm
wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
chmod +x linux-amd64/helm
mv linux-amd64/helm /home/travis/bin/helm
helm version -c
popd
