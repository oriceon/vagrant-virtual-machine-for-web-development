#Install a virtual machine with Ubuntu 14.04 on Windows 8 with virtualbox and vagrant.

We will have a **Ubuntu Trusty 14.04 LTS x64** with a hostname **project-name** running on local machine that has 4 cpu and share with it a 8 G ram.

**Nginx 1.9**

**PHP 5.6.8**

**MySQL Percona 5.6.24**

**composer 1.0**


Opened ports 22, 80, 8181, 8282, 8383, 8484, 8585

Vagrant will share /var/www folder with Windows shared/www


#Compile server

`vagrant up`

- automaticaly download and install and update Ubuntu box and dependencies.
- create default vhost http://demo.dev and install phpmyadmin on http://pma.dev
- set mysql password: server!@#$
- add Laravel Homestead serve command with which you can quick add vhosts like:
 
  `serve domain.dev domainFolderName`

  will add and enable vhost in /etc/nginx/sites-available and /etc/nginx/sites-enabled with document root /vagrant/shared/www/**domainFolderName**


#Enter in ssh

`vagrant ssh`

