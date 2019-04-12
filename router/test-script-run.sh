#!/bin/bash

cd ..
cd infrastructure/demo1
docker run --rm -it -v ~/.aws-demo:/root/.aws/ -v $(pwd)/terraform:/root/terraform/ aws-builder /bin/bash -c "cd ~/terraform/state; terraform init; terraform plan"
