
# Bootloader: U-Boot
# Das U-Boot – the Universal Boot Loader: http://www.denx.de/wiki/U-Boot
# eewiki.net patch archive: https://github.com/eewiki/u-boot-patches

# Download, patch, configure, and build u-boot
RUN git clone https://github.com/u-boot/u-boot \
  && cd u-boot \
  && git checkout v2019.07-rc4 -b tmp \
  && wget -c https://github.com/eewiki/u-boot-patches/raw/master/v2019.07-rc4/0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch \
  && wget -c https://github.com/eewiki/u-boot-patches/raw/master/v2019.07-rc4/0002-U-Boot-BeagleBone-Cape-Manager.patch \
  && patch -p1 < 0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch \
  && patch -p1 < 0002-U-Boot-BeagleBone-Cape-Manager.patch \
  && export CC=/build/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- \
  && make  O=am335x ARCH=arm CROSS_COMPILE=${CC} distclean \
  && make O=am335x ARCH=arm CROSS_COMPILE=${CC} am335x_evm_defconfig \
  && make O=am335x ARCH=arm CROSS_COMPILE=${CC}
