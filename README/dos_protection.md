# Set a protection against DoS
One of the available options against DoS attacks is the [fail2ban](https://en.wikipedia.org/wiki/Fail2ban) framework, which is used to block selected IP addresses that may belong to hosts that are trying to breach the system's security. It can ban any host IP address that makes too many login attempts or performs any other unwanted action within a time frame defined by the administrator.

> A [DoS](https://en.wikipedia.org/wiki/Denial-of-service_attack) is is a cyber-attack in which the perpetrator seeks to make a machine, or network resource, unavailable. This is typically accomplished by flooding the targeted machine or resource with superfluous requests in an attempt to overload systems.

The first step is to install the `fail2ban` package:
```
sudo apt-get install fail2ban
```

Once installed, we have to create a **configuration file**, but instead of starting from zero; the `/etc/fail2ban/jail.conf` offers a good starting point for our configuration. However, since this file may be overwritten during updates, it's better to create a copy of it, and add configuration changes there:
```
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

> From now on, the contents of `/etc/fail2ban/jail.local`, will override the settings contained in `/etc/fail2ban/jail.conf`.

---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./ufw.md
[next]: ./port_scans_protection.md