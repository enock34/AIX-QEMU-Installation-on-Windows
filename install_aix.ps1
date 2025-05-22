
# install_aix.ps1
# Run this to begin AIX installation

$qemuSystem = "qemu-system-ppc64"
$aixIso = "C:\AIX\AIX_Install_DVD_1of2.iso"
$diskPath = "C:\AIX\aix_disk.qcow2"

& $qemuSystem `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file=$diskPath,if=none,id=drive-disk0,format=qcow2 `
  -device spapr-vscsi,id=scsi0 `
  -device scsi-hd,drive=drive-disk0,bus=scsi0.0 `
  -cdrom $aixIso `
  -boot d `
  -nographic
