# Firewall Rules
For this section we have to have to set the rules of your firewall on your server only with the services used
outside the VM.

> We'll be using [UFW](https://en.wikipedia.org/wiki/Uncomplicated_Firewall) (short for Uncomplicated Firewall), which was made available by default in all Ubuntu installations after 8.04 LTS. It's an interface to [iptables](https://en.wikipedia.org/wiki/Iptables), which is a program to configure the configure the IP packet filter rules of the [Netfilter kernel framework](https://en.wikipedia.org/wiki/Netfilter). In short, **ufw** is an easy alternative to **iptables**.

If for some reason, `ufw` not installed:
```
sudo apt update && sudo apt install ufw
```
## Default policies
By default, **UFW** is set to **deny all incoming connections** and **allow all outgoing connections**. This means anyone trying to reach your server would not be able to connect, while any application within the server would be able to reach the outside world. Additional rules to allow specific services and ports are included as exceptions to this general policy.

> If we start the firewall straight ahead, using `sudo ufw enable`, we may find ourselves unable to access our server. That's why we have to take some previous steps.

The default policies are generally enough for **personal computers**, but **servers** need to accept some incoming connections from the outside (for example, SSH or HTTP connections), which means that UFW must be set to allow them. These policies can be changed with the commands:
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## Creating UFW rules
There are three ways of creating **UFW rules**:

* Using **application profiles**.
* Using **service names**.
* Using **ports**.

### 1. Application Profiles
Upon installation, most applications that rely on network connections will register an application profile within UFW, which enables users to quickly allow or deny external access to a service. You can check which profiles are currently registered in UFW with:
```
sudo ufw app list
Available applications:
  OpenSSH
```

As we can see, there's a profile available for [OpenSSH](https://www.openssh.com/). To enable this profile we can run:
```
sudo ufw allow "OpenSSH"
```

> "OpenSSH" is name of the **application profile** we want to enable. We can obtain these names with `sudo ufw app list` command.

### 2. Service Names
Another way to configure **UFW** to allow incoming connections for a given service, it's by referencing the service name; for example, to create a rule to allow `ssh` connections we can also do:
```
sudo ufw allow ssh
```

### 3. Using Ports
Another way of enable incoming connections for a given service, is to use the **port** that the service use for connecting. For example, if our SSH connection is using the **port 69**, we could enable SSH connections with:
```
sudo ufw allow 69/tcp
```

Since later on in the subject, we have to set a **web server**, we could take the chance to create rules to allow access using the ports/protocols:
```
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

> Port `80/tcp` is for HTTP, whereas `443/tcp` is for HTTPS.

### Enabling UFW
Finally, once we have rules in place to allow for incoming/outcoming connections, we are ready to enable the firewall:
```
sudo ufw enable
```

And check its **status**:
```
sudo ufw status
```

---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./README/ssh.md
[next]: ./README/dos_protection.md