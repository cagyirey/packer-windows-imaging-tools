$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = "SilentlyContinue"

function Run-SpecializeScripts {
    Start-Transcript -Path ./specialize.log
    $DeployScripts = Get-ChildItem -Recurse -Include *.ps1,*.cmd,*.bat -Exclude "Specialize.ps1"

    foreach ($script in $DeployScripts) {
        Write-Host "[Specialize] | Running deploy script : $($script.Name) `r`n"
        & "$($script.FullName)"
    }
    Stop-Transcript 
}

Push-Location

Set-Location $env:SystemDrive/unattend_resources
Run-SpecializeScripts

Pop-Location

