#!/bin/bash

dir=$(dirname $0)

if [ $# -eq 1 ]; then
    ISO="$1"
else
    ISO="$dir/../wazo-platform/wazo-iso/workspace/wazo-engine.iso"
fi

$dir/provision-debian-vm.sh iso $ISO no

sleep 20

virsh send-key iso --codeset linux --holdtime 100  KEY_DOWN KEY_DOWN KEY_ENTER \
    KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_ENTER

# provision-wazo-iso.sh ends here
