[string]$SIGResourceGroup   = 'RG_EUS_SharedImageGallery'
[string]$SIGLocation        = 'East US'
[string]$SIGName            = 'SIG_EUS'

# Connect to Azure Tennant
Connect-AzAccount 

# Create SIG Resource Group
$resourceGroup = New-AzResourceGroup -Name $SIGResourceGroup -Location $SIGLocation	

# Create SIG Gallery
$gallery = New-AzGallery -GalleryName $SIGName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Description 'Shared Image Gallery for my organization'

# Add AIB Application ID as contributer to SIG Resource Group
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName $SIGResourceGroup

# Create Image definition
$galleryImage = New-AzGalleryImageDefinition `
   -GalleryName $gallery.Name `
   -ResourceGroupName $resourceGroup.ResourceGroupName `
   -Location $gallery.Location `
   -Name 'Win10-1909' `
   -OsState generalized `
   -OsType Windows `
   -Publisher 'MicrosoftWindowsDesktop' `
   -Offer 'windows-10' `
   -Sku '19h2-evd'

# Start Building the Golden Image
$TemplateUri = "https://raw.githubusercontent.com/xenblog/Azure-Azure-Image-Build/master/Templates/AIB-W10-SingleSession-CVAD-SIG.json"
New-AzResourceGroupDeployment -ResourceGroupName $SIGResourceGroup -TemplateUri $TemplateUri -OutVariable Output -Verbose -SIGImageDefinitionId $galleryImage.Id

$managedImage = Get-AzImage `
   -ImageName myImage `
   -ResourceGroupName $SIGResourceGroup

# Create an image version
$region1 = @{Name='North Europe';ReplicaCount=1}
$region2 = @{Name='East US';ReplicaCount=2}
$targetRegions = @($region1,$region2)
$imageVersion = New-AzGalleryImageVersion `
   -GalleryImageDefinitionName $galleryImage.Name `
   -GalleryImageVersionName '1.0.0' `
   -GalleryName $gallery.Name `
   -ResourceGroupName $resourceGroup.ResourceGroupName `
   -Location $resourceGroup.Location `
   -TargetRegion $targetRegions  `
   -Source $managedImage.Id.ToString() `
   -PublishingProfileEndOfLifeDate '2020-01-01' `
   -asJob
