#!/bin/bash

[[ $EUID == 0 ]] && echo "Can't run as root" && exit

function needssudo() {
    whoami
    echo ~
    echo $HOME
    echo $PATH

    apt install -y apt-transport-https
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
    apt update
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
    apt install -y ~/Downloads/google-chrome-stable_current_amd64.deb git g++ sublime-text uncrustify clang default-jre
    snap install gitkraken --classic

    # run following lines after checking iff they don't exist already
    echo gtk-recent-files-enabled=false >> ~/.config/gtk-3.0/settings.ini
    echo gtk-recent-files-enabled=false >> ~/.config/gtk-4.0/settings.ini
    echo '
    export LANG="en_US.utf8"
    export LANGUAGE="en_US.utf8"
    export LC_ALL="en_US.utf8"' >> ~/.profile

}

#NOTE in single command sudo -s command, ~ or $VAR is expanded immediately hence it falsely seems that environment is maintained.
sudo -E --preserve-env=PATH bash -c "$(declare -f needssudo); needssudo"  # -E doesn't preserve PATH, instead changes path to secure_path defined in /etc/sudoers

#NOTE alternatively we can put all sudo commands in heredoc with:
# sudo -E --preserve-env=PATH -s << EOF
# # sudo commands
# whoami
# echo ~
# echo $HOME
# echo $PATH
# EOF


# automount local disk E in /mnt/shafin using gnome-disk-utility and following https://askubuntu.com/a/165462, add `,permissions` to the mount options

# nano ~/.bashrc -> uncomment # force_color_prompt=yes, now you can use tty with Colors.
# sudo nano /root/.bashrc -> uncomment # force_color_prompt=yes, now you can sudo su with Colors.
