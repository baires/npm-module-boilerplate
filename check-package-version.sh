#!/bin/bash

REPO=baires/npm-module-boilerplate
NPM_PACKAGE_VERSION=$(npm info @baires/number-formatter)
MY_PACKAGE_VERSION=$(node -pe 'require("./package.json").version')

 if [ "$(printf "$NPM_PACKAGE_VERSION\n$MY_PACKAGE_VERSION" | sort -V | head -n1)" == "$MY_PACKAGE_VERSION" ] && [ "$MY_PACKAGE_VERSION" != "$NPM_PACKAGE_VERSION" ]; then
   printf "Old version [%s]\n" "$MY_PACKAGE_VERSION"
   curl -H "Content-Type: application/json" -H "Authorization: token $GITHUB_TOKEN" \
         --request POST \
         --data '{"state":"error",
         "target_url":"https://travis-ci.org/$REPO/builds/'$TRAVIS_BUILD_ID'",
         "description":"Build failed, you forgot to upgrade npm package version!",
         "context":"continuous-integration/travis"}' \
         "https://api.github.com/repos/$REPO/statuses/${TRAVIS_COMMIT}"
   exit 1

 else
   printf "New version [%s] === [%s]\n" "$MY_PACKAGE_VERSION" "$NPM_PACKAGE_VERSION"
   curl -H "Content-Type: application/json" -H "Authorization: token $GITHUB_TOKEN" \
         --request POST \
         --data '{"state":"success",
         "target_url":"https://travis-ci.org/$REPO/builds/'$TRAVIS_BUILD_ID'",
         "description":"Build passed!",
         "context":"continuous-integration/travis"}' \
         "https://api.github.com/repos/$REPO/statuses/${TRAVIS_COMMIT}"
   exit 0
 fi
