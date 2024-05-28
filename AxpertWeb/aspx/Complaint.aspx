<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Complaint.aspx.cs" Inherits="aspx_Complaint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Complaint Box</title>
    <meta charset="utf-8"/> 
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
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
    <link href="../Css/Complaint.min.css" rel="stylesheet" />
    <link href="../ThirdParty/scrollbar-plugin-master/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css" rel="stylesheet" />
    <link href="../ThirdParty/DataTables-1.10.13/media/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
</head>
    
<body dir="<%=direction %>" class="btextDir-<%=direction%>">
    <div class="wrap-contact100">
			<form id="form1" runat="server" class="contact100-form validate-form">
				<span class="contact100-form-title">
					Send us a message
				</span>

				<div class="wrap-input100">
					<input id="subject" class="input100" type="text" name="email" placeholder="Subject"/>
					<span class="focus-input100"></span>
				</div>

				<div class="wrap-input100">
					<textarea id="content" class="input100" name="message" placeholder="How Can We Help?"></textarea>
					<span class="focus-input100"></span>
				</div>

				<div class="container-contact100-form-btn">
					<button type="button" class="contact100-form-btn">
						Send Message
					</button>
				</div>
                <asp:HiddenField ID="CloudAPI" runat="server" />
                 <asp:HiddenField ID="UserName" runat="server" />
			</form>
		</div>
    <script type="text/javascript" src="../Js/thirdparty/jquery/3.1.1/jquery.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1"></script>
    <script type="text/javascript" src="../Js/common.min.js?v=118"></script>
    <script type="text/javascript" src="../Js/Complaint.min.js?v=1"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script src="../Js/alerts.min.js?v=30"></script>
    <script src="../ThirdParty/DataTables-1.10.13/extensions/Extras/moment.min.js"></script>
    <script src="../ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.min.js"></script>
    <script src="../ThirdParty/DataTables-1.10.13/extensions/Extras/datetime-moment.js"></script>
</body>
</html>
