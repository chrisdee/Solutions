function Convert-ImagesToBinary {
    [CmdLetBinding()]
    param(
        [string[]] $Content,
        [string] $Search,
        [string] $ReplacePath
    )
    if ($Content -like "*$Search*") {
        $Replace = "data:image/$FileType;base64," + [Convert]::ToBase64String((Get-Content -LiteralPath $ReplacePath -Encoding Byte))
        $Content = $Content.Replace($Search, $Replace)        
    }
    $Content
}
function Convert-StyleContent {
    [CmdLetBinding()]
    param(
        [string[]] $CSS,
        [string] $ImagesPath,
        [string] $SearchPath
    )

    #Get-ObjectType -Object $CSS -VerboseOnly -Verbose

    $ImageFiles = Get-ChildItem -Path (Join-Path $ImagesPath '\*') -Include *.jpg, *.png, *.bmp #-Recurse
    foreach ($Image in $ImageFiles) {
        #$Image.FullName
        #$Image.Name
        $CSS = Convert-ImagesToBinary -Content $CSS -Search "$SearchPath$($Image.Name)" -ReplacePath $Image.FullName
    }
    return $CSS
}

#

#Convert-StyleContent -ImagesPath "$PSScriptRoot\Resources\Images\DataTables" -SearchPath "DataTables-1.10.18/images/"
function Convert-StyleContent1 {
    param(
        [PSCustomObject] $Options
    )
    # Replace PNG / JPG files in Styles
    if ($null -ne $Options.StyleContent) {
        Write-Verbose "Logos: $($Options.Logos.Keys -join ',')"
        foreach ($Logo in $Options.Logos.Keys) {
            $Search = "../images/$Logo.png", "DataTables-1.10.18/images/$Logo.png"
            $Replace = $Options.Logos[$Logo]
            foreach ($S in $Search) {
                Write-Verbose "Logos - replacing $S with binary representation"
                $Options.StyleContent = ($Options.StyleContent).Replace($S, $Replace)
            }
        }
    }    
}
function Get-FeaturesInUse {
    [CmdletBinding()]
    param()
    foreach ($Key in $Script:HTMLSchema.Features.Keys) {
        if ($Script:HTMLSchema.Features[$Key]) {
            $Key
        }
    }
}
Function Get-HTMLColorSchemes {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)][String]$SchemePath
    )
    if ([String]::IsNullOrEmpty($SchemePath)) {
        $SchemePath = "$PSScriptRoot\Resources\ColorSchemas"
    }
    $Schemes = @{}
    Write-Verbose "Retrieving *.rcs from $SchemePath"
    $SchemeFiles = @(Get-ChildItem $SchemePath -Filter '*.rcs' -Recurse )
    foreach ($SchemeFile in $SchemeFiles) {
        $SchemeContent = Import-Csv -Delimiter ';' -Path $SchemeFile.FullName
        $Schemes.Add($SchemeFile.BaseName, $SchemeContent)
    }
    $Schemes.add('Generated1', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated2', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated3', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated4', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated5', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated6', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated7', (Get-RandomColorScheme -NumberOfSchemes 80))
    $Schemes.add('Generated8', (Get-RandomColorScheme -NumberOfSchemes 80))
    Write-Output $Schemes
}
Function Get-HTMLLogos {
    <#
	 	.SYNOPSIS
		    Get Base64 HTML

	#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [string]$LeftLogoName = "Sample",
        [string]$RightLogoName = "Alternate",
        [string]$LeftLogoString,
        [string]$RightLogoString

    )
    $LogoSources = @{}
    $LogoPath = @()

    if ([String]::IsNullOrEmpty($RightLogoString) -eq $false -or [String]::IsNullOrEmpty($LeftLogoString) -eq $false) {
        if ([String]::IsNullOrEmpty($RightLogoString) -eq $false) {
            $LogoSources.Add($RightLogoName, $RightLogoString)
        }
        if ([String]::IsNullOrEmpty($LeftLogoString) -eq $false) {
            $LogoSources.Add($LeftLogoName, $LeftLogoString)
        }
    } else {
        $LogoPath += "$PSScriptRoot\Resources\Images\Other"
    }
    $LogoPath += "$PSScriptRoot\Resources\Images\DataTables"

    $ImageFiles = Get-ChildItem -Path (join-path $LogoPath '\*') -Include *.jpg, *.png, *.bmp -Recurse
    foreach ($ImageFile in $ImageFiles) {
        if ($ImageFile.Extension -eq '.jpg') {
            $FileType = 'jpeg'
        } else {
            $FileType = $ImageFile.Extension.Replace('.', '')
        }
        Write-Verbose "Converting $($ImageFile.FullName) to base64 ($FileType)"
        $LogoSources.Add($ImageFile.BaseName, "data:image/$FileType;base64," + [Convert]::ToBase64String((Get-Content $ImageFile.FullName -Encoding Byte)))
    }
    Write-Output $LogoSources
}
function Get-HTMLPartContent {
    param(
        [Array] $Content,
        [string] $Start,
        [string] $End,
        [ValidateSet('Before', 'Between', 'After')] $Type = 'Between'
    )
    $NrStart = $Content.IndexOf($Start)
    $NrEnd = $Content.IndexOf($End)   
    
    #Write-Color $NrStart, $NrEnd, $Type -Color White, Yellow, Blue

    if ($Type -eq 'Between') {
        if ($NrStart -eq -1) {
            # return nothing
            return
        }
        $Content[$NrStart..$NrEnd]
    } 
    if ($Type -eq 'After') {
        if ($NrStart -eq -1) {
            # Returns untouched content
            return $Content
        }
        $Content[($NrEnd + 1)..($Content.Count - 1)]

    }
    if ($Type -eq 'Before') {
        if ($NrStart -eq -1) {
            # return nothing
            return
        }
        $Content[0..$NrStart]
    }
}

Function Get-RandomColor {
    <#
    .SYNOPSIS
        Random colour Function
    #>
    param(
        [int]$RMin = 0,
        [int]$RMax = 255,
        [int]$GMin = 0,
        [int]$GMax = 255,
        [int]$BMin = 0,
        [int]$BMax = 255
    )
    $R = (Get-Random -Maximum $RMax -Minimum $RMin)
    $G = (Get-Random -Maximum $GMax -Minimum $GMin)
    $B = (Get-Random -Maximum $BMax -Minimum $BMin)

    @($R, $G, $B)
}
Function Get-RandomColorScheme {
    <#
    .SYNOPSIS
    Generate a colour scheme

    
    .DESCRIPTION
    Generate a colour scheme
    
    .PARAMETER NumberOfSchemes
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    param
    (
        [Parameter(Mandatory = $false)][int]$NumberOfSchemes = 1,
        [int] $ColorSwing = 8,        
        [string] $Hover = 0.3,
        [string] $color = 0.6,
        [string] $border = 1,
        [string] $background = 0.7
    )

    $ColorReference = Get-Random -Minimum 1 -Maximum 3
    $BaseColor = (Get-Random -Maximum (200 - $ColorSwing) -Minimum (50 + $ColorSwing))
    $BCMax = $BaseColor + $ColorSwing
    $BCMin = $BaseColor - $ColorSwing

    $i = 0
    while ($i -ne $NumberOfSchemes) {       
        switch ($ColorReference) {
            1 { [int[]] $base = Get-RandomColor -rmin $BCMin -rmax $BCMax }
            2 { [int[]] $base = Get-RandomColor -gmin $BCMin -gmax $BCMax }
            3 { [int[]] $base = Get-RandomColor -bmin $BCMin -bcmax $BCMax }
        }

        [PSCustomObject] @{
            Background = "rgba($($base + $background -join ','))"
            Border     = "rgba($($base + $border -join ','))"
            Colour     = "rgba($($base + $color -join ','))"
            Hover      = "rgba($($base + $Hover -join ','))"
        }
        $i++
    }


}
function Get-Resources {
    [CmdLetBinding()]
    param(
        [switch] $UseCssLinks,
        [switch] $UseJavaScriptLinks, 
        [ValidateSet('Header', 'Footer', 'HeaderAlways', 'FooterAlways')][string] $Location
    )
    DynamicParam {
        # Defines Features Parameter Dynamically
        $Names = $Script:Configuration.Features.Keys
        $ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
        $ParamAttrib.Mandatory = $true
        $ParamAttrib.ParameterSetName = '__AllParameterSets'

        $ReportAttrib = New-Object  System.Collections.ObjectModel.Collection[System.Attribute]
        $ReportAttrib.Add($ParamAttrib)
        $ReportAttrib.Add((New-Object System.Management.Automation.ValidateSetAttribute($Names)))
        $ReportRuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Features', [string[]], $ReportAttrib)
        $RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Features', $ReportRuntimeParam)
        return $RuntimeParamDic
    }
    Process {
        [string[]] $Features = $PSBoundParameters.Features
        
        foreach ($Feature in $Features) {
            
            Write-Verbose "Get-Resources - Location: $Location - Feature: $Feature UseCssLinks: $UseCssLinks UseJavaScriptLinks: $UseJavaScriptLinks"
            if ($UseCssLinks) {
                New-HTMLResourceCSS -Link $Script:Configuration.Features.$Feature.$Location.'CssLink' -ResourceComment $Script:Configuration.Features.$Feature.Comment
            } else {
                $CSSOutput = New-HTMLResourceCSS -FilePath $Script:Configuration.Features.$Feature.$Location.'Css' -ResourceComment $Script:Configuration.Features.$Feature.Comment 
                Convert-StyleContent -CSS $CSSOutput -ImagesPath "$PSScriptRoot\Resources\Images\DataTables" -SearchPath "DataTables-1.10.18/images/"
            }
            if ($UseJavaScriptLinks) {
                New-HTMLResourceJS -Link $Script:Configuration.Features.$Feature.$Location.'JsLink' -ResourceComment $Script:Configuration.Features.$Feature.Comment 
            } else {
                New-HTMLResourceJS -FilePath $Script:Configuration.Features.$Feature.$Location.'Js' -ResourceComment $Script:Configuration.Features.$Feature.Comment 
            }
        }
        
    }

}
function New-ApexChart {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [ValidateSet('', 'central')][string] $Positioning
    )
    $Script:HTMLSchema.Features.ChartsApex = $true
    [string] $ID = "ChartID-" + (Get-RandomStringName -Size 8)
    $Div = New-HTMLTag -Tag 'div' -Attributes @{ id = $ID; class = $Positioning }
    $Script = New-HTMLTag -Tag 'script' -Value {
        # Convert Dictionary to JSON and return chart within SCRIPT tag
        # Make sure to return with additional empty string
        $JSON = $Options | ConvertTo-Json -Depth 5 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
        "var options = $JSON"
        ""
        "var chart = new ApexCharts(document.querySelector('#$ID'),
            options
        );"
        "chart.render();"
    }
    $Div
    # we need to move it to the end of the code therefore using additional vesel
    $Script:HTMLSchema.Charts.Add($Script)
}
function New-ChartArea {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,

        [Array] $Data,
        [Array] $DataNames,
        [Array] $DataLegend,

        #[bool] $DataLabelsEnabled = $true,
        #[int] $DataLabelsOffsetX = -6,
        #[string] $DataLabelsFontSize = '12px',
        #[nullable[RGBColors]] $DataLabelsColor,
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category'

        #$Type
    )
    # Chart defintion type, size
    $Options.chart = @{
        type = 'area'
    }

    $Options.series = @( New-HTMLChartDataSet -Data $Data -DataNames $DataNames )

    # X AXIS - CATEGORIES
    $Options.xaxis = [ordered] @{}
    if ($DataCategoriesType -ne '') {
        $Options.xaxis.type = $DataCategoriesType
    }
    if ($DataCategories.Count -gt 0) {
        $Options.xaxis.categories = $DataCategories
    }

}
function New-ChartAxisX {
    param(
        [System.Collections.IDictionary] $Options,
        [string] $Title,
        [int] $MinValue,
        [int] $MaxValue,
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',
        $DataCategories
    )

    if (-not $Options.Contains('xaxis')) {
        $Options.xaxis = @{}
    }
    if ($Title -ne '') {
        $Options.xaxis.title = @{}
        $Options.xaxis.title.text = $Title
    }
    if ($MinValue -gt 0) {
        $Options.xaxis.min = $MinValue
    }
    if ($MinValue -gt 0) {
        $Options.xaxis.max = $MaxValue
    }
    if ($DataCategoriesType -ne '') {
        $Options.xaxis.type = $DataCategoriesType
    }
    if ($DataCategories.Count -gt 0) {
        $Options.xaxis.categories = $DataCategories
    }
}
function New-ChartAxisY {
    param(
        [System.Collections.IDictionary] $Options,
        [string] $Title,
        [int] $MinValue,
        [int] $MaxValue
    )
    if (-not $Options.Contains('yaxis')) {
        $Options.yaxis = @{}
    }
    if ($Title -ne '') {
        $Options.yaxis.title = @{}
        $Options.yaxis.title.text = $Title
    }
    if ($MinValue -gt 0) {
        $Options.yaxis.min = $MinValue
    }
    if ($MinValue -gt 0) {
        $Options.yaxis.max = $MaxValue
    }
}
Function New-ChartBar {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [bool] $Horizontal = $true,
        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [RGBColors[]] $DataLabelsColor,

        [string] $Title,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [string] $Formatter,
        [ValidateSet('bar', 'barStacked', 'barStacked100Percent')] $Type = 'bar',

        [RGBColors[]] $Colors,

        [switch] $PatternedColors,
        [switch] $Distributed,

        [Array] $Data,
        [Array] $DataNames,
        [Array] $DataLegend
    )

    if ($Type -eq 'bar') {
        $Options.chart = [ordered] @{
            type = 'bar'
        }
    } elseif ($Type -eq 'barStacked') {
        $Options.chart = [ordered] @{
            type    = 'bar'
            stacked = $true
        }
    } else {
        $Options.chart = [ordered] @{
            type      = 'bar'
            stacked   = $true
            stackType = '100%'
        }
    }

    if ($Colors.Count -gt 0) {
        $RGBColor = ConvertFrom-Color -Color $Colors
        $Options.colors = @($RGBColor)
    }

    $Options.plotOptions = @{
        bar = @{
            horizontal = $Horizontal
        }
    }
    if ($Distributed) {
        $Options.plotOptions.bar.distributed = $Distributed.IsPresent
    }
    $Options.dataLabels = [ordered] @{
        enabled = $DataLabelsEnabled
        offsetX = $DataLabelsOffsetX
        style   = @{
            fontSize = $DataLabelsFontSize
        }
    }
    if ($null -ne $DataLabelsColor) {
        $RGBColorLabel = ConvertFrom-Color -Color $DataLabelsColor
        $Options.dataLabels.style.colors = @($RGBColorLabel)
    }
    $Options.series = @(New-HTMLChartDataSet -Data $Data -DataNames $DataLegend)

    # X AXIS - CATEGORIES
    $Options.xaxis = [ordered] @{}
    # if ($DataCategoriesType -ne '') {
    #    $Options.xaxis.type = $DataCategoriesType
    #}
    if ($DataNames.Count -gt 0) {
        $Options.xaxis.categories = $DataNames
        # Need to figure out how to conver to json and leave function without ""
        #if ($Formatter -ne '') {
        #$Options.xaxis.labels = @{
        #formatter = "function(val) { return val + `"$Formatter`" }"
        #}
        #}
    }

    New-ChartTitle -Options $Options -Title $Title -TitleAlignment $TitleAlignment

     if ($PatternedColors) {
        $Options.fill = @{
            type    = 'pattern'
            opacity = 1
            pattern = @{
                style = @('circles', 'slantedLines', 'verticalLines', 'horizontalLines')
            }
        }
    }
}
function New-ChartDataLabels {
    param(
        [System.Collections.IDictionary] $Options,
        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [RGBColors[]] $DataLabelsColor
    )

    $Options.dataLabels = [ordered] @{
        enabled = $DataLabelsEnabled
        offsetX = $DataLabelsOffsetX
        style   = @{
            fontSize = $DataLabelsFontSize
        }
    }
    if ($DataLabelsColor.Count -gt 0) {
        $Options.dataLabels.style.colors = @(ConvertFrom-Color -Color $DataLabelsColor)
    }
}
function New-ChartGridColors {
    param(
        [System.Collections.IDictionary] $Options,
        [RGBColors[]] $GridColors,
        [double] $GridOpacity
    )
    $Options.grid = @{}
    $Options.grid.row = @{}

    if ($GridColors.Count -gt 0) {
        $Options.grid.row.colors = @(ConvertFrom-Color -Color $GridColors)
    }
    if ($GridOpacity -ne 0) {
        $Options.grid.row.opacity = $GridOpacity
    }
}

function New-ChartLegend {
    param(
        [System.Collections.IDictionary] $Options,
        [ValidateSet('top', 'topRight', 'left', 'right', 'bottom', '')][string] $LegendPosition = ''
    )
    # legend
    if ($LegendPosition -eq '' -or $LegendPosition -eq 'bottom') {
        # Do nothing
    } elseif ($LegendPosition -eq 'right') {
        $Options.legend = [ordered]@{
            position = 'right'
            offsetY  = 100
            height   = 230
        }
    } elseif ($LegendPosition -eq 'top') {
        $Options.legend = [ordered]@{
            position        = 'top'
            horizontalAlign = 'left'
            offsetX         = 40
        }
    } elseif ($LegendPosition -eq 'topRight') {
        $Options.legend = [ordered]@{
            position        = 'top'
            horizontalAlign = 'right'
            floating        = true
            offsetY         = -25
            offsetX         = -5
        }
    }
}
function New-ChartLine {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,

        [Array] $Data,
        [Array] $DataNames,
        #[Array] $DataLegend,

        # [bool] $DataLabelsEnabled = $true,
        #[int] $DataLabelsOffsetX = -6,
        #[string] $DataLabelsFontSize = '12px',
        # [nullable[RGBColors]] $DataLabelsColor,
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category'

        # $Type
    )
    # Chart defintion type, size
    $Options.chart = @{
        type = 'line'
    }

    $Options.series = @( New-HTMLChartDataSet -Data $Data -DataNames $DataNames )

    # X AXIS - CATEGORIES
    $Options.xaxis = [ordered] @{}
    if ($DataCategoriesType -ne '') {
        $Options.xaxis.type = $DataCategoriesType
    }
    if ($DataCategories.Count -gt 0) {
        $Options.xaxis.categories = $DataCategories
    }

}
function New-ChartMarker {
    param(
        [System.Collections.IDictionary] $Options,
        [int] $MarkerSize
    )
    if ($MarkerSize -gt 0) {
        $Options.markers = @{
            size = $MarkerSize
        }
    }
}
function New-ChartRadial {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [Array] $Values,
        [Array] $Names,
        $Type
    )
    # Chart defintion type, size
    $Options.chart = @{
        type = 'radialBar'
    }

    if ($Type -eq '1') {
        New-ChartRadialType1 -Options $Options
    } elseif ($Type -eq '2') {
        New-ChartRadialType2 -Options $Options
    }

    $Options.series = @($Values)
    $Options.labels = @($Names)


}
function New-ChartRadialCircleType {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [ValidateSet('FullCircleTop', 'FullCircleBottom', 'FullCircleBottomLeft', 'FullCircleLeft', 'Speedometer', 'SemiCircleGauge')] $CircleType
    )
    if ($CircleType -eq 'SemiCircleGauge') {
        $Options.plotOptions.radialBar = [ordered] @{
            startAngle = -90
            endAngle   = 90
        }
    } elseif ($CircleType -eq 'FullCircleBottom') {
        $Options.plotOptions.radialBar = [ordered] @{
            startAngle = -180
            endAngle   = 180
        }
    } elseif ($CircleType -eq 'FullCircleLeft') {
        $Options.plotOptions.radialBar = [ordered] @{
            startAngle = -90
            endAngle   = 270
        }
    } elseif ($CircleType -eq 'FullCircleBottomLeft') {
        $Options.plotOptions.radialBar = [ordered] @{
            startAngle = -135
            endAngle   = 225
        }
    } elseif ($CircleType -eq 'Speedometer') {
        $Options.plotOptions.radialBar = [ordered] @{
            startAngle = -135
            endAngle   = 135
        }
    } else {
        #FullCircleTop
    }
}
function New-ChartRadialDataLabels {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [string] $LabelAverage = 'Average'
    )
    if ($LabelAverage -ne '') {
        $Options.plotOptions.radialBar.dataLabels = @{
            showOn = 'always'

            name   = @{
                # fontSize = '16px'
                # color    = 'undefined'
                #offsetY = 120
            }
            value  = @{
                #offsetY = 76
                #  fontSize  = '22px'
                #  color     = 'undefined'
                # formatter = 'function (val) { return val + "%" }'
            }

            total  = @{
                show  = $true
                label = $LabelAverage
            }

        }
    }
}

function New-ChartRadialType1 {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [Array] $Values,
        [Array] $Names
    )

    $Options.plotOptions = @{
        radialBar = [ordered] @{
            #startAngle = -135
            #endAngle   = 225

            #startAngle = -135
            #endAngle   = 135


            hollow = [ordered] @{
                margin       = 0
                size         = '70%'
                background   = '#fff'
                image        = 'undefined'
                imageOffsetX = 0
                imageOffsetY = 0
                position     = 'front'
                dropShadow   = @{
                    enabled = $true
                    top     = 3
                    left    = 0
                    blur    = 4
                    opacity = 0.24
                }
            }
            track  = [ordered] @{
                background  = '#fff'
                strokeWidth = '70%'
                margin      = 0  #// margin is in pixels
                dropShadow  = [ordered] @{
                    enabled = $true
                    top     = -3
                    left    = 0
                    blur    = 4
                    opacity = 0.35
                }
            }
            <#
            dataLabels = @{
                showOn = 'always'

                name   = @{
                    # fontSize = '16px'
                    # color    = 'undefined'
                    #offsetY = 120
                }
                value  = @{
                    #offsetY = 76
                    #  fontSize  = '22px'
                    #  color     = 'undefined'
                    # formatter = 'function (val) { return val + "%" }'
                }

                total  = @{
                    show  = $false
                    label = 'Average'
                }
            }
            #>
        }
    }

    $Options.fill = [ordered] @{
        type     = 'gradient'
        gradient = [ordered] @{
            shade            = 'dark'
            type             = 'horizontal'
            shadeIntensity   = 0.5
            gradientToColors = @('#ABE5A1')
            inverseColors    = true
            opacityFrom      = 1
            opacityTo        = 1
            stops            = @(0, 100)
        }
    }
    <# Gradient
        $Options.stroke = @{
        lineCap = 'round'
    }
    #>
    <#
    $Options.fill = @{
        type     = 'gradient'
        gradient = @{
            shade          = 'dark'
            shadeIntensity = 0.15
            inverseColors  = false
            opacityFrom    = 1
            opacityTo      = 1
            stops          = @(0, 50, 65, 91)
        }
    }
    #>
    $Options.stroke = [ordered] @{
        dashArray = 4
    }
}

function New-ChartRadialType2 {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [Array] $Values,
        [Array] $Names
    )
    $Options.plotOptions = @{
        radialBar = [ordered] @{

            #startAngle = -135
            #endAngle   = 225

            #startAngle = -135
            #endAngle   = 135


            hollow = [ordered] @{
                margin       = 0
                size         = '70%'
                background   = '#fff'
                image        = 'undefined'
                imageOffsetX = 0
                imageOffsetY = 0
                position     = 'front'
                dropShadow   = @{
                    enabled = $true
                    top     = 3
                    left    = 0
                    blur    = 4
                    opacity = 0.24
                }
            }
            <#
            track      = @{
                background  = '#fff'
                strokeWidth = '70%'
                margin      = 0  #// margin is in pixels
                dropShadow  = @{
                    enabled = $true
                    top     = -3
                    left    = 0
                    blur    = 4
                    opacity = 0.35
                }
            }
            dataLabels = @{
                showOn = 'always'

                name   = @{
                    # fontSize = '16px'
                    # color    = 'undefined'
                    offsetY = 120
                }
                value  = @{
                    offsetY = 76
                    #  fontSize  = '22px'
                    #  color     = 'undefined'
                    # formatter = 'function (val) { return val + "%" }'
                }

                total  = @{
                    show  = $false
                    label = 'Average'
                }
            }
            #>
        }
    }
}
function New-ChartSize {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width
    )
    if ($null -ne $Height) {
        $Options.chart.height = $Height
    }
    if ($null -ne $Width) {
        $Options.chart.width = $Width
    }
}
function New-ChartSpark {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [nullable[RGBColors]] $Color,
        [string] $Title,
        [string] $SubTitle,
        [int] $FontSizeTitle = 24,
        [int] $FontSizeSubtitle = 14,
        [Array] $Values
    )
    if ($Values.Count -eq 0) {
        Write-Warning 'Get-ChartSpark - Values Empty'
    }

    if ($null -ne $Color) {
        $ColorRGB = ConvertFrom-Color -Color $Color
        $Options.colors = @($ColorRGB)
    }
    $Options.chart = [ordered] @{
        type      = 'area'
        sparkline = @{
            enabled = $true
        }
    }
    $Options.stroke = @{
        curve = 'straight'
    }
    $Options.title = [ordered] @{
        text    = $Title
        offsetX = 0
        style   = @{
            fontSize = "$($FontSizeTitle)px"
            cssClass = 'apexcharts-yaxis-title'
        }
    }
    $Options.subtitle = [ordered] @{
        text    = $SubTitle
        offsetX = 0
        style   = @{
            fontSize = "$($FontSizeSubtitle)px"
            cssClass = 'apexcharts-yaxis-title'
        }
    }
    $Options.yaxis = @{
        min = 0
    }
    $Options.fill = @{
        opacity = 0.3
    }
    $Options.series = @(
        # Checks if it's multiple array passed or just one. If one it will draw one line, if more then one it will draw line per each array
        if ($Values[0] -is [Array]) {
            foreach ($Value in $Values) {
                @{
                    data = @($Value)
                }
            }
        } else {
            @{
                data = @($Values)
            }
        }
    )
}
function New-ChartStrokeDefinition {
    param(
        [System.Collections.IDictionary] $Options,
        [bool] $LineShow = $true,
        [ValidateSet('straight', 'smooth', 'stepline')] $LineCurve = 'straight',
        [int] $LineWidth,
        [RGBColors[]] $LineColor
    )
    # LINE Definition
    $Options.stroke = [ordered] @{
        show  = $LineShow
        curve = $LineCurve
    }
    if ($LineWidth -ne 0) {
        $Options.stroke.width = $LineWidth
    }
    if ($LineColor.Count -gt 0) {
        $Options.stroke.colors = @(ConvertFrom-Color -Color $LineColor)
    }
}
function New-ChartTitle {
    param(
        [System.Collections.IDictionary] $Options,
        [string] $Title,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = ''
    )
    # title
    $Options.title = [ordered] @{}
    if ($TitleText -ne '') {
        $Options.title.text = $Title
    }
    if ($TitleAlignment -ne '') {
        $Options.title.align = $TitleAlignment
    }
}
function New-ChartToolbar {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [bool] $Show = $true,
        [bool] $Download = $true,
        [bool] $Selection = $true,
        [bool] $Zoom = $true,
        [bool] $ZoomIn = $true,
        [bool] $ZoomOut = $true,
        [bool] $Pan = $true,
        [bool] $Reset = $true
    )
    $Options.chart.toolbar = [ordered] @{
        show         = $show
        tools        = [ordered] @{
            download  = $Download
            selection = $Selection
            zoom      = $Zoom
            zoomin    = $ZoomIn
            zoomout   = $ZoomOut
            pan       = $Pan
            reset     = $Reset
        }
        autoSelected = 'zoom'
    }
}
function New-ChartZoom {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Options,
        [switch] $Enabled
    )
    if ($Enabled) {
        $Options.chart.zoom = @{
            type    = 'x'
            enabled = $Enabled.IsPresent
        }
    }
}
Function New-HTML {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][ValidateNotNull()][ScriptBlock] $HtmlData = $(Throw "Have you put the open curly brace on the next line?"),
        [switch] $UseCssLinks,
        [switch] $UseJavaScriptLinks,
        [String] $TitleText,
        [String] $ColorSchemePath,
        [string] $PrimaryColorHex,
        [string] $Author,
        [string] $DateFormat = 'yyyy-MM-dd HH:mm:ss',

        # save HTML options
        [Parameter(Mandatory = $false)][string]$FilePath,
        [Parameter(Mandatory = $false)][switch]$ShowHTML,
        [int] $AutoRefresh
    )

    [string] $CurrentDate = (Get-Date).ToString($DateFormat)

    <#
    $Options = New-HTMLReportOptions `
        -RightLogoName $RightLogoName `
        -LeftLogoName LeftLogoName  `
        -LeftLogoString $LeftLogoString `
        -RightLogoString $RightLogoString `
        -CSSName $CSSName `
        -CSSPath $CSSPath `
        -ScriptPath $ScriptPath `
        -ColorSchemePath $ColorSchemePath `
        -UseCssLinks:$UseCssLinks `
        -UseStyleLinks:$UseStyleLinks
    #>
    $Script:HTMLSchema = @{
        TabsHeaders = [System.Collections.Generic.List[HashTable]]::new() # tracks / stores headers
        Features    = @{} # tracks features for CSS/JS implementation
        Charts      = [System.Collections.Generic.List[string]]::new()
    }
    $OutputHTML = Invoke-Command -ScriptBlock $HtmlData
    $Logo = Get-HTMLPartContent -Content $OutputHTML -Start '<!-- START LOGO -->' -End '<!-- END LOGO -->' -Type Between
    $OutputHTML = Get-HTMLPartContent -Content $OutputHTML -Start '<!-- START LOGO -->' -End '<!-- END LOGO -->' -Type After
    $Features = Get-FeaturesInUse

    $HTML = @(
        '<!DOCTYPE html>'
        New-HTMLTag -Tag 'html' {
            '<!-- HEADER -->'
            New-HTMLTag -Tag 'head' {
                New-HTMLTag -Tag 'meta' -Attributes @{ charset = "utf-8" } -SelfClosing
                New-HTMLTag -Tag 'meta' -Attributes @{ name = 'viewport'; content = 'width=device-width, initial-scale=1' } -SelfClosing
                New-HTMLTag -Tag 'meta' -Attributes @{ name = 'author'; content = $Author } -SelfClosing
                New-HTMLTag -Tag 'meta' -Attributes @{ name = 'revised'; content = $CurrentDate } -SelfClosing
                New-HTMLTag -Tag 'title' { $TitleText }
                if ($Autorefresh -gt 0) {
                    New-HTMLTag -Tag 'meta' -Attributes @{ 'http-equiv' = 'refresh'; content = $Autorefresh } -SelfClosing
                }

                Get-Resources -UseCssLinks:$true -UseJavaScriptLinks:$true -Location 'HeaderAlways' -Features Default, DefaultHeadings, Fonts, FontsAwesome
                Get-Resources -UseCssLinks:$false -UseJavaScriptLinks:$false -Location 'HeaderAlways' -Features Default, DefaultHeadings
                if ($null -ne $Features) {
                    Get-Resources -UseCssLinks:$true -UseJavaScriptLinks:$true -Location 'HeaderAlways' -Features $Features
                    Get-Resources -UseCssLinks:$false -UseJavaScriptLinks:$false -Location 'HeaderAlways' -Features $Features
                    Get-Resources -UseCssLinks:$UseCssLinks -UseJavaScriptLinks:$UseJavaScriptLinks -Location 'Header' -Features $Features
                }
            }
            '<!-- END HEADER -->'
            '<!-- BODY -->'
            #'<body onload="hide();">'
            New-HTMLTag -Tag 'body' {

                <#
            if ($HideLogos -eq $false) {
                $Leftlogo = $Options.Logos[$LeftLogoName]
                $Rightlogo = $Options.Logos[$RightLogoName]
                $LogoContent = @"
                <table><tbody>
                <tr>
                    <td class="clientlogo"><img src="$Leftlogo" /></td>
                    <td class="MainLogo"><img src="$Rightlogo" /></td>
                </tr>
                </tbody></table>
"@
                $LogoContent
            }
            #>
                <# Not sure what for
            if (!([string]::IsNullOrEmpty($PrimaryColorHex))) {
                if ($PrimaryColorHex.Length -eq 7) {
                    $HTML = $HTML -replace '#337E94', $PrimaryColorHex
                } else {
                    Write-Warning '$PrimaryColorHex must be 7 characters with hash eg "#337E94"'
                }
            }
            #>

                # Add logo if there is one
                $Logo

                # Add tabs header if there is one
                if ($Script:HTMLSchema.TabsHeaders) {
                    New-HTMLTabHead
                }
                # Add remaining data
                $OutputHTML

                # Add charts scripts if those are there
                foreach ($Chart in $Script:HTMLSchema.Charts) {
                    $Chart
                }
            }
            '<!-- END BODY -->'
            '<!-- FOOTER -->'
            New-HTMLTag -Tag 'footer' {
                if ($null -ne $Features) {
                    # FooterAlways means we're not able to provide consistent output with and without links and we prefer those to be included
                    # either as links or from file per required features
                    Get-Resources -UseCssLinks:$true -UseJavaScriptLinks:$true -Location 'FooterAlways' -Features $Features
                    Get-Resources -UseCssLinks:$false -UseJavaScriptLinks:$false -Location 'FooterAlways' -Features $Features
                    # standard footer features
                    Get-Resources -UseCssLinks:$UseCssLinks -UseJavaScriptLinks:$UseJavaScriptLinks -Location 'Footer' -Features $Features
                }
            }
            '<!-- END FOOTER -->'
        }
    )
    if ($FilePath -ne '') {
        Save-HTML -HTML $HTML -FilePath $FilePath -ShowHTML:$ShowHTML #-Supress:$Supress
    } else {
        $HTML
    }
}
function New-HTMLAnchor {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Name
    Parameter description
    
    .PARAMETER Id
    Parameter description
    
    .PARAMETER Target
    Parameter description
    
    .PARAMETER Class
    Parameter description
    
    .PARAMETER HrefLink
    Parameter description
    
    .PARAMETER OnClick
    Parameter description
    
    .PARAMETER Style
    Parameter description
    
    .PARAMETER Text
    Parameter description
    
    .EXAMPLE
    New-HTMLAnchor -Target _parent

    New-HTMLAnchor -Id "show_$RandomNumber" -Href '#' -OnClick "show('$RandomNumber');" -Style "color: #ffffff; display:none;" -Text 'Show' 

    Output:
    <a target = "_parent" />
    
    .NOTES
    General notes
    #>
    

    param(
        [alias('AnchorName')][string] $Name,
        [string] $Id,
        [string] $Target, # "_blank|_self|_parent|_top|framename"
        [string] $Class,
        [alias('Url', 'Link', 'UrlLink', 'Href')][string] $HrefLink,
        [string] $OnClick,
        [string] $Style,
        [alias('AnchorText', 'Value')][string] $Text
    )
    $Attributes = [ordered]@{
        'id'      = $Id
        'name'    = $Name
        'class'   = $Class
        'target'  = $Target
        'href'    = $HrefLink
        'onclick' = $OnClick
        'style'   = $Style
    }
    New-HTMLTag -Tag 'a' -Attributes $Attributes {
        $Text
    }
}
Function New-HTMLAnchorLink {
    <#
    .SYNOPSIS
    Creates Hyperlink for an Anchor

    .DESCRIPTION
    Long description

    .PARAMETER AnchorName
    The Actual name of the Anchor (Hidden)

    .PARAMETER AnchorText
    The HyperLink text.  Will default to $AnchorNname if not specified

    .EXAMPLE
    Get-HTMLAnchorLink -AnchorName 'test'

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)][String] $AnchorName,
        [Parameter(Mandatory = $false)][String] $AnchorText
    )
    if ($AnchorText -eq $null -or $AnchorText -eq '') {
        $AnchorText = $AnchorName
    }
    New-HTMLAnchor -Name $AnchorName -HrefLink '#' -Class 'alink' -Text $AnchorText
}
Function New-HTMLAnchorName {
    <#
    .SYNOPSIS
    Creates an anchor

    .DESCRIPTION
    Long description

    .PARAMETER AnchorName
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)][String] $AnchorName
    )
    New-HTMLAnchor -Name $AnchorName
}
function New-HTMLCanvas {
    [CmdletBinding()]
    param(
        [alias('Value')][Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content = $(Throw "Open curly brace with Content"),
        [string] $ID,
        [string] $Width,
        [string] $Height,
        [string] $Style
    )
    $Canvas = [Ordered] @{
        Tag         = 'canvas'
        Attributes  = [ordered]@{
            'id'     = $Id
            'width'  = $Width
            'height' = $Height
            'style'  = $Style
        }
        SelfClosing = $false
        Value       = Invoke-Command -ScriptBlock $Content
    }
    $HTML = Set-Tag -HtmlObject $Canvas
    return $HTML
}
function New-HTMLChart {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [string] $Type = 'bar',
        [bool] $Horizontal = $true,
        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [RGBColors] $DataLabelsColor,
        [Array] $Data = @(),
        [Array] $DataNames = @(),
        [Array] $DataCategories = @(),
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',
        [string] $TitleText,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [bool] $LineShow = $true,
        [ValidateSet('straight', 'smooth')] $LineCurve = 'straight',
        $LineWidth = 2,
        [RGBColors[]] $LineColor,
        [ValidateSet('', 'central')][string] $Positioning
    )




    $Options = [ordered] @{}

    # Chart defintion type, size
    $Options.chart = @{
        type = $Type
    }


    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options


    $Options.plotOptions = @{
        bar = @{
            horizontal = $Horizontal
        }
    }
    $Options.dataLabels = [ordered] @{
        enabled = $DataLabelsEnabled
        offsetX = $DataLabelsOffsetX
        style   = @{
            fontSize = $DataLabelsFontSize
            colors   = @($DataLabelsColor)
        }
    }
    if ('bar', 'line' -contains $Type) {
        # Some types require a more complicated dataset
        $Options.series = @( New-HTMLChartDataSet -Data $Data -DataNames $DataNames )
    } else {
        # Some types of charts require simple data sets - in particular just array
        $Options.series = $Data
        if ($null -ne $DataCategories) {
            $Options.labels = $DataCategories
        } else {
            $Options.labels = $DataNames
        }
    }
    # X AXIS - CATEGORIES
    $Options.xaxis = [ordered] @{}
    if ($DataCategoriesType -ne '') {
        $Options.xaxis.type = $DataCategoriesType
    }
    if ($DataCategories.Count -gt 0) {
        $Options.xaxis.categories = $DataCategories
    }

    # LINE Definition
    $Options.stroke = [ordered] @{
        show   = $LineShow
        curve  = $LineCurve
        width  = $LineWidth
        colors = @(ConvertFrom-Color -Color $LineColor)
    }


    $Options.legend = @{
        position = 'right'
        offsetY  = 100
        height   = 230
    }

    # title
    $Options.title = [ordered] @{}
    if ($TitleText -ne '') {
        $Options.title.text = $TitleText
    }
    if ($TitleAlignment -ne '') {
        $Options.title.align = $TitleAlignment
    }


    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options
    New-ApexChart -Positioning $Positioning -Options $Options
}
function New-HTMLChartArea {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [ValidateSet('', 'central')][string] $Positioning,

        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [RGBColors[]] $DataLabelsColor,
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',

        [ValidateSet('straight', 'smooth', 'stepline')] $LineCurve = 'straight',
        [int] $LineWidth,
        [RGBColors[]] $LineColor,

        [RGBColors[]] $GridColors,
        [double] $GridOpacity,

        [string] $Title,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [ValidateSet('top', 'topRight', 'left', 'right', 'bottom', '')][string] $LegendPosition = '',

        [string] $TitleX,
        [string] $TitleY,

        [int] $MarkerSize,

        [Array] $Data,
        [Array] $DataNames,
        [Array] $DataLegend,

        [switch] $Zoom
    )

    $Options = [ordered] @{}

    New-ChartArea -Options $Options -Data $Data -DataNames $DataNames

    New-ChartStrokeDefinition -Options $Options `
        -LineShow $true `
        -LineCurve $LineCurve `
        -LineWidth $LineWidth `
        -LineColor $LineColor

    New-ChartDataLabels -Options $Options `
        -DataLabelsEnabled $DataLabelsEnabled `
        -DataLabelsOffsetX $DataLabelsOffsetX `
        -DataLabelsFontSize $DataLabelsFontSize `
        -DataLabelsColor $DataLabelsColor

    New-ChartAxisX -Options $Options `
        -Title $TitleX `
        -DataCategoriesType $DataCategoriesType `
        -DataCategories $DataLegend

    New-ChartAxisY -Options $Options `
        -Title $TitleY

    New-ChartMarker -Options $Options -MarkerSize $MarkerSize

    New-ChartTitle -Options $Options -Title $Title -TitleAlignment $TitleAlignment
    New-ChartGridColors -Options $Options -GridColors $GridColors -GridOpacity $GridOpacity

    New-ChartLegend -Options $Options -LegendPosition $LegendPosition

    New-ChartSize -Options $Options -Height $Height -Width $Width

    New-ChartZoom -Options $Options -Enabled:$Zoom
    New-ChartToolbar -Options $Options
    New-ApexChart -Positioning $Positioning -Options $Options
}
function New-HTMLChartBar {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [ValidateSet('', 'central')][string] $Positioning,
        [ValidateSet('bar', 'barStacked', 'barStacked100Percent')] $Type = 'bar',
        <#

        [Array] $DataCategories = @(),
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',


        [bool] $LineShow = $true,
        [ValidateSet('straight', 'smooth')] $LineCurve = 'straight',
        $LineWidth = 2,
        [RGBColors[]] $LineColor,
        #>

        [RGBColors[]] $Colors,

        [switch] $PatternedColors,

        [string] $Title,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [bool] $Horizontal = $true,
        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [nullable[RGBColors]] $DataLabelsColor,

        [switch] $Distributed,

        #[string] $Formatter,

        [ValidateSet('top', 'topRight', 'left', 'right', 'bottom', '')][string] $LegendPosition = '',

        [Array] $Data,
        [Array] $DataNames,
        [Array] $DataLegend

    )




    $Options = [ordered] @{}
    New-ChartBar -Options $Options -Horizontal $Horizontal -DataLabelsEnabled $DataLabelsEnabled `
        -DataLabelsOffsetX $DataLabelsOffsetX -DataLabelsFontSize $DataLabelsFontSize -DataLabelsColor $DataLabelsColor `
        -Data $Data -DataNames $DataNames -DataLegend $DataLegend -Title $Title -TitleAlignment $TitleAlignment `
        -Type $Type -Colors $Colors `
        -PatternedColors:$PatternedColors -Distributed:$Distributed


    New-ChartLegend -Options $Options -LegendPosition $LegendPosition
    #-Formatter $Formatter


    <#
    if ('bar', 'line' -contains $Type) {
        # Some types require a more complicated dataset
        $Options.series = @( New-HTMLChartDataSet -Data $Data -DataNames $DataNames )
    } else {
        # Some types of charts require simple data sets - in particular just array
        $Options.series = $Data
        if ($null -ne $DataCategories) {
            $Options.labels = $DataCategories
        } else {
            $Options.labels = $DataNames
        }
    }

    # X AXIS - CATEGORIES
    $Options.xaxis = [ordered] @{}
    if ($DataCategoriesType -ne '') {
        $Options.xaxis.type = $DataCategoriesType
    }
    if ($DataCategories.Count -gt 0) {
        $Options.xaxis.categories = $DataCategories
    }

    # LINE Definition
    $Options.stroke = [ordered] @{
        show   = $LineShow
        curve  = $LineCurve
        width  = $LineWidth
        colors = @(ConvertFrom-Color -Color $LineColor)
    }


    $Options.legend = @{
        position = 'right'
        offsetY  = 100
        height   = 230
    }



#>
    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options
    New-ApexChart -Positioning $Positioning -Options $Options
}
function New-HTMLChartDataSet {
    [CmdletBinding()]
    param(
        [Array] $Data,
        [Array] $DataNames
    )

    if ($null -ne $Data -and $null -ne $DataNames) {
        if ($Data[0] -is [Array]) {
            # If it's array of Arrays
            if ($Data[0].Count -eq $DataNames.Count) {
                for ($a = 0; $a -lt $Data.Count; $a++) {
                    @{
                        name = $DataNames[$a]
                        data = $Data[$a]
                    }
                }
            } elseif ($Data.Count -eq $DataNames.Count) {
                for ($a = 0; $a -lt $Data.Count; $a++) {
                    @{
                        name = $DataNames[$a]
                        data = $Data[$a]
                    }
                }
            } else {
                # rerun with just data (so it checks another if)
                New-HTMLChartDataSet -Data $Data
            }

        } else {
            if ($null -ne $DataNames) {
                # If it's just int in Array
                @{
                    name = $DataNames
                    data = $Data
                }
            } else {
                @{
                    data = $Data
                }
            }
        }

    } elseif ($null -ne $Data) {
        # No names given
        if ($Data[0] -is [Array]) {
            # If it's array of Arrays
            foreach ($D in $Data) {
                @{
                    data = $D
                }
            }
        } else {
            # If it's just int in Array
            @{
                data = $Data
            }
        }
    } else {
        Write-Warning -Message "New-HTMLChartDataSet - No Data provided. Unabled to create dataset."
        return @{}
    }
}
function New-HTMLChartLine {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [ValidateSet('', 'central')][string] $Positioning,

        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [RGBColors[]] $DataLabelsColor,
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',

        [ValidateSet('straight', 'smooth', 'stepline')] $LineCurve = 'straight',
        [int] $LineWidth,
        [RGBColors[]] $LineColor,

        [RGBColors[]] $GridColors,
        [double] $GridOpacity,

        [string] $Title,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [ValidateSet('top', 'topRight', 'left', 'right', 'bottom', '')][string] $LegendPosition = '',

        [string] $TitleX,
        [string] $TitleY,

        [int] $MarkerSize,

        [Array] $Data,
        [Array] $DataNames,
        [Array] $DataLegend
    )

    $Options = [ordered] @{}

    New-ChartLine -Options $Options -Data $Data -DataNames $DataNames

    New-ChartStrokeDefinition -Options $Options `
        -LineShow $true `
        -LineCurve $LineCurve `
        -LineWidth $LineWidth `
        -LineColor $LineColor

    New-ChartDataLabels -Options $Options `
        -DataLabelsEnabled $DataLabelsEnabled `
        -DataLabelsOffsetX $DataLabelsOffsetX `
        -DataLabelsFontSize $DataLabelsFontSize `
        -DataLabelsColor $DataLabelsColor

    New-ChartAxisX -Options $Options `
        -Title $TitleX `
        -DataCategoriesType $DataCategoriesType `
        -DataCategories $DataLegend

    New-ChartAxisY -Options $Options `
        -Title $TitleY

    New-ChartMarker -Options $Options -MarkerSize $MarkerSize

    New-ChartTitle -Options $Options -Title $Title -TitleAlignment $TitleAlignment
    New-ChartGridColors -Options $Options -GridColors $GridColors -GridOpacity $GridOpacity

    New-ChartLegend -Options $Options -LegendPosition $LegendPosition

    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options
    New-ApexChart -Positioning $Positioning -Options $Options
}
function New-HTMLChartRadial {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [ValidateSet('', 'central')][string] $Positioning,

        <#
        [bool] $Horizontal = $true,
        [bool] $DataLabelsEnabled = $true,
        [int] $DataLabelsOffsetX = -6,
        [string] $DataLabelsFontSize = '12px',
        [nullable[RGBColors]] $DataLabelsColor,
        [Array] $Data = @(),
        [Array] $DataNames = @(),
        [Array] $DataCategories = @(),
        [ValidateSet('datetime', 'category', 'numeric')][string] $DataCategoriesType = 'category',
        [string] $TitleText,
        [ValidateSet('center', 'left', 'right', '')][string] $TitleAlignment = '',

        [bool] $LineShow = $true,
        [ValidateSet('straight', 'smooth')] $LineCurve = 'straight',
        $LineWidth = 2,
        [RGBColors[]] $LineColor,

#>

        [Array] $Names,
        [Array] $Values,
        $Type,
        [ValidateSet('FullCircleTop', 'FullCircleBottom', 'FullCircleBottomLeft', 'FullCircleLeft', 'Speedometer', 'SemiCircleGauge')] $CircleType = 'FullCircleTop',
        [string] $LabelAverage
    )

    $Options = [ordered] @{}

    New-ChartRadial -Options $Options -Names $Names -Values $Values -Type $Type
    # This controls how the circle starts / left , right and so on
    New-ChartRadialCircleType -Options $Options -CircleType $CircleType
    # This added label. It's useful if there's more then one data
    New-ChartRadialDataLabels -Options $Options -Label $LabelAverage
    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options
    New-ApexChart -Positioning $Positioning -Options $Options
}
function New-HTMLChartSpark {
    [CmdletBinding()]
    param(
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [ValidateSet('', 'central')][string] $Positioning,

        # Data to display in Spark
        [Array] $Data,
        [string] $TitleText,
        [string] $SubTitleText,
        [int] $FontSizeTitle = 24,
        [int] $FontSizeSubtitle = 14,
        [nullable[RGBColors]] $Color
    )

    $Options = [ordered] @{}
    New-ChartSpark -Options $Options -Color $Color -Title $TitleText -SubTitle $SubTitleText -FontSizeTitle $FontSizeTitle -FontSizeSubtitle $FontSizeSubtitle -Values $Data
    New-ChartSize -Options $Options -Height $Height -Width $Width
    New-ChartToolbar -Options $Options

    New-ApexChart -Positioning $Positioning -Options $Options
}


Function New-HTMLCodeBlock {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)][String] $Code,
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'assembly',
            'asm',
            'avrassembly',
            'avrasm',
            'c',
            'cpp',
            'c++',
            'csharp',
            'css',
            'cython',
            'cordpro',
            'diff',
            'docker',
            'dockerfile',
            'generic',
            'standard',
            'groovy',
            'go',
            'golang',
            'html',
            'ini',
            'conf',
            'java',
            'js',
            'javascript',
            'jquery',
            'mootools',
            'ext.js',
            'json',
            'kotlin',
            'less',
            'lua',
            'gfm',
            'md',
            'markdown',
            'octave',
            'matlab',
            'nsis',
            'php',
            'powershell',
            'prolog',
            'py',
            'python',
            'raw',
            'ruby',
            'rust',
            'scss',
            'sass',
            'shell',
            'bash',
            'sql',
            'squirrel',
            'swift',
            'typescript',
            'vhdl',
            'visualbasic',
            'vb',
            'xml',
            'yaml'
        )]

        [String] $Style = 'powershell',
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'enlighter',
            'standard',
            'classic',
            'bootstrap4',
            'beyond',
            'godzilla',
            'eclipse',
            'mootwo',
            'droide',
            'minimal',
            'atomic',
            'dracula',
            'rowhammer'
        )][String] $Theme,
        [Parameter(Mandatory = $false)][String] $Group,
        [Parameter(Mandatory = $false)][String] $Title,
        [Parameter(Mandatory = $false)][String] $Highlight,
        [Parameter(Mandatory = $false)][nullable[bool]] $ShowLineNumbers,
        [Parameter(Mandatory = $false)][String] $LineOffset
    )
    $Script:HTMLSchema.Features.CodeBlocks = $true
    <# Explanation to fields:
        data-enlighter-language (string) - The language of the codeblock - overrides the global default setting | Block+Inline Content option
        data-enlighter-theme (string) - The theme of the codeblock - overrides the global default setting | Block+Inline Content option
        data-enlighter-group (string) - The identifier of the codegroup where the codeblock belongs to | Block Content option
        data-enlighter-title (string) - The title/name of the tab | Block Content option
        data-enlighter-linenumbers (boolean) - Show/Hide the linenumbers of a codeblock (Values: "true", "false") | Block Content option
        data-enlighter-highlight (string) - A List of lines to point out, comma seperated (ranges are supported) e.g. "2,3,6-10" | Block Content option
        data-enlighter-lineoffset (number) - Start value of line-numbering e.g. "5" to start with line 5 - attribute start of the ol tag is set | Block Content option
    #>

    $Attributes = [ordered]@{
        'data-enlighter-language'    = "$Style".ToLower()
        'data-enlighter-theme'       = "$Theme".ToLower()
        'data-enlighter-group'       = "$Group".ToLower()
        'data-enlighter-title'       = "$Title"
        'data-enlighter-linenumbers' = "$ShowLineNumbers"
        'data-enlighter-highlight'   = "$Highlight"
        'data-enlighter-lineoffset'  = "$LineOffset".ToLower()
    }
    New-HTMLTag -Tag 'pre' -Attributes $Attributes {
        $Code
    }
}
Function New-HTMLContent {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content = $(Throw "Open curly brace with Content"),
        [alias('ColumnCount', 'Columns')][ValidateSet('1', '2', '3', '4', '5 ', '6', '7', '8', '9', '10', '11', '12')][string] $Count = 1,
        [Parameter(Mandatory = $false)][string]$HeaderText,
        [RGBColors]$HeaderTextColor = [RGBColors]::White,
        [string][ValidateSet('center', 'left', 'right', 'justify')] $HeaderTextAlignment = 'center',
        [alias('BackgroundShade')][RGBColors]$BackgroundColor,
        [Parameter(Mandatory = $false)][switch] $CanCollapse,
        [Parameter(Mandatory = $false)][switch] $IsHidden,
        [int] $Height,
        [switch] $Invisible
    )
    $RandomNumber = Get-Random
    $TextHeaderColorFromRGB = ConvertFrom-Color -Color $HeaderTextColor
    if ($null -ne $BackgroundColor) {
        $BackGroundColorFromRGB = ConvertFrom-Color -Color $BackgroundColor
        $BGStyleColor = "background-color:$BackGroundColorFromRGB;"
    } else {
        $BGStyleColor = ''
    }
    if ($CanCollapse) {
        $Script:HTMLSchema.Features.HideSection = $true
        if ($IsHidden) {
            $ShowStyle = "color: $TextHeaderColorFromRGB;" # shows Show button
            $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Hide button
        } else {
            $ShowStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Show button
            $HideStyle = "color: $TextHeaderColorFromRGB;" # shows Hide button
        }
    } else {
        if ($IsHidden) {
            $ShowStyle = "color: $TextHeaderColorFromRGB;" # shows Show button
            $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Hide button
        } else {
            $ShowStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Show button
            $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Show button
        }
    }

    if ($Height -ne 0) { $StyleHeight = "height: $($Height)px" }
    $StyleWidth = "width: calc(100% / $Count - 15px)"

    if ($IsHidden) {
        $DivContentStyle = "display:none; $StyleWidth; $StyleHeight; $BGStyleColor"
    } else {
        $DivContentStyle = "$StyleWidth; $StyleHeight; $BGStyleColor"
    }

    $DivHeaderStyle = "text-align: $HeaderTextAlignment;"
    $HeaderStyle = "color: $TextHeaderColorFromRGB;"

    if ($Invisible) {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'defaultContainerOther' } -Value {
            New-HTMLTag -Tag 'div' -Attributes @{ class = 'defaultContainerOther defaultPanelOther' } -Value {
                Invoke-Command -ScriptBlock $Content
            }
        }
    } else {
        # return this HTML
        New-HTMLTag -Tag 'div' -Attributes @{ 'class' = "defaultSection defaultCard"; 'style' = $DivContentStyle } -Value {
            New-HTMLTag -Tag 'div' -Attributes @{ 'class' = "defaultHeader"; 'style' = $DivHeaderStyle  } -Value {
                New-HTMLAnchor -Name $HeaderText -Text $HeaderText -Style $HeaderStyle
                New-HTMLAnchor -Id "show_$RandomNumber" -Href 'javascript:void(0)' -OnClick "show('$RandomNumber');" -Style $ShowStyle -Text '(Show)'
                New-HTMLAnchor -Id "hide_$RandomNumber" -Href 'javascript:void(0)' -OnClick "hide('$RandomNumber');" -Style $HideStyle -Text '(Hide)'
            }
            New-HTMLTag -Tag 'div' -Attributes @{ class = 'defaultContainerOther'; id = $RandomNumber; } -Value {
                New-HTMLTag -Tag 'div' -Attributes @{ class = 'defaultContainer defaultPanelOther collapsable'; id = $RandomNumber; } -Value {
                    Invoke-Command -ScriptBlock $Content
                }
            }
        }
    }
}
Function New-HTMLHeading {
    [CmdletBinding()]
    Param (
        [validateset('h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7')][string]$Heading,
        [string]$HeadingText,
        [validateset('', 'central')][string] $Type,
        [switch] $Underline,
        [nullable[RGBColors]] $Color
    )
    if ($null -ne $Color) {
        $RGBcolor = ConvertFrom-Color -Color $Color
        $Attributes = @{
            style = "color: $RGBcolor;"
        }
    } else {
        $Attributes = @{}
    }
    if ($Type -eq 'central') {
        $Attributes.Class = 'central'
    }
    if ($Underline) {
        $Attributes.Class = "$($Attributes.Class) underline"
    }

    New-HTMLTag -Tag $Heading -Attributes $Attributes {
        $HeadingText
    }
}
function New-HTMLHorizontalLine {
    [CmdletBinding()]
    param()
    New-HTMLTag -Tag 'hr' -SelfClosing
}
function New-HTMLImage {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Source
    Parameter description
    
    .PARAMETER UrlLink
    Parameter description
    
    .PARAMETER AlternativeText
    Parameter description
    
    .PARAMETER Class
    Parameter description
    
    .PARAMETER Target
    Parameter description
    
    .PARAMETER Width
    Parameter description
    
    .PARAMETER Height
    Parameter description
    
    .EXAMPLE
    New-HTMLImage -Source 'https://evotec.pl/image.png' -UrlLink 'https://evotc.pl/' -AlternativeText 'My other text' -Class 'otehr' -Width '100%'
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param(
        [string] $Source,
        [Uri] $UrlLink = '',
        [string] $AlternativeText = '',
        [string] $Class = 'Logo',
        [string] $Target = '_blank',
        [string] $Width,
        [string] $Height
    )

    New-HTMLTag -Tag 'div' -Attributes @{ class = $Class.ToLower() } {
        $AAttributes = [ordered]@{
            'target' = $Target
            'href'   = $UrlLink
        }        
        New-HTMLTag -Tag 'a' -Attributes $AAttributes {
            $ImgAttributes = [ordered]@{
                'src'    = "$Source"
                'alt'    = "$AlternativeText"
                'width'  = "$Height"
                'height' = "$Width"
            }
            New-HTMLTag -Tag 'img' -Attributes $ImgAttributes
        }        
    }
}
function New-HTMLLogo {
    param(
        [String] $LogoPath,
        [string] $LeftLogoName = "Sample",
        [string] $RightLogoName = "Alternate",
        [string] $LeftLogoString,
        [string] $RightLogoString,
        [switch] $HideLogos
    )

    $LogoSources = Get-HTMLLogos `
        -RightLogoName $RightLogoName `
        -LeftLogoName $LeftLogoName  `
        -LeftLogoString $LeftLogoString `
        -RightLogoString $RightLogoString

    Convert-StyleContent1 -Options $Options


    $Options = [PSCustomObject] @{
        Logos        = $LogoSources
        ColorSchemes = $ColorSchemes
    }

    if ($HideLogos -eq $false) {
        $Leftlogo = $Options.Logos[$LeftLogoName]
        $Rightlogo = $Options.Logos[$RightLogoName]
        '<!-- START LOGO -->'
        $LogoContent = @"
        <table><tbody>
        <tr>
            <td class="clientlogo"><img src="$Leftlogo" /></td>
            <td class="MainLogo"><img src="$Rightlogo" /></td>
        </tr>
        </tbody></table>
"@
        $LogoContent
        '<!-- END LOGO -->'
     
    }       
}
function New-HTMLMessage {
    param(
        [Parameter(Mandatory = $false, Position = 0)][alias('')][ScriptBlock] $Content,
        $Text
    )
    $Script:HTMLSchema.Features.Message = $true
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'message green' } {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'message-icon' } {
            New-HTMLTag -Tag 'i' -Attributes @{ class = 'fa fa-bell-o'} 
        }
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'message-body' } {
            New-HTMLTag -Tag 'p' -Attributes @{ class = '' } {
                $Text
            }
        }
    }
}
Function New-HTMLPanel {
    [alias('New-HTMLColumn')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content = $(Throw "Open curly brace with Content"),
        [alias('ColumnCount', 'Columns')][ValidateSet('1', '2', '3', '4', '5 ', '6', '7', '8', '9', '10', '11', '12')][string] $Count = 1,
        [alias('BackgroundShade')][RGBColors]$BackgroundColor,
        [switch] $Invisible,
        [int] $Height
    )
    if ($Height -ne 0) { 
        $StyleHeight = "height: $($Height)px" 
    }    
    $StyleWidth = "width: calc(100% / $Count - 10px)"

    if ($null -ne $BackgroundColor) {
        $BackGroundColorFromRGB = ConvertFrom-Color -Color $BackgroundColor
        $DivColumnStyle = "background-color:$BackGroundColorFromRGB; $StyleWidth; $StyleHeight;"
    } else {
        $DivColumnStyle = "$StyleWidth; $StyleHeight;"
    }
    if ($Invisible) {
        $DivColumnStyle = "$DivColumnStyle box-shadow: unset !important;"
    }
    New-HTMLTag -Tag 'div' -Attributes @{ class = "defaultPanel defaultCard"; style = $DivColumnStyle } {
        Invoke-Command -ScriptBlock $Content
    }
}
function New-HTMLResourceCSS {
    [alias('New-ResourceCSS', 'New-CSS')]
    [CmdletBinding()]
    param(
        [alias('ScriptContent')][Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content,
        [string] $Link,
        [string] $ResourceComment,
        [string] $FilePath
    
    )
    $Output = @(
        "<!-- CSS $ResourceComment START -->"
        foreach ($File in $FilePath) {
            if ($File -ne '') {
                if (Test-Path -LiteralPath $File) {                
                    New-HTMLTag -Tag 'style' -Attributes @{ type = 'text/css' } {    
                        Write-Verbose "New-HTMLResourceCSS - Reading file from $File"        
                        Get-Content -LiteralPath $File           
                    }
                } 
            }
        }
        foreach ($L in $Link) {   
            if ($L -ne '') {
                Write-Verbose "New-HTMLResourceCSS - Adding link $L"   
                New-HTMlTag -Tag 'link' -Attributes @{ rel = "stylesheet"; type = "text/css"; href = $L } -SelfClosing
            }
        }
        "<!-- CSS $ResourceComment END -->"
    )
    if ($Output.Count -gt 2) {
        # Outputs only if more than comments
        $Output
    } 
}
function New-HTMLResourceJS {
    [alias('New-ResourceJS', 'New-JavaScript')]
    [CmdletBinding()]
    param(
        [alias('ScriptContent')][Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content,
        [string[]] $Link,
        [string] $ResourceComment,
        [string[]] $FilePath
    )   
    $Output = @(
        "<!-- JS $ResourceComment START -->"
        foreach ($File in $FilePath) {
            if ($File -ne '') {
                if (Test-Path -LiteralPath $File) {
                    New-HTMLTag -Tag 'script' -Attributes @{ type = 'text/javascript' } {            
                        Get-Content -LiteralPath $File          
                    }
                } else {
                    return
                }
            } 
        }
        foreach ($L in $Link) {        
            if ($L -ne '') {
                New-HTMlTag -Tag 'script' -Attributes @{ type = "text/javascript"; src = $L }
            } else {
                return
            }
        }
        "<!-- JS $ResourceComment END -->"
    )
    if ($Output.Count -gt 2) {
        # Outputs only if more than comments
        $Output
    } 
}
function New-HTMLStatus {
    param(
        [Parameter(Mandatory = $false, Position = 0)][alias('')][ScriptBlock] $Content
    )
    $Script:HTMLSchema.Features.StatusButtonical = $true
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'buttonicalService' } {
        #New-HTMLTag -Tag 'div' -Attributes @{ class = 'buttonical-align' } {
        Invoke-Command -ScriptBlock $Content
        # } 
    }
    
}
function New-HTMLStatusItem {
    param(
        $ServiceName,
        $ServiceStatus,
        [ValidateSet('Dead', 'Bad', 'Good')]$Icon = 'Good',
        [ValidateSet('0%', '10%', '30%', '70%', '100%')][string] $Percentage = '100%'
    )
    #$Script:HTMLSchema.Features.StatusButtonical = $true
    if ($Icon -eq 'Dead') {
        $IconType = 'performanceDead'
    } elseif ($Icon -eq 'Bad') { 
        $IconType = 'performanceProblem'
    } elseif ($Icon -eq 'Good') {
        #$IconType = 'performance'
    }

    if ($Percentage -eq '100%') {
        $Colors = 'background-color: #0ef49b;'
    } elseif ($Percentage -eq '70%') {
        $Colors = 'background-color: #d2dc69;'
    } elseif ($Percentage -eq '30%') {
        $Colors = 'background-color: #faa04b;'
    } elseif ($Percentage -eq '10%') {
        $Colors = 'background-color: #ff9035;'
    } elseif ($Percentage -eq '0%') {
        $Colors = 'background-color: #ff5a64;'
    }

    New-HTMLTag -Tag 'div' -Attributes @{ class = 'buttonical'; style = $Colors } -Value {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'label' } {
            New-HTMLTag -Tag 'span' -Attributes @{ class = 'performance' } {
                $ServiceName
            }
        }
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'middle' } 
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'status'} {
            New-HTMLTag -Tag 'input' -Attributes @{ name = Get-Random; type = 'radio'; value = 'other-item'; checked = 'true' } -SelfClosing
            New-HTMLTag -Tag 'span' -Attributes @{ class = "performance $IconType" } {
                $ServiceStatus
            }            
        }
    }
}
function New-HTMLTab {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $HtmlData = $(Throw "No curly brace?)"),
        [Parameter(Mandatory = $false, Position = 1)][String]$TabHeading,
        [alias('Name')][string] $TabName
    )
    $Script:HTMLSchema.Features.Tabs = $true
    $Script:HTMLSchema.Features.JQuery = $true

    # Reset all Tabs Headers to make sure there are no Current Tab Set
    # This is required for New-HTMLTable
    foreach ($Tab in $Script:HTMLSchema.TabsHeaders) {
        $Tab.Current = $false
    }

    # Start Tab Tracking
    $Tab = @{}
    $Tab.ID = "Tab-$(Get-RandomStringName -Size 8)"
    $Tab.Name = $TabName
    #$Tab.Used = $true
    $Tab.Current = $true
    if ($Script:HTMLSchema.TabsHeaders | Where-Object { $_.Active -eq $true }) {
        $Tab.Active = $false
    } else {
        $Tab.Active = $true
    }
    $Script:HTMLSchema.TabsHeaders.Add($Tab)
    # End Tab Tracking


    # This is building HTML
    if ($Tab.Active) {
        $Class = 'tabs-content active'
    } else {
        $Class = 'tabs-content'
    }

    New-HTMLTag -Tag 'div' -Attributes @{ id = $Tab.ID; class = $Class } {
        if (-not [string]::IsNullOrWhiteSpace($TabHeading)) {
            New-HTMLTag -Tag 'h7' {
                $TabHeading
            }
        }
        Invoke-Command -ScriptBlock $HtmlData
    }
}
function New-HTMLTabHead {
    [CmdletBinding()]
    Param (
        
    )    
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'tabsWrapper' } {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'tabs' } {
            New-HTMLTag -Tag 'div' -Attributes @{ class = 'selector' }
            foreach ($Tab in $Script:HTMLSchema.TabsHeaders) {
           
                if ($Tab.Active) {
                    $AttributesA = @{
                        'class'   = 'active'
                        'href'    = 'javascript:void(0)'
                        'data-id' = "$($Tab.Id)"
                    }

                    New-HTMLTag -Tag 'a' -Attributes $AttributesA {
                        New-HTMLTag -Tag 'i' -Attributes @{ class = 'fas fa-bomb' } -Value { $Tab.Name }
                    }
                    #New-HTMLAnchor -Class 'active' -HrefLink "#$($Tab.Id)" -Text $Tab.Name
                } else {
                    # New-HTMLAnchor -Class '' -HrefLink "#" -Text $Tab.Name

                    $AttributesA = @{
                        'class'   = ''
                        'href'    = 'javascript:void(0)'
                        'data-id' = "$($Tab.Id)"
                    }

                    New-HTMLTag -Tag 'a' -Attributes $AttributesA {
                        New-HTMLTag -Tag 'i' -Attributes @{ class = 'fas fa-bomb' } -Value { $Tab.Name }
                    }
                }
            }            
        }
    }
}
function New-HTMLTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)][ScriptBlock] $ConditionalFormatting,
        [alias('ArrayOfObjects', 'Object', 'Table')][Array] $DataTable,
        #[Array] $ConditionalFormatting,
        [string[]][ValidateSet('copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5')] $Buttons = @('copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5'),
        [string[]][ValidateSet('numbers', 'simple', 'simple_numbers', 'full', 'full_numbers', 'first_last_numbers')] $PagingStyle = 'full_numbers',
        [int[]]$PagingOptions = @(15, 25, 50, 100),
        [switch]$DisablePaging,
        [switch]$DisableOrdering,
        [switch]$DisableInfo,
        [switch]$HideFooter,
        [switch]$DisableColumnReorder,
        [switch]$DisableProcessing,
        [switch]$DisableResponsiveTable,
        [switch]$DisableSelect,
        [switch]$DisableStateSave,
        [switch]$DisableSearch,
        [switch]$ScrollCollapse,
        [switch]$OrderMulti,
        [string[]][ValidateSet('display', 'cell-border', 'compact', 'hover', 'nowrap', 'order-column', 'row-border', 'stripe')] $Style = @('display', 'compact'),
        [switch]$Simplify,
        [string]$TextWhenNoData = 'No data available.',
        [int] $ScreenSizePercent = 0,
        [string] $DefaultSortColumn,
        [int] $DefaultSortIndex = -1,
        [ValidateSet('Ascending', 'Descending')][string] $DefaultSortOrder = 'Ascending',
        [alias('Search')][string]$Find
    )
    # Theme creator  https://datatables.net/manual/styling/theme-creator

    [string] $DataTableName = "DT-$(Get-RandomStringName -Size 8 -LettersOnly)" # this builds table ID
    if ($null -eq $DataTable -or $DataTable.Count -eq 0) {
        #return ''
        $DataTable = $TextWhenNoData
    }
    if ($DataTable[0] -is [System.Collections.IDictionary]) {
        Write-Verbose 'New-HTMLTable - Working with IDictionary'
        [Array ] $Table = $($DataTable).GetEnumerator() | Select-Object Name, Value | ConvertTo-Html -Fragment | Select-Object -SkipLast 1 | Select-Object -Skip 2 # This removes table tags (open/closing)
    } elseif ($DataTable[0] -is [string]) {
        [Array] $Table = $DataTable | ForEach-Object { [PSCustomObject]@{ 'Name' = $_ } } | ConvertTo-Html -Fragment | Select-Object -SkipLast 1 | Select-Object -Skip 2
    } else {
        Write-Verbose 'New-HTMLTable - Working with Objects'
        [Array] $Table = $DataTable | ConvertTo-Html -Fragment | Select-Object -SkipLast 1 | Select-Object -Skip 2 # This removes table tags (open/closing)
    }
    [string] $Header = $Table | Select-Object -First 1 # this gets header
    [string[]] $HeaderNames = $Header -replace '</th></tr>' -replace '<tr><th>' -split '</th><th>'
    $Table = $Table | Select-Object -Skip 1 # this gets actuall table content

    $Options = [ordered] @{
        <# DOM Definition: https://datatables.net/reference/option/dom
            l - length changing input control
            f - filtering input
            t - The table!
            i - Table information summary
            p - pagination control
            r - processing display element
            B - Buttons
            S - Select
        #>
        dom              = 'Bfrtip'
        buttons          = @($Buttons)
        "colReorder"     = -not $DisableColumnReorder.IsPresent


        # https://datatables.net/examples/basic_init/scroll_y_dynamic.html
        "paging"         = -not $DisablePaging
        "scrollCollapse" = $ScrollCollapse.IsPresent

        <# Paging Type
            numbers - Page number buttons only
            simple - 'Previous' and 'Next' buttons only
            simple_numbers - 'Previous' and 'Next' buttons, plus page numbers
            full - 'First', 'Previous', 'Next' and 'Last' buttons
            full_numbers - 'First', 'Previous', 'Next' and 'Last' buttons, plus page numbers
            first_last_numbers - 'First' and 'Last' buttons, plus page numbers
        #>
        "pagingType"     = $PagingStyle
        "lengthMenu"     = @(
            @($PagingOptions, -1)
            @($PagingOptions, "All")
        )
        "ordering"       = -not $DisableOrdering.IsPresent
        "info"           = -not $DisableInfo.IsPresent
        "procesing"      = -not $DisableProcessing.IsPresent
        "responsive"     = @{
            details = -not $DisableResponsiveTable.IsPresent
        }
        "select"         = -not $DisableSelect.IsPresent
        "searching"      = -not $DisableSearch.IsPresent
        "stateSave"      = -not $DisableStateSave.IsPresent
    }

    if ($OrderMulti) {
        $Options.orderMulti = $OrderMulti.IsPresent
    }
    if ($Find -ne '') {
        $Options.search = @{
            search = $Find
        }
    }

    # Sorting
    if ($DefaultSortOrder -eq 'Ascending') {
        $Sort = 'asc'
    } else {
        $Sort = 'dsc'
    }
    if ($DefaultSortColumn -ne '') {
        $DefaultSortingNumber = ($HeaderNames).ToLower().IndexOf($DefaultSortColumn.ToLower())
        $Options."order" = @( $DefaultSortingNumber , $Sort )

        # there seems to be a bug in ordering and colReorder plugin
        # Disabling colReorder
        $Options.colReorder = $false
    }
    if ($DefaultSortIndex -gt -1 -and $DefaultSortColumn -eq '') {
        $Options."order" = @( $DefaultSortIndex , $Sort )

        # there seems to be a bug in ordering and colReorder plugin
        # Disabling colReorder
        $Options.colReorder = $false
    }

    # Overwriting table size - screen size in percent. With added Section/Panels it shouldn't be more than 90%
    if ($ScreenSizePercent -gt 0) {
        $Options."scrollY" = "$($ScreenSizePercent)vh"
    }
    if ($null -ne $ConditionalFormatting) {
        #.Count -gt 0) {
        $Options.columnDefs = ''
    }
    $Options = $Options | ConvertTo-Json -Depth 6

    if ($null -ne $ConditionalFormatting) {
        $Conditional = Invoke-Command -ScriptBlock $ConditionalFormatting
    }
    # Process Conditional Formatting. Ugly JS building
    $Options = New-TableConditionalFormatting -Options $Options -ConditionalFormatting $Conditional -Header $HeaderNames


    [Array] $Tabs = ($Script:HTMLSchema.TabsHeaders | Where-Object { $_.Current -eq $true })
    if ($Tabs.Count -eq 0) {
        # There are no tabs in use, pretend there is only one Active Tab
        $Tab = @{ Active = $true }
    } else {
        # Get First Tab
        $Tab = $Tabs[0]
    }

    # return data
    if (-not $Simplify) {
        $Script:HTMLSchema.Features.DataTables = $true
        $Script:HTMLSchema.Features.DataTablesPDF = $true
        $Script:HTMLSchema.Features.DataTablesExcel = $true

        $TableAttributes = @{ id = $DataTableName; class = ($Style -join ' ') }
        if ($Tab.Active -eq $true) {
            New-HTMlTag -Tag 'script' {
                @"
                `$(document).ready(function() {
                    `$('#$DataTableName').DataTable(
                        $($Options)
                    );
                });
"@
            }
        } else {
            [string] $TabName = $Tab.Id
            New-HTMlTag -Tag 'script' {
                @"
                    `$(document).ready(function() {
                        `$('.tabs').on('click', 'a', function (event) {
                            if (`$(event.currentTarget).attr("data-id") == "$TabName" && !$.fn.dataTable.isDataTable("#$DataTableName")) {
                                `$('#$DataTableName').DataTable(
                                    $($Options)
                                );
                            };
                        });
                    });
"@
            }
        }
    } else {
        $TableAttributes = @{ class = 'sortable' }
    }
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'defaultPanelOther' } -Value {
        # Build HTML TABLE
        New-HTMLTag -Tag 'table' -Attributes $TableAttributes {
            New-HTMLTag -Tag 'thead' {
                $Header
            }
            New-HTMLTag -Tag 'tbody' {
                $Table
            }
            if (-not $HideFooter) {
                New-HTMLTag -Tag 'tfoot' {
                    $Header
                }
            }
        }
    }
}
function New-HTMLTableCondition {
    [CmdletBinding()]
    param(
        [alias('ColumnName')][string] $Name,
        [ValidateSet('number', 'string')][string] $Type,
        [ValidateSet('lt', 'le', 'eq', 'ge', 'gt')][string] $Operator,
        [Object] $Value,
        [switch] $Row,
        [nullable[RGBColors]] $Color,
        [nullable[RGBColors]] $BackgroundColor
    )
    return [PSCustomObject] @{ Row = $Row; Type = $Type ; Name = $Name; Operator = $Operator; Value = $Value; Color = $Color; BackgroundColor = $BackgroundColor }
}
function New-HTMLTag {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)][alias('Content')][ScriptBlock] $Value,
        [Parameter(Mandatory = $true, Position = 1)][string] $Tag,
        [System.Collections.IDictionary] $Attributes,
        [switch] $SelfClosing
    )
    $HTMLTag = [Ordered] @{
        Tag         = $Tag
        Attributes  = $Attributes
        Value       = if ($null -eq $Value) { '' } else { Invoke-Command -ScriptBlock $Value }
        SelfClosing = $SelfClosing
    }
    $HTML = Set-Tag -HtmlObject $HTMLTag
    return $HTML
}
function New-HTMLTimeline {
    param(
        [Parameter(Mandatory = $false, Position = 0)][alias('TimeLineItems')][ScriptBlock] $Content
    )
    $Script:HTMLSchema.Features.TimeLine = $true
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'timelineSimpleContainer' } {
        if ($null -eq $Value) { '' } else { Invoke-Command -ScriptBlock $Content }
    }
}
function New-HTMLTimelineItem {
    [CmdletBinding()]
    param(
        [DateTime] $Date = (Get-Date),
        [string] $HeadingText,
        [string] $Text,
        [nullable[RGBColors]] $Color
    )
    $Attributes = @{
        class     = 'timelineSimple-item'
        "date-is" = $Date
    }

    if ($null -ne $Color) {
        $RGBcolor = ConvertFrom-Color -Color $Color
        $Style = "color: $RGBcolor;"
    } else {
        $Style = ''
    }
    # $Script:HTMLSchema.Features.TimeLine = $true
    New-HTMLTag -Tag 'div' -Attributes $Attributes -Value {
        New-HTMLTag -Tag 'h1' -Attributes @{ class = 'timelineSimple'; style = $style } {
            $HeadingText
        }
        New-HTMLTag -Tag 'p' -Attributes @{ class = 'timelineSimple'} {
            $Text
        }
    }
}
function New-HTMLToast {
    [CmdletBinding()]
    param(
        [string] $TextHeader,
        [string] $Text,
        [ValidateSet('Green', 'Blue', 'Orange')] $Color = "Green",
        [ValidateSet('Success', 'Information', 'Exclamation')][string] $Icon = 'Success'
    )
    $Script:HTMLSchema.Features.Toast = $true
    $DivClass = "toast $($Color.ToLower()) central" 
    New-HTMLTag -Tag 'div' -Attributes @{ class = $DivClass } {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'toast__icon' } {
            if ($Icon -eq 'Success') {
                New-IconSuccess
            } elseif ($Icon -eq 'Information') {
                New-IconInfo
            } elseif ($Icon -eq 'Exclamation') {
                New-IconExclamation
            }
        }
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'toast__content' } {
            New-HTMLTag -Tag 'p' -Attributes @{ class = 'toast__type' } {
                $TextHeader
            }
            New-HTMLTag -Tag 'p' -Attributes @{ class = 'toast__message' } {
                $Text
            }
        }
    }
}
function New-IconExclamation {
    <#
    .SYNOPSIS
    This function is used for New-HTMLToast
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param()
    $SvgAttributes = [ordered] @{
        version       = "1.1"
        class         = "toast__svg"
        xmlns         = "http://www.w3.org/2000/svg"
        'xmlns:xlink' = "http://www.w3.org/1999/xlink"
        x             = "0px"
        y             = "0px"
        viewBox       = "0 0 301.691 301.691"
        style         = "enable-background:new 0 0 301.691 301.691;"
        'xml:space'   = "preserve"
    }
    New-HTMLTag -Tag 'svg' -Attributes $SvgAttributes {
        $Points = @{
            points = "119.151,0 129.6,218.406 172.06,218.406 182.54,0  "
        }
        New-HTMLTag -Tag 'polygon' -Attributes $Points 
        $React = @{
            x      = "130.563"
            y      = "261.168"
            width  = "40.525"
            height = "40.523"
        }
        New-HTMLTag -Tag 'react' -Attributes $React
    }
}
function New-IconInfo {
    <#
    .SYNOPSIS
    This function is used for New-HTMLToast
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param()
    $SvgAttributes = [ordered] @{
        version       = "1.1"
        class         = "toast__svg"
        xmlns         = "http://www.w3.org/2000/svg"
        'xmlns:xlink' = "http://www.w3.org/1999/xlink"
        x             = "0px"
        y             = "0px"
        viewBox       = "0 0 32 32"
        style         = "enable-background:new 0 0 32 32;"
        'xml:space'   = "preserve"
    }
    New-HTMLTag -Tag 'svg' -Attributes $SvgAttributes {
        $PathAttributes = @{
            d = "M10,16c1.105,0,2,0.895,2,2v8c0,1.105-0.895,2-2,2H8v4h16v-4h-1.992c-1.102,0-2-0.895-2-2L20,12H8     v4H10z"        
        }
        New-HTMLTag -Tag 'path' -Attributes $PathAttributes
        New-HTMLTag -Tag 'circle' -Attributes @{ cx = "16"; cy = "4"; r = "4"; }
    }
}
function New-IconSuccess {
    <#
    .SYNOPSIS
    This function is used for New-HTMLToast
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param()
    $SvgAttributes = [ordered] @{
        version       = "1.1"
        class         = "toast__svg"
        xmlns         = "http://www.w3.org/2000/svg"
        'xmlns:xlink' = "http://www.w3.org/1999/xlink"
        x             = "0px"
        y             = "0px"
        viewBox       = "0 0 512 512"
        style         = "enable-background:new 0 0 512 512;"
        'xml:space'   = "preserve"
    }
    New-HTMLTag -Tag 'svg' -Attributes $SvgAttributes {
        $PathAttributes = @{
            d = "M504.502,75.496c-9.997-9.998-26.205-9.998-36.204,0L161.594,382.203L43.702,264.311c-9.997-9.998-26.205-9.997-36.204,0    c-9.998,9.997-9.998,26.205,0,36.203l135.994,135.992c9.994,9.997,26.214,9.99,36.204,0L504.502,111.7    C514.5,101.703,514.499,85.494,504.502,75.496z"
        }
        New-HTMLTag -Tag 'path' -Attributes $PathAttributes
    }
}
function New-TableConditionalFormatting {
    [CmdletBinding()]
    param(
        [string] $Options,
        [Array] $ConditionalFormatting,
        [string[]] $Header
    )

    if ($ConditionalFormatting.Count -gt 0) {
        # Conditional - changes PowerShellOperator into JS operator
        foreach ($Formatting in $ConditionalFormatting) {
            if ($Formatting.Operator -eq 'gt') {
                $Formatting.Operator = '>'
            } elseif ($Formatting.Operator -eq 'lt') {
                $Formatting.Operator = '<'
            } elseif ($Formatting.Operator -eq 'eq') {
                $Formatting.Operator = '=='
            } elseif ($Formatting.Operator -eq 'le') {
                $Formatting.Operator = '<='
            } elseif ($Formatting.Operator -eq 'ge') {
                $Formatting.Operator = '>='
            }
        }
        <#
        $ConditionHeaderNr = $CleanHeader.IndexOf('Name')

        $Condition1 = "columnDefs: [{targets: $ConditionHeaderNr, render: function ( data, type, row ) {"
        $Condition2 = "var color = 'black'; var backgroundColor = undefined;"

        $Condition3 = foreach ($Condition in $ConditionalFormatting) {
            "if (data $($Condition.Operator) $($Condition.Value)) {"
            if ($null -ne $Condition.Color) {
                $RGBColor = (ConvertFrom-Color -Color $Condition.Color)
                "color = '$RGBColor';"
            }
            if ($null -ne $Condition.BackgroundColor) {
                $RGBBackgroundColor = (ConvertFrom-Color -Color $Condition.BackgroundColor)
                "backgroundColor = '$RGBBackgroundColor';"
            }
            "}"

        }
        if ($null -ne $Condition.Color -and $null -ne $Condition.BackgroundColor) {
            # Background and Color Both
            $Condition4 = "return '<span style=`"color:' + color + ';background-color:' + backgroundColor + '`">' + data + '</span>';"
        } elseif ($null -ne $Condition.Color) {
            # Color Only
            $Condition4 = "return '<span style=`"color:' + color + '`">' + data + '</span>';"
        } else {
            # Background Color Only
            $Condition4 = "return '<span style=`"background-color:' + backgroundColor + '`">' + data + '</span>';"
        }

        $Condition5 = '},}]'
        #>

        $Condition1 = '"createdRow": function (row, data, dataIndex, column) {'

        $Condition3 = foreach ($Condition in $ConditionalFormatting) {
            $ConditionHeaderNr = $Header.ToLower().IndexOf($($Condition.Name.ToLower()))
            # reset to defaults
            [string] $ColorJSDefinition = ''
            [string] $ColorBackgroundJSDefinition = ''

            if ($null -ne $Condition.Color) {
                $RGBColor = (ConvertFrom-Color -Color $Condition.Color)
                $C = @{ "color" = $RGBColor } | ConvertTo-Json
                $ColorJSDefinition = ".css($C)"
            }
            if ($null -ne $Condition.BackgroundColor) {
                $RGBBackgroundColor = (ConvertFrom-Color -Color $Condition.BackgroundColor)
                $BG = @{ "background-color" = $RGBBackgroundColor } | ConvertTo-Json
                $ColorBackgroundJSDefinition = ".css($BG)"
            }

            if ($null -eq $Condition.Type -or $Condition.Type -eq 'number') {
                "if (data[$ConditionHeaderNr] $($Condition.Operator) $($Condition.Value)) {"
            } elseif ($Condition.Type -eq 'string') {
                "if (data[$ConditionHeaderNr] $($Condition.Operator) '$($Condition.Value)') {"
            } elseif ($Condition.Type -eq 'date') {
                "if (new Date(data[$ConditionHeaderNr]) $($Condition.Operator) new Date('$($Condition.Value)')) {"
            }




            if ($null -ne $Condition.Row -and $Condition.Row -eq $true) {
                "`$(column)$($ColorJSDefinition)$($ColorBackgroundJSDefinition);"
            } else {
                "`$(column[$ConditionHeaderNr])$($ColorJSDefinition)$($ColorBackgroundJSDefinition);"
            }



            "}"
        }

        $Condition5 = '}'

        $Test = $Condition1 + $Condition3 + $Condition5
        $Options = $Options -Replace ('"columnDefs":  ""', $Test)
    }

    return $Options
}

<# Best solution
"createdRow": function (row, data, dataIndex, column) {
    if (data[2] == 'Normal') {
        $(column[2]).css({ "color": "red"}).css({'background-color':'green' })
    }
}
# Other
columnDefs: [{
    targets: 0,
    render: function (data, type, row) {
        var color = 'black';
        var backgroundColor = undefined;
        if (data > 10000) {
            color = '#ff0000';
            backgroundColor = '#008000';
        }
        if (data < 10000) {
            color = '#ffff00';
            backgroundColor = '#008000';
        }
        if (data > 20000) {
            color = '#008000';
            backgroundColor = '#008000';
        }
        return '<span style="color:' + color +
            ';background-color:' + backgroundColor + '">' +
            data + '</span>';
    },
}]
#>
function Out-HtmlView {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Table
    Parameter description

    .PARAMETER Title
    Parameter description

    .PARAMETER DefaultSortColumn
    Parameter description

    .PARAMETER DefaultSortIndex
    Parameter description

    .EXAMPLE
    Get-Process | Select-Object -First 5 | Out-HtmlView

    .NOTES
    General notes
    #>
    [alias('Out-GridHtml')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)] $Table,
        [string] $Title = 'Out-HTMLView',
        [string] $DefaultSortColumn,
        [int] $DefaultSortIndex = -1
    )
    Begin {
        $DataTable = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        foreach ($T in $Table) {
            $DataTable.Add($T)
        }
    }
    End {
        [string] $FilePath = Get-FileName -Extension 'html' -Temporary
        New-HTML -FilePath $FilePath -UseCssLinks -UseJavaScriptLinks -TitleText $Title -ShowHTML {
            New-HTMLTable -DataTable $DataTable -DefaultSortColumn $DefaultSortColumn -DefaultSortIndex $DefaultSortIndex
        }
    }
}
Function Save-HTML {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER FilePath
    Parameter description

    .PARAMETER HTML
    Parameter description

    .PARAMETER ShowReport
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false)][string]$FilePath,
        [Parameter(Mandatory = $true)][Array] $HTML,
        [Parameter(Mandatory = $false)][switch]$ShowHTML
       # [switch] $Supress
    )
    if ([string]::IsNullOrEmpty($FilePath)) {
        $FilePath = Get-FileName -Temporary -Extension 'html'
        Write-Warning "Save-HTML - FilePath parameter $FilePath is empty, using Temporary $FilePath"
    } else {
        if (Test-Path -LiteralPath $FilePath) {
            Write-Warning "Save-HTML - Path $FilePath already exists. Report will be overwritten."
        }
    }
    Write-Verbose "Save-HTML - Saving HTML to file $FilePath"


    $HTML | Set-Content -Path $FilePath -Force
    Write-Verbose $FilePath
    if ($ShowHTML) {
        #Start-Sleep -Seconds 1
        Invoke-Item $FilePath
    }
   # if (-not $Supress) {
   #     $FilePath
   # }
}
$Script:Configuration = [ordered] @{
    Features = [ordered] @{
        Default          = @{
            Comment      = 'Always Required Default Visual Settings'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\default.css"
            }
        }
        DefaultHeadings  = @{
            Comment      = 'Always Required Default Headings'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\headings.css"
            }
        }
        Accordion        = @{
            Comment      = 'Accordion'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\accordion-1.css"
            }
        }
        CodeBlocks       = @{
            Comment      = 'EnlighterJS CodeBlocks'
            Header       = @{
                CssLink = 'https://evotec.xyz/wp-content/uploads/pswritehtml/enlighterjs.min.css'
                Css     = "$PSScriptRoot\Resources\CSS\enlighterjs.min.css"
                JsLink  = 'https://evotec.xyz/wp-content/uploads/pswritehtml/enlighterjs.min.js'
                JS      = "$PSScriptRoot\Resources\JS\enlighterjs.min.js"
            }
            Footer       = @{

            }
            HeaderAlways = @{

            }
            FooterAlways = @{
                JS = "$PSScriptRoot\Resources\JS\enlighterjs-footer.js"
            }
        }
        Charts           = @{
            Comment = 'Charts JS'
            Header  = @{
                JsLink = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.bundle.min.js'
            }
        }
        ChartsApex       = @{
            Comment      = 'Apex Charts'
            Header       = @{
                JsLink = 'https://cdn.jsdelivr.net/npm/apexcharts@latest'
                JS     = "$PSScriptRoot\Resources\JS\apexcharts.min.js"
            }
            HeaderAlways = @{
                #Css = "$PSScriptRoot\Resources\CSS\apexcharts.css"
            }
        }
        Jquery           = @{
            Comment = 'Jquery'
            Header  = @{
                JsLink = 'http://code.jquery.com/jquery-3.3.1.min.js'
                Js     = "$PSScriptRoot\Resources\JS\jquery-3.3.1.min.js"
            }
        }
        DataTables       = @{
            Comment      = 'DataTables'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\datatables.css"
            }
            Header       = @{
                CssLink = 'https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.18/af-2.3.2/b-1.5.4/b-colvis-1.5.4/b-html5-1.5.4/b-print-1.5.4/cr-1.5.0/fc-3.2.5/fh-3.1.4/kt-2.5.0/r-2.2.2/rg-1.1.0/rr-1.2.4/sc-1.5.0/sl-1.2.6/datatables.min.css'
                Css     = "$PSScriptRoot\Resources\CSS\datatables.min.css"
                JsLink  = "https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.18/af-2.3.2/b-1.5.4/b-colvis-1.5.4/b-html5-1.5.4/b-print-1.5.4/cr-1.5.0/fc-3.2.5/fh-3.1.4/kt-2.5.0/r-2.2.2/rg-1.1.0/rr-1.2.4/sc-1.5.0/sl-1.2.6/datatables.min.js"
                JS      = "$PSScriptRoot\Resources\JS\datatables.min.js"
            }
        }
        DataTablesPDF    = @{
            Comment = 'DataTables PDF Features'
            Header  = @{
                JsLink = 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js', 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js'
                Js     = "$PSScriptRoot\Resources\JS\pdfmake.min.js", "$PSScriptRoot\Resources\JS\vfs_fonts.min.js"
            }
        }
        DataTablesExcel  = @{
            Comment = 'DataTables Excel Features'
            Header  = @{
                JsLink = 'https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js'
                JS     = "$PSScriptRoot\Resources\JS\jszip.min.js"
            }
        }
        Fonts            = @{
            Comment      = 'Default fonts'
            HeaderAlways = @{
                CssLink = 'https://fonts.googleapis.com/css?family=Roboto|Hammersmith+One|Questrial|Oswald'
            }
        }
        FontsAwesome     = @{
            Comment      = 'Default fonts icons'
            HeaderAlways = @{
                CssLink = 'https://use.fontawesome.com/releases/v5.7.2/css/all.css'
            }
        }
        HideSection      = @{
            Comment      = 'Hide Section Code'
            HeaderAlways = @{
                JS = "$PSScriptRoot\Resources\JS\HideSection.js"
            }
        }
        Tabs             = @{
            Comment      = 'Elastic Tabs'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\tabs-elastic.css"
            }
            FooterAlways = @{
                JS = "$PSScriptRoot\Resources\JS\tabs-elastic.js"
            }
        }
        TimeLine         = @{
            Comment      = 'Timeline Simple'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\timeline-simple.css"
            }
        }
        StatusButtonical = @{
            Comment      = 'Status Buttonical'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\status.css"
            }
        }
        Toast            = @{
            Comment      = 'Toasts Looking Messages'
            HeaderAlways = @{
                Css = "$PSScriptRoot\Resources\CSS\toasts.css"
            }
        }
        TuiGrid          = @{
            Comment = 'Tui Grid'
            Header  = @{
                Css     = "$PSScriptRoot\Resources\CSS\tuigrid.css"
                CssLink = 'https://cdn.jsdelivr.net/npm/tui-grid@3.5.0/dist/tui-grid.css'
            }
        }
    }
}
function Set-Tag {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $HtmlObject
    )
    $HTML = [System.Text.StringBuilder]::new()
    [void] $HTML.Append("<$($HtmlObject.Tag)")
    foreach ($Property in $HtmlObject.Attributes.Keys) {
        $PropertyValue = $HtmlObject.Attributes[$Property]
        # This checks if property has any subproperties  such as style having multiple options
        if ($PropertyValue -is [System.Collections.IDictionary]) {
            $OutputSubProperties = foreach ($SubAttributes in $PropertyValue.Keys) {
                $SubPropertyValue = $PropertyValue[$SubAttributes]
                # skip adding properties that are empty
                if ($null -ne $SubPropertyValue -and $SubPropertyValue -ne '') {
                    "$($SubAttributes):$($SubPropertyValue)"
                }
            }
            $MyValue = $OutputSubProperties -join ';'
            [void] $HTML.Append(" $Property=`"$MyValue`"")
        } else {
            # skip adding properties that are empty
            if ($null -ne $PropertyValue -and $PropertyValue -ne '') {
                [void] $HTML.Append(" $Property=`"$PropertyValue`"")
            }
        }
    }
    if (($null -ne $HtmlObject.Value) -and ($HtmlObject.Value -ne '')) {
        [void] $HTML.Append(">")
        foreach ($Entry in $HtmlObject.Value) {
            if ($Entry -is [System.Collections.IDictionary]) {
                [string] $NewObject = Set-Tag -HtmlObject ($Entry)
                [void] $HTML.Append($NewObject)
            } else {
                [void] $HTML.AppendLine([string] $Entry)
            }

        }
        [void] $HTML.Append("</$($HtmlObject.Tag)>")
    } else {
        if ($HtmlObject.SelfClosing) {
            [void] $HTML.Append("/>")
        } else {
            [void] $HTML.Append("></$($HtmlObject.Tag)>")
        }
    }
    $HTML.ToString()
}


Export-ModuleMember `
    -Function @('New-HTML','New-HTMLAnchor','New-HTMLAnchorLink','New-HTMLAnchorName','New-HTMLChart','New-HTMLChartArea','New-HTMLChartBar','New-HTMLChartDataSet','New-HTMLChartLine','New-HTMLChartRadial','New-HTMLChartSpark','New-HTMLCodeBlock','New-HTMLContent','New-HTMLHeading','New-HTMLHorizontalLine','New-HTMLImage','New-HTMLLogo','New-HTMLMessage','New-HTMLPanel','New-HTMLResourceCSS','New-HTMLResourceJS','New-HTMLStatus','New-HTMLStatusItem','New-HTMLTab','New-HTMLTabHead','New-HTMLTable','New-HTMLTableCondition','New-HTMLTag','New-HTMLTimeline','New-HTMLTimelineItem','New-HTMLToast','Out-HtmlView','Save-HTML') `
    -Alias @('New-CSS','New-HTMLColumn','New-JavaScript','New-ResourceCSS','New-ResourceJS','Out-GridHtml')
