#!/bin/bash


NPM_PACKAGE_VERSION=$(npm info @tactivos/mural-shared version)

MY_PACKAGE_VERSION=$(node -pe 'require("./package.json").version')

if [ "$MY_PACKAGE_VERSION" \> "$NPM_PACKAGE_VERSION" ]; then
  printf "Old version [%s]\n" "$MY_PACKAGE_VERSION"
  exit 1

else [ "$MY_PACKAGE_VERSION" \< "$NPM_PACKAGE_VERSION" ]
  printf "New version [%s] === [%s]\n" "$MY_PACKAGE_VERSION" "$NPM_PACKAGE_VERSION"
  exit 0
fi
