clear
set -x -e
rm -rfv Debi64.tar.gz
rm -rfv Debi64
apt --yes --force-yes install --no-install-suggests --no-install-recommends debootstrap coreutils tar qemu-user-static binfmt-support
debootstrap --no-merged-usr --verbose --arch=amd64 --variant=minbase --no-check-gpg --log-extra-deps --no-check-certificate trixie Debi64 http://snapshot.debian.org/archive/debian/20250728T143703Z/
cp -rfv "$0" Debi64/usr/src/Debi64.sh
chroot Debi64 /bin/rm -rfv /etc/apt/preferences
chroot Debi64 /bin/echo "Package: *" | chroot Debi64 /usr/bin/tee /etc/apt/preferences
chroot Debi64 /bin/echo "Pin: release o=*,a=*,n=*,l=*,c=*,b=*" | chroot Debi64 /usr/bin/tee -a /etc/apt/preferences
chroot Debi64 /bin/echo "Pin-Priority: 1001" | chroot Debi64 /usr/bin/tee -a /etc/apt/preferences
chroot Debi64 /bin/rm -rfv /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-backports-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-proposed-updates-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ rc-buggy-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ sid-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20250728T145310Z/ trixie-security main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-backports main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-proposed-updates main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-updates main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ experimental main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ sid main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-backports-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ trixie-proposed-updates-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ rc-buggy-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-debug/20250728T143850Z/ sid-debug main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20250728T145310Z/ trixie-security main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-backports main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-proposed-updates main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ trixie-updates main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ experimental main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20250728T143703Z/ sid main contrib non-free non-free-firmware" | chroot Debi64 /usr/bin/tee -a /etc/apt/sources.list
chroot Debi64 /bin/rm -rfv /etc/hostname
chroot Debi64 /bin/echo "" | chroot Debi64 /usr/bin/tee /etc/hostname
chroot Debi64 /usr/bin/apt-get --yes --force-yes update --allow-unauthenticated --allow-insecure-repositories
chroot Debi64 /usr/bin/apt-get --yes --force-yes dist-upgrade --no-install-suggests --no-install-recommends
chroot Debi64 /usr/bin/yes "1" | chroot Debi64 /usr/bin/apt-get --yes --force-yes install --no-install-suggests --no-install-recommends task-lxde-desktop nano sudo xvkbd kmod network-manager-gnome wpasupplicant firefox-esr linux-image-amd64 linux-headers-amd64
chroot Debi64 /usr/bin/apt-get --yes --force-yes autoremove
chroot Debi64 /usr/bin/apt-get --yes --force-yes clean
chroot Debi64 /usr/bin/apt-get --yes --force-yes autoclean
chroot Debi64 /bin/rm -rfv /etc/sudoers
chroot Debi64 /bin/echo "Defaults secure_path='/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/:/usr/local/sbin/'" | chroot Debi64 /usr/bin/tee /etc/sudoers
chroot Debi64 /bin/echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" | chroot Debi64 /usr/bin/tee -a /etc/sudoers
chroot Debi64 /bin/sed -i 's/minimum-uid=500/minimum-uid=0/g' /etc/lightdm/users.conf
chroot Debi64 /bin/sed -i 's/hidden-users=nobody nobody4 noaccess/hidden-users=/g' /etc/lightdm/users.conf
chroot Debi64 /bin/sed -i 's/hidden-shells=\/bin\/false \/usr\/sbin\/nologin \/sbin\/nologin/hidden-shells=/g' /etc/lightdm/users.conf
chroot Debi64 /bin/sed -i 's/#keyboard=/keyboard=xvkbd/g' /etc/lightdm/lightdm-gtk-greeter.conf
chroot Debi64 /bin/sed -i 's/#autologin-user=/autologin-user=toor/g' /etc/lightdm/lightdm.conf
chroot Debi64 /bin/ln -sfv /sbin/init /init
chroot Debi64 /usr/sbin/useradd -m toor
chroot Debi64 /bin/sed -i 's/::\/root:\/bin\/sh/::\/root:\/bin\/bash/g' /etc/passwd
chroot Debi64 /bin/sed -i 's/::\/home\/toor:\/bin\/sh/::\/home\/toor:\/bin\/bash/g' /etc/passwd
chroot Debi64 /bin/echo "root:root" | chroot Debi64 /usr/sbin/chpasswd
chroot Debi64 /bin/echo "toor:toor" | chroot Debi64 /usr/sbin/chpasswd
tar --acls --selinux --xattrs -C Debi64 -zcvf Debi64.tar.gz ./
