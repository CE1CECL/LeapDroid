clear
set -x -e
rm -rfv Debi686.tar.gz
rm -rfv Debi686
apt --yes --force-yes install --no-install-suggests --no-install-recommends debootstrap coreutils tar qemu-user-static binfmt-support
debootstrap --verbose --arch=i386 --variant=minbase --no-check-gpg --log-extra-deps --no-check-certificate bookworm Debi686 http://snapshot.debian.org/archive/debian/20230610T024621Z/
cp -rfv "$0" Debi686/usr/src/Debi686.sh
chroot Debi686 /bin/rm -rfv /etc/apt/preferences
chroot Debi686 /bin/echo "Package: *" | chroot Debi686 /usr/bin/tee /etc/apt/preferences
chroot Debi686 /bin/echo "Pin: release o=*,a=*,n=*,l=*,c=*,b=*" | chroot Debi686 /usr/bin/tee -a /etc/apt/preferences
chroot Debi686 /bin/echo "Pin-Priority: 1001" | chroot Debi686 /usr/bin/tee -a /etc/apt/preferences
chroot Debi686 /bin/rm -rfv /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-backports-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-proposed-updates-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ rc-buggy-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ sid-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20230609T202335Z/ bookworm-security main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-backports main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-proposed-updates main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-updates main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ experimental main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ sid main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-backports-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ bookworm-proposed-updates-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ rc-buggy-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20230610T024552Z/ sid-debug main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20230609T202335Z/ bookworm-security main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-backports main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-proposed-updates main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ bookworm-updates main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ experimental main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20230610T024621Z/ sid main contrib non-free non-free-firmware" | chroot Debi686 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi686 /bin/rm -rfv /etc/hostname
chroot Debi686 /bin/echo "" | chroot Debi686 /usr/bin/tee /etc/hostname
chroot Debi686 /usr/bin/apt-get --yes --force-yes update --allow-unauthenticated --allow-insecure-repositories
chroot Debi686 /usr/bin/apt-get --yes --force-yes dist-upgrade --no-install-suggests --no-install-recommends
chroot Debi686 /usr/bin/yes "1" | chroot Debi686 /usr/bin/apt-get --yes --force-yes install --no-install-suggests --no-install-recommends task-lxde-desktop nano sudo xvkbd kmod network-manager-gnome wpasupplicant firefox-esr linux-image-686 linux-headers-686
chroot Debi686 /usr/bin/apt-get --yes --force-yes autoremove
chroot Debi686 /usr/bin/apt-get --yes --force-yes clean
chroot Debi686 /usr/bin/apt-get --yes --force-yes autoclean
chroot Debi686 /bin/rm -rfv /etc/sudoers
chroot Debi686 /bin/echo "Defaults secure_path='/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/:/usr/local/sbin/'" | chroot Debi686 /usr/bin/tee /etc/sudoers
chroot Debi686 /bin/echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" | chroot Debi686 /usr/bin/tee -a /etc/sudoers
chroot Debi686 /bin/sed -i 's/minimum-uid=500/minimum-uid=0/g' /etc/lightdm/users.conf
chroot Debi686 /bin/sed -i 's/hidden-users=nobody nobody4 noaccess/hidden-users=/g' /etc/lightdm/users.conf
chroot Debi686 /bin/sed -i 's/hidden-shells=\/bin\/false \/usr\/sbin\/nologin \/sbin\/nologin/hidden-shells=/g' /etc/lightdm/users.conf
chroot Debi686 /bin/sed -i 's/#keyboard=/keyboard=xvkbd/g' /etc/lightdm/lightdm-gtk-greeter.conf
chroot Debi686 /bin/sed -i 's/#autologin-user=/autologin-user=toor/g' /etc/lightdm/lightdm.conf
chroot Debi686 /bin/ln -sfv /sbin/init /init
chroot Debi686 /usr/sbin/useradd -m toor
chroot Debi686 /bin/sed -i 's/::\/root:\/bin\/sh/::\/root:\/bin\/bash/g' /etc/passwd
chroot Debi686 /bin/sed -i 's/::\/home\/toor:\/bin\/sh/::\/home\/toor:\/bin\/bash/g' /etc/passwd
chroot Debi686 /bin/echo "root:root" | chroot Debi686 /usr/sbin/chpasswd
chroot Debi686 /bin/echo "toor:toor" | chroot Debi686 /usr/sbin/chpasswd
tar --acls --selinux --xattrs -C Debi686 -zcvf Debi686.tar.gz ./
