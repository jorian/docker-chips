FROM ubuntu:18.04

ENV BUILD_DEPS="build-essential git wget software-properties-common libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3"
ENV CHIPS_DATA=/home/chips/.chips

RUN useradd -r chips && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ${BUILD_DEPS} && \
    apt-get clean

WORKDIR /usr/local

ENV DIRPATH=/usr/local
ENV PREFIX=/usr/local/db4

RUN mkdir -p ${PREFIX} && \
    wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h && \
    cd db-4.8.30.NC/build_unix/ && \
    ../dist/configure -enable-cxx -disable-shared -with-pic -prefix=${PREFIX} && \
    make install

RUN git clone https://github.com/chips-blockchain/chips && \
    cd chips && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L${PREFIX}/lib/" CPPFLAGS="-I${PREFIX}/include/" \
    --with-gui=no --disable-tests --disable-bench --without-miniupnpc --enable-experimental-asm \
    --enable-static --disable-shared && \
    make -j$(nproc)

RUN ln -s $PWD/chips/src/chipsd /usr/local/bin/
RUN ln -s $PWD/chips/src/chips-cli /usr/local/bin/


EXPOSE 57776 57777

COPY . .
# RUN chmod +x ./entrypoint.sh
# ENTRYPOINT [ "./entrypoint.sh" ]

VOLUME [ "/home/chips/.chips" ]
USER chips

CMD ["/bin/bash"]
