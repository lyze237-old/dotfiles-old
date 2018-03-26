#!/bin/sh

# run script with: wget -O - https://gitlab.com/lyze237/dotfiles-public/raw/master/install.ubuntu.sh | bash

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

# nvim
sudo add-apt-repository ppa:neovim-ppa/stable

# Twitter Color Emoji SVGinOT Font
sudo apt-add-repository ppa:eosrei/fonts

#############################################
# Installation
#############################################

echo Updating apt cache
sudo apt update

echo Installing everything possible
sudo apt install -f -y xorg corebird fish python3-setuptools arc-theme numix-icon-theme-circle mopidy ncmpcpp rofi g++ qttools5-dev-tools build-essential qt5-qmake qt5-default dotnet-sdk-2.0.* mono-devel xdotool htop indicator-kdeconnect nextcloud-client compton mopidy-spotify steam mpc mpdris2 redshift redshift-gtk ffmpeg obs-studio mpv vlc python3-socks gimp wmctrl feh awesome i3lock arandr lxappearance ranger w3m xfce4-terminal thunar unzip pulseaudio pavucontrol thunar scrot imagemagick libnotify-bin ubuntu-restricted-extras urlview xclip weechat neovim numlockx thunderbird breeze-cursor-theme firefox python3-docopt python3-jinja2 xarchiver urlview w3m gpgsm msmtp offlineimap mutt mousepad neovim pass oathtool parcellite fonts-twemoji-svginot ristretto

#############################################
# Manual Website Installation
#############################################

echo Manually downloading deb files from websites
cd ~/Downloads
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

# clone public dotfiles
git clone --recursive git@gitlab.com:lyze237/dotfiles-public.git
chmod u+x dotfiles-public/*.sh

# clone private dotfiles (requires gitlab key)
git clone --recursive git@gitlab.com:lyze237/dotfiles-private.git
chmod u+x dotfiles-private/*.sh

# installs dotfiles
cd dotfiles-public
read -p "Please enter the correct values in ~/.dotfiles/dotfiles-public/secure.env and press a key" -n 1 -r
echo

source secure.env

./dotdrop.sh install --force --profile=ovo
sudo ./dotdrop.sh install --force --profile=sudo
cd ../dotfiles-private
./dotdrop.sh install --force --profile=ovo

# move ssh key
mv ~/.ssh/id_rsa ~/.ssh/id_gitlab
mv ~/.ssh/id_rsa.pub ~/.ssh/id_gitlab.pub

# updates Xresource
xrdb ~/.Xresources

# installs pulsemixer
sudo pip3 install git+https://github.com/GeorgeFilipkin/pulsemixer.git

# install streamlink
sudo pip install -U streamlink

# set fish as shell
chsh -s `which fish`
sudo chsh -s `which fish`

# rtv
sudo pip install rtv

# maim
cd /tmp
sudo apt install -y slop libjpeg-dev libgl1-mesa-dev cmake libglm-dev
git clone https://github.com/naelstrof/maim.git
cd maim
cmake -DCMAKE_INSTALL_PREFIX="/usr" ./
make && sudo make install

# termite install
cd /tmp
git clone --recursive https://github.com/thestinger/termite.git
git clone https://github.com/thestinger/vte-ng.git
sudo apt install -y \
    g++ \
    libgtk-3-dev \
    gtk-doc-tools \
    gnutls-bin \
    valac \
    intltool \
    libpcre2-dev \
    libglib3.0-cil-dev \
    libgnutls28-dev \
    libgirepository1.0-dev \
    libxml2-utils \
    gperf

echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd vte-ng && ./autogen.sh && make && sudo make install
cd ../termite && make && sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x; sudo ln -s \
/usr/local/share/terminfo/x/xterm-termite \
/lib/terminfo/x/xterm-termite

# pass stuff
cd /tmp
git clone https://github.com/roddhjav/pass-update/
cd pass-update
sudo make install

cd /tmp
git clone https://github.com/tadfisher/pass-otp
cd pass-otp
sudo make install

cd /tmp
git clone https://github.com/carnager/rofi-pass.git
cd rofi-pass
sudo make install
