# LeapDroid

To Install LeapDroid:

```
./remote_flash.sh
```

And Choose Option 3!


Build Android RootFS yourself:

```

rm -rfv armeabi-v7a
rm -rfv armeabi-v7a-10_r05.zip
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
cp -rfv ../../system/.* .
cp -rfv ../../system/* .
setfacl --restore=../../system.acl
cd ../
cd data/
cp -rfv ../../userdata/.* .
cp -rfv ../../userdata/* .
setfacl --restore=../../userdata.acl
cd ../
sed -i 's/ ro / rw /g' init.rc
sed -i 's/mkdir \/data\/data 0771 system system/mkdir \/data\/system 0771 system system\nmkdir \/data\/data 0771 system system/g' init.rc
#sed -i 's/mkdir \/mnt 0775 root system/mkdir \/mnt 0775 root system\nexport EXTERNAL_STORAGE \/mnt\/sdcard\nmkdir \/mnt\/sdcard 0000 system system\nsymlink \/mnt\/sdcard \/sdcard/g' init.rc
sed -i 's/on property:persist.service.adb.enable=1/on property:persist.service.adb.enable=1\nsetprop sys.usb.state accessory,adb\nwrite \/sys\/class\/android_usb\/android0\/enable 0\nwrite \/sys\/class\/android_usb\/android0\/idVendor 18d1\nwrite \/sys\/class\/android_usb\/android0\/idProduct 2d01\nwrite \/sys\/class\/android_usb\/android0\/functions accessory,adb\nwrite \/sys\/class\/android_usb\/android0\/enable 1/g' init.rc
sed -i 's/on property:persist.service.adb.enable=0/on property:persist.service.adb.enable=0\nsetprop sys.usb.state none\nwrite \/sys\/class\/android_usb\/android0\/enable 0\nwrite \/sys\/class\/android_usb\/android0\/bDeviceClass 0/g' init.rc
setfacl --restore=../rc.acl
cd system/
cd lib/
cd egl/
rm -rfv egl.cfg
rm -rfv *mulatio*
cd ../
cd ../
cd ../
cd system/
cd etc/
rm -rfv audio_policy.conf
cd ../
cd ../
tar -zcvf ../ramdisk.tar.gz ./
cd ../
umount system
umount userdata

```

