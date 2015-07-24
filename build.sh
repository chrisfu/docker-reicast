#!/bin/bash

# Do an initial git clone if /reicast doesn't contain a git repo
[ ! -d /reicast/.git ] && git clone https://github.com/reicast/reicast-emulator.git /reicast

# Clean up 32-bit build target
#rm -rf /build_i386/*
#rm -rf /build_i386/.*

# Clean up 64-bit build target
rm -rf /build_x86_64/*
rm -rf /build_x86_64/.*

# Clean up packages directory
rm -rf /packages/*
rm -rf /packages/.*

# Cleanup source build dirs and pull latest
#cd /reicast/shell/lin86; make clean
cd /reicast/shell/lin64; make clean
cd /reicast
git pull -u origin master

# Update the apt repositories
apt-get update

# Create simple changelog
cd /reicast
changelogger changelog > /tmp/CHANGELOG

# Pulseaudio available! Pull the 32-bit library in
#apt-get install -qy --force-yes libpulse-dev:i386

# Pulseaudio available! Pull the 64-bit library in
apt-get install -qy --force-yes libpulse-dev

# Build i386 version
#cd /reicast/shell/lin86
#USE_PULSEAUDIO=1 make

# Create 32-bit tarball
#cd /reicast
#GIT_VERSION=`git rev-parse --short HEAD`
#cp -a /reicast/shell/lin86/nosym-reicast.elf /build_i386/reicast-$GIT_VERSION-i386
#chmod +x /build_i386/reicast-$GIT_VERSION-i386
#tar cvfz /packages/reicast-$GIT_VERSION-i386.tar.gz /build_i386/reicast-$GIT_VERSION-i386

# Prep to create i386 Debian package
#mkdir -p /build_i386/usr/bin
#mv /build_i386/reicast-$GIT_VERSION-i386 /build_i386/usr/bin/reicast

# Create i386 Debian package
#echo "Building i386 deb..."
#fpm -s dir -t deb -n reicast -v $GIT_VERSION -C /build_i386 \
#-m "Chris Merrett <chris@chrisfu.co.uk>" \
#-p /packages/reicast-VERSION-ARCH.deb \
#-a i386 \
#-d "libgcc1 >= 1:4.1.1" \
#-d "libgl1-mesa-glx | libgl1" \
#-d "libstdc++6 >= 4.6" \
#-d "libx11-6" \
#-d "pulseaudio" \
#--description "reicast is a multi-platform Sega Dreamcast emulator." \
#--license "GPLv2" \
#--vendor "Reicast" \
#--url http://reicast.com/ \
#--deb-changelog /tmp/CHANGELOG \
#--category games \
#usr/bin

# Cleanup source build dirs again
#cd /reicast/shell/lin86; make clean
#cd /reicast/shell/lin64; make clean

# Half-time interval (32-bit -> 64-bit switch-er-roo)
#apt-get remove -qy --force-yes\
#  libasound2-dev:i386\
#  libgl1-mesa-dev:i386\
#  libpulse-dev:i386
#apt-get autoremove -qy --force-yes
#apt-get install -qy --force-yes\
#  libasound2-dev\
#  libgl1-mesa-dev\
#  libpulse-dev

# Build x86_64 version
cd /reicast/shell/lin64
USE_PULSEAUDIO=1 make

# Create 64-bit tarball
cd /reicast
GIT_VERSION=`git rev-parse --short HEAD`
cp -a /reicast/shell/lin64/nosym-reicast.elf /build_x86_64/reicast-$GIT_VERSION-x86_64
chmod +x /build_x86_64/reicast-$GIT_VERSION-x86_64
tar cvfz /packages/reicast-$GIT_VERSION-x86_64.tar.gz /build_x86_64/reicast-$GIT_VERSION-x86_64

# Prep to create amd64 Debian package
mkdir -p /build_x86_64/usr/bin
mv /build_x86_64/reicast-$GIT_VERSION-x86_64 /build_x86_64/usr/bin/reicast

# Create amd64 Debian package
echo "Building amd64 deb..."
fpm -s dir -t deb -n reicast -v $GIT_VERSION -C /build_x86_64 \
-m "Chris Merrett <chris@chrisfu.co.uk>" \
-p /packages/reicast-VERSION-ARCH.deb \
-a amd64 \
-d "libgcc1 >= 1:4.1.1" \
-d "libgl1-mesa-glx | libgl1" \
-d "libstdc++6 >= 4.6" \
-d "libx11-6" \
-d "pulseaudio" \
--description "reicast is a multi-platform Sega Dreamcast emulator." \
--license "GPLv2" \
--vendor "Reicast" \
--url http://reicast.com/ \
--deb-changelog /tmp/CHANGELOG \
--category games \
usr/bin

# Exit stage left  (64-bit -> 32-bit revert)
#apt-get remove -qy --force-yes\
#  libasound2-dev\
#  libgl1-mesa-dev\
#  libpulse-dev
#apt-get autoremove -qy --force-yes
#apt-get install -qy --force-yes\
#  libasound2-dev:i386\
#  libgl1-mesa-dev:i386\
#  libpulse-dev:i386

# Print success if 32-bit package created
#if [ -f /packages/reicast-$GIT_VERSION-i386.deb ]; then
#	echo "Your Reicast 32-bit Debian package can be found at /packages/reicast-$GIT_VERSION-i386.deb. Copy it via 'docker cp' and you're good to go!"
#fi

# Print success if 32-bit tarball created
#if [ -f /packages/reicast-$GIT_VERSION-i386.tar.gz ]; then
#	echo "Your Reicast 32-bit tarball archive can be found at /packages/reicast-$GIT_VERSION-i386.tar.gz. Copy it via 'docker cp' and you're good to go!"
#fi

# Print success if 64-bit package created
if [ -f /packages/reicast-$GIT_VERSION-amd64.deb ]; then
	echo "Your Reicast 64-bit Debian package can be found at /packages/reicast-$GIT_VERSION-amd64.deb. Copy it via 'docker cp' and you're good to go!"
fi

# Print success if 64-bit tarball created
if [ -f /packages/reicast-$GIT_VERSION-x86_64.tar.gz ]; then
	echo "Your Reicast 64-bit tarball archive can be found at /packages/reicast-$GIT_VERSION-x86_64.tar.gz. Copy it via 'docker cp' and you're good to go!"
fi
