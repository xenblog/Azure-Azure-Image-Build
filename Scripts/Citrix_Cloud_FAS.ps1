
#Script to setup golden image with Azure Image Builder

$VDAArgs = '/quiet /controllers "az-ccc01.xenblog.dk az-ccc02.xenblog.dk" /noreboot /quiet /enable_remote_assistance /disableexperiencemetrics /components VDA /virtualmachine /optimize /enable_real_time_transport /enable_framehawk_port /enable_hdx_ports /enable_hdx_udp_ports /exclude "Citrix Telemetry Service" /install_mcsio_driver'

#Create temp folder
New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null

#Install Citrix Federated Authentication Server
Invoke-WebRequest -Uri 'https://weusourcefiles.blob.core.windows.net/sourcefiles/FederatedAuthenticationService_x64_1906.msi' -OutFile 'c:\temp\FederatedAuthenticationService_x64_1906.msi'
Invoke-Expression -Command "msiexec.exe -i c:\temp\FederatedAuthenticationService_x64_1906.msi -qb"

#Start sleep
Start-Sleep -Seconds 10

