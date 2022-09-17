# Main image
FROM docker.io/library/debian:buster-20220912

# Install packages
RUN \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    ca-certificates=20200601~deb10u2 \
    curl=7.64.0-4+deb10u3 \
    musl=1.1.21-2 \
    xz-utils=5.2.4-1+deb10u1 \
  && \
  rm -rf /var/lib/apt/lists/*

# Install confd
RUN \
  curl https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 --location --output /usr/local/bin/confd \
  && \
  chmod +x \
    /usr/local/bin/confd

# add s6 overlay
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# set command
CMD ["/init"]
