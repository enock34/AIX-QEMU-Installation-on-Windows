
# create_disk.ps1
# Run in PowerShell to create a 30GB AIX disk image

$qemuImg = "qemu-img"
$diskPath = "C:\AIX\aix_disk.qcow2"

& $qemuImg create -f qcow2 $diskPath 30G
Write-Host "Disk image created at $diskPath"
