#!/bin/sh

docker stack rm jenkins
docker build -t cyberhaven/s2e-jenkins -f Dockerfile .
docker stack deploy -c jenkins.yml jenkins

