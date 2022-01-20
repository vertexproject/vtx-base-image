#!/usr/bin/env bash
apt update
apt install -y git
git clone https://github.com/vertexproject/synapse.git -v --depth 1 ./synapse
cd ./synapse
pytest -v -s --disable-warnings --durations 6 --maxfail 6
exit $?
