<%@ Page Language="VB" AutoEventWireup="false" CodeFile="emailaxpdocs.aspx.vb" Inherits="emailaxpdocs" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Axpert Tstruct"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Email Axpert Docs</title>
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
    <link href="../Css/gen.min.css" rel="stylesheet" type="text/css"/>
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
</head>

<body>
    <form name="form1" dir="<%=direction%>">
        <div>
            <table style='width:100%;padding:1px;border:0px' class="emailBdr">
                <tr>
                    <td>
                        <table style='width:100%;padding:1px;border:0px' class="emailBdr">
                            <tr class="emailPgBg">
                                <td class="anahead">&nbsp;</td>
                            </tr>
                            <%=chkVal%>
                            <tr>
                                <td class="rowbor" align="center">
                                    <%  If chkVal = "" Then
                                            Response.Write("<font color=maroon>No Related Document Available For this Structure</font>")
                                        Else%>
                                    <input type="button" name="sub" value="OK" onclick="javascript: subValues();" /></td>
                            </tr>
                            <%End If%>
                        </table>
                    </td>
                </tr>

            </table>

    </div>
    </form>
</body>
<script src="../Js/emailaxpdocs.min.js?v=1" type="text/javascript"></script>
<script src="../Js/common.min.js?v=118" type="text/javascript"></script>

</html>
