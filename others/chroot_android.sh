#!/bin/sh

UBUNTUPATH="/data/local/tmp/ubuntu"

predownload(){
mkdir -p $UBUNTUPATH
cd $UBUNTUPATH
wget https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.5-base-arm64.tar.gz 
tar xpvf ubuntu-base-*-base-arm64.tar.gz --numeric-owner 
mkdir $UBUNTUPATH/sdcard
mkdir $UBUNTUPATH/dev/shm

echo "nameserver 8.8.8.8" > $UBUNTUPATH/etc/resolv.conf
echo "127.0.0.1 localhost" > $UBUNTUPATH/etc/hosts
}

checkstorage(){
du -sh $UBUNTUPATH/* --exclude $UBUNTUPATH/proc --exclude $UBUNTUPATH/sdcard --exclude $UBUNTUPATH/sys
du -sh $UBUNTUPATH --exclude $UBUNTUPATH/proc --exclude $UBUNTUPATH/sdcard --exclude $UBUNTUPATH/sys
}

cleanstorage(){
#apt clean
#apt-get autoremove --purge
rm -rf $UBUNTUPATH/var/lib/apt/lists/*
rm -f $UBUNTUPATH/var/cache/apt/archives/*.deb
rm -f $UBUNTUPATH/var/cache/apt/archives/partial/*.deb
rm -rf $UBUNTUPATH/var/cache/apt/*.bin
}

mountstorage(){
# Fix setuid issue
#mount -o remount,dev,suid /data

mount --bind /dev $UBUNTUPATH/dev
mount --bind /sys $UBUNTUPATH/sys
mount --bind /proc $UBUNTUPATH/proc
mount -t devpts devpts $UBUNTUPATH/dev/pts

# /dev/shm for Electron apps
#mount -t tmpfs -o size=256M tmpfs $UBUNTUPATH/dev/shm

# Mount sdcard
mount --bind /sdcard $UBUNTUPATH/sdcard
}

startchroot(){
# chroot into Ubuntu
#env -i HOME=/root TERM=$TERM chroot $UBUNTUPATH /bin/bash --login
env -i HOME=/home/k TERM=$TERM chroot $UBUNTUPATH /bin/su - k
}


umountstorage(){
# Umount everything after exiting the shell. Because the graphical environment will be installed later, they are commented. If you do not want to install a graphics environment, uncomment the following commands.

#umount -fl $UBUNTUPATH/dev/shm
umount -fl $UBUNTUPATH/dev/pts
umount -fl $UBUNTUPATH/dev
umount -fl $UBUNTUPATH/proc
umount -fl $UBUNTUPATH/sys
umount -fl $UBUNTUPATH/sdcard
}

makeminimal(){
cat <<EOF > $UBUNTUPATH/etc/apt/apt.conf.d/99minimal
APT::Install-Recommends "false";
APT::Install-Suggests "false";
Acquire::Languages "none";
EOF

cat <<EOF >> $UBUNTUPATH/etc/apt/apt.conf.d/99minimal
DPkg::Post-Invoke { "rm -rf /var/lib/apt/lists/* || true"; };
Apt::Post-Invoke { "rm -rf /var/lib/apt/lists/* || true"; };
EOF
}


#predownload
#makeminimal
#checkstorage
#cleanstorage
#checkstorage
mountstorage
startchroot
umountstorage && echo umounted
