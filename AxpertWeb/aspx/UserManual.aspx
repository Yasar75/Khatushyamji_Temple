<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserManual.aspx.cs" Inherits="aspx_UserManual" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="User manual"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>User Manual</title>
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script src="../Js/thirdparty/jquery-ui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <link href="../Css/thirdparty/jquery-ui/1.12.1/jquery-ui.min.css" rel="stylesheet" />
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
    <script src="../Js/common.min.js?v=118"></script>
    <link href="../Css/aboutus.min.css?v=3" rel="stylesheet" />
    <script>
        $(document).ready(function () {
            modalHeader = eval(callParent("divModalHeader", "id") + ".getElementById('divModalHeader')");
            modalHeader.innerText = eval(callParent('lcm[492]'));
            $("#btnClose").prop("title", eval(callParent('lcm[249]')));
            $(this).parent("#btnClose").focus();
        })

        function ShowFiles(src) {
            src = unescape(src);
            var idx = src.lastIndexOf("/");
            if (idx > -1) src = src.substring(0, idx + 1) + encodeURIComponent(src.substring(idx + 1, src.length));
            window.open(src, "UserManual", "width=500,height=350,scrollbars=no,resizable=yes");
        }
    </script>
    <style>
        .btextDir-rtl .modal-header button#btnModalClose {
            float: left !important;
        }
    </style>
</head>
<body class="btextDir-<%=direction%>" dir="<%=direction%>">
    <div class="container">
        <asp:Literal id="listOfFiles" runat="server" />
        
        <button type="button" id="btnClose" class="coldbtn btn" onclick="parent.closeModalDialog()" title=""></button>
    </div>
</body>
</html>
