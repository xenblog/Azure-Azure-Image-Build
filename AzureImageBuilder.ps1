[string]$AIBResourceGroup   = 'RG_EUS_AzureImageBuilder'
[string]$AIBLocation        = 'East US'

# Connect to Azure Tennant
Connect-AzAccount 

# Create AIB Resource Group
New-AzResourceGroup -Name $AIBResourceGroup -Location $AIBLocation

# Add AIB Application ID as contributer to AIB Resource Group
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName $AIBResourceGroup

# Deploy AIB Template
$TemplateUri = "https://raw.githubusercontent.com/xenblog/Azure-Azure-Image-Build/master/Templates/AIB-W10-SingleSession-CVAD.json"
New-AzResourceGroupDeployment -ResourceGroupName $AIBResourceGroup -TemplateUri $TemplateUri -OutVariable Output -Verbose

# Start Building the Golden Image
$ImageTemplateName = $Output.Outputs["imageTemplateName"].Value
Invoke-AzResourceAction -ResourceGroupName $AIBResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ResourceName $ImageTemplateName -Action Run

(Get-AzResource -ResourceGroupName RG_EUS_AzureImageBuilder -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name $ImageTemplateName).Properties.lastRunStatus




