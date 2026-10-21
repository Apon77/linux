#!/bin/sh

UBUNTUPATH="/data/local/tmp/ubuntu"

predownload(){
mkdir -p $UBUNTUPATH
cd $UBUNTUPATH
wget https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.5-base-arm64.tar.gz 
tar xpvf ubuntu-base-*-base-arm64.tar.gz --numeric-owner 
mkdir -p $UBUNTUPATH/sdcard
mkdir -p $UBUNTUPATH/dev/shm

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
#mount -o remount,dev,suid /data #risky
#mount -o remount,nosuid,nodev /data #default

mount -t tmpfs -o mode=0755 tmpfs $UBUNTUPATH/dev

mkdir -p $UBUNTUPATH/dev/pts $UBUNTUPATH/dev/shm
mkdir -p $UBUNTUPATH/proc $UBUNTUPATH/sys $UBUNTUPATH/sdcard

[ -c $UBUNTUPATH/dev/null ]   || mknod -m 666 $UBUNTUPATH/dev/null c 1 3
[ -c $UBUNTUPATH/dev/zero ]   || mknod -m 666 $UBUNTUPATH/dev/zero c 1 5
[ -c $UBUNTUPATH/dev/random ] || mknod -m 666 $UBUNTUPATH/dev/random c 1 8
[ -c $UBUNTUPATH/dev/urandom ]|| mknod -m 666 $UBUNTUPATH/dev/urandom c 1 9
[ -c $UBUNTUPATH/dev/tty ] || mknod -m 666 $UBUNTUPATH/dev/tty c 5 0

# FIX: Create the standard device multiplexer and descriptor symlinks
[ -e $UBUNTUPATH/dev/ptmx ]   || ln -s pts/ptmx $UBUNTUPATH/dev/ptmx
[ -e $UBUNTUPATH/dev/fd ]     || ln -s /proc/self/fd $UBUNTUPATH/dev/fd
[ -e $UBUNTUPATH/dev/stdin ]  || ln -s fd/0 $UBUNTUPATH/dev/stdin
[ -e $UBUNTUPATH/dev/stdout ] || ln -s fd/1 $UBUNTUPATH/dev/stdout
[ -e $UBUNTUPATH/dev/stderr ] || ln -s fd/2 $UBUNTUPATH/dev/stderr

mount -t proc proc $UBUNTUPATH/proc
mount -t sysfs sysfs $UBUNTUPATH/sys
mount -t devpts -o newinstance,ptmxmode=0666 devpts $UBUNTUPATH/dev/pts

mkdir -p /sdcard/LinuxShare
mkdir -p $UBUNTUPATH/sdcard
mount --bind /sdcard/LinuxShare $UBUNTUPATH/sdcard

# /dev/shm for Electron apps
mount -t tmpfs -o size=256M tmpfs $UBUNTUPATH/dev/shm

}

startchroot(){
#Bypass Android background limits and execute jail session safely as user 'k'
#su -c "device_config put activity_manager max_phantom_processes 2147483647"

#env -i HOME=/root TERM=$TERM chroot $UBUNTUPATH /bin/bash --login #only when you need to install new packages as root
env -i HOME=/home/k TERM=$TERM chroot $UBUNTUPATH /bin/su - k #safe to use because it cant escape chroot
}

umountstorage(){
# Umount everything after exiting the shell. Because the graphical environment will be installed later, they are commented. If you do not want to install a graphics environment, uncomment the following commands.

umount -l $UBUNTUPATH/dev/shm
umount -l $UBUNTUPATH/dev/pts
umount -l $UBUNTUPATH/dev #should be done after child
umount -l $UBUNTUPATH/proc
umount -l $UBUNTUPATH/sys
umount -l $UBUNTUPATH/sdcard
}

noinstallrecommends(){
cat <<EOF > $UBUNTUPATH/etc/apt/apt.conf.d/99noinstallrecommends
APT::Install-Recommends "false";
APT::Install-Suggests "false";
Acquire::Languages "none";
EOF
}

cleanup(){
cat <<EOF > $UBUNTUPATH/etc/apt/apt.conf.d/99cleanup
DPkg::Post-Invoke { "rm -rf /var/lib/apt/lists/* || true"; };
Apt::Post-Invoke { "rm -rf /var/lib/apt/lists/* || true"; };
EOF
}
#predownload
#noinstallrecommends
#cleanup
#checkstorage
#cleanstorage
#checkstorage
#mountstorage
#startchroot
#umountstorage && echo umounted

#hello i broke chroot
#perl -e 'mkdir "/tmp/escape"; chroot "/tmp/escape"; chdir ".." for 1..50; chroot "."; system("/system/bin/sh");'
#python3 -c 'import os; os.mkdir("/tmp/escape"); os.chroot("/tmp/escape"); [os.chdir("..") for _ in range(50)]; os.chroot("."); os.system("/system/bin/sh")'
