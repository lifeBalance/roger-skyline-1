# SSH Settings
The assignment requires the following SSH settings:
* Change the port of the SSH service to one of our choice.
* SSH access must be done only with **public keys**.
* SSH **root access** should not be allowed.

We can set all the settings above by editing the `/etc/ssh/sshd_config` file. But before anything, let's upload our **public key** to the server, later we'll see why.

For this section we'll assume that we have the `ssh` server installed in our machine. Otherwise, that's trivial to fix with:
```
sudo apt install openssh-server -y
```

## Public Keys
To upload our **public key** to the server we can use the [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id) command. 
```
ssh-copy-id -i ~/.ssh/hive.pub roger@192.156.1.2
```

> `ssh-copy-id` is a handy tool provided by OpenSSH for copying public keys to remote systems. It even creates required directories and files.

Now it's a good idea to edit the `/etc/ssh/sshd_config` file and add the line:
```
PasswordAuthentication no
```

## Change Port and set No Root Access
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