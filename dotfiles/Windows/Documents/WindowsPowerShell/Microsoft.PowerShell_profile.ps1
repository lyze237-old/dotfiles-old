Import-Module PSReadLine;
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete;

Import-Module Get-ChildItemColor;

Set-Alias ls Get-ChildItemColor -option AllScope;

function Prompt
{
    # backup exit code
    $properExitCode = $LASTEXITCODE;

    $path = (Get-Location).Path;
    $path = $path.Replace($HOME, '~');
    $splittedPath = $path.Split('\');

    if ($splittedPath.length -gt 3)
    {
        for ($i = 0; $i -lt $splittedPath.length - 1; $i++)
        {
            $splittedPath[$i] = $splittedPath[$i][0];
        }

        $joinedPath = [String]::Join("\", $splittedPath);
        Write-Host $joinedPath -NoNewline;
    }
    else
    {
        Write-Host $path -NoNewline;
    }

    Write-Host " " -NoNewline;

    if (Test-Administrator) 
    {
        Write-Host "^" -NoNewline -ForegroundColor Yellow;
        Write-Host "v" -NoNewline -ForegroundColor Gray;
        Write-Host "^" -NoNewline -ForegroundColor Yellow;
    }

    Write-Host "O" -NoNewline -ForegroundColor Yellow;
    Write-Host "v" -NoNewline -ForegroundColor Gray;
    Write-Host "O" -NoNewline -ForegroundColor Yellow;

    Write-Host "/" -NoNewline -ForegroundColor Cyan;
    Write-Host "`"" -NoNewline -ForegroundColor Red;
    Write-Host "/ " -NoNewline -ForegroundColor Cyan;

    # restore exit code
    $global:LASTEXITCODE = $properExitCode;

    return " ";
}

function Edit-PowershellProfile 
{
    Start-Process $Profile;
}

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
}