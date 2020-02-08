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

set -xue

if [ $# -ne 1 ]; then
    echo "Usage: $0 branch_name"
    exit 1
fi

BRANCH="$1"

mkdir s2e
cd s2e

S2EDIR="$(pwd)"

repo init -u https://github.com/s2e/manifest.git
repo sync

set +e
for d in *; do
  if [ -d "$d" ]; then
    cd "$d"
    git checkout $BRANCH
    cd ..
  fi
done
set -e

mkdir build && cd build
make -f $S2EDIR/Makefile.docker demo
