This feature is installed to the farm and is enabled on a per-site basis. By navigating to Site Actions > Site Settings > Look and Feel > jQuery Settings, the site administrator can also configure the version of jQuery to load (1.3.2 through 1.6.1) and where the jQuery library will be delivered from (the local site or one of the available Content Delivery Networks).

To Install the Solution

Extract files to local hard drive (i.e. to c:TEMP)

Open the SharePoint 2010 Management Shell (PowerShell)

Use Add-SPSolution to upload the WSP file to the SharePoint farm

Add-SPSolution -LiteralPath C:TEMPPhoenixCodes.jQuery.wsp

Use Install-SPSolution to deploy the WSP to the farm

Install-SPSolution -Identity phoenixcodes.jquery.wsp -GACDeployment

To enable the feature on a specific site, visit Site Actions > Site Features.

Activate the “Phoenix Codes – Globally Load jQuery Library” feature.
