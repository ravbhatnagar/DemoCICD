﻿$resourceGroupName = 'ravCICDDemoRG'
$storageName = 'ravcicddemostorage'

$password = "P@ssW0rd1"
$certPath = "C:\certificates\examplecert4.pfx"

$securePassword = ConvertTo-SecureString -String $password -Force -AsPlainText
$cert1 = Import-PfxCertificate -FilePath $certPath cert:\LocalMachine\My -Password $securePassword

Add-Type -Path 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureRM.Resources\Microsoft.Azure.Commands.Resources.dll'

Login-AzureRmAccount -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -ServicePrincipal -CertificateThumbprint $cert1.Thumbprint -ApplicationId 4d1165d0-08a3-444d-9863-8a0b9b75ffd6

Set-AzureStorageBlobContent -Context (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName).Context -Container packages -File 'C:\Program Files (x86)\Jenkins\jobs\Demo_CICD\workspace\DemoCICDDeploymentProj\bin\Debug\staging\DemoCICDWebApp\package.zip' -Force

$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName  -Name $storageName).Key1
$storageCtx = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName  -Name $storageName).Context
$sasToken = New-AzureStorageContainerSASToken -Container "packages" -Context $storageCtx -Permission r
$sasToken = ConvertTo-SecureString $sasToken -AsPlainText -Force


#New-AzureRmResourceGroupDeployment -Name ravcddep -hostingPlanName ravhp4444 -TemplateFile "C:\Program Files (x86)\Jenkins\jobs\ravTestProj1\workspace\WebApplication1\AzureResourceGroup1\Templates\WebSite.json" -ResourceGroupName ravAzureRG1 -_artifactsLocationSasToken $sasToken -_artifactsLocation https://ravwdstorage2.blob.core.windows.net/packages/WebApplication1.zip
$webVMDeployment = New-AzureRmResourceGroupDeployment -Name ('ravcddep' +  '-' + ((Get-Date).ToUniversalTime().ToString('MMdd-HHmm'))) -TemplateFile "C:\Program Files (x86)\Jenkins\jobs\Demo_CICD\workspace\DemoCICDDeploymentProj\bin\Debug\staging\DemoCICDDeploymentProj\Templates\azuredeploy.json" -ResourceGroupName $resourceGroupName -TemplateParameterFile "C:\Program Files (x86)\Jenkins\jobs\Demo_CICD\workspace\DemoCICDDeploymentProj\bin\Debug\staging\DemoCICDDeploymentProj\Templates\azuredeploy.parameters.json" -_artifactsLocationSasToken $sasToken -Verbose

$connectionString = $webVMDeployment.Outputs.sqlDbConnectionString.Value
$connectionStringValue = ConvertTo-SecureString $connectionString -AsPlainText -Force

$connectionStringSecret = Set-AzureKeyVaultSecret -VaultName "ravCICDDemoKeyVault" -Name "sqlConnectionString" -SecretValue $connectionStringValue