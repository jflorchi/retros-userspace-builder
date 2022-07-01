#!/usr/bin/env bash

# Copy in configurations files
cp -R usr/** out/data/data/com.termux/files/usr/

# Create apt folders
mkdir -p out/data/data/com.termux/files/usr/etc/apt/apt.conf.d/
mkdir -p out/data/data/com.termux/files/usr/etc/apt/preferences.d/
mkdir -p out/data/data/com.termux/files/usr/var/cache/apt/archives/partial
mkdir -p out/data/data/com.termux/files/usr/var/lib/dpkg/updates/
mkdir -p out/data/data/com.termux/files/usr/var/lib/dpkg/info
touch out/data/data/com.termux/files/usr/var/lib/dpkg/info/format-new
touch out/data/data/com.termux/files/usr/var/lib/dpkg/available
mkdir -p out/data/data/com.termux/files/usr/var/log/apt/

# Create tmp symlink
pushd out/data/data/com.termux/files/usr
ln -sf /tmp tmp
popd

cp -pRv home out/data/data/com.termux/files/
mkdir -p out/data/data/com.termux/files/usr/libexec/qt/egldeviceintegrations/
cp libqeglfs-surfaceflinger-integration.so 
cd out/data/data/com.termux/
tar czvf files.tar.gz files
mv files.tar.gz ../../../../
