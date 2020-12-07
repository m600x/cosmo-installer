FROM python:3.9.0-buster

RUN pip install pip --upgrade ; pip install ansible
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sshpass unzip tar

WORKDIR /work