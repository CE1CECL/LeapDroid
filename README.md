# LeapDroid
To Install LeapDroid:

```
./remote_flash.sh
```
Choose Option 3, then after reboot (Post 1st-stage install):
```
adb shell mount -o remount,rw /dev/ubi0_0 /
adb shell mkdir /data/data/
adb shell mkdir /data/system/
```

To Boot LeapDroid (for-now):
```
adb shell mount -o remount,rw /dev/ubi0_0 /
```
