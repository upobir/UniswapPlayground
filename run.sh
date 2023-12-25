#!/bin/bash

if [ "$NET_ENV" != "LOCAL" ]; then
    echo "not a local config"
    exit 1
fi

# forge create ./src/Tokens.sol:WethToken \
#     --rpc-url $RPC_URL \
#     --private-key $PRIVATE_KEY 

# forge create ./src/MyUniswapV2Factory.sol:UniswapV2Factory \
#     --rpc-url $RPC_URL \
#     --private-key $PRIVATE_KEY \
#     --constructor-args $PUBLIC_KEY

forge script ./script/TripleToken.s.sol:TripleTokenScript \
    --fork-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast