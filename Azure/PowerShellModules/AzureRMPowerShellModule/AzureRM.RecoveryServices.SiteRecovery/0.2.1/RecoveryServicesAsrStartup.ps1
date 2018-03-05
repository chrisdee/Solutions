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

@{
    # Azure Site Recovery aliases
    "Edit-ASRRecoveryPlan" = "Edit-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Edit-ASRRP" = "Edit-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Get-ASRAlertSetting" = "Get-AzureRmRecoveryServicesAsrAlertSetting";
    "Get-ASREvent" = "Get-AzureRmRecoveryServicesAsrEvent";
    "Get-ASRFabric" = "Get-AzureRmRecoveryServicesAsrFabric";
    "Get-ASRJob" = "Get-AzureRmRecoveryServicesAsrJob";
    "Get-ASRNetwork" = "Get-AzureRmRecoveryServicesAsrNetwork";
    "Get-ASRNetworkMapping" = "Get-AzureRmRecoveryServicesAsrNetworkMapping";
    "Get-ASRNotificationSetting" = "Get-AzureRmRecoveryServicesAsrAlertSetting";
    "Get-ASRPolicy" = "Get-AzureRmRecoveryServicesAsrPolicy";
    "Get-ASRProtectableItem" = "Get-AzureRmRecoveryServicesAsrProtectableItem";
    "Get-ASRProtectionContainer" = "Get-AzureRmRecoveryServicesAsrProtectionContainer";
    "Get-ASRProtectionContainerMapping" = "Get-AzureRmRecoveryServicesAsrProtectionContainerMapping";
    "Get-ASRRecoveryPlan" = "Get-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Get-ASRRecoveryPoint" = "Get-AzureRmRecoveryServicesAsrRecoveryPoint";
    "Get-ASRReplicationProtectedItem" = "Get-AzureRmRecoveryServicesAsrReplicationProtectedItem";
    "Get-ASRRP" = "Get-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Get-ASRServicesProvider" = "Get-AzureRmRecoveryServicesAsrServicesProvider";
    "Get-ASRStorageClassification" = "Get-AzureRmRecoveryServicesAsrStorageClassification";
    "Get-ASRStorageClassificationMapping" = "Get-AzureRmRecoveryServicesAsrStorageClassificationMapping";
    "Get-ASRvCenter" = "Get-AzureRmRecoveryServicesAsrvCenter";
    "Get-ASRVaultContext" = "Get-AzureRmRecoveryServicesAsrVaultContext";
    "Get-ASRVaultSettings" = "Get-AzureRmRecoveryServicesAsrVaultContext";
    "Get-AzureRmRecoveryServicesAsrNotificationSetting" = "Get-AzureRmRecoveryServicesAsrAlertSetting";
    "Get-AzureRmRecoveryServicesAsrVaultSettings" = "Get-AzureRmRecoveryServicesAsrVaultContext";
    "New-ASRFabric" = "New-AzureRmRecoveryServicesAsrFabric";
    "New-ASRNetworkMapping" = "New-AzureRmRecoveryServicesAsrNetworkMapping";
    "New-ASRPolicy" = "New-AzureRmRecoveryServicesAsrPolicy";
    "New-ASRProtectableItem" = "New-AzureRmRecoveryServicesAsrProtectableItem";
    "New-ASRProtectionContainerMapping" = "New-AzureRmRecoveryServicesAsrProtectionContainerMapping";
    "New-ASRRecoveryPlan" = "New-AzureRmRecoveryServicesAsrRecoveryPlan";
    "New-ASRReplicationProtectedItem" = "New-AzureRmRecoveryServicesAsrReplicationProtectedItem";
    "New-ASRRP" = "New-AzureRmRecoveryServicesAsrRecoveryPlan";
    "New-ASRStorageClassificationMapping" = "New-AzureRmRecoveryServicesAsrStorageClassificationMapping";
    "New-ASRvCenter" = "New-AzureRmRecoveryServicesAsrvCenter";
    "Remove-ASRFabric" = "Remove-AzureRmRecoveryServicesAsrFabric";
    "Remove-ASRNetworkMapping" = "Remove-AzureRmRecoveryServicesAsrNetworkMapping";
    "Remove-ASRPolicy" = "Remove-AzureRmRecoveryServicesAsrPolicy";
    "Remove-ASRProtectionContainerMapping" = "Remove-AzureRmRecoveryServicesAsrProtectionContainerMapping";
    "Remove-ASRRecoveryPlan" = "Remove-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Remove-ASRReplicationProtectedItem" = "Remove-AzureRmRecoveryServicesAsrReplicationProtectedItem";
    "Remove-ASRRP" = "Remove-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Remove-ASRServicesProvider" = "Remove-AzureRmRecoveryServicesAsrServicesProvider";
    "Remove-ASRStorageClassificationMapping" = "Remove-AzureRmRecoveryServicesAsrStorageClassificationMapping";
    "Remove-ASRvCenter" = "Remove-AzureRmRecoveryServicesAsrvCenter";
    "Restart-ASRJob" = "Restart-AzureRmRecoveryServicesAsrJob";
    "Resume-ASRJob" = "Resume-AzureRmRecoveryServicesAsrJob";
    "Set-ASRAlertSetting" = "Set-AzureRmRecoveryServicesAsrAlertSetting";
    "Set-ASRNotificationSetting" = "Set-AzureRmRecoveryServicesAsrAlertSetting";
    "Set-ASRReplicationProtectedItem" = "Set-AzureRmRecoveryServicesAsrReplicationProtectedItem";
    "Set-ASRVaultContext" = "Set-AzureRmRecoveryServicesAsrVaultContext";
    "Set-ASRVaultSettings" = "Set-AzureRmRecoveryServicesAsrVaultContext";
    "Set-AzureRmRecoveryServicesAsrNotificationSetting" = "Set-AzureRmRecoveryServicesAsrAlertSetting";
    "Set-AzureRmRecoveryServicesAsrVaultSettings" = "Set-AzureRmRecoveryServicesAsrVaultContext";
    "Start-ASRApplyRecoveryPoint" = "Start-AzureRmRecoveryServicesAsrApplyRecoveryPoint";
    "Start-ASRCommitFailover" = "Start-AzureRmRecoveryServicesAsrCommitFailoverJob";
    "Start-ASRCommitFailoverJob" = "Start-AzureRmRecoveryServicesAsrCommitFailoverJob";
    "Start-ASRFO" = "Start-AzureRmRecoveryServicesAsrUnplannedFailoverJob";
    "Start-ASRPFO" = "Start-AzureRmRecoveryServicesAsrPlannedFailoverJob";
    "Start-ASRPlannedFailoverJob" = "Start-AzureRmRecoveryServicesAsrPlannedFailoverJob";
    "Start-ASRResyncJob" = "Start-AzureRmRecoveryServicesAsrResynchronizeReplicationJob";
    "Start-ASRResynchronizeReplicationJob" = "Start-AzureRmRecoveryServicesAsrResynchronizeReplicationJob";
    "Start-ASRSwitchProcessServerJob" = "Start-AzureRmRecoveryServicesAsrSwitchProcessServerJob";
    "Start-ASRTestFailoverCleanupJob" = "Start-AzureRmRecoveryServicesAsrTestFailoverCleanupJob";
    "Start-ASRTestFailoverJob" = "Start-AzureRmRecoveryServicesAsrTestFailoverJob";
    "Start-ASRTFO" = "Start-AzureRmRecoveryServicesAsrTestFailoverJob";
    "Start-ASRUnplannedFailoverJob" = "Start-AzureRmRecoveryServicesAsrUnplannedFailoverJob";
    "Stop-ASRJob" = "Stop-AzureRmRecoveryServicesAsrJob";
    "Update-ASRPolicy" = "Update-AzureRmRecoveryServicesAsrPolicy";
    "Update-ASRProtectionDirection" = "Update-AzureRmRecoveryServicesAsrProtectionDirection";
    "Update-ASRRecoveryPlan" = "Update-AzureRmRecoveryServicesAsrRecoveryPlan";
    "Update-ASRServicesProvider" = "Update-AzureRmRecoveryServicesAsrServicesProvider";
    "Update-ASRvCenter" = "Update-AzureRmRecoveryServicesAsrvCenter";
}.GetEnumerator() | Select @{Name='Name'; Expression={$_.Key}}, @{Name='Value'; Expression={$_.Value}} | New-Alias -Description "AzureAlias"

# SIG # Begin signature block
# MIIkCQYJKoZIhvcNAQcCoIIj+jCCI/YCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA/YdRB7Ro6izl7
# Fk/7ouwph7dtaoX91OvyLvjcqYaEWaCCDYIwggYAMIID6KADAgECAhMzAAAAww6b
# p9iy3PcsAAAAAADDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTcwODExMjAyMDI0WhcNMTgwODExMjAyMDI0WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC7V9c40bEGf0ktqW2zY596urY6IVu0mK6N1KSBoMV1xSzvgkAqt4FTd/NjAQq8
# zjeEA0BDV4JLzu0ftv2AbcnCkV0Fx9xWWQDhDOtX3v3xuJAnv3VK/HWycli2xUib
# M2IF0ZWUpb85Iq2NEk1GYtoyGc6qIlxWSLFvRclndmJdMIijLyjFH1Aq2YbbGhEl
# gcL09Wcu53kd9eIcdfROzMf8578LgEcp/8/NabEMC2DrZ+aEG5tN/W1HOsfZwWFh
# 8pUSoQ0HrmMh2PSZHP94VYHupXnoIIJfCtq1UxlUAVcNh5GNwnzxVIaA4WLbgnM+
# Jl7wQBLSOdUmAw2FiDFfCguLAgMBAAGjggF/MIIBezAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUpxNdHyGJVegD7p4XNuryVIg1Ga8w
# UQYDVR0RBEowSKRGMEQxDDAKBgNVBAsTA0FPQzE0MDIGA1UEBRMrMjMwMDEyK2M4
# MDRiNWVhLTQ5YjQtNDIzOC04MzYyLWQ4NTFmYTIyNTRmYzAfBgNVHSMEGDAWgBRI
# bmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEt
# MDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAE2X
# TzR+8XCTnOPVGkucEX5rJsSlJPTfRNQkurNqCImZmssx53Cb/xQdsAc5f+QwOxMi
# 3g7IlWe7bn74fJWkkII3k6aD00kCwaytWe+Rt6dmAA6iTCXU3OddBwLKKDRlOzmD
# rZUqjsqg6Ag6HP4+e0BJlE2OVCUK5bHHCu5xN8abXjb1p0JE+7yHsA3ANdkmh1//
# Z+8odPeKMAQRimfMSzVgaiHnw40Hg16bq51xHykmCRHU9YLT0jYHKa7okm2QfwDJ
# qFvu0ARl+6EOV1PM8piJ858Vk8gGxGNSYQJPV0gc9ft1Esq1+fTCaV+7oZ0NaYMn
# 64M+HWsxw+4O8cSEQ4fuMZwGADJ8tyCKuQgj6lawGNSyvRXsN+1k02sVAiPGijOH
# OtGbtsCWWSygAVOEAV/ye8F6sOzU2FL2X3WBRFkWOCdTu1DzXnHf99dR3DHVGmM1
# Kpd+n2Y3X89VM++yyrwsI6pEHu77Z0i06ELDD4pRWKJGAmEmWhm/XJTpqEBw51sw
# THyA1FBnoqXuDus9tfHleR7h9VgZb7uJbXjiIFgl/+RIs+av8bJABBdGUNQMbJEU
# fe7K4vYm3hs7BGdRLg+kF/dC/z+RiTH4p7yz5TpS3Cozf0pkkWXYZRG222q3tGxS
# /L+LcRbELM5zmqDpXQjBRUWlKYbsATFtXnTGVjELMIIHejCCBWKgAwIBAgIKYQ6Q
# 0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5
# WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQD
# Ex9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4
# BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe
# 0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato
# 88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v
# ++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDst
# rjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN
# 91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4ji
# JV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmh
# D+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbi
# wZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8Hh
# hUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaI
# jAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTl
# UAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNV
# HQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQF
# TuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcC
# ARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnlj
# cHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5
# AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oal
# mOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0ep
# o/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1
# HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtY
# SWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInW
# H8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZ
# iWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMd
# YzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7f
# QccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKf
# enoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOpp
# O6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZO
# SEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCFd0wghXZAgEBMIGVMH4xCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jv
# c29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAADDDpun2LLc9ywAAAAAAMMw
# DQYJYIZIAWUDBAIBBQCggcwwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEICciNndN
# 0FtIa7x1+LcGLsIkCECUJCbNvJ1wzISU362+MGAGCisGAQQBgjcCAQwxUjBQoDaA
# NABNAGkAYwByAG8AcwBvAGYAdAAgAEEAegB1AHIAZQAgAFAAbwB3AGUAcgBTAGgA
# ZQBsAGyhFoAUaHR0cDovL0NvZGVTaWduSW5mbyAwDQYJKoZIhvcNAQEBBQAEggEA
# WV/xSXV9q0Z5pS2/5rLfEJzCNCDPZonjBh1zZZWWGPy1DhAmV5KuX7qv3hmJ1VTa
# 01ox/glghS/yHtZ1dHzCidtdb96Dqazw8KaUFT4CDGtE/N/DSGKU85ZUt6I0B4ar
# JXLCTdR8+WsdGRLbPBh4C85d9Mdr86yTBnvB1ledQgG8u9CQoYZD1GlJPoa/YzlW
# JoXyNuk+yx0jadv8gvxdbPkEfLcvshH/b0HI35em3fUxmTDm1AUGdfyNOQrWAmtl
# QGBCO26hx4dMkV+Oi3JGEDt3sZ4EUty6VxBiQ4bhZlMYgJqgmoyxOhDHOQ8X63Qr
# TYZ/CCOkRp2aaak0EsIrT6GCE0kwghNFBgorBgEEAYI3AwMBMYITNTCCEzEGCSqG
# SIb3DQEHAqCCEyIwghMeAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggE8BgsqhkiG9w0B
# CRABBKCCASsEggEnMIIBIwIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFlAwQCAQUA
# BCBA6nhhFMS7uW7UITHDX861kuvihFQbceci4nrrKPXg6AIGWdrdGaFyGBMyMDE3
# MTExMDA3MDk1NC41MzRaMAcCAQGAAgH0oIG4pIG1MIGyMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMQwwCgYDVQQLEwNBT0MxJzAlBgNVBAsTHm5D
# aXBoZXIgRFNFIEVTTjoxMkI0LTJENUYtODdENDElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaCCDs0wggZxMIIEWaADAgECAgphCYEqAAAAAAAC
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
# MIIDwaADAgECAhMzAAAAp2RdxSgPAT1EAAAAAACnMA0GCSqGSIb3DQEBCwUAMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2MDkwNzE3NTY1MloXDTE4
# MDkwNzE3NTY1MlowgbIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xDDAKBgNVBAsTA0FPQzEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNOOjEyQjQt
# MkQ1Ri04N0Q0MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApuoaUMBfT9JT+aHsBHwN
# 1yBXMSFR2MfuAwoueM6LLiIja5Y2EB8KUXqF510U/nOy19J8Y1XBCrjGlDTouInZ
# F5wJsRihkT9DVlVW2VvFT9aDfuToEIgbTHobkKLUtQLT0fi/m87/NWrVLo5Mk0Z6
# s31OUtAYEdjMl8xMlORyi1D86tJSCRA4gxG4lgMxOFxBjTophxFYE6MOrX2t3vrm
# bsrQuKFzbb61qaVnSWsHfHmItGY28jEnOBTiNR/BJ114yOIqMmtngUZTBdZ7QzVq
# RDDtuyHtN0l/skQJm9pZwCs+kvgOwCZLF4rvCNNU54wLj4qNUvageahPZgYyuYsq
# 8QIDAQABo4IBGzCCARcwHQYDVR0OBBYEFHwNSgt9+0//XhAsPXlvIE1CUIhdMB8G
# A1UdIwQYMBaAFNVjOlyKMZDzQ3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeG
# RWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Rp
# bVN0YVBDQV8yMDEwLTA3LTAxLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUH
# MAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljVGltU3Rh
# UENBXzIwMTAtMDctMDEuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwDQYJKoZIhvcNAQELBQADggEBAJrGJEvnl7JSAWSHD+JCkyhWeXb0+QoV
# Z016DomAPD8zQt6OcvJcpvN4s7mwhdKPJe3bir3hLH1WYAQSzyfzY3j4RlRUShba
# a+pcu/uGemxef01zYqA2nbDes+nPEmKM+vCcbCQMa4gukZe+304yjFxuJ4QneZud
# y9/o7BELAAlcei9qJfbS9joqh21HdsxVr0628dV6GrP5nB0ISCj9cf9eB5slQrCj
# +Av9YdJfunToYdXz4uBEvykN44rwbV2MWuLlDg2BB9ErjtJ5UJmtAaLLNQG6vgBC
# gyNxth1gh6qMW/577XCGDghxtVeFL5QQI220H7yjRrflFkuu8K62uk6hggN3MIIC
# XwIBATCB4qGBuKSBtTCBsjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEMMAoGA1UECxMDQU9DMScwJQYDVQQLEx5uQ2lwaGVyIERTRSBFU046MTJC
# NC0yRDVGLTg3RDQxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZp
# Y2WiJQoBATAJBgUrDgMCGgUAAxUA5IIunTI2bXQAMg8ewSG0DesMd9mggcEwgb6k
# gbswgbgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xDDAKBgNV
# BAsTA0FPQzEnMCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjI2NjUtNEMzRi1DNURF
# MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBTb3VyY2UgTWFzdGVyIENsb2NrMA0G
# CSqGSIb3DQEBBQUAAgUA3a9EjzAiGA8yMDE3MTEwOTIxMTgwN1oYDzIwMTcxMTEw
# MjExODA3WjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDdr0SPAgEAMAoCAQACAhcY
# AgH/MAcCAQACAhlyMAoCBQDdsJYPAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisG
# AQQBhFkKAwGgCjAIAgEAAgMW42ChCjAIAgEAAgMHoSAwDQYJKoZIhvcNAQEFBQAD
# ggEBAFCLhDhI6LbCmI3QiY2s+uvKd5t61IOEt2a1+ZdbBzdImu3JCdUZOvZyD2iM
# 1PDW0gruXxqQdBS9wTX9OlElT7/BM5ZIRzYyPzzl8JPK2OU9j+eBlAHndsHMeDEE
# 3RLkDtHuSkkE0kxmtIyPAaNiPExSy/6Wrb25rmai3SYsBQ9bnM8IrDTJQKZklgwk
# EVDdrJBVaDhgXbbDQXvJzIgMuNH4PwIr1b61Cr3I0+/lte9z/xJ3+fzk28Fyqm2a
# cPbWKi4bje3VLu5Klt3hSu5OV25sPoNV+XNzmxV3fZEyPq9s31nrdlEdnceBlUEo
# 3xrR3Jfu8v7LPIj6Vwi41qcQGe0xggL1MIIC8QIBATCBkzB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMAITMwAAAKdkXcUoDwE9RAAAAAAApzANBglghkgBZQME
# AgEFAKCCATIwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJ
# BDEiBCCcggfANYADgjCSrPmyWWkw19aE9SWS1qgzxwwNfYx1pzCB4gYLKoZIhvcN
# AQkQAgwxgdIwgc8wgcwwgbEEFOSCLp0yNm10ADIPHsEhtA3rDHfZMIGYMIGApH4w
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAACnZF3FKA8BPUQAAAAA
# AKcwFgQUltonDKRLDCjDlkuIWDpE7u9AyTYwDQYJKoZIhvcNAQELBQAEggEAmJcA
# J68pfl917TRfn6EyGaYvTpZfuVhKxW1KC8xRSnQS68ABJl/Fh2Er8BjJ3Jk/KxgB
# tllKnQBTQC/gAbYJFVb8O/MRZVaWDbcbiv08skCeZgPt8fM6FMj5ogWXFjiUDSFA
# SIJtPZ+HzYV2FMd47yyt8PHbBd0sqLvn/mYTTgLIYXzedcIigs5NWxgCQv2CFQrx
# btVdf6uMCskqsfR6ildqoW9FkG//A3R0t+eFu+Y4w4FtTv3JA0+dmWY/uDFkked/
# 34aAJF9q2o2fyYbxSXWx/N7qT+z3MeRhE+jD3MC/V1Oj8rVzboTeaJbh/XkQ59w7
# Dbd4u9picXPxAmsBOA==
# SIG # End signature block
