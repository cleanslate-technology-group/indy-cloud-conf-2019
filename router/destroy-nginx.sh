#!/bin/bash

say 'web destruction is in progress'

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

./notify.sh "Destroying web server..."
cd ..
cd infrastructure/fulldemo

docker run --rm \
-v ~/.aws-demo:/root/.aws/ \
-v $(pwd)/terraform:/root/terraform/ \
aws-builder \
/bin/bash -c "terraform init; terraform destroy -auto-approve;" >> test-file.log 2>&1

cd ../..
cd router
./notify.sh "Web destroyed."
