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

# update sudo pacman -Syuu

# fix windows
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg

# install yay
sudo pacman -S yaourt
yaourt -S yay

# install fish
sudo pacman -S fish
chsh -s `which fish`
sudo chsh -s `which fish`

# install terminal
yay -S kitty

# install base programs
sudo pacman -S git xdg-utils xclip playerctl imagemagick numlockx compton unzip xdotool python-yaml python-docopt python-jinja jq ttf-dejavu wmctrl parcellite maim networkmanager thunar-volman tumbler thunar-media-tags-plugin thunar-archive-plugin gvfs noto-fonts-cjk noto-fonts-extra imagemagick maim python-xdg xorg xorg-xinit herbstluftwm 
yay -S dotnet-sdk numix-circle-icon-theme-git breeze-obsidian-cursor-theme v4l2loopback-dkms-git ttf-twemoji-color urlview

# install tui programs
sudo pacman -S w3m htop pass pass-otp neomutt youtube-dl
yay -S pulsemixer neovim

# install gui programs
yay -S libc++ --mflags --nocheck #install discord dependency without tests since they take 20 minutes or so

sudo pacman -S i3lock feh dunst firefox rofi arandr thunar obs-studio lxappearance pavucontrol  ristretto vinagre rhythmbox
yay -S redshift-gtk-git discord-ptb nextcloud-client mstdn neovim nougat-git lemonbar-xft-git spotify

# network manager fun
systemctl enable NetworkManager
systemctl start NetworkManager

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
chmod o-rwx ~/.gnugp
chmod g-rwx ~/.gnugp

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
echo edit /etc/makepkg.conf and set MAKEFLAGS="-j9 -l8"
