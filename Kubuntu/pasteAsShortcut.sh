# https://unix.stackexchange.com/questions/3543/expand-kde-activities-concept-to-the-shell

copied=$(qdbus org.kde.klipper /klipper getClipboardContents)
copied=${copied:7}
kdialog --passivepopup "script=$0; shell=$(readlink /proc/$$/exe); argument=$1; copied=$copied" 3
ln -s "$copied" "$1"