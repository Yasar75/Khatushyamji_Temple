<%@ Page Language="C#" AutoEventWireup="true" CodeFile="excelimportgrid.aspx.cs" Inherits="aspx_excelimportgrid" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="File Upload"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />	
    <title>File Upload</title>
    <link href="../Css/generic.min.css?v=10" rel="stylesheet" type="text/css" id="generic" />
    <link id="themecss" type="text/css" rel="Stylesheet" href="" />
   
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/iFrameHandler.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <%--custom alerts start--%>
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <%--custom alerts end--%>
    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <link href="../Css/fileupload.min.css?v=3" rel="stylesheet" /> 
   <script src="../Js/excelimport.min.js?v=3" type="text/javascript"></script>
    <script src="../Js/thirdparty/excelImport/xlsx.full.min.js" type="text/javascript"></script>
    
   
     <link href="../Css/tstructNewUi.min.css?v=82" rel="stylesheet" />
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



</head>
<body>

    <div class="file-upload">
        <div tabindex="0" class="file-select" id="spnFileSelect">
            <div class="file-select-button" id="fileName">
                            <asp:Label ID="lblfilename" meta:resourcekey="lblfilename" runat="server">Choose File</asp:Label>
                        </div>
                        <div class="file-select-name" id="noFile">
                            <asp:Label ID="lblnofilename" meta:resourcekey="lblnofilename" runat="server">No file chosen...</asp:Label>
                        </div>
                        <input runat="server" type="file" tabindex="-1" name="filMyFile" id="excelfile" accept=".xls,.xlsx" />
        </div>
    </div>
     <div class="row">
            <input name="Import" id ="excelimport" value="Import" type="button" title="Import" class="hotbtn btn handCursor excelimportGridBtn" onclick="">&nbsp;
            <input name="close" type="button" id="close" value="Close" title="Close" class="coldbtn btn handCursor excelimportGridBtn" onclick="callParentNew('closeModalDialog();','function')">
        </div>
   
</body>
</html>
