<#  

Statusimo:  PowerShell Generated Status Page (Incidents and Maintenance)

Resources:

https://github.com/EvotecIT/Statusimo

https://evotec.xyz/meet-statusimo-powershell-generated-status-page

#>

## Import Modules and Prepare StatusimoPage ##

$PSScriptRoot = "C:\BoxBuild\Scripts\Statusimo\reports"
$PSModulesRoot = "C:\BoxBuild\Scripts\Statusimo\modules"

## Create Incident directory if it does not exist
if( -Not (Test-Path -Path "$PSScriptRoot\Incident" ) )
{
    New-Item -ItemType directory -Path "$PSScriptRoot\Incident"
}

## Create Maintenance directory if it does not exist
if( -Not (Test-Path -Path "$PSScriptRoot\Maintenance" ) )
{
    New-Item -ItemType directory -Path "$PSScriptRoot\Maintenance"
}

cd "$PSModulesRoot\pswritecolor"

Import-Module .\PSWriteColor.psd1

cd "$PSModulesRoot\pssharedgoods"

Import-Module .\PSSharedGoods.psd1

cd "$PSModulesRoot\pswritehtml"

Import-Module .\PSWriteHTML.psd1

cd "$PSModulesRoot\statusimo"

Import-Module .\Statusimo.psd1

New-StatusimoPage -FilePath $PSScriptRoot\StatusPage.html -IncidentsPath $PSScriptRoot\Incident -MaintenancePath $PSScriptRoot\Maintenance

## Create New StatusimoIncident and newStatusimoMaintenance Examples

$newStatusimoIncidentSplat = @{
    Date       = (Get-Date)
    Overview   = "We're currently experiencing no issues. All services are available."
    Title      = 'Exchange Servers are Operational'
    Status     = 'Operational'
    Service    = 'Exchange'
    FolderPath = "$PSScriptRoot\Incident"
}
New-StatusimoEvent @newStatusimoIncidentSplat

$newStatusimoIncidentSplat = @{
    Date = (Get-Date).AddDays(-1)
    Overview = "We're currently experiencing issues with Active Directory. It may work slower than usual."
    Title = 'Active Directory controller is down'
    Status = 'Partial Degradation'
    Service = 'Active Directory'
    FolderPath = "$PSScriptRoot\Incident"
}
New-StatusimoEvent @newStatusimoIncidentSplat

$newStatusimoIncidentSplat = @{
    Date = (Get-Date).AddDays(-3)
    Overview = "We're currently experiencing issues with SharePoint. Web applications are down."
    Title = 'SharePoint is down'
    Status = 'down'
    Service = 'SharePoint'
    FolderPath = "$PSScriptRoot\Incident"
}
New-StatusimoEvent @newStatusimoIncidentSplat

$newStatusimoMaintenanceSplat = @{
    Title = 'Hyper-V scheduled maintenance'
    DateStart = (Get-Date).AddDays(5)
    DateEnd = (Get-Date).AddDays(6).AddHours(2)
    Service = 'Hyper-V'
    Overview = "Updating core infrastructure for Hyper-V. Servers may be affected."
    FolderPath = "$PSScriptRoot\Maintenance" 
}
New-StatusimoMaintenance @newStatusimoMaintenanceSplat 
