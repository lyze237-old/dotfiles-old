function Expand-Tar($tarFile, $dest) {

    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
    }

    Expand-7Zip $tarFile $dest
}

$filename = "HootManager.tar"

if (-not (Test-Path HootManager)) {
    Write-Host "Downloading latest version"
    Write-Host "Checking job page"
    $website = Invoke-WebRequest https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/
    $elements = $website.AllElements | Where Class -eq "build-link" | Select -ExpandProperty innerText
    Write-Host "Iterating through jobs"
    foreach ($element in $elements) {
        $element = $element.Substring(1);

        Write-Host "Fetching page for $element"
        $jobWebsite = Invoke-WebRequest https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/$element/
        $amount = ($jobWebsite.AllElements | Where Class -eq "btn btn-sm btn-default" | Measure-Object).Count
        if ($amount -gt 0) {
            Write-Host "Found job with artifacts $element"
            break
        } else {
            Write-Host "Couldn't find artifacts, trying next one"
        }
    }

    $id = $element
    echo $id
    if (Get-Command dotnet -errorAction SilentlyContinue) {
        $url = "https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/$id/artifacts/raw/result/HootManager-no_runtime.tar"
    } elseif ((Test-Path env:os) -and $env:os -eq "Windows_NT") {
        $url = "https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/$id/artifacts/raw/result/HootManager-win-x64.tar"
    } elseif ($IsLinux) {
        $url = "https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/$id/artifacts/raw/result/HootManager-linux-x64.tar"
    } elseif ($IsMacOS) {
        $url = "https://gitlab.com/lyze237-dotnet/hootmanager/-/jobs/$id/artifacts/raw/result/HootManager-osx-x64.tar"
    } else {
        Write-Host "Unknown OS, aborting"
        exit
    }

    Write-Host "Downloading $url to $filename"
    Invoke-WebRequest -OutFile $filename $url
    Write-Host "Extracting $filename"
    Expand-Tar $filename HootManager_temp

    Write-Host "Copying contents"
    New-Item -ItemType Directory HootManager

    Copy-Item "HootManager_temp/result/*/*" "HootManager/"

    Write-Host "Deleting $filename"
    Remove-Item $filename
    Remove-Item HootManager_temp
}

# dotnet HootManager\HootManager.dll %*