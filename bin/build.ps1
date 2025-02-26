# Powershell
# ------------------------
# 构建基础镜像（不依赖工程名，所有工程通用脚本）
# bin/build_base.sh [-c] [-p] [-u ${proxy}]
#   -c 是否启用缓存构建
#   -p 是否启用代理
#   -u 代理地址（只支持 http）
# ------------------------


param(
    [switch]$c,
    [switch]$p, 
    [string]$u="http://127.0.0.1:10090"
)

$CACHE = $c
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


function del_image([string]$image_name) {
    $image_id = (docker images -q --filter reference=${image_name})
    if(![String]::IsNullOrEmpty(${image_id})) {
        Write-Host "delete [${image_name}] ..."
        docker image rm -f ${image_id}
        Write-Host "done ."
    }
}

function build_image([string]$image_name, [string]$dockerfile) {
    del_image -image_name ${image_name}
    if (${CACHE}) {
        docker build --no-cache -t ${image_name} -f ${dockerfile} .
    } else {
        docker build -t ${image_name} -f ${dockerfile} .
    }
}


Write-Host "build base image ..."
$IMAGE_NAME = (Split-Path $pwd -leaf)
build_image -image_name ${IMAGE_NAME} -dockerfile "Dockerfile"

docker image ls | Select-String "${IMAGE_NAME}"
Write-Host "finish ."