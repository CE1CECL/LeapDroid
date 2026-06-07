#!/bin/bash

SSH="ssh root@169.254.8.1"

show_warning () {
  clear
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
  echo "What type of system are you using?"
  echo
  echo "1. LF1000 (Didj, Leapster Explorer, LeapPad Explorer)"
  echo "2. LF2000 (Leapster GS, LeapPad 2, LeapPad Ultra, LeapPad Ultra XDI)"
  echo "3. LF3000 (Currently Unsupported)"
}

boot_surgeon () {
  surgeon_path=$1
  memloc=$2
  echo "Booting the Surgeon environment..."
  python make_cbf.py $memloc $surgeon_path surgeon_tmp.cbf || python3 make_cbf.py $memloc $surgeon_path surgeon_tmp.cbf || python2 make_cbf.py $memloc $surgeon_path surgeon_tmp.cbf
  python boot_surgeon.py surgeon_tmp.cbf || python3 boot_surgeon.py surgeon_tmp.cbf || python2 boot_surgeon.py surgeon_tmp.cbf
  echo "Done! Waiting for Surgeon to come up..."
  rm -rf surgeon_tmp.cbf
  sleep 20
  echo "Done!"
}

test_detect () {
  ${SSH} -o "StrictHostKeyChecking no" "test"
  if [[ $? != 1 ]]; then
    test_detect
  fi
}

part_detect () {
  KERNEL_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"Kernel\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  RFS_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"RFS\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  Bulk_PARTITION=`${SSH} "awk -e '\\$4 ~ /\"Bulk\"/ {print \"/dev/\" substr(\\$1, 1, length(\\$1)-1)}' /proc/mtd"`
  echo "Detected Kernel Partition=$KERNEL_PARTITION RFS Partition=$RFS_PARTITION Bulk Partition=$Bulk_PARTITION"
}

nand () {
  prefix=$1
  if [[ $prefix == lf1000_* ]]; then
	  rootfs="lf1000_rootfs${RFSVER}.tar.gz"
	  memloc="high"
	  kernel="zImage_tmp.cbf"
	  python make_cbf.py $memloc ${prefix}zImage $kernel || python3 make_cbf.py $memloc ${prefix}zImage $kernel || python2 make_cbf.py $memloc ${prefix}zImage $kernel
  else
	  rootfs="rootfs${RFSVER}.tar.gz"
	  memloc="superhigh"
	  kernel=${prefix}uImage
  fi
  boot_surgeon ${prefix}surgeon_zImage $memloc
  test_detect
  part_detect
  ${SSH}
  echo "Done! Rebooting your LeapFrog Device."
  ${SSH} "reboot -f"
}

mmc () {
  prefix=$1
  boot_surgeon ${prefix}surgeon_zImage superhigh
  test_detect
  ${SSH}
  echo "Done! Rebooting your LeapFrog Device."
  ${SSH} "reboot -f"
}

show_warning
show_machinelist
read -p "Enter choice (1 - 3)" choice
case $choice in
  1) prefix="lf1000_" ;;
  2) prefix="lf2000_" ;;
  3) prefix="lf3000_" ;;
  *) echo "Unknown choice!" && exit 1
esac

if [ $prefix == "lf3000_" ]; then
	mmc $prefix
else
	nand $prefix
fi
