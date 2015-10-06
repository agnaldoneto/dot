# Remember my language!
set -x LANG en_GB.utf8
set -x LC_ALL en_GB.utf8

# CWD color
set -x fish_color_cwd cyan

# Path updates
set -x PATH $PATH ~/.cabal/bin /usr/bin ~/.bin

# Java
set -x JAVA_HOME /usr/lib/jvm/default
set -x PATH $PATH $JAVA_HOME/bin

# SSH Agent
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket