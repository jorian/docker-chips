# Docker files for CHIPS / BET / PANGEA

## Bet (+ lightning)

Bet depends on some dependencies made in Lightning, so (for now) we have to put up with building 2 things in one container.

## CHIPS

The Dockerfile in `/chips` is based on the bitcoin docker images that are found [https://github.com/ruimarinho/docker-bitcoin-core/blob/master/0.21/alpine/Dockerfile](here)

It's supposed to have a very light footprint.

### Usage

#### Binaries

This image contains the chips binaries. It behaves like a binary, so any arguments passed to it will be forwarded.

```sh
    docker run --rm -it n41r0j/chips:latest \
    -txindex=1
    -server=1
```

You can also mount a directory in a volume under /home/bitcoin/.bitcoin in case you want to access it on the host:

```sh
    docker run -v ${PWD}/data:/home/chips/.chips --rm -it n41r0j/chips:latest
```

`docker-compose` file (add more arguments to `chipsd` in the command section)

```yml
chips:
  image: n41r0j/chips
  command: -txindex=1 
```

#### Talk to chips-cli

Start daemon like this:

```sh
    docker run --rm --name chips-node -it n41r0j/chips \

```

Then in a new terminal window:

```sh
    docker exec --user chips chips-node chips-cli getinfo
```

## Todo

- [ ] include an option to download a bootstrap
- [ ] work out RPC connection
