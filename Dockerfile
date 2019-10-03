# following example from here: https://www.digikey.com/eewiki/display/linuxonarm/BeagleBone+Black
FROM debian:stretch-20190812-slim
LABEL name=nhex
RUN apt-get update && apt-get install -y \
  apt-utils \
  bash \
  curl \
  build-essential \
  wget \
  git \
  libncurses5-dev:amd64 \
  libssl-dev:amd64 \
  flex \
  bison \
  initramfs-tools \
  dosfstools \
  rsync \
  bc \
  lsb-release \
  lzop \
  lzma \
  man-db \
  gettext \
  pkg-config \
  libmpc-dev \
  u-boot-tools \
  && rm -rf /var/lib/apt/lists/*

ENV BUILD_DIR=/build/
COPY dependencies "${BUILD_DIR}"
COPY scripts  "${BUILD_DIR}"/scripts
ENTRYPOINT ["/bin/bash", "-c" ,"$BUILD_DIR/scripts/entrypoint.sh $0 $1"]

