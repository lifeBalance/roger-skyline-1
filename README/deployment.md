# Deployment
There are plenty of ways we could get our site deployed:

* We could use a fully-fledged deploy system, such as [Fabric](https://www.fabfile.org/), [Jenkins](https://en.wikipedia.org/wiki/Jenkins_(software)), or [Ansible](https://en.wikipedia.org/wiki/Ansible_(software)).
* Or we could also go for the **bare minimum** approach (using `scp` or [rsync](https://en.wikipedia.org/wiki/Rsync)), that gets the job done.

But since the assignment asks just for a **functional** and **automated** solution, we'll take a middle-ground approach:

1. On the server we’ll create a **bare git repository**, which is a repository that doesn't contain any actual file.
2. On this repo will use the `post-receive` hook that once triggered, will put the files in whatever directory we want; in this case in `/var/www/evil`.
3. On our **development machine**, in this case our **host** computer, we'll add the **bare repo** we created in the server, as a **remote**. This repository could have several remotes, for example, one of them could also be in github.

> A **bare repository** is a git repository that doesn't contain the **working tree**, only the repository's **metadata**.

## Create Bare Repository on the Server
Let's `ssh` into our server and create the bare repo:
```
ssh roger@192.168.56.2 -p 69
git init --bare /home/roger/bare_evil.git
```

> By convention, the **directory name** of a **bare repository ** ends with the suffix `.git`. 

## Create a `post-receive` Hook
Now we have to create the `post-receive`file; so let's `cd` into the folder containing our bare repository, and under the `hooks` folder, let's create a script named `post-receive` with the following content:
```
#!/bin/sh

git --work-tree=/var/www/evil --git-dir=/home/roger/bare_evil.git checkout -f
```

> Don't forget that the `/var/www/evil` **folder** must exist! Also, we should have permissions to write in `/var/www` (we accomplished both things in the section before).

Let's make it executable:
```
chmod +x /home/roger/bare_evil.git/hooks/post-receive
```

What this script does, is moving the **actual files** to the argument specified in the ``--work-tree`` option. The script itself is run everytime the **bare repository** receives a new commit.

## Add Remote Repository on the Development Machine
Finally, in our development machine (in this case let's assume it's our **host**), we'll add a new remote to the repo where we're developing our site:
```
git remote add bare_evil ssh://roger@192.168.56.2:69/home/roger/bare_evil.git
```

You may need to set the upstream:
```
git push --set-upstream bare_evil master
```

From now on, everytime we push our changes to the `evil-server` remote, the `post-receive` hook will be triggered, and the files will be **deployed** to the proper directory.

> We could also `git pull` from the `bare_evil` repository.

---
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

<!-- navigation -->
[home]: ../README.md
[back]: ./web_server.md
[next]: ../README.md
