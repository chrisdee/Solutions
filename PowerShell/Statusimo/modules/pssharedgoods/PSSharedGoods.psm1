function Add-PropertyToList {
    [CmdletBinding()]
    param(
        $List,
        [ValidateSet("Password", "MailNickName")][string] $PropertyName
    )
    foreach ($Object in $List) {
        if ($PropertyName -eq 'Password') {
            $PropertyValue = Get-RandomPassword
            $Object | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue -Force
        }
        if ($PropertyName -eq 'MailNickName') {
            $PropertyValue = ($Object.UserPrincipalName).Split('@')[0]
            #$PropertyValue = $Split[0]
            $Object | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue -Force
        }
    }
    return $List
}
function Add-ToArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element
    )
    #Write-Verbose "Add-ToArray - Element: $Element"
    [void] $List.Add($Element) #> $null
}
function Add-ToArrayAdvanced {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $SkipNull,
        [switch] $RequireUnique,
        [switch] $FullComparison,
        [switch] $Merge
    )
    if ($SkipNull -and $Element -eq $null) {
        #Write-Verbose "Add-ToArrayAdvanced - SkipNull used"
        return
    }
    if ($RequireUnique) {
        if ($FullComparison) {
            foreach ($ListElement in $List) {
                if ($ListElement -eq $Element) {
                    $TypeLeft = Get-ObjectType -Object $ListElement
                    $TypeRight = Get-ObjectType -Object $Element
                    if ($TypeLeft.ObjectTypeName -eq $TypeRight.ObjectTypeName) {
                        #Write-Verbose "Add-ToArrayAdvanced - RequireUnique with full comparison used"
                        return
                    }
                }
            }
        } else {
            if ($List -contains $Element) {
                #Write-Verbose "Add-ToArrayAdvanced - RequireUnique on name used"
                return
            }
        }
    }
    #Write-Verbose "Add-ToArrayAdvanced - Adding ELEMENT: $Element"
    if ($Merge) {
        [void] $List.AddRange($Element) # > $null
    } else {
        [void] $List.Add($Element) # > $null
    }
}
function Add-ToHashTable($Hashtable, $Key, $Value) {
    if ($null -ne $Value -and $Value -ne '') {
        $Hashtable.Add($Key, $Value)
    }
}
<#
Output of Get-ADPrincipalGroupmembership:

distinguishedName : CN=Organization Management,OU=Microsoft Exchange Security Groups,DC=ad,DC=evotec,DC=xyz
GroupCategory     : Security
GroupScope        : Universal
name              : Organization Management
objectClass       : group
objectGUID        : 551c2400-f0d2-4aa6-8dbf-f9722ceb8675
SamAccountName    : Organization Management
SID               : S-1-5-21-853615985-2870445339-3163598659-1117

#>

function Add-WinADUserGroups {
    [CmdletBinding()]
    [alias("Add-ADUserGroups")]
    param(
        [parameter(Mandatory = $true)][Object] $User,
        [string[]] $Groups,
        [string] $FieldSearch = 'Name',
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $ADgroups = Get-ADPrincipalGroupMembership -Identity $User.DistinguishedName | Where-Object {$_.Name -ne "Domain Users" }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
    }
    if ($Groups) {
        foreach ($Group in $Groups) {
            if ($ADgroups.$FieldSearch -notcontains $Group) {
                try {
                    if (-not $WhatIf) {
                        Add-ADGroupMember -Identity $Group -Members $User.DistinguishedName -ErrorAction Stop
                    }
                    $Object += @{ Status = $true; Output = $Group; Extended = 'Added to group.' }

                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $Group; Extended = $ErrorMessage }
                }
            } else {
                # Turned off to not clutter view, may required turning back on.
                #$Object += @{ Status = $false; Output = $Group; Extended = 'Already exists.' }
            }
        }
    }
    return $Object
}
function Compare-ObjectsAdvanced {
    param(
        [object] $Object1,
        [object] $Object2,
        [alias('Property')][string] $CommonProperty = 'DistinguishedName',
        [string[]] $AddObjectArrayName,
        [object[]] $AddObjectArray,
        [string] $Object1Property,
        [string] $Object2Property,
        [string] $ObjectPropertySubstitute = 'SpecialValueToCompare',
        [switch] $RemoveSideIndicator,
        [switch] $KeepTemporaryProperty,
        [ValidateSet('Left', 'Right')][string] $Side = 'Left' # May need Both later on
    )
    $Objects = New-GenericList

    if ($null -eq $Object1 -and $null -eq $Object2) {
        # nothing to do, doesn't event need check for distribution groups because it should be empty as well.
    } elseif ($null -eq $Object1) {
        # nothing to do
    } elseif ($null -eq $Object2) {
        foreach ($G in $Object1) {
            #Add-Member -InputObject $G -MemberType NoteProperty -Name 'OrganizationalUnit' -Value $OrganizationalUnit -Force
            #

            for ($a = 0; $a -lt $AddObjectArrayName.Count; $a++) {
                $G | Add-Member -MemberType NoteProperty -Name $AddObjectArrayName[$a] -Value $AddObjectArray[$a] -Force
                
            }
            $Objects.Add($G)
        }
    } else {
        $Terminate = New-GenericList -Type [bool]

        if ($Object1Property -and $Object2Property) {                
            if ($Object1[0].PSObject.Properties.Name -notcontains $Object1Property) {
                Write-Warning -Message "Compare-InfrastructureObjects - Object1 property doesn't exists $Object1Property"
                $Terminate.Add($true)
            }
            if ($Object2[0].PSObject.Properties.Name -notcontains $Object2Property) {
                Write-Warning -Message "Compare-InfrastructureObjects - Object2 property doesn't exists $Object2Property"
                $Terminate.Add($true)
            }
            if ($Terminate -contains $true) {
                return
            }
            $Object1 | Add-Member -MemberType AliasProperty -Name $ObjectPropertySubstitute -Value $Object1Property -Force
            $Object2 | Add-Member -MemberType AliasProperty -Name $ObjectPropertySubstitute -Value $Object2Property -Force
            $Compare = Compare-Object -ReferenceObject $Object1 -DifferenceObject $Object2 -Property  $ObjectPropertySubstitute -PassThru
        } else {
            if ($Object1[0].PSObject.Properties.Name -notcontains $CommonProperty) {
                Write-Warning -Message "Compare-InfrastructureObjects - Object1 property doesn't exists $CommonProperty"
                $Terminate.Add($true)
            }
            if ($Object2[0].PSObject.Properties.Name -notcontains $CommonProperty) {
                Write-Warning -Message "Compare-InfrastructureObjects - Object2 property doesn't exists $CommonProperty"
                $Terminate.Add($true)
            }
            if ($Terminate -contains $true) {
                return
            }
            $Compare = Compare-Object -ReferenceObject $Object1 -DifferenceObject $Object2 -Property $CommonProperty -PassThru
        }
        if ($Side -eq 'Left') {
            $Compare = $Compare | Where-Object { $_.SideIndicator -eq '<=' }
        } elseif ($Side -eq 'Right') {
            $Compare = $Compare | Where-Object { $_.SideIndicator -eq '=>' }
        } else {
            # left just in case Equal is needed
            $Compare = $Compare | Where-Object { $_.SideIndicator -eq '==' }
        }
        foreach ($G in $Compare) {
            if ($RemoveSideIndicator) {
                $G.PSObject.Members.Remove('SideIndicator')
            }
            if (-not $KeepTemporaryProperty) {
                $G.PSObject.Members.Remove($ObjectPropertySubstitute)
            }
            for ($a = 0; $a -lt $AddObjectArrayName.Count; $a++) {
                $G | Add-Member -MemberType NoteProperty -Name $AddObjectArrayName[$a] -Value $AddObjectArray[$a] -Force
            }
            $Objects.Add($G) 
        }
    }  
    return $Objects
}
Function Compare-ObjectProperties {
    Param(
        [PSObject]$ReferenceObject,
        [PSObject]$DifferenceObject
    )
    $objprops = $ReferenceObject | Get-Member -MemberType Property, NoteProperty | % Name
    $objprops += $DifferenceObject | Get-Member -MemberType Property, NoteProperty | % Name
    $objprops = $objprops | Sort | Select -Unique
    $diffs = @()
    foreach ($objprop in $objprops) {
        $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop
        if ($diff) {
            $diffprops = @{
                PropertyName = $objprop
                RefValue     = ($diff | ? {$_.SideIndicator -eq '<='} | % $($objprop))
                DiffValue    = ($diff | ? {$_.SideIndicator -eq '=>'} | % $($objprop))
            }
            $diffs += New-Object PSObject -Property $diffprops
        }
    }
    if ($diffs) {return ($diffs | Select PropertyName, RefValue, DiffValue)}
}
<#
https://blogs.technet.microsoft.com/janesays/2017/04/25/compare-all-properties-of-two-objects-in-windows-powershell/

$ad1 = Get-ADUser amelia.mitchell -Properties *
$ad2 = Get-ADUser carolyn.quinn -Properties *
Compare-ObjectProperties $ad1 $ad2
#>
function Connect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure MSOL',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output #, [System.Collections.IDictionary] $Credentials
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinAzure - Running connectivity without MFA"
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    try {
        # If it's mfa $Credentials will be $null so it will ask with a prompt
        Connect-MsolService -Credential $Credentials -ErrorAction Stop
        $Connected = $true
    } catch {
        $Connected = $false
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinAzure - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Connected -eq $false) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    } else {
        if ($Output) {
            return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
        } else {
            return
        }
    }
}
function Connect-WinAzureAD {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure AD',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinAzureAD - Running connectivity without MFA"
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    try {
           # If it's mfa $Credentials will be $null so it will ask with a prompt
        $Session = Connect-AzureAD -Credential $Credentials -ErrorAction Stop
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinAzureAD - Failed with error message: $ErrorMessage"
            return
        }
    }
    if (-not $Session) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}
function Connect-WinExchange {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Exchange',
        [string] $ConnectionURI,
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Kerberos',
        [alias('UserPrincipalName')][string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [string] $Prefix,
        [switch] $Output
    )
    $Object = @()
    if ($MultiFactorAuthentication) {
        Write-Verbose 'Connect-WinExchange - Using MFA option'
        try {
            Import-Module -ErrorAction Stop $((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | Where-Object { $_ -notmatch "_none_" } | select -First 1)
        } catch {
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed. Couldn't find Exchange Online module to load." }
                return $Object
            } else {
                Write-Warning -Message "Connect-WinExchange - Connection failed. Couldn't find Exchange Online module to load."
                return
            }
        }
    } else {
        Write-Verbose 'Connect-WinExchange - Using Non-MFA option'
        if ($Authentication -ne 'Kerberos') {
            $Credentials = Request-Credentials -UserName $Username `
                -Password $Password `
                -AsSecure:$AsSecure `
                -FromFile:$FromFile `
                -Service $SessionName `
                -Output

            if ($Credentials -isnot [PSCredential]) {
                if ($Output) {
                    return $Credentials
                } else {
                    return
                }
            }
        } else {
            # Credentials should be null for Kerberos - Current user will run it
            $Credentials = $null
        }
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($UsedSession in $ExistingSession) {
            if ($UsedSession.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose -Message "Connect-WinExchange - reusing session $($Session.ComputerName)"
                }
                $Session = $UsedSession
                break
            }
        }
    } else {
        if ($MultiFactorAuthentication) {
            Write-Verbose -Message "Connect-WinExchange - Establishing MFA Connection"
            $PSSessionOption = New-PSSessionOption -ProxyAccessType IEConfig
            try {
                $Session = New-ExoPSSession -UserPrincipalName $UserName -PSSessionOption $PSSessionOption
                $Session.Name = $SessionName
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning -Message "Connect-WinExchange - Failed with error message: $ErrorMessage"
                    return
                }
            }
        } else {
            Write-Verbose -Message "Connect-WinExchange - Creating Session to URI: $ConnectionURI"
            $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck -Verbose:$false
            try {
                if ($Credentials) {
                    Write-Verbose 'Connect-WinExchange - Creating new session using Credentials'
                    $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -ErrorAction Stop -Verbose:$false
                } else {
                    Write-Verbose 'Connect-WinExchange - Creating new session without Credentials'
                    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -Verbose:$false -ErrorAction Stop
                }
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning "Connect-WinExchange - Failed with error message: $ErrorMessage"
                    return
                }
            }
        }
    }


    # Failed connecting to session
    if (-not $Session) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection failed.' }
            return $Object
        } else {
            return
        }
    }


    $CurrentVerbosePreference = $VerbosePreference; $VerbosePreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    $CurrentWarningPreference = $WarningPreference; $WarningPreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    if ($Prefix) {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global -Prefix $Prefix
    } else {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)MailContact", "Get-$($Prefix)Mailbox"
    if ($CheckAvailabilityCommands -contains $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Commands unavailable.' }
            return $Object
        } else {
            return
        }
    }

    if ($Output) {
        if ($Prefix) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: $Prefix" }
        } else {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: n/a" }
        }
        return $Object
    } else {
        if ($Prefix) {
            Write-Verbose -Message "Connect-WinExchange - Connection established $($Session.ComputerName) - prefix: $Prefix"
        } else {
            Write-Verbose -Message "Connect-WinExchange - Connection established $($Session.ComputerName) - prefix: n/a"
        }
    }
    return $Object
}
function Connect-WinSecurityCompliance {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Security and Compliance',
        [string] $ConnectionURI,
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Basic',
        [alias('UserPrincipalName')][string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [string] $Prefix,
        [switch] $Output
    )
    $Object = @()
    if ($MultiFactorAuthentication) {
        Write-Verbose 'Connect-WinSecurityCompliance - Using MFA option'
        try {
            Import-Module $((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | ? { $_ -notmatch "_none_" } | select -First 1)
        } catch {
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed. Couldn't find Exchange Online module to load." }
                return $Object
            } else {
                Write-Warning -Message "Connect-WinSecurityCompliance - Connection failed. Couldn't find Exchange Online module to load."
                return
            }
        }
    } else {
        Write-Verbose 'Connect-WinSecurityCompliance - Using Non-MFA option'
        if ($Authentication -ne 'Kerberos') {
            $Credentials = Request-Credentials -UserName $Username `
                -Password $Password `
                -AsSecure:$AsSecure `
                -FromFile:$FromFile `
                -Service $SessionName `
                -Output

            if ($Credentials -isnot [PSCredential]) {
                if ($Output) {
                    return $Credentials
                } else {
                    return
                }
            }
        } else {
            # Credentials should be null for Kerberos - Current user will run it
            $Credentials = $null
        }
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($UsedSession in $ExistingSession) {
            if ($UsedSession.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose -Message "Connect-WinSecurityCompliance - reusing session $($Session.ComputerName)"
                }
                $Session = $UsedSession
                break
            }
        }
    } else {
        if ($MultiFactorAuthentication) {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Establishing MFA Connection"
            $PSSessionOption = New-PSSessionOption -ProxyAccessType IEConfig
            try {
                $Session = New-ExoPSSession -UserPrincipalName $UserName -PSSessionOption $PSSessionOption
                $Session.Name = $SessionName
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning -Message "Connect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                    return
                }
            }
        } else {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Creating Session to URI: $ConnectionURI"
            $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck -Verbose:$false
            try {
                if ($Credentials) {
                    Write-Verbose 'Connect-WinSecurityCompliance - Creating new session using Credentials'
                    $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -ErrorAction Stop -Verbose:$false
                } else {
                    Write-Verbose 'Connect-WinSecurityCompliance - Creating new session without Credentials'
                    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection -Verbose:$false -ErrorAction Stop
                }
            } catch {
                $Session = $null
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($Output) {
                    $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                    return $Object
                } else {
                    Write-Warning "Connect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                    return
                }
            }
        }
    }


    # Failed connecting to session
    if (-not $Session) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection failed.' }
            return $Object
        } else {
            return
        }
    }


    $CurrentVerbosePreference = $VerbosePreference; $VerbosePreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    $CurrentWarningPreference = $WarningPreference; $WarningPreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    if ($Prefix) {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global -Prefix $Prefix
    } else {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)ProtectionAlert"
    if ($CheckAvailabilityCommands -contains $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Commands unavailable.' }
            return $Object
        } else {
            return
        }
    }

    if ($Output) {
        if ($Prefix) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: $Prefix" }
        } else {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: n/a" }
        }
        return $Object
    } else {
        if ($Prefix) {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Connection established $($Session.ComputerName) - prefix: $Prefix"
        } else {
            Write-Verbose -Message "Connect-WinSecurityCompliance - Connection established $($Session.ComputerName) - prefix: n/a"
        }
    }
    return $Object
}
function Connect-WinService {
    [CmdletBinding()]
    param (
        [Object] $Credentials,
        [Object] $Service,
        [string] $Type,
        [switch] $Output
    )
    $Object = @()
    if ($Service.Use) {
        switch ($Type) {
            'ActiveDirectory' {
                # Prepare Data AD
                $CheckAvailabilityCommandsAD = Test-AvailabilityCommands -Commands 'Get-ADForest', 'Get-ADDomain', 'Get-ADRootDSE', 'Get-ADGroup', 'Get-ADUser', 'Get-ADComputer'
                if ($CheckAvailabilityCommandsAD -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Commands unavailable.' }
                        return $Object
                    } else {
                        Write-Warning "Active Directory documentation can't be started as commands are unavailable. Check if you have Active Directory module available (part of RSAT) and try again."
                        return
                    }
                } else {
                    #if ($Output) {
                    #    $Object += @{ Status = $true; Output = 'ActiveDirectory'; Extended = 'Commands available.' }
                    #}
                }
                if (-not (Test-ForestConnectivity)) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'No connectivity to forest/domain.' }
                        return $Object
                    } else {
                        Write-Warning 'Active Directory - No connectivity to forest/domain.'
                        return
                    }
                } else {
                    #if ($Output) {
                    #$Object += @{ Status = $true; Output = 'ActiveDirectory'; Extended = 'Connectivity to forest/domain available.' }
                    #}
                }
                if ($Output) {
                    $Object += @{ Status = $true; Output = $Service.SessionName; Extended = 'Connection Established.' }
                    return $Object
                }
            }
            'Azure' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }

                $OutputCommand = Connect-WinAzure -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Output
                return $OutputCommand
            }
            'AzureAD' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $OutputCommand = Connect-WinAzureAD -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Output
                return $OutputCommand
            }
            'Exchange' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Document.DocumentExchange.Configuration -AllowEmptyKeys 'Username', 'Password'
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $OutputCommand = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand
            }
            'ExchangeOnline' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $OutputCommand = Connect-WinExchange -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand

            }
            'SecurityCompliance' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $OutputCommand = Connect-WinSecurityCompliance -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand

            }
            'SharePointOnline' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $OutputCommand = Connect-WinSharePoint -SessionName $Service.SessionName `
                    -ConnectionURI $Service.ConnectionURI `
                    -Authentication $Service.Authentication `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand

            }
            'SkypeOnline' {
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                # Build Session
                $OutputCommand = Connect-WinSkype -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Prefix $Service.Prefix `
                    -Output
                return $OutputCommand

            }
            'MicrosoftTeams' {
                # Check Credentials
                $CheckCredentials = Test-ConfigurationCredentials -Configuration $Credentials
                if ($CheckCredentials.Status -contains $false) {
                    if ($Output) {
                        $Object += @{ Status = $false; Output = $Service.SessionName; Extended = 'Credentials configuration is wrong.' }
                        return $Object
                    } else {
                        return
                    }
                }
                $OutputCommand = Connect-WinTeams -SessionName $Service.SessionName `
                    -Username $Credentials.Username `
                    -Password $Credentials.Password `
                    -AsSecure:$Credentials.PasswordAsSecure `
                    -FromFile:$Credentials.PasswordFromFile `
                    -MultiFactorAuthentication:$Credentials.MultiFactorAuthentication `
                    -Output
                return $OutputCommand
            }
        }

    }
}
function Connect-WinSharePoint {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft SharePoint',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [alias('uri', 'url', 'ConnectionUrl')][Uri] $ConnectionURI,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    try {
        # If it's mfa $Credentials will be $null so it will ask with a prompt
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        $Session = Connect-SPOService -Url $ConnectionURI -Credential $Credentials
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinSharePoint - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}
function Connect-WinSkype {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft Skype',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinSkype - Running connectivity without MFA"
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -contains 'Available') {
        foreach ($UsedSession in $ExistingSession) {
            if ($UsedSession.Availability -eq 'Available') {
                if ($Output) {
                    $Object += @{ Status = $true; Output = $SessionName; Extended = "Will reuse established session to $($Session.ComputerName)" }
                } else {
                    Write-Verbose -Message "Connect-WinSkype - reusing session $($Session.ComputerName)"
                }
                $Session = $UsedSession
                break
            }
        }
    } else {
        try {
            if ($MultiFactorAuthentication) {
                $Session = New-CsOnlineSession -UserName $Username -ErrorAction Stop
            } else {
                $Session = New-CsOnlineSession -Credential $Credentials -ErrorAction Stop
            }
            $Session.Name = $SessionName
        } catch {
            $Session = $null
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
                return $Object
            } else {
                Write-Warning -Message "Connect-WinSkype - Failed with error message: $ErrorMessage"
                return
            }
        }
    }
    # Failed connecting to session
    if (-not $Session) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Connection failed.' }
            return $Object
        } else {
            return
        }
    }


    $CurrentVerbosePreference = $VerbosePreference; $VerbosePreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    $CurrentWarningPreference = $WarningPreference; $WarningPreference = 'SilentlyContinue' # weird but -Verbose:$false doesn't do anything
    if ($Prefix) {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Prefix $Prefix -Verbose:$false) -Global -Prefix $Prefix
    } else {
        Import-Module (Import-PSSession -Session $Session -AllowClobber -DisableNameChecking -Verbose:$false) -Global
    }
    $VerbosePreference = $CurrentVerbosePreference
    $WarningPreference = $CurrentWarningPreference

    ## Verify Connectivity
    #$CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Service.Prefix)ExchangeServer", "Get-$($Service.Prefix)MailboxDatabase", "Get-$($Service.Prefix)PublicFolderDatabase"
    $CheckAvailabilityCommands = Test-AvailabilityCommands -Commands "Get-$($Prefix)CsExternalAccessPolicy"
    if ($CheckAvailabilityCommands -contains $false) {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = 'Commands unavailable.' }
            return $Object
        } else {
            return
        }
    }

    if ($Output) {
        if ($Prefix) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: $Prefix" }
        } else {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Connection established $($Session.ComputerName) - prefix: n/a" }
        }
        return $Object
    } else {
        if ($Prefix) {
            Write-Verbose -Message "Connect-WinSkype - Connection established $($Session.ComputerName) - prefix: $Prefix"
        } else {
            Write-Verbose -Message "Connect-WinSkype - Connection established $($Session.ComputerName) - prefix: n/a"
        }
    }
    return $Object
}
function Connect-WinTeams {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft Teams',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    try {
        # If it's mfa $Credentials will be $null so it will ask with a prompt
        $Session = Connect-MicrosoftTeams -Credential $Credentials -ErrorAction Stop
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinTeams - Failed with error message: $ErrorMessage"
            return
        }
    }
    if (-not $Session) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}
function Convert-BinaryToHex {
    param(
        [alias('Bin')]
	[Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
	[Byte[]]$Binary
    )
    if ($null -eq $Binary) {
        return
    }
    # assume pipeline input if we don't have an array (surely there must be a better way)
    if ($Binary.Length -eq 1) {
        $Binary = @($input)
    }
    $Return = -join ($Binary |  foreach { "{0:X2}" -f $_ })
    Write-Output $Return
}
function Convert-BinaryToString {
    param(
        [alias('Bin')]
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
        [Byte[]]$Binary
    )
    if ($null -ne $Binary) {
        return [System.Text.Encoding]::Unicode.GetString($Binary)
    }
}
function Convert-Color {
    <#
    .Synopsis
    This color converter gives you the hexadecimal values of your RGB colors and vice versa (RGB to HEX)
    .Description
    This color converter gives you the hexadecimal values of your RGB colors and vice versa (RGB to HEX). Use it to convert your colors and prepare your graphics and HTML web pages.
    .Parameter RBG
    Enter the Red Green Blue value comma separated. Red: 51 Green: 51 Blue: 204 for example needs to be entered as 51,51,204
    .Parameter HEX
    Enter the Hex value to be converted. Do not use the '#' symbol. (Ex: 3333CC converts to Red: 51 Green: 51 Blue: 204)
    .Example
    .\convert-color -hex FFFFFF
    Converts hex value FFFFFF to RGB

    .Example
    .\convert-color -RGB 123,200,255
    Converts Red = 123 Green = 200 Blue = 255 to Hex value

    #>
    param(
        [Parameter(ParameterSetName = "RGB", Position = 0)]
        [ValidateScript( {$_ -match '^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$'})]
        $RGB,
        [Parameter(ParameterSetName = "HEX", Position = 0)]
        [ValidateScript( {$_ -match '[A-Fa-f0-9]{6}'})]
        [string]
        $HEX
    )
    switch ($PsCmdlet.ParameterSetName) {
        "RGB" {
            if ($RGB[2] -eq $null) {
                Write-error "Value missing. Please enter all three values seperated by comma."
            }
            $red = [convert]::Tostring($RGB[0], 16)
            $green = [convert]::Tostring($RGB[1], 16)
            $blue = [convert]::Tostring($RGB[2], 16)
            if ($red.Length -eq 1) {
                $red = '0' + $red
            }
            if ($green.Length -eq 1) {
                $green = '0' + $green
            }
            if ($blue.Length -eq 1) {
                $blue = '0' + $blue
            }
            Write-Output $red$green$blue
        }
        "HEX" {
            $red = $HEX.Remove(2, 4)
            $Green = $HEX.Remove(4, 2)
            $Green = $Green.remove(0, 2)
            $Blue = $hex.Remove(0, 4)
            $Red = [convert]::ToInt32($red, 16)
            $Green = [convert]::ToInt32($green, 16)
            $Blue = [convert]::ToInt32($blue, 16)
            Write-Output $red, $Green, $blue
        }
    }
}
function Convert-ExchangeEmail {
    <#
    .SYNOPSIS
    Function that helps converting Exchange email address list into readable, exportable format.
    
    .DESCRIPTION
        Function that helps converting Exchange email address list into readable, exportable format.
    
    .PARAMETER Emails
    List of emails as available in Exchange or Exchange Online, otherwise known as proxy addresses list
    
    .PARAMETER Separator
    
    .PARAMETER RemoveDuplicates
    
    .PARAMETER RemovePrefix
    
    .PARAMETER AddSeparator
    
    .EXAMPLE
    
    $Emails = @()
    $Emails += 'SIP:test@email.com'
    $Emails += 'SMTP:elo@maiu.com'
    $Emails += 'sip:elo@maiu.com'
    $Emails += 'Spo:dfte@sdsd.com'
    $Emails += 'SPO:myothertest@sco.com'

    Convert-ExchangeEmail -Emails $Emails -RemovePrefix -RemoveDuplicates -AddSeparator
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param(
        [string[]] $Emails,
        [string] $Separator = ', ',
        [switch] $RemoveDuplicates,
        [switch] $RemovePrefix,
        [switch] $AddSeparator
    )

    if ($RemovePrefix) {
        #$Emails = $Emails.Replace('SMTP:', '').Replace('SIP:', '').Replace('smtp:', '').Replace('sip:', '').Replace('spo:','')
        $Emails = $Emails -replace 'smtp:', '' -replace 'sip:', '' -replace 'spo:', ''
    }
    if ($RemoveDuplicates) {
        $Emails = $Emails | Sort-Object -Unique
    }
    if ($AddSeparator) {
        $Emails = $Emails -join $Separator
    }
    return $Emails
}
function Convert-ExchangeItems {
    [cmdletbinding()]
    param(
        $Count,
        [string] $Default = 'N/A'
    )
    if ($null -eq $Count) {
        return $Default
    } else {
        return $Count
    }
}
function Convert-ExchangeRecipientDetails {
    [cmdletbinding()]
    param(
        [string] $RecipientType,
        [switch] $FromKey
    ) 
    $RecipientTypeDetails = @{
        UserMailbox            = 1
        LinkedMailbox          = 2
        SharedMailbox          = 4 
        RoomMailbox            = 16
        EquipmentMailbox       = 32
        MailUser               = 128
        RemoteUserMailbox      = 2147483648
        RemoteRoomMailbox      = 8589934592
        RemoteEquipmentMailbox = 17179869184
        RemoteSharedMailbox    = 34359738368
    }

    $RecipientTypeDetails.GetEnumerator() | Where-Object { $_.Value -eq $RecipientType }
}

<#
Convert-ExchangeSize -To MB -Size '49 GB (52,613,349,376 bytes)'
Convert-ExchangeSize -To GB -Size '49 GB (52,613,349,376 bytes)'
#>
function Convert-ExchangeSize {
    [cmdletbinding()]
    param(
        [validateset("Bytes", "KB", "MB", "GB", "TB")][string]$To = 'MB',
        [string]$Size,
        [int]$Precision = 4,
        [switch]$Display,
        [string]$Default = 'N/A'
    )
    if ([string]::IsNullOrWhiteSpace($Size)) {
        return $Default
    }
    $Pattern = [Regex]::new('(?<=\()([0-9]*[,.].*[0-9])')  # (?<=\()([0-9]*.*[0-9]) works too
    $Value = ($Size | Select-String $Pattern -AllMatches).Matches.Value
    Write-Verbose "Convert-ExchangeSize - Value Before: $Value"

    if ($null -ne $Value) {
        $Value = $Value.Replace(',', '').Replace('.', '')
    }

    switch ($To) {
        "Bytes" {return $value}
        "KB" {$Value = $Value / 1KB}
        "MB" {$Value = $Value / 1MB}
        "GB" {$Value = $Value / 1GB}
        "TB" {$Value = $Value / 1TB}

    }
    Write-Verbose "Convert-ExchangeSize - Value After: $Value"
    if ($Display) {
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $To"
    } else {
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }

}
function ConvertFrom-Color {
    [alias('Convert-FromColor')]
    [CmdletBinding()]
    param (
        [alias('Colors')][RGBColors[]] $Color,
        [switch] $AsDecimal
    )
    $Colors = foreach ($C in $Color) {
        $Value = $Script:RGBColors."$C"
        $HexValue = Convert-Color -RGB $Value
        Write-Verbose "Convert-FromColor - Color Name: $C Value: $Value HexValue: $HexValue"
        <#
    [string] $HexVal = ''
    foreach ($arg in $Value) {
        $hexval = $hexval + [Convert]::ToString($arg, 16).ToUpper()
    }
    #>
        if ($AsDecimal) {
            [Convert]::ToInt64($HexValue, 16)
        } else {
            "#$($HexValue)"
        }
    }
    $Colors
}
#
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/making-error-records-more-readable

function ConvertFrom-ErrorRecord
{
  param
  (
    # we receive either a legit error record...
    [Management.Automation.ErrorRecord[]]
    [Parameter(
        Mandatory,ValueFromPipeline,
        ParameterSetName='ErrorRecord')]
    $ErrorRecord,

    # ...or a special stop exception which is raised by
    # cmdlets with -ErrorAction Stop
    [Management.Automation.ActionPreferenceStopException[]]
    [Parameter(
        Mandatory,ValueFromPipeline,
        ParameterSetName='StopException')]
    $Exception
  )



  process
  {
    # if we received a stop exception in $Exception,
    # the error record is to be found inside of it
    # in all other cases, $ErrorRecord was received
    # directly
    if ($PSCmdlet.ParameterSetName -eq 'StopException')
    {
      $ErrorRecord = $Exception.ErrorRecord
    }

    # compose a new object out of the interesting properties
    # found in the error record object
    $ErrorRecord | ForEach-Object { [PSCustomObject]@{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
    }
  }
}
Function ConvertFrom-OperationType {
    param (
        [string] $OperationType
    )
    $Known = @{
        '%%14674' = 'Value Added'
        '%%14675' = 'Value Deleted'
        '%%14676' = 'Unknown'
    }
    foreach ($id in $OperationType) {
        if ($name = $Known[$id]) { return $name }
    }
    return $OperationType
}
function ConvertFrom-SID ($Sid) {
    $KnownSIDs = @{
        'S-1-0' = 'Null Authority'
        'S-1-0-0' = 'Nobody'
        'S-1-1' = 'World Authority'
        'S-1-1-0' = 'Everyone'
        'S-1-2' = 'Local Authority'
        'S-1-2-0' = 'Local'
        'S-1-2-1' = 'Console Logon'
        'S-1-3' = 'Creator Authority'
        'S-1-3-0' = 'Creator Owner'
        'S-1-3-1' = 'Creator Group'
        'S-1-3-2' = 'Creator Owner Server'
        'S-1-3-3' = 'Creator Group Server'
        'S-1-3-4' = 'Owner Rights'
        'S-1-5-80-0' = 'All Services'
        'S-1-4' = 'Non-unique Authority'
        'S-1-5' = 'NT Authority'
        'S-1-5-1' = 'Dialup'
        'S-1-5-2' = 'Network'
        'S-1-5-3' = 'Batch'
        'S-1-5-4' = 'Interactive'
        'S-1-5-6' = 'Service'
        'S-1-5-7' = 'Anonymous'
        'S-1-5-8' = 'Proxy'
        'S-1-5-9' = 'Enterprise Domain Controllers'
        'S-1-5-10' = 'Principal Self'
        'S-1-5-11' = 'Authenticated Users'
        'S-1-5-12' = 'Restricted Code'
        'S-1-5-13' = 'Terminal Server Users'
        'S-1-5-14' = 'Remote Interactive Logon'
        'S-1-5-15' = 'This Organization'
        'S-1-5-17' = 'This Organization'
        'S-1-5-18' = 'Local System'
        'S-1-5-19' = 'NT Authority'
        'S-1-5-20' = 'NT Authority'
        'S-1-5-32-544' = 'Administrators'
        'S-1-5-32-545' = 'Users'
        'S-1-5-32-546' = 'Guests'
        'S-1-5-32-547' = 'Power Users'
        'S-1-5-32-548' = 'Account Operators'
        'S-1-5-32-549' = 'Server Operators'
        'S-1-5-32-550' = 'Print Operators'
        'S-1-5-32-551' = 'Backup Operators'
        'S-1-5-32-552' = 'Replicators'
        'S-1-5-64-10' = 'NTLM Authentication'
        'S-1-5-64-14' = 'SChannel Authentication'
        'S-1-5-64-21' = 'Digest Authority'
        'S-1-5-80' = 'NT Service'
        'S-1-5-83-0' = 'NT VIRTUAL MACHINE\Virtual Machines'
        'S-1-16-0' = 'Untrusted Mandatory Level'
        'S-1-16-4096' = 'Low Mandatory Level'
        'S-1-16-8192' = 'Medium Mandatory Level'
        'S-1-16-8448' = 'Medium Plus Mandatory Level'
        'S-1-16-12288' = 'High Mandatory Level'
        'S-1-16-16384' = 'System Mandatory Level'
        'S-1-16-20480' = 'Protected Process Mandatory Level'
        'S-1-16-28672' = 'Secure Process Mandatory Level'
        'S-1-5-32-554' = 'BUILTIN\Pre-Windows 2000 Compatible Access'
        'S-1-5-32-555' = 'BUILTIN\Remote Desktop Users'
        'S-1-5-32-556' = 'BUILTIN\Network Configuration Operators'
        'S-1-5-32-557' = 'BUILTIN\Incoming Forest Trust Builders'
        'S-1-5-32-558' = 'BUILTIN\Performance Monitor Users'
        'S-1-5-32-559' = 'BUILTIN\Performance Log Users'
        'S-1-5-32-560' = 'BUILTIN\Windows Authorization Access Group'
        'S-1-5-32-561' = 'BUILTIN\Terminal Server License Servers'
        'S-1-5-32-562' = 'BUILTIN\Distributed COM Users'
        'S-1-5-32-569' = 'BUILTIN\Cryptographic Operators'
        'S-1-5-32-573' = 'BUILTIN\Event Log Readers'
        'S-1-5-32-574' = 'BUILTIN\Certificate Service DCOM Access'
        'S-1-5-32-575' = 'BUILTIN\RDS Remote Access Servers'
        'S-1-5-32-576' = 'BUILTIN\RDS Endpoint Servers'
        'S-1-5-32-577' = 'BUILTIN\RDS Management Servers'
        'S-1-5-32-578' = 'BUILTIN\Hyper-V Administrators'
        'S-1-5-32-579' = 'BUILTIN\Access Control Assistance Operators'
        'S-1-5-32-580' = 'BUILTIN\Remote Management Users'
    }
    foreach ($id in $sid) {
        if ($name = $KnownSIDs[$id]) { }
        else {
            #Try to translate the SID to an account
            Try {
                $objSID = New-Object System.Security.Principal.SecurityIdentifier($id)
                $name = ( $objSID.Translate([System.Security.Principal.NTAccount]) ).Value
            } Catch {
                $name = $sid # returns sid if unable to name
            }
        }
        return @{ SID = $id
            Name = $name
        }

    }

}
function ConvertFrom-X500Address {
    <#
    .EXAMPLE
    By default returns string without @evotec.pl in the end. This is because the string from NDR needs domain name removed to be able to add it back to Exchange
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'

    .EXAMPLE
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full
    #>
    param(
        [string] $IMCEAEXString,
        [switch] $Full
    )
    $Final = $IMCEAEXString.Replace("IMCEAEX-", "").Replace("_", "/").Replace("+20", " ").Replace("+28", "(").Replace("+29", ")").Replace("+2E", ".").Replace("+2C", ",").Replace("+5F", "_")
    if ($Full) {
        return $Final
    } else {
        return ($Final -split '@')[0]
    }
}
function Convert-HexToBinary {
	[CmdletBinding()]
	param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] [string] $Hex
    )
	$return = @()

	for ($i = 0; $i -lt $Hex.Length ; $i += 2)
	{
		$return += [Byte]::Parse($Hex.Substring($i, 2), [System.Globalization.NumberStyles]::HexNumber)
	}

	Write-Output $return
}
function Convert-KeyToKeyValue {
    [CmdletBinding()]
    param (
        [object] $Object
    )
    $NewHash = [ordered] @{}
    foreach ($O in $Object.Keys) {
        $KeyName = "$O ($($Object.$O))"
        $KeyValue = $Object.$O
        $NewHash.$KeyName = $KeyValue
    }
    return $NewHash
}
function Convert-Office365License {
    <#
    .SYNOPSIS
    This function helps converting Office 365 licenses from/to their SKU equivalent
    
    .DESCRIPTION
        This function helps converting Office 365 licenses from/to their SKU equivalent
    
    .PARAMETER License
    License SKU or License Name. Takes multiple values.
    
    .PARAMETER ToSku
    Converts license name to SKU

    .PARAMETER Separator
    
    .PARAMETER ReturnArray
  
    .EXAMPLE
    Convert-Office365License -License 'VISIOCLIENT','PROJECTONLINE_PLAN_1','test','tenant:VISIOCLIENT'

    .EXAMPLE
    Convert-Office365License -License "Office 365 (Plan A3) for Faculty","Office 365 (Enterprise Preview)", 'test' -ToSku
    #>
  
    [CmdletBinding()]
    param(
        [string[]] $License,
        [alias('SKU')][switch] $ToSku,
        [string] $Separator = ', ',
        [switch] $ReturnArray
    )
    if (-not $ToSku) {
        $ConvertedLicenses = foreach ($L in $License) {
            # Remove tenant from SKU
            if ($L -match ':') {
                $Split = $L -split ':'
                $L = $Split[-1]
            }
            
            $Conversion = $Script:O365SKU[$L]
            if ($null -eq $Conversion) {
                $L
            } else {
                $Conversion
            }
        }
    } else {
        $ConvertedLicenses = foreach ($L in $License) {
            $Conversion = $Script:O365SKU.GetEnumerator() | Where-Object {$_.Value -eq $L }
            if ($null -eq $Conversion) {
                $L
            } else {
                $Conversion.Name
            }
        }
    }
    if ($ReturnArray) {
        return $ConvertedLicenses
    } else {
        return $ConvertedLicenses -join ', '
    }
}
function Convert-Size {
    # Original - https://techibee.com/powershell/convert-from-any-to-any-bytes-kb-mb-gb-tb-using-powershell/2376
    #
    # Changelog - Modified 30.03.2018 - przemyslaw.klys at evotec.pl
    # - Added $Display Switch
    [cmdletbinding()]
    param(
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]$From,
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]$To,
        [Parameter(Mandatory = $true)]
        [double]$Value,
        [int]$Precision = 4,
        [switch]$Display
    )
    switch ($From) {
        "Bytes" {$value = $Value }
        "KB" {$value = $Value * 1024 }
        "MB" {$value = $Value * 1024 * 1024}
        "GB" {$value = $Value * 1024 * 1024 * 1024}
        "TB" {$value = $Value * 1024 * 1024 * 1024 * 1024}
    }

    switch ($To) {
        "Bytes" {return $value}
        "KB" {$Value = $Value / 1KB}
        "MB" {$Value = $Value / 1MB}
        "GB" {$Value = $Value / 1GB}
        "TB" {$Value = $Value / 1TB}

    }
    if ($Display) {
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $To"
    } else {
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }

}
function Convert-TimeToDays {
    [CmdletBinding()]
    param (
        $StartTime,
        $EndTime,
        #[nullable[DateTime]] $StartTime,
        #[nullable[DateTime]] $EndTime,
        [string] $Ignore = '*1601*'
    )
    <# Due to some use of string as StartTime in some code temporary using this version.
    Get-ObjectType -Object $StartTime -VerboseOnly -Verbose
    Get-ObjectType -Object $EndTime -VerboseOnly -Verbose
    #>
    if ($StartTime -and $EndTime) {
        try {
            if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
                $Days = (NEW-TIMESPAN -Start (GET-DATE) -End ($EndTime)).Days
            } else {
                $Days = $null
            }
        } catch {
            $Days = $null
        }
    }
    return $Days
}
function Convert-ToDateTime {
    [CmdletBinding()]
    param (
        [string] $Timestring,
        [string] $Ignore = '*1601*'
    )
    Try {
        $DateTime = ([datetime]::FromFileTime($Timestring))
    } catch {
        $DateTime = $null
    }
    #Write-Verbose "Convert-ToDateTime: $DateTime"
    if ($null -eq $DateTime -or $DateTime -like $Ignore) {
        return $null
    } else {
        return $DateTime
    }
}
function ConvertTo-ImmutableID {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'User')]
        [alias('ADuser')]
        [Microsoft.ActiveDirectory.Management.ADAccount] $User,

        [Parameter(Mandatory = $false, ParameterSetName = 'Guid')]
        [alias('GUID')]
        [string] $ObjectGUID
    )
    if ($User) {
        if ($User.ObjectGUID) {
            $ObjectGUID = $User.ObjectGuid
        }
    }
    if ($ObjectGUID) {
        $ImmutableID = [System.Convert]::ToBase64String(($User.ObjectGUID).ToByteArray())
        return $ImmutableID
    }
    return
}
function Convert-ToTimeSpan {
    [CmdletBinding()]
    param (
        [DateTime] $StartTime = (Get-Date),
        [DateTime] $EndTime
    )
    if ($StartTime -and $EndTime) {
        try {
            $TimeSpan = (NEW-TIMESPAN -Start $StartTime -End $EndTime)
        } catch {
            $TimeSpan = $null
        }
    }
    if ($null -ne $TimeSpan) {
        return $TimeSpan
    } else {
        return $null
    }
}
## This methods converts 2 Arrays into 1 Array
## Administrators  + 0 = Administrators (0)
function Convert-TwoArraysIntoOne {
    [CmdletBinding()]
    param (
        $Object,
        $ObjectToAdd
    )

    $Value = @()
    for ($i = 0; $i -lt $Object.Count; $i++) {
        $Value += "$($Object[$i]) ($($ObjectToAdd[$i]))"
    }
    return $Value
}
Function Convert-UAC {
    <#
    .SYNOPSIS
        Converts values from Events into proper format

    .DESCRIPTION
        Converts values from Events into proper format

    .PARAMETER UAC
        Parameter description

    .EXAMPLE
        Convert-UAC -UAC '%%1793'
        Convert-UAC -UAC '1793'
        Output: TEMP_DUPLICATE_ACCOUNT, NORMAL_ACCOUNT, RESERVED

        Convert-UAC -UAC '1793', '1794'

        Convert-UAC -UAC '121793'
        Output: PASSWD_CANT_CHANGE, ENCRYPTED_TEXT_PWD_ALLOWED, TEMP_DUPLICATE_ACCOUNT, NORMAL_ACCOUNT, INTERDOMAIN_TRUST_ACCOUNT, WORKSTATION_TRUST_ACCOUNT, RESERVED, RESERVED, DONT_EXPIRE_PASSWORD

        Convert-UAC -UAC 'C:\Onet33'
        Output: Same input as output

        Convert-UAC -UAC '121793' -OutputPerLine
        Output: One entry per line
            PASSWD_CANT_CHANGE
            ENCRYPTED_TEXT_PWD_ALLOWED
            TEMP_DUPLICATE_ACCOUNT
            NORMAL_ACCOUNT
            INTERDOMAIN_TRUST_ACCOUNT
            WORKSTATION_TRUST_ACCOUNT
            RESERVED
            RESERVED
            DONT_EXPIRE_PASSWORD

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $UAC,
        [string] $Separator
    )
    $Output = foreach ($String in $UAC) {
        $NumberAsString = $String.Replace('%', '') -as [int]
        if ($null -eq $NumberAsString) {
            return $UAC
        }

        $PropertyFlags = @(
            "SCRIPT",
            "ACCOUNTDISABLE",
            "RESERVED",
            "HOMEDIR_REQUIRED",
            "LOCKOUT",
            "PASSWD_NOTREQD",
            "PASSWD_CANT_CHANGE",
            "ENCRYPTED_TEXT_PWD_ALLOWED",
            "TEMP_DUPLICATE_ACCOUNT",
            "NORMAL_ACCOUNT",
            "RESERVED",
            "INTERDOMAIN_TRUST_ACCOUNT",
            "WORKSTATION_TRUST_ACCOUNT",
            "SERVER_TRUST_ACCOUNT",
            "RESERVED",
            "RESERVED",
            "DONT_EXPIRE_PASSWORD",
            "MNS_LOGON_ACCOUNT",
            "SMARTCARD_REQUIRED",
            "TRUSTED_FOR_DELEGATION",
            "NOT_DELEGATED",
            "USE_DES_KEY_ONLY",
            "DONT_REQ_PREAUTH",
            "PASSWORD_EXPIRED",
            "TRUSTED_TO_AUTH_FOR_DELEGATION",
            "RESERVED",
            "PARTIAL_SECRETS_ACCOUNT"
            "RESERVED"
            "RESERVED"
            "RESERVED"
            "RESERVED"
            "RESERVED"
        )
        1..($PropertyFlags.Length) | Where-Object { $NumberAsString -bAnd [math]::Pow(2, $_)} | ForEach-Object {$PropertyFlags[$_]}
    }
    if ($Separator -eq '') {
        $Output
    } else {
        $Output -join $Separator
    }
}
function Disconnect-WinSkype {
    [CmdletBinding()]
    param(
        [string] $SessionName = "Microsoft Skype",
        [switch] $Output
    )
    $Object = @()
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession) {
        try {
            Remove-PSSession -Name $SessionName -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
                return $Object
            } else {
                Write-Warning "Disconnect-WinSkype - Failed with error message: $ErrorMessage"
                return
            }
        }
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
            return $Object
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
            return $Object
        }
    }

}
function Disconnect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure MSOL',
        [switch] $Output,
        [switch] $Force
    )
    $Object = @()
    if (-not $Force) {
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "No way to do this. Kill PowerShell session manually." }
            return $Object
        } else {
            Write-Warning "Disconnect-WinAzure - There is no other way to disconnect from $Session then killing PowerShell session. Do this manually!"
            return
        }
    } else {
        Exit
    }
}
function Disconnect-WinAzureAD {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure AD',
        [switch] $Output
    )
    $Object = @()
    try {
        Disconnect-AzureAD -ErrorAction Stop
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($ErrorMessage -like "*Object reference not set to an instance of an object.*") {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
        } else {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
        }
        if ($Output) {
            return $Object
        } else {
            Write-Warning "Disconnect-WinAzureAD - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Output) {
        $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
        return $Object
    }
}
function Disconnect-WinExchange {
    [CmdletBinding()]
    param(
        [string] $SessionName = "Exchange",
        [switch] $Output
    )
    $Object = @()
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession) {
        try {
            Remove-PSSession -Name $SessionName -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
                return $Object
            } else {
                Write-Warning "Disconnect-WinExchange - Failed with error message: $ErrorMessage"
                return
            }
        }
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
            return $Object
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
            return $Object
        }
    }

}
function Disconnect-WinSecurityCompliance {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Security and Compliance',
        [switch] $Output
    )
    $Object = @()
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession) {
        try {
            Remove-PSSession -Name $SessionName -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
                return $Object
            } else {
                Write-Warning "Disconnect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                return
            }
        }
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
            return $Object
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
            return $Object
        }
    }

}
function Disconnect-WinService {
    [CmdletBinding()]
    param(

    )
    Get-PSSession | Remove-PSSession
}
function Disconnect-WinTeams {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft Teams',
        [switch] $Output
    )
    $Object = @()
    try {
        Disconnect-MicrosoftTeams -ErrorAction Stop
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($ErrorMessage -like "*Object reference not set to an instance of an object.*") {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
        } else {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
        }
        if ($Output) {
            return $Object
        } else {
            Write-Warning "Disconnect-MicrosoftTeams - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Output) {
        $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
        return $Object
    }
}
function Find-ADConnectServer {
    [alias('Find-ADSyncServer')]
    param(

    )
    $Description = Get-ADUser -Filter { Name -like "MSOL*" } -Properties Description | Select-Object Description -ExpandProperty Description

    foreach ($Desc in $Description) {
        $PatternType = "(?<=(Account created by ))(.*)(?=(with installation identifier))"
        $PatternServerName = "(?<=(on computer ))(.*)(?=(configured))"
        $PatternTenantName = "(?<=(to tenant ))(.*)(?=(. This))"
        $PatternInstallationID = "(?<=(installation identifier ))(.*)(?=( running on ))"
        if ($Desc -match $PatternServerName) {
            $ServerName = ($Matches[0]).Replace("'", '').Replace(' ', '')

            if ($Desc -match $PatternTenantName) {
                $TenantName = ($Matches[0]).Replace("'", '').Replace(' ', '')
            } else {
                $TenantName = ''
            }
            if ($Desc -match $PatternInstallationID) {
                $InstallationID = ($Matches[0]).Replace("'", '').Replace(' ', '')
            } else {
                $InstallationID = ''
            }
            if ($Desc -match $PatternType) {
                $Type = ($Matches[0]).Replace("'", '').Replace('by ', '').Replace('the ', '')
            } else {
                $Type = ''
            }


            $Data = Get-ADComputer -Identity $ServerName
            [PSCustomObject] @{
                Name              = $Data.Name
                FQDN              = $Data.DNSHostName
                DistinguishedName = $Data.DistinguishedName
                Type              = $Type
                TenantName        = $TenantName
                InstallatioNID    = $InstallationID 
            }
        }
    }
}
function Find-DatesCurrentDayMinusDayX ($days) {
    $DateTodayStart = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays( - $Days)
    $DateTodayEnd = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(1).AddDays( - $Days).AddMilliseconds(-1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}
function Find-DatesCurrentDayMinuxDaysX ($days) {
    $DateTodayStart = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays( - $Days)
    $DateTodayEnd = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(1).AddMilliseconds(-1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}
function Find-DatesCurrentHour () {
    $DateTodayStart = (Get-Date -Minute 0 -Second 0 -Millisecond 0)
    $DateTodayEnd = $DateTodayStart.AddHours(1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}
function Find-DatesDayPrevious () {
    $DateToday = (GET-DATE).Date
    $DateYesterday = $DateToday.AddDays(-1)

    $DateParameters = @{
        DateFrom = $DateYesterday
        DateTo   = $dateToday
    }
    return $DateParameters
}
function Find-DatesDayToday () {
    $DateToday = (GET-DATE).Date
    $DateTodayEnd = $DateToday.AddDays(1).AddSeconds(-1)

    $DateParameters = @{
        DateFrom = $DateToday
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}
function Find-DatesMonthCurrent () {
    $DateMonthFirstDay = (GET-DATE -Day 1).Date
    $DateMonthLastDay = GET-DATE $DateMonthFirstDay.AddMonths(1).AddSeconds(-1)

    $DateParameters = @{
        DateFrom = $DateMonthFirstDay
        DateTo   = $DateMonthLastDay
    }
    return $DateParameters
}
function Find-DatesMonthPast ([bool] $Force) {
    $DateToday = (Get-Date).Date
    $DateMonthFirstDay = (GET-DATE -Day 1).Date
    $DateMonthPreviousFirstDay = $DateMonthFirstDay.AddMonths(-1)

    if ($Force -eq $true -or $DateToday -eq $DateMonthFirstDay) {
        $DateParameters = @{
            DateFrom = $DateMonthPreviousFirstDay
            DateTo   = $DateMonthFirstDay
        }
        return $DateParameters
    } else {
        return $null
    }
}
function Find-DatesPastHour () {
    $DateTodayEnd = Get-Date -Minute 0 -Second 0 -Millisecond 0
    $DateTodayStart = $DateTodayEnd.AddHours(-1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}
function Find-DatesPastWeek($DayName) {
    $DateTodayStart = Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0
    if ($DateTodayStart.DayOfWeek -ne $DayName) {
        return $null
    }
    $DateTodayEnd = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(-7)
    $DateParameters = @{
        DateFrom = $DateTodayEnd
        DateTo   = $DateTodayStart
    }
    return $DateParameters

}
function Find-DatesQuarterCurrent ([bool] $Force) {
    $Today = (Get-Date)
    $Quarter = [Math]::Ceiling($Today.Month / 3)
    $LastDay = [DateTime]::DaysInMonth([Int]$Today.Year.ToString(), [Int]($Quarter * 3))
    $StartDate = (get-date -Year $Today.Year -Month ($Quarter * 3 - 2) -Day 1).Date
    $EndDate = (get-date -Year $Today.Year -Month ($Quarter * 3) -Day $LastDay).Date.AddDays(1).AddTicks(-1)
    $DateParameters = @{
        DateFrom = $StartDate
        DateTo   = $EndDate
    }
    return $DateParameters
}
function Find-DatesQuarterLast ([bool] $Force) {
    #https://blogs.technet.microsoft.com/dsheehan/2017/09/21/use-powershell-to-determine-the-first-day-of-the-current-calendar-quarter/
    $Today = (Get-Date).AddDays(-90)
    $Yesterday = ((Get-Date).AddDays(-1))
    $Quarter = [Math]::Ceiling($Today.Month / 3)
    $LastDay = [DateTime]::DaysInMonth([Int]$Today.Year.ToString(), [Int]($Quarter * 3))
    $StartDate = (get-date -Year $Today.Year -Month ($Quarter * 3 - 2) -Day 1).Date
    $EndDate = (get-date -Year $Today.Year -Month ($Quarter * 3) -Day $LastDay).Date.AddDays(1).AddTicks(-1)

    if ($Force -eq $true -or $Yesterday.Date -eq $EndDate.Date) {
        $DateParameters = @{
            DateFrom = $StartDate
            DateTo   = $EndDate
        }
        return $DateParameters
    } else {
        return $null
    }
}
function Find-ExchangeServer {
    <#
    .SYNOPSIS
    Find Exchange Servers in Active Directory
    
    .DESCRIPTION
    Find Exchange Servers in Active Directory
    
    .EXAMPLE
    Find-ExchangeServer

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(

    )
    $ExchangeServers = Get-ADGroup -Identity "Exchange Servers" | Get-ADGroupMember | Where-Object { $_.objectClass -eq 'computer' }
    foreach ($Server in $ExchangeServers) {
        $Data = Get-ADComputer -Identity $Server.SamAccountName -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName
        [PSCustomObject] @{
            Name              = $Data.Name
            FQDN              = $Data.DNSHostName
            OperatingSystem   = $Data.OperatingSystem
            DistinguishedName = $Data.DistinguishedName
            Enabled           = $Data.Enabled
        }
    }
}
function Find-HyperVServer {            
    [cmdletbinding()]            
    param()            
    try {            
        $ADObjects = Get-ADObject -Filter 'ObjectClass -eq "serviceConnectionPoint" -and Name -eq "Microsoft Hyper-V"' -ErrorAction Stop            
    } catch {            
        Write-Error "Error: $_"            
    }            
    foreach ($Server in $ADObjects) {            
        $Temporary = $Server.DistinguishedName.split(",")            
        $DistinguishedName = $Temporary[1..$Temporary.Count] -join ","        
        $Data = Get-ADComputer -Identity $DistinguishedName -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName       
        [PSCustomObject] @{
            Name              = $Data.Name
            FQDN              = $Data.DNSHostName
            OperatingSystem   = $Data.OperatingSystem
            DistinguishedName = $Data.DistinguishedName
            Enabled           = $Data.Enabled
        }
    }      
}
function Find-MyProgramData {
    [CmdletBinding()]
    param (
        $Data,
        $FindText
    )
    foreach ($Sub in $Data) {
        if ($Sub -like $FindText) {
            $Split = $Sub.Split(' ')
            return $Split[1]
        }
    }
    return ''
}

function Find-ServerTypes {
    [cmdletbinding()]
    param(
        [string[]][ValidateSet('All', 'ADConnect', 'DomainController', 'Exchange', 'Hyper-V', 'RDSLicense', 'SQL', 'VirtualMachine')] $Type = 'All'
    )
    $Forest = Get-ADForest

    foreach ($Domain in $Forest.Domains) {
        try {
            $DomainInformation = Get-ADDomain -Server $Domain -ErrorAction Stop
        } catch {
            Write-Warning "Find-ServerTypes - Domain $Domain couldn't be reached. Skipping"
            continue
        }

        try {
            $ServiceConnectionPoint = Get-ADObject -Filter 'ObjectClass -eq "serviceConnectionPoint"' -ErrorAction Stop -Server $Domain
            foreach ($Point in $ServiceConnectionPoint) {  
                $Temporary = $Point.DistinguishedName.split(",")            
                $DistinguishedName = $Temporary[1..$Temporary.Count] -join ","    
                $Point | Add-Member -MemberType 'NoteProperty' -Name 'DN' -Value $DistinguishedName -Force
            }
        } catch {
            Write-Error "Find-ServerTypes - Get-ADObject command failed. Terminating. Error $_"
            return
        }

        $ADConnect = Find-ADConnectServer
        $Computers = Get-ADComputer -Filter * -Properties Name, DNSHostName, OperatingSystem, DistinguishedName, ServicePrincipalName -Server $Domain
        $Servers = foreach ($Computer in $Computers) {
            $Services = foreach ($Service in $Computer.servicePrincipalName) {
                ($Service -split '/')[0]
            }
            [PSCustomObject] @{
                Name                   = $Computer.Name
                FQDN                   = $Computer.DNSHostName
                OperatingSystem        = $Computer.OperatingSystem
                DistinguishedName      = $Computer.DistinguishedName
                Enabled                = $Computer.Enabled
                IsExchange             = if ($Services -like '*ExchangeMDB*' -or $Services -like '*ExchangeRFR*') { $true } else { $false }
                IsSql                  = if ($Services -like '*MSSql*') { $true } else { $false }
                IsVM                   = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'Windows Virtual Machine') { $true } else { $false } 
                IsHyperV               = if ($Services -like '*Hyper-V Replica*') { $true } else { $false }
                IsSPHyperV             = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'Microsoft Hyper-V') { $true } else { $false } 
                IsRDSLicense           = if ($ServiceConnectionPoint.DN -eq $Computer.DistinguishedName -and $ServiceConnectionPoint.Name -eq 'TermServLicensing') { $true } else { $false } 
                #IsDC                   = if ($Services -like '*ldap*' -and $Services -like '*DNS*') { $true } else { $false }
                IsDC                   = if ($DomainInformation.ReplicaDirectoryServers -contains $Computer.DNSHostName) { $true } else { $false }  
                IsADConnect            = if ($ADConnect.FQDN -eq $Computer.DNSHostName) { $true } else { $false }
                Forest                 = $Forest.Name
                Domain                 = $Domain
                ServicePrincipalName   = ($Services | Sort-Object -Unique) -Join ','
                ServiceConnectionPoint = ($ServiceConnectionPoint | Where-Object { $_.DN -eq $Computer.DistinguishedName }).Name -join ','
            }
        }
        if ($Type -eq 'All') {
            $Servers
        } else {
            if ($Type -contains 'SQL') {
                $Servers | Where-Object { $_.IsSql -eq $true }
            }
            if ($Type -contains 'Exchange' ) {
                $Servers | Where-Object { $_.IsExchange -eq $true } 
            }
            if ($Type -contains 'Hyper-V') {
                $Servers | Where-Object { $_.IsHyperV -eq $true -or $_.IsSPHyperV -eq $true } 
            }
            if ($Type -contains 'VirtualMachine') {
                $Servers | Where-Object { $_.IsVM -eq $true } 
            }
            if ($Type -contains 'RDSLicense') {
                $Servers | Where-Object { $_.IsRDSLicense -eq $true } 
            }
            if ($Type -contains 'DomainController') {
                $Servers | Where-Object { $_.IsDC -eq $true } 
            }
            if ($Type -contains 'DomainController') {
                $Servers | Where-Object { $_.IsDC -eq $true } 
            }
            if ($Type -contains 'ADConnect') {
                $Servers | Where-Object { $_.IsADConnect -eq $true } 
            }
        }
    }
}
function Find-TypesNeeded {
    [CmdletBinding()]
    param (
        $TypesRequired,
        $TypesNeeded
    )
    $AllTypes = @()
    foreach ($Type in $TypesNeeded) {
        if ($TypesRequired -contains $Type) {
            $AllTypes += $True
        } else {
            $AllTypes += $False
        }
    }
    if ($AllTypes -contains $True) {
        return $True
    } else {
        return $False
    }
}
# not sure why I have it, or where it's used. Need to find out
function Find-UsersProxyAddressesStatus {
    param(
        $User
    )
    $status = 'No proxy'
    if ($user.proxyAddresses -ne $null) {
        $count = 0
        foreach ($proxy in $($user.ProxyAddresses)) {
            if ($proxy.SubString(0, 4) -ceq 'SMTP') { $count++ }
        }
        if ($count -eq 0) {
            $status = 'Missing primary proxy'
        } elseif ($count -gt 1) {
            $status = 'Multiple primary proxy'
        } else {
            $status = 'All OK'
        }
    } else {
        $status = 'Missing all proxy'
    }
    return $status
}
function Format-AddSpaceToSentence {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Text
    Parameter description

    .EXAMPLE


    $test = @(
        'OnceUponATime',
        'OnceUponATime1',
        'Money@Risk',
        'OnceUponATime123',
        'AHappyMan2014'
        'OnceUponATime_123'
    )

    Format-AddSpaceToSentence -Text $Test

    $Test | Format-AddSpaceToSentence -ToLowerCase

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)][string[]] $Text,
        [switch] $ToLowerCase
    )
    Begin {}
    Process {
        $Value = foreach ($T in $Text) {
            ($T -creplace '([A-Z\W_]|\d+)(?<![a-z])', ' $&').trim()
        }
        if ($ToLowerCase) {
            $Value.ToLower()
        } else {
            $Value
        }
    }
    End {

    }
}
function Format-FirstXChars {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Text
    Parameter description

    .PARAMETER NumberChars
    Parameter description

    .EXAMPLE
    Format-FirstChars -Text "VERBOSE: Loading module from path 'C:\Users\pklys\.vscode\extensions\ms-vs" -NumberChars 15

    .NOTES
    General notes
    #>

    param(
        [string] $Text,
        [int] $NumberChars
    )
    return ($Text.ToCharArray() | Select-Object -First $NumberChars) -join ''
}
function Format-PSTable {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object,
        [switch] $SkipTitle,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders,
        [ref] $StringLenghts
    )
   
    [int] $Type = 0   
    if ($Object -is [Array]) {
        if ($Object[0].GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {  
            $Type = 0
        } elseif ($Object[0] -is [System.Collections.IDictionary]) {
            $Type = 1
        } else {
            $Type = 2
        }
    } else {
        if ($Object.GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {  
            $Type = 0
        } elseif ($Object -is [System.Collections.IDictionary]) {
            $Type = 1
        } else {
            $Type = 2
        }
    }
    if ($Type -eq 0) {
        return $Object
    } elseif ($Type -eq 1) {
        return Format-PSTableConvertID -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -Property $Property
    } else {
        return Format-PSTableConvertCO -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -PreScanHeaders:$PreScanHeaders `
            -Property $Property
    }
}
function Format-PSTableConvertCO {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders
    )
    if ($Property) {
        $Object = $Object | Select-Object -Property $Property
    }
    $Array = [System.Collections.ArrayList]::new()
    $Titles = [System.Collections.ArrayList]::new()

    if ($NoAliasOrScriptProperties) {$PropertyType = 'AliasProperty', 'ScriptProperty'  } else {$PropertyType = ''}

    # Get Titles first (to make sure order is correct for all rows)
    if ($PreScanHeaders) {
        $ObjectProperties = Get-ObjectProperties -Object $Object
        foreach ($Name in $ObjectProperties) {
            $null = $Titles.Add($Name)
        }
    } else {
        if ($OverwriteHeaders) {
            $Titles = $OverwriteHeaders
        } else {
            foreach ($O in $Object) {
                if ($DisplayPropertySet -and $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames) {
                    $ObjectProperties = $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames.Where( { $ExcludeProperty -notcontains $_  } ) #.Name
                } else {
                    $ObjectProperties = $O.PSObject.Properties.Where( { $PropertyType -notcontains $_.MemberType -and $ExcludeProperty -notcontains $_.Name  } ).Name
                }
                foreach ($Name in $ObjectProperties) {
                    $null = $Titles.Add($Name)
                }
                break
            }
            # Add Titles to Array (if not -SkipTitles)
        }
    }
    if (-not $SkipTitle) {
        $null = $Array.Add($Titles)
    }
    # Extract data (based on Title)
    foreach ($O in $Object) {
        $ArrayValues = [System.Collections.ArrayList]::new()
        foreach ($Name in $Titles) {
            $null = $ArrayValues.Add($O.$Name)
        }
        $null = $Array.Add($ArrayValues)
    }
    if ($Array.Count -eq 1) { , $Array } else { $Array }
}
function Format-PSTableConvertID {
    [CmdletBinding()]
    param (
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders
    )
    $Array = [System.Collections.ArrayList]::new()
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = [System.Collections.ArrayList]::new()
        $null = $Titles.Add('Name')
        $null = $Titles.Add('Value')
        $null = $Array.Add($Titles)
    }
    ### Add Data
    foreach ($O in $Object) {
        foreach ($Name in $O.Keys) {
            #$ArrayValues = New-ArrayList
            $ArrayValues = [System.Collections.ArrayList]::new()
            if ($Property) {
                if ($Property -contains $Name) {
                     $null = $ArrayValues.Add($Name)
                    $null = $ArrayValues.Add($Object.$Name)
                    $null = $Array.Add($ArrayValues)
                }
            } else {
                if ($ExcludeProperty -notcontains $Name) {
                    $null = $ArrayValues.Add($Name)
                    $null = $ArrayValues.Add($O[$Name])
                    $null = $Array.Add($ArrayValues)
                }
            }
        }
    }
    if ($Array.Count -eq 1) { , $Array } else { $Array }
}
function Format-Stream {
    [alias('FS','Format-TableStream','Format-ListStream')]
    ##[alias('ftv','ftd','fto','fth','fti','flv','fld','flo','flh','fli','Format-TableVerbose', 'Format-TableDebug', 'Format-TableInformation', 'Format-TableWarning')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory = $false,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [object] $InputObject,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 0,ParameterSetName = 'Property')]
        [Object[]] $Property,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 2,ParameterSetName = 'ExcludeProperty')]
        [Object[]] $ExcludeProperty,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 3)]
        [switch] $HideTableHeaders,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 4)]
        [int] $ColumnHeaderSize,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 5)]
        [switch] $AlignRight,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 6)]
        [validateset('Output', 'Host', 'Warning', 'Verbose', 'Debug', 'Information')]
        [string] $Stream = 'Verbose',

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 7)]
        [alias('AsList')][switch] $List,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 8)]
        [alias('Rotate', 'RotateData', 'TransposeColumnsRows', 'TransposeData')]
        [switch] $Transpose,

        [Parameter(Mandatory = $false,ValueFromPipeline = $false,Position = 9)]
        [ValidateSet("ASC", "DESC", "NONE")]
        [string] $TransposeSort = 'NONE',

        [alias('Color')]
        [System.ConsoleColor[]] $ForegroundColor,

        [alias('ColorRow')]
        [int[]] $ForegroundColorRow
    )
    Begin {
        $IsVerbosePresent = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent

        if ($Stream -eq 'Output') {
            #
        } elseif ($Stream -eq 'Host') {
            #
        } elseif ($Stream -eq 'Warning') {
            [System.Management.Automation.ActionPreference] $WarningCurrent = $WarningPreference
            $WarningPreference = 'continue'
        } elseif ($Stream -eq 'Verbose') {
            [System.Management.Automation.ActionPreference] $VerboseCurrent = $VerbosePreference
            $VerbosePreference = 'continue'
        } elseif ($Stream -eq 'Debug') {
            [System.Management.Automation.ActionPreference] $DebugCurrent = $DebugPreference
            $DebugPreference = 'continue'
        } elseif ($Stream -eq 'Information') {
            [System.Management.Automation.ActionPreference] $InformationCurrent = $InformationPreference
            $InformationPreference = 'continue'
        }

        [bool] $FirstRun = $True # First run for pipeline
        [bool] $FirstLoop = $True # First loop for data
        [bool] $FirstList = $True # First loop for a list
        [int] $ScreenWidth = $Host.UI.RawUI.WindowSize.Width - 12 # Removes 12 chars because of VERBOSE: output
        $ArrayList = @()
    }
    Process {
        if ((Get-ObjectCount -Object $InputObject) -eq 0) { break }
        if ($FirstRun) {
            $FirstRun = $false
            if ($Transpose) { $InputObject = Format-TransposeTable -Object $InputObject -Sort $TransposeSort }
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders
            $Headers = $Data[0]
            if ($HideTableHeaders) {
                $Data.RemoveAt(0);
            }
            $ArrayList += $Data
        } else {
            if ($Transpose) { $InputObject = Format-TransposeTable -Object $InputObject -Sort $TransposeSort }
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders -OverwriteHeaders $Headers -SkipTitle
            $ArrayList += $Data
        }
    }
    End {
        if (-not $ColumnHeaderSize) {
            $ColumnLength = [int[]]::new($Headers.Count);
            foreach ($Row in $ArrayList) {
                $i = 0
                foreach ($Column in $Row) {
                    $Length = "$Column".Length
                    if ($Length -gt $ColumnLength[$i]) {
                        $ColumnLength[$i] = $Length
                    }
                    $i++
                }
            }
            if ($IsVerbosePresent) {
                Write-Verbose "Format-TableVerbose - ScreenWidth $ScreenWidth"
                Write-Verbose "Format-TableVerbose - Column Lengths $($ColumnLength -join ',')"
            }
        }
        # Add empty line
        if ($Stream -eq 'Output') {
            Write-Output -InputObject ''
        } elseif ($Stream -eq 'Host') {
            Write-Host -Object ''
        } elseif ($Stream -eq 'Warning') {
            Write-Warning -Message ''
        } elseif ($Stream -eq 'Verbose') {
            Write-Verbose -Message ''
        } elseif ($Stream -eq 'Debug') {
            Write-Debug -Message ''
        } elseif ($Stream -eq 'Information') {
            Write-Information -MessageData ''
        }
        if ($List) {
            [int] $RowCount = 1
            foreach ($Row in $ArrayList ) {
                [string] $Output = ''
                [int] $ColumnNumber = 0
                [int] $CurrentColumnLength = 0

                if ($ColumnHeaderSize) {
                    $PadLength = $ColumnHeaderSize # Add +1 to make sure there's space between columns
                } else {
                    $PadLength = (($Headers.Length | Measure-Object -Maximum).Maximum) + 1 # Add +1 to make sure there's space between columns
                }


                # Prepare each data for row
                if (-not $FirstList) {
                    $i = 0
                    foreach ($ColumnValue in $Row) {
                        if (-not $HideTableHeaders) {
                            # Using Headers for a List
                            if ($AlignRight) {
                                $Head = $($Headers[$i]).PadLeft($PadLength)
                            } else {
                                $Head = $($Headers[$i]).PadRight($PadLength)
                            }
                            $Output = "$Head`: $ColumnValue"
                        } else {
                            # Hide table headers for a List switch
                            $Output = "$ColumnValue"
                        }

                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject $Output
                        } elseif ($Stream -eq 'Host') {
                            Write-Host -Object $Output
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message $Output
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message $Output
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message $Output
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData $Output
                        }
                        $i++
                    }
                    $RowCount++
                    if ($RowCount -ne $ArrayList.Count) {
                        # Add empty line per each object but only if it's not last object
                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject ''
                        } elseif ($Stream -eq 'Host') {
                            Write-Host -Object ''
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message ''
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message ''
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message ''
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData ''
                        }
                    }
                }
                $FirstList = $false
            }
        } else {
            # Process Data
            [int] $RowCountColors = 1
            foreach ($Row in $ArrayList ) {
                [string] $Output = ''
                [int] $ColumnNumber = 0
                [int] $CurrentColumnLength = 0
                # Prepare each data for row
                foreach ($ColumnValue in $Row) {

                    # Set Column Header Size to static value or based on string length
                    if ($ColumnHeaderSize) {
                        $PadLength = $ColumnHeaderSize # Add +1 to make sure there's space between columns
                    } else {
                        $PadLength = $ColumnLength[$ColumnNumber] + 1 # Add +1 to make sure there's space between columns
                    }

                    # Makes sure to display all data on current screen size, the larger the screen, the more it fits
                    $CurrentColumnLength += $PadLength
                    if ($CurrentColumnLength -ge $ScreenWidth) {
                        break
                    }

                    # Prepare Data
                    if ($ColumnHeaderSize) {
                        # if ColumnHeaderSize is defined we need to trim text and make sure there is space between for the ones being trimmed
                        $ColumnValue = ("$ColumnValue".ToCharArray() | Select-Object -First ($PadLength - 1)) -join ""
                    } else {
                        $ColumnValue = ("$ColumnValue".ToCharArray() | Select-Object -First ($PadLength)) -join ""
                    }
                    if ($Output -eq '') {
                        if ($AlignRight) {
                            $Output = "$ColumnValue".PadLeft($PadLength)
                        } else {
                            $Output = "$ColumnValue".PadRight($PadLength)
                        }
                    } else {
                        if ($AlignRight) {
                            $Output = $Output + "$ColumnValue".PadLeft($PadLength)
                        } else {
                            $Output = $Output + "$ColumnValue".PadRight($PadLength)
                        }
                    }
                    $ColumnNumber++
                }
                if ($Stream -eq 'Output') {
                    Write-Output -InputObject $Output
                } elseif ($Stream -eq 'Host') {
                    if ($ForegroundColorRow -contains $RowCountColors) {
                        [int] $Index = $ForegroundColorRow.IndexOf($RowCountColors)
                        Write-Host -Object $Output -ForegroundColor $ForegroundColor[$Index]
                    } else {
                        Write-Host -Object $Output
                    }
                } elseif ($Stream -eq 'Warning') {
                    Write-Warning -Message $Output
                } elseif ($Stream -eq 'Verbose') {
                    Write-Verbose -Message $Output
                } elseif ($Stream -eq 'Debug') {
                    Write-Debug -Message $Output
                } elseif ($Stream -eq 'Information') {
                    Write-Information -MessageData $Output
                }


                if (-not $HideTableHeaders) {
                    # Add underline
                    if ($FirstLoop) {
                        $HeaderUnderline = $Output -Replace '\w', '-'
                        #Write-Verbose -Message $HeaderUnderline
                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject $HeaderUnderline
                        } elseif ($Stream -eq 'Host') {
                            if ($ForegroundColorRow -contains $RowCountColors) {
                                [int] $Index = $ForegroundColorRow.IndexOf($RowCountColors)
                                Write-Host -Object $HeaderUnderline -ForegroundColor $ForegroundColor[$Index]
                            } else {
                                Write-Host -Object $HeaderUnderline
                            }
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData $HeaderUnderline
                        }
                    }
                }

                $FirstLoop = $false
                $RowCountColors++
            }
        }

        # Add empty line
        if ($Stream -eq 'Output') {
            Write-Output -InputObject ''
        } elseif ($Stream -eq 'Host') {
            Write-Host -Object ''
        } elseif ($Stream -eq 'Warning') {
            Write-Warning -Message ''
        } elseif ($Stream -eq 'Verbose') {
            Write-Verbose -Message ''
        } elseif ($Stream -eq 'Debug') {
            Write-Debug -Message ''
        } elseif ($Stream -eq 'Information') {
            Write-Information -MessageData ''
        }


        # Set back to defaults
        if ($Stream -eq 'Output') {
            #
        } elseif ($Stream -eq 'Host') {
            #
        } elseif ($Stream -eq 'Warning') {
            $WarningPreference = $WarningCurrent
        } elseif ($Stream -eq 'Verbose') {
            $VerbosePreference = $VerboseCurrent
        } elseif ($Stream -eq 'Debug') {
            $DebugPreference = $DebugCurrent
        } elseif ($Stream -eq 'Information') {
            $InformationPreference = $InformationCurrent
        }
    }
}

<#
Format-ToTitleCase 'me'

'me i feel good' | Format-ToTitleCase

'me i feel', 'not feel' |Format-ToTitleCase
#>

function Format-ToTitleCase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)][string[]] $Text
    )
    Begin {}
    Process {
        $Conversion = foreach ($T in $Text) {
            (Get-Culture).TextInfo.ToTitleCase($T)
        }
    }
    End {
        return $Conversion
    }
}
function Format-TransposeTable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] [object[]]$Object,
        [ValidateSet("ASC", "DESC", "NONE")][String] $Sort = 'NONE'
    )
    begin { $i = 0; }

    process {
        foreach ($myObject in $Object) {
            if ($myObject.GetType().Name -eq 'hashtable' -or $myObject.GetType().Name -eq 'OrderedDictionary') {
                #Write-Verbose "Format-TransposeTable - Converting HashTable/OrderedDictionary to PSCustomObject - $($myObject.GetType().Name)"
                $output = New-Object -TypeName PsObject;
                Add-Member -InputObject $output -MemberType ScriptMethod -Name AddNote -Value {
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1];
                };
                if ($Sort -eq 'ASC') {
                    $myObject.Keys | Sort-Object -Descending:$false | % { $output.AddNote($_, $myObject.$_); }
                } elseif ($Sort -eq 'DESC') {
                    $myObject.Keys | Sort-Object -Descending:$true | % { $output.AddNote($_, $myObject.$_); }
                } else {
                    $myObject.Keys | % { $output.AddNote($_, $myObject.$_); }
                }
                $output;
            } else {
                #Write-Verbose "Format-TransposeTable - Converting PSCustomObject to HashTable/OrderedDictionary - $($myObject.GetType().Name)"
                # Write-Warning "Index $i is not of type [hashtable]";
                $output = [ordered] @{};
                $myObject | Get-Member -MemberType *Property | % {
                    $output.($_.name) = $myObject.($_.name);
                }
                $output

            }
            $i += 1;
        }
    }
}
function Format-View {
    [alias('FV', 'Format-Verbose', 'Format-Debug', 'Format-Warning')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [object] $InputObject,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 1, ParameterSetName = 'Property')]
        [Object[]] $Property,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 2, ParameterSetName = 'ExcludeProperty')]
        [Object[]] $ExcludeProperty,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 3)]
        [switch] $HideTableHeaders,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 6)]
        [validateset('Output', 'Host', 'Warning', 'Verbose', 'Debug', 'Information')]
        [string] $Stream = 'Verbose',

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 7)]
        [alias('AsList')][switch] $List,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 8)]
        [switch] $Autosize
    )
    Begin {
        $IsVerbosePresent = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent

        if ($Stream -eq 'Output') {
            #
        } elseif ($Stream -eq 'Host') {
            #
        } elseif ($Stream -eq 'Warning') {
            [System.Management.Automation.ActionPreference] $WarningCurrent = $WarningPreference
            $WarningPreference = 'continue'
        } elseif ($Stream -eq 'Verbose') {
            [System.Management.Automation.ActionPreference] $VerboseCurrent = $VerbosePreference
            $VerbosePreference = 'continue'
        } elseif ($Stream -eq 'Debug') {
            [System.Management.Automation.ActionPreference] $DebugCurrent = $DebugPreference
            $DebugPreference = 'continue'
        } elseif ($Stream -eq 'Information') {
            [System.Management.Automation.ActionPreference] $InformationCurrent = $InformationPreference
            $InformationPreference = 'continue'
        }

        [bool] $FirstRun = $True # First run for pipeline
        [bool] $FirstLoop = $True # First loop for data
        [bool] $FirstList = $True # First loop for a list
        [int] $ScreenWidth = $Host.UI.RawUI.WindowSize.Width - 12 # Removes 12 chars because of VERBOSE: output
        $MyList = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        $MyList.Add($InputObject)
    }
    End {
        $Parameters = @{}
        if ($Property) {
            $Parameters.Property = $Property
        }
        if ($ExcludeProperty) {
            $Parameters.ExcludeProperty = $ExcludeProperty
        }
        if ($HideTableHeaders) {
            $Parameters.HideTableHeaders = $HideTableHeaders
        }

        if ($List) {
            # Show and set back to defaults
            if ($Stream -eq 'Output') {
                $MyList | Format-List @Parameters | Out-String | Write-Output
            } elseif ($Stream -eq 'Host') {
                $MyList | Format-List @Parameters | Out-String | Write-Host
            } elseif ($Stream -eq 'Warning') {
                $MyList | Format-List @Parameters | Out-String | Write-Warning
                $WarningPreference = $WarningCurrent
            } elseif ($Stream -eq 'Verbose') {
                $MyList | Format-List @Parameters | Out-String | Write-Verbose
                $VerbosePreference = $VerboseCurrent
            } elseif ($Stream -eq 'Debug') {
                $MyList | Format-List @Parameters | Out-String | Write-Debug
                $DebugPreference = $DebugCurrent
            } elseif ($Stream -eq 'Information') {
                $MyList | Format-List @Parameters | Out-String | Write-Information
                $InformationPreference = $InformationCurrent
            }
        } else {
            # Show and set back to defaults
            if ($Stream -eq 'Output') {
                $MyList | Format-Table @Parameters | Out-String | Write-Output
            } elseif ($Stream -eq 'Host') {
                $MyList | Format-Table @Parameters | Out-String | Write-Host
            } elseif ($Stream -eq 'Warning') {
                $MyList | Format-Table @Parameters | Out-String | Write-Warning
                $WarningPreference = $WarningCurrent
            } elseif ($Stream -eq 'Verbose') {
                $MyList | Format-Table @Parameters | Out-String | Write-Verbose
                $VerbosePreference = $VerboseCurrent
            } elseif ($Stream -eq 'Debug') {
                $MyList | Format-Table @Parameters | Out-String | Write-Debug
                $DebugPreference = $DebugCurrent
            } elseif ($Stream -eq 'Information') {
                $MyList | Format-Table @Parameters | Out-String | Write-Information
                $InformationPreference = $InformationCurrent
            }
        }
    }
}
function Get-CimData {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [string] $Class,
        [string[]] $Properties = '*'
    ) 
    $CimObject = @(
        # requires removal of this property for query
        [string[]] $PropertiesOnly = $Properties | Where-Object { $_ -ne 'PSComputerName' }   
        # Process all remote computers
        $Computers = $ComputerName | Where-Object { $_ -ne $Env:COMPUTERNAME }
        if ($Computers.Count -gt 0) {
            if ($Protocol = 'Default') {
                Get-CimInstance -ClassName $Class -ComputerName $Computers -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
         
            } else {                
                $Option = New-CimSessionOption -Protocol 
                $Session = New-CimSession -ComputerName $Computers -SessionOption $Option
                $Info = Get-CimInstance -ClassName $Class -CimSession $Session -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
                $null = Remove-CimSession -CimSession $Session                    
                $Info
            }
        }
        # Process local computer
        $Computers = $ComputerName | Where-Object { $_ -eq $Env:COMPUTERNAME }
        if ($Computers.Count -gt 0) {
            $Info = Get-CimInstance -ClassName $Class -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
            $Info | Add-Member -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
            $Info        
        }
    )
    # Find computers that are not part of data return and warn user
    $CimComputers = $CimObject.PSComputerName | Sort-Object -Unique
    foreach ($Computer in $ComputerName) {
        if ($CimComputers -notcontains $Computer) {
            Write-Warning "Get-ComputerSystem - No data for computer $Computer. Most likely an error on receiving side." 
        }
    }
    return $CimObject
}

<# ReferenceOnly
It's not really a function. If you use this it will display Get-CommandInfo. It's something you can use for reference if needed.
#>
Function Get-CommandInfo {
    $Command = @{}
    $Command.Type = "$($MyInvocation.MyCommand.CommandType)".ToLower()
    $Command.Name = "$($MyInvocation.MyCommand.Name)"
    return $Command
}
function Get-ComputerApplications {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = {
        $objapp1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
        $objapp2 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*

        $app1 = $objapp1 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x64' }; Label = "WindowsType"}
        $app2 = $objapp2 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x86' }; Label = "WindowsType"} | where { -NOT (([string]$_.displayname).contains("Security Update for Microsoft") -or ([string]$_.displayname).contains("Update for Microsoft"))}
        $app = $app1 + $app2 #| Sort-Object -Unique
        return $app | Where { $_.Displayname -ne $null } | Sort-Object DisplayName
    }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $Data = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    }
    return $Data

}
function Get-ComputerBios {
    [CmdletBinding()]
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data1 = Get-WmiObject win32_bios -ComputerName $ComputerName| select Status, Version, PrimaryBIOS, Manufacturer, ReleaseDate, SerialNumber
    return $Data1
}
function Get-ComputerCPU {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_processor'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'PSComputerName', 'Name', 'DeviceID', 'Caption', 'SystemName', 'CurrentClockSpeed', 'MaxClockSpeed', 'ProcessorID', 'ThreadCount', 'Architecture', 'Status', 'LoadPercentage', 'L3CacheSize', 'Manufacturer', 'VirtualizationFirmwareEnabled', 'NumberOfCores', 'NumberOfEnabledCore', 'NumberOfLogicalProcessors'

    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName                  = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Name                          = $Data.Name
                    DeviceID                      = $Data.DeviceID
                    Caption                       = $Data.Caption
                    CurrentClockSpeed             = $Data.CurrentClockSpeed
                    MaxClockSpeed                 = $Data.MaxClockSpeed
                    ProcessorID                   = $Data.ProcessorID
                    ThreadCount                   = $Data.ThreadCount
                    Architecture                  = $Data.Architecture
                    Status                        = $Data.Status
                    LoadPercentage                = $Data.LoadPercentage
                    Manufacturer                  = $Data.Manufacturer
                    #VirtualizationFirmwareEnabled = $Data.VirtualizationFirmwareEnabled
                    NumberOfCores                 = $Data.NumberOfCores
                    NumberOfEnabledCore           = $Data.NumberOfEnabledCore
                    NumberOfLogicalProcessors     = $Data.NumberOfLogicalProcessors    
                }
            }
        }
    }
}


#get-counter -Counter '\Processor(*)\% Processor Time' -SampleInterval 1 -MaxSamples 3 | select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average | select -ExpandProperty Average
function Get-ComputerCulture {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = {
        get-culture | select KeyboardLayoutId, DisplayName, @{Expression = {$_.ThreeLetterWindowsLanguageName}; Label = "Windows Language"}
    }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data8 = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $Data8 = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    }
    return $Data8
}
function Get-ComputerDisk {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ComputerName
    Parameter description
    
    .PARAMETER Protocol
    Parameter description
    
    .PARAMETER All
    Parameter description
    
    .EXAMPLE
    Get-ComputerDisk -ComputerName AD1, AD2, EVO1, AD2019 | Format-Table -AutoSize *

    Output:
    WARNING: Get-ComputerSystem - No data for computer AD2019. Most likely an error on receiving side.

    ComputerName Index Model                     Caption                   SerialNumber         Description MediaType             FirmwareRevision Partitions SizeGB PNPDeviceID
    ------------ ----- -----                     -------                   ------------         ----------- ---------             ---------------- ---------- ------ -----------
    AD1              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
    AD2              0 Microsoft Virtual Disk    Microsoft Virtual Disk                         Disk drive  Fixed hard disk media 1.0                       3    127 SCSI\DISK&VEN_MSFT&PROD_VIRTUAL_DISK\000000
    EVO1             0 WDC WD30EFRX-68AX9N0      WDC WD30EFRX-68AX9N0      WD-WMC1T2351095      Disk drive  Fixed hard disk media 80.00A80                  1   2795 SCSI\DISK&VEN_WDC&PROD_WD30EFRX-68AX9N0\4&191557A4&0&000000
    EVO1             2 Samsung SSD 950 PRO 512GB Samsung SSD 950 PRO 512GB 0025_3857_61B0_0EF2. Disk drive  Fixed hard disk media 2B0Q                      3    477 SCSI\DISK&VEN_NVME&PROD_SAMSUNG_SSD_950\5&35365596&0&000000
    EVO1             1 Samsung SSD 860 EVO 500GB Samsung SSD 860 EVO 500GB S3Z2NB0K176976A      Disk drive  Fixed hard disk media RVT01B6Q                  1    466 SCSI\DISK&VEN_SAMSUNG&PROD_SSD\4&191557A4&0&000100
        
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_diskdrive'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Index', 'Model', 'Caption', 'SerialNumber', 'Description', 'MediaType', 'FirmwareRevision', 'Partitions', 'Size', 'PNPDeviceID', 'PSComputerName'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName     = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Index            = $Data.Index
                    Model            = $Data.Model
                    Caption          = $Data.Caption
                    SerialNumber     = if ($Data.SerialNumber) { $Data.SerialNumber.Trim() } else { '' }
                    Description      = $Data.Description
                    MediaType        = $Data.MediaType
                    FirmwareRevision = $Data.FirmwareRevision
                    Partitions       = $Data.Partitions
                    SizeGB           = $Data.Size / 1Gb -as [int]
                    PNPDeviceID      = $Data.PNPDeviceID
                }
            }
        }
    }
}
function Get-ComputerDiskLogical {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data5 = Get-WmiObject win32_logicalDisk -ComputerName $ComputerName | select DeviceID, VolumeName, @{Expression = {$_.Size / 1Gb -as [int]}; Label = "Total Size(GB)"}, @{Expression = {$_.Freespace / 1Gb -as [int]}; Label = "Free Size (GB)"}
    return $Data5
}
function Get-ComputerMissingDrivers {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $Data = Get-WmiObject Win32_PNPEntity -ComputerName $ComputerName | where {$_.Configmanagererrorcode -ne 0} | Select Caption, ConfigmanagererrorCode, Description, DeviceId, HardwareId, PNPDeviceID
    return $Data
}
function Get-ComputerNetwork {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data3 = get-WmiObject win32_networkadapter -ComputerName $ComputerName | Select Name, Manufacturer, Description , AdapterType, Speed, MACAddress, NetConnectionID, PNPDeviceID
    $Data3 = $Data3 | Select Name, Manufacturer, Speed, AdapterType, MACAddress
    return $Data3
}
function Get-ComputerOemInformation {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = { Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation | select Model, Manufacturer, Logo, SupportPhone, SupportURL, SupportHours }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $Data = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    }
    return $Data
}
function Get-ComputerOperatingSystem {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_operatingsystem'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'Caption', 'Manufacturer', 'InstallDate', 'OSArchitecture', 'Version', 'SerialNumber', 'BootDevice', 'WindowsDirectory', 'CountryCode', 'OSLanguage', 'OSProductSuite', 'PSComputerName', 'LastBootUpTime', 'LocalDateTime'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName     = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Caption          = $Data.Caption
                    Manufacturer     = $Data.Manufacturer
                    OSArchitecture   = $Data.OSArchitecture
                    OSLanguage       = $Data.OSLanguage
                    OSProductSuite   = $Data.OSProductSuite
                    InstallDate      = $Data.InstallDate
                    LastBootUpTime   = $Data.LastBootUpTime
                    LocalDateTime    = $Data.LocalDateTime
                    Version          = $Data.Version
                    SerialNumber     = $Data.SerialNumber
                    BootDevice       = $Data.BootDevice
                    WindowsDirectory = $Data.WindowsDirectory
                    CountryCode      = $Data.CountryCode
                }
            }
        }
    }
}
function Get-ComputerServices {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )
    $Services = Get-Service -ComputerName $ComputerName | select Name, Displayname, Status
    return $Services
}
function Get-ComputerStartup {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data4 = Get-WmiObject win32_startupCommand -ComputerName $ComputerName | select Name, Location, Command, User, caption
    $Data4 = $Data4 | Select Name, Command, User, Caption
    return $Data4
}
function Get-ComputerSystem {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ComputerName
    Parameter description
    
    .PARAMETER Protocol
    Parameter description
    
    .PARAMETER All
    Parameter description
    
    .EXAMPLE
    Get-ComputerSystem -ComputerName AD1, AD2, EVO1, ADFFS | ft -a *

    Output:
    WARNING: Get-ComputerSystem - No data for computer ADFFS. Most likely an error on receiving side.
    ComputerName Name Manufacturer          Domain        Model           Systemtype   PrimaryOwnerName PCSystemType PartOfDomain CurrentTimeZone BootupState SystemFamily    Roles
    ------------ ---- ------------          ------        -----           ----------   ---------------- ------------ ------------ --------------- ----------- ------------    -----
    AD1          AD1  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Primary_Domain_Controller, Timesource, NT, DFS
    AD2          AD2  Microsoft Corporation ad.evotec.xyz Virtual Machine x64-based PC Windows User                1         True              60 Normal boot Virtual Machine LM_Workstation, LM_Server, Backup_Domain_Controller, Timesource, NT, DFS
    EVO1         EVO1 MSI                   ad.evotec.xyz MS-7980         x64-based PC                             1         True              60 Normal boot Default string  LM_Workstation, LM_Server, SQLServer, NT, Potential_Browser, Master_Browser

    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'Win32_ComputerSystem'
    if ($All) {
        $Properties = '*'
    } else {
        $Properties = 'PSComputerName', 'Name', 'Manufacturer' , 'Domain', 'Model' , 'Systemtype', 'PrimaryOwnerName', 'PCSystemType', 'PartOfDomain', 'CurrentTimeZone', 'BootupState', 'Roles', 'SystemFamily'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{ 
                    ComputerName     = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Name             = $Data.Name
                    Manufacturer     = $Data.Manufacturer
                    Domain           = $Data.Domain
                    Model            = $Data.Model
                    Systemtype       = $Data.Systemtype
                    PrimaryOwnerName = $Data.PrimaryOwnerName
                    PCSystemType     = $Data.PCSystemType
                    PartOfDomain     = $Data.PartOfDomain
                    CurrentTimeZone  = $Data.CurrentTimeZone
                    BootupState      = $Data.BootupState
                    SystemFamily     = $Data.SystemFamily
                    Roles            = $Data.Roles -join ', '
                }
            }
        }
    }
}
function Get-ComputerWindowsFeatures {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data = Get-WmiObject Win32_OptionalFeature -ComputerName $vComputerName | select Caption , Installstate
    return $Data
}
function Get-ComputerWindowsUpdates {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data = Get-hotfix -ComputerName $vComputerName | select Description , HotFixId , InstalledBy, InstalledOn, Caption
    return $Data
}
function Get-FileInformation {
    [CmdletBinding()]
    param(
        [string] $File
    )
    if (Test-Path $File) {
        return get-item $File  | Select-Object Name, FullName, @{N = 'Size'; E = {Get-FileSize -Bytes $_.Length}}, IsReadOnly, LastWriteTime
    }
    return
}
# https://docs.microsoft.com/en-us/dotnet/api/system.io.path.getfilenamewithoutextension?view=netframework-4.7.2
function Get-FileName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Extension
    Parameter description

    .PARAMETER Temporary
    Parameter description

    .PARAMETER TemporaryFileOnly
    Parameter description

    .EXAMPLE
    Get-FileName -Temporary
    Output: 3ymsxvav.tmp

    .EXAMPLE

    Get-FileName -Temporary
    Output: C:\Users\pklys\AppData\Local\Temp\tmpD74C.tmp

    .EXAMPLE

    Get-FileName -Temporary -Extension 'xlsx'
    Output: C:\Users\pklys\AppData\Local\Temp\tmp45B6.xlsx


    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $Extension = 'tmp',
        [switch] $Temporary,
        [switch] $TemporaryFileOnly
    )

    if ($Temporary) {
        return "$($([System.IO.Path]::GetTempFileName()).Split('.')[0]).$Extension"
    }
    if ($TemporaryFileOnly) {
        # Generates 3ymsxvav.tmp
        return "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
    }
}
function Get-FilesInFolder {
    [CmdletBinding()]
    param(
        [string] $Folder,
        [string] $Extension = '*.evtx'
    )
    $ReturnFiles = @()
    $Files = Get-ChildItem -Path $Folder -Filter $Extension -Recurse
    foreach ($File in $Files) {
        $ReturnFiles += $File.FullName
    }
    return $ReturnFiles
}
function Get-FileSize {
    [CmdletBinding()]
    param(
        $Bytes
    )
    $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for ($i = 0; ($Bytes -ge 1kb) -and ($i -lt $sizes.Count); $i++) {
        $Bytes /= 1kb
    }
    $N = 2;
    if ($i -eq 0) {
        $N = 0
    }
    return "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}
function Get-HashMaxValue {
    [CmdletBinding()]
    param (
        [Object] $hashTable,
        [switch] $Lowest
    )
    if ($Lowest) {
        return ($hashTable.GetEnumerator() | Sort-Object value -Descending | Select-Object -Last 1).Value
    } else {
        return ($hashTable.GetEnumerator() | Sort-Object value -Descending | Select-Object -First 1).Value
    }
}
function Get-HTML($text) {
    $text = $text.Split("`r")
    foreach ($t in $text) {
        Write-Host $t
    }
}
function Get-InstalledApplication {
    <#
    .EXAMPLE
    Get-InstalledApplication -Type UserInstalled -DisplayName 'JetBrains dotCover 2017.1.1'
    #>
    [CmdletBinding()]
    Param(
        [string[]] $DisplayName, # = "Microsoft Exchange Online Powershell Module",
        [ValidateSet('UserInstalled', 'SystemWide', 'ClickOnce')][string] $Type = 'UserInstalled',
        [switch] $All
    )
    if ($Type -eq 'UserInstalled' -or $Type -eq 'ClickOnce') {
        $Registry = 'HKCU'
    } else {
        $Registry = 'HKLM'
    }

    $InstalledApplications = Get-ChildItem -Path "$Registry`:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Foreach-Object { Get-ItemProperty $_.PsPath }
    if ($DisplayName) {
        $InstalledApplications | Where-Object { $DisplayName -contains $_.DisplayName }
    } else {
        $InstalledApplications
    }
}
function Get-IPAddressInformation {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER IP
    Parameter description
    
    .EXAMPLE
    Get-IpAddressInformation -IP 1.1.1.1

    
    .NOTES
    General notes
    #>
    
    [cmdletbinding()]
    param(
        [string] $IP
    )
    try {
        $Information = Invoke-RestMethod -Method get -Uri "http://ip-api.com/json/$ip"
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning "Get-IPAddressInformation - Error occured on IP $IP`: $ErrorMessage"
    }
    return $Information
}
#requires -Module PSWriteColor
<#
    .SYNOPSIS
    Returns an instance of the logger object.

    .EXAMPLE with full log name
    $Logger = Get-Logger -ShowTime -LogPath 'C:\temp\test.log'
    $Logger.AddErrorRecord("test error")
    $Logger.AddInfoRecord("test info")
    $Logger.AddSuccessRecord("test success")
    $Logger.AddRecord("test record")

    .EXAMPLE with directory name and auto-generated log name
    $Logger = Get-Logger -ShowTime -LogsDir 'C:\temp'
    $Logger.AddErrorRecord("test error")

    .EXAMPLE with directory name and logo name defined separately
    $Logger = Get-Logger -ShowTime -Directory 'C:\temp' -Filename 'test.log'
    $Logger.AddErrorRecord("test error")

    .EXAMPLE without logfile, only console output
    $Logger = Get-Logger -ShowTime
    $Logger.AddErrorRecord("test error")
#>

function Get-Logger {
    [CmdletBinding(DefaultParameterSetName="All")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Logpath')][string] $LogPath,
        [Parameter(Mandatory = $false, ParameterSetName = 'Complexpath')][string] $LogsDir,
        [Parameter(Mandatory = $false, ParameterSetName = 'Complexpath')][string] $Filename,
        [switch] $ShowTime,
        [string] $TimeFormat = 'yyyy-MM-dd HH:mm:ss'
    )

    if ($PSCmdlet.ParameterSetName -eq 'Complexpath') {
        if (-not $Filename) {
            $CallerName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path $MyInvocation.PSCommandPath -Leaf))
            $Filename = "$([DateTime]::Now.ToString($TimeFormat) -replace('[^.\-\w]', '_'))_$CallerName.log"
        }
        $LogPath = Join-Path $LogsDir $Filename
    }

    if ($LogPath) {
        $LogsDir = [System.IO.Path]::GetDirectoryName($LogPath)
        New-Item $LogsDir -ItemType Directory -Force | Out-Null
        New-Item $LogPath -ItemType File -Force | Out-Null
    }

    $Logger = [PSCustomObject]@{
        LogPath    = $LogPath
        ShowTime   = $ShowTime
        TimeFormat = $TimeFormat
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddErrorRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Error] ", $String -Color Red, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Error] ", $String -Color Red, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddInfoRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Info] ", $String -Color Yellow, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Info] ", $String -Color Yellow, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddWarningRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Warning] ", $String -Color Magenta, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Warning] ", $String -Color Magenta, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text " $String" -Color White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text " $String" -Color White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }
    Add-Member -InputObject $Logger -MemberType ScriptMethod AddSuccessRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Success] ", $String -Color Green, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Success] ", $String -Color Green, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }
    return $Logger
}
function Get-MimeType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $FileName
	)

	$MimeMappings = @{
		'.jpeg' = 'image/jpeg'
		'.jpg'  = 'image/jpeg'
		'.png'  = 'image/png'
	}

	$Extension = [System.IO.Path]::GetExtension( $FileName )
	$ContentType = $MimeMappings[ $Extension ]

	if ([string]::IsNullOrEmpty($ContentType)) {
		return New-Object System.Net.Mime.ContentType
	} else {
		return New-Object System.Net.Mime.ContentType($ContentType)
	}
}
Function Get-ModulesAvailability {
    param(
        [string]$Name
    )
    if (-not(Get-Module -Name $Name)) {
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $Name }) {
            try {
                Import-Module -Name $Name
                return $true
            } catch {
                return $false
            }
        } else {
            #module not available
            return $false
        }
    } else {
        return $true
    } #module already loaded
}
function Get-MyIpAddress {
    [alias('Get-MyIP')]
    [CmdletBinding()]
    param()
    $DNSParam = @{
        Name    = 'myip.opendns.com'
        Server  = 'resolver1.opendns.com'
        DnsOnly = $true
    }
    return Resolve-DnsName @DNSParam | ForEach-Object IPAddress
}
function Get-ObjectCount {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Object]$Object
    )
    return $($Object | Measure-Object).Count
}
function Get-ObjectData {
    [CmdletBinding()]
    param(
        $Object,
        $Title,
        [switch] $DoNotAddTitles
    )
    $ArrayList = New-Object System.Collections.ArrayList
    $Values = $Object.$Title
    Write-Verbose "Get-ObjectData1: Title $Title Values: $Values"
    if ((Get-ObjectCount $values) -eq 1 -and $DoNotAddTitles -eq $false) {
        $ArrayList.Add("$Title - $Values") | Out-Null
    } else {
        if ($DoNotAddTitles -eq $false) { $ArrayList.Add($Title) | Out-Null }
        foreach ($Value in $Values) {
            $ArrayList.Add("$Value") | Out-Null
        }
    }
    Write-Verbose "Get-ObjectData2: Title $Title Values: $(Get-ObjectCount $ArrayList)"
    return $ArrayList
}
Function Get-ObjectEnumValues {
    param(
        [string]$enum
    )
    $enumValues = @{}
    [enum]::getvalues([type]$enum) |
        ForEach-Object {
        $enumValues.add($_, $_.value__)
    }
    $enumValues
}
function Get-ObjectKeys {
    param(
        [object] $Object,
        [string] $Ignore
    )
    $Data = $Object.Keys | Where { $_ -notcontains $Ignore }
    return $Data
}

# This function goes thru an object such as Get-Aduser and scans every object returned getting all properties
# This basically makes sure that all properties are known at run time of Export to SQL, Excel or Word

<#
$Test = Get-Process

Get-ObjectProperties -Object $Test
#>
function Get-ObjectProperties {
    param (
        [object] $Object,
        [string[]] $AddProperties, # provides ability to add some custom properties
        [switch] $Sort
    )
    $Properties = [System.Collections.ArrayList]::new()
    foreach ($O in $Object) {
        $ObjectProperties = $O.PSObject.Properties.Name
        foreach ($Property in $ObjectProperties) {
            Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
        }
    }
    foreach ($Property in $AddProperties) {
        Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
    }
    if ($Sort) {
        return $Properties | Sort-Object
    } else {
        return $Properties
    }
}
function Get-ObjectPropertiesAdvanced {
    [CmdletBinding()]
    param (
        [object] $Object,
        [string[]] $AddProperties, # provides ability to add some custom properties
        [switch] $Sort
    )
    $Data = @{}
    $Properties = New-ArrayList
    $HighestCount = 0

    foreach ($O in $Object) {
        $ObjectProperties = $O.PSObject.Properties.Name
        $Test = $ObjectProperties -join ','
        $Count = $ObjectProperties.Count
        if ($Count -gt $HighestCount) {
            $Data.HighestCount = $Count
            $Data.HighestObject = $O
            $HighestCount = $Count
        }
        foreach ($Property in $ObjectProperties) {
            Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
        }
    }
    foreach ($Property in $AddProperties) {
        Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
    }
    $Data.Properties = if ($Sort) { $Properties | Sort-Object } else { $Properties }
    #Write-Verbose "Get-ObjectPropertiesAdvanced - HighestCount: $($Data.HighestCount)"
    #Write-Verbose "Get-ObjectPropertiesAdvanced - Properties: $($($Data.Properties) -join ',')"

    # returns for example
    # $Data.HighestCount = 100
    # $Data.HighestObject = $Object
    # $Data.Properties = array of strings
    return $Data
}
function Get-ObjectTitles {
    [CmdletBinding()]
    param(
        $Object
    )
    $ArrayList = New-Object System.Collections.ArrayList
    Write-Verbose "Get-ObjectTitles - ObjectType $($Object.GetType())"
    foreach ($Title in $Object.PSObject.Properties) {
        Write-Verbose "Get-ObjectTitles - Value added to array: $($Title.Name)"
        $ArrayList.Add($Title.Name) | Out-Null
    }
    Write-Verbose "Get-ObjectTitles - Array size: $($ArrayList.Count)"
    return $ArrayList
}
function Get-ObjectType {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $ObjectName = 'Random Object Name',
        [switch] $VerboseOnly
    )
    $ReturnData = [ordered] @{}
    $ReturnData.ObjectName = $ObjectName

    if ($Object -ne $null) {
        try {
            $TypeInformation = $Object.GetType()
            $ReturnData.ObjectTypeName = $TypeInformation.Name
            $ReturnData.ObjectTypeBaseName = $TypeInformation.BaseType
            $ReturnData.SystemType = $TypeInformation.UnderlyingSystemType
        } catch {
            $ReturnData.ObjectTypeName = ''
            $ReturnData.ObjectTypeBaseName = ''
            $ReturnData.SystemType = ''
            #Write-Verbose "Get-ObjectType - Outside Error: $($_.Exception.Message)"
        }
        try {
            $TypeInformationInsider = $Object[0].GetType()
            $ReturnData.ObjectTypeInsiderName = $TypeInformationInsider.Name
            $ReturnData.ObjectTypeInsiderBaseName = $TypeInformationInsider.BaseType
            $ReturnData.SystemTypeInsider = $TypeInformationInsider.UnderlyingSystemType
        } catch {

            $ReturnData.ObjectTypeInsiderName = ''
            $ReturnData.ObjectTypeInsiderBaseName = ''
            $ReturnData.SystemTypeInsider = ''
            #Write-Verbose "Get-ObjectType - Inside Error: $($_.Exception.Message)"
        }
    } else {
        $ReturnData.ObjectTypeName = ''
        $ReturnData.ObjectTypeBaseName = ''
        $ReturnData.SystemType = ''
        $ReturnData.ObjectTypeInsiderName = ''
        $ReturnData.ObjectTypeInsiderBaseName = ''
        $ReturnData.SystemTypeInsider = ''
        #Write-Verbose "Get-ObjectType - No data to process - Object is empty?"
    }
    Write-Verbose "Get-ObjectType - ObjectTypeName: $($ReturnData.ObjectTypeName)"
    Write-Verbose "Get-ObjectType - ObjectTypeBaseName: $($ReturnData.ObjectTypeBaseName)"
    Write-Verbose "Get-ObjectType - SystemType: $($ReturnData.SystemType)"
    Write-Verbose "Get-ObjectType - ObjectTypeInsiderName: $($ReturnData.ObjectTypeInsiderName)"
    Write-Verbose "Get-ObjectType - ObjectTypeInsiderBaseName: $($ReturnData.ObjectTypeInsiderBaseName)"
    Write-Verbose "Get-ObjectType - SystemTypeInsider: $($ReturnData.SystemTypeInsider)"
    if ($VerboseOnly) { return } else { return Format-TransposeTable -Object $ReturnData }

}
function Get-PathSeparator {
    param(

    )
    return  [IO.Path]::PathSeparator
}
function Get-PathTemporary {
    param(

    )
    return [IO.path]::GetTempPath()
}
function Get-RandomCharacters {
    [cmdletbinding()]
    param(
        [int] $length,
        [string] $characters
    )
    if ($length -ne 0 -and $characters -ne '') {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = "" # https://blogs.msdn.microsoft.com/powershell/2006/07/15/psmdtagfaq-what-is-ofs/
        return [String]$characters[$random]
    } else {
        return
    }
}
function Get-RandomFileName {
    [cmdletbinding()]
    param(
        $Length = 16,
        $Extension
    )
    $File = Get-RandomStringName -Size $Length -LettersOnly -ToLower
    return "$File.$Extension"
}
function Get-RandomPassword {
    [cmdletbinding()]
    param(
        [int] $LettersLowerCase = 4,
        [int] $LettersHigherCase = 2,
        [int] $Numbers = 1,
        [int] $SpecialChars = 0,
        [int] $SpecialCharsLimited = 1
    )
    $password = Get-RandomCharacters -length $LettersLowerCase -characters 'abcdefghiklmnoprstuvwxyz'
    $password += Get-RandomCharacters -length $LettersHigherCase -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length $Numbers -characters '1234567890'
    $password += Get-RandomCharacters -length $SpecialChars -characters '!$%()=?{@#'
    $password += Get-RandomCharacters -length $SpecialCharsLimited -characters '!$#'
    return $password
}
function Get-RandomStringName {
    [cmdletbinding()]
    param(
        [int] $Size = 31,
        [switch] $ToLower,
        [switch] $ToUpper,
        [switch] $LettersOnly
    )
    [string] $MyValue = @(
        if ($LettersOnly) {
            ( -join ((1..$Size) | % {(65..90) + (97..122) | Get-Random} | % {[char]$_}))
        } else {
            ( -join ((48..57) + (97..122) | Get-Random -Count $Size | ForEach-Object {[char]$_}))
        }
    )
    if ($ToLower) {
        return $MyValue.ToLower()
    }
    if ($ToUpper) {
        return $MyValue.ToUpper()
    }
    return $MyValue
}
function Get-ServerRoles {
    [CmdletBinding()]
    param (
        $ComputerName = $env:COMPUTERNAME
    )
    $List = @()
    foreach ($Computer in $ComputerName) {
        $Output = get-windowsfeature -ComputerName $Computer |  Where-Object {$_.installed -eq $true -and $_.featuretype -eq 'Role'} |  select name, installed -ExcludeProperty subfeatures
        $List += $Output | Select name, installed , @{name = 'Server Name'; expression = {$Computer}}
    }
    return $List
}
function Get-SqlQueryColumnInformation {
    [CmdletBinding()]
    param (
        [string] $SqlServer,
        [string] $SqlDatabase,
        [string] $Table
    )
    $Table = $Table.Replace("dbo.", '').Replace('[', '').Replace(']', '') # removes dbo and [] from dbo.[Table] as INFORMATION_SCHEMA expects it without
    $SqlDatabase = $SqlDatabase.Replace('[', '').Replace(']', '') # makes sure we know what we have
    $SqlDatabase = "[$SqlDatabase]"
    $Query = "SELECT * FROM $SqlDatabase.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$Table'"
    $SqlReturn = @(
        try {
            Invoke-DbaQuery -ErrorAction Stop -ServerInstance $SqlServer -Query $Query #-Verbose
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            "Error occured (Get-SqlQueryColumnInformation): $ErrorMessage" # return of error
        }
    )
    return $SQLReturn
}
function Get-TemporaryDirectory {
    param(

    )
    $TemporaryFolder = Get-RandomStringName -Size 13 -LettersOnly -ToLower
    $TemporaryPath = [system.io.path]::GetTempPath()
    $Output = New-Item -ItemType Directory -Path $TemporaryPath -Name $TemporaryFolder -Force
    if (Test-Path -LiteralPath $Output.FullName) {
        $Output
    }
}
function Get-TimeSynchronization {
    param(

    )
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient

}




<#
w32tm /config /manualpeerlist:"0.uk.pool.ntp.org,0x1 1.uk.pool.ntp.org,0x1 2.uk.pool.ntp.org,0x1 3.uk.pool.ntp.org,0x1"
w32tm /config /reliable:yes
Restart-Service -Name 'w32time'
#>

<#
w32tm /resync /nowait
w32tm /query /configuration
w32tm /query /source
w32tm /query /peers
w32tm /query /status
w32tm /config /syncfromflags:domhier /update
#>

<#
    net stop w32time
    w32tm /unregister
    w32tm /register
    net start w32time
#>
<#
$Servers = 'localhost','127.0.0.1'

$w32tm = Invoke-Command -Computer $Servers -ArgumentList $Servers -Scriptblock {
    Param ($Servers)
    Foreach ($Server in $Servers)
    {
        $Check = w32tm /monitor /computers:$Server /nowarn
        $ICMP = (($Check | Select-String "ICMP")-Replace "ICMP: " , "").Trim()
        $ICMPVal = [int]($ICMP -split "ms")[0]
        $Source = w32tm /query /source
        $Name = Hostname

        Switch ($ICMPVal)
            {
                {$ICMPVal -le 0} {$Status = "Optimal time synchronisation"}
                #you probably need another value here since you'll get no status if it is between 0 and 2m
                {$ICMPVal -lt 100000} {$Status = "0-2 Minute time difference"}
                {$ICMPVal -ge 100000} {$Status = "Warning, 2 minutes time difference"}
                {$ICMPVal -ge 300000} {$Status = "Critical. Over 5 minutes time difference!"}
            }
        $String = $Name + " - $Status " + "- $ICMP " + " - Source: $Source"
        Write-Output $String
    }
}

$w32tm
#>
function Get-TimeZoneAdvanced {
    param(
        [string[]]$ComputerName = $Env:COMPUTERNAME,
        [System.Management.Automation.PSCredential] $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    foreach ($computer in $computerName) {
        $TimeZone = Get-WmiObject -Class win32_timezone -ComputerName $computer -Credential $Credential
        $LocalTime = Get-WmiObject -Class win32_localtime -ComputerName $computer -Credential $Credential
        $Output = @{
            'ComputerName' = $localTime.__SERVER;
            'TimeZone'     = $timeZone.Caption;
            'CurrentTime'  = (Get-Date -Day $localTime.Day -Month $localTime.Month);
        }
        $Object = New-Object -TypeName PSObject -Property $Output
        Write-Output $Object
    }
}
function Get-TimeZoneLegacy () {
    return ([System.TimeZone]::CurrentTimeZone).StandardName
}
Function Get-Types {
    [CmdletBinding()]
    param (
        [Object] $Types
    )
    $TypesRequired = @()
    foreach ($Type in $Types) {
        #Write-Verbose "Type: $Type"
        $TypesRequired += $Type.GetEnumValues()
    }
    return $TypesRequired
}
function Get-WinADForestControllers {
    [alias('Get-WinADDomainControllers')]
    <#
    .SYNOPSIS


    .DESCRIPTION
    Long description

    .PARAMETER TestAvailability
    Parameter description

    .EXAMPLE
    Get-WinADForestControllers -TestAvailability | Format-Table

    .EXAMPLE
    Get-WinADDomainControllers

    .EXAMPLE
    Get-WinADDomainControllers | Format-Table *

    Output:

    Domain        HostName          Forest        IPV4Address     IsGlobalCatalog IsReadOnly SchemaMaster DomainNamingMasterMaster PDCEmulator RIDMaster InfrastructureMaster Comment
    ------        --------          ------        -----------     --------------- ---------- ------------ ------------------------ ----------- --------- -------------------- -------
    ad.evotec.xyz AD1.ad.evotec.xyz ad.evotec.xyz 192.168.240.189            True      False         True                     True        True      True                 True
    ad.evotec.xyz AD2.ad.evotec.xyz ad.evotec.xyz 192.168.240.192            True      False        False                    False       False     False                False
    ad.evotec.pl                    ad.evotec.xyz                                                   False                    False       False     False                False Unable to contact the server. This may be becau...

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [switch] $TestAvailability,
        [switch] $SkipEmpty
    )
    try {
        $Forest = Get-ADForest
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning "Get-WinADForestControllers - Couldn't use Get-ADForest feature. Error: $ErrorMessage"
        return
    }
    $Servers = foreach ($D in $Forest.Domains) {
        try {
            $DC = Get-ADDomainController -Server $D -Filter *
            foreach ($S in $DC) {
                [PSCustomObject]@{
                    Domain                   = $D
                    HostName                 = $S.HostName
                    Forest                   = $Forest.RootDomain
                    IPV4Address              = $S.IPV4Address
                    IPV6Address              = $S.IPV6Address
                    IsGlobalCatalog          = $S.IsGlobalCatalog
                    IsReadOnly               = $S.IsReadOnly
                    Site                     = $S.Site
                    SchemaMaster             = ($S.OperationMasterRoles -contains 'SchemaMaster')
                    DomainNamingMasterMaster = ($S.OperationMasterRoles -contains 'DomainNamingMaster')
                    PDCEmulator              = ($S.OperationMasterRoles -contains 'PDCEmulator')
                    RIDMaster                = ($S.OperationMasterRoles -contains 'RIDMaster')
                    InfrastructureMaster     = ($S.OperationMasterRoles -contains 'InfrastructureMaster')
                    LdapPort                 = $S.LdapPort
                    SslPort                  = $S.SslPort
                    Comment                  = ''
                }
            }
        } catch {
            [PSCustomObject]@{
                Domain                   = $D
                HostName                 = ''
                Forest                   = $Forest.RootDomain
                IPV4Address              = ''
                IPV6Address              = ''
                IsGlobalCatalog          = ''
                IsReadOnly               = ''
                Site                     = ''
                SchemaMaster             = $false
                DomainNamingMasterMaster = $false
                PDCEmulator              = $false
                RIDMaster                = $false
                InfrastructureMaster     = $false
                LdapPort                 = ''
                SslPort                  = ''
                Comment                  = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            }
        }
    }
    if ($TestAvailability) {
        foreach ($Server in $Servers) {
            if ($Server.IPV4Address -ne '') {
                $Output = Test-Connection -Count 1 -Server $Server.IPV4Address -Quiet -ErrorAction SilentlyContinue
                Add-Member -InputObject $Server -MemberType NoteProperty -Name 'Pingable' -Value $Output
            } else {
                Add-Member -InputObject $Server -MemberType NoteProperty -Name 'Pingable' -Value $false
            }
        }
    }
    if ($SkipEmpty) {
        return $Servers | Where-Object { $_.HostName -ne '' }
    }
    return $Servers
}
#Require -Version 3
#Require -Module ActiveDirectory
Function Get-WinADForestOptions {
    <#
    .SYNOPSIS
        This Cmdlet gets Active Directory Site Options.
    .DESCRIPTION
        This Cmdlet gets Active Directory Site Options.
        We can fill out the rest of this comment-based help later.
    .LINK
        http://myotherpcisacloud.com

    .LINK
        https://serverfault.com/questions/543143/detecting-ad-site-options-using-powershell

    .NOTES
        Written by Ryan Ries, October 2013. ryanries09@gmail.com.
    #>
    [CmdletBinding()]
    Param()
    BEGIN {
        # This enum comes from NtDsAPI.h in the Windows SDK.
        # Also thanks to Jason Scott for pointing it out to me. http://serverfault.com/users/23067/jscott
        Add-Type -TypeDefinition @"
                                   [System.Flags]
                                   public enum nTDSSiteSettingsFlags {
                                   NTDSSETTINGS_OPT_IS_AUTO_TOPOLOGY_DISABLED            = 0x00000001,
                                   NTDSSETTINGS_OPT_IS_TOPL_CLEANUP_DISABLED             = 0x00000002,
                                   NTDSSETTINGS_OPT_IS_TOPL_MIN_HOPS_DISABLED            = 0x00000004,
                                   NTDSSETTINGS_OPT_IS_TOPL_DETECT_STALE_DISABLED        = 0x00000008,
                                   NTDSSETTINGS_OPT_IS_INTER_SITE_AUTO_TOPOLOGY_DISABLED = 0x00000010,
                                   NTDSSETTINGS_OPT_IS_GROUP_CACHING_ENABLED             = 0x00000020,
                                   NTDSSETTINGS_OPT_FORCE_KCC_WHISTLER_BEHAVIOR          = 0x00000040,
                                   NTDSSETTINGS_OPT_FORCE_KCC_W2K_ELECTION               = 0x00000080,
                                   NTDSSETTINGS_OPT_IS_RAND_BH_SELECTION_DISABLED        = 0x00000100,
                                   NTDSSETTINGS_OPT_IS_SCHEDULE_HASHING_ENABLED          = 0x00000200,
                                   NTDSSETTINGS_OPT_IS_REDUNDANT_SERVER_TOPOLOGY_ENABLED = 0x00000400,
                                   NTDSSETTINGS_OPT_W2K3_IGNORE_SCHEDULES                = 0x00000800,
                                   NTDSSETTINGS_OPT_W2K3_BRIDGES_REQUIRED                = 0x00001000  }
"@
        ForEach ($Site In (Get-ADObject -Filter 'objectClass -eq "site"' -Searchbase (Get-ADRootDSE).ConfigurationNamingContext)) {
            $SiteSettings = Get-ADObject "CN=NTDS Site Settings,$($Site.DistinguishedName)" -Properties Options
            If (!$SiteSettings.PSObject.Properties.Match('Options').Count -OR $SiteSettings.Options -EQ 0) {
                # I went with '(none)' here to give it a more classic repadmin.exe feel.
                # You could also go with $Null, or omit the property altogether for a more modern, Powershell feel.
                [PSCustomObject]@{
                    SiteName          = $Site.Name
                    DistinguishedName = $Site.DistinguishedName
                    SiteOptions       = '(none)'
                }
            } Else {
                [PSCustomObject]@{
                    SiteName          = $Site.Name
                    DistinguishedName = $Site.DistinguishedName
                    SiteOptions       = [Enum]::Parse('nTDSSiteSettingsFlags', $SiteSettings.Options)
                }
            }
        }
    }
}
function Get-WinADOrganizationalUnitData {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER OrganizationalUnit
    Parameter description

    .EXAMPLE
    An example

    Get-WinADOrganizationalUnitData -OrganizationalUnit 'OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz'



    .NOTES
    Output of function:
        CanonicalName                   : ad.evotec.xyz/Production/Users-O365
        City                            :
        CN                              :
        Country                         : PL
        Created                         : 09.11.2018 17:38:32
        Description                     : OU for Synchronization of Users to Office 365
        DisplayName                     :
        DistinguishedName               : OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz
        LinkedGroupPolicyObjects        : {cn={74D09C6F-35E9-4743-BCF7-F87D7010C60D},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz}
        ManagedBy                       :
        Modified                        : 19.11.2018 22:54:47
        Name                            : Users-O365
        PostalCode                      :
        ProtectedFromAccidentalDeletion : True
        State                           :
        StreetAddress                   :

    #>
    [CmdletBinding()]
    param(
        [string[]] $OrganizationalUnit
    )
    $Output = foreach ($OU in $OrganizationalUnit) {
        $Data = Get-ADOrganizationalUnit -Identity $OU -Properties CanonicalName, City, CN, Country, Created, Description, DisplayName, DistinguishedName, ManagedBy, Modified, Name, OU, PostalCode, ProtectedFromAccidentalDeletion, State, StreetAddress

        [PsCustomobject][Ordered] @{
            CanonicalName                   = $Data.CanonicalName
            City                            = $Data.City
            CN                              = $Data.CN
            Country                         = $Data.Country
            Created                         = $Data.Created
            Description                     = $Data.Description
            DisplayName                     = $Data.DisplayName
            DistinguishedName               = $Data.DistinguishedName
            LinkedGroupPolicyObjects        = $Data.LinkedGroupPolicyObjects
            ManagedBy                       = Get-WinADUsersByDN -DistinguishedName $U.ManagedBy
            Modified                        = $Data.Modified
            Name                            = $Data.Name
            PostalCode                      = $Data.PostalCode
            ProtectedFromAccidentalDeletion = $Data.ProtectedFromAccidentalDeletion
            State                           = $Data.State
            StreetAddress                   = $Data.StreetAddress
        }
    }
    return $Output
}
function Get-WinADOrganizationalUnitFromDN {
    <#
    .SYNOPSIS


    .DESCRIPTION
    Long description

    .PARAMETER DistinguishedName
    Parameter description

    .EXAMPLE
    An example

    $DistinguishedName = 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'
    Get-WinADOrganizationalUnitFromDN -DistinguishedName $DistinguishedName

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        $DistinguishedName
    )
    return [Regex]::Match($DistinguishedName,'(?=OU)(.*\n?)(?<=.)').Value
}
function Get-WinADUsersByDN {
    param(
        [alias('DN')][string[]]$DistinguishedName,
        [string] $Field = 'DisplayName', # return field
        [switch] $All
    )
    $Properties = 'DistinguishedName', 'Enabled', 'GivenName', 'Name', 'SamAccountName', 'SID', 'Surname', 'UserPrincipalName', 'EmailAddress', 'DisplayName'

    $Users = foreach ($DN in $DistinguishedName) {
        try {
            get-aduser -Identity $DN -Properties $Properties
        } catch {
            # returns empty, basically ignores stuff
        }
    }

    if ($All) {
        return $Users #.PSObject.Properties.Name
    } else {
        return $Users.$Field
    }
}
function Get-WinADUsersByOU {
    [CmdletBinding()]
    param (
        $OrganizationalUnit
    )
    $OU = Get-ADOrganizationalUnit $OrganizationalUnit
    if ($OU.ObjectClass -eq 'OrganizationalUnit') {
        try {
            $Users = Get-ADUser -SearchBase $OU -Filter * -Properties $Script:UserProperties
        } catch {
            Write-Color @Script:WriteParameters -Text '[i]', ' One or more properties are invalid - Terminating', ' Terminating' -Color Yellow, White, Red
            return
        }
    }
    return $Users
}
function Get-WinADUserSnapshot {
    [CmdletBinding()]
    [alias("Get-ADUserSnapshot")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [string] $XmlPath,
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $FullData = Get-ADUser -Identity $User.DistinguishedName -Properties *
        if (($XmlPath) -and (Test-Path $XmlPath)) {
            $FullPath = [IO.Path]::Combine($XmlPath, "$($User.SamAccountName).xml") #
            if (-not $WhatIf) {
                $FullData | Export-Clixml -Path $FullPath -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Saved to $FullPath" }

        } else {
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = 'XmlPath Incorrect' }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
    }
    return $Object
}
function Install-ApplicationClickOnce {
    [CmdletBinding()]
    Param(
        [string] $Manifest,
        [switch] $ElevatePermissions
    )
    Try {

        Add-Type -AssemblyName System.Deployment

        Write-Verbose "Install-ApplicationClickOnce - Start installation of ClickOnce Application $Manifest"

        $RemoteURI = [URI]::New( $Manifest , [UriKind]::Absolute)
        if (-not $Manifest) {
            Write-Warning "Invalid Manifest (URL) parameter $RemoteURI"
            return
        }

        $HostingManager = New-Object System.Deployment.Application.InPlaceHostingManager -ArgumentList $RemoteURI , $False

        #register an event to trigger custom event (yep, its a hack)
        $null = Register-ObjectEvent -InputObject $HostingManager -EventName GetManifestCompleted -Action {
            new-event -SourceIdentifier "ManifestDownloadComplete"
        }
        #register an event to trigger custom event (yep, its a hack)
        $null = Register-ObjectEvent -InputObject $HostingManager -EventName DownloadApplicationCompleted -Action {
            new-event -SourceIdentifier "DownloadApplicationCompleted"
        }

        #get the Manifest
        $HostingManager.GetManifestAsync()

        #Waitfor up to 5s for our custom event
        $event = Wait-Event -SourceIdentifier "ManifestDownloadComplete" -Timeout 5
        if ($event ) {
            $event | Remove-Event
            Write-Verbose "Install-ApplicationClickOnce - ClickOnce Manifest Download Completed"

            $HostingManager.AssertApplicationRequirements($ElevatePermissions)
            #todo :: can this fail ?

            #Download Application
            $HostingManager.DownloadApplicationAsync()
            #register and wait for completion event
            # $HostingManager.DownloadApplicationCompleted
            $event = Wait-Event -SourceIdentifier "DownloadApplicationCompleted" -Timeout 15
            if ($event ) {
                $event | Remove-Event
                Write-Verbose "Install-ApplicationClickOnce - ClickOnce Application Download Completed"
            } else {
                Write-Error "Install-ApplicationClickOnce - ClickOnce Application Download did not complete in time (15s)"
            }
        } else {
            Write-Error "Install-ApplicationClickOnce - ClickOnce Manifest Download did not complete in time (5s)"
        }

        #Clean Up
    } finally {
        #get rid of our eventhandlers
        Get-EventSubscriber| Where-Object {$_.SourceObject.ToString() -eq 'System.Deployment.Application.InPlaceHostingManager'} | Unregister-Event
    }
}
function Install-WinConnectity {
    [CmdletBinding()]
    param(
        [ValidateSet('MSOnline', 'AzureAD', 'SharePoint', 'ExchangeOnline' )][string[]] $Module,
        [switch] $All,
        [switch] $Force
    )

    $Splat = @{
        Force = $Force
    }

    if ($Module -eq 'MSOnline' -or $All) {
        Write-Verbose "Installing MSOnline Powershell Module"
        Install-Module -Name MSOnline
    }
    if ($Module -eq 'AzureAD' -or $All) {
        Write-Verbose "Installing AzureAD Powershell Module"
        Install-Module -Name AzureAD
    }
    #Install-Module SkypeOnlineConnector
    if ($Module -eq 'SharePoint' -or $All) {
        Write-Verbose "Installing Microsoft SharePoint Online Powershell Module"
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell
    }
    if ($Module -eq 'ExchangeOnline' -or $All) {
        Write-Verbose "Checking for Microsoft Exchange Online Powershell Module"
        $App = Test-InstalledApplication -DisplayName "Microsoft Exchange Online Powershell Module"
        if ($null -eq $App) {
            # Manifest for Exchange Online Click Once App
            Write-Verbose "Installing Microsoft Exchange Online Powershell Module"
            Install-ApplicationClickOnce -Manifest "https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application" -ElevatePermissions
        }
    }
}
function Merge-Array {
    <#
    .SYNOPSIS
    Merge-Array allows to merge two or more arrays together. 
    
    .DESCRIPTION
    Merge-Array allows to merge two or more arrays together. It copies headers from each Array and merges them together allowing for fulll output. 
    When used with Prescan parameter it actually is able to show headers from all arrays
    
    .PARAMETER Array
    List of Arrays to process
    
    .PARAMETER Prescan
    Scans each element of each array for headers. 
    
    .EXAMPLE
    $Array1 = @(
        [PSCustomObject] @{ Name = 'Company1'; Count = 259  }
        [PSCustomObject] @{ Name = 'Company2'; Count = 300 }
    )
    $Array2 = @(
        [PSCustomObject] @{ Name = 'Company1'; Count = 25 }
        [PSCustomObject] @{ Name = 'Company2'; Count = 100 }
    )
    $Array3 = @(
        [PSCustomObject] @{ Name1 = 'Company1'; Count3 = 25 }
        [PSCustomObject] @{ Name1 = 'Company2'; Count3 = 100 }
        [PSCustomObject] @{ Name2 = 'Company2'; Count3 = 100 }
    )

    $Array1 | Format-Table -AutoSize
    $Array2 | Format-Table -AutoSize
    $Array3 | Format-Table -AutoSize

    Merge-Array -Array $Array1, $Array2, $Array3 | Format-Table -AutoSize
    Merge-Array -Array $Array1, $Array2, $Array3 -Prescan | Format-Table -AutoSize
    
    .NOTES
    General notes
    #>
    
    param(
        [Array[]] $Array,
        [switch] $Prescan
    )
    $PropertyNames = foreach ($A in $Array) {
        if ($Prescan) {
            foreach ($O in $A) {
                $O.PSObject.Properties.Name
            }
        } else {
            $A[0].PSObject.Properties.Name
        }
    } 
    $PropertyNames = $PropertyNames | Sort-Object -Unique
    foreach ($A in $Array) {
        $A | Select-Object -Property $PropertyNames
    }
}
<#
$FoundUser1 = [pscustomobject] @{
    'Duplicate Group1' = 'test1'
    'User2'            = 'test2'
}

$FoundUser2 = [pscustomobject] @{
    'Duplicate Group2' = 'test3'
    'User1'            = 'test4'
}

Merge-Objects -Object1 $FoundUser1 -Object2 $FoundUser2
#>
function Merge-Objects {
    [CmdletBinding()]
    param (
        [Object] $Object1,
        [Object] $Object2
    )
    $Object = [ordered] @{}
    foreach ($Property in $Object1.PSObject.Properties) {
        $Object.($Property.Name) = $Property.Value

    }
    foreach ($Property in $Object2.PSObject.Properties) {
        $Object.($Property.Name) = $Property.Value
    }
    return [pscustomobject] $Object
}
function New-ArrayList {
    [CmdletBinding()]
    param()
    $List = [System.Collections.ArrayList]::new()
    <#
    Mathias Rørbo Jessen:
        The pipeline will attempt to unravel the list on assignment,
        so you'll have to either wrap the empty arraylist in an array,
        like above, or call WriteObject explicitly and tell it not to, like so:
        $PSCmdlet.WriteObject($List,$false)
    #>
    return , $List
}
function New-GenericList {
    [CmdletBinding()]
    param(
        [Object] $Type = [System.Object]
    )
    return New-Object "System.Collections.Generic.List[$Type]"
}
function New-Runspace {
    [cmdletbinding()]
    param (
        [int] $minRunspaces = 1,
        [int] $maxRunspaces = [int]$env:NUMBER_OF_PROCESSORS + 1
    )
    $RunspacePool = [RunspaceFactory]::CreateRunspacePool($minRunspaces, $maxRunspaces)
    #ApartmentState is not available in PowerShell 6+
    #$RunspacePool.ApartmentState = "MTA"
    $RunspacePool.Open()
    return $RunspacePool
}
function New-SqlQuery {
    [CmdletBinding()]
    param (
        [Object] $SqlSettings,
        [Object] $Object,
        [Object] $TableMapping
    )
    <#
    Example on how output looks like:
    IF NOT EXISTS (
        SELECT 1 FROM dbo.[EventsLogsClearedSecurity] WHERE [RecordID] = '2434391'
        )
    BEGIN
        --INSERT INTO Users (FirstName, LastName) VALUES ('John', 'Smith')
        INSERT INTO  dbo.[EventsLogsClearedSecurity] ( [DomainController],[Action],[BackupPath],[LogType],[Who],[When],[EventID],[RecordID],[AddedWhen],[AddedWho] ) VALUES ( 'AD1.ad.evotec.xyz','Event log automatic backup','C:\Windows\System32\Winevt\Logs\Archive-Security-2018-09-25-14-12-52-658.evtx','Security','Automatic Backup','2018-09-25 16:12:53','1105','2434391','2018-09-25 20:49:02','przemyslaw.klys' )
    END
    #>
    $ArraySQLQueries = New-ArrayList
    if ($null -ne $Object) {
        ## Added fields to know when event was added to SQL and by WHO (in this case TaskS Scheduler User)
        ## Only adding when $Object exists
        foreach ($O in $Object) {
            $ArrayMain = New-ArrayList
            $ArrayKeys = New-ArrayList
            $ArrayValues = New-ArrayList

            if (-not $O.AddedWhen) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWhen" -Value (Get-Date)
            }
            if (-not $O.AddedWho) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWho" -Value ($Env:USERNAME)
            }
            $DuplicateString = [System.Text.StringBuilder]::new()
            foreach ($E in $O.PSObject.Properties) {
                $FieldName = $E.Name
                $FieldValue = $E.Value

                foreach ($MapKey in $TableMapping.Keys) {
                    if ($FieldName -eq $MapKey) {
                        $MapValue = $TableMapping.$MapKey
                        $MapValueSplit = $MapValue -Split ','



                        if ($FieldValue -is [DateTime]) { $FieldValue = Get-Date $FieldValue -Format "yyyy-MM-dd HH:mm:ss" }
                        if ($FieldValue -like "*'*") { $FieldValue = $FieldValue -Replace "'", "''" }
                        Add-ToArray -List $ArrayKeys -Element "[$($MapValueSplit[0])]"
                        if ([string]::IsNullOrWhiteSpace($FieldValue)) {

                            Add-ToArray -List $ArrayValues -Element "NULL"
                        } else {
                            foreach ($ColumnName in $SqlSettings.SqlCheckBeforeInsert) {
                                $DuplicateColumn = $ColumnName.Replace("[", '').Replace("]", '') # Remove [ ] for comparision

                                if ($MapValueSplit[0] -eq $DuplicateColumn) {
                                    if ($DuplicateString.Length -ne 0) {
                                        # Means something is already in string so most likely 2nd run
                                        $null = $DuplicateString.Append(" AND ")
                                    }
                                    $null = $DuplicateString.Append("[$DuplicateColumn] = '$FieldValue'")
                                    
                                }
                            }
                            Add-ToArray -List $ArrayValues -Element "'$FieldValue'"
                        }
                    }
                }
            }
            if ($ArrayKeys) {
                if ($null -ne $SqlSettings.SqlCheckBeforeInsert -and $DuplicateString.Length -gt 0) {
                    Add-ToArray -List $ArrayMain -Element "IF NOT EXISTS ("
                    Add-ToArray -List $ArrayMain -Element "SELECT 1 FROM "
                    Add-ToArray -List $ArrayMain -Element "$($SqlSettings.SqlTable) "
                    Add-ToArray -List $ArrayMain -Element "WHERE $($DuplicateString.ToString())"
                    Add-ToArray -List $ArrayMain -Element ")"
                }
                Add-ToArray -List $ArrayMain -Element "BEGIN"
                Add-ToArray -List $ArrayMain -Element "INSERT INTO  $($SqlSettings.SqlTable) ("
                Add-ToArray -List $ArrayMain -Element ($ArrayKeys -join ',')
                Add-ToArray -List $ArrayMain -Element ') VALUES ('
                Add-ToArray -List $ArrayMain -Element ($ArrayValues -join ',')
                Add-ToArray -List $ArrayMain -Element ')'
                Add-ToArray -List $ArrayMain -Element "END"
                Add-ToArray -List $ArraySQLQueries -Element ([string] ($ArrayMain) -replace "`n", "" -replace "`r", "")
            }
        }
    }
    return $ArraySQLQueries
}
function New-SqlQueryAlterTable {
    [CmdletBinding()]
    param (
        [Object]$SqlSettings,
        [Object]$TableMapping,
        [string[]] $ExistingColumns
    )
    $ArraySQLQueries = New-ArrayList
    $ArrayMain = New-ArrayList
    $ArrayKeys = New-ArrayList

    foreach ($MapKey in $TableMapping.Keys) {
        $MapValue = $TableMapping.$MapKey
        $Field = $MapValue -Split ','


        if ($ExistingColumns -notcontains $MapKey -and $ExistingColumns -notcontains $Field[0]) {
            if ($Field.Count -eq 1) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] [nvarchar](max) NULL"
            } elseif ($Field.Count -eq 2) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) NULL"
            } elseif ($Field.Count -eq 3) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) $($Field[2])"
            }
        }
    }

    if ($ArrayKeys) {
        Add-ToArray -List $ArrayMain -Element "ALTER TABLE $($SqlSettings.SqlTable) ADD"
        Add-ToArray -List $ArrayMain -Element ($ArrayKeys -join ',')
        Add-ToArray -List $ArrayMain -Element ';'
        Add-ToArray -List $ArraySQLQueries -Element ([string] ($ArrayMain) -replace "`n", "" -replace "`r", "")
    }
    return $ArraySQLQueries
}
function New-SqlQueryCreateTable {
    [CmdletBinding()]
    param (
        [Object]$SqlSettings,
        [Object]$TableMapping
    )
    $ArraySQLQueries = New-ArrayList
    $ArrayMain = New-ArrayList
    $ArrayKeys = New-ArrayList

    foreach ($MapKey in $TableMapping.Keys) {
        $MapValue = $TableMapping.$MapKey
        $Field = $MapValue -Split ','
        if ($Field.Count -eq 1) {
            Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] [nvarchar](max) NULL"
        } elseif ($Field.Count -eq 2) {
            Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) NULL"
        } elseif ($Field.Count -eq 3) {
            Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) $($Field[2])"
        }
    }
    if ($ArrayKeys) {
        Add-ToArray -List $ArrayMain -Element "CREATE TABLE $($SqlSettings.SqlTable) ("
        Add-ToArray -List $ArrayMain -Element "ID int IDENTITY(1,1) PRIMARY KEY,"
        Add-ToArray -List $ArrayMain -Element ($ArrayKeys -join ',')
        Add-ToArray -List $ArrayMain -Element ')'
        Add-ToArray -List $ArraySQLQueries -Element ([string] ($ArrayMain) -replace "`n", "" -replace "`r", "")
    }
    return $ArraySQLQueries
}
function New-SqlTableMapping {
    [CmdletBinding()]
    param(
        [Object] $SqlTableMapping,
        [Object] $Object,
        $Properties,
        [switch] $BasedOnSqlTable
    )
    if ($SqlTableMapping) {
        $TableMapping = $SqlTableMapping
    } else {
        $TableMapping = @{}
        if ($BasedOnSqlTable) {
            foreach ($Property in $Properties) {
                $FieldName = $Property
                $FieldNameSql = $Property
                $TableMapping.$FieldName = $FieldNameSQL
            }
        } else {
            # Gets the highest object
            foreach ($O in $Properties.HighestObject) {
                # goes thru properties (but not properties of highest object but for all properties of all objects
                # if there is value it will use the ones from highest object if not it will utilize nvarchar

                foreach ($Property in $Properties.Properties) {

                    #foreach ($E in $O.PSObject.Properties) {
                    $FieldName = $Property
                    $FieldValue = $O.$Property

                    $FieldNameSQL = $FieldName.Replace(' ', '') #.Replace('-', '')

                    if ($FieldValue -is [DateTime]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[datetime],null"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: DateTime"
                    } elseif ($FieldValue -is [int] -or $FieldValue -is [Int64]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bigint]"
                        # Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: BigInt"
                    } elseif ($FieldValue -is [bool]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bit]"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: Bit/Bool"
                    } else {
                        $TableMapping.$FieldName = "$FieldNameSQL"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: NvarChar"
                    }
                }
            }
        }
    }
    #Write-Verbose 'New-SqlTableMapping - Ending'
    return $TableMapping
}
function New-UserAdd {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        $Users
    )

    $Success = @()
    $Failed = @()
    $Output = @()
    foreach ($User in $Users) {
        #New-MsolUser -UserPrincipalName $User.UserPrincipalName -FirstName $User.FirstName -LastName $User.LastName -DisplayName $User.DisplayName -UsageLocation $User.CountryCode -Country $User.Country -City $User.City -WhatIf
        $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
        $PasswordProfile.Password = $User.Password
        $PasswordProfile.EnforceChangePasswordPolicy = $false
        $PasswordProfile.ForceChangePasswordNextLogin = $false


        try {
            if ($pscmdlet.ShouldProcess("$($User.DisplayName)", "New-UserAdd")) {
                Write-Color "New-AzureADUser - Processing new user ", $User.DisplayName -Color White, Yellow
                if ($User.MailNickName) {

                    if ($User.FirstName -eq $null -or $User.FirstName.Trim() -eq '') {
                        $User.FirstName = 'Not set'
                    }
                    if ($User.LastName -eq $null -or $User.LastName.Trim() -eq '') {
                        $User.LastName = 'Not set'
                    }
                    $Output += New-AzureADUser -UserPrincipalName $User.UserPrincipalName `
                        -GivenName ([string] $User.FirstName) `
                        -Surname ([string] $User.LastName) `
                        -DisplayName ([string] $User.DisplayName) `
                        -UsageLocation ([string] $User.CountryCode) `
                        -Country ([string] $User.Country) `
                        -City ([string] $User.City) `
                        -PasswordProfile $PasswordProfile `
                        -AccountEnabled $true `
                        -MailNickName ([string] $User.MailNickName) `
                        -ErrorAction Stop

                    $Success += $User
                } else {
                    $Failed += $User
                }
            } else {
                # pretends WhatIf all success
                $Success += $User
            }
        } catch {
            $Failed += $User
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning "New-AzureADUser - Failed with error message: $ErrorMessage"
        }
    }
    $Data = @{}
    $Data.Failed = $Failed
    $Data.Success = $Success
    return $Data
}
function Remove-DuplicateObjects {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Object
    Parameter description
    
    .PARAMETER Property
    Parameter description
    
    .EXAMPLE    
    $Array = @()
    $Array += [PSCustomObject] @{ 'Name' = 'Test'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test1'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test1'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}

    Write-Color 'Before' -Color Red
    $Array | Format-Table -A

    Write-Color 'After' -Color Green
    $Array = $Array | Sort-Object -Unique -Property 'Name', 'Val1','Val2'
    $Array | Format-Table -AutoSize
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string[]] $Property
    )
    $Count = Get-ObjectCount -Object $Object
    if ($Count -eq 0) {
        return $Object
    } else {
        return $Object | Sort-Object -Property $Property -Unique
    }
}
function Remove-FilePermission {
    [alias('Remove-Permission')]
    param(
        [string] $StartingDir,
        [string] $UserOrGroup = "",
        [switch] $All
    )
    $acl = get-acl -Path $StartingDir
    if ($UserOrGroup -ne "") {
        foreach ($access in $acl.Access) {
            if ($access.IdentityReference.Value -eq $UserOrGroup) {
                $acl.RemoveAccessRule($access) | Out-Null
            }
        }
    }
    if ($All -eq $true) {
        foreach ($access in $acl.Access) {
            $acl.RemoveAccessRule($access) | Out-Null
        }

    }
    Set-Acl -Path $folder.FullName -AclObject $acl
}
function Remove-FromArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $LastElement
    )
    if ($LastElement) {
        $LastID = $List.Count - 1
        $List.RemoveAt($LastID) > $null
    } else {
        $List.Remove($Element) > $null
    }
}
function Remove-ObjectsExistingInTarget {
    param(
        $ObjectSource,
        $ObjectTarget,
        [string] $ComparePropertySource,
        [string] $ComparePropertyTarget,
        [switch] $Reverse # returns only existing objects
    )
    $ObjectsExistingInTarget = @()
    $ObjectsNotExistingInTarget = @()
    foreach ($Object in $ObjectSource) {
        if ($ObjectTarget.$ComparePropertySource -contains $Object.$ComparePropertyTarget) {
            $ObjectsExistingInTarget += $Object
        } else {
            $ObjectsNotExistingInTarget += $Object
        }
    }
    if ($Reverse) {
        return $ObjectsExistingInTarget
    } else {
        return $ObjectsNotExistingInTarget
    }
}
function Remove-WhiteSpace {
    param(
        [string] $Text
    )
    $Text = $Text -replace '(^\s+|\s+$)','' -replace '\s+',' '
    return $Text
}
<#
$MyValue = Remove-WhiteSpace -Text 'My Field  '
Write-Color $MyValue, 'No' -Color White, Yellow

#>
function Remove-WinADUserGroups {
    [CmdletBinding()]
    [alias("Remove-ADUserGroups")]
    param(
        [parameter(Mandatory = $true)][Object] $User,
        [ValidateSet("Distribution", "Security")][String] $GroupCategory ,
        [ValidateSet("DomainLocal", "Global", "Universal")][String] $GroupScope,
        [string[]] $Groups,
        [switch] $All,
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $ADgroups = Get-ADPrincipalGroupMembership -Identity $User.DistinguishedName -ErrorAction Stop | Where-Object { $_.Name -ne "Domain Users" }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
    }
    if ($ADgroups) {
        if ($All) {
            #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups ', ($ADgroups.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow
            foreach ($Group in $ADgroups) {
                try {
                    if (-not $WhatIf) {
                        Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                    }
                    $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                }
            }
        }
        if ($GroupCategory) {
            $ADGroupsByCategory = $ADgroups | Where-Object { $_.GroupCategory -eq $GroupCategory }
            if ($ADGroupsByCategory) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by category - ', $GroupCategory, ") ", ($ADGroupsByCategory.Name -join ', '), ' from user ', $User.DisplayName -Colo White, Yellow, Green, White, Yellow, White, Blue
                foreach ($Group in $ADGroupsByCategory) {
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                }
            }
        }
        if ($GroupScope) {
            $ADGroupsByScope = $ADgroups | Where-Object { $_.GroupScope -eq $GroupScope }
            if ($ADGroupsByScope) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by scope ', " - $GroupScope) ", ($ADGroupsByScope.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow, White, Blue
                foreach ($Group in $ADGroupsByScope) {
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                }
            }
        }
        if ($Groups) {
            foreach ($Group in $Groups) {
                $ADGroupsByName = $ADgroups | Where-Object { $_.Name -like $Group }
                if ($ADGroupsByName) {
                    #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by name) ', ($ADGroupsByName.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow, White, Yellow
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $ADGroupsByName -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                } else {
                    $Object += @{ Status = $false; Output = $Group.Name; Extended = 'Not available on user.' }
                }
            }
        }
    }
    return $Object
}
Function Rename-LatinCharacters {
    [alias('Remove-StringLatinCharacters')]
    param (
        [string]$String
    )
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}
function Rename-UserValuesFromHash {
    [CmdletBinding()]
    param(
        $Users,
        $MatchData,
        $FieldTypes
    )
    <#
    foreach ($User in $DataFinland) {
        $User.UserPrincipalName = $($User.UserPrincipalName).ToLower().Replace('@test.com', '@newdomain.com')
        $User.License = $($User.License).ToLower().Replace('test:', 'newdomain:')
        $User.ProxyAddress = $(($User.ProxyAddress).ToLower()).Replace('@test.com', '@newdomain.com').Replace('@test.onmicrosoft.com', '@newdomain.onmicrosoft.com')
    }
    #>
    Write-Verbose "FieldTypes: $($FieldTypes -join ',')"
    foreach ($User in $Users) {
        foreach ($Match in $MatchData.Keys) {
            $Key = $Match
            $Value = $MatchData.$Match
            Write-Verbose "User: $($User.UserPrincipalName) Key: $Key Value: $Value"
            foreach ($Field in $FieldTypes) {
                if ($User.$Field) {
                    $User.$Field = $($User.$Field).ToLower().Replace($Key, $Value)
                }
            }
        }
    }
    return $Users
}
function Request-Credentials {
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output,
        [switch] $NetworkCredentials,
        [string] $Service
    )
    if ($FromFile) {
        if (($Password -ne '') -and (Test-Path $Password)) {
            # File is there and we are reading it into Password
            Write-Verbose "Request-Credentials - Reading password from file $Password"
            $Password = Get-Content -Path $Password
        } else {
            # File is not there or couldn't be read
            if ($Output) {
                $Object = @{ Status = $false; Output = $Service; Extended = 'File with password unreadable.' }
                return $Object
            } else {
                Write-Warning "Request-Credentials - Secure password from file couldn't be read. File not readable. Terminating."
                return
            }
        }
    }
    if ($AsSecure) {
        try {
            $NewPassword = $Password | ConvertTo-SecureString -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($ErrorMessage -like '*Key not valid for use in specified state*') {
                if ($Output) {
                    $Object = @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                    return $Object
                } else {
                    Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                    return
                }
            } else {
                if ($Output) {
                    $Object = @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                    return $Object
                } else {
                    Write-Warning -Message "Request-Credentials - $ErrorMessage"
                    return
                }
            }
        }

    } else {
        $NewPassword = $Password
    }

    if ($UserName -and $NewPassword) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $NewPassword)
            #Write-Verbose "Request-Credentials - Using AsSecure option with Username $Username and password: $NewPassword"
        } else {
            Try {
                $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                if ($ErrorMessage -like '*Key not valid for use in specified state*') {
                    if ($Output) {
                        $Object = @{ Status = $false; Output = $Service; Extended = "Couldn't use credentials provided. Most likely using credentials from other user/session/computer." }
                        return $Object
                    } else {
                        Write-Warning -Message "Request-Credentials - Couldn't use credentials provided. Most likely using credentials from other user/session/computer."
                        return
                    }
                } else {
                    if ($Output) {
                        $Object = @{ Status = $false; Output = $Service; Extended = $ErrorMessage }
                        return $Object
                    } else {
                        Write-Warning -Message "Request-Credentials - $ErrorMessage"
                        return
                    }
                }
            }
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
            #Write-Verbose "Request-Credentials - Using AsSecure option with Username $Username and password: $NewPassword converted to $SecurePassword"
        }
    } else {
        if ($Output) {
            $Object = @{ Status = $false; Output = $Service; Extended = 'Username or/and Password is empty' }
            return $Object
        } else {
            Write-Warning -Message 'Request-Credentials - UserName or Password are empty.'
            return
        }
    }
    if ($NetworkCredentials) {
        $RewritePassword = $Credentials.GetNetworkCredential()
        #Get-ObjectType $RewritePassword -VerboseOnly -Verbose
        return $RewritePassword
    } else {
        #Get-ObjectType $Credentials -VerboseOnly -Verbose
        return $Credentials
    }
}
Add-Type -TypeDefinition @"
public enum RGBColors {
    Black,
    Navy,
    DarkBlue,
    MediumBlue,
    Blue,
    DarkGreen,
    Green,
    Teal,
    DarkCyan,
    DeepSkyBlue,
    DarkTurquoise,
    MediumSpringGreen,
    Lime,
    SpringGreen,
    Aqua,
    Cyan,
    MidnightBlue,
    DodgerBlue,
    LightSeaGreen,
    ForestGreen,
    SeaGreen,
    DarkSlateGray,
    DarkSlateGrey,
    LimeGreen,
    MediumSeaGreen,
    Turquoise,
    RoyalBlue,
    SteelBlue,
    DarkSlateBlue,
    MediumTurquoise,
    Indigo,
    DarkOliveGreen,
    CadetBlue,
    CornflowerBlue,
    MediumAquamarine,
    DimGray,
    DimGrey,
    SlateBlue,
    OliveDrab,
    SlateGray,
    SlateGrey,
    LightSlateGray,
    LightSlateGrey,
    MediumSlateBlue,
    LawnGreen,
    Chartreuse,
    Aquamarine,
    Maroon,
    Purple,
    Olive,
    Grey,
    Gray,
    //Grey,
    SkyBlue,
    LightSkyBlue,
    BlueViolet,
    DarkRed,
    DarkMagenta,
    SaddleBrown,
    DarkSeaGreen,
    LightGreen,
    MediumPurple,
    DarkViolet,
    PaleGreen,
    DarkOrchid,
    YellowGreen,
    Sienna,
    Brown,
    DarkGray,
    DarkGrey,
    LightBlue,
    GreenYellow,
    PaleTurquoise,
    LightSteelBlue,
    PowderBlue,
    FireBrick,
    DarkGoldenrod,
    MediumOrchid,
    RosyBrown,
    DarkKhaki,
    Silver,
    MediumVioletRed,
    IndianRed,
    Peru,
    Chocolate,
    Tan,
    LightGray,
    LightGrey,
    Thistle,
    Orchid,
    Goldenrod,
    PaleVioletRed,
    Crimson,
    Gainsboro,
    Plum,
    BurlyWood,
    LightCyan,
    Lavender,
    DarkSalmon,
    Violet,
    PaleGoldenrod,
    LightCoral,
    Khaki,
    AliceBlue,
    Honeydew,
    Azure,
    SandyBrown,
    Wheat,
    Beige,
    WhiteSmoke,
    MintCream,
    GhostWhite,
    Salmon,
    AntiqueWhite,
    Linen,
    LightGoldenrodYellow,
    OldLace,
    Red,
    Fuchsia,
    Magenta,
    DeepPink,
    OrangeRed,
    Tomato,
    HotPink,
    Coral,
    DarkOrange,
    LightSalmon,
    Orange,
    LightPink,
    Pink,
    Gold,
    PeachPuff,
    NavajoWhite,
    Moccasin,
    Bisque,
    MistyRose,
    BlanchedAlmond,
    PapayaWhip,
    LavenderBlush,
    Seashell,
    Cornsilk,
    LemonChiffon,
    FloralWhite,
    Snow,
    Yellow,
    LightYellow,
    Ivory,
    White
}
"@
function Save-XML {
    param (
        [string] $FilePath,
        [System.Xml.XmlNode] $xml
    )
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    $writer = New-Object System.IO.StreamWriter($FilePath, $false, $utf8WithoutBom)
    $xml.Save( $writer )
    $writer.Close()
}
$Script:O365SKU = @{
    "O365_BUSINESS_ESSENTIALS"           = "Office 365 Business Essentials"
    "O365_BUSINESS_PREMIUM"              = "Office 365 Business Premium"
    "DESKLESSPACK"                       = "Office 365 (Plan F1)"
    "DESKLESSWOFFPACK"                   = "Office 365 (Plan F2)"
    "LITEPACK"                           = "Office 365 (Plan P1)"
    "EXCHANGESTANDARD"                   = "Office 365 Exchange Online Only"
    "STANDARDPACK"                       = "Office 365 Enterprise E1"
    "STANDARDWOFFPACK"                   = "Office 365 (Plan E2)"
    "ENTERPRISEPACK"                     = "Office 365 Enterprise E3"
    "ENTERPRISEPACKLRG"                  = "Office 365 Enterprise E3"
    "ENTERPRISEWITHSCAL"                 = "Office 365 Enterprise E4"
    "STANDARDPACK_STUDENT"               = "Office 365 (Plan A1) for Students"
    "STANDARDWOFFPACKPACK_STUDENT"       = "Office 365 (Plan A2) for Students"
    "ENTERPRISEPACK_STUDENT"             = "Office 365 (Plan A3) for Students"
    "ENTERPRISEWITHSCAL_STUDENT"         = "Office 365 (Plan A4) for Students"
    "STANDARDPACK_FACULTY"               = "Office 365 (Plan A1) for Faculty"
    "STANDARDWOFFPACKPACK_FACULTY"       = "Office 365 (Plan A2) for Faculty"
    "ENTERPRISEPACK_FACULTY"             = "Office 365 (Plan A3) for Faculty"
    "ENTERPRISEWITHSCAL_FACULTY"         = "Office 365 (Plan A4) for Faculty"
    "ENTERPRISEPACK_B_PILOT"             = "Office 365 (Enterprise Preview)"
    "STANDARD_B_PILOT"                   = "Office 365 (Small Business Preview)"
    "VISIOCLIENT"                        = "Visio Online Plan 2"
    "POWER_BI_ADDON"                     = "Office 365 Power BI Addon"
    "POWER_BI_INDIVIDUAL_USE"            = "Power BI Individual User"
    "POWER_BI_STANDALONE"                = "Power BI Stand Alone"
    "POWER_BI_STANDARD"                  = "Power BI (free)"
    "PROJECTESSENTIALS"                  = "Project Online Essentials"
    "PROJECTCLIENT"                      = "Project Professional"
    "PROJECTONLINE_PLAN_1"               = "Project Online"
    "PROJECTONLINE_PLAN_2"               = "Project Online and PRO"
    "ProjectPremium"                     = "Project Online Premium"
    "ECAL_SERVICES"                      = "ECAL"
    "EMS"                                = "Enterprise Mobility + Security E3"
    "RIGHTSMANAGEMENT_ADHOC"             = "Windows Azure Rights Management"
    "MCOMEETADV"                         = "Audio Conferencing"
    "SHAREPOINTSTORAGE"                  = "SharePoint Storage"
    "PLANNERSTANDALONE"                  = "Planner Standalone"
    "CRMIUR"                             = "CMRIUR"
    "BI_AZURE_P1"                        = "Power BI Reporting and Analytics"
    "INTUNE_A"                           = "Windows Intune Plan A"
    "PROJECTWORKMANAGEMENT"              = "Office 365 Planner Preview"
    "ATP_ENTERPRISE"                     = "Exchange Online Advanced Threat Protection"
    "EQUIVIO_ANALYTICS"                  = "Office 365 Advanced eDiscovery"
    "AAD_BASIC"                          = "Azure Active Directory Basic"
    "RMS_S_ENTERPRISE"                   = "Azure Active Directory Rights Management"
    "AAD_PREMIUM"                        = "Azure Active Directory Premium"
    "MFA_PREMIUM"                        = "Azure Multi-Factor Authentication"
    "STANDARDPACK_GOV"                   = "Microsoft Office 365 (Plan G1) for Government"
    "STANDARDWOFFPACK_GOV"               = "Microsoft Office 365 (Plan G2) for Government"
    "ENTERPRISEPACK_GOV"                 = "Microsoft Office 365 (Plan G3) for Government"
    "ENTERPRISEWITHSCAL_GOV"             = "Microsoft Office 365 (Plan G4) for Government"
    "DESKLESSPACK_GOV"                   = "Microsoft Office 365 (Plan F1) for Government"
    "ESKLESSWOFFPACK_GOV"                = "Microsoft Office 365 (Plan F2) for Government"
    "EXCHANGESTANDARD_GOV"               = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
    "EXCHANGEENTERPRISE_GOV"             = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
    "SHAREPOINTDESKLESS_GOV"             = "SharePoint Online Kiosk"
    "EXCHANGE_S_DESKLESS_GOV"            = "Exchange Kiosk"
    "RMS_S_ENTERPRISE_GOV"               = "Windows Azure Active Directory Rights Management"
    "OFFICESUBSCRIPTION_GOV"             = "Office ProPlus"
    "MCOSTANDARD_GOV"                    = "Lync Plan 2G"
    "SHAREPOINTWAC_GOV"                  = "Office Online for Government"
    "SHAREPOINTENTERPRISE_GOV"           = "SharePoint Plan 2G"
    "EXCHANGE_S_ENTERPRISE_GOV"          = "Exchange Plan 2G"
    "EXCHANGE_S_ARCHIVE_ADDON_GOV"       = "Exchange Online Archiving"
    "EXCHANGE_S_DESKLESS"                = "Exchange Online Kiosk"
    "SHAREPOINTDESKLESS"                 = "SharePoint Online Kiosk"
    "SHAREPOINTWAC"                      = "Office Online"
    "YAMMER_ENTERPRISE"                  = "Yammer for the Starship Enterprise"
    "EXCHANGE_L_STANDARD"                = "Exchange Online (Plan 1)"
    "MCOLITE"                            = "Lync Online (Plan 1)"
    "SHAREPOINTLITE"                     = "SharePoint Online (Plan 1)"
    "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
    "EXCHANGE_S_STANDARD_MIDMARKET"      = "Exchange Online (Plan 1)"
    "MCOSTANDARD_MIDMARKET"              = "Lync Online (Plan 1)"
    "SHAREPOINTENTERPRISE_MIDMARKET"     = "SharePoint Online (Plan 1)"
    "OFFICESUBSCRIPTION"                 = "Office ProPlus"
    "YAMMER_MIDSIZE"                     = "Yammer"
    "DYN365_ENTERPRISE_PLAN1"            = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
    "ENTERPRISEPREMIUM_NOPSTNCONF"       = "Enterprise E5 (without Audio Conferencing)"
    "ENTERPRISEPREMIUM"                  = "Enterprise E5 (with Audio Conferencing)"
    "MCOSTANDARD"                        = "Skype for Business Online Standalone Plan 2"
    "PROJECT_MADEIRA_PREVIEW_IW_SKU"     = "Dynamics 365 for Financials for IWs"
    "STANDARDWOFFPACK_IW_STUDENT"        = "Office 365 Education for Students"
    "STANDARDWOFFPACK_IW_FACULTY"        = "Office 365 Education for Faculty"
    "EOP_ENTERPRISE_FACULTY"             = "Exchange Online Protection for Faculty"
    "EXCHANGESTANDARD_STUDENT"           = "Exchange Online (Plan 1) for Students"
    "OFFICESUBSCRIPTION_STUDENT"         = "Office ProPlus Student Benefit"
    "STANDARDWOFFPACK_FACULTY"           = "Office 365 Education E1 for Faculty"
    "STANDARDWOFFPACK_STUDENT"           = "Microsoft Office 365 (Plan A2) for Students"
    "DYN365_FINANCIALS_BUSINESS_SKU"     = "Dynamics 365 for Financials Business Edition"
    "DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
    "FLOW_FREE"                          = "Microsoft Flow Free"
    "POWER_BI_PRO"                       = "Power BI Pro"
    "O365_BUSINESS"                      = "Office 365 Business"
    "DYN365_ENTERPRISE_SALES"            = "Dynamics Office 365 Enterprise Sales"
    "RIGHTSMANAGEMENT"                   = "Rights Management"
    "PROJECTPROFESSIONAL"                = "Project Online Professional"
    "VISIOONLINE_PLAN1"                  = "Visio Online Plan 1"
    "EXCHANGEENTERPRISE"                 = "Exchange Online Plan 2"
    "DYN365_ENTERPRISE_P1_IW"            = "Dynamics 365 P1 Trial for Information Workers"
    "DYN365_ENTERPRISE_TEAM_MEMBERS"     = "Dynamics 365 For Team Members Enterprise Edition"
    "CRMSTANDARD"                        = "Microsoft Dynamics CRM Online Professional"
    "EXCHANGEARCHIVE_ADDON"              = "Exchange Online Archiving For Exchange Online"
    "EXCHANGEDESKLESS"                   = "Exchange Online Kiosk"
    "SPZA_IW"                            = "App Connect"
    "WINDOWS_STORE"                      = "Windows Store for Business"
    "MCOEV"                              = "Phone System"
    "VIDEO_INTEROP"                      = "Polycom Skype Meeting Video Interop for Skype for Business"
    "SPE_E5"                             = "Microsoft 365 E5"
    "SPE_E3"                             = "Microsoft 365 E3"
    "ATA"                                = "Advanced Threat Analytics"
    "MCOPSTN2"                           = "Domestic and International Calling Plan"
    "FLOW_P1"                            = "Microsoft Flow Plan 1"
    "FLOW_P2"                            = "Microsoft Flow Plan 2"
    "POWERAPPS_VIRAL"                    = "Microsoft PowerApps Plan 2"
    "MIDSIZEPACK"                        = "Office 365 Midsize Business"
    "AAD_PREMIUM_P2"                     = "Azure Active Directory Premium P2"
    "RIGHTSMANAGEMENT_STANDARD_FACULTY"  = "Information Rights Management for Faculty"
    "PROJECTONLINE_PLAN_1_FACULTY"       = "Project Online for Faculty Plan 1"
    "PROJECTONLINE_PLAN_2_FACULTY"       = "Project Online for Faculty Plan 2"
    "PROJECTONLINE_PLAN_1_STUDENT"       = "Project Online for Students Plan 1"
    "PROJECTONLINE_PLAN_2_STUDENT"       = "Project Online for Students Plan 2"
    "TEAMS1"                             = "Microsoft Teams"
    "RIGHTSMANAGEMENT_STANDARD_STUDENT"  = "Information Rights Management for Students"
    "EXCHANGEENTERPRISE_FACULTY"         = "Exchange Online Plan 2 for Faculty"
    "SHAREPOINTSTANDARD"                 = "SharePoint Online Plan 1"
    "CRMPLAN2"                           = "Dynamics CRM Online Plan 2"
    "CRMSTORAGE"                         = "Microsoft Dynamics CRM Online Additional Storage"
    "EMSPREMIUM"                         = "Enterprise Mobility + Security E5"
    "POWER_BI_INDIVIDUAL_USER"           = "Power BI for Office 365 Individual"
    "DESKLESSPACK_YAMMER"                = "Office 365 Enterprise F1 with Yammer"
    "MICROSOFT_BUSINESS_CENTER"          = "Microsoft Business Center"
    "STREAM"                             = "Microsoft Stream"
    "OFFICESUBSCRIPTION_FACULTY"         = "Office 365 ProPlus for Faculty"
    "WACSHAREPOINTSTD"                   = "Office Online STD"
    "POWERAPPS_INDIVIDUAL_USER"          = "Microsoft PowerApps and Logic flows"
    "IT_ACADEMY_AD"                      = "Microsoft Imagine Academy"
    "SHAREPOINTENTERPRISE"               = "SharePoint Online (Plan 2)"
    "MCOPSTN1"                           = "Skype for Business PSTN Domestic Calling"
    "MEE_FACULTY"                        = "Minecraft Education Edition Faculty"
    "LITEPACK_P2"                        = "Office 365 Small Business Premium"
    "EXCHANGE_S_ENTERPRISE"              = "Exchange Online Plan 2 S"
    "INTUNE_A_VL"                        = "Intune (Volume License)"
    "ENTERPRISEPACKWITHOUTPROPLUS"       = "Office 365 Enterprise E3 without ProPlus Add-on"
    "ATP_ENTERPRISE_FACULTY"             = "Exchange Online Advanced Threat Protection"
    "EXCHANGE_S_STANDARD"                = "Exchange Online (Plan 2)"
    "MEE_STUDENT"                        = "Minecraft Education Edition Student"
    "EQUIVIO_ANALYTICS_FACULTY"          = "Office 365 Advanced Compliance for faculty"
    "MFA_STANDALONE"                     = "Microsoft Azure Multi-Factor Authentication"
    "MS_TEAMS_IW"                        = "Microsoft Teams"
}
$Script:RGBColors = @{
    "Black"                = 0, 0, 0
    "Navy"                 = 0, 0, 128
    "DarkBlue"             = 0, 0, 139
    "MediumBlue"           = 0, 0, 205
    "Blue"                 = 0, 0, 255
    "DarkGreen"            = 0, 100, 0
    "Green"                = 0, 128, 0
    "Teal"                 = 0, 128, 128
    "DarkCyan"             = 0, 139, 139
    "DeepSkyBlue"          = 0, 191, 255
    "DarkTurquoise"        = 0, 206, 209
    "MediumSpringGreen"    = 0, 250, 154
    "Lime"                 = 0, 255, 0
    "SpringGreen"          = 0, 255, 127
    "Aqua"                 = 0, 255, 255
    "Cyan"                 = 0, 255, 255
    "MidnightBlue"         = 25, 25, 112
    "DodgerBlue"           = 30, 144, 255
    "LightSeaGreen"        = 32, 178, 170
    "ForestGreen"          = 34, 139, 34
    "SeaGreen"             = 46, 139, 87
    "DarkSlateGray"        = 47, 79, 79
    "DarkSlateGrey"        = 47, 79, 79
    "LimeGreen"            = 50, 205, 50
    "MediumSeaGreen"       = 60, 179, 113
    "Turquoise"            = 64, 224, 208
    "RoyalBlue"            = 65, 105, 225
    "SteelBlue"            = 70, 130, 180
    "DarkSlateBlue"        = 72, 61, 139
    "MediumTurquoise"      = 72, 209, 204
    "Indigo"               = 75, 0, 130
    "DarkOliveGreen"       = 85, 107, 47
    "CadetBlue"            = 95, 158, 160
    "CornflowerBlue"       = 100, 149, 237
    "MediumAquamarine"     = 102, 205, 170
    "DimGray"              = 105, 105, 105
    "DimGrey"              = 105, 105, 105
    "SlateBlue"            = 106, 90, 205
    "OliveDrab"            = 107, 142, 35
    "SlateGray"            = 112, 128, 144
    "SlateGrey"            = 112, 128, 144
    "LightSlateGray"       = 119, 136, 153
    "LightSlateGrey"       = 119, 136, 153
    "MediumSlateBlue"      = 123, 104, 238
    "LawnGreen"            = 124, 252, 0
    "Chartreuse"           = 127, 255, 0
    "Aquamarine"           = 127, 255, 212
    "Maroon"               = 128, 0, 0
    "Purple"               = 128, 0, 128
    "Olive"                = 128, 128, 0
    #"Grey" = 92, 92, 92
    "Gray"                 = 128, 128, 128
    "Grey"                 = 128, 128, 128
    "SkyBlue"              = 135, 206, 235
    "LightSkyBlue"         = 135, 206, 250
    "BlueViolet"           = 138, 43, 226
    "DarkRed"              = 139, 0, 0
    "DarkMagenta"          = 139, 0, 139
    "SaddleBrown"          = 139, 69, 19
    "DarkSeaGreen"         = 143, 188, 143
    "LightGreen"           = 144, 238, 144
    "MediumPurple"         = 147, 112, 219
    "DarkViolet"           = 148, 0, 211
    "PaleGreen"            = 152, 251, 152
    "DarkOrchid"           = 153, 50, 204
    "YellowGreen"          = 154, 205, 50
    "Sienna"               = 160, 82, 45
    "Brown"                = 165, 42, 42
    "DarkGray"             = 169, 169, 169
    "DarkGrey"             = 169, 169, 169
    "LightBlue"            = 173, 216, 230
    "GreenYellow"          = 173, 255, 47
    "PaleTurquoise"        = 175, 238, 238
    "LightSteelBlue"       = 176, 196, 222
    "PowderBlue"           = 176, 224, 230
    "FireBrick"            = 178, 34, 34
    "DarkGoldenrod"        = 184, 134, 11
    "MediumOrchid"         = 186, 85, 211
    "RosyBrown"            = 188, 143, 143
    "DarkKhaki"            = 189, 183, 107
    "Silver"               = 192, 192, 192
    "MediumVioletRed"      = 199, 21, 133
    "IndianRed"            = 205, 92, 92
    "Peru"                 = 205, 133, 63
    "Chocolate"            = 210, 105, 30
    "Tan"                  = 210, 180, 140
    "LightGray"            = 211, 211, 211
    "LightGrey"            = 211, 211, 211
    "Thistle"              = 216, 191, 216
    "Orchid"               = 218, 112, 214
    "Goldenrod"            = 218, 165, 32
    "PaleVioletRed"        = 219, 112, 147
    "Crimson"              = 220, 20, 60
    "Gainsboro"            = 220, 220, 220
    "Plum"                 = 221, 160, 221
    "BurlyWood"            = 222, 184, 135
    "LightCyan"            = 224, 255, 255
    "Lavender"             = 230, 230, 250
    "DarkSalmon"           = 233, 150, 122
    "Violet"               = 238, 130, 238
    "PaleGoldenrod"        = 238, 232, 170
    "LightCoral"           = 240, 128, 128
    "Khaki"                = 240, 230, 140
    "AliceBlue"            = 240, 248, 255
    "Honeydew"             = 240, 255, 240
    "Azure"                = 240, 255, 255
    "SandyBrown"           = 244, 164, 96
    "Wheat"                = 245, 222, 179
    "Beige"                = 245, 245, 220
    "WhiteSmoke"           = 245, 245, 245
    "MintCream"            = 245, 255, 250
    "GhostWhite"           = 248, 248, 255
    "Salmon"               = 250, 128, 114
    "AntiqueWhite"         = 250, 235, 215
    "Linen"                = 250, 240, 230
    "LightGoldenrodYellow" = 250, 250, 210
    "OldLace"              = 253, 245, 230
    "Red"                  = 255, 0, 0
    "Fuchsia"              = 255, 0, 255
    "Magenta"              = 255, 0, 255
    "DeepPink"             = 255, 20, 147
    "OrangeRed"            = 255, 69, 0
    "Tomato"               = 255, 99, 71
    "HotPink"              = 255, 105, 180
    "Coral"                = 255, 127, 80
    "DarkOrange"           = 255, 140, 0
    "LightSalmon"          = 255, 160, 122
    "Orange"               = 255, 165, 0
    "LightPink"            = 255, 182, 193
    "Pink"                 = 255, 192, 203
    "Gold"                 = 255, 215, 0
    "PeachPuff"            = 255, 218, 185
    "NavajoWhite"          = 255, 222, 173
    "Moccasin"             = 255, 228, 181
    "Bisque"               = 255, 228, 196
    "MistyRose"            = 255, 228, 225
    "BlanchedAlmond"       = 255, 235, 205
    "PapayaWhip"           = 255, 239, 213
    "LavenderBlush"        = 255, 240, 245
    "Seashell"             = 255, 245, 238
    "Cornsilk"             = 255, 248, 220
    "LemonChiffon"         = 255, 250, 205
    "FloralWhite"          = 255, 250, 240
    "Snow"                 = 255, 250, 250
    "Yellow"               = 255, 255, 0
    "LightYellow"          = 255, 255, 224
    "Ivory"                = 255, 255, 240
    "White"                = 255, 255, 255

    <# Alternative version
    "darkSlateGray" = 42, 42, 42
    "darkGray" = 163, 163, 163
    "whiteSmoke" = 240, 240, 240
    "whiteSmoke" = 242, 242, 242
    "DeepSkyBlue" = 0, 102, 221
    "DarkSlateGrey" = 38, 38, 38
    "DarkSlateGrey" = 51, 51, 51
    "cornflowerblue" = 0, 102, 153
    "WhiteSmoke" = 248, 248, 248
    "Green" = 0, 130, 0
    "SteelBlue" = 127, 157, 185
    "Red" = 163, 21, 21
    "cornflowerblue" = 43, 145, 175
    "Royalblue" = 46, 117, 181
    #>
}
function Search-Command {
    [cmdletbinding()]
    param (
        [string] $CommandName
    )
    return [bool](Get-Command -Name $CommandName -ErrorAction SilentlyContinue)
}
function Send-Email {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [alias('EmailParameters')][System.Collections.IDictionary] $Email,
        [string] $Body = "",
        [string[]] $Attachment,
        [System.Collections.IDictionary] $InlineAttachments,
        [string] $Subject = "",
        [string[]] $To,
        [PSCustomObject] $Logger
    )
    try {
        # Following code makes sure both formats are accepted.
        if ($Email.EmailTo) {
            $EmailParameters = $Email.Clone()
        } else {
            $EmailParameters = @{
                EmailFrom                   = $Email.From
                EmailTo                     = $Email.To
                EmailCC                     = $Email.CC
                EmailBCC                    = $Email.BCC
                EmailReplyTo                = $Email.ReplyTo
                EmailServer                 = $Email.Server
                EmailServerPassword         = $Email.Password
                EmailServerPasswordAsSecure = $Email.PasswordAsSecure
                EmailServerPasswordFromFile = $Email.PasswordFromFile
                EmailServerPort             = $Email.Port
                EmailServerLogin            = $Email.Login
                EmailServerEnableSSL        = $Email.EnableSsl
                EmailEncoding               = $Email.Encoding
                EmailSubject                = $Email.Subject
                EmailPriority               = $Email.Priority
            }
        }
    } catch {    
        return @{
            Status = $False
            Error  = $($_.Exception.Message)
            SentTo = ""
        }
    }  
    $SmtpClient = New-Object -TypeName System.Net.Mail.SmtpClient
    if ($EmailParameters.EmailServer) {
        $SmtpClient.Host = $EmailParameters.EmailServer
    } else {
        return @{
            Status = $False
            Error  = "Email Server Host is not set."
            SentTo = ""
        }
    }
    # Adding parameters to login to server
    if ($EmailParameters.EmailServerPort) {
        $SmtpClient.Port = $EmailParameters.EmailServerPort
    } else {
        return @{
            Status = $False
            Error  = "Email Server Port is not set."
            SentTo = ""
        }
    }

    if ($EmailParameters.EmailServerLogin -ne '') {

        $Credentials = Request-Credentials -UserName $EmailParameters.EmailServerLogin `
            -Password $EmailParameters.EmailServerPassword `
            -AsSecure:$EmailParameters.EmailServerPasswordAsSecure `
            -FromFile:$EmailParameters.EmailServerPasswordFromFile `
            -NetworkCredentials #-Verbose
        $SmtpClient.Credentials = $Credentials
    }

    $SmtpClient.EnableSsl = $EmailParameters.EmailServerEnableSSL
    $MailMessage = New-Object -TypeName System.Net.Mail.MailMessage
    $MailMessage.From = $EmailParameters.EmailFrom
    if ($To) {
        foreach ($T in $To) { $MailMessage.To.add($($T)) }
    } else {
        if ($EmailParameters.Emailto) {
            foreach ($To in $EmailParameters.Emailto) { $MailMessage.To.add($($To)) }
        }
    }
    if ($EmailParameters.EmailCC -ne "") {
        foreach ($CC in $EmailParameters.EmailCC) { $MailMessage.CC.add($($CC)) }
    }
    if ($EmailParameters.EmailBCC -ne "") {
        foreach ($BCC in $EmailParameters.EmailBCC) { $MailMessage.BCC.add($($BCC)) }
    }
    $Exists = Test-Key $EmailParameters "EmailParameters" "EmailReplyTo" -DisplayProgress $false
    if ($Exists -eq $true) {
        if ($EmailParameters.EmailReplyTo -ne "") {
            $MailMessage.ReplyTo = $EmailParameters.EmailReplyTo
        }
    }
    $MailMessage.IsBodyHtml = $true
    if ($Subject -eq '') {
        $MailMessage.Subject = $EmailParameters.EmailSubject
    } else {
        $MailMessage.Subject = $Subject
    }

    $MailMessage.Priority = [System.Net.Mail.MailPriority]::$($EmailParameters.EmailPriority)

    #  Encoding
    $MailMessage.BodyEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)
    $MailMessage.SubjectEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)

    # Inlining attachment (s)
    if ($PSBoundParameters.ContainsKey('InlineAttachments')) {
        $BodyPart = [Net.Mail.AlternateView]::CreateAlternateViewFromString( $Body, 'text/html' )
        $MailMessage.AlternateViews.Add( $BodyPart )
        foreach ( $Entry in $InlineAttachments.GetEnumerator() ) {
            try {

                $FilePath = $Entry.Value
                Write-Verbose $FilePath
                if ($Entry.Value.StartsWith('http')) {
                    $FileName = $Entry.Value.Substring($Entry.Value.LastIndexOf("/") + 1)
                    $FilePath = Join-Path $env:temp $FileName
                    Invoke-WebRequest -Uri $Entry.Value -OutFile $FilePath
                }
                $ContentType = Get-MimeType -FileName $FilePath
                $InAttachment = New-Object Net.Mail.LinkedResource($FilePath, $ContentType )
                $InAttachment.ContentId = $Entry.Key
                $BodyPart.LinkedResources.Add( $InAttachment )
            } catch {
                $MailMessage.Dispose()
                throw
            }
        }
    } else {
        $MailMessage.Body = $Body
    }

    #  Attaching file (s)
    if ($PSBoundParameters.ContainsKey('Attachment')) {
        foreach ($Attach in $Attachment) {
            if (Test-Path $Attach) {
                try {
                    $File = New-Object Net.Mail.Attachment($Attach)
                    Write-Verbose "Send-Email - Attaching file $Attach"
                    $MailMessage.Attachments.Add($File)
                } catch {
                    # non critical error
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    if ($Logger) {
                    $Logger.AddErrorRecord("Error attaching file $Attach`: $ErrorMessage")
                    } else {
                        Write-Error "Error attaching file $Attach`: $ErrorMessage"
                    }
                }
            }
        }
    }

    #  Sending the Email
    try {
        $MailSentTo = "$($MailMessage.To) $($MailMessage.CC) $($MailMessage.BCC)".Trim()
        if ($pscmdlet.ShouldProcess("$MailSentTo", "Send-Email")) {
            $SmtpClient.Send($MailMessage)
            #$att.Dispose();
            $MailMessage.Dispose();


            return @{
                Status = $True
                Error  = ""
                SentTo = $MailSentTo
            }
        }
    } catch {
        $MailMessage.Dispose();
        return @{
            Status = $False
            Error  = $($_.Exception.Message)
            SentTo = ""
        }
    }
}
function Send-SqlInsert {
    [CmdletBinding()]
    param(
        [Array] $Object,
        [System.Collections.IDictionary] $SqlSettings
    )
    if ($SqlSettings.SqlTableTranspose) {
        $Object = Format-TransposeTable -Object $Object
    }
    $SqlTable = Get-SqlQueryColumnInformation -SqlServer $SqlSettings.SqlServer -SqlDatabase $SqlSettings.SqlDatabase -Table $SqlSettings.SqlTable
    $PropertiesFromAllObject = Get-ObjectPropertiesAdvanced -Object $Object -AddProperties 'AddedWhen', 'AddedWho'
    $PropertiesFromTable = $SqlTable.Column_name

    if ($SqlTable -eq $null) {
        if ($SqlSettings.SqlTableCreate) {
            Write-Verbose "Send-SqlInsert - SqlTable doesn't exists, table creation is allowed, mapping will be done either on properties from object or from TableMapping defined in config"
            $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            $CreateTableSQL = New-SqlQueryCreateTable -SqlSettings $SqlSettings -TableMapping $TableMapping
        } else {
            Write-Verbose "Send-SqlInsert - SqlTable doesn't exists, no table creation is allowed. Terminating"
            return "Error occured: SQL Table doesn't exists. SqlTableCreate option is disabled"
        }
    } else {
        if ($SqlSettings.SqlTableAlterIfNeeded) {
            if ( $SqlSettings.SqlTableMapping) {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is allowed, but SqlTableMapping is already defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            } else {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is allowed, and SqlTableMapping is not defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
                $AlterTableSQL = New-SqlQueryAlterTable -SqlSettings $SqlSettings -TableMapping $TableMapping -ExistingColumns $SqlTable.Column_name
            }
        } else {
            if ( $SqlSettings.SqlTableMapping) {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is not allowed, SqlTableMaping is already defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            } else {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is not allowed, SqlTableMaping is not defined, using SqlTable Columns"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromTable -BasedOnSqlTable
            }
        }
    }
    $Queries = @(
        if ($CreateTableSQL) { 
            foreach ($Sql in $CreateTableSQL) {
                $Sql 
            }
        }
        if ($AlterTableSQL) {
            foreach ($Sql in $AlterTableSQL) {
                $Sql 
            }
        }
        $SqlQueries = New-SqlQuery -Object $Object -SqlSettings $SqlSettings -TableMapping $TableMapping
        foreach ($Sql in $SqlQueries) {
            $Sql
        }
    )

    $ReturnData = foreach ($Query in $Queries) {
        try {
            if ($Query) {
                $Query # return query to log
                Invoke-DbaQuery -SqlInstance "$($SqlSettings.SqlServer)" -Database "$($SqlSettings.SqlDatabase)" -Query $Query -ErrorAction Stop # return output      
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            "Error occured (Send-SqlInsert): $ErrorMessage" # return data
        }
    }    
    return $ReturnData
}
<#
# Where $ServerName can be set as needed
# Where Service is the name of the Network Card (takes wildcard)
# Where IpAddresses are given in brackets
Set-DnsServerIpAddress -ComputerName $ServerName -NicName "Service*" -IpAddresses '8.8.8.8','8.8.4.4','8.8.8.1'
#>

function Set-DnsServerIpAddress {
    [CmdletBinding()]
    param(
        [string] $ComputerName,
        [string] $NicName,
        [string] $IpAddresses
    )
    if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock { param ($ComputerName, $NicName, $IpAddresses)
            write-host "Setting on $ComputerName on interface $NicName a new set of DNS Servers $IpAddresses"
            Set-DnsClientServerAddress -InterfaceAlias $NicName -ServerAddresses $IpAddresses

        } -ArgumentList $ComputerName, $NicName, $IpAddresses

    } else {
        write-host "Can't access $ComputerName. Computer is not online."
    }
}
function Set-EmailBody {
    [CmdletBinding()]
    param(
        [Object] $TableData,
        [alias('TableWelcomeMessage')][string] $TableMessageWelcome,
        [string] $TableMessageNoData = 'No changes happened during that period.'
    )
    $Body = "<p><i><u>$TableMessageWelcome</u></i></p>"
    if ($($TableData | Measure-Object).Count -gt 0) {
        $Body += $TableData | ConvertTo-Html -Fragment | Out-String
        # $Body += "</p>"
    } else {
        $Body += "<p><i>$TableMessageNoData</i></p>"
    }
    return $body
}
function Set-EmailBodyPreparedTable ($TableData, $TableWelcomeMessage) {
    $body = "<p><i><u>$TableWelcomeMessage</u></i></p>"
    $body += $TableData
    return $body
}
function Set-EmailBodyReplacement {
    [CmdletBinding()]
    param(
        [string] $Body,
        [hashtable] $ReplacementTable,
        [ValidateSet('Colors', 'Bold')][string] $Type
    )
    switch ($Type) {
        'Colors' {
            foreach ($Field in $ReplacementTable.Keys) {
                $Value = $ReplacementTable.$Field
                $Body = $Body -replace $Field, "<font color=`"$Value`">$Field</font>"
            }
        }
        'Bold' {
            foreach ($Field in $ReplacementTable.Keys) {
                $Value = $ReplacementTable.$Field
                if ($Value -eq $true) {
                    $Body = $Body -replace $Field, "<b>$Field</b>"
                }
            }
        }
    }
    return $Body
}

<#
$ReplacementTable = @{
    ' Added' = 'green'
}

$ReplacementTable = @{
    ' Added' = $true
}
#>
function Set-EmailBodyReplacementTable {
    [alias('Set-EmailBodyTableReplacement')]
    param (
        $Body,
        $TableName,
        $TableData
    )
    $TableData = $TableData | ConvertTo-Html -Fragment | Out-String
    $Body = $Body -replace "<<$TableName>>", $TableData
    return $Body
}
function Set-EmailFormatting {
    param (
        $Template,
        [System.Collections.IDictionary] $FormattingParameters,
        [System.Collections.IDictionary] $ConfigurationParameters,
        $Logger,
        [switch] $SkipNewLines,
        [string[]] $AddAfterOpening,
        [string[]] $AddBeforeClosing
    )
    if ($ConfigurationParameters) {
        $WriteParameters = $ConfigurationParameters.DisplayConsole
    } else {
        $WriteParameters = @{ ShowTime = $true; LogFile = ""; TimeFormat = "yyyy-MM-dd HH:mm:ss" }
    }
   

    $Body = "<body>"
    if ($AddAfterOpening) {
        $Body += $AddAfterOpening
    }

    if (-not $SkipNewLines) { 
        $Template = $Template.Split("`n") # https://blogs.msdn.microsoft.com/timid/2014/07/09/one-liner-fun-with-multi-line-blocktext-and-split-split/
        if ($Logger) {
            $Logger.AddInfoRecord("Preparing template - adding HTML <BR> tags...")
        } else {
            Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "<BR>", " tags." -Color White, Yellow, White, Yellow
        }

        $StyleFlag = $false
   
        foreach ($t in $Template) {
            ## needs investigation
            <#
        if ($t -match 'style>') {
            $StyleFlag = -not $StyleFlag
        }
        if ($StyleFlag) {
            $Body += $t
            continue
        }
        if ($t -match '[\<|\</][\w+|\d+]') {
            $Body += $t
            continue
        }
        #>       
            $Body += "$t<br>" 
        
        }
    } else {
        $Body += $Template
    }
    foreach ($style in $FormattingParameters.Styles.GetEnumerator()) {
        foreach ($value in $style.Value) {
            if ($value -eq "") { continue }
            if ($Logger) {
                $Logger.AddInfoRecord("Preparing template - adding HTML $($style.Name) tag for $value.")
            } else {
                Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "$($style.Name)", " tag for ", "$value", ' tags...' -Color White, Yellow, White, Yellow, White, Yellow
            }
            $Body = $Body.Replace($value, "<$($style.Name)>$value</$($style.Name)>")
        }
    }

    foreach ($color in $FormattingParameters.Colors.GetEnumerator()) {
        foreach ($value in $color.Value) {
            if ($value -eq "") { continue }
            if ($Logger) {
                $Logger.AddInfoRecord("Preparing template - adding HTML $($color.Name) tag for $value.")
            } else {
                Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "$($color.Name)", " tag for ", "$value", ' tags...' -Color White, Yellow, White, Yellow, White, Yellow
            }
            $Body = $Body.Replace($value, "<span style=color:$($color.Name)>$value</span>")
        }
    }
    foreach ($links in $FormattingParameters.Links.GetEnumerator()) {
        foreach ($link in $links.Value) {
            #write-host $link.Text
            #write-host $link.Link
            if ($link.Link -like "*@*") {
                if ($Logger) {
                    $Logger.AddInfoRecord("Preparing template - adding EMAIL Links for $($links.Key).")
                } else {
                    Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " EMAIL ", "Links for", " $($links.Key)..." -Color White, Yellow, White, White, Yellow, White
                }
                $Body = $Body -replace "<<$($links.Key)>>", "<span style=color:$($link.Color)><a href='mailto:$($link.Link)?subject=$($Link.Subject)'>$($Link.Text)</a></span>"
            } else {
                if ($Logger) {
                    $Logger.AddInfoRecord("[i] Preparing template - adding HTML Links for $($links.Key)")
                } else {
                    Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "Links for", " $($links.Key)..." -Color White, Yellow, White, White, Yellow, White
                }
                $Body = $Body -replace "<<$($links.Key)>>", "<span style=color:$($link.Color)><a href='$($link.Link)'>$($Link.Text)</a></span>"
            }
        }

    }
    if ($AddAfterOpening) {
        $Body += $AddBeforeClosing
    }
    $Body += '</body>'
    if ($ConfigurationParameters) {
        if ($ConfigurationParameters.DisplayTemplateHTML -eq $true) { Get-HTML($Body) }
    }
    return $Body
}
function Set-EmailHead {
    param(
        [System.Collections.IDictionary] $FormattingOptions
    )
    $head = @"
    <head>
        <style>
        BODY {
            background-color: white;
            font-family: $($FormattingOptions.FontFamily);
            font-size: $($FormattingOptions.FontSize);
        }

        TABLE {
            border-width: 1px;
            border-style: solid;
            border-color: black;
            border-collapse: collapse;
            font-family: $($FormattingOptions.FontTableDataFamily);
            font-size: $($FormattingOptions.FontTableDataSize);
        }

        TH {
            border-width: 1px;
            padding: 3px;
            border-style: solid;
            border-color: black;
            background-color: #00297A;
            color: white;
            font-family: $($FormattingOptions.FontTableHeadingFamily);
            font-size: $($FormattingOptions.FontTableHeadingSize);
        }
        TR {
            font-family: $($FormattingOptions.FontTableDataFamily);
            font-size: $($FormattingOptions.FontTableDataSize);
        }

        UL {
            font-family: $($FormattingOptions.FontFamily);
            font-size: $($FormattingOptions.FontSize);
        }

        LI {
            font-family: $($FormattingOptions.FontFamily);
            font-size: $($FormattingOptions.FontSize);
        }

        TD {
            border-width: 1px;
            padding-right: 2px;
            padding-left: 2px;
            padding-top: 0px;
            padding-bottom: 0px;
            border-style: solid;
            border-color: black;
            background-color: white;
            font-family: $($FormattingOptions.FontTableDataFamily);
            font-size: $($FormattingOptions.FontTableDataSize);
        }

        H2 {
            font-family: $($FormattingOptions.FontHeadingFamily);
            font-size: $($FormattingOptions.FontHeadingSize);
        }

        P {
            font-family: $($FormattingOptions.FontFamily);
            font-size: $($FormattingOptions.FontSize);
        }
    </style>
    </head>
"@
    return $Head
}
function Set-EmailReportBranding {
    param(
        [alias('FormattingOptions')] $FormattingParameters
    )
    if ($FormattingParameters.CompanyBranding.Link) {
        $Report = "<a style=`"text-decoration:none`" href=`"$($FormattingParameters.CompanyBranding.Link)`" class=`"clink logo-container`">"
    } else {
        $Report = ''
    }
    if ($FormattingParameters.CompanyBranding.Inline) {
        $Report += "<img width=<fix> height=<fix> src=`"cid:logo`" border=`"0`" class=`"company-logo`" alt=`"company-logo`"></a>"
    } else {
        $Report += "<img width=<fix> height=<fix> src=`"$($FormattingParameters.CompanyBranding.Logo)`" border=`"0`" class=`"company-logo`" alt=`"company-logo`"></a>"
    }
    if ($FormattingParameters.CompanyBranding.Width -ne "") {
        $Report = $Report -replace "width=<fix>", "width=$($FormattingParameters.CompanyBranding.Width)"
    } else {
        $Report = $Report -replace "width=<fix>", ""
    }
    if ($FormattingParameters.CompanyBranding.Height -ne "") {
        $Report = $Report -replace "height=<fix>", "height=$($FormattingParameters.CompanyBranding.Height)"
    } else {
        $Report = $Report -replace "height=<fix>", ""
    }
    return $Report
}
function Set-EmailWordReplacements($Body, $Replace, $ReplaceWith, [switch] $RegEx) {
    if ($RegEx) {
        $Body = $Body -Replace $Replace, $ReplaceWith
    } else {
        $Body = $Body.Replace($Replace, $ReplaceWith)
    }
    return $Body
}
function Set-EmailWordReplacementsHash {
    [CmdletBinding()]
    param (
        $Body,
        $Substitute
    )
    foreach ($Key in $Substitute.Keys) {
        Write-Verbose "Set-EmailWordReplacementsHash - Key: $Key Value: $($Substitute.$Key)"
        $Body = Set-EmailWordReplacements -Body $Body -Replace $Key -ReplaceWith $Substitute.$Key
    }
    return $Body
}
function Set-FileInheritance {
    [alias('Set-Inheritance')]
    param(
        [string] $StartingDir,
        [switch] $DisableInheritance,
        [switch] $KeepInheritedAcl
    )
    $acl = get-acl -Path $StartingDir
    $acl.SetAccessRuleProtection($DisableInheritance, $KeepInheritedAcl)
    $acl | Set-Acl -Path $StartingDir
}
function Set-FilePermission {
    [alias('Set-Permission')]
    param (
        [string] $StartingDir,
        [string] $UserOrGroup = "",
        $InheritedFolderPermissions = "ContainerInherit, ObjectInherit",
        [string] $AccessControlType = "Allow",
        [string] $PropagationFlags = "None",
        $AclRightsToAssign
    )
    ### The possible values for Rights are:
    # ListDirectory, ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, Synchronize, FullControl
    # ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, DeleteSubdirectoriesAndFiles, ReadAttributes
    # WriteAttributes, Write, Delete, ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership

    ### Principal expected
    # domain\username

    ### Inherited folder permissions:
    # Object inherit    - This folder and files. (no inheritance to subfolders)
    # Container inherit - This folder and subfolders.
    # Inherit only      - The ACE does not apply to the current file/directory

    #define a new access rule.
    $acl = Get-Acl -Path $StartingDir
    $perm = $UserOrGroup, $AclRightsToAssign, $InheritedFolderPermissions, $PropagationFlags, $AccessControlType
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
    $acl.SetAccessRule($rule)
    set-acl -Path $StartingDir $acl
}
function Set-PasswordRemotely {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $UserName,
        [Parameter(Mandatory = $true)][string] $OldPassword,
        [Parameter(Mandatory = $true)][string] $NewPassword,
        [Parameter(Mandatory = $true)][alias('DC', 'Server', 'ComputerName')][string] $DomainController
    )
    $DllImport = @'
[DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
public static extern bool NetUserChangePassword(string domain, string username, string oldpassword, string newpassword);
'@

    $NetApi32 = Add-Type -MemberDefinition $DllImport -Name 'NetApi32' -Namespace 'Win32' -PassThru
    if ($result = $NetApi32::NetUserChangePassword($DomainController, $UserName, $OldPassword, $NewPassword)) {
        Write-Output -InputObject 'Password change failed. Please try again.'
    } else {
        Write-Output -InputObject 'Password change succeeded.'
    }
}
function Set-ServiceRecovery {
    <#
    .SYNOPSIS
    #
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ServiceDisplayName
    Parameter description
    
    .PARAMETER Server
    Parameter description
    
    .PARAMETER action1
    Parameter description
    
    .PARAMETER time1
    Parameter description
    
    .PARAMETER action2
    Parameter description
    
    .PARAMETER time2
    Parameter description
    
    .PARAMETER actionLast
    Parameter description
    
    .PARAMETER timeLast
    Parameter description
    
    .PARAMETER resetCounter
    Parameter description
    
    .EXAMPLE
    Set-ServiceRecovery -ServiceDisplayName "Pulseway" -Server "MAIL1"
    
    .NOTES
    General notes
    #>
    [alias('Set-Recovery')]
    param
    (
        [string] [Parameter(Mandatory = $true)] $ServiceDisplayName,
        [string] [Parameter(Mandatory = $true)] $Server,
        [string] $action1 = "restart",
        [int] $time1 = 30000, # in miliseconds
        [string] $action2 = "restart",
        [int] $time2 = 30000, # in miliseconds
        [string] $actionLast = "restart",
        [int] $timeLast = 30000, # in miliseconds
        [int] $resetCounter = 4000 # in seconds
    )
    $serverPath = "\\" + $server
    $services = Get-CimInstance -ClassName 'Win32_Service' -ComputerName $Server| Where-Object {$_.DisplayName -imatch $ServiceDisplayName}
    $action = $action1 + "/" + $time1 + "/" + $action2 + "/" + $time2 + "/" + $actionLast + "/" + $timeLast
    foreach ($service in $services) {
        # https://technet.microsoft.com/en-us/library/cc742019.aspx
        $output = sc.exe $serverPath failure $($service.Name) actions= $action reset= $resetCounter
    }
}
function Set-SpecUser {
    [CmdletBinding()]
    param(
        $User,
        $UsersAzure
    )
    $UserAzure = $UsersAzure | where { $_.UserPrincipalName -eq $User.UserPrincipalName }
    if ($UserAzure) {
        Write-Color "Set-SpecUser - Processing user ", $User.DisplayName, ' - ObjectID: ', $($UserAzure.ObjectID), ' user password ', $User.Password  -Color White, Yellow

        $Password = $User.Password | ConvertTo-SecureString -AsPlainText -Force
        Set-AzureADUserPassword -ObjectId $UserAzure.ObjectID -Password $Password
    } else {
        Write-Color "Set-SpecUser - Skipping user ", $User.DisplayName, ' - ObjectID: ', $($UserAzure.ObjectID), ' user password ', $User.Password  -Color White, Yellow
    }
}
function Set-TimeSynchronization {
    param(
        [string[]] $TimeSource = 'time.windows.com',
        [int] $MaxPosPhaseCorrection = 86400,
        [int] $MaxnegPhaseCorrection = 86400,
        [int] $PollInterval = 1800
    )
    ## set external time source
    ## set server type to NTP
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value 'NTP'
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name AnnounceFlags -Value 5
    ## Enable NTP server
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer -Name Enabled -Value 1
    ## Specify Time source
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name NtpServer -Value "$TimeSource,0x1"
    ## Set poll interval in seconds - every 30 minutes
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient -Name SpecialPollInterval -Value $PollInterval
    ## set max +/- time corrections in seconds - 24 hours
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name MaxPosPhaseCorrection -Value $MaxPosPhaseCorrection
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name MaxnegPhaseCorrection -Value $MaxnegPhaseCorrection

    Stop-Service -Name W32Time
    Start-Service -Name W32Time
}
<#

$Group1 = 'GDS-TestGroup1'
$Group2 = 'GDS-TestGroup2'

Set-WinADGroupSynchronization -GroupFrom $Group1 -GroupTo $Group2 -Type 'All' -Recursive None
#>

function Set-WinADGroupSynchronization {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)][string] $GroupFrom,
        [parameter(Mandatory = $true)][string] $GroupTo,
        [parameter(Mandatory = $false)][ValidateSet("User", "Group", "All")][string] $Type = 'User',
        [parameter(Mandatory = $false)][ValidateSet("None", "RecursiveFrom", "RecursiveBoth", "RecursiveTo")] $Recursive = 'None',
        [switch] $WhatIf
    )
    Begin {
        $Object = @()
        if ($Recursive -eq 'None') {
            $GroupFromRecursive = $false
            $GroupToRecursive = $false
        } elseif ($Recursive -eq 'RecursiveFrom') {
            $GroupFromRecursive = $true
            $GroupToRecursive = $false
        } elseif ($Recursive -eq 'RecursiveBoth') {
            $GroupFromRecursive = $true
            $GroupToRecursive = $true
        } else {
            $GroupFromRecursive = $false
            $GroupToRecursive = $true
        }
    }
    Process {
        try {

            $GroupMembersFrom = Get-ADGroupMember -Identity $GroupFrom -Recursive:$GroupFromRecursive | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
        }
        try {
            $GroupMembersTo = Get-ADGroupMember -Identity $GroupTo -Recursive:$GroupToRecursive | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
        }
        if ($Object.Count -gt 0) {
            # Something went seriously wrong. Terminate ASAP
            return $Object
        }

        foreach ($User in $GroupMembersFrom) {
            if ($User.ObjectClass -eq "user") {
                if ($Type -eq 'User' -or $Type -eq 'All') {
                    if ($GroupMembersTo.SamAccountName -notcontains $User.SamAccountName) {
                        #Write-Color "Not a member ", $User.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Add-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Added to group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            } else {
                if ($Type -eq 'Group' -or $Type -eq 'All') {
                    if ($GroupMembersTo.SamAccountName -notcontains $User.SamAccountName) {
                        #Write-Color "Not a member ", $User.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Add-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Added to group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            }
        }
        foreach ($User in $GroupMembersTo) {
            if ($User.ObjectClass -eq "user") {
                if ($Type -eq 'User' -or $Type -eq 'All') {
                    if ($GroupMembersFrom.SamAccountName -notcontains $User.SamAccountName) {
                        Write-Color "Not a member of $GroupFrom - requires removal from $GroupTo ", $User.SamAccountName -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Remove-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName -Confirm:$false
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Removed from group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            } else {
                if ($Type -eq 'Group' -or $Type -eq 'All') {
                    if ($GroupMembersFrom.SamAccountName -notcontains $User.SamAccountName) {
                        Write-Color "Not a member of $GroupFrom - requires removal from $GroupTo ", $User.SamAccountName -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Remove-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName -Confirm:$false
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Removed from group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            }
        }
    }
    End {
        return $object
    }
}
function Set-WinADUserFields {
    [CmdletBinding()]
    [alias("Set-ADUserName")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $false)][ValidateSet("Before", "After")][String] $Option,
        [string] $TextToAdd,
        [string] $TextToRemove,
        [string[]] $Fields,
        [switch] $WhatIf
    )
    $Object = @()
    if ($TextToAdd) {
        foreach ($Field in $Fields) {
            if ($User.$Field -notlike "*$TextToAdd*") {

                if ($Option -eq 'After') {
                    $NewName = "$($User.$Field)$TextToAdd"
                } elseif ($Option -eq 'Before') {
                    $NewName = "$TextToAdd$($User."$Field")"
                }
                if ($NewName -ne $User.$Field) {
                    if ($Field -eq 'Name') {
                        try {
                            if (-not $WhatIf) {
                                Rename-ADObject -Identity $User.DistinguishedName -NewName $NewName #-WhatIf
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed account '$Field' to '$NewName'" }

                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                        }
                    } else {
                        $Splat = @{
                            Identity = $User.DistinguishedName
                            "$Field" = $NewName
                        }
                        try {
                            if (-not $WhatIf) {
                                Set-ADUser @Splat
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed field '$Field' to '$NewName'" }

                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                        }
                    }


                }

            }
        }
    }
    if ($TextToRemove) {
        foreach ($Field in $Fields) {
            if ($User.$Field -like "*$TextToRemove*") {
                $NewName = $($User.$Field).Replace($TextToRemove, '')
                if ($Field -eq 'Name') {
                    try {
                        if (-not $WhatIf) {
                            Rename-ADObject -Identity $User.DistinguishedName -NewName $NewName #-WhatIf
                        }
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed account '$Field' to '$NewName'" }

                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Field: '$Field' Error: '$ErrorMessage'" }
                    }
                } else {
                    $Splat = @{
                        Identity = $User.DistinguishedName
                        "$Field" = $NewName
                    }
                    try {
                        if (-not $WhatIf) {
                            Set-ADUser @Splat #-WhatIf
                        }
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed field $Field to $NewName" }

                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Field: $Field Error: $ErrorMessage" }
                    }
                }
            }
        }

    }
    return $Object
}
Function Set-WinADUserSettingGAL {
    [CmdletBinding()]
    [alias("Set-ADUserSettingGAL")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Hide", "Show")][String]$Option,
        [switch] $WhatIf
    )
    $Object = @()
    if ($User) {
        if ($Option -eq 'Hide') {
            if (-not $User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Hiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                try {
                    if (-not $WhatIf) {
                        Set-ADObject -Identity $User.DistinguishedName -Replace @{msExchHideFromAddressLists = $true}
                    }
                    $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Hidden from GAL.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                }
            }
        } elseif ($Option -eq 'Show') {
            if ($User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Unhiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                try {
                    if ($WhatIf) {
                        Set-ADObject -Identity $User.DistinguishedName -Clear msExchHideFromAddressLists
                    }
                    $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Unhidden in GAL.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                }
            }
        }
    }
    return $Object
}
function Set-WinADUserStatus {
    [CmdletBinding()]
    [alias("Set-ADUserStatus")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option,
        [switch] $WhatIf
        # $WriteParameters
    )
    $Object = @()
    if ($Option -eq 'Enable' -and $User.Enabled -eq $false) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Enabling user ', $User.DisplayName, ' in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        try {
            if (-not $WhatIf) {
                Set-ADUser -Identity $User.DistinguishedName -Enabled $true
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Enabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Disable' -and $User.Enabled -eq $true) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Disabling user ', $User.DisplayName, 'in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        try {
            if (-not $WhatIf) {
                Set-ADUser -Identity $User.DistinguishedName -Enabled $false
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Disabled user.' }

        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
        }
    }
    return $Object
}
function Set-WinAzureADUserField {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $false)][Object] $Value,
        [switch] $WhatIf
    )

    $Splat = @{}
    $Splat.UserPrincipalName = $User.UserPrincipalName
    $Splat.ErrorAction = 'Stop'
    if ($Value) {
        $Field = "$($Value.Field)"
        if ($Field -eq 'UserPrincipalName') {
            # if UserPrincipalName it means user wants to rename UserPrincipalName
            # that requires different method
            $Field = 'NewUserPrincipalName'
        }
        $Data = $Value.Value
        $Splat.$Field = $Data
    }

    $Object = @()
    if ($User.$Field -ne $Data) {
        try {
            if (-not $WhatIf) {
                if ($Field -eq 'UserPrincipalName') {
                    Set-MsolUserPrincipalName @Splat
                } else {
                    Set-MsolUser @Splat
                }
            }

            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Set $Field to $Data" }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " " -Replace '  ',' '
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}
function Set-WinAzureADUserLicense {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Add", "Remove", "RemoveAll", "Replace")][String] $Option,
        [parameter(Mandatory = $false)][string] $License,
        [parameter(Mandatory = $false)][string] $LicenseToReplace,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Add') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Remove') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'RemoveAll') {
        try {
            foreach ($License in $User.Licenses.AccountSKUID) {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Replace') {
        [bool] $Success = $true
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user before removing $LicenseToReplace." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            $Success = $false
        }
        if ($Success) {
            try {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $LicenseToReplace from user." }
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            }
        }
    }
    return $Object
}
function Set-WinAzureADUserStatus {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Enable' -and $User.BlockCredential -eq $true) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $false
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Enabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Disable' -and $User.BlockCredential -eq $false) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $true
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Disabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}
function Set-XML {
    param (
        [string] $FilePath,
        [string[]]$Paths,
        [string] $Node,
        [string] $Value
    )
    [xml]$xmlDocument = Get-Content -Path $FilePath -Encoding UTF8
    $XmlElement = $xmlDocument
    foreach ($Path in $Paths) {
        $XmlElement = $XmlElement.$Path
    }
    $XmlElement.$Node = $Value
    $xmlDocument.Save($FilePath)
    # Save-XML -FilePath $FilePath -xml $xmlDocument
}
function Show-Array {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [switch] $WithType
    )
    foreach ($Element in $List) {
        $Type = Get-ObjectType -Object $Element
        if ($WithType) {
            Write-Output "$Element (Type: $($Type.ObjectTypeName))"
        } else {
            Write-Output $Element
        }
    }
}
function Show-DataInVerbose {
    [CmdletBinding()]
    param(
        [Object] $Object
    )
    foreach ($O in $Object) {
        foreach ($E in $O.PSObject.Properties) {
            $FieldName = $E.Name
            $FieldValue = $E.Value
            Write-Verbose "Display-DataInVerbose - FieldName: $FieldName FieldValue: $FieldValue"
        }
    }
}
function Show-TableVisualization {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object
    )
    if ($Color) { Write-Color "[i] This is how table looks like in Format-Table" -Color Yellow }
    Write-Verbose '[i] This is how table looks like in Format-Table'
    $Object | Format-Table -AutoSize
    $Data = Format-PSTable $Object #-Verbose

    Write-Verbose "[i] Rows Count $($Data.Count) Column Count $($Data[0].Count)"
    $RowNr = 0
    if ($Color) { Write-Color "[i] Presenting table after conversion" -Color Yellow }
    foreach ($Row in $Data) {
        $ColumnNr = 0
        foreach ($Column in $Row) {
            Write-Verbose "Row: $RowNr Column: $ColumnNr Data: $Column"
            $ColumnNr++
        }
        $RowNr++
    }
}
function Split-Array {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        Split an array
        .NOTES
        Version : July 2, 2017 - implemented suggestions from ShadowSHarmon for performance
        .PARAMETER inArray
        A one dimensional array you want to split
        .EXAMPLE
        This splits array into multiple arrays of 3
        Example below wil return 1,2,3  + 4,5,6 + 7,8,9

        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -parts 3
        .EXAMPLE
        This splits array into 3 parts regardless of amount of elements


        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -size 3

        # Link: https://gallery.technet.microsoft.com/scriptcenter/Split-an-array-into-parts-4357dcc1
    #>
    param(
        [Object] $inArray,
        [int]$parts,
        [int]$size
    )
    if ($inArray.Count -eq 1) { return $inArray }
    if ($parts) {
        $PartSize = [Math]::Ceiling($inArray.count / $parts)
    }
    if ($size) {
        $PartSize = $size
        $parts = [Math]::Ceiling($inArray.count / $size)
    }
    $outArray = New-Object 'System.Collections.Generic.List[psobject]'
    for ($i = 1; $i -le $parts; $i++) {
        $start = (($i - 1) * $PartSize)
        $end = (($i) * $PartSize) - 1
        if ($end -ge $inArray.count) {$end = $inArray.count - 1}
        $outArray.Add(@($inArray[$start..$end]))
    }
    return , $outArray
}
Function Split-ArrayEvery {
    [CmdletBinding()]
    param(
        $list,
        [int] $count = 4
    )
    $aggregateList = @()

    $blocks = [Math]::Floor($list.Count / $count)
    $leftOver = $list.Count % $count
    $start = $end = 0
    for ($i = 0; $i -lt $blocks; $i++) {
        $end = $count * ($i + 1) - 1

        $aggregateList += @(, $list[$start..$end])
        $start = $end + 1
    }
    if ($leftOver -gt 0) {
        $aggregateList += @(, $list[$start..($end + $leftOver)])
    }

    $aggregateList
}
function Start-MyProgram {
    [CmdletBinding()]
    param (
        [string] $Program,
        [string[]] $CmdArgList
    )
    return & $Program $CmdArgList
}
function Start-Runspace {
    [cmdletbinding()]
    param (
        [string] $ScriptBlock,
        [System.Collections.IDictionary] $Parameters,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool
    )
    if ($null -ne $Parameters -and $ScriptBlock -ne '
    ') {
        $runspace = [PowerShell]::Create()
        $null = $runspace.AddScript($ScriptBlock)
        $null = $runspace.AddParameters($Parameters)
        $runspace.RunspacePool = $RunspacePool
        # return data
        [PSCustomObject]@{
            Pipe   = $runspace
            Status = $runspace.BeginInvoke()
        }
    }
}
function Start-TimeLog {
    [CmdletBinding()]
    param()
    $ExecutionTime = [System.Diagnostics.Stopwatch]::StartNew()
    return $ExecutionTime
}
function Stop-Runspace {
    [cmdletbinding()]
    param(
        [System.Object[]]$Runspaces,
        [string] $FunctionName,
        [System.Management.Automation.Runspaces.RunspacePool] $RunspacePool,
        [switch] $ExtendedOutput
    )
    [Array] $List = while ($Runspaces.Status -ne $null) {
        foreach ($Runspace in $Runspaces | Where-Object { $_.Status.IsCompleted -eq $true }) {
            $Errors = foreach ($e in $($Runspace.Pipe.Streams.Error)) {
                Write-Error -ErrorRecord $e
                $e
            }
            foreach ($w in $($Runspace.Pipe.Streams.Warning)) {
                Write-Warning -Message $w
            }
            foreach ($v in $($Runspace.Pipe.Streams.Verbose)) {
                Write-Verbose -Message $v
            }
            if ($ExtendedOutput) {
                @{
                    Output = $Runspace.Pipe.EndInvoke($Runspace.Status)
                    Errors = $Errors
                }
            } else {
                $Runspace.Pipe.EndInvoke($Runspace.Status)
            }
            $Runspace.Status = $null
        }
    }
    $RunspacePool.Close()
    $RunspacePool.Dispose()
    if ($List.Count -eq 1) {
        return , $List
    } else {
        return $List
    }
}
function Stop-TimeLog {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)][System.Diagnostics.Stopwatch] $Time,
        [ValidateSet('OneLiner', 'Array')][string] $Option = 'OneLiner',
        [switch] $Continue
    )
    Begin {}
    Process {
        if ($Option -eq 'Array') {
            $TimeToExecute = "$($Time.Elapsed.Days) days", "$($Time.Elapsed.Hours) hours", "$($Time.Elapsed.Minutes) minutes", "$($Time.Elapsed.Seconds) seconds", "$($Time.Elapsed.Milliseconds) milliseconds"
        } else {
            $TimeToExecute = "$($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds"
        }
    }
    End {
        if (-not $Continue) {
            $Time.Stop()
        }
        return $TimeToExecute
    }
}
function Test-AvailabilityCommands {
    param (
        [string[]] $Commands
    )
    $CommandsStatus = foreach ($Command in $Commands) {
        $Exists = Search-Command -Command $Command
        if ($Exists) {
            Write-Verbose "Test-AvailabilityCommands - Command $Command is available."
        } else {
            Write-Verbose "Test-AvailabilityCommands - Command $Command is not available."
        }
        $Exists
    }
    return $CommandsStatus
}
function Test-ComputerAvailability {
    [CmdletBinding()]
    param(
        [string[]] $Servers,
        [ValidateSet('All', 'Ping', 'WinRM', 'PortOpen', 'Ping+WinRM', 'Ping+PortOpen', 'WinRM+PortOpen')] $Test = 'All',
        [int[]] $Ports = 135,
        [int] $PortsTimeout = 100,
        [int] $PingCount = 1
    )
    $OutputList = @(
        foreach ($Server in $Servers) {
            $Output = [ordered] @{}
            $Output.ServerName = $Server
            if ($Test -eq 'All' -or $Test -like 'Ping*') {
                $Output.Pingable = Test-Connection -ComputerName $Server -Quiet -Count $PingCount
            }
            if ($Test -eq 'All' -or $Test -like '*WinRM*') {
                $Output.WinRM = Test-WinRM -ComputerName $Server
            }
            if ($Test -eq 'All' -or '*PortOpen*') {
                $Output.PortOpen = Test-ComputerPort -Server $Server -Ports $Ports -Timeout $PortsTimeout
            }
            [PSCustomObject] $Output
        }
    )
    return $OutputList
}
function Test-ComputerPort {
    [CmdletBinding()]
    Param(
        [string] $Server,
        [int[]] $Ports = 135,
        [int] $TimeOut = 1000
    )
    foreach ($Port in $Ports) {
        #Write-Verbose "Test-Port - $Server`:$Port Start"
        $TcpClient = New-Object system.Net.Sockets.TcpClient
        $iar = $TcpClient.BeginConnect($server, $port, $null, $null)
        # Set the Wait time
        $Wait = $iar.AsyncWaitHandle.WaitOne($TimeOut, $false)
        # Check to see if the connection is done
        if (!$Wait) {
            # Close the connection and report TimeOut
            $TcpClient.Close()
            Write-Verbose "Test-Port - $Server`:$Port Connection TimeOut"
            return $false
        } else {
            # Close the connection and report the error if there is one
            $error.Clear()
            $TcpClient.EndConnect($iar) | Out-Null
            if (!$?) {
                Write-Verbose "Test-Port - $Server`:$Port Error: $($error[0])"
                $Failed = $true
            }
            $TcpClient.Close()
        }
        if ($Failed) { break }
    }
    if ($Failed) {
        return $false # Failed on all or just one of tested ports
    } else {
        return $true # Established
    }
}
function Test-ConfigurationCredentials {
    [CmdletBinding()]
    param (
        [Object] $Configuration,
        $AllowEmptyKeys
    )
    $Object = @()
    foreach ($Key in $Configuration.Keys) {
        if ($AllowEmptyKeys -notcontains $Key -and [string]::IsNullOrWhiteSpace($Configuration.$Key)) {
            Write-Verbose "Test-ConfigurationCredentials - Configuration $Key is Null or Empty! Terminating"
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Credentials configuration $Key is Null or Empty!" }
        }
    }
    return $Object
}
function Test-ForestConnectivity {
    Try {
        $Test = Get-ADForest
        return $true
    } catch {
        #Write-Warning 'No connectivity to forest/domain.'
        return $False
    }
}
Function Test-InstalledApplication {
    [CmdletBinding()]
    Param(
        [alias('ApplicationName')] [string] $DisplayName
    )
    $App = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
    return $App
}
function Test-Key ($ConfigurationTable, $ConfigurationSection = "", $ConfigurationKey, $DisplayProgress = $false) {
    if ($ConfigurationTable -eq $null) { return $false }
    try {
        $value = $ConfigurationTable.ContainsKey($ConfigurationKey)
    } catch {
        $value = $false
    }
    if ($value -eq $true) {
        if ($DisplayProgress -eq $true) {
            Write-Color @script:WriteParameters -Text "[i] ", "Parameter in configuration of ", "$ConfigurationSection.$ConfigurationKey", " exists." -Color White, White, Green, White
        }
        return $true
    } else {
        if ($DisplayProgress -eq $true) {
            Write-Color @script:WriteParameters -Text "[i] ", "Parameter in configuration of ", "$ConfigurationSection.$ConfigurationKey", " doesn't exist." -Color White, White, Red, White
        }
        return $false
    }
}
function Test-ModuleAvailability {
    if (Search-Command -CommandName 'Get-AdForest') {
        # future use
    } else {
        Write-Warning 'Modules required to run not found.'
        Exit
    }
}
function Test-WinRM {
    [CmdletBinding()]
    param (
        $ComputerName
    )
    try {
        $WinRM = Test-WSMan -ComputerName $Server -ErrorAction Stop
        $Value = $true
    } catch {
        $Value = $false
    }
    return $Value
}
function Uninstall-ApplicationClickOnce {
    [CmdletBinding()]
    Param(
        [alias('ApplicationName')] $DisplayName
    )
    $App = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
    if ($App) {
        $selectedUninstallString = $App.UninstallString
        #Seperate cmd from parameters (First Space)
        $parts = $selectedUninstallString.Split(' ', 2)
        Start-Process -FilePath $parts[0] -ArgumentList $parts[1] -Wait
        #ToDo : Automatic press of OK
        #Start-Sleep 5
        #$wshell = new-object -com wscript.shell
        #$wshell.sendkeys("`"OK`"~")

        $app = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
        if ($app) {
            Write-Verbose 'Uninstall-ApplicationClickOnce - Uninstallation was not successfull.'
            return $false
        } else {
            Write-Verbose 'Uninstall-ApplicationClickOnce - Uninstallation was not successfull.'
            return $true
        }

    } else {
        return
    }
}


Export-ModuleMember `
    -Function @('Add-PropertyToList','Add-ToArray','Add-ToArrayAdvanced','Add-ToHashTable','Add-WinADUserGroups','Compare-ObjectProperties','Compare-ObjectsAdvanced','Connect-WinAzure','Connect-WinAzureAD','Connect-WinExchange','Connect-WinSecurityCompliance','Connect-WinService','Connect-WinSharePoint','Connect-WinSkype','Connect-WinTeams','Convert-BinaryToHex','Convert-BinaryToString','Convert-Color','Convert-ExchangeEmail','Convert-ExchangeItems','Convert-ExchangeRecipientDetails','Convert-ExchangeSize','ConvertFrom-Color','ConvertFrom-ErrorRecord','ConvertFrom-OperationType','ConvertFrom-SID','ConvertFrom-X500Address','Convert-HexToBinary','Convert-KeyToKeyValue','Convert-Office365License','Convert-Size','Convert-TimeToDays','Convert-ToDateTime','ConvertTo-ImmutableID','Convert-ToTimeSpan','Convert-TwoArraysIntoOne','Convert-UAC','Disconnect-WinAzure','Disconnect-WinAzureAD','Disconnect-WinExchange','Disconnect-WinSecurityCompliance','Disconnect-WinService','Disconnect-WinSkype','Disconnect-WinTeams','Find-ADConnectServer','Find-DatesCurrentDayMinusDayX','Find-DatesCurrentDayMinuxDaysX','Find-DatesCurrentHour','Find-DatesDayPrevious','Find-DatesDayToday','Find-DatesMonthCurrent','Find-DatesMonthPast','Find-DatesPastHour','Find-DatesPastWeek','Find-DatesQuarterCurrent','Find-DatesQuarterLast','Find-ExchangeServer','Find-HyperVServer','Find-MyProgramData','Find-ServerTypes','Find-TypesNeeded','Find-UsersProxyAddressesStatus','Format-AddSpaceToSentence','Format-FirstXChars','Format-PSTable','Format-Stream','Format-ToTitleCase','Format-TransposeTable','Format-View','Get-CimData','Get-CommandInfo','Get-ComputerApplications','Get-ComputerBios','Get-ComputerCPU','Get-ComputerCulture','Get-ComputerDisk','Get-ComputerDiskLogical','Get-ComputerMissingDrivers','Get-ComputerNetwork','Get-ComputerOemInformation','Get-ComputerOperatingSystem','Get-ComputerServices','Get-ComputerStartup','Get-ComputerSystem','Get-ComputerWindowsFeatures','Get-ComputerWindowsUpdates','Get-FileInformation','Get-FileName','Get-FilesInFolder','Get-FileSize','Get-HashMaxValue','Get-HTML','Get-InstalledApplication','Get-IPAddressInformation','Get-Logger','Get-MimeType','Get-ModulesAvailability','Get-MyIpAddress','Get-ObjectCount','Get-ObjectData','Get-ObjectEnumValues','Get-ObjectKeys','Get-ObjectProperties','Get-ObjectPropertiesAdvanced','Get-ObjectTitles','Get-ObjectType','Get-PathSeparator','Get-PathTemporary','Get-RandomCharacters','Get-RandomFileName','Get-RandomPassword','Get-RandomStringName','Get-ServerRoles','Get-SqlQueryColumnInformation','Get-TemporaryDirectory','Get-TimeSynchronization','Get-TimeZoneAdvanced','Get-TimeZoneLegacy','Get-Types','Get-WinADForestControllers','Get-WinADForestOptions','Get-WinADOrganizationalUnitData','Get-WinADOrganizationalUnitFromDN','Get-WinADUsersByDN','Get-WinADUsersByOU','Get-WinADUserSnapshot','Install-ApplicationClickOnce','Install-WinConnectity','Merge-Array','Merge-Objects','New-ArrayList','New-GenericList','New-Runspace','New-SqlQuery','New-SqlQueryAlterTable','New-SqlQueryCreateTable','New-SqlTableMapping','New-UserAdd','Remove-DuplicateObjects','Remove-FilePermission','Remove-FromArray','Remove-ObjectsExistingInTarget','Remove-WhiteSpace','Remove-WinADUserGroups','Rename-LatinCharacters','Rename-UserValuesFromHash','Request-Credentials','Save-XML','Search-Command','Send-Email','Send-SqlInsert','Set-DnsServerIpAddress','Set-EmailBody','Set-EmailBodyPreparedTable','Set-EmailBodyReplacement','Set-EmailBodyReplacementTable','Set-EmailFormatting','Set-EmailHead','Set-EmailReportBranding','Set-EmailWordReplacements','Set-EmailWordReplacementsHash','Set-FileInheritance','Set-FilePermission','Set-PasswordRemotely','Set-ServiceRecovery','Set-SpecUser','Set-TimeSynchronization','Set-WinADGroupSynchronization','Set-WinADUserFields','Set-WinADUserSettingGAL','Set-WinADUserStatus','Set-WinAzureADUserField','Set-WinAzureADUserLicense','Set-WinAzureADUserStatus','Set-XML','Show-Array','Show-DataInVerbose','Show-TableVisualization','Split-Array','Split-ArrayEvery','Start-MyProgram','Start-Runspace','Start-TimeLog','Stop-Runspace','Stop-TimeLog','Test-AvailabilityCommands','Test-ComputerAvailability','Test-ComputerPort','Test-ConfigurationCredentials','Test-ForestConnectivity','Test-InstalledApplication','Test-Key','Test-ModuleAvailability','Test-WinRM','Uninstall-ApplicationClickOnce') `
    -Alias @('Add-ADUserGroups','Convert-FromColor','Find-ADSyncServer','Format-Debug','Format-ListStream','Format-TableStream','Format-Verbose','Format-Warning','FS','FV','Get-ADUserSnapshot','Get-MyIP','Get-WinADDomainControllers','Remove-ADUserGroups','Remove-Permission','Remove-StringLatinCharacters','Set-ADUserName','Set-ADUserSettingGAL','Set-ADUserStatus','Set-EmailBodyTableReplacement','Set-Inheritance','Set-Permission','Set-Recovery')
