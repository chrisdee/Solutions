# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

$script:aliases = @{
    # Profile aliases
    "Get-WAPackPublishSettingsFile" = "Get-AzurePublishSettingsFile";
    "Get-WAPackSubscription" = "Get-AzureSubscription";
    "Import-WAPackPublishSettingsFile" = "Import-AzurePublishSettingsFile";
    "Remove-WAPackSubscription" = "Remove-AzureSubscription";
    "Select-WAPackSubscription" = "Select-AzureSubscription";
    "Set-WAPackSubscription" = "Set-AzureSubscription";
    "Show-WAPackPortal" = "Show-AzurePortal";
    "Test-WAPackName" = "Test-AzureName";
    "Get-WAPackEnvironment" = "Get-AzureEnvironment";
    "Add-WAPackEnvironment" = "Add-AzureEnvironment";
    "Set-WAPackEnvironment" = "Set-AzureEnvironment";
    "Remove-WAPackEnvironment" = "Remove-AzureEnvironment";

    # Websites aliases
    "New-WAPackWebsite" = "New-AzureWebsite";
    "Get-WAPackWebsite" = "Get-AzureWebsite";
    "Set-WAPackWebsite" = "Set-AzureWebsite";
    "Remove-WAPackWebsite" = "Remove-AzureWebsite";
    "Start-WAPackWebsite" = "Start-AzureWebsite";
    "Stop-WAPackWebsite" = "Stop-AzureWebsite";
    "Restart-WAPackWebsite" = "Restart-AzureWebsite";
    "Show-WAPackWebsite" = "Show-AzureWebsite";
    "Get-WAPackWebsiteLog" = "Get-AzureWebsiteLog";
    "Save-WAPackWebsiteLog" = "Save-AzureWebsiteLog";
    "Get-WAPackWebsiteLocation" = "Get-AzureWebsiteLocation";
    "Get-WAPackWebsiteDeployment" = "Get-AzureWebsiteDeployment";
    "Restore-WAPackWebsiteDeployment" = "Restore-AzureWebsiteDeployment";
    "Enable-WAPackWebsiteApplicationDiagnositc" = "Enable-AzureWebsiteApplicationDiagnostic";
    "Disable-WAPackWebsiteApplicationDiagnostic" = "Disable-AzureWebsiteApplicationDiagnostic";

    # Service Bus aliases
    "Get-WAPackSBLocation" = "Get-AzureSBLocation";
    "Get-WAPackSBNamespace" = "Get-AzureSBNamespace";
    "New-WAPackSBNamespace" = "New-AzureSBNamespace";
    "Remove-WAPackSBNamespace" = "Remove-AzureSBNamespace";
    
    # Compute aliases
    "New-AzureDnsConfig" = "New-AzureDns";
    "Set-AzureBootDiagnostics" = "Set-AzureVMBootDiagnostics";
    
    # HDInsight aliases
    "Invoke-Hive" = "Invoke-AzureHDInsightHiveJob";
    "hive" = "Invoke-AzureHDInsightHiveJob";

    #StorSimple aliases
    "Get-SSAccessControlRecord" = "Get-AzureStorSimpleAccessControlRecord" ;
    "Get-SSDevice"= "Get-AzureStorSimpleDevice" ;
    "Get-SSDeviceBackup" = "Get-AzureStorSimpleDeviceBackup" ;
    "Get-SSDeviceBackupPolicy" = "Get-AzureStorSimpleDeviceBackupPolicy" ;
    "Get-SSDeviceConnectedInitiator" = "Get-AzureStorSimpleDeviceConnectedInitiator" ;
    "Get-SSDeviceVolume" = "Get-AzureStorSimpleDeviceVolume" ;
    "Get-SSDeviceVolumeContainer" = "Get-AzureStorSimpleDeviceVolumeContainer" ;
    "Get-SSFailoverVolumeContainers" = "Get-AzureStorSimpleFailoverVolumeContainers" ;
    "Get-SSJob" = "Get-AzureStorSimpleJob" ;
    "Get-SSResource" = "Get-AzureStorSimpleResource" ;
    "Get-SSResourceContext" = "Get-AzureStorSimpleResourceContext" ;
    "Get-SSStorageAccountCredential" = "Get-AzureStorSimpleStorageAccountCredential" ;
    "Get-SSTask" = "Get-AzureStorSimpleTask" ;
    "New-SSAccessControlRecord" = "New-AzureStorSimpleAccessControlRecord" ;
    "New-SSDeviceBackupPolicy" = "New-AzureStorSimpleDeviceBackupPolicy" ;
    "New-SSDeviceBackupScheduleAddConfig" = "New-AzureStorSimpleDeviceBackupScheduleAddConfig" ;
    "New-SSDeviceBackupScheduleUpdateConfig" = "New-AzureStorSimpleDeviceBackupScheduleUpdateConfig" ;
    "New-SSDeviceVolume" = "New-AzureStorSimpleDeviceVolume";
    "New-SSDeviceVolumeContainer" = "New-AzureStorSimpleDeviceVolumeContainer" ;
    "New-SSInlineStorageAccountCredential" = "New-AzureStorSimpleInlineStorageAccountCredential" ;
    "New-SSNetworkConfig" = "New-AzureStorSimpleNetworkConfig";
    "New-SSStorageAccountCredential" = "New-AzureStorSimpleStorageAccountCredential";
    "New-SSVirtualDevice" = "New-AzureStorSimpleVirtualDevice";
    "Remove-SSAccessControlRecord" = "Remove-AzureStorSimpleAccessControlRecord";
    "Remove-SSDeviceBackup" = "Remove-AzureStorSimpleDeviceBackup";
    "Remove-SSDeviceBackupPolicy" = "Remove-AzureStorSimpleDeviceBackupPolicy";
    "Remove-SSDeviceVolume" = "Remove-AzureStorSimpleDeviceVolume";
    "Remove-SSDeviceVolumeContainer" = "Remove-AzureStorSimpleDeviceVolumeContainer";
    "Remove-SSStorageAccountCredential" = "Remove-AzureStorSimpleStorageAccountCredential";
    "Select-SSResource" = "Select-AzureStorSimpleResource";
    "Set-SSAccessControlRecord" = "Set-AzureStorSimpleAccessControlRecord";
    "Set-SSDevice" = "Set-AzureStorSimpleDevice";
    "Set-SSDeviceBackupPolicy" = "Set-AzureStorSimpleDeviceBackupPolicy";
    "Set-SSDeviceVolume" = "Set-AzureStorSimpleDeviceVolume";
    "Set-SSStorageAccountCredential" = "Set-AzureStorSimpleStorageAccountCredential";
    "Set-SSVirtualDevice" = "Set-AzureStorSimpleVirtualDevice";
    "Start-SSBackupCloneJob" = "Start-AzureStorSimpleBackupCloneJob";
    "Start-SSDeviceBackupJob" = "Start-AzureStorSimpleDeviceBackupJob";
    "Start-SSDeviceBackupRestoreJob" = "Start-AzureStorSimpleDeviceBackupRestoreJob";
    "Start-SSDeviceFailoverJob" = "Start-AzureStorSimpleDeviceFailoverJob";
    "Stop-SSJob" = "Stop-AzureStorSimpleJob";	
    "Confirm-SSLegacyVolumeContainerStatus" = "Confirm-AzureStorSimpleLegacyVolumeContainerStatus";
    "Get-SSLegacyVolumeContainerConfirmStatus" = "Get-AzureStorSimpleLegacyVolumeContainerConfirmStatus";
    "Get-SSLegacyVolumeContainerMigrationPlan" = "Get-AzureStorSimpleLegacyVolumeContainerMigrationPlan";
    "Get-SSLegacyVolumeContainerStatus" = "Get-AzureStorSimpleLegacyVolumeContainerStatus";
    "Import-SSLegacyApplianceConfig" = "Import-AzureStorSimpleLegacyApplianceConfig";
    "Import-SSLegacyVolumeContainer" = "Import-AzureStorSimpleLegacyVolumeContainer";
    "Start-SSLegacyVolumeContainerMigrationPlan" = "Start-AzureStorSimpleLegacyVolumeContainerMigrationPlan";
}

$aliases.GetEnumerator() | Select @{Name='Name'; Expression={$_.Key}}, @{Name='Value'; Expression={$_.Value}} | New-Alias -Description "AzureAlias"

# SIG # Begin signature block
# MIIkBgYJKoZIhvcNAQcCoIIj9zCCI/MCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBX1/L1COFm3S/X
# vaUgZDg8wMAeL53Y93rGAZB1bX3i5qCCDYMwggYBMIID6aADAgECAhMzAAAAxOmJ
# +HqBUOn/AAAAAADEMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTcwODExMjAyMDI0WhcNMTgwODExMjAyMDI0WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCIirgkwwePmoB5FfwmYPxyiCz69KOXiJZGt6PLX4kvOjMuHpF4+nypH4IBtXrL
# GrwDykbrxZn3+wQd8oUK/yJuofJnPcUnGOUoH/UElEFj7OO6FYztE5o13jhwVG87
# 7K1FCTBJwb6PMJkMy3bJ93OVFnfRi7uUxwiFIO0eqDXxccLgdABLitLckevWeP6N
# +q1giD29uR+uYpe/xYSxkK7WryvTVPs12s1xkuYe/+xxa8t/CHZ04BBRSNTxAMhI
# TKMHNeVZDf18nMjmWuOF9daaDx+OpuSEF8HWyp8dAcf9SKcTkjOXIUgy+MIkogCy
# vlPKg24pW4HvOG6A87vsEwvrAgMBAAGjggGAMIIBfDAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUy9ZihM9gOer/Z8Jc0si7q7fDE5gw
# UgYDVR0RBEswSaRHMEUxDTALBgNVBAsTBE1PUFIxNDAyBgNVBAUTKzIzMDAxMitj
# ODA0YjVlYS00OWI0LTQyMzgtODM2Mi1kODUxZmEyMjU0ZmMwHwYDVR0jBBgwFoAU
# SG5k5VAF04KqFzc3IrVtqMp1ApUwVAYDVR0fBE0wSzBJoEegRYZDaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljQ29kU2lnUENBMjAxMV8yMDEx
# LTA3LTA4LmNybDBhBggrBgEFBQcBAQRVMFMwUQYIKwYBBQUHMAKGRWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWljQ29kU2lnUENBMjAxMV8y
# MDExLTA3LTA4LmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4ICAQAG
# Fh/bV8JQyCNPolF41+34/c291cDx+RtW7VPIaUcF1cTL7OL8mVuVXxE4KMAFRRPg
# mnmIvGar27vrAlUjtz0jeEFtrvjxAFqUmYoczAmV0JocRDCppRbHukdb9Ss0i5+P
# WDfDThyvIsoQzdiCEKk18K4iyI8kpoGL3ycc5GYdiT4u/1cDTcFug6Ay67SzL1BW
# XQaxFYzIHWO3cwzj1nomDyqWRacygz6WPldJdyOJ/rEQx4rlCBVRxStaMVs5apao
# pIhrlihv8cSu6r1FF8xiToG1VBpHjpilbcBuJ8b4Jx/I7SCpC7HxzgualOJqnWmD
# oTbXbSD+hdX/w7iXNgn+PRTBmBSpwIbM74LBq1UkQxi1SIV4htD50p0/GdkUieeN
# n2gkiGg7qceATibnCCFMY/2ckxVNM7VWYE/XSrk4jv8u3bFfpENryXjPsbtrj4Ns
# h3Kq6qX7n90a1jn8ZMltPgjlfIOxrbyjunvPllakeljLEkdi0iHv/DzEMQv3Lz5k
# pTdvYFA/t0SQT6ALi75+WPbHZ4dh256YxMiMy29H4cAulO2x9rAwbexqSajplnbI
# vQjE/jv1rnM3BrJWzxnUu/WUyocc8oBqAU+2G4Fzs9NbIj86WBjfiO5nxEmnL9wl
# iz1e0Ow0RJEdvJEMdoI+78TYLaEEAo5I+e/dAs8DojCCB3owggVioAMCAQICCmEO
# kNIAAAAAAAMwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAyMDExMB4XDTExMDcwODIwNTkwOVoXDTI2MDcwODIxMDkw
# OVowfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
# AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBAKvw+nIQHC6t2G6qghBNNLrytlghn0IbKmvpWlCq
# uAY4GgRJun/DDB7dN2vGEtgL8DjCmQawyDnVARQxQtOJDXlkh36UYCRsr55JnOlo
# XtLfm1OyCizDr9mpK656Ca/XllnKYBoF6WZ26DJSJhIv56sIUM+zRLdd2MQuA3Wr
# aPPLbfM6XKEW9Ea64DhkrG5kNXimoGMPLdNAk/jj3gcN1Vx5pUkp5w2+oBN3vpQ9
# 7/vjK1oQH01WKKJ6cuASOrdJXtjt7UORg9l7snuGG9k+sYxd6IlPhBryoS9Z5JA7
# La4zWMW3Pv4y07MDPbGyr5I4ftKdgCz1TlaRITUlwzluZH9TupwPrRkjhMv0ugOG
# jfdf8NBSv4yUh7zAIXQlXxgotswnKDglmDlKNs98sZKuHCOnqWbsYR9q4ShJnV+I
# 4iVd0yFLPlLEtVc/JAPw0XpbL9Uj43BdD1FGd7P4AOG8rAKCX9vAFbO9G9RVS+c5
# oQ/pI0m8GLhEfEXkwcNyeuBy5yTfv0aZxe/CHFfbg43sTUkwp6uO3+xbn6/83bBm
# 4sGXgXvt1u1L50kppxMopqd9Z4DmimJ4X7IvhNdXnFy/dygo8e1twyiPLI9AN0/B
# 4YVEicQJTMXUpUMvdJX3bvh4IFgsE11glZo+TzOE2rCIF96eTvSWsLxGoGyY0uDW
# iIwLAgMBAAGjggHtMIIB6TAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQUSG5k
# 5VAF04KqFzc3IrVtqMp1ApUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYD
# VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUci06AjGQQ7kU
# BU7h6qfHMdEjiTQwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybC5taWNyb3Nv
# ZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAz
# XzIyLmNybDBeBggrBgEFBQcBAQRSMFAwTgYIKwYBBQUHMAKGQmh0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAz
# XzIyLmNydDCBnwYDVR0gBIGXMIGUMIGRBgkrBgEEAYI3LgMwgYMwPwYIKwYBBQUH
# AgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvZG9jcy9wcmltYXJ5
# Y3BzLmh0bTBABggrBgEFBQcCAjA0HjIgHQBMAGUAZwBhAGwAXwBwAG8AbABpAGMA
# eQBfAHMAdABhAHQAZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAZ/KG
# pZjgVHkaLtPYdGcimwuWEeFjkplCln3SeQyQwWVfLiw++MNy0W2D/r4/6ArKO79H
# qaPzadtjvyI1pZddZYSQfYtGUFXYDJJ80hpLHPM8QotS0LD9a+M+By4pm+Y9G6XU
# tR13lDni6WTJRD14eiPzE32mkHSDjfTLJgJGKsKKELukqQUMm+1o+mgulaAqPypr
# WEljHwlpblqYluSD9MCP80Yr3vw70L01724lruWvJ+3Q3fMOr5kol5hNDj0L8giJ
# 1h/DMhji8MUtzluetEk5CsYKwsatruWy2dsViFFFWDgycScaf7H0J/jeLDogaZiy
# WYlobm+nt3TDQAUGpgEqKD6CPxNNZgvAs0314Y9/HG8VfUWnduVAKmWjw11SYobD
# HWM2l4bf2vP48hahmifhzaWX0O5dY0HjWwechz4GdwbRBrF1HxS+YWG18NzGGwS+
# 30HHDiju3mUv7Jf2oVyW2ADWoUa9WfOXpQlLSBCZgB/QACnFsZulP0V3HjXG0qKi
# n3p6IvpIlR+r+0cjgPWe+L9rt0uX4ut1eBrs6jeZeRhL/9azI2h15q/6/IvrC4Dq
# aTuv/DDtBEyO3991bWORPdGdVk5Pv4BXIqF4ETIheu9BCrE/+6jMpF3BoYibV3FW
# TkhFwELJm3ZbCoBIa/15n8G9bW1qyVJzEw16UM0xghXZMIIV1QIBATCBlTB+MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNy
# b3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExAhMzAAAAxOmJ+HqBUOn/AAAAAADE
# MA0GCWCGSAFlAwQCAQUAoIHMMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwG
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCADopNH
# MHLV5L49kJJ4GRml/A2rQVrrQmSHPBIoL+nbtzBgBgorBgEEAYI3AgEMMVIwUKA2
# gDQATQBpAGMAcgBvAHMAbwBmAHQAIABBAHoAdQByAGUAIABQAG8AdwBlAHIAUwBo
# AGUAbABsoRaAFGh0dHA6Ly9Db2RlU2lnbkluZm8gMA0GCSqGSIb3DQEBAQUABIIB
# ABS4/LDfeRJD9FX7eQfl519dypufX9+1AEzcLp+WGFyqB1PSQZRrtK0Vjon0tUg4
# 2g4gpkd9xkOe864GirCSEJ7iHsU1uEFC11VNUldrG9qenbIZ0JJNemA1vN0bMzP3
# Zvv2qFl1NIK1MioiWeKjLgErNLR99sOWm8fdG31McNe/Dn039wPDGJFGVdei1tWt
# 1GEHi1tdONeSaKFUb/YASit4LF9WlGm1cme/8NRtaZQQQP6nLbhxkjYXYDAPiZRv
# hTd7W+pImyflDyuH5HxX9bIwZbCRboAcD3MlRCXl8Mz1tFT1GX1PE919CJvqizRl
# t8FntGo6iEdfOMqWfF8YQLmhghNFMIITQQYKKwYBBAGCNwMDATGCEzEwghMtBgkq
# hkiG9w0BBwKgghMeMIITGgIBAzEPMA0GCWCGSAFlAwQCAQUAMIIBOwYLKoZIhvcN
# AQkQAQSgggEqBIIBJjCCASICAQEGCisGAQQBhFkKAwEwMTANBglghkgBZQMEAgEF
# AAQgE/x12WywH53lm0QrFVmiGQd47eSYbGxYOxcVUjtyXvsCBlp7bbQ6yhgSMjAx
# ODAyMDkwNjQ4MDguNDJaMAcCAQGAAgH0oIG4pIG1MIGyMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMQwwCgYDVQQLEwNBT0MxJzAlBgNVBAsTHm5D
# aXBoZXIgRFNFIEVTTjoxMkU3LTMwNjQtNjExMjElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaCCDsowggZxMIIEWaADAgECAgphCYEqAAAAAAAC
# MA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRo
# b3JpdHkgMjAxMDAeFw0xMDA3MDEyMTM2NTVaFw0yNTA3MDEyMTQ2NTVaMHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEAqR0NvHcRijog7PwTl/X6f2mUa3RUENWlCgCChfvtfGhLLF/Fw+Vh
# wna3PmYrW/AVUycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRUQwzXTbg4CLNC3ZOs
# 1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJYR4YyhB50YWeRX4FUsc+TTJLBxKZd0WET
# bijGGvmGgLvfYfxGwScdJGcSchohiq9LZIlQYrFd/XcfPfBXday9ikJNQFHRD5wG
# Pmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDaTgaRtogINeh4HLDpmc085y9Euqf0
# 3GS9pAHBIAmTeM38vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCCAeIwEAYJKwYBBAGC
# NxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8RhvFM2hahW1VMBkGCSsGAQQB
# gjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
# MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJ
# oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYB
# BQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUwgZIwgY8GCSsGAQQB
# gjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL1BL
# SS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBMAGUAZwBh
# AGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0AC4gHTANBgkqhkiG
# 9w0BAQsFAAOCAgEAB+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1Mb7PBeKp/vpXbRkw
# s8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7uVOMzPRgEop2zEBAQZvcXBf/
# XPleFzWYJFZLdO9CEMivv3/Gf/I3fVo/HPKZeUqRUgCvOA8X9S95gWXZqbVr5MfO
# 9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v/rbljjO7Yl+a21dA6fHO
# mWaQjP9qYn/dxUoLkSbiOewZSnFjnXshbcOco6I8+n99lmqQeKZt0uGc+R38ONiU
# 9MalCpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ouOVd2onGqBooPiRa6
# YacRy5rYDkeagMXQzafQ732D8OE7cQnfXXSYIghh2rBQHm+98eEA3+cxB6STOvdl
# R3jo+KhIq/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUBHoD7G4kqVDmyW9rI
# DVWZeodzOwjmmC3qjeAzLhIp9cAvVCch98isTtoouLGp25ayp0Kiyc8ZQU3ghvkq
# mqMRZjDTu3QyS99je/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXjad5XwdHeMMD9zOZN
# +w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzVs341Hgi62jbb01+P3nSISRIwggTZ
# MIIDwaADAgECAhMzAAAArIohvHrSm3L0AAAAAACsMA0GCSqGSIb3DQEBCwUAMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2MDkwNzE3NTY1NFoXDTE4
# MDkwNzE3NTY1NFowgbIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xDDAKBgNVBAsTA0FPQzEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNOOjEyRTct
# MzA2NC02MTEyMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAocT0PKWOczGhF0Fcq3cI
# t6nRQ6q739x0+bo1VmqECdipu/tU9xjZxqWzQ+j6JgHMPTX1fgvkTJgq04aVJQVc
# 3rs7DS9i7I/ZjHSvN4sXm2s3p0qwNK1yyIn1gcyh1T+o87EFqPenB7pB2aiPMUad
# 7WIr4GqbeSy65/UZtiZ/hNIdpSgzsObCLXmYq4jjDx9me5rYGF5sgfE4YHQeOqen
# 6zRqXF69daWtVZJXZdImOqAQCkEEsSeQZ+De7ouVo+cA5A2cxgIOp9abTD0zyYS9
# rqLFvOGI50qf9rLjWqd6joyhGF5qRs72rKuasqj8r36n5LDnzQWiZ7X6QvHSAySq
# 5wIDAQABo4IBGzCCARcwHQYDVR0OBBYEFNhHcKiFNYsTYa+HkOhFFyTgmKcNMB8G
# A1UdIwQYMBaAFNVjOlyKMZDzQ3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeG
# RWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Rp
# bVN0YVBDQV8yMDEwLTA3LTAxLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUH
# MAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljVGltU3Rh
# UENBXzIwMTAtMDctMDEuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwDQYJKoZIhvcNAQELBQADggEBAEjs6F4nwxsYnF20znZuNwwfXWMcDV2k
# I9IVtM7QQAnlm1+s8XntcO0yXl0MdSH089QViQH1ZWuxwNaMWtC4hf1H+q30bxBJ
# hph6/cFhG698YhK5ZUxRNlf5nWAUhMHY++JvECwXhWN+wo8eExXvgAfxUJct5L36
# ySg2mGE010wBWACqYtAHA03BEl2XLISfzvFGbPX69AYKzpuYe6nkNQiTZgzFRKhJ
# ULf3BTt3caqwCr9xbv57E+RpAAbvryIm4MV+rTZqnHCCFygC4L+8wyGkQAFrV1fS
# 8J5rLQ1GyKfHR/6ElZt7T5wj5awd/gtvLz57yXW7SYv8jrhE3fqy5/qhggN0MIIC
# XAIBATCB4qGBuKSBtTCBsjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEMMAoGA1UECxMDQU9DMScwJQYDVQQLEx5uQ2lwaGVyIERTRSBFU046MTJF
# Ny0zMDY0LTYxMTIxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZp
# Y2WiJQoBATAJBgUrDgMCGgUAAxUAOXAlixTIed1fDF3pi5yzlJn3HLeggcEwgb6k
# gbswgbgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xDDAKBgNV
# BAsTA0FPQzEnMCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjI2NjUtNEMzRi1DNURF
# MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBTb3VyY2UgTWFzdGVyIENsb2NrMA0G
# CSqGSIb3DQEBBQUAAgUA3idAzzAiGA8yMDE4MDIwODIxMzQwN1oYDzIwMTgwMjA5
# MjEzNDA3WjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDeJ0DPAgEAMAcCAQACAhvL
# MAcCAQACAhlqMAoCBQDeKJJPAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQB
# hFkKAwGgCjAIAgEAAgMW42ChCjAIAgEAAgMHoSAwDQYJKoZIhvcNAQEFBQADggEB
# ABJF1feduxxbwWzyoYOXNRneVN7cCvOro5YcbVFDn5d8DHUt6kFqmWXt7EXi48OL
# 1dzHkOyxTrlSfXi6Rmv5axX5NYXLRj3I8WA6SZsSKhkwapj02dhpsueLQX0x53SF
# 6x3c0PJdMeqYJ6vh5YdgfeGQw3UouuGqvE6ZYYpJz2mvoGAuwmMQ9vT9Fr92XaMH
# 0DUwxAzu6STg+3TxlaCkLsUMRZQlIdITPXd/6pNdwveu/0F8gq3tSKXxWKoBqxMu
# CNgtaLZ/YaDQvecyb7J7IUzmRjYS3MsrRBbJGSYCfgqJbQ3T6K951KArvQpB0p4P
# 0VtKlZApGhcuCfIF2Jlm/DIxggL1MIIC8QIBATCBkzB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMAITMwAAAKyKIbx60pty9AAAAAAArDANBglghkgBZQMEAgEF
# AKCCATIwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEi
# BCDQyXyteqTavcXtj5JxgpAm1AYHOfgjLJ2GqkJHu73xwzCB4gYLKoZIhvcNAQkQ
# AgwxgdIwgc8wgcwwgbEEFDlwJYsUyHndXwxd6Yucs5SZ9xy3MIGYMIGApH4wfDEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
# cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAACsiiG8etKbcvQAAAAAAKww
# FgQUOSq6EAsfZ+GdjCjQ/2isjZYrhk0wDQYJKoZIhvcNAQELBQAEggEAlahJ8q8J
# EDnHC8nh0O0uRTGQ+m9RW+xi0KBXQNRHK+Kzx4IKFSSeZzRyrKsZqrZHoFGptkv+
# ClsdaiT16n98DTs5DPIZE4gNQgUhGULS07YkUtMajf5YzoO0fzme1TGSEexC6f0I
# L2GwjTFptCHXnd0tlXg1q5MyLedYWtMaaHUGO6sNECUeoLFeZ52ooBFHZTrCmXhP
# AQpiOoqjj6gcNOlhtFzrNC05lJJs3xXaXynC1CwgrhuQqF0miRlDqWsXVubrzm88
# +nM/86eSqhUczKMbVVYIPEktEeNWjtGfR0k2ufWJqvJ7g+Pebra4dNMyM/UXLkDe
# 9fN1vYHgcv+KFA==
# SIG # End signature block
