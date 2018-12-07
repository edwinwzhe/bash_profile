# .bash_profile
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

set -o vi
alias ll='ls -lart --color=auto'

### Source utils
source $CURRENT_DIR/bash_utils/utils.sh
source $CURRENT_DIR/bash_utils/docker_utils.sh

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