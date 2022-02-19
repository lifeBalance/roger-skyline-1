# `cron` assignments
For this part of the assignment we have to do two things:

1. Create a **script** that updates all the sources of package, then your packages and which logs the whole in a file named /var/log/update_script.log. 
2. Create a **scheduled task** for this script once a week at **4AM** and every time the machine reboots.

## 1. Update Packages Script
We can create a folder to store our **scripts**:
```
mkdir -r ./local/bin
```

Then add it to our PATH; so in our shell configuration we'll add:
```
export PATH=$HOME/.local/bin:$PATH
```

Finally, let's write the script:
```
vim ~/.local/bin/update_packages.sh
chmod +x ~/.local/bin/update_packages.sh 
```

The contents:
```
#!/bin/sh

updates_log=/var/log/update_script.log
date > $updates_log
sudo apt update -y	> &updates_log
sudo apt upgrade -y	> &updates_log
```

## 2. Create a `cron` scheduled task
When it comes to `cron`, we have to differentiate between two utilities:

* `cron` itself is a **service** that runs in the background used to execute scheduled commands.
* The `crontab` command is used to **install**, **deinstall**, or **list** the tables used to drive the `cron` daemon. Each **user** can have their own **cron table**, which are files under the `/var/spool/cron/crontabs` directory.

In order to create a **crontab file**, we'll use the `crontab` command with the `-e` option (short for edit):
```
crontab -e
```

That will launch our default editor, or if we don't have one, offer us the choice to set one. Once the editor is set, we can proceed to edit the file. The syntax of a crontab file is as follows:
```
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
```

But if you're thinking of trying out some command to run every minute, don't try:
```
1 * * * * some_command
```

Use instead `*/1` for the first field, as in:
```
*/1 * * * * some_command
```

So if we want to run our script everyday at **4AM** we'd add:
```
0 4 * * 0	/home/roger/.local/bin/update_packages.sh
@reboot		/home/roger/.local/bin/update_packages.sh
```