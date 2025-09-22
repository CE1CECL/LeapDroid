#!/bin/bash
cd ../gingerbread/
python ../LeapDroid/repo.py diff -u > ../LeapDroid/gingerbread.patch
git apply -R ../LeapDroid/gingerbread-werror.patch
python ../LeapDroid/repo.py diff -u > ../LeapDroid/gingerbread.diff
git apply ../LeapDroid/gingerbread-werror.patch
cd ../ics-mr1/
python ../LeapDroid/repo.py diff -u > ../LeapDroid/ics-mr1.patch
git apply -R ../LeapDroid/ics-mr1-werror-hardwareAccelerated.patch
python ../LeapDroid/repo.py diff -u > ../LeapDroid/ics-mr1.diff
git apply ../LeapDroid/ics-mr1-werror-hardwareAccelerated.patch
cd ../CyanogenMod-gingerbread/
python ../LeapDroid/repo.py diff -u > ../LeapDroid/CyanogenMod-gingerbread.patch
git apply -R ../LeapDroid/CyanogenMod-gingerbread-werror.patch
python ../LeapDroid/repo.py diff -u > ../LeapDroid/CyanogenMod-gingerbread.diff
git apply ../LeapDroid/CyanogenMod-gingerbread-werror.patch
cd ../CyanogenMod-ics/
python ../LeapDroid/repo.py diff -u > ../LeapDroid/CyanogenMod-ics.patch
git apply -R ../LeapDroid/CyanogenMod-ics-werror-hardwareAccelerated.patch
python ../LeapDroid/repo.py diff -u > ../LeapDroid/CyanogenMod-ics.diff
git apply ../LeapDroid/CyanogenMod-ics-werror-hardwareAccelerated.patch
cd ../LeapDroid/
