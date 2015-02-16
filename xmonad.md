# Arch linux instalation

Prepare the partitions in advance. I used gparted live CD for this
get the CD, burn it, reboot with it.

once inside:

## Basic installation

* loadkeys /usr/share/kbd/keymaps/i386/qwerty/pt-latin9.map.gz
* mkfs.ext4 /dev/sda5
* mkswap /dev/sda6
* mount /dev/sda5 /mnt
* swapon /dev/sda6
* vi /etc/pacman.d/mirrorlist and leave only the best mirrors. I left all the ones until 1.5 since those had a lot of germany and european mirrors and removed all US mirrors
* pacstrap /mnt base
* genfstab -p -L /mnt >> /mnt/etc/fstab
* arch-chroot /mnt
* bash
* echo Hamming > /etc/hostname
* ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
* vi /etc/locale.gen and uncommented EN_GB (go europe!!!)
* locale-gen
* echo LANG=en_GB.UTF-8 > /etc/locale.conf
* vi /etc/vconsole.conf and add KEYMAP=pt-latin9 and FONT=Lat2-Terminus16
* hwclock --systohc --localtime (date still gives me one hour more though...)
* systemctl enable dhcpcd.service
* mkinitcpio -p linux
* pacman -S grub
* chattr -i /boot/grub/i386-pc/core.img
* grub-install --target=i386-pc --recheck --debug --force /dev/sdaX
* chattr +i /boot/grub/i386-pc/core.img
* grub-mkconfig -o /boot/grub/grub.cfg
* passwd
* exit
* exit
* umount /mnt

Problems at this point:

1. accented characters are not showing up accented in the console (e.g. `a instead of à)
2. the terminus font is not being loaded at all.

We'll try to address problem 1. first:

locale > /etc/locale.conf

this didn't help so I'm postponing the problem to after installing the nvidia drivers and things like that

## nVIDIA Driver

* pacman -S nvidia
* reboot
* created /etc/X11/xorg.conf.d/20-nvidia.conf with

Section "Device"
        Identifier "Nvidia Card"
        Driver "nvidia"
        VendorName "NVIDIA Corporation"
        Option "NoLogo" "true"
EndSection

Updated /etc/Default/grub to have

GRUB_GFXMODE=1280x1024x24
GRUB_GFXPAYLOAD_LINUX=keep

and GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vga=795

I had to install hwinfo to list the framebuffer modes available for me
pacman -S hwinfo

## sudo, fish and adding new user

pacman -S sudo
visudo and uncomment the wheel group line

pacman -S fish 
chsh -s /usr/bin/fish
exit and login again

useradd --shell /usr/bin/fish --create-home -m -G wheel luis
passwd luis
exit, login as luis, change password, exit, login

from this moment onwards, it's everything under luis

## X and xmonad

* pacman -S emacs xorg-server xorg-server-utils xorg-apps xorg-xinit xorg-message xmonad xmonad-contrib cabal-install xmobar ghc haddock trayer mlocate xscreensaver gmrun dmenu ttf-inconsolata git

makes xmonad start with `startx`
* emacs .xinitrc and add `exec xmonad` at the end.
* put the keyboard in portuguese on X -- `localectl set-X11-keymap pt pc104 "" caps:ctrl_modifier,terminate:ctrl_alt_bksp`

* pacman -S firefox
* pacman -S ttf

* git clone https://github.com/decomputed/dot.git
* ln -s dot/.emacs .emacs
* emacs & and watch the beauty of everything being downloaded!!!!

