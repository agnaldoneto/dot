# Language -- should still change this to en-GB
set -x LANG en_US.utf8
set -x LC_ALL en_US.utf8

# CWD color
set -x fish_color_cwd cyan

# Splunk
set -x SPLUNK_HOME /opt/splunk

# Path updates
set -x PATH $PATH ~/.cabal/bin /usr/bin ~/.bin $SPLUNK_HOME

# SSH Agent
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
