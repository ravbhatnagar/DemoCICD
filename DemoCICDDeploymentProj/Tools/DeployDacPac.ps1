
Import-Module Azure -ErrorAction SilentlyContinue

Set-StrictMode -Version 3
$password = "P@ssW0rd1"
$certPath = "C:\certificates\examplecert4.pfx"

$securePassword = ConvertTo-SecureString -String $password -Force -AsPlainText
$cert1 = Import-PfxCertificate -FilePath $certPath cert:\LocalMachine\My -Password $securePassword


Login-AzureRmAccount -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -ServicePrincipal -CertificateThumbprint $cert1.Thumbprint -ApplicationId 4d1165d0-08a3-444d-9863-8a0b9b75ffd6

$dacpacFile = "C:\Program Files (x86)\Jenkins\jobs\Demo_CICD\workspace\DemoCICDSqlProj\bin\Debug\DemoCICDSqlProj.dacpac"

$connectionStringSecretValue = Get-AzureKeyVaultSecret -VaultName "ravCICDDemoKeyVault" -Name "sqlConnectionString"

$connectionString = $connectionStringSecretValue.SecretValueText

#$commandScript =  "`"" + $batchFile + "`" " + "`"" + $dacpacFile + "`" " + "`"" + $connectionString + "`""

$command =  "`"C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\SqlPackage.exe`"" + " /action:Publish " + "/SourceFile:"+ "`"" + $dacpacFile  + "`"" + " /tcs:" + $connectionString

#cmd /c "`"$commandScript`""
cmd $command