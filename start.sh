#!/bin/bash

CONTAINER_NAME=cosmo-installer

docker build \
    --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
    --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" \
    -t $CONTAINER_NAME .

docker run -it --rm \
    --name $CONTAINER_NAME \
    --hostname container \
    -v ${PWD}/:/etc/ansible:rw \
    $CONTAINER_NAME /bin/bash
