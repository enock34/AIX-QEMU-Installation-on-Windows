# AIX-QEMU-Installation-on-Windows
Guide to install and run AIX on QEMU with networking and SSH access, On Windows 11
# 📄 Installing AIX on QEMU (Windows Guide using PowerShell)

## 📅 Step 1: Download and Install QEMU

1. Visit: [https://qemu.weilnetz.de/w64/](https://qemu.weilnetz.de/w64/)
2. Download the latest QEMU Windows installer and install it.

---

## ⚙️ Step 2: Set QEMU Path in Environment Variables

### Purpose:

So you can run QEMU commands from any terminal.

### Steps:

1. Press **Win + S**, search "**Environment Variables**" and open it.
2. Under **System Variables**, find and select `Path`, then click **Edit**.
3. Click **New** and add your QEMU path, for example:


   ```
   C:\Program Files\qemu
   ```
4. Repeat under **User Variables** if necessary.
5. Click **OK**, then restart PowerShell.
6. Confirm with:

   ```powershell
   qemu-system-ppc64 --version
   ```

---

## 📀 Step 3: Create AIX Disk Image

```powershell
qemu-img create -f qcow2 aix_disk.qcow2 30G
```

Creates a 30GB virtual disk using the QCOW2 format.

---

## 💽 Step 4: Install AIX Using ISO

Make sure the AIX ISO path is correct.

```powershell
qemu-system-ppc64 `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file="C:\AIX\aix_disk.qcow2",if=none,id=drive-disk0,format=qcow2 `
  -device spapr-vscsi,id=scsi0 `
  -device scsi-hd,drive=drive-disk0,bus=scsi0.0 `
  -cdrom "C:\AIX\AIX_Install_DVD_1of2.iso" `
  -boot d `
  -nographic
```

* `-boot d`: Boot from DVD ISO.
* `-nographic`: Console output in terminal.

---

## 📡 Step 5: Configure Networking (NAT with Port Forwarding)

```powershell
qemu-system-ppc64 `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file="C:\AIX\aix_disk.qcow2",if=none,id=drive-disk0 `
  -device virtio-scsi-pci,id=scsi `
  -device scsi-hd,drive=drive-disk0 `
  -netdev user,id=net0,hostfwd=tcp::2222-:22 `
  -device spapr-vlan,netdev=net0,mac=52:54:00:12:34:56 `
  -boot c `
  -nographic
```

* SSH from host: `ssh root@localhost -p 2222`

---

## 🧠 Step 6: Configure IP in AIX

Inside AIX:

```bash
smitty tcpip
```

* Set a static IP, subnet mask, and gateway.

---

## 🔌 Step 7: Install OpenVPN GUI (for Bridged TAP Networking)

1. Download and install from: [https://openvpn.net/community-downloads/](https://openvpn.net/community-downloads/)
2. Rename the TAP adapter:

   ```powershell
   Get-NetAdapter
   Rename-NetAdapter -Name "Ethernet x" -NewName "tap0"
   ```
3. Assign a static IP to the adapter:

   ```powershell
   New-NetIPAddress -InterfaceAlias "tap0" -IPAddress 192.168.100.1 -PrefixLength 24
   ```

---

## 🚀 Step 8: Boot AIX with Bridged Networking

```powershell
qemu-system-ppc64 `
  -machine pseries `
  -cpu POWER8 `
  -m 4096 `
  -drive file="C:\AIX\aix_disk.qcow2",if=none,id=drive-virtio-disk0 `
  -device virtio-scsi-pci,id=scsi `
  -device scsi-hd,drive=drive-virtio-disk0 `
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no `
  -device spapr-vlan,netdev=net0,mac=52:54:00:12:34:56 `
  -boot c `
  -nographic
```

Test SSH:

```powershell
ssh root@192.168.100.50
```

Start SSH daemon in AIX if not running:

```bash
startsrc -s sshd
```

---

## ⚡ Optional: Resize AIX Disk

To add 10GB:

```powershell
qemu-img resize "C:\AIX\aix_disk.qcow2" +10G
```

Inside AIX:

1. Run `bootinfo -s hdisk0` to confirm size.
2. Use `smitty lv` to expand logical volumes.
3. Use `chfs` to extend filesystems.

---

## 🚀 Done!

You now have AIX running inside QEMU with networking and SSH access. You can automate this setup further or publish a preconfigured `.ps1` startup script.

> **Tip:** Add this project as a GitHub repository with a descriptive README and include sample PowerShell scripts in a `/scripts` folder for reuse.

---

Let me know if you want the Markdown version for GitHub `README.md`!
