<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ArrangeMenu.aspx.cs" Inherits="aspx_ArrangeMenu" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="IView"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>ArrangeMenu</title>
     <asp:PlaceHolder runat="server">
        <%:Styles.Render("~/Css/ArrangeMenu") %>
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
   
   <%-- <link href="../ThirdParty/materialize/css/materialize.min.css?v=3" rel="stylesheet" />
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
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../ThirdParty/fancytree-master/src/skin-material/ui.fancytree.css" rel="stylesheet">
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <link href="../Css/arrangeMenu.css?v=1" rel="stylesheet" />--%>
    
    <script>
        var menuData = '<%=menuData%>';
    </script>
</head>
<body class="btextDir-<%=direction%>" dir="<%=direction%>">
    <form id="form1" runat="server">
         <asp:PlaceHolder runat="server">
            <%:Scripts.Render("~/Js/ArrangeMenuJS") %>
        </asp:PlaceHolder>
        <div id="arrangeMenu">
        </div>
        <div id="triggerPopover"></div>
        <div id="arngmnuFooter" class="hide">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <ajaxToolkit:AsyncFileUpload runat="server" ID="uploadIcon" ClientIDMode="AutoID" OnUploadedComplete="uploadIcon_Click" OnClientUploadStarted="validateFile" OnClientUploadComplete="SetNodeIcon" onclientuploaderror="uploadError"></ajaxToolkit:AsyncFileUpload>
             <asp:Button ID="lnkChngIcon" Text="Change Icon" runat="server" CssClass="coldbtn" />
            <asp:Button ID="btnAdd" Text="Add Folder" runat="server" CssClass="coldbtn" />
            <asp:Button ID="btnDelete" Text="Delete" runat="server" CssClass="coldbtn" />
           <%--<asp:Button ID="btnCancl" Text="Cancel" runat="server" CssClass="coldbtn" />--%>
            <asp:Button ID="btnSave" Text="Save" runat="server" CssClass="hotbtn" />
           <%-- <ul>
                <li>
                    <a id="lnkChngIcon" text="Change Icon" runat="server" class="coldbtn">Change Icon</a>
                </li>
                <li>
                    <a id="btnAdd" text="Add Folder" runat="server" class="coldbtn">Add Folder</a>
                </li>
                <li>
                    <a id="btnDelete" text="Delete" runat="server" class="coldbtn">Delete</a>
                </li>
                <li>
                    <a id="btnCancl" text="Cancel" runat="server" class="coldbtn" >Cancel</a>
                </li>
            </ul>--%>
            <asp:HiddenField runat="server" ID="hdnUserIconList" />
            <asp:HiddenField runat="server" ID="hdnIconPath" />
        </div>
       
        <div id='waitDiv'>
            <div id='backgroundDiv'>
            </div>
        </div>
    </form>

   <%-- <script type="text/javascript" src="../Js/thirdparty/jquery/3.1.1/jquery.min.js"></script>
    <script src="../Js/thirdparty/jquery-ui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=1" type="text/javascript"></script>
    <%--    <script src="../ThirdParty/fancytree-master/dist/jquery.fancytree-all-deps.min.js"></script>--%>

   <%-- <script src="../ThirdParty/fancytree-master/src/jquery-ui-dependencies/jquery.fancytree.ui-deps.js"></script>
    <script src="../ThirdParty/fancytree-master/src/jquery.fancytree.js"></script>
    <script src="../ThirdParty/fancytree-master/src/jquery.fancytree.dnd5.js"></script>
    <script src="../ThirdParty/fancytree-master/src/jquery.fancytree.edit.js"></script>
    <script src="../ThirdParty/fancytree-master/src/jquery.fancytree.glyph.js"></script>
    <script src="../Js/xmlToJson.min.js?v=2"></script>
    <script src="../Js/ArrangeMenu.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js" type="text/javascript"></script>--%>

</body>
</html>
