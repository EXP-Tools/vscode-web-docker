#------------------------------------------------
# 运行 docker 服务
#------------------------------------------------
# 命令执行示例：
# ./run.ps1 -p "123456"
#------------------------------------------------
# ./run.ps1
#           [-a ${AUTH_PASSWORD}]            # 前端认证密码
#           [-p ${SUDO_PASSWORD}]            # 后端提权密码
#------------------------------------------------

param (
    [string]$a = "123456",
    [string]$p = "123456"
)

$AUTH_PASSWORD = $a
$SUDO_PASSWORD = $p


$ENV:auth_password=${AUTH_PASSWORD}; `
$ENV:sudo_password=${SUDO_PASSWORD}; `
docker-compose up -d
