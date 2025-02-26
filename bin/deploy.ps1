# PowerShell
# ------------------------
# �������񣨲����������������й���ͨ�ýű���
# bin/deploy.ps1 [-n NAMESPACE] [-v VERSION] [-b] [-p] [-u ${proxy}]
#   -n docker hub �������ռ�
#   -v ����汾��
#   -b �Ƿ񷢲���������
#   -p �Ƿ����ô���
#   -u �����ַ��ֻ֧�� http��
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
    Write-Host "���������ã���ַΪ��$PROXY" -ForegroundColor Green
} else {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Write-Host "�����ѽ���" -ForegroundColor Yellow
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