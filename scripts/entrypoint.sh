#!/bin/bash
SCRIPTS_DIR=/build/scripts
usage() { printf "Neohexane Image Builder\n\nUsage: ./entrypoint.sh COMMAND\n\n" 1>&2; exit 1; }
if [ $# == 0 ]; then
    usage
fi

while (( "$#" )); do
  case "$1" in
    build)
      BUILD_CMD=$2
      shift 2
      ;;
    kernel)
      KERNEL_CMD=$2
      shift 2
      ;;
    image)
      IMAGE_CMD=$2
      shift 2
      ;;
  esac
done

if [[ $BUILD_CMD == 'install' ]]; then
  ${SCRIPTS_DIR}/install_sources.sh
fi

if [[ $KERNEL_CMD == 'build' ]]; then
  ${SCRIPTS_DIR}/build_kernel.sh
fi

if [[ $IMAGE_CMD == 'create' ]]; then
  ${SCRIPTS_DIR}/build_image.sh
fi

