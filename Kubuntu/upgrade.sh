if [[ $(tty) != /dev/tty[1-9] ]]; then echo Please run from tty otherwise if screen is locked, you may have to use loginctl to get back && exit; fi

sudo apt update && sudo apt full-upgrade && sudo do-release-upgrade
