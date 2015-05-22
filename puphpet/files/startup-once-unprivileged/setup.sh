#!/usr/bin/env bash

echo "--- Updating packages list ---"

cat << EOF | sudo tee -a /etc/apt/sources.list

deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx

deb http://repo.percona.com/apt trusty main
deb-src http://repo.percona.com/apt trusty main
EOF

echo "--- Updating packages list ---"

unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
ucf --purge /boot/grub/menu.lst

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq
#sudo apt-get upgrade -y --force-yes -qq
sudo apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

sudo apt-get install -y dos2unix


echo "--- Installing Nginx ---"
sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo rm nginx_signing.key

sudo apt-get install -y --force-yes nginx

echo "--- Modify nginx vhost directory ---"

sudo rm -rf /etc/nginx/conf.d

sed -i 's/include \/etc\/nginx\/conf\.d\/\*\.conf;/include \/etc\/nginx\/sites-enabled\/\*;/' /etc/nginx/nginx.conf

sudo mkdir /etc/nginx/sites-available 2>/dev/null
sudo mkdir /etc/nginx/sites-enabled 2>/dev/null


echo "--- Create alias serve for quick adding vhosts ---"

cat << EOF | sudo tee -a ~/.bash_aliases

function serve() {
	servePath=/vagrant/puphpet/files/startup-once-unprivileged/src/serve.sh

	if [[ "\$1" && "\$2" ]]
	then
		sudo dos2unix "\$servePath"
		sudo bash "\$servePath" "\$1" "/vagrant/shared/www/\$2" 80
	else
		echo "Error: missing required parameters."
		echo "Usage: "
		echo "  serve domain path"
	fi
}
EOF

source ~/.bash_aliases


sudo mkdir /vagrant/shared/www/demo 2>/dev/null

cat << EOF | sudo tee -a /vagrant/shared/www/demo/index.html
Hello World!
EOF

echo "--- Serve demo.dev ---"
serve demo.dev demo


echo "--- Install MySQL Percona Server 5.6 ---"

DEBCONF_PREFIX="percona-server-server-5.6 percona-server-server"
PERCONA_PW="server!@#$"

#read -e -i "$PERCONA_PW" -p "Enter a mysql password: " PERCONA_PW

sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

cat << EOF | sudo tee -a /etc/apt/preferences.d/00percona.pref
Package: *
Pin: release o=Percona Development Team
Pin-Priority: 1001
EOF

sudo debconf-set-selections >> /dev/null <<DEBCONF
${DEBCONF_PREFIX}/root_password password $PERCONA_PW
${DEBCONF_PREFIX}/root_password_again password $PERCONA_PW
DEBCONF

sudo apt-get install -y --force-yes percona-server-server-5.6 percona-server-client-5.6


echo "--- Install phpMyAdmin on pma.dev ---"

pmaRoot=/vagrant/shared/www/phpMyAdmin/

sudo mkdir "$pmaRoot" 2>/dev/null


echo "--- Downloading latest phpMyAdmin ---"
sudo wget -q -O "$pmaRoot"phpmyadmin.zip http://sourceforge.net/projects/phpmyadmin/files/latest/

echo "--- Extracting phpMyAdmin ---"
sudo unzip -q -o "$pmaRoot"phpmyadmin.zip -d "$pmaRoot"

sudo mv "$pmaRoot"phpMyAdmin*/* "$pmaRoot"

sudo rm "$pmaRoot"phpmyadmin.zip
sudo rm "$pmaRoot"phpMyAdmin*/

serve pma.dev phpMyAdmin

#if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null; fi

#if [ ! -n "$(grep "^github.com " /home/vagrant/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> /home/vagrant/.ssh/known_hosts 2>/dev/null; fi

#git clone git@github.com:phpmyadmin/phpmyadmin.git /vagrant/shared/www/phpMyAdmin2