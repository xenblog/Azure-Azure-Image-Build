# Support 
Get-AzVMImagePublisher -Location "East US" | Select PublisherName
Get-AzVMImageOffer -Location "East US" -PublisherName "MicrosoftWindowsDesktop" | Select Offer
Get-AzVMImageSku -Location "East US" -PublisherName "MicrosoftWindowsDesktop" -Offer "windows-10" | Select SKUs
Get-AzVMImage -Location "East US" -PublisherName "MicrosoftWindowsDesktop" -Offer "windows-10" -Sku "19h2-evd" | Select Version 
