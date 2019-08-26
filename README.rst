Tools to create VM using virt-install
=====================================

Start a vm::
  ./provision-debian-vm.sh [<name> [<iso file> [<no preseed>]]]

The mac address is always the same for the same name.

Install a vm from Wazo CD::
  ./provision-wazo-iso.sh [<ios file>]

Allow to specify an option in a file named config in the same
directory as provision-debian-vm.sh.

Here is the list of variables that can be specified in the config file:

ssh_key
USER
domain
pool
