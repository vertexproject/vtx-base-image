#!/usr/bin/env bash
apt update
apt install -y git
git clone https://github.com/vertexproject/synapse.git -v --depth 1 ./synapse
cd ./synapse
cp -v /opt/test/pytest.ini .
which python3
which python
SYN_VENDOR_TEST=1 python3 -m pytest
# pytest -v -s --disable-warnings --durations 6 --maxfail 6
exit $?
