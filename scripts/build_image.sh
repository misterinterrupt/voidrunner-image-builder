
# Root filesystem
RUN wget -c https://rcn-ee.com/rootfs/eewiki/minfs/debian-9.8-minimal-armhf-2019-02-16.tar.xz \
  && sha256sum debian-9.8-minimal-armhf-2019-02-16.tar.xz \
  && echo "40643313dbfc4bc9487455cb6e839cc110e226ac2e9046a2f59f05e563802943  debian-9.8-minimal-armhf-2019-02-16.tar.xz" \
  && tar xf debian-9.8-minimal-armhf-2019-02-16.tar.xz

# # Mount SD Card from host
# sudo fdisk -l
# sudo mkdir /mnt/usb
# sudo mount /dev/sdb1 /mnt/usb

# docker run -i -t -v /mnt/usb:/opt/usb ubuntu /bin/bash ls /opt/usb