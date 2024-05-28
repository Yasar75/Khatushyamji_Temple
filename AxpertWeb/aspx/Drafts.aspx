<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Drafts.aspx.cs" Inherits="aspx_Drafts" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Drafts"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Drafts </title>
    <link href="../Css/globalStyles.min.css?v=36" rel="stylesheet" type="text/css" />
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
    <link href="../Css/generic.min.css?v=10" rel="stylesheet" type="text/css" id="generic" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <%--custom alerts start--%>
    <link href="../Css/animate.min.css" rel="stylesheet" type="text/css" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" type="text/css" />
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <%--custom alerts end--%>

    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>

    <link id="themecss" type="text/css" rel="Stylesheet" href="" />

    <script type="text/javascript">
        $j(document).ready(function () {
            // ChangeTheme(window, true);
        });


    </script>

</head>
<body>
    <form id="form1" runat="server" dir="<%=direction%>">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="../WebService.asmx" />
            </Services>
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div id="dvDrafts" runat="server">
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div style="display: none">
            <asp:Button ID="btnGetDrafts" runat="server" OnClick="btnGetDrafts_Click" />
        </div>
    </form>
</body>
</html>
