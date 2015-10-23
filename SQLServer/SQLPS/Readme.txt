== Install SQL Server PowerShell Module (SQLPS) ==

When installing SQL server, the PowerShell modules are installed by default, but if you wan’t to run scripts or commands from a computer/server that hasn’t got an installation of SQL, you need to install these manually.

This installation is quite straight forward and does not require a restart, already open PowerShell windows must be reopened though. (Same goes for ISE).

All you need to do is to download the following three packages from:

http://www.microsoft.com/en-us/download/details.aspx?id=29065

Microsoft® System CLR Types for Microsoft® SQL Server® 2012 (SQLSysClrTypes.msi)

Microsoft® SQL Server® 2012 Shared Management Objects (SharedManagementObjects.msi)

Microsoft® Windows PowerShell Extensions for Microsoft® SQL Server® 2012 (PowerShellTools.msi)

Be sure to select the correct architecture, x86 or x64, and install them in the order above.

When completed, you are able to import the module by running:

Import-Module sqlps

If needed, you can include -DisableNameChecking as well.

Example Command:

Import-Module sqlps

Invoke-Sqlcmd -ServerInstance "SCAURORA13\SQL13" -Database "MSDB" -Query "Select @@version"