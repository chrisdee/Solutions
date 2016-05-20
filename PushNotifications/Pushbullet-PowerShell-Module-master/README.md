# Pushbullet-PowerShell-Module

This PowerShell module can be used to send notifications to any of your devices using the Pushbullet service. It includes three functions:

    Send-Pushbullet
    Get-PushbulletDevices
    Get-PushbulletContacts

It can be used as part of scripts to send notifications of events:

    PS> Import-Module .\Pushbullet.psm1
    PS> Send-Pushbullet -APIKey "XXXXXX" -Title "Process Report" -Message "There are $(Get-Process | Measure | Select -ExpandProperty Count) processes running."

Result:

![](sample.jpg)
