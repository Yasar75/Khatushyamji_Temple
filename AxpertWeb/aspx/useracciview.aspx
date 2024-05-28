<%@ Page Language="VB" AutoEventWireup="false" CodeFile="useracciview.aspx.vb" Inherits="useracciview"
    ValidateRequest="false" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="Axpert file user access" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

    <title>User Access Iview</title>
    <!-- ________ CSS __________ -->
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Css/Users.min.css?v=5" />
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
    <link href="" id="themecss" type="text/css" rel="Stylesheet"/>
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../Css/Users.min.css?v=5" rel="stylesheet" type="text/css" />

    <!-- ________ JAVASCRIPT __________ -->
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../Js/helper.min.js?v=141" type="text/javascript"></script>
    <script src="../Js/useracciview.min.js?v=11" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script type="text/javascript" src="../Js/lang/content-<%=langType%>.js?v=59"></script>
       <style>
       .tab-content{
           margin-top:15px;
       }
        .view-content{
           height:313px !important;
       }
   </style>
    <script>
        var isCloudApp = '<%=isCloudApp%>'
    </script>
</head>
<body  class="Family btextDir-<%=direction%>"  dir="<%=direction%>">
    <form id="form1" runat="server" dir="<%=direction%>">
        <div class="form-horizontal">
            <div runat="server" class="success hide" id="dvMessage">
            </div>
            <div class="view-content">
                <asp:ScriptManager runat="server" />
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                           <div class="tab-pane active" id="ViewControl">
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#Buttons" data-toggle="tab" id="aButtons">Buttons</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="Buttons">
                                        <div id="but_div" runat="server" class="userTbl">
                                        </div>
                                        <asp:HiddenField ID="but_xml" runat="server" />
                                    </div>
                                </div>
                            </div>
                        <asp:Menu ID="Menu1" Width="150px" runat="server" Orientation="Horizontal" RenderingMode="List" IncludeStyleBlock="false" StaticMenuStyle-CssClass="nav nav-tabs" DynamicMenuStyle-CssClass="dropdown-menu" StaticSelectedStyle-CssClass="active" Visible="false">
                            <Items>
                                <asp:MenuItem Selected="true" Text="View Control" Value="0"></asp:MenuItem>
                            </Items>
                        </asp:Menu>
                        <br />
                        <!-- Tab for View Control -->
                        <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0" Visible="false">
                            <asp:View ID="vc" runat="server">
                                <asp:Menu ID="vc_menu" Width="100px" runat="server" Orientation="Horizontal" RenderingMode="List" IncludeStyleBlock="false" StaticMenuStyle-CssClass="nav nav-tabs" DynamicMenuStyle-CssClass="dropdown-menu" StaticSelectedStyle-CssClass="active">
                                    <Items>
                                        <asp:MenuItem Text="Buttons" Selected="true" Value="2"></asp:MenuItem>
                                    </Items>
                                </asp:Menu>
                            </asp:View>
                        </asp:MultiView>
                        <!-- View Control Inner Items -->
                        <asp:MultiView ID="MultiView2" runat="server" ActiveViewIndex="0">
                            <!-- Buttons -->
                            <asp:View ID="but_view" runat="server">
                                <div style="height: auto; overflow: auto;">
                                    <table class="table">
                                        <tr style="vertical-align: top">
                                            <td style="border-top: none; text-align: left;">
                                               
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </asp:View>
                        </asp:MultiView>
                      
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
        <div class="dialog-footer">
            <div class="<%=direction %>" style="padding: 9px">
                <asp:Button runat="server" ID="save" Text="Save" CssClass="hotbtn btn" OnClientClick="ShowDimmer(true);" />&nbsp;
                <input type="button" id="btnClose" name="Close" value="Close" class="coldbtn btn" onclick="closeWindow()" />
            </div>
        </div>
        <div id='waitDiv' style='display: none;'>
            <div id='backgroundDiv' style='background: url(../Axpimages/loadingBars.gif) center center no-repeat rgba(255, 255, 255, 0.4); background-size: 135px;'>
            </div>
        </div>
        <div id="ls" runat="server">
        </div>
    </form>
</body>
</html>
