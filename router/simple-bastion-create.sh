#!/bin/bash

say 'creation is in progress'

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

IP=$(./get-ip.sh)

./notify.sh "Ip is: $IP"

./notify.sh "Creating bastion..."
cd ..
cd infrastructure/simpledemo

docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform init; TF_VAR_myip=$IP terraform apply -auto-approve;" >> test-file.log 2>&1

BASTIONIP=$(docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform output bastion-ip")

cd ../..
cd router
./notify.sh "Bastion created."
./notify.sh "Basation IP is: $BASTIONIP"
