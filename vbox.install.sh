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

# ssh stuff
sudo bash -c "echo X11Forwarding yes >> /etc/ssh/sshd_config"
sudo systemctl enable sshd
sudo systemctl start sshd

# update sudo pacman -Syuu

# install yay
sudo pacman -S yaourt
yaourt -S yay
yay -R yaourt

# install fish
sudo pacman -S fish
chsh -s `which fish`
sudo chsh -s `which fish`

# install terminal
yay -S kitty

# install base programs
sudo pacman -S git xdg-utils xclip imagemagick unzip xdotool python-yaml python-docopt python-jinja jq ttf-dejavu wmctrl parcellite thunar-volman tumbler thunar-media-tags-plugin thunar-archive-plugin gvfs noto-fonts-cjk noto-fonts-extra imagemagick maim python-xdg xorg xorg-xinit
yay -S dotnet-sdk numix-circle-icon-theme-git breeze-obsidian-cursor-theme ttf-twemoji-color urlview

# install tui programs
sudo pacman -S w3m htop pass pass-otp neomutt youtube-dl
yay -S pulsemixer neovim 

# install gui programs
sudo pacman -S thunar lxappearance pavucontrol ristretto vinagre 

# dotfiles
cd ~/.dotfiles/dotfiles-public
./dotdrop install --profile=vbox
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
