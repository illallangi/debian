# Debian Builder image
FROM docker.io/library/debian:buster-20220912 AS debian-builder

RUN \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    ca-certificates=20200601~deb10u2 \
    curl=7.64.0-4+deb10u3 \
  && \
  rm -rf /var/lib/apt/lists/*

# Build confd
FROM debian-builder as confd-builder

RUN \
  curl https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 --location --output /usr/local/bin/confd \
  && \
  chmod +x \
    /usr/local/bin/confd

# Main image
FROM docker.io/library/debian:buster-20220912

# Install packages
RUN \
  apt-get update \
  && \
  rm -rf /var/lib/apt/lists/*

COPY --from=confd-builder /usr/local/bin/confd /usr/local/bin/confd
