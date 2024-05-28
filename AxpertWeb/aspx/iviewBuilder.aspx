<%@ Page Language="C#" AutoEventWireup="true" CodeFile="iviewBuilder.aspx.cs" Inherits="aspx_iviewBuilder" EnableEventValidation="false" ValidateRequest="false" %>

<!DOCTYPE html>

<html id="Head1" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="IView"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>Report Builder</title>

    <asp:PlaceHolder runat="server">
        <%:Styles.Render("~/Css/reportBuilder") %>
    </asp:PlaceHolder>

    <% if (direction == "rtl")
        { %>
    <link rel="stylesheet" href="../ThirdParty/bootstrap_rtl.min.css" type="text/css" />
    <% } %>
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
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
</head>
<body class="Mainbody Family btextDir-<%=direction%>" dir="<%=direction%>">
    <form id="form1" runat="server">
        <div>
            <asp:PlaceHolder runat="server">
                <%:Scripts.Render("~/Js/reportBuilder") %>
            </asp:PlaceHolder>
            <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="36000">
                <%--<Scripts>
                    <asp:ScriptReference Path="../Js/helper.min.js?v=141" />
                </Scripts>--%>
                <Services>
                    <asp:ServiceReference Path="../WebService.asmx" />
                </Services>
                <Services>
                    <asp:ServiceReference Path="../CustomWebService.asmx" />
                </Services>
            </asp:ScriptManager>
        </div>

        <div class="iviewTableWrapper tab-pane fade in active">

            <div id="GridView2Wrapper" runat="server" visible="true">
            </div>

            <table class="animationLoading">
                <thead><tr><th></th><th></th><th></th><th></th><th></th></tr></thead>
                <tbody><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td></tr></tbody>
            </table>

        </div>

        <div id="paramCont" runat="server" class="wBdr Pagebody">
            <asp:HiddenField ID="hdnparamValues" runat="server" />
            <asp:HiddenField ID="param" runat="server" Value="" />
            <asp:HiddenField ID="hdnSelParamsAftrChWin" runat="server" />
        </div>

        

        
    </form>
    
    <div id='waitDiv'>
        <div id='backgroundDiv'>
        </div>
    </div>
</body>
</html>
