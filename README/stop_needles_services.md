# Stop Needless Services
There are two common methods to interact with services on Linux:

* The `systemctl` command.
* The `service` command.

> To give a bit of background, traditionally, [init](https://en.wikipedia.org/wiki/Init) is the first process started by the kernel when we boot our machine. It has the [PID](https://en.wikipedia.org/wiki/Process_identifier) ``1``, and continues running until the system is shut down.

Traditionally, Unix and Unix-like systems, have been using an **init system** that is somewhat compatible with the one used by [Unix System V](https://en.wikipedia.org/wiki/UNIX_System_V). That was up until [systemd](https://en.wikipedia.org/wiki/Systemd) entered the scene.

The `service` command is a **wrapper script** that allows system administrators to start, stop, and check the status of services without worrying too much about the actual init system being used. Prior to systemd's introduction, it was a wrapper for `/etc/init.d` scripts and Upstart's `initctl` command, and now it is a wrapper for these two and `systemctl` as well.

## Listing Services
Before stopping any service, we need a **list** of the ones that are running. We'll see how to do that using both `service` and `systemctl`.

It's important to differentiate between when a service is:
* **enabled**: a service (unit) configured to start when the system boots.
* **active**: a service (unit) that is currently running.

> At this point, I find the output of the `service` command way more digestible than the one of `systemctl`.

### Using `systemctl`
To check **all** services:
```
systemctl list-units --type service --all
```

To check the ones that are **enabled**:
```
sudo systemctl list-unit-files --type service | grep enabled
```

### Using `service`
In order to do that, we have to start by listing them:
```
sudo service --status-all
```

That must show us a list of all the services (enabled or not) that we have in our system. Since these services are configured in files under the `/etc/init.d` folder, the command above will shows us the list of files in that directory. But the ones that are **enabled** are preceded by a `[ + ]` sign, so we could `grep` the ones that we're interested:
```
sudo service --status-all | grep +
```

## Disabling Services
While the `service` command allows us to **list**, **start**, **stop**, and **restart** services easily, **disabling** them is a bit more confusing. For this reason, we'll focus on `systemctl` when it comes to **disable** services. Basically two steps:

* `stop` the service, so it stops running right now.
* `disable` the service, so that it's not automatically started after rebooting.

For example, let's say we want to take care of the `unattended-upgrades` service:
```
sudo systemctl stop unattended-upgrades
sudo systemctl disable unattended-upgrades
```