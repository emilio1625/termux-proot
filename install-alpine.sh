#!/data/data/com.termux/files/usr/bin/bash
folder=alpine-stable
if [ -d "$folder" ]; then
	first=1
	echo "skipping downloading"
fi

tarball="alpine-rootfs.tar.gz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo "Download Rootfs, this may take a while base on your internet speed."
		case `dpkg --print-architecture` in
		aarch64)
			archurl="aarch64" ;;
		arm)
			archurl="armv7" ;;
		amd64)
			archurl="x86_64" ;;
		x86_64)
			archurl="x86_64" ;;
		i*86)
			archurl="x86" ;;
		x86)
			archurl="x86" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac

		alpine_ver=$(curl -s http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$archurl/latest-releases.yaml | grep -m 1 -o version.* | sed -e 's/[^0-9.]*//g' -e 's/-$//')
		if [ -z "$alpine_ver" ] ; then
			exit 1
		fi

		alpine_url="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$archurl/alpine-minirootfs-$alpine_ver-$archurl.tar.gz"
		wget $alpine_url -O $tarball
	fi

	cur=`pwd`
	mkdir -p "$folder"
	cd "$folder"
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xf ${cur}/${tarball} --exclude='dev' 2> /dev/null||:
	cd "$cur"
fi

echo "Removing image for some space"
rm $tarball

echo "Preparing additional component for the first time, please wait..."
rm alpine-stable/etc/resolv.conf
cat > ${folder}/etc/resolv.conf <<- EOF
nameserver 1.1.1.1
nameserver 9.9.9.9
EOF

echo "You can now launch Alpine with the start-alpine.sh script"
