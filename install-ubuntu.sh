#!/data/data/com.termux/files/usr/bin/bash
folder=ubuntu-lts
if [ -d "$folder" ]; then
	first=1
	echo "Skipping downloading"
fi

tarball="ubuntu-rootfs.tar.gz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo "Download Rootfs, this may take a while base on your internet speed."
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
			arch="i386" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac

		ver=$(curl -s http://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/MD5SUMS | tail -1 | egrep -o "[0-9]+\.[0-9]+(\.[0-9])*")
		url="http://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/ubuntu-base-$ver-base-$arch.tar.gz"
		wget $url -O $tarball
	fi

	cur=`pwd`
	mkdir -p "$folder"
	cd "$folder"
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xf ${cur}/${tarball} --exclude='dev' 2> /dev/null||:
	cd "$cur"
    stubs=()
    stubs+=('usr/bin/groups')
    for f in ${stubs[@]};do
        echo "Writing stub: $f"
        echo -e "#!/bin/sh\nexit" > "$f"
    done
fi

echo "Removing image for some space"
rm $tarball

echo "Preparing additional component for the first time, please wait..."
rm ${folder}/etc/resolv.conf
cat > ${folder}/etc/resolv.conf <<- EOF
nameserver 1.1.1.1
nameserver 9.9.9.9
EOF

echo "You can now launch Ubuntu with the start-ubuntu.sh script"
