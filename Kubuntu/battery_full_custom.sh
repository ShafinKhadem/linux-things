#!/bin/bash

battery_status() {
    read -r line < /sys/class/power_supply/BAT0/status
    echo $line
}

# Modified from https://askubuntu.com/a/1358853
while true; do
    battery_level=`cat /sys/class/power_supply/BAT0/capacity`
    if [[ $(battery_status) == "Charging" || $(battery_status) == "Unknown" ]] && [[ $battery_level -ge 95 ]]; then
        while true; do
            tmp=($(pactl get-sink-volume @DEFAULT_SINK@))
            tmp=${tmp[4]}
            volume=${tmp:0:$((${#tmp}-1))}
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga --volume=$((3000000/$volume))
        done &
        kdialog --passivepopup "Battery now fully charged."
        while [[ $(battery_status) != "Discharging" ]]; do sleep 1; done
        pkill -P $! && kill $!
    fi
    sleep 300
done
