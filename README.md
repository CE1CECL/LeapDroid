# LeapDroid

To Install LeapDroid:

On Linux:
```
./remote_flash.sh
```

On Windows:
```
remote_flash.bat
```

And Choose the LF2000 Option! (Only the LF2000 Option is Supported for Now, as only LF2000 support has been implemented!)

Build Android 2.3.7 RootFS yourself:

```

set -xe
wget https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-10_r05.zip
unzip armeabi-v7a-10_r05.zip
cd armeabi-v7a
export LC_ALL=C
mkdir -pv ramdisk 
mkdir -pv system
mkdir -pv userdata
mv -fv ramdisk.img ramdisk.img.gz
gzip -kdvf ramdisk.img.gz
mount -o ro system.img system
mount -o ro userdata.img userdata
cd ramdisk/
cpio -i < ../ramdisk.img
cd ../
cd system/
cd ../
cd userdata/
cd ../
cd ramdisk/
cd sbin/
cp --preserve=mode,ownership,timestamps,xattr,all -rfvs ../init ./init
cd ../
cd system/
cp --preserve=mode,ownership,timestamps,xattr,all -rfv ../../system/* .
sed -i 's/net.bt.name=Android/net.bt.name=Android\nqemu.hw.mainkeys=0/g' build.prop
echo "0 1 android" > lib/egl/egl.cfg
cd ../
cd data/
cp --preserve=mode,ownership,timestamps,xattr,all -rfv ../../userdata/* .
cd ../
sed -i 's/ ro / rw /g' init.rc
sed -i 's/mkdir \/data\/data 0771 system system/mkdir \/data\/system 0771 system system\nmkdir \/data\/data 0771 system system/g' init.rc
sed -i 's/on property:persist.service.adb.enable=1/on property:persist.service.adb.enable=1\nwrite \/sys\/class\/android_usb\/android0\/functions adb\nwrite \/sys\/class\/android_usb\/android0\/enable 1/g' init.rc
sed -i 's/mkdir \/mnt 0775 root system/mkdir \/mnt 0775 root system\nexport EXTERNAL_STORAGE \/mnt\/sdcard\nmkdir \/mnt\/sdcard 0000 system system\nsymlink \/mnt\/sdcard \/sdcard/g' init.rc
tar --acls --selinux --xattrs -zcvf ../rootfs.tar.gz ./
cd ../
umount system
umount userdata

```
