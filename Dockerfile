FROM mirakc/mirakc:debian

# Build envirionment
RUN apt update && apt install -y --no-install-recommends \
    wget \
    curl \
    pcscd \
    pcsc-tools \
    libpcsclite1 \
    libpcsclite-dev \
    && rm -rf /var/lib/apt/lists/*

# TARGETPLATFORM
ARG TARGETPLATFORM

# Install recisdb
ARG RECISDB_RS_VERSION
WORKDIR /tmp
RUN PLATFORM=$( \
      case ${TARGETPLATFORM} in \
        linux/amd64 ) echo "amd64";; \
        linux/arm64 ) echo "arm64";; \
      esac \
    ) && \
    wget https://github.com/kazuki0824/recisdb-rs/releases/download/${RECISDB_RS_VERSION}/recisdb_${RECISDB_RS_VERSION}-1_${PLATFORM}.deb -O ./recisdb.deb
RUN apt-get install -y ./recisdb.deb
RUN rm ./recisdb.deb
RUN recisdb --version

# Install miraview
ARG MIRAVIEW_VERSION
WORKDIR /var/html/miraview
RUN curl -L https://github.com/maeda577/miraview/releases/download/${MIRAVIEW_VERSION}/build.tar.gz | tar -zxvf -

# Install healthcheck script
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

WORKDIR /app

# entrypoint.shをコピーして実行権限付与
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
