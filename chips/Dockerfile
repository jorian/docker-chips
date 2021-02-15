# Build stage for BerkeleyDB
FROM alpine:3.7 as berkeleydb

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base
RUN apk --no-cache add openssl

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

RUN wget https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j$(nproc)
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for building CHIPS
FROM alpine:3.7 as chips

COPY --from=berkeleydb /opt /opt

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add boost-dev
RUN apk --no-cache add build-base
RUN apk --no-cache add chrpath
RUN apk --no-cache add file
RUN apk --no-cache add git
RUN apk --no-cache add gnupg
RUN apk --no-cache add libevent-dev
RUN apk --no-cache add libtool
RUN apk --no-cache add linux-headers
RUN apk --no-cache add openssl
RUN apk --no-cache add openssl-dev
RUN apk --no-cache add protobuf-dev
RUN apk --no-cache add zeromq-dev

ENV CHIPS_PREFIX=/opt/chips

RUN git clone https://github.com/chips-blockchain/chips

WORKDIR /chips

RUN ./autogen.sh 
RUN ./configure LDFLAGS=-L`ls -d /opt/db*`/lib/ CPPFLAGS=-I`ls -d /opt/db*`/include/ \
    --prefix=${CHIPS_PREFIX} \
    --mandir=/usr/share/man \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --with-gui=no \
    --with-utils \
    --with-libs \
    --with-daemon
RUN make -j$(nproc)
RUN make install
RUN strip ${CHIPS_PREFIX}/bin/chips-cli
RUN strip ${CHIPS_PREFIX}/bin/chips-tx
RUN strip ${CHIPS_PREFIX}/bin/chipsd
RUN strip ${CHIPS_PREFIX}/lib/libbitcoinconsensus.a
RUN strip ${CHIPS_PREFIX}/lib/libbitcoinconsensus.so.0.0.0

# Build stage for compiled artifacts
FROM alpine:3.7

RUN adduser -S chips
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add \
  boost \
  boost-program_options \
  libevent \
  openssl \
  libzmq \
  su-exec

ENV CHIPS_DATA=/home/chips/.chips
ENV CHIPS_PREFIX=/opt/chips
ENV PATH=${CHIPS_PREFIX}/bin:$PATH

COPY --from=chips /opt /opt

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/chips/.chips"]

EXPOSE 57776 57777

ENTRYPOINT ["/entrypoint.sh"]

CMD ["chipsd"]