#
# Ubuntu 18.04 (Bionic Beaver)
# Basic packages
# Installs multiple packages on Ubuntu 18.04 (Bionic Beaver)
#
# Author: Pavel Petrov <papahelmsman@gmail.com>
#

.PHONY: all preparations libs update upgrade fonts virtualbox vagrant graphics darktable networking google_chrome firefox_next slack archives media pandoc python_packs ruby_packs system harddisk docker ansible filesystem nodejs nginx mysql mysql-workbench postgres mongodb couchdb php memcached tools encfs_manager nautilus_extensions httpie esl_repo erlang elixir teamviwer xmind presentation idea_intellij

all:
	@echo "Installation of all targets"
	make preparations libs
	make update
	make upgrade
	make fonts
	make media pandoc
	make python_packs ruby_packs
	make graphics darktable
	make networking google_chrome httpie
	make presentation
	make archives system harddisk filesystem tools encfs_manager nautilus_extensions
	make docker ansible virtualbox vagrant
	make nodejs
	make nginx
	make mysql mysql-workbench postgres couchdb
	make php
	make openoffice owncloud
	make erlang elixir
	make teamviwer
	make xmind

preparations:
	make update
	sudo apt -y install software-properties-common build-essential checkinstall wget curl git
	make git
	sudo apt -y install libssl-dev apt-transport-https ca-certificates

libs:
	sudo apt -y install libavahi-compat-libdnssd-dev

update:
	sudo apt update

upgrade:
	sudo apt -y upgrade

git:
	sudo add-apt-repository -y ppa:git-core/ppa
	make update
	sudo apt -y install git

fonts:
	mkdir -p ~/.fonts/
	rm -f ~/.fonts/FiraCode-*
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Bold.otf -O ~/.fonts/FiraCode-Bold.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Light.otf -O ~/.fonts/FiraCode-Light.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Medium.otf -O ~/.fonts/FiraCode-Medium.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -O ~/.fonts/FiraCode-Regular.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Retina.otf -O ~/.fonts/FiraCode-Retina.otf
	fc-cache -v

media:
	sudo add-apt-repository -y ppa:thomas-schiex/blender # Get bleeding edge blender releases
	sudo apt -y install mplayer mplayer-gui vlc ubuntu-restricted-extras libavcodec-extra libdvdread4 blender-edge totem okular okular-extra-backends audacity brasero handbrake youtube-dl kodi
	sudo apt -y install libxvidcore4 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-alsa gstreamer1.0-fluendo-mp3 gstreamer1.0-libav
	# DVD Playback
	sudo DEBIAN_FRONTEND=noninteractive apt -y install libdvd-pkg
	sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg
	# !!!!! Fix mplayer bug - "Error in skin config file on line 6: PNG read error in /usr/share/mplayer/skins/default/main"
	cd /usr/share/mplayer/skins/default; for FILE in *.png ; do sudo convert $$FILE -define png:format=png24 $$FILE ; done
	sudo adduser $$USER video # Fix CUDA support

pandoc:
	sudo apt -y install pandoc pandoc-citeproc texlive texlive-latex-extra texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra texlive-lang-german texlive-xetex preview-latex-style dvipng nbibtex

python_packs:
	make preparations
	sudo -H apt -y install python-pip
	sudo -H pip install --upgrade pip

ruby_packs:
	sudo apt -y install ruby-dev ruby-bundler
	sudo gem install bundler

graphics:
	# !!!!!!
	sudo apt -y install gimp gimp-data gimp-plugin-registry gimp-data-extras geeqie graphviz jpegoptim

darktable:
	make update
	sudo apt -y install darktable

networking:
	sudo apt -y install pidgin filezilla vinagre chromium-browser pepperflashplugin-nonfree bmon hexchat samba ethtool sshuttle

google_chrome:
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	make update
	sudo apt -y install google-chrome-stable libappindicator1

## firefox_next:
## 	sudo add-apt-repository -y ppa:mozillateam/firefox-next
## 	make update
## 	sudo apt -y install firefox firefox-locale-en

slack:
	sudo apt -y install gvfs-bin libgnome-keyring0 gir1.2-gnomekeyring-1.0
	rm -f slack-desktop-3.0.5-amd64.deb
	wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.0.5-amd64.deb
	sudo dpkg -i slack-desktop-3.0.5-amd64.deb
	rm -f slack-desktop-3.0.5-amd64.deb

archives:
	# Tested
	sudo apt install unace p7zip p7zip-full p7zip-rar sharutils rar mpack arj

java:
	# Not Need - Java 8 Installed by Default
	make update
	sudo apt -y install openjdk-11-jdk

system:
	# Tested
	make update
	sudo apt -y install subversion rabbitvcs-nautilus network-manager-openvpn gparted cloc mssh inotify-tools openssh-server ntp
	sudo apt install traceroute whois sqlite3 etckeeper stress

system:
	# Tested
	#--- Fixing psyhon keyring problems
	sudo apt -y install python-keyring
	#--- Raise inotify limit
	echo "fs.inotify.max_user_watches = 524288" | sudo tee /etc/sysctl.d/60-inotify.conf
	sudo service procps restart

harddisk:
	# Tested
	sudo DEBIAN_FRONTEND=noninteractive apt -y install smartmontools nvme-cli smart-notifier #gsmartcontrol

docker:
	#
	make update
	sudo apt -y install docker.io
	# sudo systemctl start docker
	# sudo systemctl enable docker
	# docker --version

ansible:
	# Not Tested
	sudo add-apt-repository -y ppa:ansible/ansible
	make update
	sudo apt -y install ansible
	# ansible --version

virtualbox:
	# Tested
	make update
	make upgrade
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib"
	make update
	sudo apt -y install virtualbox-6.0
	# Install Virtualbox Extension Pack
	# https://www.virtualbox.org/wiki/Downloads

vagrant:
	make update
	sudo apt -y install vagrant

filesystem:
	sudo apt -y install exfat-fuse exfat-utils e2fsprogs mtools dosfstools hfsutils hfsprogs jfsutils util-linux lvm2 nilfs-tools ntfs-3g reiser4progs reiserfsprogs xfsprogs attr quota f2fs-tools sshfs go-mtpfs jmtpfs

pdf:
	make update
	sudo apt -y install pdfshuffler

e_book:
	make update
	sudo apt -y install calibre

libreoffice:
	sudo add-apt-repository -y ppa:libreoffice/ppa
	make update
	sudo apt -y install libreoffice

editors:
	make update
	sudo apt -y install vim
	# sudo apt -y install retext

notepadqq:
	# Tested
	sudo add-apt-repository -y ppa:notepadqq-team/notepadqq
	make update
	sudo apt -y install notepadqq

sublime_text:
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update
	sudo apt -y install sublime-text

nodejs:
	# Tested
	# curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
	# sudo bash nodesource_setup.sh
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt -y install nodejs
	# nodejs -v
	# npm -v
	# sudo apt -y install build-essential
	# Removing Node.js
	# sudo apt purge nodejs
	# sudo apt autoremove

nginx:
	deb http://nginx.org/packages/mainline/ubuntu/ bionic nginx
	sudo wget http://nginx.org/keys/nginx_signing.key
	sudo apt-key add nginx_signing.key
	make update
	sudo apt -y install nginx

mysql: # !!!!! START HERE
	wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
	sudo dpkg -i mysql-apt-config_0.8.10-1_all.deb
	sudo apt update
	sudo apt -y install mysql-server
	# sudo mysql_secure_installation
	#

mysql-workbench:
	# sudo apt -y install mysql-workbench-community libmysqlclient18

postgres:
	sudo apt -y install postgresql postgresql-contrib pgadmin3
	#sudo -i -u postgres psql
	#> \password postgres
	#> postgres
	#> postgres
	#> \q

mongodb:
	sudo apt -y install mongodb

couchdb:
	exit 1 # TODO
	#sudo apt -y install couchdb

php:
	sudo apt-get -y install php7.2-fpm php7.2-mysql php7.2-curl php7.2-cli php7.2-gd php7.2-json php7.2-intl php-pear php-imagick php7.2-imap php-memcache php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-pgsql php7.2-bz2 php7.2-tidy php7.2-xmlrpc php7.2-xsl php7.2-mbstring php-gettext php7.2-soap php7.2-xml php7.2-zip php-xdebug php-apcu php-apcu-bc memcached

tools:
	sudo apt -y install htop meld geany ghex myrepos baobab bleachbit gnome-maps
	# sudo apt install guake password-gorilla keepassx terminator
	# Fix for nautilus not starting my preferred terminal on right click.
	#sudo apt-get -y remove gnome-terminal
	#sudo ln -fs /usr/bin/terminator /usr/bin/gnome-terminal

file_managers:
	make update
	sudo apt -y install


encfs_manager:
	sudo add-apt-repository -y ppa:gencfsm/ppa
	make update
	sudo apt -y install gnome-encfs-manager

nautilus_extensions:
	make update
	sudo apt -y install nautilus-image-converter nautilus-compare nautilus-wipe
	# sudo add-apt-repository -y ppa:nilarimogard/webupd8
	# make update
	# sudo apt -y install nautilus-columns

httpie: ruby_packs
	# sudo apt -y install python-pip
	sudo pip install --upgrade httpie

# esl_repo:
#	rm -f erlang-solutions_1.0_all.deb
#	wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
#	sudo dpkg -i erlang-solutions_1.0_all.deb
#	rm -f erlang-solutions_1.0_all.deb
#	make update

# erlang:
#	#make esl_repo
#	sudo apt -y install erlang

# elixir:
#	#make esl_repo
#	sudo apt -y install elixir

#teamviwer:
#	sudo apt -y install qml-module-qtquick-dialogs qml-module-qtquick-privatewidgets
#	rm -f teamviewer_amd64.deb
#	wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
#	sudo dpkg -i teamviewer_amd64.deb
#	rm -f teamviewer_amd64.deb

#xmind:
#	[ -f xmind-7-update1-linux_amd64.deb ] || wget --user-agent="Mozilla/5.0"  http://dl2.xmind.net/xmind-downloads/xmind-7-update1-linux_amd64.deb
#	sudo apt -y install lame libwebkitgtk-1.0-0
#	sudo dpkg -i xmind-7-update1-linux_amd64.deb

presentation:
	make update
	make upgrade
	sudo apt -y install pdf-presenter-console


jetbrains:
	make update
	# Intellij IDEA - IDE for Java Virtual Machine
	sudo snap install intellij-idea-ultimate --classic
	make update
	# PhpStorm - PHP IDE
	sudo snap install phpstorm --classic
	make update
	# PyCharm - Python IDE
	# sudo snap install pycharm-community --classic
	sudo snap install pycharm-professional --classic
	# make update
	# WebStorm - JavaScript IDE
	sudo snap install webstorm --classic
	make update
	# CLion - IDE for C and C++
sudo snap install clion --classic