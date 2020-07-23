#!/bin/bash

set -ex
set -o pipefail

CHARTSDIR="$(pwd)/charts"

[ -z "$GITHUB_PAGES_BRANCH" ] && GITHUB_PAGES_BRANCH=gh-pages

[ -z "$HELM_CHARTS_SOURCE" ] && HELM_CHARTS_SOURCE="charts"

echo "GITHUB_PAGES_BRANCH=$GITHUB_PAGES_BRANCH"
echo "HELM_CHARTS_SOURCE=$HELM_CHARTS_SOURCE"

mkdir -p /tmp/gh-pages

echo '>> Building charts...'
git diff --diff-filter=d --dirstat=files,0 HEAD~1 | awk '{print $2}' | (grep -i -E "charts" || true) | cut -d/ -f2 | sort | uniq | while read chart; do
  pushd /tmp/gh-pages
  chart=$CHARTSDIR/$chart
  echo ">>> helm lint $chart"
  helm lint "$chart"
  chart_name="`basename "$chart"`"
  echo ">>> helm package -d $chart_name $chart"
  mkdir -p "$chart_name"
  helm package -d "$chart_name" "$chart"
  popd
done

git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin
git checkout -b gh-pages origin/gh-pages
rsync -a /tmp/gh-pages/ .

echo '>>> helm repo index'
helm repo index .
