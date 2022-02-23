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
$ sudo -i
# useradd -m bob
```

> In Ubuntu, `sudo -i` is used to log in as `root`.

The `-m` option is short for `--create-home`, and it's used to create a **home directory** for our user.

### Add user to sudo
We're also asked to be able to use `sudo` with our non-root user, which is already possible with the user that we created during the installation. If that wasn't the case, we would have to do:
```
# usermod -aG sudo bob
```

* The `-a` (short for `--append`) flag is essential. Otherwise, the user will be removed from any groups, not in the list.
* The `-G` (short for `--Groups`) option takes a (comma-separated, without whitespace at all) list of additional groups to assign the user to.
* Note that the user `bob` is the **last argument**.

The next parts of the assignment have separate notes:

* [Static IP](./README/static_ip.md)
* [SSH](./README/ssh.md)
* [Firewall](./README/ufw.md)
* [Set a protection against DoS](./README/dos_protection.md)
* [Set a protection against Port Scans](./README/port_scans_protection.md)
* [Stop Needless Services](./README/stop_needles_services.md)
* [Schedule a Task for Updating Packages](./README/crontab_packages_update.md)
* [Monitor crontab](./README/monitor_crontab.md)

## Web Server
As an **optional** part of the assignment, we have to:

* Set a [web server](https://en.wikipedia.org/wiki/Web_server) of our choice (between [Nginx](https://docs.nginx.com/nginx/admin-guide/web-server/) and [Apache](https://httpd.apache.org/)).
* Set a self-signed [SSL](https://www.ssl.com/faqs/faq-what-is-ssl/) certificate on all of your services.
* Set a web application from those choices:

	* A login page.
	* A display site.
	* A wonderful website that blow our minds.

We explain how to deal with these tasks in separate sections:

* [Setting up a web server](./README/web_server.md)

## Website Deployment
The last task of the optional part of the project is to propose a *functional* deployment solution.

* [Website Deployment](./README/deployment.md)

## Submitting Project
The project's subject states that we do **not** have to **return** our **virtual machine**, but a [checksum](https://en.wikipedia.org/wiki/Checksum) of its **virtual disk** file. We can do this with:
```
shasum < /home/rodrodri/VirtualBox VMs/roger.vdi > virtual_disk.sha1
```

Note that during evaluation, we may have to make some changes in the machine in order to show how everything works. Those changes will affect the **checksum** of the virtual disk, and further evaluators will notice that the **checksum** we submitted doesn't match the one we submitted. In order to avoid that we can do two things:

1. Before starting the evaluation, we must:

* Create a **snapshot** of the machine. So select the virtual machine so that the **VirtualBox VM** toolbar shows up. Then click on `Machine > Take Snapshot`, and name me whatever you want.
* After the correction is over click **Restore Snapshot** then **Delete Snapshot**. You can create new Snapshot for new evaluation.

2. The other thing is to create a **backup** of the **virtual disk**, which we can put back in the VM in case we forget about the Snapshot.

### Mounting a Virtual Disk
Imagine the snapshot thingie failed miserably, well, luckily we have a backup of the **virtual disk**. Installing it into the **virtual machine** is a two-step process:

1. First we gotta get rid of the **old virtual disk**. Click on the **VM manager** to activate the **VirtualBox** toolbar. Then click on `File > Virtual Media Manager`; once the manager is open we have to select the **old virtual disk**, then click on the **Release** icon in order to detach the **virtual disk** file from the controller. Then we have to click on the **Remove** icon to remove the media from VirtualBox.

2. Second, we proceed to mount the **new virtual disk** in a **virtual machine**. Click on the **virtual machine** where you want to install the disk, open its **settings**, and under the **storage** section: add a new hard disk attachment to the SATA controller. Choose existing VDI, select your VDI.

### For the evaluator
In order to check the **virtual machine** is in the same state than when we submitted the project:
```
shasum < roger.vdi > evaluation.sha1
diff virtual_disk.sha1 evaluation.sha1
```

If everything is **ok**, we shouldn't get any output.

---
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

<!-- navigation -->
[home]: #
[back]: #
[next]: ./README/creating_vm.md

