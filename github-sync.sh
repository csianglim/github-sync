#!/bin/sh

set -e

UPSTREAM_REPO=$1
BRANCH_MAPPING=$2

if [[ -z "$UPSTREAM_REPO" ]]; then
  echo "Missing \$UPSTREAM_REPO"
  exit 1
fi

if [[ -z "$BRANCH_MAPPING" ]]; then
  echo "Missing \$SOURCE_BRANCH:\$DESTINATION_BRANCH"
  exit 1
fi

if ! echo $UPSTREAM_REPO | grep '\.git'
then
  UPSTREAM_REPO="https://github.com/${UPSTREAM_REPO}.git"
fi

echo "UPSTREAM_REPO=$UPSTREAM_REPO"
echo "BRANCHES=$BRANCH_MAPPING"

git config --unset-all http."https://github.com/".extraheader
git clone "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY" repo
cd repo
git config user.name "$GITHUB_ACTOR"
git config user.email "$GITHUB_ACTOR@users.noreply.github.com"
git remote set-url origin "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY"
git remote add tmp_upstream "$UPSTREAM_REPO"
git fetch tmp_upstream master:tmp
git checkout master
git merge tmp
git push origin master
git remote rm tmp_upstream
git remote --verbose
