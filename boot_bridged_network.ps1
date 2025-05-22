
# boot_bridged_network.ps1
# Requires OpenVPN TAP driver and "tap0" interface

$qemuSystem = "qemu-system-ppc64"
$diskPath = "C:\AIX\aix_disk.qcow2"

& $qemuSystem `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file=$diskPath,if=none,id=drive-virtio-disk0 `
  -device virtio-scsi-pci,id=scsi `
  -device scsi-hd,drive=drive-virtio-disk0 `
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no `
  -device spapr-vlan,netdev=net0,mac=52:54:00:12:34:56 `
  -boot c `
  -nographic
