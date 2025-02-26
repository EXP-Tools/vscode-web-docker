#!/bin/bash
#------------------------------------------------
# 进入容器的交互终端（不依赖工程名，所有工程通用脚本）
# bin/terminal.sh
#------------------------------------------------

# 获取容器列表
CONTAINER_LIST=$(docker ps --format "{{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}")

# 打印容器列表，并对容器打上编号
echo "Select a container to enter:"
echo "$CONTAINER_LIST" | awk '{print NR". "$0}'

# 读取用户选择的容器编号
read -p "Enter a number (0 for exit): " NUMBER

# 根据用户选择的容器编号获取容器ID
CONTAINER_ID=$(echo "$CONTAINER_LIST" | awk -v number="$NUMBER" 'NR==number{print $1}')

# 进入容器终端
if [ -n "$CONTAINER_ID" ]; then
    docker exec -it "$CONTAINER_ID" /bin/bash
else
    echo "Invalid container number."
fi
