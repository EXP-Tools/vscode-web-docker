#!/bin/bash
# ------------------------
# 发布镜像（不依赖工程名，所有工程通用脚本）
# bin/deploy.sh [-n NAMESPACE] [-v VERSION] [-b ON/OFF]
#   -n docker hub 的命名空间
#   -v 镜像版本号
#   -b 是否发布基础镜像: ON/OFF(默认)
# ------------------------

NAMESPACE="expm02"
VERSION=$(date "+%Y%m%d%H")
IS_BASE="OFF"

set -- `getopt n:v:b: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -n) NAMESPACE="$2"
        shift ;;
    -v) VERSION="$2"
        shift ;;
    -b) IS_BASE="$2"
        shift ;;
  esac
  shift
done

function deploy_image {
    image_name=$1
    remote_url=${NAMESPACE}/${image_name}
    docker tag ${image_name} ${remote_url}:${VERSION}
    docker push ${remote_url}:${VERSION}
    docker tag ${image_name} ${remote_url}:latest
    docker push ${remote_url}:latest
    echo "Pushed to ${remote_url}"
}


echo "Login to docker hub ..."
docker login

image_name=`echo ${PWD##*/}`
if [ "x${image_name}" = "xON" ]; then
  image_name="${image_name}-base"
end
deploy_image ${image_name}

docker image ls | grep "${image_name}"
echo "finish ."