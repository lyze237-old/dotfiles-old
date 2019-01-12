function Expand-Tar($tarFile, $dest) {

    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
    }

    Expand-7Zip $tarFile $dest
}

$filename = "HootManager.tar"
$directory = "HootManager"
$tempDirectory = "HootManager_temp"

if (-not (Test-Path $directory)) {
    Write-Host "Downloading latest version"
    Write-Host "Checking job page"
    $website = Invoke-WebRequest "https://gitlab.com/lyze237/dotnet-hootmanager/-/jobs/"
    $elements = $website.AllElements | Where Class -eq "build-link" | Select -ExpandProperty innerText
    Write-Host "Iterating through jobs"
    foreach ($element in $elements) {
        $element = $element.Substring(1);

        Write-Host "Fetching page for $element"
        $jobWebsite = Invoke-WebRequest "https://gitlab.com/lyze237/dotnet-hootmanager/-/jobs/$element/"
        $amount = ($jobWebsite.AllElements | Where Class -eq "btn btn-sm btn-default" | Measure-Object).Count
        if ($amount -gt 0) {
            Write-Host "Found job with artifacts $element"
            break
        } else {
            Write-Host "Couldn't find artifacts, trying next one"
        }
    }

    $url = "https://gitlab.com/lyze237/dotnet-hootmanager/-/jobs/$element/artifacts/raw/result/"
    if (Get-Command dotnet -errorAction SilentlyContinue) {
        $url = $url + "HootManager-no_runtime.tar";
    } elseif ($IsWindows -or ((Test-Path env:os) -and $env:os -eq "Windows_NT")) {
        $url = $url + "HootManager-win-x64.tar"
    } elseif ($IsLinux) {
        $url = $url + "HootManager-linux-x64.tar"
    } elseif ($IsMacOS) {
        $url = $url + "HootManager-osx-x64.tar"
    } else {
        Write-Host "Unknown OS, aborting"
        exit
    }

    Write-Host "Downloading $url to $filename"
    Invoke-WebRequest -OutFile $filename $url
    Write-Host "Extracting $filename"
    Expand-Tar $filename $tempDirectory

    Write-Host "Copying contents"
    New-Item -ItemType Directory $directory

    Copy-Item "HootManager_temp/result/*/*" "HootManager/"

    Write-Host "Deleting $filename"
    Remove-Item $filename
    Remove-Item -Recurse -Force $tempDirectory
}

if (Get-Command dotnet -errorAction SilentlyContinue) {
    dotnet HootManager\HootManager.dll $args
} elseif ($IsWindows -or ((Test-Path env:os) -and $env:os -eq "Windows_NT")) {
    .\HootManager\HootManager.exe $args
} elseif ($IsLinux -or $IsMacOS) {
    .\HootManager\HootManager $args
} else {
    Write-Host "Unknown OS, aborting"
    exit
}