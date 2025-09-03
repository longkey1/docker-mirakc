FROM mirakc/mirakc:debian

# Build envirionment
RUN apt update && apt install -y --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install recisdb
ARG RECISDB_RS_VERSION
RUN PLATFORM=$( \
      case ${TARGETPLATFORM} in \
        linux/amd64 ) echo "amd64";; \
        linux/arm64 ) echo "arm64";; \
      esac \
    ) && \
    echo "TARGETPLATFORM=${TARGETPLATFORM}, PLATFORM=${PLATFORM}" && \
    wget https://github.com/kazuki0824/recisdb-rs/releases/download/${RECISDB_RS_VERSION}/recisdb_${RECISDB_RS_VERSION}-1_${PLATFORM}.deb -O ./recisdb.deb
RUN RUN apt-get install -y ./recisdb.deb
RUN rm ./recisdb.deb
RUN recisdb --version

# Install healthcheck script
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

WORKDIR /app
