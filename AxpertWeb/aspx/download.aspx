<%@ Page Language="VB" AutoEventWireup="false" CodeFile="download.aspx.vb" Inherits="aspx_download" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Download"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Download</title>
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
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script type="text/javascript" src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2"></script>
</head>
<body dir="<%=direction%>">
    <form id="form1" runat="server">
        <div>
            <br /><asp:Label ID="lblautodwnld" runat="server" meta:resourcekey="lblautodwnld">
            If the download doesn't start automatically, <a id="lnkFile" href="./download.aspx?act=false"><asp:Label ID="lbldwnldclk" runat="server" meta:resourcekey="lbldwnldclk">Click Here</asp:Label></a></asp:Label>
            <br />
            <br />
            <br />
            <div style="text-align: center">
                <a href="javascript:window.close();">Close</a>
            </div>
        </div>
    </form>
</body>
</html>
