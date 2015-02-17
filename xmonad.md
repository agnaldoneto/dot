#A Haskell dev environment with Arch Linux, Xmonad and Emacs

In a world where most Linux users revolve around Ubuntu and desktop environments choices (Gnome vs KDE vs ...), I'm finding more and more that I want something simpler and more lightweight. The truth is that even the very barebones installations of KDE and Gnome I did for my home and work computers, were not that light: far more widgets than I needed, far more applications than I ever used; I kept uninstalling things most of the time.

Besides that, my attempt at having a rolling distribution of Debian by pointing it to the testing distribution, also meant that my system was far more unstable than I wanted. I got a rolling distribution but I lost stability.

So I rethought all these constraints and how to accomodate them better with a new distribution. Here's what I want:

- A distribution which is inherently rolling but where that doesn't mean loosing stability;
- A distribution which gets me just the bare bare minimum, from where I can iteratively build up;
- A window manager (instead of a desktop environment) which keeps out of the way and is super light on resources.

So after some reading and experimenting, I decided to go with [Arch Linux](https://www.archlinux.org/) and [xmonad](http://xmonad.org/).

Many things contributed to this decision but for sure [documentation](https://wiki.archlinux.org/) was one of the main ones for Arch. I had bumped into their wiki accidentally many many times while trying to solve problems on Debian and the quality is very very good. Besides that, I really agreed with their [design philosophy](https://wiki.archlinux.org/index.php/The_Arch_Way) and their stance in what regards simplicity.

As for xmonad, the choice was essentially based on the fact that it was implemented in Haskell, which gives me a chance to play with the source code. On top of that the fact that it is super super light on resources definitelly helped but to be honest I did not look into other possibilities.

So here I am, 24 hours later, writing this blog post on Emacs running on Xmonad on a fresh and light Arch Linux installation. The rest of this post explains how to do it.

## What you should be aware of

Depending on your experience, Arch Linux may be a bit too manual for your taste. You should definitelly read the [begginer's guide](https://wiki.archlinux.org/index.php/Beginners%27_guide), the [FAQ](https://wiki.archlinux.org/index.php/FAQ) and the [installation guide](https://wiki.archlinux.org/index.php/Installation_guide) beforehand - the documentation is really really good and it gives you a general idea of all the steps you'll have to go through, which are somewhat different than when installing Debian for example.

There are a few things you should prepare ahead of time, in my opinion, contrary to what the guide tells you:

1. Find out if your BIOS uses UEFI or not as this is very relevant for the bootloader installation. It will depend on things such as whether you have other operating systems installed or not or if you plan to do it eventually;
2. Find out to what is your BIOS time synchronized to. Is it UTC or local time?
3. Partition your hard disk before you even start this whole process. This one I cannot stress enough -- get a [gpared Live CD](http://gparted.org/livecd.php) (or whatever you prefer), boot into your computer and prepartition it. You'll get the benefit of doing it in a controlled environment, thinking well ahead of time about how you want to have your partitions. Oh and *do* write down what is each partition, i.e., `/dev/sda5` is `/`, `/dev/sda6` is `/boot`, etc.
4. Definitelly do this with the instructions opened on a laptop or something like that so that you can search for help if you get stuck.

## Getting the basic instalation medium

The CD can be downloaded from [Arch linux downloads page](https://www.archlinux.org/download/). Partition your disk, burn Arch into a CD and boot into it. You'll have a menu at boot time and then you'll be logged in as root in a prompt.

Activate the keymap you want if you don't want US english. In my case, for Portuguese:

* `loadkeys /usr/share/kbd/keymaps/i386/qwerty/pt-latin9.map.gz`

Since we already partitioned the disks, let's format them. In my case, I had 2 extended partitions (`sda5` and `sda6`) under a logical partition, after the Windows 8 partitions:

* `mkfs.ext4 /dev/sda5`
* `mkswap /dev/sda6`

Let's mount the partitions. The partition which is going to be `/` should be mounted on `/mnt`.

* `mount /dev/sda5 /mnt`
* `swapon /dev/sda6`

Now we install the base system onto `/mnt`. We'll first `vi /etc/pacman.d/mirrorlist` and leave only the best mirrors. I left all the ones until 1.5 since those included a lot of germany and european mirrors, and removed all US mirrors. It's important to note that, since I was on a wired connection, the next step works automatically for me. I haven't tried this on a wireless connection but the documentation explains how to do it.

* `pacstrap /mnt base`

This part takes a little bit. When that's done it's time to switch to the newly installed system and finish setting it up:

* `genfstab -p -L /mnt >> /mnt/etc/fstab`
* `arch-chroot /mnt`
* `bash`

This part of the configuration will surely be different for you but my examples will indicate what you should be doing on your computer:

* `echo Hamming > /etc/hostname`
* `ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
* `vi /etc/locale.gen` and uncommented `en_GB` entries and then run `locale-gen`
* `locale > /etc/locale.conf`
* `vi /etc/vconsole.conf` and add `KEYMAP=pt-latin9` and `FONT=Lat2-Terminus16`
* `hwclock --systohc --localtime`
* `systemctl enable dhcpcd.service`
* `mkinitcpio -p linux`

Now it's time to install the boot loader. This will definitelly be different for you if you decide to put GRUB on the beggining of your disk. In my case, it's in the beggining of `sda5` since Windows won't cope well with it and for that I had to do some more magic:

* `pacman -S grub`
* `chattr -i /boot/grub/i386-pc/core.img`
* `grub-install --target=i386-pc --recheck --debug --force /dev/sdaX`
* `chattr +i /boot/grub/i386-pc/core.img`
* `grub-mkconfig -o /boot/grub/grub.cfg`

Finally we give a password to root, exit bash and the chroot shell, unmount the system and reboot:

* `passwd`
* `exit`
* `exit`
* `umount /mnt`
* `systemctl reboot`

If you did everything well, you'll see an Arch Linux prompt after reboot, indicating that you just installed your system! Congratulations! So what do you have at this moment?

- only one user (`root`);
- only `vi`
- the most basic system tools and not much more.

So since we intend to get an X windows system with xmonad, emacs and Haskell ready, we need a few base things before that:

## fish and adding a user

Let's start with a few basics, like not using root for everything:

* `pacman -S sudo`
* `visudo` and uncomment the `wheel` group line

Let's get [Fish](http://fishshell.com/) as well, so that we can define it as the shell for our new user:

* `pacman -S fish`
* `chsh -s /usr/bin/fish`
* `exit` and login again

If Fish is working fine for root, we add the new user:

* `useradd --shell /usr/bin/fish --create-home -m -G wheel luis`
* `passwd luis` and set a new password
* `exit`, login as yourself and, in my case, the next first thing I did was `pacman -S emacs`.

I'll leave the configuration of emacs to another post. For now we have already a sane text editor so let's keep it at that.

## nVIDIA Driver

We can check that the nVIDIA driver works ok even without having X Windows, so let's do that:

* `pacman -S nvidia`
* `systemctl reboot`

The console will now show up in 640x480 resolution so let's change that to something nicer. For that we need to know what resolutions our graphics card can handle and for that we need a tool called `hwinfo`

* `pacman -S hwinfo`
* `hwinfo --framebuffer` will produce something like this:

		02: None 00.0: 11001 VESA Framebuffer
		  [Created at bios.459]
		  Unique ID: rdCR.y3YwIxtOSHA
		  Hardware Class: framebuffer
		  Model: "NVIDIA GK110 Board - 20830010"
		  Vendor: "NVIDIA Corporation"
		  Device: "GK110 Board - 20830010"
		  SubVendor: "NVIDIA"
		  SubDevice: 
		  Revision: "Chip Rev"
		  Memory Size: 14 MB
		  Memory Range: 0xf1000000-0xf1dfffff (rw)
		  Mode 0x0300: 640x400 (+640), 8 bits
		  Mode 0x0301: 640x480 (+640), 8 bits
		  Mode 0x0303: 800x600 (+800), 8 bits
		  Mode 0x0305: 1024x768 (+1024), 8 bits
		  Mode 0x0307: 1280x1024 (+1280), 8 bits
		  Mode 0x030e: 320x200 (+640), 16 bits
		  Mode 0x030f: 320x200 (+1280), 24 bits
		  Mode 0x0311: 640x480 (+1280), 16 bits
		  Mode 0x0312: 640x480 (+2560), 24 bits
		  Mode 0x0314: 800x600 (+1600), 16 bits
		  Mode 0x0315: 800x600 (+3200), 24 bits
		  Mode 0x0317: 1024x768 (+2048), 16 bits
		  Mode 0x0318: 1024x768 (+4096), 24 bits
		  Mode 0x031a: 1280x1024 (+2560), 16 bits
		  Mode 0x031b: 1280x1024 (+5120), 24 bits
		  Mode 0x0330: 320x200 (+320), 8 bits
		  Mode 0x0331: 320x400 (+320), 8 bits
		  Mode 0x0332: 320x400 (+640), 16 bits
		  Mode 0x0333: 320x400 (+1280), 24 bits
		  Mode 0x0334: 320x240 (+320), 8 bits
		  Mode 0x0335: 320x240 (+640), 16 bits
		  Mode 0x0336: 320x240 (+1280), 24 bits
		  Mode 0x033d: 640x400 (+1280), 16 bits
		  Mode 0x033e: 640x400 (+2560), 24 bits
		  Mode 0x034b: 1920x1080 (+1920), 8 bits
		  Mode 0x034c: 1920x1080 (+3840), 16 bits
		  Mode 0x034d: 1920x1080 (+7680), 24 bits
		  Mode 0x0360: 1280x800 (+1280), 8 bits
		  Mode 0x0361: 1280x800 (+5120), 24 bits
		  Config Status: cfg=new, avail=yes, need=no, active=unknown

You'll find some hexadecimal number on the column on the left which you should convert to decimal. In my case, the mode I was interested in was 1280x1024x24, which is `0x031b`, which is 795 in decimal. That number should now be added to `/etc/default/grub` plus the following changes:

* find the line which starts with `GRUB_GFXMODE` and update it to match the resolution you chose (in my case `GRUB_GFXMODE=1280x1024x24`);
* find the line which starts with `GRUB_GFXPAYLOAD_LINUX` and update it to say `GRUB_GFXPAYLOAD_LINUX=keep`);
* add the decimal representation of the hex mode you found with `hwinfo` to the `GRUB_CMDLINE_LINUX_DEFAULT` like so `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vga=795`
* recreate the grub configuration with `grub-mkconfig -o /boot/grub/grub.cfg` and `systemctl reboot`

# X windows and xmonad

We'll be installing a [window manager](https://wiki.archlinux.org/index.php/Window_manager), as opposed to a full [desktop environment](https://wiki.archlinux.org/index.php/Desktop_environment). It's a good idea to understand the differences between the two. For me, the main reason to go for a window manager was really [performance](https://wiki.archlinux.org/index.php/Maximizing_performance#The_first_thing_to_do). 

* `pacman -S xorg-server xorg-server-utils xorg-apps xorg-xinit xorg-message xscreensaver feh`

Let's create our nVIDIA configuration file at `/etc/X11/xorg.conf.d/20-nvidia.conf` with

        Section "Device"
			Identifier "Nvidia Card"
			Driver "nvidia"
			VendorName "NVIDIA Corporation"
			Option "NoLogo" "true"
		EndSection

I also configured my keyboard in X windows to be in portuguese plus I made the `Caps Lock` key and alternative to `CTRL` key (for emacs) and I set `CTRL+ALT+Backspace` as the combination to kill X Windows:

* `localectl set-X11-keymap pt pc104 "" caps:ctrl_modifier,terminate:ctrl_alt_bksp`

Next I configured the terminal to use the inconsolata font by creating `~/.Xresources` with the following:

        XTerm*reverseVideo: on
        xterm*faceName: Inconsolata:size=10:antialias=true

We're almost done. We now get xmonad and configure it:

* `pacman -S xmonad xmonad-contrib cabal-install xmobar ghc haddock trayer gmrun dmenu ttf-inconsolata`

The default configuration is a bit too white so let's change it. These changes are based upon several guides and tutorials found on the [xmonad page](http://xmonad.org/documentation.html), on the [Haskell wiki](https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen%27s_Configuration) and on the [Arch Linux Wiki](https://wiki.archlinux.org/index.php/Xmonad). They represent the bare minimum for me but, as with everything in this post, YMMV.

It uses [xmobar](http://projects.haskell.org/xmobar/) to have a small text based bar on the top of the screen and a background image. Nothing more.

Let's edit `~/.xmonad/xmonad.hs` and add the following Haskell code (remember to replace my references to `/home/luis` with your home directory):

        import XMonad
        import XMonad.Hooks.ManageDocks
        import XMonad.Hooks.DynamicLog
        import XMonad.Util.Run
        import XMonad.Util.EZConfig
        
        main = do
            xmproc <- spawnPipe "/usr/bin/xmobar /home/luis/.xmobarrc"
            xmonad $ defaultConfig
        	{ manageHook = manageDocks <+> manageHook defaultConfig
        	, layoutHook = avoidStruts  $  layoutHook defaultConfig
        	, logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
        	    , ppTitle = xmobarColor "green" "" . shorten 50 }
				} `additionalKeys`
				[ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") ]

We'll also edit `~/.xmobarrc` and add:

        Config { font = "-*-Fixed-Bold-R-Normal-*-13-*-*-*-*-*-*-*"
               , bgColor = "black"
               , fgColor = "grey"
               , position = TopW L 100
               , commands = [ Run Weather "EDDB" ["-t"," <tempC>C"] 3000
                            , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                            , Run Memory ["-t","Mem: <usedratio>%"] 10
                            , Run Swap [] 10
                            , Run Date "%a %b %_d %l:%M" "date" 10
                            , Run StdinReader
                            ]
               , sepChar = "%"
               , alignSep = "}{"
               , template = "%StdinReader% }{ %cpu% | %memory% * %swap%    <fc=#ee9a00>%date%</fc> | %EGPF%"
               }

Finally, find an image you like for background (I'm currently using this one), download it and edit you `~/.xinitrc`:

        #!/bin/sh
        #
        # ~/.xinitrc
        #
        # Executed by startx (run your window manager from here)
        
        if [ -d /etc/X11/xinit/xinitrc.d ]; then
          for f in /etc/X11/xinit/xinitrc.d/*; do
            [ -x "$f" ] && . "$f"
          done
          unset f
        fi
        
        # Xresources
        [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
        
        # Set the background Image
        feh --bg-fill ~/dot/lambda.jpg
         
        # start xscreensaver
        /usr/bin/xscreensaver -no-splash &
        
        # Start xmonad
        exec xmonad

At this point `startx` should start xmonad and show you your downloaded image as background.

## And there you have it!

This is a very very bare bones configuration which is supposed to be iterated. There's still many things that can be done on top of this, for example:

* X windows is not starting automatically after you login. This is a good thing to change or even, if you prefer, use a [display manager](https://wiki.archlinux.org/index.php/Display_manager);
* emacs is still not configured or themed;
* xmobar can be [tweaked even more](http://projects.haskell.org/xmobar/#configuration);
* And there's more applications to install (from the top of my head: firefox, java, node, intellij, clementine, vlc).

However, the foundation is laid - a very minimal and super fast Linux with a windowing system which just gets out of the way.

:-)
