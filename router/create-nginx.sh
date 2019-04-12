#!/bin/bash

say 'web creation is in progress'

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

./notify.sh "Creating web server..."
cd ..
cd infrastructure/fulldemo

docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform init; terraform apply -auto-approve;" >> test-file.log 2>&1

WEBIP=$(docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform output web-ip")

cd ../..
cd router
./notify.sh "Web created."
./notify.sh "Web IP is: $WEBIP"
