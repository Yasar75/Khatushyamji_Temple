<%@ Page Language="C#" AutoEventWireup="true" CodeFile="fileupload.aspx.cs" Inherits="fileupload" %>

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
    <link href="../Css/generic.min.css?v=10" rel="stylesheet" type="text/css" id="generic" />
    <link id="themecss" type="text/css" rel="Stylesheet" href="" />
    <link href="../Css/fileupload.min.css?v=3" rel="stylesheet" />
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
    <script src="../Js/fileUpload.min.js?v=22" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>


</head>
<body dir='<%=direction%>'>

    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="dcContent">
            <div class="lablattactxt">
                <table style="width: 100%" class="gridDatauploadtxt">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="lblslctfilename" meta:resourcekey="lblslctfilename" runat="server">Please select a file and then click 'Attach' button.</asp:Label>
                        </td>
                    </tr>
                </table>

            </div>
            <div class="clear"></div>
            <div>
                <div class="file-upload">
                    <div tabindex="0" class="file-select">
                        <div class="file-select-button" id="fileName">
                            <asp:Label ID="lblfilename" meta:resourcekey="lblfilename" runat="server">Choose File</asp:Label>
                        </div>
                        <div class="file-select-name" id="noFile">
                            <asp:Label ID="lblnofilename" meta:resourcekey="lblnofilename" runat="server">No file chosen...</asp:Label>
                        </div>
                        <input tabindex="-1" runat="server" type="file" name="filMyFile" id="filMyFile" accept="All Files/*" multiple="multiple" />
                    </div>
                </div>
            </div>
            <asp:Label ID="fileuploadsts" meta:resourcekey="fileuploadsts" Style="display: block; padding-top: 10px;" Text="" runat="server" ForeColor="#DB2222"></asp:Label>
            <asp:HiddenField ID="upsts" Value="" runat="server" />
            <asp:HiddenField ID="fname" Value="" runat="server" />
            <asp:HiddenField ID="hdnAction" Value="" runat="server" />

            <asp:Label ID="lblFileUp" runat="server" meta:resourcekey="lblFileUp" Visible="false">File uploaded successfully!</asp:Label>
            <asp:Label ID="lblfilecn" runat="server" meta:resourcekey="lblfilecn" Visible="false"></asp:Label>
            <asp:Label ID="lblAnError" runat="server" meta:resourcekey="lblAnError" Visible="false">An Error Occured. Please Try Again!</asp:Label>
        </div>
        <div style="display: block; padding-top: 10px;">
            <asp:Button ID="cmdSend" class="hotbtn btn handCur" title="Attach" runat="server" Text="Attach" OnClick="cmdSend_Click" />&nbsp;
            <input name="close" type="button" id="close" value="Close" title="Close" class="coldbtn btn handCursor" onclick="closeUploadDialog();">
        </div>
    </form>

</body>
</html>
