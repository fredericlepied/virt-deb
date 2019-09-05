#!/bin/bash

set -ex

cleanup() {
    if [ $name != wazo ]; then
        rm -rf $(dirname $preseed)
    fi
}

dir=$(dirname $0)
pool=/home/pool1

if [ -r $dir/config ]; then
    . $dir/config
fi

if [ $# -eq 0 ]; then
    name=wazo
else
    name=$1
fi

if [ $# -lt 2 ]; then
    iso=$dir/debian-10.0.0-amd64-netinst.iso
    if [ ! -r $dir/debian-10.0.0-amd64-netinst.iso ]; then
        wget -O $dir/debian-10.0.0-amd64-netinst.iso https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.0.0-amd64-netinst.iso
    fi
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

if [ -z "$ssh_key" ]; then
    ssh_key="$(ssh-add -L|head -1)"
fi

if [ -n "$USER" -a "$USER" != fred ]; then
    sed -i -e "s/fred/$USER/g" -e "s|@ssh_key@|$ssh_key|g" $preseed
else
    sed -i -e "s|@ssh_key@|$ssh_key|g" $preseed
fi

if [ -n "$domain" -a "$domain" != local ]; then
    sed -i -e "s@d-i netcfg/get_domain string local@d-i netcfg/get_domain string $domain@" $preseed
fi

mac="$($dir/name2mac.py $name)"

if [ $# -eq 3 ]; then
    preseed_opt=
    iso_load="--cdrom=$iso"
else
    preseed_opt="--initrd-inject=$preseed"
    iso_load="--location=$iso"
fi

if [ -f $pool/$name.img ]; then
    virsh destroy $name || :

    virsh undefine $name --remove-all-storage
fi

qemu-img create -f qcow2 $pool/$name.img 10G

virt-install --name=$name --disk path=$pool/$name.img --graphics spice --vcpu=1 --ram=1024 $iso_load --network bridge=virbr0,mac=$mac --os-variant debian9 $preseed_opt && cleanup &

# provision-debian-vm.sh ends here
