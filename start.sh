#!/bin/bash
# Doesn't use docker-compose to avoid an other dependency on the host apart from Docker itself

docker build -t cosmo-installer .
docker run -v ${PWD}/:/work:ro --rm cosmo-installer ansible-playbook -i cosmo, cosmo.yml