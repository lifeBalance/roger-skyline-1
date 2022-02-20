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

* [Static IP](./README/static_ip.md)
* [SSH](./README/ssh.md)
* [Firewall](./README/ufw.md)
* [Set a protection against DoS](./README/dos_protection.md)
* [Set a protection against Port Scans](./README/port_scans_protection.md)
* [Stop Needless Services](./README/stop_needles_services.md)
* [Schedule a Task for Updating Packages](./README/crontab_packages_update.md)
* [Monitor crontab](./README/monitor_crontab.md)


---
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

<!-- navigation -->
[home]: #
[back]: #
[next]: ./README/creating_vm.md

