#!/bin/sh
set -e

# Run this command from one-level higher in the folder path, not this folder.

CLI="faas-cli"
if ! [ -x "$(command -v faas-cli)" ]; then
    HERE=`pwd`
    cd /tmp/
    curl -sL https://github.com/openfaas/faas-cli/releases/download/0.12.19/faas-cli > faas-cli
    chmod +x ./faas-cli
    CLI="/tmp/faas-cli"

    echo "Returning to $HERE"
    cd $HERE
fi

echo "Working folder: `pwd`"

export REPO_URL="https://github.com/openfaas/openfaas-cloud"

if [ $1 ] ; then
    REPO_URL=$1
fi

$CLI publish --platforms=linux/arm64 --build-label=org.opencontainers.image.source=$REPO_URL
HERE=`pwd`
cd dashboard
$CLI publish -f stack.yml --platforms=linux/arm64 --build-label=org.opencontainers.image.source=$REPO_URL
cd $HERE