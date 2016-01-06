== Lapointe SharePoint Online PowerShell ==

Usage Instructions:

Install the PowerShell Module to a location of your choice

Import the PowerShell Module through the following methods:

Import-Module "Lapointe.SharePointOnline.PowerShell"

Or using the full installation path like the following example:

Import-Module "C:\Program Files\Falchion Consulting, LLC\SharePoint Online PowerShell\Lapointe.SharePointOnline.PowerShell\Lapointe.SharePointOnline.PowerShell.psd1"

Known Issues:

On other processor architecture different to 'Amd64' change the following line in the 'Lapointe.SharePointOnline.PowerShell.psd1' file to match your processor architecture

# Processor architecture (None, X86, Amd64, IA64) required by this module
ProcessorArchitecture = 'Amd64'

Example:

# Processor architecture (None, X86, Amd64, IA64) required by this module
ProcessorArchitecture = 'None'