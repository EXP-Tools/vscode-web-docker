# Powershell
#------------------------------------------------
# 停止 docker 服务（不依赖工程名，所有工程通用脚本）
# bin/stop.ps1
#       [--keepdb]      # 可选参数: 保留 DB 服务不停止
#------------------------------------------------

param (
    [string]$keepdb
)

$IMAGE_NAME = (Split-Path $pwd -leaf)

if ($keepdb -eq "--keepdb") {
    docker ps | Select-String -Pattern "${IMAGE_NAME}" | Select-String -NotMatch -Pattern "redis|mysql" | ForEach-Object {
        docker stop $_.ToString().Split(" ")[-1]
    }
} else {
    docker-compose down

    Write-Host "Docker is stopped ."
}
