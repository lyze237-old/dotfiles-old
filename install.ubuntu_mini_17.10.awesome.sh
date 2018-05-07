#!/bin/sh

# run script with: wget -O - https://gitlab.com/lyze237/dotfiles-public/raw/master/install.ubuntu_mini_17.10.awesome.sh | bash

echo Installing curl n co
sudo apt install -y curl git jq

#############################################
# Repos
#############################################

# obs
sudo add-apt-repository -y ppa:obsproject/obs-studio

# Fish
echo Adding fish repo
sudo apt-add-repository -y ppa:fish-shell/release-2

# mopidy
echo Adding mopidy repo
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list

# numix circle
echo Adding numix circle repo
sudo add-apt-repository -y ppa:numix/ppa

# dotnet core 2
echo Adding dotnet core repo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-artful-prod artful main" > /etc/apt/sources.list.d/dotnetdev.list'

# kde connect
echo Adding kde connect repo
sudo add-apt-repository -y ppa:webupd8team/indicator-kdeconnect

# nextcloud-client
echo Adding nextcloud client repo
sudo add-apt-repository -y ppa:nextcloud-devs/client

#############################################
# Installation
#############################################

echo Updating apt cache
sudo apt update

echo Installing everything possible
sudo apt install -f -y xorg corebird fish python3-setuptools arc-theme numix-icon-theme-circle mopidy ncmpcpp rofi g++ build-essential qt5-qmake qt5-default dotnet-sdk-2.0.* mono-devel xdotool htop indicator-kdeconnect nextcloud-client compton mopidy-spotify steam mpc mpdris2 redshift redshift-gtk ffmpeg obs-studio mpv vlc python3-socks gimp wmctrl feh awesome i3lock arandr lxappearance ranger w3m xfce4-terminal thunar unzip pulseaudio pavucontrol thunar scrot imagemagick libnotify-bin ubuntu-restricted-extras urlview xclip weechat neovim numlockx thunderbird breeze-cursor-theme

#############################################
# Manual Website Installation
#############################################

echo Manually downloading deb files from websites
cd ~/Downloads
echo Downloading vivaldi
wget $(curl -s https://vivaldi.com/download/ |grep amd64.deb|awk -F '"' '{print $4}') -O "vivaldi.deb"
echo Downloading discord
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O "discord.deb"
echo Downloading telegram
wget "https://telegram.org/dl/desktop/linux" -O "telegram.tar.xz"
echo Downloading rider
wget $(curl -s "https://data.services.jetbrains.com//products/releases?code=RD&latest=true&type=release" | jq -r ".RD | .[] | .downloads | .linux | .link") -O "rider.tar.gz"
echo Downloading teamviewer
wget "https://download.teamviewer.com/download/teamviewer_i386.deb" -O "teamviewer.deb"

echo Installing manually downloaded deb files
sudo dpkg -i *.deb
echo Fixing dependencies
sudo apt -f install -y
echo Deleting deb files
rm *.deb

echo Installing manually downloaded tar files
echo Setting opt permissions
sudo chown -R lyze:root /opt
echo Copying tar files to /opt
cp *.tar.* /opt/
cd /opt
echo Extracting tar files
for f in *.tar.* ; do tar xf $f ; done
echo Deleting tar files
rm *.tar.*

############################################
# Setup
############################################

# copying gitlab ssh key
mkdir ~/.ssh
cp /cloud/Documents/Server/gitlab_rsa ~/.ssh/id_rsa
cp /cloud/Documents/Server/gitlab_rsa.pub ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

# fish
chsh -s `which fish`
sudo chsh -s `which fish`

# dotfiles
mkdir ~/.dotfiles
cd ~/.dotfiles

# install pip via pythons pm
sudo easy_install3 pip

# clone public dotfiles
git clone --recursive git@gitlab.com:lyze237/dotfiles-public.git
chmod u+x dotfiles-public/*.sh

# clone private dotfiles (requires gitlab key)
git clone --recursive git@gitlab.com:lyze237/dotfiles-private.git
chmod u+x dotfiles-private/*.sh

# installs dotdrop dependencies
cd dotfiles-public
sudo pip install -r dotdrop/requirements.txt

# installs dotfiles
./dotdrop.sh install --force --profile=ovo
sudo ./dotdrop.sh install --force --profile=sudo
cd ../dotfiles-private
./dotdrop.sh install --force --profile=ovo

# move ssh key
mv ~/.ssh/id_rsa ~/.ssh/id_gitlab
mv ~/.ssh/id_rsa.pub ~/.ssh/id_gitlab.pub

# updates Xresource
xrdb ~/.Xresources

# install flameshot
cd /opt
git clone https://github.com/lupoDharkael/flameshot.git
cd flameshot
qmake
make
sudo make install
mkdir ~/Pictures/screenshots

# installs pulsemixer
sudo pip3 install git+https://github.com/GeorgeFilipkin/pulsemixer.git

# install streamlink
sudo pip install -U streamlink

# set fish as shell
chsh -s `which fish`
sudo chsh -s `which fish`

# rtv
sudo pip install rtv

# powerline font
cd /opt
git clone https://github.com/powerline/fonts.git
cd /opt/fonts
chmod u+x install.sh
./install.sh
cd ..
rm -rf fonts

# powerline shell
sudo pip install powerline-shell