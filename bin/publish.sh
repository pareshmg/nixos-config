#!/usr/bin/env sh

set -e
set -x

bname="publish-$(date '+%Y%m%d')"

echo "$bname"

git checkout -b pmain publish/main
git checkout -b publish
git merge --squash main
git commit -a -m "$bname"

git push -u publish publish

git checkout main
git branch -d publish
git branch -d pmain
