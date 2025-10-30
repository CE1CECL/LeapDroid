@echo off

SET SSH=ssh root@169.254.8.1

call :show_warning
call :show_machinelist
echo Enter choice (1 - 3)
SET /P REPLY=
if /I "%REPLY%" == "1" (
	set prefix="lf1000_"
	call :backup_nand "lf1000_"
) else if /I "%REPLY%" == "2" (
	set prefix="lf2000_"
	call :backup_nand "lf2000_"
) else if /I "%REPLY%" == "3" (
	set prefix="lf3000_"
	call :backup_mmc "lf3000_"
) else (
	echo Unknown choice!
	pause
	EXIT /B 1
)
EXIT /B %ERRORLEVEL%


:show_warning
cls
echo This will Back up your Leapster/LeapPad!
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
echo What type of system would you like to backup?
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
  echo Done! Make Sure You Configure Your Device's IPv4 Address to "169.254.8.2", IPv4 Subnet Mask to "255.255.0.0", and disable IPv6!
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

  echo Detected Kernel Partition=%KERNEL_PARTITION% RFS Partition=%RFS_PARTITION% Bulk Partition=%BULK_PARTITION%
EXIT /B 0

:backup_nand
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
  %SSH% -o "StrictHostKeyChecking no" "test"
  call :nand_part_detect
  for /f %%m in ('%SSH% "ls /dev/mtd*"') do (
    echo %%m
    for %%u in (%%~nxm) do (
        echo /dev/%%u -> %prefix:"=%%%u%
        %SSH% "dd if=%%m" > %prefix:"=%%%u%
    )
  )
  echo Done! Rebooting your LeapFrog Device.
  %SSH% "reboot -f"
EXIT /B 0

:backup_mmc
  SET prefix=%~1
  call :boot_surgeon %prefix%surgeon_zImage superhigh
  %SSH% -o "StrictHostKeyChecking no" "test"
  for /f %%m in ('%SSH% "ls /dev/mmc*"') do (
    echo %%m
    for %%u in (%%~nxm) do (
        echo /dev/%%u -> %prefix:"=%%%u%
        %SSH% "dd if=%%m" > %prefix:"=%%%u%
    )
  )
  echo Done! Rebooting your LeapFrog Device.
  %SSH% "reboot -f"
EXIT /B 0
