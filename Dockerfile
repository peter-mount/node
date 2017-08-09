FROM area51/alpine
MAINTAINER Peter Mount <peter@retep.org>

# Current stable LTS version
ENV VERSION=v4.4.7 NPM_VERSION=2

RUN apk add --no-cache \
        curl \
        make \
        gcc \
        g++ \
        python \
        linux-headers \
        paxctl \
        libgcc \
        libstdc++ && \
    cd /tmp &&\
    curl -o node-${VERSION}.tar.gz -sSL https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.gz && \
    tar -zxf node-${VERSION}.tar.gz && \
    cd node-${VERSION} && \
    export GYP_DEFINES="linux_use_gold_flags=0" && \
    ./configure --prefix=/usr ${CONFIG_FLAGS} && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
    paxctl -cm out/Release/mksnapshot && \
    make -j${NPROC} && \
    make install && \
    paxctl -cm /usr/bin/node && \
    cd / && \
    if [ -x /usr/bin/npm ]; then \
        npm install -g npm@${NPM_VERSION} && \
        find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    fi && \
    apk del \
        curl \
        make \
        gcc \
        g++ \
        python \
        linux-headers \
        paxctl && \
    rm -rf /etc/ssl \
        /usr/share/man \
        /tmp/* \
        /var/cache/apk/* \
        /root/.npm \
        /root/.node-gyp \
        /root/.gnupg \
        /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html
