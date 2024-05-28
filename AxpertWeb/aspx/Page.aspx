<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Page.aspx.cs" Inherits="aspx_Page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Page</title>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <link href="../ThirdParty/materialize/css/materialize.min.css?v=3" rel="stylesheet" />
    <link href="../Css/globalStyles.min.css?v=36" rel="stylesheet" />
    <script>
        if(typeof localStorage != "undefined"){
            var projUrl =  top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
            var lsTimeStamp = localStorage["customGlobalStylesExist-" + projUrl]
            if(lsTimeStamp && lsTimeStamp != "false"){
                var appProjName = localStorage["projInfo-" + projUrl] || "";
                var customGS = "<link id=\"customGlobalStyles\" data-proj=\""+ appProjName +"\" href=\"../"+ appProjName +"/customGlobalStyles.css?v="+ lsTimeStamp +"\" rel=\"stylesheet\" />";
                document.write(customGS);
            }
        }
    </script>
    <link href="../ThirdParty/scrollbar-plugin-master/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css" rel="stylesheet" />
    <link href="../ThirdParty/DataTables-1.10.13/media/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../Css/builderHome.min.css?v=36" rel="stylesheet" />
    <!-- <link href="" id="homeBuilderLink" rel="stylesheet" /> -->
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script>
        var userResponsibilities = '<%=Session["AxResponsibilities"] %>';
        userResponsibilities = userResponsibilities.split(",");
        var buildModeAccess = '<%=homeBuilder%>';
        buildModeAccess = buildModeAccess.split(',');
        var globalVars = '<%=globalVars%>';
        var imageBase = '<%=homeBuilderImagePath%>';
        var myTaskString = '<%=myTaskString%>';
        var appsessionKey = '<%=appsessionKey%>';
        var dbType = '<%=Session["axdb"]%>';
        var isPageBuilder = true;
        var homepagews = '<%=homepagews%>';
        var requestProcess_logtime = '<%=requestProcess_logtime%>';
        var serverprocesstime = '<%=serverprocesstime%>';
    </script>
</head>
<body dir="<%=direction %>" class="menu-<%=menuStyle%> btextDir-<%=direction%>">
    <div class="row" style="margin: 0px;">
        <div id="HPBmainWrapper">
            <div class="col s12" id="HPBdesignerCanvas">
                <div class="hpbWrapper">
                    <div id="hpbDsgnrcnvsWrapper">
                        <ul class="tabs" id="HPBtabsHaeder" style="display: none;">
                        </ul>
                        <div id="sortable" class="row mainWidgetAddedWrapper">
                            <div class="smallKpiDiv hide"></div>
                            <div class="clear"></div>
                            <div class="kpiDiv hide"></div>
                            <div class="clear"></div>
                            <div class="widgetDiv hide"></div>
                            <div class="clear"></div>
                            <div class="customDiv hide"></div>
                            <div class="clear"></div>
                            <div class="tstructDiv hide"></div>
                            <div class="clear"></div>
                            <div class="iviewDiv hide"></div>
                            <div class="clear"></div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="clear"></div>
        </div>
    </div>
    <script type="text/javascript" src="../Js/thirdparty/jquery/3.1.1/jquery.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1"></script>
    <script type="text/javascript" src="../Js/common.min.js?v=118"></script>
    <script src="../ThirdParty/jquery-mousewheel/jquery-mousewheel.min.js"></script>
    <script src="../ThirdParty/scrollbar-plugin-master/jquery.mCustomScrollbar.js"></script>
    <script src="../ThirdParty/materialize/js/materialize.min.js?v=11"></script>
    <script src="../Js/jquery.browser.min.js" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js"></script>
    <script src="../Js/alerts.min.js?v=30"></script>
    <script src="../ThirdParty/Highcharts/highcharts.js"></script>
    <script src="../ThirdParty/Highcharts/highcharts-3d.js"></script>
    <script src="../ThirdParty/Highcharts/highcharts-more.js"></script>
    <script src="../ThirdParty/Highcharts/highcharts-exporting.js"></script>
    <script src="../Js/high-charts-functions.min.js?v=20"></script>
    <script src="../ThirdParty/DataTables-1.10.13/extensions/Extras/moment.min.js"></script>
    <script src="../ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.min.js"></script>
    <script src="../ThirdParty/DataTables-1.10.13/extensions/Extras/datetime-moment.js"></script>
    <script src="../Js/templateParser.min.js?v=12"></script>
    <script src="../Js/commonBuilder.min.js?v=48"></script>
    <script src="../Js/commonHome.min.js?v=25"></script>
    <script src="../Js/builderHome.min.js?v=56"></script>
</body>
</html>
