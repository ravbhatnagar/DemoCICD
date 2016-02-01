#
# ServicePrincipalAuth.ps1
#
Login-AzureRmAccount -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -ServicePrincipal -CertificateThumbprint $cert1.Thumbprint -ApplicationId 4d1165d0-08a3-444d-9863-8a0b9b75ffd6
