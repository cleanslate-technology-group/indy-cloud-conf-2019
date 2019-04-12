#!/bin/bash

say 'creation is in progress'

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

./notify.sh "Creating state..."
cd ..
cd infrastructure/state

docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform init; terraform apply -auto-approve;" >> test-file.log 2>&1

cd ../..
cd router
./notify.sh "State created."

