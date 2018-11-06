#!/usr/bin/env pwsh

foreach ($extension in Get-Content ./dotfiles/CrossPlatform/Code/User/extensions.txt) {
    code --install-extension $extension
}