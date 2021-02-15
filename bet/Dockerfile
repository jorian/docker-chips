FROM ubuntu:18.04

WORKDIR /root

ENV BUILD_DEPS="software-properties-common autoconf git build-essential libtool libprotobuf-c-dev \
libgmp-dev libsqlite3-dev python python3 zip libevent-dev pkg-config libssl-dev libcurl4-gnutls-dev \
make libboost-all-dev automake jq wget ninja-build libsqlite3-dev libgmp3-dev valgrind libcli-dev \
libsecp256k1-dev libsodium-dev libbase58-dev"

ENV BET_REPO https://github.com/chips-blockchain/bet
ENV NANOMSG https://github.com/nanomsg/nng.git
ENV LIBWEBSOCKETS https://github.com/sg777/libwebsockets.git
ENV JSMN https://github.com/zserge/jsmn.git
ENV LIBWALLY https://github.com/ElementsProject/libwally-core.git

RUN apt-get update && apt-get install -y ${BUILD_DEPS}

# Todo: separate Lightning and Bet. JSMN is the culprit, because JSMN in BET depends on JSMN in Lightning
RUN git clone https://github.com/chips-blockchain/lightning && \
    cd lightning && \
    make

RUN ln -sf lightning/lightningd/lightningd /usr/local/bin/lightning

# lightning-cli terminal shortcut
RUN cd /usr/local/bin/ && \
    echo "#/bin/bash \n ~/lightning/cli/lightning-cli \$1 \$2 \$3 \$4 \$5 \$6 | jq ." > lightning-cli && \
    chmod +x /usr/local/bin/lightning-cli

RUN mkdir /opt/cmake && \
    wget https://cmake.org/files/v3.16/cmake-3.16.1-Linux-x86_64.sh && \
    sh cmake-3.16.1-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

RUN git clone $NANOMSG && \
    cd nng && \
    mkdir build && \
    cd build && \
    cmake -G Ninja .. && \
    ninja install

RUN git clone $LIBWEBSOCKETS && \
    cd libwebsockets && \
    mkdir build && \
    cd build && \
    cmake -DLWS_WITH_HTTP2=1 .. && \
    make && \
    make install && \
    ldconfig

RUN git clone $LIBWALLY && \
    cd libwally-core && \
    git submodule init && \
    git submodule sync --recursive && \
    git submodule update --init --recursive && \
    ./tools/autogen.sh && \
    ./configure && \
    make && make install && \
    ldconfig

RUN ls /usr/local/bin

RUN git clone $BET_REPO && \
    cd bet && \
    make

WORKDIR /opt/bet/bet/privatebet

CMD ["/bin/bash"]

