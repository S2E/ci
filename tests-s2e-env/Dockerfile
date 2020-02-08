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

# Creates a fresh docker image for testing S2E.

FROM ubuntu:18.04
MAINTAINER Vitaly Chipounov <vitaly@cyberhaven.io>

RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted' /etc/apt/sources.list && \
    sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted' /etc/apt/sources.list && \
    sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted' /etc/apt/sources.list


RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y less sudo

# These are the minimum packages required to run s2e-env
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y git gcc python3 python3-dev python3-venv

RUN useradd -U -m -d /home/s2e -s /bin/bash -G sudo s2e
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

USER s2e
COPY install.sh /home/s2e
WORKDIR /home/s2e
ENTRYPOINT ["/home/s2e/install.sh"]
