---
title: "Creating a static private network on VMWare Fusion with Ubuntu"
tags: ["VMWare", "Ubuntu"]
date: 2014-10-08 11:58:00 -0400
---

This tutorial is using VMWare Fusion 7, Ubuntu 14.04.1 server and OSX 10.9

The goal here is to create a private network shared with selected VMs and the host, while offering NATing to connect to the Internet. VMWare offers some [documentation](https://pubs.vmware.com/fusion-7/index.jsp?topic=%2Fcom.vmware.fusion.help.doc%2FGUID-DEB1FB99-0E44-4AAA-9693-6C2687098F13.html), which works great with DHCP, but I needed to specify everything static for custom needs.

### Creating a private network

1. Go to the Network tab of general settings (⌘,)
2. Unlock the screen by clicking on the lock.
3. Add a custom network by clicking on the +.
4. Make sure all options are checked (see screenshot).
5. Specify a subnet IP, I will be using 192.168.200.0.
   Activating the DHCP here is needed for the host to connect to it, even though our VMs will be using static IPs.

{% include figure popup=true image_path="/assets/images/posts/static-private-network-vmware-fusion-ubuntu/Screen+Shot+2014-10-08+at+11.43.17+AM.png" %}

### Configure the VM’s network adapter

1. Make sure your VM is powered off.
2. Go to the VM’s settings (⌘E)
3. Click on Network Adapter.
4. Select your newly created network (for me it was `vmnet2`).


{% include figure popup=true image_path="/assets/images/posts/static-private-network-vmware-fusion-ubuntu/Screen+Shot+2014-10-08+at+11.35.28+AM.png" %}

### Configure the OS’s network adapter

1. Edit the network interfaces: 
   ```sh
   $ sudo nano /etc/network/interfaces
   
   # The loopback network interface
   auto lo
   iface lo inet loopback
   
   # The primary network interface
   auto eth0
   iface eth0 inet static
     address 192.168.200.100
     netmask 255.255.255.0
     gateway 192.168.200.2
     dns-nameservers 192.168.200.2
   ```
2. Reboot
3. Check to see if Internet works:
   ```sh
   ping google.com
   ```
4. Check to see if you can see your host:
   ```sh
   ping 192.168.200.1
   ```
5. Try SSHing to your VM from your host:
   ```sh
   ssh 192.168.200.100
   ```

You can add more VMs to this private network, just remember to change the IP from `192.168.200.100` to something else from `192.168.200.3` to `192.168.200.253`.
