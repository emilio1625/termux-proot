#!/data/data/com.termux/files/usr/bin/bash

cd $(dirname $0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r alpine-stable"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b alpine-fs/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
command+=" -b /data/data/com.termux/files/home/storage:/root/storage"
## uncomment the following line to mount /sdcard directly to /
#command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=PATH=/bin:/usr/bin:/sbin:/usr/sbin"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/sh --login"
com="$@"
if [ -z "$1" ];then
    exec $command
else
    $command -c "$com"
fi

