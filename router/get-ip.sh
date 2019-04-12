#!/bin/bash

# Prime the IP container

cd ..
cd prime
source ./prime-script.sh &>/dev/null
# @TODO: Echo out the IP address to slack
IPADDRESS=$(docker run --rm indy-conf-2019-dig)

echo $IPADDRESS

# Prime the Slack Container

