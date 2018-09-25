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
    $year = Get-Date -Format yyyy;
    $header = "//-----------------------------------------------------------------------
// <copyright>
// MIT License
//
// Copyright (c) " + $year + " Michael Weinberger lyze@owl.sh
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the `"Software`"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED `"AS IS`", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// </copyright>
//-----------------------------------------------------------------------`r`n"

    function Write-Header ($file)
    {
        # Get the file content as as Array object that contains the file lines
        $content = Get-Content $file
        
        # Getting the content as a String
        $contentAsString =  $content | Out-String
        
        <# If content starts with // then the file has a copyright notice already
        Let's Skip the first 26 lines of the copyright notice template... #>
        if($contentAsString.StartsWith("//"))
        {
            $oldCopyrightLength = ($content | Where { $_.StartsWith("//") }).Length + 1
            $content = $content | Select-Object -skip $oldCopyrightLength
        }

        # Splitting the file path and getting the leaf/last part, that is, the file name
        $filename = Split-Path -Leaf $file

        # $fileheader is assigned the value of $header with dynamic values passed as parameters after -f
        $fileheader = $header

        # Writing the header to the file
        Set-Content $file $fileheader -encoding Oem

        # Append the content to the file
        Add-Content $file $content
    }

    #Filter files getting only .cs ones and exclude specific file extensions
    Get-ChildItem $target -Include @("*.cs", "*.java") -Exclude *.Designer.cs,T4MVC.cs,*.generated.cs,*.ModelUnbinder.cs -Recurse | % `
    {
        <# For each file on the $target directory that matches the filter,
        let's call the Write-Header function defined above passing the file as parameter #>
        Write-Header $_.PSPath.Split(":", 3)[2]
    }
}