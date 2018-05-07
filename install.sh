#!/bin/bash

# add windows to grub list
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg

# fix networking for install script
sudo dhcpcd eno1 

# install proper pacman/aur installer
sudo pacman -S pacaur

# install bspwm
pacaur -S bspwm xorg sxhkd termite fish
chsh -s `which fish`
sudo chsh -s `which fish`

# properly fix networking
pacaur -S NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# fix discord dependency keys
gpg --recv-keys 0FC3042E345AD05D 
sudo gpg --recv-keys 0FC3042E345AD05D 

# install console programs
pacaur -S git scrot vim xdg-utils maim mopidy ncmpcpp mopidy-spotify htop pulsemixer xclip mpc imagemagick w3m numlockx i3lock compton unzip feh streamlink mpv xorg-xprop xorg-xsetroot xdotool dunst dunstify python-yaml python-docopt python-jinja rtv dotnet-sdk-2.0 jq oomox-git numix-circle-icon-theme-git breeze-obsidian-cursor-theme mono steam-native-runtime v4l2loopback-dkms

# install gui programs
pacaur -S firefox steam rofi arandr thunar redshift-gtk-git thunderbird discord-ptb corebird obs-studio lxappearance pavucontrol peek nextcloud-client

# install telegram
sudo mkdir /opt/lyze
sudo chown lyze /opt/lyze
cd /opt/lyze

wget "https://telegram.org/dl/desktop/linux" -O "telegram.tar.xz"
tar xvf telegram.tar.xz
rm telegram.tar.xz

# install jetbrains rider
wget $(curl -s "https://data.services.jetbrains.com//products/releases?code=RD&latest=true&type=release" | jq -r ".RD | .[] | .downloads | .linux | .link") -O "rider.tar.gz"
tar xvfz rider.tar.gz
rm rider.tar.gz

# install emojis
pacaur -S noto-fonts noto-fonts-emoji-blob

# copy ssh keys
mkdir ~/.ssh
cp /cloud/Documents/Server/*rsa* ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 664 ~/.ssh/known_hosts 
