# Powershell
#------------------------------------------------
# ֹͣ docker ���񣨲����������������й���ͨ�ýű���
# bin/stop.ps1
#       [--keepdb]      # ��ѡ����: ���� DB ����ֹͣ
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
