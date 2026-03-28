FROM codinuum/diffast

LABEL maintainer="codinuum"

COPY LICENSE /opt/cca/
COPY cca /opt/cca/

ENV HOME=/root
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH

SHELL ["/bin/bash", "-c"]

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
            openjdk-17-jdk \
            curl wget rsync \
            libgit2-dev \
            liblzma-dev libsqlite3-dev libffi-dev libbz2-dev

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

RUN set -x && \
    cd /root && \
    curl -fsSL https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc && \
    eval "$(pyenv init - bash)" && \
    pyenv install 3.14.3 && \
    pyenv global 3.14.3 && \
    pip install --upgrade pip && \
    pip install pygit2 pyodbc setuptools python-rapidjson svn daemon build javalang

COPY python /root/python

RUN set -x && \
    eval "$(pyenv init - bash)" && \
    cd /root/python && \
    python3 -m build && \
    pip install dist/cca-*.tar.gz --break-system-packages && \
    cd /root && \
    rm -r python

RUN set -x && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
