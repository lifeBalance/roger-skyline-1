# Set a protection against DoS
One of the available options against DoS attacks is the [fail2ban](https://en.wikipedia.org/wiki/Fail2ban) framework, which is used to block selected IP addresses that may belong to hosts that are trying to breach the system's security. It can ban any host IP address that makes too many login attempts or performs any other unwanted action within a time frame defined by the administrator.

> A [DoS](https://en.wikipedia.org/wiki/Denial-of-service_attack) (short for Denial of Service) is is a cyber-attack in which the perpetrator seeks to make a machine, or network resource, unavailable. This is typically accomplished by flooding the targeted machine or resource with superfluous requests in an attempt to overload systems.

The first step is to install the `fail2ban` package:
```
sudo apt-get install fail2ban
```

## How does it work
Fail2Ban operates by monitoring [log files](https://en.wikipedia.org/wiki/Logging_(software)) (e.g. `/var/log/auth.log`, `/var/log/apache/access.log`, etc.) for selected entries and running scripts based on them.

## Jail Configuration
A jail defines an **application-specific policy** under which fail2ban triggers an action to protect a given application. `fail2ban` comes with several jails pre-defined in `/etc/fail2ban/jail.conf`, which we could use as a good starting point for our configuration.

> Be aware that `/etc/fail2ban/jail.conf` may be overwritten during updates, so it's advisable to create a **copy** of it, and add configuration changes there.

Each jail relies on application-specific **log filters**, found in `/etc/fail2ban/filter.d` and available **actions**, which are in `/etc/fail2ban/action.d`.

### SSH Jail
Let's create a copy of the default jail file, and rename it with the `.local` extension:
```
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

> From now on, the contents of `/etc/fail2ban/jail.local`, will override the settings contained in `/etc/fail2ban/jail.conf`.

All jails share the configuration under the `[DEFAULT]` section:
```
[DEFAULT]
# Your server IP
ignoreip = 192.168.56.2
# Banned time in Seconds
bantime = 300
# Maximum times for wrong logins
maxretry = 3
# Time frame for login try
findtime = 300
backend = systemd
banaction = iptables-multiport
```

Any parameter defined in a specific jail configuration will **override** the corresponding **default**. Our configuration for `ssh` will be quite simple:
```
[ssh]
enable = true
port = 69
filter = sshd
logpath = /var/log/auth.log
```

Once we have our configuration ready, we'll upload it to the server:
```
scp -P 69 ./configs/jail.local roger@192.168.56.2:/etc/fail2ban/
scp: /etc/fail2ban//jail.local: Permission denied
```

To work around the permission denied issue, we'll upload to our home directory, and then move it after with `sudo`:
```
scp -P 69 ./configs/jail.local roger@192.168.56.2:/home/roger
```

Now we can move it after with `sudo`:
```
ssh roger@192.168.56.2 -p 69
sudo mv jail.local /etc/fail2ban/
```

Finally we must **enable** and **restart** the service:
```
sudo systemctl enable fail2ban.service
sudo systemctl restart fail2ban
```

We can check our jails with:
```
sudo fail2ban-client status
Status
|- Number of jail:      1
`- Jail list:   sshd
```

We can **test** our **ssh jail** by re-enabling `PasswordAuthentication` in the OpenSSH configuration file (`/etc/ssh/sshd_config`). Make sure you have:
```
PasswordAuthentication yes
PubkeyAuthentication no
```

Restart the `ssh` service:
```
sudo systemctl restart ssh
```

Now if we try to **log in** with the **wrong password** more than 3 times, our IP will be banned for the time we indicated in `bantime`(in seconds):
```
ssh roger@192.168.56.2 -p 69
ssh: connect to host 192.168.56.2 port 69: Connection refused
```

> We can check the IPs currently banned running `sudo fail2ban-client status sshd`.

### Apache Jail
Here we'll see how to configure `fail2ban` to protect our web server against a particular type of DoS attack: when the atacker sends more than `maxretry` `GET` requests within the time set in `findtime`. In that case we'll block that **IP** for a period of `bantime`.

> Another popular DoS attack is the good old [ping of death](https://en.wikipedia.org/wiki/Ping_of_death).

Let's add the following to our `/etc/fail2ban/jail.local` file:
```
[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/access.log
maxretry = 5
findtime = 30
bantime = 600
action = iptables[name=HTTP, port=http, protocol=tcp]
```

We also had to create configuration file for the `http-get-dos` **filter**. This is just a file under `/etc/fail2ban/filter` named `http-get-dos.conf`, with the following content:
```
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*
ignoreregex =
```

Let's upload the files to the server:
```
scp -P 69 ./configs/jail.local ./configs/http-get-dos.conf roger@192.168.56.2:/home/roger
```

Then log in again to place them in the right folder, and restart the services:
```
ssh roger@192.168.56.2 -p 69
sudo mv jail.local /etc/fail2ban/
sudo mv http-get-dos.conf /etc/fail2ban/filter.d/
service fail2ban restart
service apache2 restart
```

Now if we send more than **5** `GET` requests to our site (reload the page 5 times), our IP will be banned; we could check that running:
```
sudo fail2ban-client status http-get-dos
```

---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./ufw.md
[next]: ./port_scans_protection.md