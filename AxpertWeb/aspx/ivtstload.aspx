<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ivtstload.aspx.vb" Inherits="ivtstload"
    Debug="true" %>

<!DOCTYPE html>
<%@ Import Namespace="System.Xml" %>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Tstruct IView"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>IV Tstruct Load</title>
    <link rel="Stylesheet" href="../Css/gen.min.css" type="text/css" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" type="text/css" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>

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
</head>

<body class="Pagebody">
    <form id="form1" runat="server" dir="<%=direction%>">
        <div>
        </div>
    </form>
</body>

</html>
