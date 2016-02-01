$resourceGroupName = 'ravCICDDemoRG'
$storageName = 'ravcicddemostorage'


$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName  -Name $storageName).Key1
$storageCtx = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName  -Name $storageName).Context
$sasToken = New-AzureStorageContainerSASToken -Container "packages" -Context $storageCtx -Permission r
$sasToken = ConvertTo-SecureString $sasToken -AsPlainText -Force

#New-AzureRmResourceGroupDeployment -Name ravcddep -hostingPlanName ravhp4444 -TemplateFile "C:\Program Files (x86)\Jenkins\jobs\ravTestProj1\workspace\WebApplication1\AzureResourceGroup1\Templates\WebSite.json" -ResourceGroupName ravAzureRG1 -_artifactsLocationSasToken $sasToken -_artifactsLocation https://ravwdstorage2.blob.core.windows.net/packages/WebApplication1.zip
New-AzureRmResourceGroupDeployment -Name ('ravcddep' +  '-' + ((Get-Date).ToUniversalTime().ToString('MMdd-HHmm'))) -TemplateFile "E:\src\DemoCICD\DemoCICDDeploymentProj\DemoCICDDeploymentProj\Templates\azuredeploy.json" -ResourceGroupName $resourceGroupName -TemplateParameterFile "E:\src\DemoCICD\DemoCICDDeploymentProj\DemoCICDDeploymentProj\Templates\azuredeploy.parameters.json" -_artifactsLocationSasToken $sasToken -Verbose