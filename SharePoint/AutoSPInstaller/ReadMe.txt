Project Description

Automated SharePoint 2010/2013 PowerShell-based installation script. (SharePoint 2013 compatibility is currently in 'beta' status).

Introducing AutoSPInstaller v3 with numerous enhancements including:

- Granular SQL server assignment and aliasing for (almost) every service/web app (for control freaks)
- Centralized, remote installation to all farm servers
- Ability to specify any XML input file, by passing it as an argument to AutoSPInstallerLaunch.bat
- Several tweaks & fixes
- AutoSPInstaller works with and now leverages enhancements in SharePoint 2010 Service Pack 1 (with or without the June 2011 CU)! It takes advantage of some of the - cmdlet updates in SP1, while remaining backward-compatible with non-SP1 deployments.

Newer versions often include updates to the input file XML schema, so make sure you compare any of your existing XML files to the newest AutoSPInstallerInput.XML. See below for highlights of changes in v3.0.x.

This project consists of PowerShell scripts, an XML input file, and a standard windows batch file (to kick off the process) which together provide a quick and near-unattended installation and initial configuration (Service Apps, My Sites) of Microsoft SharePoint Server 2010. Works on both Windows 2008 and 2008 R2 (x64 only of course).

Perfect for repeated Virtual Machine-based installs/tear-downs, etc., but also great for production installs where you want to guarantee consistency and minimize data entry glitches. The immediate value is for installing and configuring the first/only server in a farm, but also supports using either server-specific input files or a single, all-encompassing input file for running the script on all farm servers (with parameters - e.g. for the service apps - set according to your desired topology).