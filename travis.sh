#!/bin/bash
  
set -x
if [ $TRAVIS_BRANCH == "master" ] ; then

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

git checkout -b traffic

Rscript -e "source('github_traffic/github_traffic.R')"

git add .
git commit --message "Update Traffic Travis build: $TRAVIS_BUILD_NUMBER [skip ci]"

git remote add deploy https://yonicd:${GITHUB_PAT}@github.com/yonicd/blog.git
git push -f deploy traffic -v

else
echo "Not deploying, since this branch is not master."
fi#!/bin/bash
  
set -x
if [ $TRAVIS_BRANCH == "master" ] ; then

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

git checkout -b traffic

Rscript -e "source('github_traffic/github_traffic.R')"

git add .
git commit --message "Update Traffic Travis build: $TRAVIS_BUILD_NUMBER [skip ci]"

git remote add deploy https://yonicd:${GITHUB_PAT}@github.com/yonicd/blog.git
git push -f deploy traffic -v

else
echo "Not deploying, since this branch is not master."
fi#!/bin/bash
  
set -x
if [ $TRAVIS_BRANCH == "master" ] ; then

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

git checkout -b traffic

Rscript -e "source('github_traffic/github_traffic.R')"

git add .
git commit --message "Update Traffic Travis build: $TRAVIS_BUILD_NUMBER [skip ci]"

git remote add deploy https://yonicd:${GITHUB_PAT}@github.com/yonicd/blog.git
git push -f deploy traffic -v

else
echo "Not deploying, since this branch is not master."
fi