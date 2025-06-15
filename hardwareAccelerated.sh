#!/bin/bash
for a in $(find . -not -type d | grep -i AndroidManifest | grep -i xml); do echo $a; sed -i 's/android:hardwareAccelerated="true"/android:hardwareAccelerated="false"/g' $a; done
