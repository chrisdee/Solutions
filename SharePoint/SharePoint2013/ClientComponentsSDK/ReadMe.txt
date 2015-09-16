== SharePoint Server 2013 Client Components SDK ==

The installers located in the Binaries folder will install the assembly files in the Binary Install locations below.

These have already been extracted into the 'ClientComponentsSDK' folder into their relevant folders and can be referenced in PowerShell Scripts like the following example using the 'Add-Type' command:

Add-Type -Path "C:\BoxBuild\GitHub\Solutions\SharePoint\SharePoint2013\ClientComponentsSDK\ISAPI\Microsoft.SharePoint.Client.dll"

Add-Type -Path "C:\BoxBuild\GitHub\Solutions\SharePoint\SharePoint2013\ClientComponentsSDK\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

Binaries Install Locations:

%ProgramFiles%\SharePoint Client Components\Assemblies
%ProgramFiles%\SharePoint Client Components\Scripts

The following files in %ProgramFiles%\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI:
Microsoft.Office.Client.Education.dll
Microsoft.Office.Client.Policy.dll
Microsoft.Office.Client.TranslationServices.dll
Microsoft.SharePoint.Client.dll
Microsoft.SharePoint.Client.DocumentManagement.dll
Microsoft.SharePoint.Client.Publishing.dll
Microsoft.SharePoint.Client.Runtime.dll
Microsoft.SharePoint.Client.Search.Applications.dll
Microsoft.SharePoint.Client.Search.dll
Microsoft.SharePoint.Client.Taxonomy.dll
Microsoft.SharePoint.Client.UserProfiles.dll
Microsoft.SharePoint.Client.WorkflowServices.dll

The following files in %ProgramFiles%\Common Files\Microsoft Shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\ClientBin:
Microsoft.Office.Client.Policy.Silverlight.dll
Microsoft.Office.Client.TranslationServices.Silverlight.dll
Microsoft.SharePoint.Client.DocumentManagement.Silverlight.dll
Microsoft.Sharepoint.Client.Publishing.Silverlight.dll
Microsoft.SharePoint.Client.Search.Applications.Silverlight.dll
Microsoft.SharePoint.Client.Search.Silverlight.dll
Microsoft.SharePoint.Client.Silverlight.dll
Microsoft.SharePoint.Client.Silverlight.Runtime.dll
Microsoft.SharePoint.Client.Taxonomy.Silverlight.dll
Microsoft.SharePoint.Client.WorkflowServices.Silverlight.dll

The following files in %ProgramFiles%\Common Files\Microsoft Shared\Web Server Extensions\15\Client:
MSOIDCLIL.DLL
MSOIDRES.DLL