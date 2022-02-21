# Setting Up a Web Server
For the web server we used [Apache](https://httpd.apache.org/) because there's plenty of information on internet about how to set it up. First step, **installation**:
```
sudo apt update && sudo apt install apache2
```

## Opening the Firewall
During installation, Apache creates an *application profile* for [UFW](https://en.wikipedia.org/wiki/Uncomplicated_Firewall), that can be used to enable or disable access. Let's check the profile is there:
```
sudo ufw app list
Available applications:
  Apache
  Apache Full
  Apache Secure
```

We have three profiles available for Apache:

* `Apache`: This profile opens only **port 80** (normal, unencrypted web traffic)
* `Apache Full`: This profile opens both **port 80** (normal, unencrypted web traffic) and **port 443** (TLS/SSL encrypted traffic)
* `Apache Secure`: This profile opens only **port 443** (TLS/SSL encrypted traffic)

Since the assignment also asks for an [SSL Certificate](https://www.ssl.com/) later on, we'll choose `Apache Full`:
```
sudo ufw allow 'Apache Full'
```

Let's not forget to verify the change:
```
sudo ufw status
```

## Controlling the Web Server Service
At the end of the installation and configuration process, we're ready to **start** the server, but let's check its **status** first:
```
service apache2
Usage: apache2 {start|stop|graceful-stop|restart|reload|force-reload}
```

Or using `systemctl`:
```
sudo systemctl status apache2
```

This second command should show us that the service is **loaded** (the installation does that for us). Let's start it, if that's not the case:
```
sudo systemctl start apache2
```

To test the server, we could pull up a werb browser in our host machine, and point it to the **static IP** of the **virtual machine**. That should open a site that looks more or less like the screenshot below.

![default welcome page](images/default_welcome_page.png)

That's the **default welcome page** used to test the server.

## Default Document root
The page we we're just talking about is located under the `/var/www/html/` folder of our **virtual machine**. That's known as the **default Ubuntu document root**. By default, Ubuntu does not allow access through the web browser to any file apart of those located in:

* `/var/www/html/`
* `/usr/share` (for web applications).

> If your site is using a web document root located elsewhere we may need to **whitelist** that document root directory in `/etc/apache2/apache2.conf`.

To test that out, we could replace it with our own `index.html` file, which we can copy to the server using `scp`:
```
scp index.html rick_morty.jpg roger@192.168.56.2:/var/www/html/ -p 69
```

We may find **permissions** issue when trying to copy the files to `/var/www/`; that can be solved setting our user as owner of the folder and its contents:
```
ssh roger@192.168.56.2 -p 69
sudo chown -R $(whoami) /var/www`
mkdir /var/wwwmorty
```

While we were at it, we also created a folder for our site, stay tuned!

## Virtual Hosts File
Apache can have **multiple sites** running on the same server by editing its **Virtual Hosts file**. We can make our own **virtual hosts** under `/var/www`. 

> As we mentioned before, `/var/www/html/` is the **default document root**. Like all sites in Apache, this site (the welcome page) is configured by a **VirtualHost file**. 

We can modify how handles incoming requests for a given site, by editing its **virtual hosts file**. There are two important folders in this regard:

* `/etc/apache2/sites-available/`, where we add our **configuration files** for each site.
* `/etc/apache2/sites-enabled/`, where we create **symbolic links** to the files in the folder mentioned above. Only the symlinks in this folder will be served by Apache.

Let's create a copy of the **virtual hosts file** of the welcome page, so that we can use as a base to configure our site. We'll use the occasion to show how to download files from the **server** to our **localhost** using `scp`:
```
scp -P 69 roger@192.168.56.2:/etc/apache2/sites-available/000-default.conf ./
```

> Syntax: scp <remote_user@remote_server:/path/to/file> <destination_in_localhost>

Once we have modified the **default virtual hosts file** to our heart's content, we can save it with another file, and upload it to the server:
```
scp -P 69 evil.conf roger@192.168.56.2:/etc/apache2/sites-available/
```

Once the configuration is up, we must **enable** it with:
```
cd /var/www/sites-available/
sudo a2ensite evil.conf
```

That must create a link in `/var/www/sites-enabled/`. Then we have to **reload** the server:
```
service apache2 reload
```

> I had some trouble setting up a **ServerName** for the site; after editing the `/etc/hosts` on the **host** to bypass the DNS (`192.168.56.2 evil.morty`), the browser still couldn't open the site.

By the way, this is what the site looked like:

![evil.morty](images/evil.morty.png)

---
<!-- navigation links -->
[:arrow_backward:][back] ║ [:house:][home] ║ [:arrow_forward:][next]

[home]: ../README.md
[back]: ./README/monitor_crontab.md
[next]: ./README/stop_needless_services.md