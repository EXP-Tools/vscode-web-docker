#!/bin/bash
#------------------------------------------------
# 清理镜像、日志（不依赖工程名，所有工程通用脚本）
# bin/clean.sh
#------------------------------------------------

IMAGE_NAME=`echo ${PWD##*/}`

# echo "clean logs ..."
# rm -rf logs

echo "clean images ..."
docker rmi -f $(docker images | grep "${IMAGE_NAME}" | awk '{print $3}')
docker rmi -f $(docker images | grep "none" | awk '{print $3}')
docker images --filter "dangling=true" -q | xargs docker rmi -f


echo "finish ."