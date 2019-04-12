#!/bin/bash

say 'destruction is in progress'

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

IP=$(./get-ip.sh)

./notify.sh "Destroying bastion..."
cd ..
cd infrastructure/simpledemo

docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform init; TF_VAR_myip=$IP terraform destroy -auto-approve;" >> test-file.log 2>&1

cd ../..
cd router
./notify.sh "Bastion destroyed."
