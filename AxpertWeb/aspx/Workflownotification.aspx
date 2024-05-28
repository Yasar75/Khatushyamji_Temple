<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Workflownotification.aspx.cs" Inherits="Workflownotification" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="Axpert Sign in" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title></title>
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <link href="../Css/thirdparty/jquery-ui/1.12.1/jquery-ui.min.css" rel="stylesheet" />
    <link href="../Css/login.min.css?v=23" rel="stylesheet" type="text/css" />
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
    <link rel="shortcut icon" href="../images/favicon.ico" />
    <meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
    <meta http-equiv="EXPIRES" content="0" />
    <link href="../Css/Icons/icon.css" rel="stylesheet" />
    <link href="../Css/Workflownotification.min.css?v=4" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.browser.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <%--<link href="../Css/animate.min.css" rel="stylesheet" />--%>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/login.min.js?v=71"></script>
    <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />
    <%--<script type="text/javascript" src="../Js/lang/content-<%=langType%>.js?v=54"></script>--%>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script src="../assets/plugins/jquery-1.10.1.min.js" type="text/javascript"></script>
    <script src="../assets/plugins/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
    <!-- IMPORTANT! Load jquery-ui-1.10.1.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
    <script src="../assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js" type="text/javascript"></script>
    <script src="../assets/plugins/bootstrap-hover-dropdown/twitter-bootstrap-hover-dropdown.min.js"
        type="text/javascript"></script>

    <script type="text/javascript">
        var alertsTimeout = 3000;

        var isOfficeSSO = '<%=isOfficeSSO%>';
        var oktaclientKey = '<%=oktaclientKey%>';
        var oktadomain = '<%=oktadomain%>';
        var office365clientKey = '<%=office365clientKey%>';
        var ssoredirecturl = '<%=ssoredirecturl%>';
    </script>

    <script src="../Js/sso.js?v=2" type="text/javascript"></script>
    <script src="../Js/msal.js" type="text/javascript"></script>
    <script src="../Js/okta-auth-js.min.js" type="text/javascript"></script>
    <script src="../Js/workflowNotification.min.js?v=4"></script>
    <script type="text/javascript" src="../Js/common.min.js?v=118"></script>
</head>
<body class="page-header-fixed login" id="main_body" runat="server">
    <div class="row-fluid login-main">
        <div class="center-view">
            <div class="content">
                <form runat="server">
                    <div class="lpanel">
                        <asp:ScriptManager runat="server">
                        </asp:ScriptManager>
                        <asp:Panel runat="server" ID="panelSignin">
                            <div class="login-wrapper" runat="server" id="divPanelSignin">
                                <div class="card login-inner">
                                    <h2 class="form-title">
                                        <img src="../images/loginlogo.png" /><asp:Label ID="lblSignin" runat="server" meta:resourcekey="lblSignin">Sign In</asp:Label>
                                    </h2>
                                    <div class="control-group">
                                        <div class="controls field-wrapper">
                                            <div class="input-icon left">
                                                <input id="axUserName" runat="server" placeholder="" title="User Name" required="" class="m-wrap placeholder-no-fix" />
                                                <div class="field-placeholder">
                                                    <asp:Label ID="lblusername" runat="server" meta:resourcekey="lblusername">User Name</asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="control-group">
                                        <div class="controls field-wrapper">
                                            <div class="input-icon left">
                                                <input id="axPassword" runat="server" placeholder="" type="password" title="Password" required="" class="m-wrap placeholder-no-fix" />
                                                <div class="field-placeholder">
                                                    <asp:Label ID="lblpwd" runat="server" meta:resourcekey="lblpwd">Password</asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <asp:UpdatePanel ID="updSubmit" runat="server">
                                            <ContentTemplate>
                                                <asp:Button ID="submit" class="hotbtn btn" OnClick="submit_Click" Text="Login" runat="server" />

                                                <asp:Button ID="OktaBtn" class="hotbtn btn" Visible="false" runat="server" OnClientClick="axOktaLogin();return false;" Text="Okta Login" />

                                                <asp:Button ID="Office365Btn" class="hotbtn btn" Visible="false" runat="server" OnClientClick="Office365Init();return false;" Text="Office365 Login" />

                                                <asp:Button ID="GoogleBtn" class="hotbtn btn" Visible="false" runat="server" Text="Google account" OnClick="GoogleBtn_Click"></asp:Button>

                                                <asp:Button ID="FacebookBtn" class="hotbtn btn" Visible="false" runat="server" Text="Facebook account" OnClick="FacebookBtn_Click"></asp:Button>

                                                <asp:Button ID="WindowsBtn" class="hotbtn btn" Visible="false" runat="server" Text="Windows" OnClick="WindowsBtn_Click"></asp:Button>

                                                <asp:Button ID="SamlBtn" class="hotbtn btn" Visible="false" runat="server" Text="SAML Login" OnClientClick="return chkSSOLogin();" OnClick="SamlBtn_Click"></asp:Button>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:HiddenField ID="hdnPwd" runat="server" />
                                    </div>
                                </div>
                            </div>

                        </asp:Panel>
                    </div>
                    <div id="workflowComments" class="modal" data-backdrop="static" data-keyboard="false" data-easein="expandIn" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-target="#consumergoods2">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title">Comments</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <textarea class="form-control" rows="5" id="comment" runat="server"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="commentSave" class="btn btn-primary hotbtndynamic" OnClientClick="return CommentsValidate();" OnClick="comment_Click" Text="Save" title="Save" runat="server" />
                                    <asp:Label ID="commentCancel" class="btn btn-default coldbtndynamic" data-dismiss="modal" aria-hidden="true" onclick="resetActions()" data-placement="bottom" title="Cancel" runat="server" Text="Cancel"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:HiddenField ID="isAuthorized" runat="server" />
                    <asp:HiddenField ID="hdnComment" runat="server" />
                </form>
            </div>
        </div>
    </div>
</body>
</html>
