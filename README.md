## Triple Token Uniswap

- [x] Deploy 3 different erc20 tokens. Say A, B and C.
- [x] Make uniswap v2 pool all three. A-B, B-C and C-A. All three should have different initial prices.
- [ ] Write a contract which can swap between these 3 tokens at best price

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
