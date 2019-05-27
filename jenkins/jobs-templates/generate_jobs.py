#!/usr/bin/env python
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

"""
This script creates all the Jenkins jobs for the S2E CI system.
"""

import argparse
import logging as log
import os
import shutil
import sys

from jinja2 import Template

log.basicConfig(level=0)

TRIGGERS_CFG = {
    'trigger-libcpu': {
        'repo': 'https://github.com/S2E/libcpu.git',
        'url': 'https://github.com/S2E/libcpu/'
    },
    'trigger-libtcg': {
        'repo': 'https://github.com/S2E/libtcg.git',
        'url': 'https://github.com/S2E/libtcg/'
    },
    'trigger-libs2e': {
        'repo': 'https://github.com/S2E/libs2e.git',
        'url': 'https://github.com/S2E/libs2e/'
    },
    'trigger-libs2ecore': {
        'repo': 'https://github.com/S2E/libs2ecore.git',
        'url': 'https://github.com/S2E/libs2ecore/'
    },
    'trigger-libs2eplugins': {
        'repo': 'https://github.com/S2E/libs2eplugins.git',
        'url': 'https://github.com/S2E/libs2eplugins/'
    },
    'trigger-libvmi': {
        'repo': 'https://github.com/S2E/libvmi.git',
        'url': 'https://github.com/S2E/libvmi/'
    },
    'trigger-guest-tools': {
        'repo': 'https://github.com/S2E/guest-tools.git',
        'url': 'https://github.com/S2E/guest-tools/'
    },
    'trigger-libfsigcxx': {
        'repo': 'https://github.com/S2E/libfsigcxx.git',
        'url': 'https://github.com/S2E/libfsigcxx/'
    },
    'trigger-tools': {
        'repo': 'https://github.com/S2E/tools.git',
        'url': 'https://github.com/S2E/tools/'
    },
    'trigger-klee': {
        'repo': 'https://github.com/S2E/klee.git',
        'url': 'https://github.com/S2E/klee/'
    },
    'trigger-libcoroutine': {
        'repo': 'https://github.com/S2E/libcoroutine.git',
        'url': 'https://github.com/S2E/libcoroutine/'
    },
    'trigger-libq': {
        'repo': 'https://github.com/S2E/libq.git',
        'url': 'https://github.com/S2E/libq/'
    },
}


def gen_triggers(template_file, jobs_dir):
    """
    Generate one repository monitoring job per S2E repository.
    A job can monitor only one repository, so we need to create one job for each repository.
    This job will trigger other downstream jobs that will do the actual work
    (e.g., checking code style, building, etc)
    """
    for job_name, env in TRIGGERS_CFG.iteritems():
        with open(template_file, 'r') as fp:
            template = Template(fp.read())
            rendered = template.render(env)

        job_dir = os.path.join(jobs_dir, job_name)
        if not os.path.isdir(job_dir):
            os.makedirs(job_dir, 0770)

        job_file = os.path.join(job_dir, 'config.xml')
        log.info('Rendering %s', job_file)
        with open(job_file, 'w') as fp:
            fp.write(rendered)


def copy_cfg_file(job_cfg_file, jobs_dir, job_name):
    job_dir = os.path.join(jobs_dir, job_name)
    if not os.path.isdir(job_dir):
        os.makedirs(job_dir, 0770)

    job_file = os.path.join(job_dir, 'config.xml')

    shutil.copyfile(job_cfg_file, job_file)


def main():
    parser = argparse.ArgumentParser(description='Generate Jenkins jobs from templates')
    parser.add_argument('-j', '--jobs-dir', required=True, help='Path to Jenkins jobs directory')
    parser.add_argument('-t', '--templates-dir', required=True, help='Path to the templates directory')
    args = parser.parse_args()

    if not os.path.isdir(args.jobs_dir):
        log.error('%s does not exist', args.jobs_dir)
        sys.exit(1)

    if not os.path.isdir(args.templates_dir):
        log.error('%s does not exist', args.templates_dir)
        sys.exit(1)

    for root, _, files in os.walk(args.templates_dir):
        for fn in files:
            template_file = os.path.join(root, fn)
            job_name, ext = os.path.splitext(fn)
            if ext != '.xml':
                continue

            log.info('Instantiating template %s for job %s', template_file, job_name)

            if job_name == 'triggers':
                gen_triggers(template_file, args.jobs_dir)
            else:
                copy_cfg_file(template_file, args.jobs_dir, job_name)


if __name__ == "__main__":
    main()
