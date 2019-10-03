#!/bin/bash
export BUILD_DIR=/build
export CC=${BUILD_DIR}/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
cp scripts/system.sh $BUILD_DIR/ti-linux-kernel-dev || exit;
cd $BUILD_DIR/ti-linux-kernel-dev || exit;
export AUTO_BUILD=0 && \
  ./build_kernel.sh makeconfig