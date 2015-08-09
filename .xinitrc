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

# Set keyboard repeat rate
xset r rate 150 40

# My keys
xbindkeys

# Start xmonad
exec xmonad
