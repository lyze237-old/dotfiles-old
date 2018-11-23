#/usr/bin/env bash

# ubuntu 18.10 gnome edition


sudo apt install neovim evolution git fish scdaemon curl inkscape vlc gimp build-essential jq

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
echo telegram
echo powershell

# installs dotnet-script
curl -s https://raw.githubusercontent.com/filipw/dotnet-script/master/install/install.sh | sudo bash

# install discord
cd /tmp
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
sudo dpkg -i discord.deb
sudo apt -f install
cd ~

# install telegram
cd ~/.local/share/
mkdir lyze_telegram
cd lyze_telegram
wget "https://telegram.org/dl/desktop/linux" -O "telegram.tar.xz"
tar xf telegram.tar.xz
rm telegram.tar.xz
mv Telegram Telegram_
mv Telegram_/* .
rm -r Telegram_
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
