# Set a protection against Port Scans
One of the assignments is to set up a protection against scans on your VM’s open ports. For this purpose we'll use a tool named [Port Scan Attack Detection] (http://www.cipherdyne.org/psad/) (PSAD for short), which, as the name indicates, is used to block port scanning on servers.

> You may have heard of [Nmap](https://nmap.org/), a well-known tool mostly used for launching port scan to detect open/close ports.

PSAD tool continuously monitors firewall ([iptables](https://en.wikipedia.org/wiki/Iptables) in case of linux platform) logs to determine port scan or any other attack occurred. In case of successful attack on the server, PSAD also takes action to deter the threat.

To install it:
```
sudo apt update && sudo apt install psad
```

Once installed, we must edit the configuration file under `/etc/psad` directory. Lets start by editing the main psad configuration `/etc/psad/psad.conf` as follows:
```
# Our hostname
HOSTNAME				roger-skyline-1

# Change syslog file (by default, psad search for logs in /var/log/messages)
IPT_SYSLOG_FILE			/var/log/syslog

# Enable PSAD to manage firewall rules
ENABLE_AUTO_IDS			Y

# Enable iptables blocking
IPTABLES_BLOCK_METHOD	Y

# Disable email notifications
ALERTING_METHODS		noemail
```

Now we have to edit one more file in `/etc/psad/auto_dl` and the following line:
```
127.0.0.0/8      0
```

Then update the signatures database so that it can correctly recognize known attack types:
```
sudo psad --sig-update
```

And restart `psad`:
```
psad -R
```
