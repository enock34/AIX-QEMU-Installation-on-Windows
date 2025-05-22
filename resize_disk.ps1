
# resize_disk.ps1
# Resize the AIX disk image by +10G

$qemuImg = "qemu-img"
$diskPath = "C:\AIX\aix_disk.qcow2"

& $qemuImg resize $diskPath +10G
Write-Host "Disk resized by +10G"
