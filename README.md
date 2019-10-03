Build a Docker image for automating embedded linux development for audio projects on the Beaglebone Black.
It can do these things for you:

- build an image with the arm-linux-gnueabihf cross-compile toolchain
  - build the image:
    `./commands.sh docker build`
- cross-compile and configure the kernel
  - run menuconfig and compile:
    `./commands.sh kernel config`
  - compile kernel build:
    `./commands.sh kernel make`
- produce debian os images
  - download debian root file system, add layers in '/fs-overlay', and create os image
    `./commands.sh image create`
- compile C++/FAUST audio apps
