#!/usr/bin/env bash

# to run this program:
# 1. install git
# 2. mkdir ~/.dotfiles
# 3. cd ~/.dotfiles
# 4. git clone https://gitlab.com/lyze237/dotfiles-public
# 5. cd dotfiles-public
# 6. ./antergos.install.sh

# enable networking
sudo dhcpcd

# update
sudo pacman -Syuu

# fix windows
sudo os-prober
sudo grub-mkconfig-o /boot/grub/grub.cfg

# install yay
sudo pacman -S yaourt
yaourt -S yay

# install xorg
sudo pacman -S xorg

# install herbstluftwm 
sudo pacman -S herbstluftwm lemonbar-xft-git

# install fish
sudo pacman -S fish
chsh -s `which fish`
sudo chsh -s `which fish`

# install terminal
yay -S kitty

# install base programs
sudo pacman -S git xdg-utils xclip mpc imagemagick numlockx compton unzip xdotool python-yaml python-docopt python-jinja jq offlineimap msmtp ttf-dejavu wmctrl parcellite maim
yay -S dotnet-sdk numix-circle-icon-theme-git breeze-obsidian-cursor-theme v4l2loopback-dkms-git neovim nougat

# install tui programs
sudo pacman -S ncmpcpp mopidy w3m htop pass pass-otp neomutt
yay -S mopidy-spotify pulsemixer neovim

# install gui programs
sudo pacman -S i3lock feh dunst firefox steam rofi arandr thunar obs-studio lxappearance pavucontrol 
yay -S redshift-gtk-git discord-ptb nextcloud-client mstdn

# create custom install dir
sudo mkdir /opt/lyze
cd /opt/lyze
sudo chown lyze /opt/lyze

# manual download of programs
wget "https://telegram.org/dl/desktop/linux" -O "telegram.tar.xz"
tar xf telegram.tar.xz

# cleanup archives
rm *.tar.*

# copy ssh keys
mkdir ~/.ssh
cp /cloud/Documents/Server/gitlab_rsa* ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

# fish
chsh -s `which fish`
sudo chsh -s `which fish`

# dotfiles
cd ~/.dotfiles/dotfiles-public
./dotdrop install --profile=ovo
sudo ./dotdrop install --profile=sudo

# fix mouse cursor
cd /usr/share/icons/Breeze_Obsidian/cursors/
sudo ln -s left_ptr arrow

# pass instructions
echo gpg --import <private key>
echo gpg --import <public key>
echo gpg --edit-key <name>
echo pass init <name>
echo pass git init
echo pass git remote add origin <url>
echo pass git fetch origin
echo pass git reset --hard origin/master

echo cp ~/.dotfiles/dotfiles-public/secrets.env.template  ~/.dotfiles/dotfiles-public/secrets.env
echo and then rerun dotdrop with fish and the "dotdrop" function