FROM python:3.9.9-buster

ARG ssh_prv_key
ARG ssh_pub_key

COPY requirements.txt requirements.txt

RUN apt update && apt upgrade -y && apt install -y sshpass ; \
    pip install pip --upgrade && pip install -r requirements.txt ; \
    mkdir -p /root/.ssh ; chmod 0700 /root/.ssh ; \
    echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod -R 0600 /root/.ssh

WORKDIR /etc/ansible