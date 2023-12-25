#!/bin/bash

if [ "$NET_ENV" != "LOCAL" ]; then
    echo "not a local config"
    exit 1
fi

forge script "$1" \
    --fork-url $RPC_URL \
    --private-key $PRIVATE_KEY1 \
    --broadcast