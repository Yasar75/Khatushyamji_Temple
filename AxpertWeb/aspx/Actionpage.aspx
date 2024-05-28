<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Actionpage.aspx.vb" Inherits="Actionpage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Axpert Tstruct"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Action Page</title>
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
    <link rel="Stylesheet" href="../Css/gen.min.css" type="text/css" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>

    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/adjustwindow.min.js?v=1"></script>


    <script type="text/javascript" src="../Js/ActionPage.min.js?v=1"></script>
</head>

<body class="Pagebody" onload="<%=bodyonload%>" style="margin: 0px 0px 0px 0px; height: auto;">
    <form id="form1" runat="server" style="height: auto;" dir="<%=direction%>">
    </form>

</body>

</html>
