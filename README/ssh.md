# SSH Settings
The assignment requires the following SSH settings:
* Change the port of the SSH service to one of our choice.
* SSH access must be done only with **public keys**.
* SSH **root access** should not be allowed.

We can set all the settings above by editing the `/etc/ssh/sshd_config` file. But before anything, let's upload our **public key** to the server (later we'll see why).

For this section we'll assume that we have the `ssh` server installed in our machine. Otherwise, that's trivial to fix with:
```
sudo apt install openssh-server -y
```

## Uploading Public Keys
Since we're planning to log in using public keys, it's a good idea to start with uploading them to the server, so we don't get **locked out** in case we disable `PasswordAuthentication`. We can use the [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id) command. 
```
ssh-copy-id -i ~/.ssh/hive.pub roger@192.156.1.2
```

> `ssh-copy-id` is a handy tool provided by OpenSSH for copying public keys to remote systems. It even creates required directories and files.

Now it's a good idea to edit the `/etc/ssh/sshd_config` file and add the line:
```
PasswordAuthentication no
PubkeyAuthentication yes
```
## Configuration Changes
There are several files where `sshd` read settings from:

* The main file is `/etc/ssh/sshd_config`
* Files under the `/etc/ssh/sshd_config.d/` directory.

We just have to make sure that the main file contains the line:
```
Include /etc/ssh/ssh_config.d/*.conf
```

If that's the case, we can just upload to the server a configuration file we have prepared in advance; this is what my `roger.conf` files looks like:
```
Port 69
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

We just have to upload it to the server:
```
scp ./roger.conf roger@192.168.56.2:/home/roger
```

Then we can log into the server and move the file to the right folder:
```
ssh roger@192.168.56.2
sudo mv ~/roger.conf /etc/ssh/ssh_config.d/
```

After all these changes have been done, we have to **restart** the `ssh` service:
```
sudo systemctl restart ssh
exit
```

> Later on, if you try to find the `roger.conf` that we placed in `/etc/ssh/ssh_config.d/`, you won't be able to find it, because the settings it contained will be integrated in the main `/etc/ssh/ssh_config` file.

From now on, we won't need to enter our password to log in:
```
ssh -p 69 roger@192.168.56.2
```

Also, since the port is not the **default** anymore (`22`), we have to specify it.
---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./static_ip.md
[next]: ./ufw.md