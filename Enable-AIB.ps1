# Install Azure Module (AZ) - require Administrative Privileges 
$admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if ($admin -eq $True) {
    Install-module Az -force 
}
# Connect to Azure Tennant
Connect-AzAccount 

# Register Azure Image Builder Feature (AIB)
Register-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -Feature VirtualMachineTemplatePreview

$State = $False
While ($state -ne "Registered") {
# Check AIB Feature Status
Get-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -Feature VirtualMachineTemplatePreview | Select-Object  RegistrationState
}
Get-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages | Select-Object  RegistrationState

Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Select-Object RegistrationState

# Register Storage Feature
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage 
Get-AzResourceProvider -ProviderNamespace Microsoft.Storage  | Select-Object RegistrationState

# Register KeyVault Feature
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault