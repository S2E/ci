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

set -xeu

if [ $# -ne 1 ]; then
    echo "Usage: $0 branch_name"
    exit 1
fi

CUR_DIR="$(pwd)"
BRANCH="$1"

git clone https://github.com/s2e/s2e-env.git
cd s2e-env

set +e
git checkout $BRANCH
set -e

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install .

cd "$CUR_DIR"

git config --global user.email "test@example.com"
git config --global user.name "John Doe"
git config --global color.ui "auto"

s2e init -n env

cd env/source
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

cd "$CUR_DIR/env"

s2e build
