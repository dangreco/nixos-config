#!/bin/sh

# !!! MAKE SURE TO SET LUKS_PASSWORD !!!

DISK="nvme0n1"

# Partition the disk
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" -- set 1 boot on
parted "$DISK" -- mkpart primary 512MiB 100%

# Setup LUKS encryption
echo -n "$LUKS_PASSWORD" | cryptsetup luksFormat "${DISK}p2" --key-file=-
echo -n "$LUKS_PASSWORD" | cryptsetup luksOpen "${DISK}p2" crypted --key-file=-

# Setup LVM
pvcreate /dev/mapper/crypted
vgcreate vg /dev/mapper/crypted
lvcreate -L 32G -n swap vg
lvcreate -l '100%FREE' -n nixos vg

# Format disks
mkfs.fat -F 32 -n boot "${DISK}p1"
mkfs.ext4 -L nixos /dev/vg/nixos
mkswap -L swap /dev/vg/swap

# Mount disks
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=0077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/vg/swap

# Generate base config
nixos-generate-config --root /mnt

# Back it up
mv /mnt/etc/nixos /mnt/etc/nixos.ref

# Add our config
git clone https://github.com/dangreco/nixos-config.git
mv nixos-config /mnt/etc/nixos

# Use new hardware-configuration
mv /mnt/etc/nixos/hosts/sake/hardware-configuration.nix /mnt/etc/nixos/hosts/sake/hardware-configuration.old.nix
cp /mnt/etc/nixos.ref/hardware-configuration.nix /mnt/etc/nixos/hosts/sake/hardware-configuration.nix