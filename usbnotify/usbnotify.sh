#!/bin/bash
# deps: udisks, sw-notify-send
# udev: 00-usb.rules: KERNEL=="sd*",RUN+="/opt/usbadd.sh"

if [ $ID_FS_USAGE == "filesystem" ]; then
    S=$(echo "scale=1; ${UDISKS_PARTITION_SIZE}/1024/1024/1024" | /usr/bin/bc -l)
    L=$(echo $DEVLINKS | sed 's/ /\n/g' | grep "by-label" | sed 's/\//\n/g' | tail -n1 | sed 's/\\x20/ /g')
    if [[ -z $(echo $L | sed 's/[ \n\r]//g') ]]; then
        L=$(echo $DEVLINKS | sed 's/ /\n/g' | grep "by-uuid" | sed 's/\//\n/g' | tail -n1)
    fi

    if [ $ACTION == "add" ]; then
    	/usr/bin/sw-notify-send \
    		-i drive-removable-media \
            "${L} (${ID_FS_TYPE}, ${S} Гб)" -- \
    		"Примонтирован в <a href=\"/media/${L}\">/media/${L}</a>"
    elif [ $ACTION == "remove" ]; then
    	/usr/bin/sw-notify-send \
    		-i drive-removable-media \
            "${L} (${ID_FS_TYPE}, ${S} Гб)" -- \
    		"Отмонтирован из /media/${L}"
    fi
fi
