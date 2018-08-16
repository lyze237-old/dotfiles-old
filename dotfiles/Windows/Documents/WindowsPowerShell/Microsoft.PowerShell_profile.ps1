Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Import-Module Get-ChildItemColor

Set-Alias ls Get-ChildItemColor -option AllScope

function Prompt
{
    $mywd = (Get-Location).Path
    $mywd = $mywd.Replace( $HOME, '~' )
    Write-Host "PS " -NoNewline -ForegroundColor DarkGreen
    Write-Host ("" + $mywd + ">") -NoNewline -ForegroundColor Green
    return " "
}

function Edit-PowershellProfile 
{
    Start-Process $Profile
}
