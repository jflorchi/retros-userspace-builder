# THIS BUILDER IS FOR ANDROID 9 SNAPDRAGON ONLY

from [geohot's gist](https://gist.github.com/geohot/569e9e4b20fd41203d8da71c6022be15) (edited to remove steps that were added to install.sh):

TODO: script the rest of the process too. better yet, make it all autorun on the phone like NEOS.

```
wget https://github.com/topjohnwu/Magisk/releases/download/v24.2/Magisk-v24.2.apk
adb install termux-app_v0.118.0+github-debug_arm64-v8a.apk
adb install Magisk-v24.2.apk
unzip -p blueline-pq3a.190801.002/image-blueline-pq3a.190801.002.zip boot.img > boot.img
adb push boot.img /sdcard/Download/
# use magisk app to patch boot.img
adb pull /sdcard/Download/magisk_patched-24200_V7Jgg.img
adb reboot bootloader
fastboot flash boot magisk_patched-24200_V7Jgg.img
fastboot reboot

# your phone is now rooted, this builds and installs the userspace
# TODO: factor build_usr out of this repo
git clone git@github.com:commaai/eon-neos-builder.git
cd eon-neos-builder/devices/eon/build_usr/
./install.py
./finish.sh
cp -pRv ../home out/data/data/com.termux/files/
cd out/data/data/com.termux/files/
tar zcvf userspace.tar.gz home usr
adb push userspace.tar.gz /sdcard/Download/
adb shell

# now we are on the phone
su
cd /data/data/com.termux/ 
mkdir files && cd files
tar xvf /sdcard/Download/userspace.tar.gz
mount -o remount,rw /dev/root /
ln -s /data/data/com.termux/files/usr /usr
exit

# enter the new userspace (reuse later)
su -c 'HOME=/data/data/com.termux/files/home PATH="/data/data/com.termux/files/usr/bin:/bin" LD_LIBRARY_PATH="/data/data/com.termux/files/usr/lib:/data/data/com.termux/files/usr/local/lib64" bash'
mkdir -p tmp && mount -t tmpfs -o size=2048M tmpfs /tmp
cd ~
tmux

# build and install extra packages
# comment out line 9 from install.sh with the mount
# this takes about 45 minutes
# TODO: the binutils this builds is broken
./install.sh

# on host
adb forward tcp:8022 tcp:8022
ssh -p 8022 localhost

# install openpilot
touch /EON
cd /data
git clone https://github.com/commaai/openpilot.git --recurse-submodules -b pixel3
cd openpilot
scons -j4
# two things currently don't build, the model and panda (binutils issue)

# HACK: for qt to talk to android 9 surfaceflinger and for locked rotation landscape
cp /data/openpilot/third_party/qt-plugins/aarch64/libqeglfs-surfaceflinger-integration.so /usr/libexec/qt/egldeviceintegrations/

# launch!
./launch_openpilot.sh/files/usr/bin:/bin" LD_LIBRARY_PATH="/data/data/com.termux/files/usr/lib" bash'
mkdir -p tmp && mount -t tmpfs -o size=2048M tmpfs /tmp
cd ~
tmux

# build and install extra packages
# comment out line 9 from install.sh with the mount
# this takes about 45 minutes
# TODO: the binutils this builds is broken
./install.sh

# on host
adb forward tcp:8022 tcp:8022
ssh -p 8022 localhost

# install openpilot
touch /EON
cd /data
git clone https://github.com/commaai/openpilot.git --recurse-submodules -b pixel3
cd openpilot
scons -j4
# two things currently don't build, the model and panda (binutils issue)

# HACK: for qt to talk to android 9 surfaceflinger and for locked rotation landscape
cp /data/openpilot/third_party/qt-plugins/aarch64/libqeglfs-surfaceflinger-integration.so /usr/libexec/qt/egldeviceintegrations/

# launch!
./launch_openpilot.sh
```



NEOS Builder
======

This is the tool to build the operating system for your EON Gold and [comma two](https://comma.ai/shop/products/comma-two-devkit) dashcam development kit.

What is NEOS?
------

* A kernel built outside the Android build system
* A minified version of Android
* Userspace from termux

Supported Devices
------

* [OnePlus 3T](https://www.oneplus.com/3t)
* [LeEco LePro 3](https://www.cnet.com/products/leeco-lepro-3/review/)

What works
-----
- [X] **Compute**
  - [X] GPU
  - [X] OpenCL
  - [X] DSP
- [X] **Sensors**
  - [X] GPS
  - [X] IMU
  - [X] Camera with visiond
  - [X] Audio
  - [X] Touchscreen
- [X] **Connectivity**
  - [X] Ethernet
  - [X] Radio
  - [X] Wi-FI
  - [X] Bluetooth
  - [X] Tethering

Usage
------

### Prerequisites

* An Ubuntu 20.04 build environment with at least 80GB of free disk space
* Install git and [git-lfs](https://github.com/git-lfs/git-lfs/wiki/Installation) to fetch build tools during `git clone`

### Building and Installing

See the device-specific instructions in `devices/eon/README.md`
