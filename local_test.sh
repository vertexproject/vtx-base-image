#!/usr/bin/env bash

# Test script to for local dev
# Takes an image name, builds the test image locally; then runs the image.
# Can specify an optional synapse branch name.

BASEIMAGE=${1}
SYN_MASTER_REF=${2:master}

set -e # exit on nonzero
set -u # undefined variables
set -o pipefail # pipefail propagate error codes
set -x # debugging

printf "FROM ${BASEIMAGE}\n\n" > "test/Dockerfile_local"
cat test/Dockerfile >> "test/Dockerfile_local"
docker build \
    --progress plain \
    --tag "${BASEIMAGE}-test" \
    --file "test/Dockerfile_local" \
    ./test

docker run --rm --network host \
    --env 'SYN_LOG_LEVEL=DEBUG' \
    --env "SYN_MASTER_REF=${SYN_MASTER_REF}" \
    "${BASEIMAGE}-test" 2>&1
