#!/bin/bash

echo "Installing xcode cli tools"
/usr/bin/xcode-select --install<Paste>

echo tweaking settings
defaults write com.apple.dock workspaces-auto-swoosh -bool NO

echo Download and install iterm2 from https://iterm2.com/downloads.html

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install urlview
brew install w3m
brew install neomutt
brew install terminal-notifier
brew install git
brew install youtube-dl
brew install streamlink
brew install coreutils

brew cask install discord
brew cask install spotify
brew cask install firefox
brew cask install vlc
brew cask install mpv
