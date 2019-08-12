#!/bin/bash

set -ex

cleanup() {
    if [ $name != wazo ]; then
        rm -rf $(dirname $preseed)
    fi
}

dir=$(dirname $0)

if [ $# -eq 0 ]; then
    name=wazo
else
    name=$1
fi

if [ $# -lt 2 ]; then
    iso=$dir/debian-9.9.0-amd64-netinst.iso
else
    iso=$2
fi

if [ $name = wazo ]; then
    preseed=$(mktemp -d)/preseed.cfg
    cp $dir/preseed.cfg $preseed
else
    preseed=$(mktemp -d)/preseed.cfg
    sed "s/wazo/$name/g" < $dir/preseed.cfg > $preseed
fi

if [ $# -eq 3 ]; then
    preseed_opt=
    iso_load="--cdrom=$iso"
else
    preseed_opt="--initrd-inject=$preseed"
    iso_load="--location=$iso"
fi

if [ -f /home/pool1/$name.img ]; then
    virsh destroy $name

    virsh undefine $name --remove-all-storage
fi

qemu-img create -f qcow2 /home/pool1/$name.img 10G

virt-install --name=$name --disk path=/home/pool1/$name.img --graphics spice --vcpu=1 --ram=1024 $iso_load --network bridge=virbr0 --os-variant debian9 $preseed_opt && cleanup &

# provision-vm.sh ends here
