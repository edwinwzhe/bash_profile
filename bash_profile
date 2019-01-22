# .bash_profile
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PS1=$'($(hostname)) \[\e[32m\] $(pwd) \[\e[0m\] \n \xE2\x9A\xA1 '

set -o vi
alias ll='ls -lart'

### Source utils
source $CURRENT_DIR/bash_utils/utils.sh
source $CURRENT_DIR/bash_utils/python_utils.sh

if [[ $(which docker) != '' ]]
then
    source $CURRENT_DIR/bash_utils/docker_utils.sh
fi

### Colors
export _norm_="$(printf '\033[0m')" #reset "everything" to normal
export _bold_="$(printf '\033[1m')"   #set bold
export _rred_="$(printf '\033[0;1;5;31m')" #"reverse red"
export _rgreen_="$(printf '\033[0;1;5;32m')" #"reverse green"
export _red_="$(printf '\033[0;0;5;31m')" #"reverse green"
export _green_="$(printf '\033[0;2;5;32m')" #"reverse green"

### PyCharm
export GEVENT_SUPPORT=True

### Path
export PATH=$HOME/bin:$PATH:/usr/local/go/bin
