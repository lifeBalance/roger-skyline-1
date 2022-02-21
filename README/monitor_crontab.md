# Scheduled task to monitor `crontab`
The last task of the **Network and Security** part is double-fold:

* Create a **script** to monitor changes of the `/etc/crontab` file and sends an email to root if it has been modified. 
* Create a **scheduled task** so the script above is run every day at midnight.

## 0. Installing Mail Client
Since the script must notify by **email** to **root** about changes in the `/etc/crontab` file, we'll obviously need to install some mailing utility. We'll install [GNU mail-utils](https://mailutils.org/), since it's one of the most popular email clients:
```
sudo apt update && sudo apt install mailutils
```

During installation, we'll be prompted by `dpkg` to configure the `mail` utility:

1. We'll go with the **local** option, since we plan to just send messages the to the mailboxes of other users on the Unix system.
2. For the **mail name** we'll choose `skyline` (derived from the localhost name).

> Apart from the one from GNU, there are several other implementations of the original [mail](https://en.wikipedia.org/wiki/Mail_(Unix)) Unix utility, such as [Heirloom's mailx](http://heirloom.sourceforge.net/mailx.html), or [BSD's mailx](https://www.freebsd.org/cgi/man.cgi?query=mailx&manpath=SunOS+5.9)

### Sending Mail
In order to test out the `mail` command, we may want to send some email, so let's send ourselves a test email. For that we have several ways:
```
mail -s "Subject" "receiver@domain>" <<< "Hello buddy!"
mail -s "Subject" "receiver@domain>" < message.txt
echo "Hello buddy!" | mail -s "Subject" "receiver@domain>"
```

If you get the `Cannot open mailbox /var/mail/atechtown: Permission denied` error, it can be fixed by adding our user to the `mail` group:
```
sudo adduser roger mail
```

> Don't forget to `logout` after that, and if that doesn't work, **reboot**.

### Checking our Mailbox
To check our mailbox we just have to type `mail`. That will open the list of messages; to **open** an email we just have to type its number and `enter`.

* Press `+` to open **next** message.
* Press `-` to open **previous** message.
* Press `d` to **delete** current message. (also `d1` to delete the first, `d1,3` the first three messages, `d*` to delete all)
* Press `h` to **list all** messages.
* Press `f` to **list some** messages (`f*` to list them all, `f1, 5` messages one and five, whereas `f1-5` displays the first five messages).
* Press `q` to **quit**.

> In order to check the mail of `root`, we'll have to login as such, which in Ubuntu is done with `sudo -i`.

## 1. Monitor script
Since our script has to detect changes made to the contents of a file, we'll use a combination of two commands:

* The `shasum` command, to verify the integrity of the `/etc/crontab` file.
* The `diff` command, to compare a **new [checksum](https://en.wikipedia.org/wiki/Checksum)** with a previously stored version of it.

Here's the script:
```sh
#!/bin/sh

file=/etc/crontab
old_sum=${file}_sum.old
new_sum=${file}_sum.new

if [ ! -f $old_sum ]
then
	shasum < $file > $old_sum	# Compute old sum (if it doesn't exist)
	exit
fi

shasum < $file > $new_sum		# Compute new sum

if [ "$(diff $old_sum $new_sum)" != "" ]
then
	mail -s "crontab has been modified!" root
	shasum < $file > $old_sum
fi
```

Now we have to **upload** the script to the server:
```
scp monitor_crontab.sh roger@skyline:/home/roger/.local/bin -p 69
```

> Since we already set up [Public Key Authentication](https://www.ssh.com/academy/ssh/public-key-authentication), there's no need for password; otherwise we'd be prompted for one.

## 2. Schedule a Task
Lastly, we have to schedule a task, so the script above is run **everyday at midnight**:
```
crontab -e
```

To open our crontab file, where we'll add:
```
@midnight	/home/roger/.local/bin/monitor_crontab.sh
```
---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./crontab_packages_update.md
[next]: ./web_server.md