# roger-skyline-1.5
This project, is about installing a Virtual Machine, and discover the basics about system and network administration as well as a lots of services used on a server machine.

## Mandatory Part
## VM Part
For this part of the assignment we have to create a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) in the [hypervisor](https://en.wikipedia.org/wiki/Hypervisor) of our choice. There are plenty of hypervisors out there, but we chose [VirtualBox](https://www.virtualbox.org/) because it's quite intuitive and easy to use.

* [Creating the Virtual Machine](./README/creating_vm.md)

Once the **VM** has been created, we must install a Linux-based operating system. Again, there are lots of Linux distros, but we went with with [Ubuntu Server](https://ubuntu.com/download/server) for its relative popularity of use in servers.

* [Installing Ubuntu Server](./README/installing_ubuntu_server.md)

During the creation of the VM, we added a virtual disk with a disk of **8 GB**, and during the installation of the operating system we created a partition **4.2 GB** in it. There are several ways of checking the **disk size** and that the required **4.2 GB** partition is there; the `fdisk` command is one of them:
```
sudo fdisk -l
```

> Note that we're using `fdisk` with the `--list` option (or `-l` for short). If we don't specify a device, we'll get a list of **all the devices** mentioned in the `/proc/partitions` file.

Finally, the subject asks us to make sure all the packages required in the project are **up to date**. In Ubuntu and other Debian-based distros there are two commands to update our package system:

* `sudo apt update`, which updates the **Ubuntu repositories**. The repositories are the servers containing packages and related metadata. The list of repositories used by our system can be checked in the `/etc/apt/sources.list` file.
* `sudo apt upgrade`, which updates **all** of the updatable packages on our Ubuntu system.

## Network and Security Part
### Create non-root user
The first point of the assignment is to create a non-root user to connect to the machine and work. That was already done during the installation, but could be easily done with:
```
# useradd -m bob
```
> The `-m` option is short for `--create-home`, and it's used to create a **home directory** for our user.

### Add user to sudo
We're also asked to be able to use `sudo` with our non-root user, which is already possible with the user that we created during the installation. If that wasn't the case, we would have to do:
```
# usermod -aG sudo bob
```

* The `-a` (short for `--append`) flag is essential. Otherwise, the user will be removed from any groups, not in the list.
* The `-G` (short for `--Groups`) option takes a (comma-separated, without whitespace at all) list of additional groups to assign the user to.
* Note that the user `bob` is the **last argument**.

### Static IP
The assignment forbids us to use the DHCP service of our machine. Instead we gotta configure it to have a **static IP** and a **Netmask** in `\30`.

![no nat](README/images/network_security/01_no_nat.png)

> In our `init` project we were using the default Attached to NAT, so in order to connect to our **virtual machine** from our mac **host**, we had to use the loopback interface (127.0.0.1) not a **static ip**. That's why we had to add a **Port Forwarding Rule** (clicking in `Advance > Port Forwarding`).

The first thing we have to do is open the VirtualBox **settings** and go to the **Network** tab. Once there, we have to change the **NAT** setting to **Bridge Adapter**.

![bridged adapter](README/images/network_security/02_bridged_adapter.png)

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

### SSH Settings
The assignment requires the following SSH settings:
* Change the port of the SSH service to one of our choice.
* SSH access must be done only with **public keys**.
* SSH **root access** should not be allowed.

We can set all the settings above by editing the `/etc/ssh/sshd_config` file. But before anything, let's upload our **public key** to the server, later we'll see why.

For this section we'll assume that we have the `ssh` server installed in our machine. Otherwise, that's trivial to fix with:
```
sudo apt install openssh-server -y
```

### Public Keys
To upload our **public key** to the server we can use the [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id) command. 
```
ssh-copy-id -i ~/.ssh/hive.pub roger@192.156.1.2
```

> `ssh-copy-id` is a handy tool provided by OpenSSH for copying public keys to remote systems. It even creates required directories and files.

Now it's a good idea to edit the `/etc/ssh/sshd_config` file and add the line:
```
PasswordAuthentication no
```

### Change Port and set No Root Access
By default, the SSH server on Ubuntu listen on TCP **port 22**. To change that we just have to edit the aforementioned file:
```
sudo vim /etc/ssh/sshd_config
```

And add the self-explanatory line:
```
Port 69
```

And while we're here, let's forbid **root access** by adding the line:
```
PermitRootLogin no
```

After all these changes have been done, we have to restart the `ssh` service:
```
sudo systemctl restart ssh
```

## Firewall Rules
For this section we'll be using the [Uncomplicated Firewall](https://en.wikipedia.org/wiki/Uncomplicated_Firewall), which was made available by default in all Ubuntu installations after 8.04 LTS.

So far the only service we're using to communicate with our VM has been `ssh`, so let's add a rule for it:
```
sudo ufw allow "OpenSSH"
sudo ufw allow 69/tcp
```

> "OpenSSH" is name of the application profile we want to enable. We can obtain these names with `sudo ufw app list` command.

Since later on in the subject, we have to set a **web server**, we could take the chance to create rules to allow access:
```
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

> Port `80/tcp` is for HTTP, whereas `443/tcp` is for HTTPS.

The last step would be to enable the firewall:
```
sudo ufw enable
```

And check its **status**:
```
sudo ufw status
```

## Set a protection against DoS
A [DoS](https://en.wikipedia.org/wiki/Denial-of-service_attack) is is a cyber-attack in which the perpetrator seeks to make a machine or network resource unavailable typically accomplished by flooding the targeted machine or resource with superfluous requests in an attempt to overload systems.


---
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

<!-- navigation -->
[home]: #
[back]: #
[next]: ./README/creating_vm.md

