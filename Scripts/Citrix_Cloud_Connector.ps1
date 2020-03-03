
#Script to setup golden image with Azure Image Builder

$clientId = "69b5193f-23e2-4fb8-9eac-01616f1a341e" #Replace with your clientId
$clientSecret = "jXxAKu7x7ah9GAgIwd50vg=="    #Replace with your clientSecret
$customer = "pandora"  #Replace with your customerid

#Create temp folder
New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null

#Install Citrix Cloud Connector
Invoke-WebRequest -Uri 'https://downloads.cloud.com/edgemo/connector/cwcconnector.exe' -OutFile 'c:\temp\cwcconnector.exe'
Invoke-Expression -Command "c:\temp\CWCConnector.exe /q /Customer:$customer  /ClientId:$ClientId  /ClientSecret:$ClientSecret  /ResourceLocationId:$ResourceLocationId  /AcceptTermsOfService:$True"

#Start sleep
Start-Sleep -Seconds 10
