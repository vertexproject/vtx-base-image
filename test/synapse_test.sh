#!/usr/bin/env sh
apk update
apk add git
git clone https://github.com/vertexproject/synapse.git -v --depth 1 ./synapse
cd ./synapse
SYN_VENDOR_TEST=1 python3 -m pytest -v -s --disable-warnings --durations 6 --maxfail 6
# pytest -v -s --disable-warnings --durations 6 --maxfail 6
exit $?
