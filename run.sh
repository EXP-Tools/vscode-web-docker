#!/bin/bash
# 运行 vscode-web 服务
#------------------------------------------------
# 命令执行示例：
# ./run.sh -a 123456 -s 123456
#------------------------------------------------

AUTH_PASSWORD="123456"
SUDO_PASSWORD="123456"

set -- `getopt a:s: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -a) AUTH_PASSWORD="$2"
        shift ;;
    -s) SUDO_PASSWORD="$2"
        shift ;;
  esac
  shift
done

auth_password=${AUTH_PASSWORD} sudo_password=${SUDO_PASSWORD} docker-compose up -d
