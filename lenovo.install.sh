#/usr/bin/env bash

# ubuntu 18.10 gnome edition


sudo snap install spotify telegram-desktop bitwarden bw 
sudo snap install --classic powershell-preview
sudo snap alias powershell-preview pwsh

sudo apt install neovim gnome-tweak-tool evolution chrome-gnome-shell git fish scdaemon curl inkscape vlc gimp

sudo apt remove thunderbird

# gruvbox gnome terminals
cd /tmp
git clone https://github.com/metalelf0/gnome-terminal-colors.git
cd gnome-terminal-colors
./install.sh -s gruvbox-dark

# fish shell
chsh -s `which fish`
sudo chsh -s `which fish`

# dotnet sdk
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt install apt-transport-https
sudo apt update
sudo apt install dotnet-sdk-2.1

# libinput-gestures
cd /tmp
sudo gpasswd -a $USER input
sudo apt-get install xdotool wmctrl libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install
libinput-gestures-setup autostart
libinput-gestures-setup start &

echo install the following programs manually: 
echo vs code
echo jetbrains toolbox
echo discord

# installs dotnet-script
curl -s https://raw.githubusercontent.com/filipw/dotnet-script/master/install/install.sh | bash

# install vs code extensions
./dotfiles/Commands/InstallVsCodeExtensions.ps1

echo install vs code and jetbrains toolbox manually
