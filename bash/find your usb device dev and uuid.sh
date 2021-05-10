for devlink in /dev/disk/by-id/usb*; do echo "$(readlink -f ${devlink}) : $devlink"; done

// once you find the uuid, you can always use it like: /dev/disk/by-id/usb-ADATA_USB_Flash_Drive_128312106135015D-0:0
