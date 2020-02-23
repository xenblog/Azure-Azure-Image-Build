[string]$AIBResourceGroup   = 'RG_EUS_AzureImageBuilder'
[string]$AIBLocation        = 'East US'

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

# Create AIB Resource Group
New-AzResourceGroup -Name $AIBResourceGroup -Location $AIBLocation

# Add AIB Application ID as contributer to AIB Resource Group
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName $AIBResourceGroup

# Deploy AIB Template
$TemplateUri = "https://raw.githubusercontent.com/xenblog/Azure-Azure-Image-Build/master/Templates/AIB-W10-SingleSession-CVAD.json"
New-AzResourceGroupDeployment -ResourceGroupName $AIBResourceGroup -TemplateUri $TemplateUri -OutVariable Output -Verbose
