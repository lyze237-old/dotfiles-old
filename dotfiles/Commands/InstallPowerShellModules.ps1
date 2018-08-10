foreach ($module in Get-Content ./dotfiles/Windows/Documents/WindowsPowerShell/PowerShellModules.txt) {
    Install-Module $module -Scope CurrentUser
}