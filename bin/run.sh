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
U_ID=`id | awk -F '[(=]' '{print $2}'`
G_ID=`id | awk -F '[(=]' '{print $4}'`

set -- `getopt p:s:u:g: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -p) AUTH_PASSWORD="$2"
        shift ;;
    -s) SUDO_PASSWORD="$2"
        shift ;;
    -u) U_ID="$2"
        shift ;;
    -g) G_ID="$2"
        shift ;;
  esac
  shift
done

# 镜像有 BUG， auth_password 与 sudo_password 被混用了，直接使用同一个
auth_password=${SUDO_PASSWORD} sudo_password=${SUDO_PASSWORD} uid=${U_ID} gid=${G_ID} docker-compose up -d

# 等容器运行
sleep 5

# 初始镜像在启动后默认会在 /etc/sudoers 追加一行 abc 账号的 sudo 配置（需要 sudo 密码）
# 导致 /etc/sudoers.d/abc 的配置不生效（不需要 sudo 密码）
# 下面脚本的作用就是删除追加的配置
# 注： 把下面操作写入 Dockerfile 并不会生效，原因是追加动作是在镜像构建完成之后
DOCKER_ID=`docker ps -aq --filter name=docker_vscode_web`
if [ ! -z "${DOCKER_ID}" ]; then
    docker exec -u root ${DOCKER_ID} /bin/bash -c "chmod a+w /etc/sudoers && sed -e /^abc/d /etc/sudoers > /tmp/sudoers.bak && cat /tmp/sudoers.bak > /etc/sudoers && rm -f /tmp/sudoers.bak && chmod a-w /etc/sudoers"
fi
