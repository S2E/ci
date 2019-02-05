#!/bin/bash
# Copyright (c) 2018, Cyberhaven
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

# This script checks out, installs, and tests the specified s2e-env repository

set -ex

S2E_BUILD_SCRIPTS_REPO="$1"

if [ $# -eq 3 ]; then
    S2E_ENV_REPO="$2"
    S2E_ENV_BRANCH="$3"

    git clone "$S2E_BUILD_SCRIPTS_REPO" build-scripts
    S2E_BUILD_SCRIPTS="$(pwd)/build-scripts"

    git clone "$S2E_ENV_REPO" s2e-env
    cd s2e-env
    git checkout "$S2E_ENV_BRANCH"
elif [ $# -eq 2 ]; then
    S2E_ENV_DIR="$2"
    if [ ! -d "$S2E_ENV_DIR" ]; then
        echo "$S2E_ENV_DIR does not exit"
        exit 1
    fi

    git clone "$S2E_BUILD_SCRIPTS_REPO" build-scripts
    S2E_BUILD_SCRIPTS="$(pwd)/build-scripts"
    cd $S2E_ENV_DIR

else
    echo "Usage:"
    echo "   $0 https://github.com/S2E/build-scripts.git https://github.com/S2E/s2e-env.git s2e_env_branch_name"
    echo "   $0 https://github.com/S2E/build-scripts.git /path/to/checked_out_folder"
    exit 1
fi


virtualenv venv
. venv/bin/activate
pip install --upgrade pip

pip install .
pip install pylint

echo Running pylint...
pylint -rn --rcfile=$S2E_BUILD_SCRIPTS/pylint_rc s2e_env
