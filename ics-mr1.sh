#!/bin/bash
clear
rm -rfv ics-mr1
mkdir -pv ics-mr1
cd ics-mr1
echo "ics-mr1" > .ics-mr1
python3 ../repo.py init --manifest-url=http://github.com/CE1CECL/LeapDroid --manifest-name=default.xml --current-branch --no-tags --depth=1 --partial-clone --no-use-superproject --no-clone-bundle --git-lfs --no-repo-verify
mkdir -pv .repo/local_manifests/
cp -rfv ../ics-mr1.xml .repo/local_manifests/ics-mr1.xml
python3 ../repo.py sync --jobs=$(nproc --all) --jobs-network=$(nproc --all) --jobs-checkout=$(nproc --all) --force-sync --detach --current-branch --no-clone-bundle --no-use-superproject --no-tags --prune --no-repo-verify
rm -rfv .ics-mr1
