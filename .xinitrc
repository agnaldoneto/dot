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

# Set up an icon tray
 
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
 
# Set the background color
 
xsetroot -solid midnightblue
 
# Fire up apps

# start xscreensaver
/usr/bin/xscreensaver -no-splash &

# Start xmonad
exec xmonad
