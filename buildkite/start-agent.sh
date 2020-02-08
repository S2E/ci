#!/bin/sh

# Copyright (c) 2020, Cyberhaven
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# This script requires the following variables to be set:
#
# TOKEN:      token for buildkite
# ROOT_DIR:   root of the buildkite installation
# AGENT_USER: buildkite user and group name
# NAME:       agent name

set -exu

if ! grep -q $AGENT_USER /etc/passwd; then
    useradd -U -d /var/lib/buildkite-agent -s /bin/bash -G docker $AGENT_USER
fi

if [ ! -d "$ROOT_DIR" ]; then
    mkdir -p "$ROOT_DIR/agent"
    mkdir -p "$ROOT_DIR/builds"
    mkdir -p "$ROOT_DIR/hooks"
    mkdir -p "$ROOT_DIR/plugins"
    mkdir -p "$ROOT_DIR/.ssh"
    cp buildkite-agent.cfg "$ROOT_DIR"

    sudo chown -R $AGENT_USER:$AGENT_USER "$ROOT_DIR"
fi

docker run --rm -ti  \
    -v "$ROOT_DIR/agent:/var/lib/buildkite-agent" \
    -v "$ROOT_DIR:/buildkite" \
    -v "$ROOT_DIR/builds:$ROOT_DIR/builds" \
    -v "$ROOT_DIR/.ssh:/.ssh" \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -e "BUILDKITE_BUILD_PATH=$ROOT_DIR/builds" \
    -e "BUILDKITE_AGENT_NAME=$NAME%n" \
    --user $(id -u $AGENT_USER):$(id -u $AGENT_USER) \
    $(for ID in $(id -G $AGENT_USER); do echo -n "--group-add $ID "; done) \
    --name buildkite-agent \
    buildkite/agent:3 start \
    --token $TOKEN
