## Microshift requires specific disk layout
## See: https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift/4.12/html/installing/microshift-embed-in-rpm-ostree#provisioning-a-machine_microshift-embed-in-rpm-ostree
zerombr
clearpart --all --initlabel
part /boot/efi --fstype=efi --size=200
part /boot --fstype=xfs --asprimary --size=800
part pv.01 --grow
volgroup rhel pv.01
logvol / --vgname=rhel --fstype=xfs --size=10000 --name=root

## Installing RHEL for Edge from the embedded ostree repo
ostreesetup --osname=rhel --url=file:///run/install/repo/ostree/repo --ref=rhel/8/x86_64/edge --nogpg

## Creating a user named core with a password + SSH key
## Substitute your own crypted password + SSH key
user --name core --password $6$EaN0... --iscrypted --shell /usr/bin/bash --groups wheel --homedir /home/core
sshkey --username core "ssh-rsa AAAAB...."

## Defintely want network
network --bootproto=dhcp

## Configure the firewall rules ahead of time
## See the docs linked above
%post --log=/var/log/anaconda/post-install.log --erroronfail
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16
firewall-offline-cmd --zone=trusted --add-source=169.254.169.1
%end
