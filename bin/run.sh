#!/bin/bash
#------------------------------------------------
# 运行 docker 服务
#------------------------------------------------
# 命令执行示例：
# ./run.sh -p "123456"
#------------------------------------------------
# sudo bin/run.sh
#           [-a ${AUTH_PASSWORD}]            # 前端认证密码
#           [-p ${SUDO_PASSWORD}]            # 后端提权密码
#------------------------------------------------

AUTH_PASSWORD="123456"
SUDO_PASSWORD="123456"

set -- `getopt a:p:u:g: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -a) AUTH_PASSWORD="$2"
        shift ;;
    -p) SUDO_PASSWORD="$2"
        shift ;;
  esac
  shift
done

auth_password=${AUTH_PASSWORD} sudo_password=${SUDO_PASSWORD} docker-compose up -d

