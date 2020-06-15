#!/bin/bash
echo "boot2net running" >/tmp/t.t

# Remove old config if there was one
/bin/sed '/Config.*netcfg\.txt/,$ d' -i /etc/dhcpcd.conf

# Add identifier to start of new config, then copy in the config removing any windows CRs
echo "#Config from /boot/netcfg.txt" >>/etc/dhcpcd.conf
/bin/sed 's/\r//g' /boot/netcfg.txt >>/etc/dhcpcd.conf

# Rename the file on boot so that it doesn't run on subsequent reboots
/bin/mv /boot/netcfg.txt /boot/netcfg.org
