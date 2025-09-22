#!/bin/bash
clear
rm -rfv CyanogenMod-gingerbread
mkdir -pv CyanogenMod-gingerbread
cd CyanogenMod-gingerbread
echo "CyanogenMod-gingerbread" > .CyanogenMod-gingerbread
python ../repo.py init --manifest-url=http://github.com/CE1CECL/default.xml --manifest-branch=default.xml --manifest-name=default.xml --current-branch --no-tags --depth=1 --partial-clone --no-use-superproject --no-clone-bundle --git-lfs --no-repo-verify
mkdir -pv .repo/local_manifests/
cp -rfv ../CyanogenMod-gingerbread.xml .repo/local_manifests/CyanogenMod-gingerbread.xml
python ../repo.py sync --jobs=$(nproc --all) --jobs-network=$(nproc --all) --jobs-checkout=$(nproc --all) --force-sync --detach --current-branch --no-clone-bundle --no-use-superproject --no-tags --prune --no-repo-verify
rm -rfv .CyanogenMod-gingerbread
