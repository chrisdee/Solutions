<%@ Assembly Name="Microsoft.SharePoint.ApplicationPages, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%> <%@ Page Language="C#" Inherits="Microsoft.SharePoint.ApplicationPages.ErrorPage" MasterPageFile="simplev4.master"       %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %> <%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Import Namespace="Microsoft.SharePoint" %> <%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Import Namespace="Microsoft.SharePoint" %> <%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<asp:Content ContentPlaceHolderId="PlaceHolderPageTitle" runat="server">
	<SharePoint:EncodedLiteral runat="server" text="<%$Resources:wss,error_pagetitle%>" EncodeMethod='HtmlEncode'/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderPageTitleInTitleArea" runat="server">
	<span id="errorPageTitleSpan" tabindex="0"><img src="/_layouts/images/orion.png"/><br/><br/>Opps! Something went wrong here.</span>
    <p><a href="mailto:Helpdesk@yourcompany.com?subject=New SharePoint Incident&amp;body=&lt;Please provide a short description and paste Error Gibberish including Correlation ID and Date Time here&gt;">Log SharePoint Support Ticket</a></p>
</asp:Content>
<asp:Content contentplaceholderid="PlaceHolderAdditionalPageHead" runat="server">
	<meta name="Robots" content="NOINDEX " />
	<meta name="SharePointError" content="0" />
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
<style>
.s4-simple-iconcont{
	display:none;
}
</style>
<SharePoint:UIVersionedContent UIVersion="3" runat="server"><ContentTemplate>
 <table width="100%" border="0" class="ms-titleareaframe" cellpadding="0">
	<tr>
	<td valign="top" width="100%" style="padding-top: 10px" class="ms-descriptiontext">
</ContentTemplate></SharePoint:UIVersionedContent>

		<b>Error Gibberish:</b><br/>
	   <SharePoint:FormattedString id="LabelMessage" EncodeMethod="HtmlEncodeAllowSimpleTextFormatting" runat="server">
			<asp:HyperLink id="LinkContainedInMessage" runat="server"/>
	   </SharePoint:FormattedString>
	   <p>
		   <span class="ms-descriptiontext">
			   <asp:HyperLink id="AdditionalHelpLink" Visible="false" runat="server"/>
		   </span>
	   </p>
	   <p>
		   <span class="ms-descriptiontext"></span></p>
	   <p>
		   <asp:Label ID="RequestGuidText" Runat="server" />
	   </p>
	   <p>
		   <asp:Label ID="DateTimeText" Runat="server" /><br/>
	   </p>
<SharePoint:UIVersionedContent UIVersion="3" runat="server"><ContentTemplate>
	</td>
	</tr>
 </table>
</ContentTemplate></SharePoint:UIVersionedContent>
<script type="text/javascript" language="JavaScript">
// <![CDATA[
function ULSvam(){var o=new Object;o.ULSTeamName="Microsoft SharePoint Foundation";o.ULSFileName="error.aspx";return o;}
	 var gearPage = document.getElementById('GearPage');
	 if(null != gearPage)
	 {
		 gearPage.parentNode.removeChild(gearPage);
		 document.title = "<SharePoint:EncodedLiteral runat='server' text='<%$Resources:wss,error_pagetitle%>' EncodeMethod='HtmlEncode'/>";
	 }
	function _spBodyOnLoad()
	{ULSvam:;
		var intialFocus = document.getElementById("errorPageTitleSpan");
		try
		{
			intialFocus.focus();
		}
		catch(ex)
		{
		}
	}
// ]]>
</script>
</asp:Content>
