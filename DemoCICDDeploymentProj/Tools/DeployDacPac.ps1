Param(
    [string] $dacpacFile,
    [string] $batchFile
)

Import-Module Azure -ErrorAction SilentlyContinue

Set-StrictMode -Version 3

$connectionStringSecretValue = Get-AzureKeyVaultSecret -VaultName "ravCICDDemoKeyVault" -Name "sqlConnectionString"

$connectionString = $connectionStringSecretValue.SecretValueText

$commandScript =  "`"" + $batchFile + "`" " + "`"" + $dacpacFile + "`" " + "`"" + $connectionString + "`""

cmd /c "`"$commandScript`""