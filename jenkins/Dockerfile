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

# This docker file sets up a fully-functional Jenkins container for S2E

FROM jenkins/jenkins:lts

USER root
RUN apt-get update -qq && \
    apt-get install -qqy \
        apt-transport-https ca-certificates curl rsync gnupg2 software-properties-common \
        python git python-pip virtualenv nano

RUN pip install --upgrade pip

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Use pre-compiled clang-format to speed up code style verification process
RUN apt-get update -qq && \
    apt-get install -y docker-ce=17.12.1~ce-0~debian && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && \
    chmod +x /bin/repo && \
    wget https://releases.llvm.org/3.9.0/clang+llvm-3.9.0-x86_64-linux-gnu-debian8.tar.xz && \
    tar -xf clang+llvm-3.9.0-x86_64-linux-gnu-debian8.tar.xz && \
    cp -r clang+llvm-3.9.0-x86_64-linux-gnu-debian8/* /

USER jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY *.groovy /usr/share/jenkins/ref/init.groovy.d/

COPY s2e-env /usr/share/jenkins/ref/s2e-env/
COPY jobs-templates/ /usr/share/jenkins/ref/jobs-templates/

USER root
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/jobs-templates
USER jenkins

RUN /usr/share/jenkins/ref/jobs-templates/build.sh


