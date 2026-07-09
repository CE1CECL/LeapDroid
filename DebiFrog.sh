clear
set -x -e
rm -rfv DebiFrog.tar.gz
rm -rfv DebiFrog
apt --yes --force-yes install --no-install-suggests --no-install-recommends debootstrap coreutils tar qemu-user-static binfmt-support
debootstrap --verbose --arch=armel --variant=minbase --no-check-gpg --log-extra-deps --no-check-certificate stretch DebiFrog http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/
cp -rfv "$0" DebiFrog/usr/src/DebiFrog.sh
chroot DebiFrog /bin/rm -rfv /etc/apt/preferences
chroot DebiFrog /bin/echo "Package: *" | chroot DebiFrog /usr/bin/tee /etc/apt/preferences
chroot DebiFrog /bin/echo "Pin: release o=*,a=*,n=*,l=*,c=*,b=*" | chroot DebiFrog /usr/bin/tee -a /etc/apt/preferences
chroot DebiFrog /bin/echo "Pin-Priority: 1001" | chroot DebiFrog /usr/bin/tee -a /etc/apt/preferences
chroot DebiFrog /bin/rm -rfv /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch main contrib non-free" | chroot DebiFrog /usr/bin/tee /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-backports main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-backports main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-backports-sloppy main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-backports-sloppy main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-proposed-updates main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian/ stretch-proposed-updates main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-backports-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-backports-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-backports-sloppy-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-backports-sloppy-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-debug/ stretch-debug main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-security/ stretch/updates main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/echo "deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-archive/20240331T102506Z/debian-security/ stretch/updates main contrib non-free" | chroot DebiFrog /usr/bin/tee -a /etc/apt/sources.list
chroot DebiFrog /bin/rm -rfv /etc/hostname
chroot DebiFrog /bin/echo "" | chroot DebiFrog /usr/bin/tee /etc/hostname
chroot DebiFrog /usr/bin/apt-get --yes --force-yes update --allow-unauthenticated --allow-insecure-repositories
chroot DebiFrog /usr/bin/apt-get --yes --force-yes dist-upgrade --no-install-suggests --no-install-recommends
chroot DebiFrog /usr/bin/yes "1" | chroot DebiFrog /usr/bin/apt-get --yes --force-yes install --no-install-suggests --no-install-recommends task-lxde-desktop nano sudo xvkbd kmod network-manager-gnome wpasupplicant firefox-esr
chroot DebiFrog /usr/bin/apt-get --yes --force-yes autoremove
chroot DebiFrog /usr/bin/apt-get --yes --force-yes clean
chroot DebiFrog /usr/bin/apt-get --yes --force-yes autoclean
chroot DebiFrog /bin/rm -rfv /etc/sudoers
chroot DebiFrog /bin/echo "Defaults secure_path='/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/:/usr/local/sbin/'" | chroot DebiFrog /usr/bin/tee /etc/sudoers
chroot DebiFrog /bin/echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" | chroot DebiFrog /usr/bin/tee -a /etc/sudoers
chroot DebiFrog /bin/sed -i 's/minimum-uid=500/minimum-uid=0/g' /etc/lightdm/users.conf
chroot DebiFrog /bin/sed -i 's/hidden-users=nobody nobody4 noaccess/hidden-users=/g' /etc/lightdm/users.conf
chroot DebiFrog /bin/sed -i 's/hidden-shells=\/bin\/false \/usr\/sbin\/nologin \/sbin\/nologin/hidden-shells=/g' /etc/lightdm/users.conf
chroot DebiFrog /bin/sed -i 's/#keyboard=/keyboard=xvkbd/g' /etc/lightdm/lightdm-gtk-greeter.conf
chroot DebiFrog /bin/sed -i 's/#autologin-user=/autologin-user=toor/g' /etc/lightdm/lightdm.conf
chroot DebiFrog /bin/ln -sfv /sbin/init /init
chroot DebiFrog /usr/sbin/useradd -m toor
chroot DebiFrog /bin/sed -i 's/::\/root:\/bin\/sh/::\/root:\/bin\/bash/g' /etc/passwd
chroot DebiFrog /bin/sed -i 's/::\/home\/toor:\/bin\/sh/::\/home\/toor:\/bin\/bash/g' /etc/passwd
chroot DebiFrog /bin/echo "root:root" | chroot DebiFrog /usr/sbin/chpasswd
chroot DebiFrog /bin/echo "toor:toor" | chroot DebiFrog /usr/sbin/chpasswd
tar --acls --selinux --xattrs -C DebiFrog -zcvf DebiFrog.tar.gz ./
