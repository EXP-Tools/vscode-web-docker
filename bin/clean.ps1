# Powershell
#------------------------------------------------
# ��������־�������������������й���ͨ�ýű���
# bin/clean.ps1
#------------------------------------------------

$IMAGE_NAME = (Split-Path $pwd -leaf)

# Write-Host "clean logs ..."
# Remove-Item -Recurse -Force logs

Write-Host "clean images ..."
docker images | Select-String "${IMAGE_NAME}" | ForEach-Object { docker rmi -f $_.ToString().Split(" ")[2] }
docker images | Select-String "none" | ForEach-Object { docker rmi -f $_.ToString().Split(" ")[2] }
docker images --filter "dangling=true" -q | ForEach-Object { docker rmi -f $_ }

Write-Host "finish ."
