FROM ubuntu:16.04

RUN apt-get update -y && \
  apt-get install -y \
  vim \
  python3 \
  python3-pip \
  awscli \
  unzip \
  wget && \
  wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && \
  unzip terraform_0.11.7_linux_amd64.zip && \
  mv terraform /usr/local/bin/

WORKDIR /root/terraform

CMD [ "terraform", "--version" ]
