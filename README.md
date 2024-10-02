# LeapDroid

To Install LeapDroid:

```
./remote_flash.sh
```

And Choose Option 3! (Only Option 3 is Supported for Now!)


Build Android 2.3.7 RootFS yourself:

```

wget https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-10_r05.zip
unzip armeabi-v7a-10_r05.zip
cd armeabi-v7a
export LANG=C
mkdir -p ramdisk 
mkdir -p system
mkdir -p userdata
mv -fv ramdisk.img ramdisk.img.gz
gzip -kvdf ramdisk.img.gz
mount -o ro system.img system
mount -o ro userdata.img userdata
cd ramdisk/
cpio -i <../ramdisk.img
getfacl -R init >../init.acl
getfacl -R init.rc >../rc.acl
getfacl -R . >../ramdisk.acl
cd ../
cd system/
getfacl -R . >../system.acl
cd ../
cd userdata/
getfacl -R . >../userdata.acl
cd ../
cd ramdisk/
cd sbin/
ln -s ../init ./init
setfacl --restore=../../init.acl
cd ../
cd system/
cp -rfv ../../system/* .
setfacl --restore=../../system.acl
cd ../
cd data/
cp -rfv ../../userdata/* .
setfacl --restore=../../userdata.acl
cd ../
sed -i 's/ ro / rw /g' init.rc
sed -i 's/mkdir \/data\/data 0771 system system/mkdir \/data\/system 0771 system system\nmkdir \/data\/data 0771 system system/g' init.rc
sed -i 's/on property:persist.service.adb.enable=1/on property:persist.service.adb.enable=1\nwrite \/sys\/class\/android_usb\/android0\/functions adb\nwrite \/sys\/class\/android_usb\/android0\/enable 1/g' init.rc
setfacl --restore=../rc.acl
cd system/
cd lib/
cd egl/
getfacl -R egl.cfg >../../../../egl.acl
echo "0 1 android" >egl.cfg
setfacl --restore=../../../../egl.acl
cd ../
cd ../
cd ../
cd system/
cd etc/
cd ../
cd ../
tar -zcvf ../rootfs.tar.gz ./
cd ../
umount system
umount userdata

```
