#/usr/bin/env bash

# xubuntu 18.10

sudo snap install spotify
sudo apt install neovim evolution git fish scdaemon curl inkscape vlc gimp build-essential jq telegram-desktop hplip-gui redshift-gtk firefox evolution-rss steam compton

# fix lock screen
sudo apt remove light-locker
sudo apt install xscreensaver

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

# installs dotnet-script
curl -s https://raw.githubusercontent.com/filipw/dotnet-script/master/install/install.sh | sudo bash

# install discord
cd /tmp
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
sudo dpkg -i discord.deb
sudo apt -f install
cd ~

# install vs code
cd /tmp
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O code.deb
sudo dpkg -i code.deb
sudo apt -f install
cd ~

# install pwsh
cd /tmp
wget $(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | jq .assets[].browser_download_url | grep -E "powershell.*\.ubuntu\.18\.04_amd64\.deb"| sed -e 's/^"//' -e 's/"$//')
sudo dpkg -i powershell*.deb
sudo apt -f install
cd ~

# install gopass
cd /tmp
wget $(curl -s https://api.github.com/repos/gopasspw/gopass/releases/latest | jq .assets[].browser_download_url | grep -E "gopass.*amd64\.deb" | sed -e 's/^"//' -e 's/"$//')
sudo dpkg -i gopass*.deb
sudo apt -f install
cd ~

# numix circle
echo Adding numix circle repo
sudo add-apt-repository -y ppa:numix/ppa
sudo apt install numix-icon-theme-circle

# vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# toolbox
cd ~/.local/share/
mkdir lyze_toolbox
cd lyze_toolbox
wget $(curl -s "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq -r ".TBA | .[] | .downloads | .linux | .link") -O "toolbox.tar.gz"
tar xvf toolbox.tar.gz
rm toolbox.tar.gz
tbx=$(ls)
mv $tbx/* .
rm -r $tbx
./jetbrains-toolbox

# ssh stuff
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

# change git location
cd ~/.dotfiles
git remote rm origin
git remote add origin git@gitlab.com:lyze237/dotfiles-public

# tlp
sudo apt install tlp powertop
sudo tlp start
sudo powertop --calibrate

# steam mesa drivers
sudo add-apt-repository ppa:paulo-miguel-dias/pkppa
sudo apt update
sudo apt install  mesa-vulkan-drivers mesa-vulkan-drivers:i386

# emoji
sudo apt-add-repository ppa:eosrei/fonts
sudo apt-get update
sudo apt-get install fonts-twemoji-svginot
