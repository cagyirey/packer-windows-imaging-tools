# Set all available network adapters to Private 
$NetworkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$Connections = $NetworkListManager.GetNetworkConnections()
$Connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }

# $dnsName = $(if ([string]::IsNullOrWhiteSpace($HostName)) { $env:ComputerName } else { $HostName })

# # Create a self-signed certificate to enable SSL
# $Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $dnsName
# ## Remove existing listeners.
# Remove-Item -Path WSMan:\Localhost\Listener\listener* -Recurse

# ## We use pure PowerShell here because `winrm quickconfig -transport:https` fails with self-signed certs.
# New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

## Optionally enable user certificate authentication.
winrm set winrm/config/service/auth '@{Certificate="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

#New-NetFirewallRule -Displayname 'WINRM-HTTPS-In-TCP' -Name 'WinRM - Powershell remoting HTTPS-In' -Profile Private,Domain -LocalPort 5986 -Protocol TCP

Restart-Service WinRM