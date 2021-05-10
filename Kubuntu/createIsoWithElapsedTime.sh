#!/bin/bash

[[ $EUID == 0 ]] && echo "Can't run as root" && exit

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

cd ~/livecdtmp

sudo apt install -y pv

START=$SECONDS
function seconds() {
    echo $(($SECONDS-$START))
}

# xyz=$(kdialog --title "Go to sleep" --progressbar "Elapsed time:<br>$(($SECONDS-$START)) seconds");
# export xyz  # otherwise no heredoc will get it.
# qdbus $xyz showCancelButton false
# qdbus $xyz Set "" maximum 100;
# qdbus $xyz Set "" value 1;
# while true; do
#     sleep 1
#     qdbus $xyz setLabelText "Elapsed time:<br>$(seconds) seconds" || break;
# done &

# sudo only remembers password for 5 minutes, hence inserting all sudo commands at once:
#NOTE in single command sudo -s command, ~ or $VAR is expanded immediately hence it falsely seems that environment is maintained.
sudo -E --preserve-env=PATH -s << 'EOF' | pv -t  # -E doesn't preserve PATH, instead changes path to secure_path defined in /etc/sudoers

chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
rm extract-cd/casper/filesystem.squashfs extract-cd/casper/filesystem.squashfs.gpg
mksquashfs edit extract-cd/casper/filesystem.squashfs || exit
printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size

# qdbus $xyz Set "" value 40;

cd extract-cd
xorriso -as mkisofs -r -J -joliet-long -l -iso-level 3 -o ../custom.iso . -V 'Kubuntu 21.04 amd64 GGSK' --modification-date='2021042011024500' --grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:'/mnt/shafin/CSE/necessary/kubuntu-21.04-desktop-amd64.iso' --protective-msdos-label -partition_cyl_align off -partition_offset 16 --mbr-force-bootable -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:local_fs:5733688d-5743727d::'/mnt/shafin/CSE/necessary/kubuntu-21.04-desktop-amd64.iso' -appended_part_as_gpt -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 -c '/boot.catalog' -b '/boot/grub/i386-pc/eltorito.img' -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info -eltorito-alt-boot -e '--interval:appended_partition_2_start_1433422s_size_10040d:all::' -no-emul-boot -boot-load-size 10040
cd ../

# qdbus $xyz Set "" value 65;

# for devlink in /dev/disk/by-id/usb*; do echo "$(readlink -f ${devlink}) : $devlink"; done
dd bs=64K if=custom.iso of=/dev/disk/by-id/usb-ADATA_USB_Flash_Drive_128312106135015D-0:0 status=progress
# writable part is ext4 by default, which is unsupported in android, so format it to fat32:
sudo mkfs.vfat -F 32 -n writefat /dev/disk/by-id/usb-ADATA_USB_Flash_Drive_128312106135015D-0:0-part4
# in my 64GB usb drive, no writable 4th part is created, can't even create one from gnome-disks, has to create
# partition manually from terminal before formatting that partition from gnome-disks:
# sudo parted /dev/disk/by-id/...-part4 -> print-> check that end is 3787MB-> mkpart primary 3787MB 100%-> ctrl+d

# qdbus $xyz Set "" value 99;

EOF

# kill %1
# qdbus $xyz close;

paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga --volume=100000 &
kdialog --msgbox "<font size=5 color=yellow>USB is ready in $(date -d@$(seconds)  -u +'%M minutes %S seconds')</font>" "Go fuck yourself" --ok-label "oh! finally!!"
