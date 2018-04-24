# My dotfiles

OS: Ubuntu Server 17.10
Shell: Fish
WM: Awesome ( Currently in migration to herbstluftwm )
Theme: Oomox-Gruvbox-Dark
Icons: Numix-Circle
Termina: Termite ( Currently in migration to kitty )
Terminal Font: Ubuntu Mono Powerline Nerdfont

# Screenshost:

## Empty
![](empty.png)

## Full
![](full.png)

# Dotdrop Setup

* I have 4 profiles:
 * ovo: My main pc.
 * wsl: Windows Subsystem for Linux. 
 * mac: My works macbook.
 * sudo: For files in /etc or other directories which can only be written to with `sudo`/as root.

## ovo
Generally contains nearly all dotfiles since it's my main pc. 
(neo)mutt uses msmtp and offlineimap to sync emails instead of it's built in functions.

## wsl
Just contains the most basic dotfiles for my linux subsystem on windows. (new)mutt with a default imap setup. git files. fish prompt and the bin directory for my scripts.

## mac
Similar to wsl, this also contains a minimal installation, though a bit more compared to wsl since it includes macos specific config files. (chunkwm, skhd, ...)

## sudo
Right now only contains one file, /etc/issues, which gets installed on my home pc. A friend of mine made a nice greeter for me and it makes me really happe whenever I see it!

## Mutt explanation
If you open my [muttrc](https://gitlab.com/lyze237/dotfiles-public/blob/master/dotfiles/config/mutt/muttrc) file, you'll notice a couple things:
* That I'm checking if the current profile is `ovo` or anything else and install the specific mailbox setup `offline` (offlineimap) or `online` (inbuilt imap functions)
* Notifications are only sent when I'm installing my dotfiles on my macbook since I have a custom script for that on my pc.

## Secrets.env
This file needs to be created before I install the dotfiles from the [secrets.env.template](https://gitlab.com/lyze237/dotfiles-public/blob/master/secrets.env.template) file.
In there I can specify all environment variables to use, e.g. email username/password, spotify app id...
Since I'm using `pass` for my passwords I can simply run it and get the first line for my passwords.
[Here's an example](https://gitlab.com/lyze237/dotfiles-public/blob/master/dotfiles/msmtprc) on how I replace a config file with the `secrets.env` file.
