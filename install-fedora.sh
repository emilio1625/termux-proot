#!/data/data/com.termux/files/usr/bin/bash
folder=fedora-30
if [ -d "$folder" ]; then
	first=1
	echo "Skipping downloading"
fi

tarball="fedora-rootfs.tar.xz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo "Download Rootfs, this may take a while base on your internet speed."
		case `dpkg --print-architecture` in
		aarch64)
			arch="aarch64" ;;
		amd64)
			arch="x86_64" ;;
		x86_64)
			arch="x86_64" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac

		url="http://mirror.metrocast.net/fedora/linux/releases/30/Container/aarch64/images/Fedora-Container-Minimal-Base-30-1.2.aarch64.tar.xz"
		wget $url -O $tarball
	fi

	cur=`pwd`
	mkdir tmp
	cd tmp
	echo "Decompressing Rootfs, please be patient."
	tar -xf ${cur}/${tarball} 2> /dev/null||:
	cd "$cur"
	mkdir -p "$folder"
	cd "$folder"
	proot --link2symlink -0 tar -xf ${cur}/tmp/*/*.tar --exclude='dev' 2> /dev/null||:
	stubs=()
	stubs+=('usr/bin/groups')
	for f in ${stubs[@]};do
		echo "Writing stub: $f"
		echo -e "#!/bin/sh\nexit" >> "$f"
	done
	cd "$cur"
fi

echo "Removing image for some space"
rm $tarball
rm tmp

echo "Preparing additional component for the first time, please wait..."
rm ${folder}/etc/resolv.conf
cat > ${folder}/etc/resolv.conf <<- EOF
nameserver 1.1.1.1
nameserver 9.9.9.9
EOF

echo "You can now launch Fedora with the start-fedora.sh script"
