#!/bin/bash
# 运行 vscode-web 服务
#------------------------------------------------
# 简单命令执行示例：
# ./run.sh -p 123456
# 完整命令执行示例：
# ./run.sh -p 123456 -s 123456 -u 1000 -g 1000
#------------------------------------------------

AUTH_PASSWORD="123456"
SUDO_PASSWORD="123456"
UID=`id | awk -F '[(=]' '{print $2}'`
GID=`id | awk -F '[(=]' '{print $4}'`

set -- `getopt p:s:u:g: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -p) AUTH_PASSWORD="$2"
        shift ;;
    -s) SUDO_PASSWORD="$2"
        shift ;;
    -u) UID="$2"
        shift ;;
    -g) GID="$2"
        shift ;;
  esac
  shift
done

auth_password=${AUTH_PASSWORD} sudo_password=${SUDO_PASSWORD} uid=${UID} gid=${GID} docker-compose up -d


# 初始镜像在启动后默认会在 /etc/sudoers 追加一行 abc 账号的 sudo 配置（需要 sudo 密码）
# 导致 /etc/sudoers.d/abc 的配置不生效（不需要 sudo 密码）
# 下面脚本的作用就是删除追加的配置
# 注： 把下面操作写入 Dockerfile 并不会生效，原因是追加动作是在镜像构建完成之后
DOCKER_ID=`docker ps -aq --filter name=docker_vscode_web`
if [ ! -z "${DOCKER_ID}" ]; then
    docker exec -u root ${DOCKER_ID} /bin/bash -c "chmod a+w /etc/sudoers && sed -e /^abc/d /etc/sudoers > /tmp/sudoers.bak && cat /tmp/sudoers.bak > /etc/sudoers && rm -f /tmp/sudoers.bak && chmod a-w /etc/sudoers"
fi
