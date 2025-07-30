@echo off

SET SSH=ssh root@169.254.8.1

call :show_warning
call :show_machinelist
echo Enter choice (1 - 3)
SET /P REPLY=
if /I "%REPLY%" == "1" (
	set prefix="lf1000_"
	call :flash_nand "lf1000_"
) else if /I "%REPLY%" == "2" (
	set prefix="lf2000_"
	call :flash_nand "lf2000_"
) else if /I "%REPLY%" == "3" (
	set prefix="lf3000_"
	call :flash_mmc "lf3000_"
) else (
	echo Unknown choice!
	pause
	EXIT /B 1
)
EXIT /B %ERRORLEVEL%


:show_warning
cls
echo This Installs LeapDroid on your Leapster/LeapPad!
echo(
echo WARNING! This utility will ERASE the stock LeapFrog OS and any other
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
echo 1. LF1000 (Didj, Leapster Explorer, LeapPad Explorer)
echo 2. LF2000 (Leapster GS, LeapPad 2, LeapPad Ultra, LeapPad Ultra XDI)
echo 3. LF3000 (Currently Unsupported)
EXIT /B 0

:boot_surgeon
  SET surgeon_path=%~1
  SET memloc=%~2
  echo Booting the Surgeon environment...
  python make_cbf.py %memloc:"=% %surgeon_path:"=% surgeon_tmp.cbf || make_cbf.exe %memloc:"=% %surgeon_path:"=% surgeon_tmp.cbf
  python boot_surgeon.py surgeon_tmp.cbf || boot_surgeon.exe surgeon_tmp.cbf
  echo Done! Waiting for Surgeon to come up...
  DEL /F surgeon_tmp.cbf
  TIMEOUT /NOBREAK /T 20
  echo Done! Make Sure You Configure Your Device's IP Address to "169.254.8.10"!
  control ncpa.cpl
  pause
EXIT /B 0

:nand_part_detect
  SET SPACE=" "
  SET KP=awk -e '$4 ~ \"Kernel\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  FOR /f %%i in ('%SSH:"=% "%KP%"') do set "KERNEL_PARTITION=%%i"

  SET RP=awk -e '$4 ~ \"RFS\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  SET "var=%SSH%%SPACE:"=%%RP%"
  FOR /f %%i in ('%SSH:"=% "%RP%"') do set "RFS_PARTITION=%%i"

  SET BP=awk -e '$4 ~ \"Bulk\"  {print \"/dev/\" substr($1, 1, length($1)-1)}' /proc/mtd
  SET "var=%SSH%%SPACE:"=%%BP%"
  FOR /f %%i in ('%SSH:"=% "%BP%"') do set "BULK_PARTITION=%%i"

  echo "Detected Kernel Partition=%KERNEL_PARTITION% RFS Partition=%RFS_PARTITION% Bulk Partition=%BULK_PARTITION%"
EXIT /B 0

:nand_flash_kernel
  SET kernel_path=%~1
  echo(
  echo "Flashing the kernel...(%kernel_path%)
  %SSH% "flash_erase %KERNEL_PARTITION% 0 0"
  type %kernel_path% | %SSH% "nandwrite -p" %KERNEL_PARTITION% "-"
  echo Done flashing the kernel!
EXIT /B 0

:nand_flash_bulk
  SET bulk_path=%~1
  echo Flashing the root filesystem...
  %SSH% "ubiformat -y %BULK_PARTITION%"
  %SSH% "ubiattach -p %BULK_PARTITION%"
  %SSH% "ubimkvol /dev/ubi0 -N Bulk -m"
  %SSH% "mkdir -p /mnt/bulk"
  %SSH% "mount -t ubifs /dev/ubi0_0 /mnt/bulk"
  echo Writing rootfs image...
  type %bulk_path% | %SSH% "tar -zxvf '-' -C /mnt/bulk"
  if /I %prefix:"=% == lf2000_ (
    %SSH% mkdir -p /mnt/rfs
    %SSH% ubiattach -p $RFS_PARTITION
    %SSH% mount -t ubifs -o ro /dev/ubi1_0 /mnt/rfs
    %SSH% mount -o rbind /dev /mnt/rfs/dev
    %SSH% mount -o rbind /sys /mnt/rfs/sys
    %SSH% mount -o rbind /proc /mnt/rfs/proc
    ${SSH} 'chroot /mnt/rfs /usr/bin/mfgdata get tsp > "/mnt/bulk/init.nxp3200.sh"
    ${SSH} 'sed -i "s/#!\/bin\/sh/#!\/system\/bin\/sh/g" "/mnt/bulk/init.nxp3200.sh"
    ${SSH} 'echo "on init" > "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    write /sys/devices/platform/lf2000-touchscreen/pointercal \"$(chroot /mnt/rfs /usr/bin/mfgdata get ts)\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    exec \"/init.nxp3200.sh\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    write /sys/devices/platform/lf2000-aclmtr/calibration \"$(chroot /mnt/rfs /usr/bin/mfgdata get aclcal)\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    write /sys/devices/platform/lf2000-power/adc_constant \"$(chroot /mnt/rfs /usr/bin/mfgdata get adc | cut -d ' ' -f 1)\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    write /sys/devices/platform/lf2000-power/adc_slope_256 \"$(chroot /mnt/rfs /usr/bin/mfgdata get adc | cut -d ' ' -f 2)\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'echo "    write /sys/devices/platform/lf2000-touchscreen/tails \"$(if [ $(chroot /mnt/rfs /usr/bin/mfgdata get tsp | grep "Version=" | cut -d = -f 2) -lt 4 ]; then echo "1"; else echo "0"; fi)\"" >> "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'chown 0:0 "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'chown 0:0 "/mnt/bulk/init.nxp3200.sh"
    ${SSH} 'chmod 0777 "/mnt/bulk/init.nxp3200.rc"
    ${SSH} 'chmod 0777 "/mnt/bulk/init.nxp3200.sh"
  )
  %SSH% "chown -R 0:0 /mnt/bulk"
  %SSH% "chmod -R 7777 /mnt/bulk"
  %SSH% "umount /mnt/bulk"
  %SSH% "ubidetach -d 0"
  echo(
  echo Done flashing the root filesystem!
EXIT /B 0

:flash_nand
  SET prefix=%~1
  if /I %prefix:"=% == lf1000_ (
    set memloc="high"
  ) else (
    set memloc="superhigh"
  )
  if /I %prefix:"=% == lf1000_ (
    set kernel="zImage_tmp.cbf"
  ) else (
    set kernel="%prefix:"=%uImage"
  )
  if /I %prefix:"=% == lf1000_ (
    python make_cbf.py %memloc:"=% %prefix:"=%zImage %kernel:"=% || ^
    make_cbf.exe %memloc:"=% %prefix:"=%zImage %kernel:"=%
  )
  if /I %prefix:"=% == lf1000_ (
    set rootfs="lf1000_rootfs.tar.gz"
  ) else (
    set rootfs="rootfs.tar.gz"
  )
  call :boot_surgeon %prefix:"=%surgeon_zImage %memloc:"=%
  %SSH% -o "StrictHostKeyChecking no" 'test'
  call :nand_part_detect
  call :nand_flash_kernel %kernel:"=%
  call :nand_flash_bulk %rootfs:"=%
  echo Done! Rebooting your LeapFrog Device.
  %SSH% "reboot -f"
EXIT /B 0

:mmc_flash_kernel
  SET kernel_path=%~1
  echo Flashing the kernel...
  %SSH% "mkdir /mnt/kernel"
  %SSH% "mount /dev/mmcblk0p2 /mnt/kernel"
  type %kernel_path% | %SSH% "cat - > /mnt/kernel/uImage"
  %SSH% "umount /dev/mmcblk0p2"
  echo Done flashing the kernel!
EXIT /B 0

:mmc_flash_bulk
  SET bulk_path=%~1
  echo Flashing the root filesystem...
  %SSH% "mkfs.ext4 -F -L Bulk -O ^metadata_csum /dev/mmcblk0p4"
  %SSH% "mkdir /mnt/bulk"
  %SSH% "mount -t ext4 /dev/mmcblk0p4 /mnt/bulk"
  echo Writing rootfs image... 
  type %bulk_path% | %SSH% "tar -zxvf '-' -C /mnt/bulk"
  %SSH% "chown -R 0:0 /mnt/bulk"
  %SSH% "chmod -R 7777 /mnt/bulk"
  %SSH% "umount /mnt/bulk"
  echo Done flashing the root filesystem!
EXIT /B 0

:flash_mmc
  SET prefix=%~1
  call :boot_surgeon %prefix%surgeon_zImage superhigh
  %SSH% -o "StrictHostKeyChecking no" 'test'
  call :mmc_flash_kernel %prefix%uImage
  call :mmc_flash_bulk rootfs.tar.gz
  echo Done! Rebooting your LeapFrog Device.
  %SSH% "reboot -f"
EXIT /B 0
