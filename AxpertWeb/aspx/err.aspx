<%@ Page Language="VB" AutoEventWireup="false" CodeFile="err.aspx.vb" Inherits="err" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Error Page"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title>Error</title>
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script type="text/javascript">
        var enableBackButton = false;
        var enableForwardButton = false;
    </script>
    <!-- <link href="../Css/globalStyles.min.css?v=36" rel="stylesheet" /> -->
    <asp:PlaceHolder runat="server">
        <%:Styles.Render(If(direction = "ltr", "~/UI/axpertUI/ltrBundleCss", "~/UI/axpertUI/rtlBundleCss")) %>
    </asp:PlaceHolder>
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
    <!-- <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script> -->
    <asp:PlaceHolder runat="server">
        <%:Scripts.Render("~/UI/axpertUI/bundleJs") %>
    </asp:PlaceHolder>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <%--custom alerts start--%>
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <%--custom alerts end--%>
   
    <script src="../Js/err.min.js?=4" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>  
    <script type="text/javascript">
        var serverprocesstime = '<%=serverprocesstime%>';
        var requestProcess_logtime = '<%=requestProcess_logtime%>';
        $(document).ready(function (event) {
            if (serverprocesstime != '') {
                WireElapsTime(serverprocesstime, requestProcess_logtime);

                GetProcessTime();
                GetTotalElapsTime();
            }
        });
    </script>
</head>
<body>
    <form dir="<%=direction%>" name="f1" id="form1" runat="server">
        <div class="d-flex justify-content-center align-items-center p-10 vh-100">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
                <Scripts>
                    <asp:ScriptReference Path="../Js/helper.min.js?v=141" />
                </Scripts>
                <Services>
                    <asp:ServiceReference Path="../WebService.asmx" />
                    <asp:ServiceReference Path="../CustomWebService.asmx" />
                </Services>
            </asp:ScriptManager>

            <%If errMsg.Contains("Disconnected because you have logged into another session.") Then
                    Response.Write("<script>")
                    Response.Write("parent.parent.location.href='../aspx/sess.aspx';")
                    Response.Write("</script>")
                    Return
                ElseIf errMsg.Contains("Session Authentication failed...") Then
                    Response.Write("<script>")
                    Response.Write("parent.parent.location.href='../aspx/sess.aspx';")
                    Response.Write("</script>")
                    Return
                End If
            %>

            <h1 class="h1 me-3 my-0 align-top inline-block align-content-center">
                <asp:Label ID="lblerror" runat="server" meta:resourcekey="lblerror">Error</asp:Label>
            </h1>
            <div class="inline-block align-middle ps-3 py-2 border-danger border-start">
                <% If errMsg <> String.Empty Then%>
                    <script type="text/javascript"> callParentNew("closeFrame()", "function"); </script>
                    <asp:Label ID="lblerror1" runat="server" meta:resourcekey="lblerror1" CssClass="d-flex h4">Error occured due to the following reason:&nbsp;</asp:Label>
                    <h2 class="my-0 font-weight-normal lead" id="desc"><%=errMsg%></h2>
                <%Else%>
                    <h2 class="my-0 font-weight-normal lead" id="desc"><%=customError%></h2>
                <%End If%>
            </div>

            <%=enableBackForwButton%>
            <div id="dvGoBack" class="d-none">

                <span class="navLeft icon-arrows-left-double-32" onclick="javascript:BackForwardButtonClicked(&quot;back&quot;);"
                    id="goback" style="text-decoration: none; cursor: pointer; border: 0px;"
                    title="Click here to go back" />

            </div>
            <asp:Label ID="lblCustomerror" runat="server" meta:resourcekey="lblCustomerror" Visible="false">Server error. Please try again.If the problem continues, please contact your administrator.</asp:Label>
            <asp:Label ID="lblInvParams" runat="server" meta:resourcekey="lblInvParams" Visible="false">Invalid parameter</asp:Label>
            <asp:Label ID="lbleroccurred" runat="server" meta:resourcekey="lbleroccurred" Visible="false">Error occurred(2). Please try again or contact administrator.</asp:Label>
            <asp:Label ID="lblUnknownError" runat="server" meta:resourcekey="lblUnknownError" Visible="false">Unknown error. Please try again. If the problem continues, please contact your administrator.</asp:Label>
        </div>
    </form>
</body>
</html>
