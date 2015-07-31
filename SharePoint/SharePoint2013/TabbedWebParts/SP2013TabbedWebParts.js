<!-- Reference the jQueryUI theme's stylesheet on the Google CDN. Here we're using the "Start" theme --> 
<link  type="text/css" rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.0/themes/start/jquery-ui.css" /> 
<!-- Reference jQuery on the Google CDN --> 
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<!-- Reference jQueryUI on the Google CDN --> 
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.0/jquery-ui.min.js"></script> 

<script type="text/javascript">
     jQuery(document).ready(function($) {
        $(".s4-wpcell").hide();
         $(".s4-wpcell-plain").hide();
         //Put the Web Part Title for all the Web Parts you wish
         //to put into the tabbed view into the array below.
        HillbillyTabs(["Web Part Title 1","Web Part Title 2"]);
        //show persisted tab        
        ShowActiveTab();

    });

    function HillbillyTabs(webPartTitles)
    {
        for(index in webPartTitles)
        {
            var title = webPartTitles[index];
            $("#HillbillyTabs").append('<li><a href="#Tab'+index+'" id="TabHead'+index+'" onclick="SetActiveTab(this.id);">'+
title+'</a></li>').after('<div id="Tab'+index+'"></div>');
            $("span:contains('"+title+"')").each(function(){
                if ($(this).text() == title){
                   var webPart = $(this).hide().closest("span").closest("[id^='MSOZoneCell_WebPart']");
                   if ($(webPart).contents().html() != undefined)
                   {
                           webPart = $(webPart).contents();
                   }
                   $("#Tab" + index).append((webPart));
            }});
        }
        $("#tabsContainer").tabs();
        $(".s4-wpcell").show();
         $(".s4-wpcell-plain").show();
    }

    function SetCookie(id)
    {
           var date = new Date();
           //make the cookie expire in 5 minutes
           date.setTime(date.getTime()+(300*1000));
           var expires = "; expires="+date.toGMTString();
           document.cookie = "ActiveTab="+id+expires+"; path=/";
    }

    function ShowActiveTab()
    {
        var name = "ActiveTab";
        var cookieArray = document.cookie.split(";");
        for (index in cookieArray)
        {
            var keyValuePair = cookieArray[index].split("=");
            var key = keyValuePair[0];
            key  = key.replace(/^\s+|\s+$/g, "");
            if (key == name)
            {
                var value = keyValuePair[1];
                $("#" + value).click();
                return;
            }
        }
    }

</script>
<div id="tabsContainer"><ul id="HillbillyTabs"></ul></div>