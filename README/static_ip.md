# Static IP
The assignment forbids us to use the DHCP service of our machine. Instead we gotta configure it to have a **static IP** and a **Netmask** in `\30`.

![no nat](./images/network_security/01_no_nat.png)

> In our `init` project we were using the default Attached to NAT, so in order to connect to our **virtual machine** from our mac **host**, we had to use the loopback interface (127.0.0.1) not a **static ip**. That's why we had to add a **Port Forwarding Rule** (clicking in `Advance > Port Forwarding`).

The first thing we have to do is open the VirtualBox **settings** and go to the **Network** tab. Once there, we have to change the **NAT** setting to **Bridge Adapter**.

![bridged adapter](./images/network_security/02_bridged_adapter.png)

> Note how the name of the interface also changed to the one we use to connect to the internet, in my case `en0`.

Once we've done that, we have to move to our **virtual machine**. Ubuntu uses a utility named [netplan](https://netplan.io/) to easily configure the network on a linux system. First thing we have to do is to identify the name of our interface:
```
ip a
```
In my case it was named `enp0s3`. We also needed to find out our:

* IP address:  172.18.3.98
* Gateway IP:  172.18.0.1
* Subnet mask: 255.255.252.0

To configure your system to use a **static IP address**, we have to create a netplan configuration in some YAML file, under the `/etc/netplan/`. In my case there was one named `00-installer-config.yaml`, so I created another one with `sudo edit `/etc/netplan/01-static-ip.yaml` and proceeded to add the following configuration in it:
```yaml
network:
   ethernets:
      enp0s3:
         addresses: [172.18.3.99/30]
         gateway4: 172.18.0.1
         nameservers:
           addresses: [172.18.0.1]
         dhcp4: no
   version: 2
```

You simply create a YAML description of the required network interfaces and what each should be configured to do. From this description Netplan will generate all the necessary configuration for your chosen renderer tool.

---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ../README.md
[next]: ./ssh.md