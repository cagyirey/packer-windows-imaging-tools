
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = 'https://github.com/PowerShell/Win32-OpenSSH/releases/latest/'
$request = [System.Net.WebRequest]::Create($url)
$request.AllowAutoRedirect=$false
$response=$request.GetResponse()

iwr $(([String]$response.GetResponseHeader("Location")).Replace('tag','download') + '/OpenSSH-Win64.zip') `
    -OutFile $env:TEMP/openssh.zip 

Expand-Archive -Path $env:TEMP/openssh.zip -DestinationPath "$env:ProgramFiles\OpenSSH"

powershell.exe -ExecutionPolicy Bypass -File "$env:ProgramFiles\OpenSSH\install-sshd.ps1"

New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
Set-Service sshd -StartupType Automatic
Start-Service sshd