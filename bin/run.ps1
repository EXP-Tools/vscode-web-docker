#------------------------------------------------
# ���� docker ����
#------------------------------------------------
# ����ִ��ʾ����
# ./run.ps1 -p "123456"
#------------------------------------------------
# ./run.ps1
#           [-a ${AUTH_PASSWORD}]            # ǰ����֤����
#           [-p ${SUDO_PASSWORD}]            # �����Ȩ����
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
