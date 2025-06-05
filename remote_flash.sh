#!/bin/bash

SSH="ssh root@169.254.8.1"

show_warning () {
  clear
  echo "This Installs LeapDroid on your Leapster/LeapPad!"
  echo
  echo "WARNING! This utility will ERASE the stock LeapFrog OS and any other"
  echo "data on the device. The device can be restored to stock settings using"
  echo "the LeapFrog Connect app. Note that flashing your device will likely"
  echo "VOID YOUR WARRANTY! Proceed at your own risk."
  echo
  echo "Please power off your device, and do the following -"
  echo
  echo "Leapster Explorer - Hold the L + R shoulder buttons AND the Hint (?) button whilst powering on"
  echo "Leapster GS - Hold the L + R shoulder buttons whilst powering on "
  echo "LeapPad - Hold the Right arrow + Home buttons AND the Volume Down button whilst powering on."
  echo
  echo "You should see a screen with a green or blue background and a picture of the device"
  echo "connecting to a computer."
  read -p "Press ENTER when you're ready to continue."
}

show_machinelist () {
  echo "----------------------------------------------------------------"
  echo "What type of system would you like to flash?"
  echo
  echo "1. LF1000 (Leapster Explorer, Didj, LeapPad Explorer)"
  echo "2. LF2000 (Leapster GS, LeapPad 2, LeapPad Ultra, LeapPad Ultra XDI)"
  echo "3. LF3000 (LeapPad 3, LeapPad Platinum)"
}

boot_surgeon () {
  surgeon_path=$1
  memloc=$2
  echo "Booting the Surgeon environment..."
  python make_cbf.py $memloc $surgeon_path surgeon_tmp.cbf
  python boot_surgeon.py surgeon_tmp.cbf
  echo -n "Done! Waiting for Surgeon to come up..."
  rm -rf surgeon_tmp.cbf
  sleep 15
  echo "Done!"
}

nand_part_detect () {
  KERNEL_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"Kernel\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  RFS_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"RFS\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  Bulk_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"Bulk\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  echo "Detected Kernel partition=$KERNEL_PARTITION RFS Partition=$RFS_PARTITION Bulk Partition=$Bulk_PARTITION"
}

nand_flash_kernel () {
  kernel_path=$1
  echo -n "Flashing the kernel..."
  ${SSH} "/usr/sbin/flash_erase $KERNEL_PARTITION 0 0"
  cat $kernel_path | ${SSH} "/usr/sbin/nandwrite -p $KERNEL_PARTITION -"
  echo "Done flashing the kernel!"
}

nand_flash_bulk () {
  bulk_path=$1
  echo -n "Flashing the root filesystem..."
  ${SSH} "/usr/sbin/ubiformat -y $Bulk_PARTITION"
  ${SSH} "/usr/sbin/ubiattach -p $Bulk_PARTITION"
  sleep 1
  ${SSH} "/usr/sbin/ubimkvol /dev/ubi0 -N Bulk -m"
  sleep 1
  ${SSH} "mount -t ubifs /dev/ubi0_0 /mnt/root"
  echo "Writing rootfs image..."  
  cat $bulk_path | ${SSH} "gunzip -c | tar x -f '-' -C /mnt/root"
  ${SSH} "umount /mnt/root"
  ${SSH} "/usr/sbin/ubidetach -d 0"
  echo "Done flashing the root filesystem!"
}

flash_nand () {
  prefix=$1
  if [[ $prefix == lf1000_* ]]; then
	  rootfs="lf1000_rootfs.tar.gz"
	  memloc="high"
	  kernel="zImage_tmp.cbf"
	  python make_cbf.py $memloc ${prefix}zImage $kernel
  else
	  rootfs="rootfs.tar.gz"
	  memloc="superhigh"
	  kernel=${prefix}uImage
  fi
  boot_surgeon ${prefix}surgeon_zImage $memloc
  ${SSH} -o "StrictHostKeyChecking no" 'test'
  nand_part_detect
  nand_flash_kernel $kernel
  nand_flash_bulk $rootfs
  echo "Done! Rebooting your LeapFrog Device."
  ${SSH} "(echo 1 >/proc/sys/kernel/sysrq) && (echo b >/proc/sysrq-trigger)"
}

mmc_flash_kernel () {
  kernel_path=$1
  echo -n "Flashing the kernel..."
  ${SSH} "mkdir /mnt/boot"
  ${SSH} "mount /dev/mmcblk0p2 /mnt/boot"
  cat $kernel_path | ${SSH} "cat - > /mnt/boot/uImage"
  ${SSH} "umount /dev/mmcblk0p2"
  echo "Done flashing the kernel!"
}

mmc_flash_bulk () {
  bulk_path=$1
  echo -n "Flashing the root filesystem..."
  ${SSH} "/sbin/mkfs.ext4 -F -L Bulk -O ^metadata_csum /dev/mmcblk0p4"
  ${SSH} "mkdir /mnt/root"
  ${SSH} "mount -t ext4 /dev/mmcblk0p4 /mnt/root"
  echo "Writing rootfs image..."  
  cat $bulk_path | ${SSH} "gunzip -c | tar x -f '-' -C /mnt/root"
  ${SSH} "umount /mnt/root"
  echo "Done flashing the root filesystem!"
}

flash_mmc () {
  prefix=$1
  boot_surgeon ${prefix}surgeon_zImage superhigh
  ${SSH} -o "StrictHostKeyChecking no" 'test'
  mmc_flash_kernel ${prefix}uImage
  mmc_flash_bulk rootfs.tar.gz
  echo "Done! Rebooting your LeapFrog Device."
  ${SSH} "(echo 1 >/proc/sys/kernel/sysrq) && (echo b >/proc/sysrq-trigger)"
}

show_warning
prefix=$1
if [ -z "$prefix" ]
then
  show_machinelist
  read -p "Enter choice (1 - 3)" choice
  case $choice in
    1) prefix="lf1000_" ;;
    2) prefix="lf2000_" ;;
    3) prefix="lf3000_" ;;
    *) echo -e "Unknown choice!" && exit 1
  esac
fi

if [ $prefix == "lf3000_" ]; then
	flash_mmc $prefix
else
	flash_nand $prefix
fi
