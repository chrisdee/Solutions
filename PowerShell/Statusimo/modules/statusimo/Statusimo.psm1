function Get-StatusimoData {
    [cmdletbinding()]
    param(
        [string] $FolderPath      
    )
    if ($FolderPath -ne '' -and (Test-Path -LiteralPath $FolderPath)) {
        $Files = Get-ChildItem -LiteralPath $FolderPath    
        foreach ($File in $Files) {       
            $Output = Get-Content -LiteralPath $File.FullName | ConvertFrom-Json      
            $TimeZoneBias = (Get-CimInstance -ClassName Win32_TimeZone).Bias
            $Output.PSObject.Properties | Where-Object {$_.Name -like 'Date*' } | ForEach-Object {
                if ($_.Value -is [DateTime]) {
                    $Output.($_.Name) = $_.Value.AddMinutes($TimeZoneBias)
                }
            }
            Add-Member -InputObject $Output -Name 'FullName' -Value $File.FullName -MemberType NoteProperty -Force
            $Output
        }
    } 
}
function New-StatusimoEvent {
    [alias('New-StatusimoIncident')]
    [cmdletbinding()]
    param(
        [DateTime] $Date = (Get-Date),
        [string] $Service,
        [ValidateSet('Operational', 'Partial Degradation', 'Down')][string] $Status,
        [string] $Title,
        [string] $Overview,
        [alias('IncidentsPath', 'EventsPath')][string] $FolderPath
    )
    $FileNameService = $Service -replace '[^a-zA-Z]', '_'
    $FileNameData = $Date.ToString("yyyy-MM-dd_HH_MM_ss")
    $FileNameEnd = Get-FileName -Extension 'json' -TemporaryFileOnly
    $FileName = $FileNameService + '_' + $FileNameData + '_' + $FileNameEnd
    $FilePath = [IO.Path]::Combine($FolderPath, $FileName)
    if ($Maintenance) {

    } else {
        $Incident = [ordered] @{
            Date     = $Date
            Service  = $Service
            Status   = $Status
            Title    = $Title
            Overview = $Overview
        }
        $Output = $Incident | ConvertTo-Json
        $Output | Set-Content -LiteralPath $FilePath
    }
}
function New-StatusimoMaintenance {
    [cmdletbinding()]
    param(
        [DateTime] $DateStart,
        [DateTime] $DateEnd,
        [string] $Service,
        [ValidateSet('Operational', 'Partial Degradation', 'Down')][string] $Status,
        [string] $Title,
        [string] $Overview,
        [string] $FolderPath
    )
    $FileNameService = $Service -replace '[^a-zA-Z]', '_'
    $FileNameData = $DateStart.ToString("yyyy-MM-dd_HH_MM_ss")
    $FileNameEnd = Get-FileName -Extension 'json' -TemporaryFileOnly
    $FileName = $FileNameService + '_' + $FileNameData + '_' + $FileNameEnd
    $FilePath = [IO.Path]::Combine($FolderPath, $FileName)

    $Maintenance = [ordered] @{
        DateStart = $DateStart
        DateEnd   = $DateEnd
        Service   = $Service
        Status    = $Status
        Title     = $Title
        Overview  = $Overview
    }
    $Output = $Maintenance | ConvertTo-Json
    $Output | Set-Content -LiteralPath $FilePath
    
}
function New-StatusimoPage {
    [cmdletbinding()]
    param(
        [string] $FilePath,
        [alias('Incident', 'Incidents', 'IncidentPath')][string] $IncidentsPath,
        [alias('Maintenance', 'MaintenancePath')][string] $MaintenancesPath,
        [int] $AutoRefresh
    )
    $DynamicHTML = New-HTML -TitleText 'Services Status' -UseCssLinks:$true -UseJavaScriptLinks:$true -AutoRefresh $AutoRefresh {

        $Today = Get-Date
        $Incidents = Get-StatusimoData -FolderPath $IncidentsPath | Sort-Object -Property Date, Title -Descending
        $Maintenances = Get-StatusimoData -FolderPath $MaintenancesPath | Sort-Object -Property DateEnd, DateStart, Title -Descending

        $IncidentTypes = $Incidents.Service | Sort-Object -Unique

        New-HTMLPanel -Invisible {
            $Statuses = foreach ($Type in $IncidentTypes) {
                $Incidents |  Where-Object { $_.Service -eq $Type  } | Select-Object -First 1 -ExpandProperty Status
            }
            if ($Statuses -notcontains 'Partial Degradation' -and $Statuses -notcontains 'Down') {
                New-HTMLToast -Icon Information -Color Blue -TextHeader 'Information' -Text 'Everything is running smoothly!'
            } else {
                New-HTMLToast -Icon Exclamation -Color Orange -TextHeader 'Warning' -Text "Some systems are affected. We're hard at work fixing."
            }
        }

        New-HTMLHeading -Heading h1 -HeadingText 'Current Status' -Type 'central' -Color Black

        New-HTMLPanel -Invisible {
            New-HTMLStatus {

                foreach ($Type in $IncidentTypes) {
                    $IncidentStatus = $Incidents | Where-Object { $_.Service -eq $Type  } | Select-Object -First 1
                    if ($IncidentStatus.Status -eq 'Operational') {
                        $Icon = 'Good'
                        $Percentage = '100%'
                    } elseif ($IncidentStatus.Status -eq 'Partial Degradation') {
                        $Icon = 'Bad'
                        $Percentage = '30%'
                    } elseif ($IncidentStatus.Status -eq 'Down') {
                        $Icon = 'Dead'
                        $Percentage = '0%'
                    }

                    New-HTMLStatusItem -ServiceName $IncidentStatus.Service -ServiceStatus $IncidentStatus.Status -Icon $Icon -Percentage $Percentage
                }
            }
        }

        New-HTMLHeading -Heading h1 -HeadingText 'Scheduled Maintenance' -Type 'central' -Color Black

        New-HTMLPanel -Invisible {
            foreach ($Maintenance in $Maintenances) {
                $Title = "$($Maintenance.Title) ($($Maintenance.DateStart) - $($Maintenance.DateEnd))"
                if ($Today -ge $Maintenance.DateStart -and $Today -le $Maintenance.DateEnd) {
                    New-HTMLToast -Icon Exclamation -Color Orange -TextHeader $Title -Text $Maintenance.Overview
                } elseif ($Today -le $Maintenance.DateStart) {
                    New-HTMLToast -Icon Information -Color Blue -TextHeader $Title -Text $Maintenance.Overview
                } else {
                    New-HTMLToast -Icon Success -Color Green -TextHeader $Title -Text $Maintenance.Overview
                }
            }
        }


        New-HTMLHeading -Heading h1 -HeadingText 'Incidents per day' -Type 'central' -Color Black

        New-HTMLPanel -Invisible {
            $Data = foreach ($Element in 30..0) {
                $Date = (Get-Date).AddDays(-$Element).Date
                $IncidentsPerDay = $Incidents | Where-Object { ($_.Status -eq 'Partial Degradation' -or $_.Status -eq 'Down') -and $_.Date.Date -eq $Date }
                Get-ObjectCount -Object $IncidentsPerDay
            }
            $DataName = "Incidents"
            $DataCategories = foreach ($Element in 30..0) {
                (Get-Date).AddDays(-$Element).ToShortDateString()
            }

            New-HTMLChart `
                -Data $Data `
                -DataNames $DataName `
                -DataCategories $DataCategories `
                -Type 'line' `
                -TitleText '' `
                -TitleAlignment 'left' `
                -LineColor 'Blue' -Horizontal $false -Positioning central
        }

        New-HTMLHeading -Heading h1 -HeadingText 'Timeline' -Type 'central' -Color Black

        New-HTMLPanel -Invisible {
            New-HTMLTimeline {
                foreach ($Incident in $Incidents) {
                    New-HTMLTimelineItem -HeadingText $Incident.Title -Text $Incident.Overview -Date $Incident.Date -Color Black
                }
            }
        }
    }
    [string] $DynamicHTMLPath = Save-HTML -HTML $DynamicHTML -FilePath $FilePath
}
function Remove-StatusimoMaintenance {
    [cmdletbinding()]
    param(
        [alias('Maintenance', 'MaintenancePath')][string] $MaintenancesPath,
        [int] $DaysOld
    )

    $DateOld = (Get-Date).AddDays($DaysOld)

    $Maintenances = Get-StatusimoData -FolderPath $MaintenancesPath |  Where-Object { $_.DateEnd -lt $DateOld }
    foreach ($Maintenance in $Maintenances) {
        Remove-Item -LiteralPath $Maintenance.FullName -Confirm:$false
    }
}


Export-ModuleMember `
    -Function @('New-StatusimoEvent','New-StatusimoMaintenance','New-StatusimoPage','Remove-StatusimoMaintenance') `
    -Alias @('New-StatusimoIncident')
