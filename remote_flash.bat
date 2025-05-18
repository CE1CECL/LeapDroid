@echo off

rem *** sshflash-win ***
rem A fork of sshflash for Windows, by andymcca.  sshflash originally by mac2612 (https://github.com/mac2612/sshflash).
rem
rem
rem Keys Information -
rem 
rem As of version 0.3, keys are no longer used to connect via SSH.
rem This reflects the upcoming change in retroleap to remove key-based access, as the RSA standard is deprecated and this was causing issues with flashing.
SET SSH=ssh root@169.254.8.1

rem Fix the permissions on the "private key" , so ssh does not complain.
rem sshflash-win - Not required on Windows so is commented out here.
rem chmod 700 keys\id_rsa

call :show_warning
SET prefix=%~1
call :show_machinelist
echo Enter choice (1 - 3)
SET /P REPLY=
if /I "%REPLY%" == "1" (SET prefix="lf1000_")
if /I "%REPLY%" == "2" (SET prefix="lf2000_")
if /I "%REPLY%" == "3" (SET prefix="lf3000_")
timeout /t 2

IF /I "%prefix%" == "lf3000_" (call :flash_mmc "%prefix%") ELSE (call :flash_nand "%prefix%")
EXIT /B %ERRORLEVEL%


:show_warning
cls
echo sshflash-win
echo Installs a custom OS on your LeapPad/Leapster!
echo(
echo WARNING! This utility will ERASE the stock leapster OS and any other
echo data on the device. The device can be restored to stock settings using
echo the LeapFrog Connect app. Note that flashing your device will likely
echo VOID YOUR WARRANTY! Proceed at your own risk.
echo(
echo Please power off your device, and do the following -
echo(
echo Leapster Explorer - Hold the L + R shoulder buttons AND the Hint (?) button whilst powering on
echo Leapster GS - Hold the L + R shoulder buttons whilst powering on 
echo LeapPad - Hold the Right arrow + Home buttons AND the Volume Down button whilst powering on.
echo(
echo You should see a screen with a green or blue background and a picture of the device
echo connecting to a computer.
pause
EXIT /B 0

:show_machinelist
echo ----------------------------------------------------------------
echo What type of system would you like to flash?
echo(
echo 1. LF1000 (Leapster Explorer, Didj, LeapPad Explorer)
echo 2. LF2000 (Leapster GS, LeapPad 2, LeapPad Ultra, LeapPad Ultra XDI)
echo 3. LF3000 (LeapPad 3, LeapPad Platinum)
EXIT /B 0

:boot_surgeon
  SET surgeon_path=%~1
  SET memloc=%~2
  echo Booting the Surgeon environment...
  python make_cbf.py %memloc:"=% %surgeon_path:"=% surgeon_tmp.cbf
  echo Lines to write (should be a whole number) -
  python boot_surgeon.py surgeon_tmp.cbf
  echo Done! Waiting for Surgeon to come up...
  DEL /F surgeon_tmp.cbf
  timeout /t 15
  echo Done!
EXIT /B 0

:nand_part_detect
  rem Probe for filesystem partition locations, they can vary based on kernel version + presence of NOR flash drivers.
  rem TODO- Make the escaping less yucky...

  SET SPACE=" "
  SET KP=awk -e '$4 ~ \"Kernel\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  rem SET "var=%SSH%%SPACE:"=%%KP%"
  rem echo %SSH:"=% "%KP%"
  FOR /f %%i in ('%SSH:"=% "%KP%"') do set "KERNEL_PARTITION=%%i"

  SET RP=awk -e '$4 ~ \"RFS\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  SET "var=%SSH%%SPACE:"=%%RP%"
  FOR /f %%i in ('%SSH:"=% "%RP%"') do set "RFS_PARTITION=%%i"

  SET BP=awk -e '$4 ~ \"Bulk\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  SET "var=%SSH%%SPACE:"=%%BP%"
  echo %SSH:"=% "%BP%"
  FOR /f %%i in ('%SSH:"=% "%BP%"') do set "BULK_PARTITION=%%i"

  echo "Detected Kernel partition=%KERNEL_PARTITION% RFS Partition=%RFS_PARTITION% Bulk Partition=%BULK_PARTITION%"
EXIT /B 0

:nand_flash_kernel
  SET kernel_path=%~1
  echo(
  echo "Flashing the kernel...(%kernel_path%)
  %SSH% "/usr/sbin/flash_erase %KERNEL_PARTITION% 0 0"
  type %kernel_path% | %SSH% "/usr/sbin/nandwrite -p" %KERNEL_PARTITION% "-"
  echo Done flashing the kernel!
EXIT /B 0

:nand_flash_bulk
  SET bulk_path=%~1
  echo Flashing the root filesystem...
  %SSH% "/usr/sbin/ubiformat -y %BULK_PARTITION%"
  %SSH% "/usr/sbin/ubiattach -p %BULK_PARTITION%"
  timeout /t 1
  %SSH% "/usr/sbin/ubimkvol /dev/ubi0 -N Bulk -m"
  timeout /t 1
  %SSH% "mount -t ubifs /dev/ubi0_0 /mnt/root"
  echo Writing rootfs image...

  rem Note: We used to use a ubifs image here, but now use a .tar.gz.
  rem This removes the need to care about PEB/LEB sizes at build time,
  rem which is important as some LF2000 models Ultra XDi have differing sizes.

  type %bulk_path% | %SSH% "gunzip -c | tar x -f '-' -C /mnt/root"
  %SSH% "umount /mnt/root"
  %SSH% "/usr/sbin/ubidetach -d 0"
  timeout /t 3
  echo(
  echo Done flashing the root filesystem!
EXIT /B 0

:nand_wipe_rfs
  %SSH% "/usr/sbin/ubiformat %RFS_PARTITION%"
  %SSH% "/usr/sbin/ubiattach -p %RFS_PARTITION%"
  timeout /t 1
  %SSH% "/usr/sbin/ubimkvol /dev/ubi0 -m -N RFS")
  timeout /t 1
  %SSH% "/usr/sbin/ubidetach -d 0"
  %SSH% "/usr/sbin/ubidetach -d 0"
  timeout /t 3
EXIT /B 0

:flash_nand
  SET prefix=%~1
  if /I %prefix:"=% == lf1000_ (set memloc="high") else (set memloc="superhigh")
  if /I %prefix:"=% == lf1000_ (set kernel="zImage_tmp.cbf") else (set kernel="%prefix:"=%uImage")
  if /I %prefix:"=% == lf1000_ (python make_cbf.py %memloc:"=% %prefix:"=%zImage %kernel:"=%)
  rem echo Debugging info - 
  rem echo(
  rem echo %memloc:"=%
  rem echo %prefix:"=%zImage
  rem echo %kernel:"=%
  rem echo(
  rem pause

  call :boot_surgeon %prefix:"=%surgeon_zImage %memloc:"=%
  rem For the first ssh command, skip hostkey checking to avoid prompting the user.
  %SSH% -o "StrictHostKeyChecking no" 'test'
  call :nand_part_detect
  call :nand_flash_kernel %kernel:"=%
  call :nand_flash_bulk rootfs.tar.gz
  call :nand_wipe_rfs 
  echo Done! Rebooting the host.
  %SSH% '(echo 1 >/proc/sys/kernel/sysrq) && (echo b >/proc/sysrq-trigger)'
EXIT /B 0

:mmc_flash_kernel
  SET kernel_path=%~1
  echo Flashing the kernel...
  rem TODO: This directory structure should be included in surgeon images.
  %SSH% "mkdir /mnt/boot"
  rem TODO: This assumes a specific partition layout - not sure if this is the case for all devices?
  %SSH% "mount /dev/mmcblk0p2 /mnt/boot"
  type %kernel_path% | %SSH% "cat - > /mnt/boot/uImage"
  %SSH% "umount /dev/mmcblk0p2"
  echo Done flashing the kernel!
EXIT /B 0

:mmc_flash_bulk
  SET bulk_path=%~1
  rem Size of the rootfs to be flashed, in bytes.
  echo Flashing the root filesystem...
  %SSH% "/sbin/mkfs.ext4 -F -L Bulk -O ^metadata_csum /dev/mmcblk0p4"
  rem TODO: This directory structure should be included in surgeon images.
  %SSH% "mkdir /mnt/root"
  %SSH% "mount -t ext4 /dev/mmcblk0p4 /mnt/root"
  echo Writing rootfs image... 
  type %bulk_path% | %SSH% "gunzip -c | tar x -f '-' -C /mnt/root"
  %SSH% "umount /mnt/root"
  echo Done flashing the root filesystem!
EXIT /B 0

:mmc_wipe_rfs
  %SSH% "/sbin/mkfs.ext4 -F -L RFS -O ^metadata_csum /dev/mmcblk0p3"
EXIT /B 0

:flash_mmc
  SET prefix=%~1
  call : boot_surgeon %prefix%surgeon_zImage superhigh
  rem For the first ssh command, skip hostkey checking to avoid prompting the user.
  %SSH% -o "StrictHostKeyChecking no" 'test'
  call :mmc_flash_kernel %prefix%uImage
  call :mmc_flash_bulk rootfs.tar.gz
  call :mmc_wipe_rfs
  echo(
  echo Done! Rebooting the host.
  %SSH% '(echo 1 >/proc/sys/kernel/sysrq) && (echo b >/proc/sysrq-trigger)'
EXIT /B 0
