
# boot_nat_network.ps1
# NAT setup for SSH access via port 2222

$qemuSystem = "qemu-system-ppc64"
$diskPath = "C:\AIX\aix_disk.qcow2"

& $qemuSystem `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file=$diskPath,if=none,id=drive-disk0 `
  -device virtio-scsi-pci,id=scsi `
  -device scsi-hd,drive=drive-disk0 `
  -netdev user,id=net0,hostfwd=tcp::2222-:22 `
  -device spapr-vlan,netdev=net0,mac=52:54:00:12:34:56 `
  -boot c `
  -nographic
