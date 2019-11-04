#!/data/data/com.termux/files/usr/bin/bash

folder=debian-stable
echo "Installing debootstrap"
pkg i debootstrap

echo "Downloading packages, this may take a while base on your internet speed."
case `dpkg --print-architecture` in
aarch64)
    arch="arm64" ;;
arm)
    arch="armhf" ;;
amd64)
    arch="amd64" ;;
x86_64)
    arch="amd64" ;;
i*86)
    arch="i386" ;;
x86)
    arch="1386" ;;
*)
    echo "unknown architecture"; exit 1 ;;
esac

debootstrap --arch=$arch stable debian-stable http://ftp.debian.org/debian/

echo "Preparing additional component for the first time, please wait..."
rm debian-stable/etc/resolv.conf
cat > debian-stable/etc/resolv.conf <<- EOF
nameserver 1.1.1.1
nameserver 9.9.9.9
EOF

echo "You can now launch Debian with the start-debian.sh script"
