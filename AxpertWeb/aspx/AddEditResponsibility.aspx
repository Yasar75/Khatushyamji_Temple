<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddEditResponsibility.aspx.cs" Inherits="aspx_AddEditResponsibility" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Access</title>
    <meta charset="utf-8"/> 
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <!-- ________ CSS __________ -->
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
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
    <link href="../Css/cloudGrid.min.css" rel="stylesheet" />
    <link href="" rel="stylesheet" id="themecss" type="text/css" />
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../Css/Users.min.css?v=5" rel="stylesheet" type="text/css" />
    <link href="../Css/newMenu.min.css?v=22" rel="stylesheet" type="text/css" />
    <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />

    <!-- ________ JAVASCRIPT __________ -->
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script src="../Js/umgmt.min.js?v=18" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/lang/content-<%=langType%>.js?v=59"></script>
</head>
<body class="btextDir-<%=direction%>" dir="<%=direction%>">
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager runat="server">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="addEditRespUpdatePanel" runat="server">
                <ContentTemplate>
                     <asp:Button Text="" runat="server" id="btnTreeViewExpand" style="display:none" OnClick="btnTreeViewExpand_Click"/>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:HiddenField ID="hdnTreeSelVal" runat="server" />
            <div id="dvEditResp" class="container">
                <div class="form-horizontal">
                    <div class="form-group">
                        <div class="col-xs-3">
                            <label id="lblResponsibility" class="control-label ">Responsibility</label>
                            <span class="req">*</span>
                        </div>
                        <div class="col-xs-9">
                            <asp:TextBox ID="txtReEditResp" runat="server" MaxLength="20" CssClass="form-control input-sm"></asp:TextBox>
                        </div>
                    </div>
                    <%--   <div class="form-group">
                                <label class="control-label col-xs-3"><span runat="server">Status</span></label>
                                <div class="col-xs-9">
                                    <select class="form-control input-sm" id="ddlStatus" runat="server">
                                        <option value="Active">Active</option>
                                        <option value="Inactive">Inactive</option>
                                    </select>
                                    <asp:DropDownList ID="rdbtnStatus" runat="server" RepeatDirection="Horizontal" CssClass="form-control input-sm"
                                        AutoPostBack="true" TextAlign="right">
                                        <asp:ListItem Value="Active">Active</asp:ListItem>
                                        <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>--%>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <div id="newMenuSearch" class="search-form">
                                <input type="text" value="" id="txtSearchNode" runat="server" placeholder="Search..." class="new-search-input search-input ui-autocomplete-input" autocomplete="off" />
                                <span title="Clear" id="GSclearBtn" class="close glyphicon glyphicon-remove icon-arrows-remove" style="font-size: 21px; right: 1px; top: 5px; display: none; color: black; opacity: 1!important;" tabindex="0"></span>
                                <button type="button" style="font-size: 15px; cursor: default;" id="globalSearchBtn" class="search-button">
                                    <i class="icon-magnifier "></i>
                                </button>
                                <span>
                                    <i class="icon-cross colorButton" style="display: none" id="searchclear" title="Clear"></i>
                                </span>
                                <span>
                                    <i class="icon-chevron-up colorButton" id="searchPrevPages" style="display: none" title="Previous"></i>
                                </span>
                                <span>
                                    <i class="icon-chevron-down colorButton" id="searchNextPages" style="display: none" title="Next"></i>
                                </span>
                                <span>
                                    <label id="lblSearchRecMsg" style="display: none"></label>
                                </span>
                               
                            </div>
                        </div>
                    </div>
                    <div class="form-group treenode-body">
                        <span id="spnTreeHeading">Access Rights</span>
                                <div class="treenode-content">
                                    <asp:TreeView ID="treeEditRes" runat="server" ShowCheckBoxes="All" onclick="client_OnTreeNodeChecked(event);" >
                                        <SelectedNodeStyle CssClass="GridHead" />
                                    </asp:TreeView>
                                </div>
                    </div>
                </div>
                <div id='waitDiv' style='display: none;'>
                    <div id='backgroundDiv' style='background: url(../Axpimages/loadingBars.gif) center center no-repeat rgba(255, 255, 255, 0.4); background-size: 135px;'>
                    </div>
                </div>
                <asp:HiddenField id="hdnAction" runat="server" />
            </div>
            <div class="add-edit-dialog-footer">
                <div class="pull-<%=direction == "rtl"?"left":"right" %>">
                    <asp:Button CssClass="hotbtn btn" ID="btnReEdSave" runat="server" Text="Save"
                        OnClientClick="javascript:return ValidateResp();" OnClick="btnReEdSave_Click" />
                    <input type="button" class="coldbtn btn" value="Close" id="btnClose" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
