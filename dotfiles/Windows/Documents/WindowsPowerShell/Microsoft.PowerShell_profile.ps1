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
    else 
    {
        Write-Host "O" -NoNewline -ForegroundColor Yellow;
        Write-Host "v" -NoNewline -ForegroundColor Gray;
        Write-Host "O" -NoNewline -ForegroundColor Yellow;
    }

    Write-Host "/" -NoNewline -ForegroundColor Cyan;
    Write-Host "`"" -NoNewline -ForegroundColor Red;
    Write-Host "/" -NoNewline -ForegroundColor Cyan;

    # restore exit code
    $global:LASTEXITCODE = $properExitCode;

    return " ";
}

function Edit-PowershellProfile 
{
    Start-Process $Profile;
}

function Test-Administrator 
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
}

function Write-Copyright
{
    param($target = (Get-Location).Path)

    # Header template
    $header = "//-----------------------------------------------------------------------
// <copyright>
// `"THE BEER-WARE LICENSE`" (Revision 42):
// <lyze@owl.sh> wrote this file. As long as you retain this notice you
// can do whatever you want with this stuff. If we meet some day, and you think
// this stuff is worth it, you can buy me a beer in return Michael Weinberger
// </copyright>
//-----------------------------------------------------------------------`r`n"

    function Write-Header ($file)
    {
        # Get the file content as as Array object that contains the file lines
        $content = Get-Content $file
        
        # Getting the content as a String
        $contentAsString =  $content | Out-String
        
        <# If content starts with // then the file has a copyright notice already
        Let's Skip the first 14 lines of the copyright notice template... #>
        if($contentAsString.StartsWith("//"))
        {
        $content = $content | Select-Object -skip 14
        }

        # Splitting the file path and getting the leaf/last part, that is, the file name
        $filename = Split-Path -Leaf $file

        # $fileheader is assigned the value of $header with dynamic values passed as parameters after -f
        $fileheader = $header

        # Writing the header to the file
        Set-Content $file $fileheader -encoding UTF8

        # Append the content to the file
        Add-Content $file $content
    }

    #Filter files getting only .cs ones and exclude specific file extensions
    Get-ChildItem $target -Filter *.cs -Exclude *.Designer.cs,T4MVC.cs,*.generated.cs,*.ModelUnbinder.cs -Recurse | % `
    {
        <# For each file on the $target directory that matches the filter,
        let's call the Write-Header function defined above passing the file as parameter #>
        Write-Header $_.PSPath.Split(":", 3)[2]
    }
}