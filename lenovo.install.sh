#/usr/bin/env bash

# ubuntu 18.10 gnome edition


sudo snap install vlc spotify discord gimp inkscape telegram-desktop bitwarden bw 
sudo snap install --classic powershell-preview
sudo snap alias powershell-preview pwsh

sudo apt install neovim gnome-tweak-tool evolution chrome-gnome-shell git fish scdaemon curl

sudo apt remove thunderbird

# installs gnome terminal colors
cd /tmp
git clone https://github.com/metalelf0/gnome-terminal-colors.git
cd gnome-terminal-colors
./install.sh -s gruvbox-dark
cd ~

# sets fish shell
chsh -s `which fish`
sudo chsh -s `which fish`

# installs dotnet sdk
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt install apt-transport-https
sudo apt update
sudo apt install dotnet-sdk-2.1

# installs dotnet-script
curl -s https://raw.githubusercontent.com/filipw/dotnet-script/master/install/install.sh | bash

# install vs code extensions
./dotfiles/Commands/InstallVsCodeExtensions.ps1

echo install vs code and jetbrains toolbox manually
