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

$AUTH_PASSWORD = $p
$SUDO_PASSWORD = $p
$U_ID = 1000
$G_ID = 1000


# ������ BUG�� auth_password �� sudo_password �������ˣ�ֱ��ʹ��ͬһ��
$ENV:auth_password=${SUDO_PASSWORD}; `
$ENV:sudo_password=${SUDO_PASSWORD}; `
$ENV:uid=${U_ID}; `
$ENV:gid=${G_ID}; `
docker-compose up -d

# ����������
Start-Sleep -Seconds 5

# ��ʼ������������Ĭ�ϻ��� /etc/sudoers ׷��һ�� abc �˺ŵ� sudo ���ã���Ҫ sudo ���룩
# ���� /etc/sudoers.d/abc �����ò���Ч������Ҫ sudo ���룩
# ����ű������þ���ɾ��׷�ӵ�����
# ע�� ���������д�� Dockerfile ��������Ч��ԭ����׷�Ӷ������ھ��񹹽����֮��
$DOCKER_ID = docker ps -aq --filter "name=docker_vscode_web"
if ($DOCKER_ID) {
    docker exec -u root $DOCKER_ID /bin/bash -c "chmod a+w /etc/sudoers && sed -e /^abc/d /etc/sudoers > /tmp/sudoers.bak && cat /tmp/sudoers.bak > /etc/sudoers && rm -f /tmp/sudoers.bak && chmod a-w /etc/sudoers"
}