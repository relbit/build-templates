install
reboot
lang en_US.UTF-8
keyboard us

network --onboot yes --device eth0 --mtu=1500 --bootproto dhcp --noipv6 --hostname template
firewall --disabled

authconfig --enableshadow --passalgo=sha512
rootpw  --iscrypted $6$aUHz7e/e$gFNlnYYdDc0upgenxFzJY8VzQmn83cl3N32/bhACMjW3uieXwn92rf7fG5upOMv5eGEQKxhfPzr9XHmt43nPk.

selinux --disabled
timezone --utc Europe/Prague

bootloader --location=mbr --driveorder=vda

zerombr
clearpart --all --drives=vda --initlabel

part / --fstype=ext2 --asprimary --size=512 --grow

%packages
-@scalable-file-systems
-@misc-sl
-@office-suite
-@internet-applications

openssh-clients
ruby
rubygems
ruby-irb
sysstat
vim-enhanced
dstat

-bridge-utils*
-device-mapper*
-dhcp-common*
-eject
-*firmware*
-grub*
-kernel*
-kpartx
-lvm2*
-man
-nano
-pciutils
-plymouth*
-usermode
-usbutils
-vconfig
-xorg-x11-drv*
-yum-autoupdate

sendmail
sendmail-cf

%end

