#!/usr/bin/env bash
apt update
apt install -y git

echo "Git clone synapse using branch: ${SYN_MASTER_REF:-master}"
git clone --single-branch --branch ${SYN_MASTER_REF:-master} -v --depth 1 https://github.com/vertexproject/synapse.git ./synapse
cd ./synapse

cp -v /opt/test/pytest.ini .
which python3
which python
SYN_VENDOR_TEST=1 python3 -m pytest
# pytest -v -s --disable-warnings --durations 6 --maxfail 6
exit $?
