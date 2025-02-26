# PowerShell
# ------------------------
# 发布镜像（不依赖工程名，所有工程通用脚本）
# bin/deploy.ps1 [-n NAMESPACE] [-v VERSION] [-b] [-p] [-u ${proxy}]
#   -n docker hub 的命名空间
#   -v 镜像版本号
#   -b 是否发布基础镜像
#   -p 是否启用代理
#   -u 代理地址（只支持 http）
# ------------------------

param(
    [string]$v="", 
    [string]$n="", 
    [switch]$b,
    [switch]$p, 
    [string]$u="http://127.0.0.1:10090"
)

$VERSION = Get-Date -format "yyyyMMddHH"
if(![String]::IsNullOrEmpty($v)) {
    $VERSION = $v
}

$NAMESPACE = "expm02"
if(![String]::IsNullOrEmpty($n)) {
    $NAMESPACE = $n
}

$IS_BASE = $b
$USE_PROXY = $p
$PROXY = $u

if ($USE_PROXY) {
    $env:HTTP_PROXY = $PROXY
    $env:HTTPS_PROXY = $PROXY
    Write-Host "代理已启用，地址为：$PROXY" -ForegroundColor Green
} else {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Write-Host "代理已禁用" -ForegroundColor Yellow
}


function deploy_image([string]$image_name) {
    $remote_url = "${NAMESPACE}/${image_name}"
    docker tag ${image_name} "${remote_url}:${VERSION}"
    docker push "${remote_url}:${VERSION}"
    docker tag ${image_name} "${remote_url}:latest"
    docker push "${remote_url}:latest"
    Write-Host "Pushed to ${remote_url}"
}


Write-Host "Login to docker hub ..."
docker login

$image_name = (Split-Path $pwd -leaf)
if(${IS_BASE}) {
    $image_name = "${image_name}-base"
}
deploy_image -image_name ${image_name}

Write-Host "finish ."