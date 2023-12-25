## Triple Token Uniswap

- [x] Deploy 3 different erc20 tokens. Say A, B and C.
- [x] Make uniswap v2 pool all three. A-B, B-C and C-A. All three should have different initial prices.
- [x] Write a contract which can swap between these 3 tokens at best price

## Running
1. Run anvil with `anvil`
2. Give executable permissions to `run.sh` and fillup the first part of `.env` with private keys, public kyes, rpc url etc.
3. `set -a && source .env && set +a` to expose those variables
4. `./run.sh ./script/TokensDeploy.s.sol` to deploy the three tokens: alpha, bravo, charlie and also a dummy weth token. Put the console logged addresses in `.env`.
5. `./run.sh ./script/PoolSetup.s.sol` to set up uniswap factory and routers. The console logged address can be put in `.env`. The file has the inital ratios. The uniswap addresses are console logged, put them in `.env`
6. `./run.sh ./script/TokenSwap.s.sol` to do the token swap, change the file to change configs or from/to tokens. The console log shows the optimal amount and transfers.

## Files
- `MyUniswapV2Factory.sol` is slightly modified code of UniswapV2Factory as I needed the hashcode for pair creation
- `MyUniswapV2Router02.sol` is slightly modified code of UniswapV2Router02 as I needed to put the hashcode from UniswapV2Factory.
- `Tokens.sol` has the 3 tokens and Weth token defintion
- `OptimalSwapper.sol` has the actual swapper, you provide it the three token addresses, and router address. Then you transfer your initial tokens and ask for the optimal swap to target tokens. The swapper tries both ways (from -> to and from -> third -> to). You can also specify cycles to try, in which case swapper tries to extend the path by adding cycles (P -> Q -> R -> P). 

## Things I still do not know how to fix
- The uniswap files have compiler version lower than those needed by forge-std. I don't know how to incorporate them properly, so I just used the cheatcode `deployCode` from abi.
- I can't seem to do the token deployment, pool setup, token swap in one script. The script fails due to some transaction failure. So I ultimately decided to divide the codes.
- I do not know how to design the swapper to that instead of transfering tokens to it, it can be given permission to spend it and it will work normally.

## Todo
- Swapper has only code for maximum target token from exact source tokens, making minimum source tokens frome exact target tokens should be similar.
- Haven't done much of require or reverts, as I do not have much knowledge about them.
- Haven't written tests as I do not have much idea about foundry testing yet.
