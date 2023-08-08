#!/usr/bin/env bash
apt update
apt install -y git
git clone https://github.com/vertexproject/synapse.git -v --depth 1 ./synapse
cd ./synapse
which python3
which python
SYN_VENDOR_TEST=1 python3 -m pytest -v -s --disable-warnings --durations 6 --maxfail 1  --log-cli-level=DEBUG --log-cli-format="%(asctime)s [%(levelname)s] %(message)s [%(filename)s:%(funcName)s:%(threadName)s:%(processName)s]" --log-cli-date-format="%Y-%m-%d %H:%M:%S" -k "not test_slab_mapfull_runsyncloop"
# pytest -v -s --disable-warnings --durations 6 --maxfail 6
exit $?
