#!/usr/bin/env bash
set -euo pipefail

# Rufus-style dual-partition Windows USB creator for NixOS/Linux
# Idempotent mounts: handles ISO already mounted, cleans busy mountpoints, forces RW on NTFS.
# DANGER: This ERASES the target disk.

# ===== User settings =====
ISO="${1:-$HOME/Downloads/Win11_24H2_English_x64.iso}"
TARGET_DISK="${2:-/dev/sda}" # e.g., /dev/sda
EFI_LABEL="WINEFI"
NTFS_LABEL="WININSTALL"
EFI_SIZE_MB=512 # FAT32 ESP size

# ===== Helpers =====
need() { command -v "$1" >/dev/null 2>&1 || {
    echo "Missing: $1"
    return 1
}; }
mount_rw_test() {
    local mnt="$1"
    if touch "$mnt/.rwtest" 2>/dev/null; then
        rm -f "$mnt/.rwtest" 2>/dev/null || true
        return 0
    fi
    return 1
}
maybe_umount() { mountpoint -q "$1" && umount "$1" || true; }

# ===== Checks =====
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (sudo $0 [ISO] [/dev/sdX])"
    exit 1
fi

MISSING=0
for cmd in parted mkfs.vfat mkfs.ntfs wipefs lsblk mount umount rsync findmnt; do
    need "$cmd" || MISSING=1
done
if [[ "$MISSING" -eq 1 ]]; then
    echo "On NixOS, install permanently (choose one):\n  - Home Manager: home.packages = with pkgs; [ parted dosfstools ntfs3g rsync util-linux ]\n  - System-wide: environment.systemPackages = with pkgs; [ parted dosfstools ntfs3g rsync util-linux ]"
    exit 1
fi

[[ -f "$ISO" ]] || {
    echo "ISO not found: $ISO"
    exit 1
}
[[ -b "$TARGET_DISK" ]] || {
    echo "Not a block device: $TARGET_DISK"
    exit 1
}

BASENAME=$(basename "$TARGET_DISK")
if [[ -r "/sys/block/$BASENAME/ro" ]]; then
    RO_FLAG=$(cat "/sys/block/$BASENAME/ro" || echo 0)
    if [[ "$RO_FLAG" != "0" ]]; then
        echo "ERROR: Kernel sees $TARGET_DISK as READ-ONLY (ro=1). Check write-protect switch or dmesg for I/O errors."
        exit 1
    fi
fi

# Refuse if any partition is mounted
if mount | grep -qE "^$TARGET_DISK|^${TARGET_DISK}[0-9]"; then
    echo "Something on $TARGET_DISK is mounted. Unmount first."
    exit 1
fi

# Final confirmation
cat <<EOF
>>> About to ERASE $TARGET_DISK and flash $ISO
Type 'YES' to continue:
EOF
read -r CONFIRM
[[ "$CONFIRM" == "YES" ]] || {
    echo "Aborted."
    exit 1
}

# ===== Partition disk (GPT: FAT32 ESP + NTFS) =====
echo ">>> Wiping signatures..."
wipefs -a "$TARGET_DISK"

echo ">>> Creating GPT with FAT32 ESP + NTFS..."
parted -s "$TARGET_DISK" mklabel gpt
parted -s "$TARGET_DISK" mkpart primary fat32 1MiB "${EFI_SIZE_MB}MiB"
parted -s "$TARGET_DISK" set 1 esp on
parted -s "$TARGET_DISK" set 1 boot on
parted -s "$TARGET_DISK" mkpart primary ntfs "${EFI_SIZE_MB}MiB" 100%

EFI_PART="${TARGET_DISK}1"
NTFS_PART="${TARGET_DISK}2"

udevadm settle || true
sleep 1

# ===== Format =====
echo ">>> Formatting ${EFI_PART} as FAT32 (${EFI_LABEL})..."
mkfs.vfat -F 32 -n "$EFI_LABEL" "$EFI_PART"

echo ">>> Formatting ${NTFS_PART} as NTFS (${NTFS_LABEL})..."
mkfs.ntfs -f -L "$NTFS_LABEL" "$NTFS_PART"

# ===== Mounts =====
ISO_MNT="/mnt/iso"
EFI_MNT="/mnt/winusb/efi"
NTFS_MNT="/mnt/winusb/install"
mkdir -p "$EFI_MNT" "$NTFS_MNT" "$ISO_MNT"

# Handle ISO already mounted anywhere
MOUNTED_ISO=false
if findmnt -rn -S "$ISO" >/dev/null 2>&1; then
    ISO_MNT=$(findmnt -rn -S "$ISO" -o TARGET)
    echo ">>> Using already-mounted ISO at: $ISO_MNT"
else
    # If our ISO_MNT is busy with another source, unmount
    if mountpoint -q "$ISO_MNT"; then
        SRC=$(findmnt -rn -T "$ISO_MNT" -o SOURCE || true)
        echo ">>> /mnt/iso is mounted (source: $SRC). Unmounting to remount our ISO..."
        umount "$ISO_MNT"
    fi
    echo ">>> Mounting ISO..."
    mount -o loop,ro "$ISO" "$ISO_MNT"
    MOUNTED_ISO=true
fi

# Clean any stale mounts for target dirs
maybe_umount "$EFI_MNT"
maybe_umount "$NTFS_MNT"

echo ">>> Mounting target partitions (force RW)..."
mount -t vfat "$EFI_PART" "$EFI_MNT"
if ! mount -t ntfs3 -o rw,uid=0,gid=0,umask=022 "$NTFS_PART" "$NTFS_MNT" 2>/dev/null; then
    echo "ntfs3 mount failed or RO; trying ntfs-3g (FUSE)..."
    mount -t ntfs-3g -o rw,big_writes,uid=0,gid=0,umask=022 "$NTFS_PART" "$NTFS_MNT"
fi

# Double-check writeability
if ! mount_rw_test "$NTFS_MNT"; then
    echo "ERROR: NTFS is still read-only. Check dmesg for I/O errors. Aborting."
    exit 1
fi

# ===== Copy like Rufus (dual-partition) =====
echo ">>> Copying all files to NTFS (this can take a while)..."
rsync -aH --no-perms --no-owner --no-group --info=progress2 "$ISO_MNT"/ "$NTFS_MNT"/

echo ">>> Copying boot files to FAT32 (excluding /sources)..."
rsync -aH --no-perms --no-owner --no-group --info=progress2 --exclude='/sources/**' "$ISO_MNT"/ "$EFI_MNT"/

# ===== Flush & unmount =====
echo ">>> Syncing..."
sync

echo ">>> Unmounting..."
umount "$EFI_MNT" || true
umount "$NTFS_MNT" || true
if [[ "$MOUNTED_ISO" == true ]]; then
    umount "$ISO_MNT" || true
fi

rmdir "$EFI_MNT" "$NTFS_MNT" "$ISO_MNT" 2>/dev/null || true

echo ">>> Done!"
echo "Reboot and select the USB from your UEFI boot menu (disable CSM/Legacy if needed)."
