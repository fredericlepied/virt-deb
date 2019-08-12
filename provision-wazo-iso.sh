#!/bin/bash

dir=$(dirname $0)

$dir/provision-debian-vm.sh iso $dir/../wazo-pbx/wazo-iso/workspace/wazo-engine.iso no

sleep 20

virsh send-key iso --codeset linux --holdtime 100  KEY_DOWN KEY_DOWN KEY_ENTER \
    KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_DOWN KEY_ENTER

# provision-wazo-iso.sh ends here
