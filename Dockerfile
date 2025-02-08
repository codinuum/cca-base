FROM codinuum/diffast

LABEL maintainer="codinuum"

COPY LICENSE /opt/cca/
COPY cca /opt/cca/

RUN set -x && \
    cd /root && \
    apt-get update && \
    apt-get upgrade -y && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            gosu \
            vim \
            net-tools \
            make m4 flex bison automake autoconf \
            libtool swig \
            libssl-dev libz-dev libreadline-dev librdf0-dev libpcre3-dev unixodbc-dev \
            gawk gperf \
            sloccount \
            unixodbc \
            openjdk-8-jdk \
            python3 python3-dev \
            python3-pygit2 \
            python3-pyodbc \
            python3-setuptools \
            python3-rapidjson \
            python3-svn \
            python3-daemon \
            python3-venv \
            python3-build \
            python3-pip \
            wget \
            rsync && \
    pip3 install javalang --break-system-packages

RUN set -x && \
    cd /root && \
    git clone https://github.com/openlink/virtuoso-opensource && \
    cd virtuoso-opensource && \
    ./autogen.sh && \
    env CFLAGS='-O2' ./configure --prefix=/opt/virtuoso --with-layout=opt --with-readline=/usr \
    --program-transform-name="s/isql/isql-v/" --disable-dbpedia-vad --disable-demo-vad \
    --enable-fct-vad --enable-ods-vad --disable-sparqldemo-vad --disable-tutorial-vad \
    --enable-isparql-vad --enable-rdfmappers-vad --enable-openssl=/usr && \
    make && make install && \
    cd /root && \
    rm -r virtuoso-opensource

COPY python /root/python

RUN set -x && \
    cd /root/python && \
    python3 -m build && \
    pip3 install dist/cca-*.tar.gz --break-system-packages && \
    cd /root && \
    rm -r python

RUN set -x && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
