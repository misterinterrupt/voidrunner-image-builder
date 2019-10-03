#!/bin/bash
export BUILD_DIR=/build
cp -dR "${BUILD_DIR}"/transfer/* "${BUILD_DIR}"
cd "${BUILD_DIR}" || exit;
ls -lah
# Download kernel and checkout RT branch

# Mainline
# git clone https://github.com/RobertCNelson/bb-kernel
# cd bb-kernel/ 
# git checkout origin/am33x-rt-v4.19 -b kernel-source 
# cd ${BUILD_DIR} || exit;

# TI Board Support Package
git clone https://github.com/RobertCNelson/ti-linux-kernel-dev.git
cd ti-linux-kernel-dev || exit;
git checkout origin/ti-linux-rt-4.19.y -b kernel-source
cd ${BUILD_DIR} || exit;

# U-Boot
git clone https://github.com/u-boot/u-boot
cd u-boot || exit;
git checkout v2019.07 -b uboot-source
cd ${BUILD_DIR} || exit;

# root-fs 
wget -c https://rcn-ee.com/rootfs/eewiki/minfs/debian-9.8-minimal-armhf-2019-02-16.tar.xz;
sha256sum debian-9.8-minimal-armhf-2019-02-16.tar.xz | \
  awk '$1"  "$2=="40643313dbfc4bc9487455cb6e839cc110e226ac2e9046a2f59f05e563802943  debian-9.8-minimal-armhf-2019-02-16.tar.xz"{print"sha256sum verified"}'
tar xf debian-9.8-minimal-armhf-2019-02-16.tar.xz

# prove it all happened
CC=${BUILD_DIR}/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
${CC}gcc --version;
cd ${BUILD_DIR}/ti-linux-kernel-dev || exit;
git status;
cd ${BUILD_DIR}/u-boot || exit;
git status;
ls -lah ${BUILD_DIR}/debian-9.8-minimal-armhf-2019-02-16;
exit;