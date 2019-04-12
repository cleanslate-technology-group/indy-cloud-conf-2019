#!/bin/bash

export PATH=$PATH:/usr/local/bin

alias docker=/usr/local/bin/docker

PAYLOAD="{\"text\": \"$@\"}"

CMD="curl -X POST -H 'Content-type: application/json' --data '$PAYLOAD' https://hooks.slack.com/services/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"

docker run --rm notify /bin/sh -c "$CMD"
