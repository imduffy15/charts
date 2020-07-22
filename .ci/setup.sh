#!/bin/bash

set -e
set -o pipefail

[ -z "$HELM_VERSION" ] && HELM_VERSION=2.16.0

echo "HELM_VERSION=$HELM_VERSION"

echo $PATH

echo '>> Installing Helm...'
mkdir -p /tmp/helm/bin
cd /tmp/helm/bin
wget "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
chmod +x linux-amd64/helm
mv linux-amd64/helm /home/travis/bin/helm
helm version -c
helm init -c
