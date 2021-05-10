#!/bin/bash

# get the class of the application using wmctrl -lx, pass it in argument 1, pass the command to execute when no active window of that class in current workspace.
# /media/shafin/01D284A91F3FF3B0/CSE/ubuntu/codes/git_repos/Problem-solving/intermediate/focusOrLaunch.sh google-chrome.Google-chrome "google-chrome"

app=$1
workspace=$(wmctrl -d | grep '\*' | cut -d ' ' -f1)
win_list=$(wmctrl -lx | grep $app | grep " $workspace " | awk '{print $1}')

IDs=$(xprop -root|grep "^_NET_CLIENT_LIST_STACKING" | tr "," " ")
IDs=(${IDs##*#})

for (( idx=${#IDs[@]}-1 ; idx>=0 ; idx-- )) ; do
    for i in $win_list; do
        if [ $((i)) = $((IDs[idx])) ]; then
            wmctrl -ia $i
            exit 0
        fi
    done
done

$2

# exit 1
