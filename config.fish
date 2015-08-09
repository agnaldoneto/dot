# Remember my language!
set -x LANG en_US.utf8
set -x LC_ALL en_US.utf8
set -x fish_color_cwd cyan

# fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'
 
set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set gray (set_color -o black)

function fish_prompt
         set_color yellow
         printf '%s' (whoami)
         set_color normal
         printf ' at '
         set_color magenta
         printf '%s' (hostname|cut -d . -f 1)
         set_color normal
         printf ' in '
         set_color $fish_color_cwd
         printf '%s' (prompt_pwd)
         set_color normal
         # Line 2
         echo
         if test $VIRTUAL_ENV
            printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
         end
         printf '-> '
         set_color normal
end

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
