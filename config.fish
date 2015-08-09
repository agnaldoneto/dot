# Remember my language!
set -x LANG en_US.utf8
set -x LC_ALL en_US.utf8
set -x fish_color_cwd cyan

# start X at login
#if status --is-login
#    if test -z "$DISPLAY" -a $XDG_VTNR = 1
#        exec startx
#   end
#end

# Path updates
set -x PATH $PATH ~/.cabal/bin /usr/bin ~/.bin

# Java
#set -x JAVA_HOME /usr/lib/jvm/default
#set -x PATH $PATH $JAVA_HOME/bin
#set -x _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#set -x _JAVA_AWT_WM_NONREPARENTING 1
