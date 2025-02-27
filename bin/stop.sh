#!/bin/bash
#------------------------------------------------
# 停止 docker 服务（不依赖工程名，所有工程通用脚本）
# bin/stop.sh
#       [--keepdb]      # 可选参数: 保留 DB 服务不停止
#------------------------------------------------

IMAGE_NAME=`echo ${PWD##*/}`
KEEP_DB=$1
if [ "x${KEEP_DB}" == "x--keepdb" ]; then
    docker ps | grep "${IMAGE_NAME}" | grep -v -e "redis" -e "mysql" | awk '{print $1}' | xargs docker stop

else
    auth_password=0 sudo_password=0 uid=0 gid=0 workpath="./volumes/workspace/" docker-compose up -d

    echo "Docker is stopped ."
fi
