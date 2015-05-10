#Install a virtual machine with Ubuntu 14.04 on Windows 8 with virtualbox and vagrant.

We will have a **Ubuntu Trusty 14.04 LTS x64** with a hostname **project-name** running on local machine that has 4 cpu and share with it a 8 G ram.

**Nginx 1.9**

**PHP 5.6.8**

**MySQL Percona 5.6.24**

**composer 1.0**


Opened ports 22, 80, 8181, 8282, 8383, 8484, 8585

Vagrant will share /var/www folder with Windows shared/www



#Install VirtualBox

Open https://www.virtualbox.org/wiki/Downloads download and install VirtualBox for Windows

#Install Vagrant

Open https://www.vagrantup.com/downloads.html download and install Vagrant for Windows

##Install Vagrant vbguest.
*Is a Vagrant plugin which automatically installs the host's VirtualBox Guest Additions on the guest system.
https://github.com/dotless-de/vagrant-vbguest*

Open command with admin rights and run

`vagrant plugin install vagrant-vbguest`


#Virtual machine for Web Development using PuPHPet

Open https://puphpet.com/ and generate your server files
Or clone this repository

**Identify a partition on your PC and create a folder servers/ and another one named as you want**

F:\servers\project-name

Extract here all files from PuPHPet downloaded archive or this repository

Create a folder **shared** with **www** and **mysql** folders

You should have this structure:

```
puphpet/
shared/
.gitattributes
Vagrantfile
```

Edit puphpet/config.yaml change what you want and be sure you have `public_network: 192.168.1.110` before `private_network`

public network ip is your Windows Network IP and should be set in order to get out on the internet with your sites.

You should set a static ip on your network card.

##Make sure you changed the `memory:` and `cpus:` from config depends on your machine

After all settings are done, we could start to compile our server.


#Install cmder a Console Emulator for Windows

Open http://gooseberrycreative.com/cmder/ download full version and extract where you want.
Open Cmder.exe

#Run Vagrant installation

On Cmder.exe open path F:\servers\project-name then run

`vagrant up`

This command will download and install dependencies and will take a while, so take a coffee!
At mine, it`s take 10 min.

When compiling is done, you should see a `Happy programming!` message.

**Then login into machine with**

`vagrant ssh`

**Update and Upgrade packages with**

```
sudo apt-get update
sudo apt-get upgrade
```

#Install last Nginx (at this moment version 1.9)

**get and add nginx key**

```
sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo rm nginx_signing.key
```

**add to source list**

`sudo nano /etc/apt/sources.list`

then at the end add

```
deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx
```

save and run update and install

```
sudo apt-get update
sudo apt-get install nginx
```

Open `http://192.168.56.101/` and see nginx welcome page!


#Install last MySQL Percona Server (version 5.6.24)

get percona key

`sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A`

**add to source list**

`sudo nano /etc/apt/sources.list`

then at the end add

```
deb http://repo.percona.com/apt trusty main
deb-src http://repo.percona.com/apt trusty main
```

then create a preference

`sudo nano /etc/apt/preferences.d/00percona.pref`

with

```
Package: *
Pin: release o=Percona Development Team
Pin-Priority: 1001
```

update and install percona (set a password for a root user)

```
sudo apt-get update
sudo apt-get install percona-server-server-5.6
```

secure mysql installation

`sudo /usr/bin/mysql_secure_installation`


#Other

to stop vagrant do:

`logout` to exit ssh then

`vagrant halt` to shutdown virtual machine

##To start server again just run `vagrant up` and enter in ssh with `vagrant ssh`


To remove virtual machine you could do `vagrant destroy`


You could install how many Virtual Machines you want with different configurations
To custom your one, just drag puphpet/config.yaml file to https://puphpet.com/ site to preload my config.

