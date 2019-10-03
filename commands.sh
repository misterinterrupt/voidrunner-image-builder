#!/bin/bash
DEBUG=false
export DOCKER_IMAGE_NAME=nhex
export DOCKER_CONTAINER_NAME=nhex
export BUILD_DIR=/build
OVERRIDE_CMDS=()
DOCKER_CMDS=()
KERNEL_CMDS=()
OSIMAGE_CMDS=()

colorEcho() {
  echo -e '\e[1m\e[36m'"${1}"'\e[0m';
}

usage() {
  colorEcho "Neohexane Image Builder" 1>&2;
  echo "Usage: ./commands.sh [FUNCTION [COMMAND]*]*" 1>&2;
  exit 1;
}

debugEcho() {
  if $DEBUG; then echo -e '\e[1m\e[31m'"${1}"'\e[0m'; fi 
}

if [ $# == 0 ]; then
    usage
fi

require_docker_build() {
  if [ -z $(docker images -a -q $DOCKER_IMAGE_NAME) ]; then 
    colorEcho "Run ./commands.sh docker build first";
    exit;
  fi
}

docker_get_container_by_name() {
  docker ps -a | awk '{ print $1,$2 }' | grep "$1" | awk '{print $1 }'4345
}

docker_get_images_by_name() {
  docker images -a | awk '{ print $1,$3 }' | grep "$1" | awk '{print $2}'
}

docker_get_dangling_images() {
  docker images -f "dangling=true" -q
}
docker_clean() {
  colorEcho "Nhex: cleaning up"
  docker_get_container_by_name $DOCKER_CONTAINER_NAME | xargs -I {} docker stop {}
  docker_get_container_by_name $DOCKER_CONTAINER_NAME | xargs -I {} docker rm {}
  docker_get_images_by_name $DOCKER_IMAGE_NAME | xargs -I {} docker rmi {};
  docker_get_dangling_images | xargs -I {} docker rmi {};
}

docker_build() {
  colorEcho "Nhex: building image"
  docker build --no-cache --squash --force-rm=true -t $DOCKER_IMAGE_NAME .;
  docker_get_dangling_images | xargs -I {} docker rmi {};
}

docker_install() {
  require_docker_build
  colorEcho "Nhex: Installing Sources"
  docker run -it --name=$DOCKER_CONTAINER_NAME $DOCKER_CONTAINER_NAME build install
  # LAST_IMAGE=$(docker images -a -q $DOCKER_IMAGE_NAME)
  docker commit $DOCKER_CONTAINER_NAME | awk -F '[/:]' '{print $2}' | xargs -I {} docker tag {} $DOCKER_CONTAINER_NAME
  # docker save $DOCKER_CONTAINER_NAME > "$DOCKER_CONTAINER_NAME.tar"
  # docker rmi "$LAST_IMAGE"
  # docker rmi "$DOCKER_IMAGE_NAME"
  # docker load < $DOCKER_CONTAINER_NAME.tar
}

override_login() {
  colorEcho "Nhex: logging in"
  docker run --entrypoint "/bin/bash" \
    -v "$(pwd)"/dependencies/:${BUILD_DIR}/transfer \
    -v "$(pwd)"/scripts:${BUILD_DIR}/transfer/scripts -it $DOCKER_IMAGE_NAME
}

kernel_build() {
  require_docker_build
  colorEcho "Nhex: building kernel"
  docker run -it $DOCKER_IMAGE_NAME kernel build
}

osimage_create() {
  colorEcho "Nhex: creating os image"
   docker run --entrypoint "/bin/bash" -it $DOCKER_IMAGE_NAME image create
}

while (( "$#" )); do
  declare -n CMD_INDEX
  # debugEcho "parsing $1 of $# args"
  case "$1" in
    override)
      declare -n CMD_INDEX=OVERRIDE_CMDS
      debugEcho "setting ${!CMD_INDEX} as current command category"
      shift 1
      ;;
    docker)
      declare -n CMD_INDEX=DOCKER_CMDS
      debugEcho "setting ${!CMD_INDEX} as current command category"
      shift 1
      ;;
    kernel)
      declare -n CMD_INDEX=KERNEL_CMDS
      debugEcho "setting ${!CMD_INDEX} as current command category"
      shift 1
      ;;
    image)
      declare -n CMD_INDEX=OSIMAGE_CMDS
      debugEcho "setting ${!CMD_INDEX} as current command category"
      shift 1
      ;;
    *)
      debugEcho "* $@"
      if [[ -z ${!CMD_INDEX} ]]; then
        colorEcho "Please specify a function before any commands."
        usage
        exit;
      else
        debugEcho "assigning $1 to ${!CMD_INDEX}"
        CMD_INDEX+=("$1")
        shift 1
      fi
      ;;
  esac
done

debugEcho "override cmds: ${OVERRIDE_CMDS[@]}"
debugEcho "docker cmds : ${DOCKER_CMDS[@]}"

if [[ ${#DOCKER_CMDS[@]} -gt 0 ]]; then
  for (( i=0; i<${#DOCKER_CMDS[@]}; i++ )); do {
    DOCKER_CMD=${DOCKER_CMDS[$i]}
    if [[ $DOCKER_CMD == 'clean' ]]; then
      docker_clean
    fi
    if [[ $DOCKER_CMD == 'build' ]]; then
      docker_build
    fi
    if [[ $DOCKER_CMD == 'install' ]]; then
      docker_install
    fi
  }; done
fi

if [[ ${#OVERRIDE_CMDS[@]} -gt 0 ]]; then
  if [ ${OVERRIDE_CMDS[0]} == 'login' ] && [ ! -z "$(docker images -a -q $DOCKER_IMAGE_NAME)" ]; then
    override_login
  fi
fi

if [[ ${#KERNEL_CMDS[0]} -gt 0 ]]; then
  if [ ${KERNEL_CMDS[0]} == 'build' ] && [ ! -z "$(docker images -a -q $DOCKER_IMAGE_NAME)" ]; then
    kernel_build
  fi
fi

if [[ ${#OSIMAGE_CMDS[@]} -gt 0 ]]; then
  if [ ${OSIMAGE_CMDS[0]} == 'create' ] && [ ! -z "$(docker images -a -q $DOCKER_IMAGE_NAME)" ]; then
    osimage_create
  fi
fi
