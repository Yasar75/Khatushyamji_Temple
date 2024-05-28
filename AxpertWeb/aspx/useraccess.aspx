<%@ Page Language="VB" AutoEventWireup="false" CodeFile="useraccess.aspx.vb" Inherits="pvtpages_useraccess"
    ValidateRequest="false" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="Axpert User Access" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>User Access</title>
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
    <link href="" id="themecss" type="text/css" rel="Stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../Css/Users.min.css?v=5" rel="stylesheet" type="text/css" />
    <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />
    <link href="../ThirdParty/DataTables-1.10.13/media/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script type="text/javascript" src="../Js/lang/content-<%=langType%>.js?v=59"></script>
    <!-- ________ JAVASCRIPT __________ -->
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../Js/helper.min.js?v=141" type="text/javascript"></script>
    <script src="../Js/useraccess.min.js?v=12" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script src="../ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.min.js"></script>

    <script>
        var transid = '<%=Request.QueryString("transid")%>'
    </script>
   <style>
       .tab-content {
           margin-top: 15px;
       }

       .tc-action {
           padding: 5px;
           cursor: pointer;
           font-size: 15px;
       }

       table.dataTable thead th, table.dataTable thead td {
           padding: 0px 7px;
       }
   </style>
</head>
<body class="Family btextDir-<%=direction%>"  dir="<%=direction%>">
    <form id="form1" runat="server">
        <div class="form-horizontal">
            <div runat="server" class="success hide" id="dvMessage">
            </div>
            <div class="view-content">
                <asp:ScriptManager runat="server" />
                <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                    <ContentTemplate>
                        <ul class="nav nav-tabs">
                            <li id="liViewControl" class="active"><a href="#ViewControl" data-toggle="tab" id="aViewControl">View Control</a></li>
                            <li id="liTransactionControl"><a href="#TransactionControl" data-toggle="tab" id="aTransactionControl">Transaction Control</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="ViewControl">
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#DCs" data-toggle="tab" id="aDCs">DCs</a></li>
                                    <li><a href="#Fields" data-toggle="tab" id="aFields">Fields</a></li>
                                    <li><a href="#Buttons" data-toggle="tab" id="aButtons">Buttons</a></li>
                                    <li><a href="#ListviewButtons" data-toggle="tab" id="aListViewButtons">Listview Buttons</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="DCs">
                                        <div id="dc_div" runat="server" class="userTbl">
                                        </div>
                                        <asp:HiddenField ID="dc_xml" runat="server"></asp:HiddenField>
                                    </div>
                                    <div class="tab-pane" id="Fields">
                                        <div id="fields_div" runat="server" class="userTbl">
                                        </div>
                                        <asp:HiddenField ID="fld_xml" runat="server"></asp:HiddenField>
                                    </div>
                                    <div class="tab-pane" id="Buttons">
                                        <div id="but_div" runat="server" class="userTbl">
                                        </div>
                                        <asp:HiddenField ID="but_xml" runat="server" />
                                    </div>
                                    <div class="tab-pane" id="ListviewButtons">
                                        <div id="lv_div" runat="server" class="userTbl">
                                        </div>
                                        <asp:HiddenField ID="lv_xml" runat="server"></asp:HiddenField>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="TransactionControl">
                                <div class="container">
                                    <a runat="server" id="tcadd" class="colorButton icon-plus action-button" title="Add New"></a>
                                    <%--<asp:LinkButton Text="" runat="server" ID="tcadd" CssClass="colorButton icon-plus action-button" ToolTip="Add New"/>--%>
                                    <br />
                                    <table id="tblTC" class="gridData" cellspacing="0" width="100%" style="top: 9px;">
                                        <thead>
                                            <tr>
                                                <th>Expression</th>
                                                <th>View</th>
                                                <th>Edit</th>
                                                <th>Delete</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                    </table>
                                    <div id="tc_expr" runat="server" style="height: 280px;" visible="false">
                                        <asp:GridView CellSpacing="-1" ID="tc_expr_gv" runat="server" CellPadding="2" ForeColor="Black" GridLines="Vertical"
                                            Width="100%" RowStyle-Wrap="false" AutoGenerateColumns="False" CssClass="gridData"
                                            AutoGenerateDeleteButton="true" AutoGenerateEditButton="true" OnDataBound="tc_expr_gv_DataBound" >
                                            <SelectedRowStyle BackColor="LightCyan" ForeColor="DarkBlue" Font-Bold="true"  />
                                            <%--<HeaderStyle ForeColor="White" CssClass="GridHead" HorizontalAlign="Center" />--%>
                                            <AlternatingRowStyle CssClass="GridAltPage" />
                                            <RowStyle Wrap="False" />
                                        </asp:GridView>
                                    </div>

                                    <div id="tc_flds" runat="server" style="height: 280px;display:none">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label class="control-label col-xs-4" id="lblFieldColumn">Select Field/Column</label>
                                                <div class="col-xs-8">
                                                    <asp:DropDownList ID="tc_fld_cb" runat="server" class="form-control input-sm">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4" id="lblOperator">Operator</label>
                                                <div class="col-xs-8">
                                                  <%--  <select runat="server" id="tc_opr_cb" class="form-control input-sm">
                                                         <option></option>
                                                        <option value="Equal to">Equal to</option>
                                                        <option value="Not Equal to">Not Equal to</option>
                                                        <option value="Less Than">Less Than</option>
                                                        <option value="Less Than or Equal to">Less Than or Equal to</option>
                                                        <option value="Greater Than">Greater Than</option>
                                                        <option value="Greater Than or Equal to">Greater Than or Equal to</option>
                                                        <option value="Is Empty">Is Empty</option>
                                                        <option value="Between">Between</option>
                                                        <option value="Contains">Contains</option>
                                                        <option value="Not Contains">Not Contains</option>
                                                    </select>--%>
                                                    <asp:DropDownList ID="tc_opr_cb" runat="server" AutoPostBack="false" class="form-control input-sm">
                                                        <asp:ListItem></asp:ListItem>
                                                        <asp:ListItem Text="Equal to"></asp:ListItem>
                                                        <asp:ListItem Text="Not Equal to"></asp:ListItem>
                                                        <asp:ListItem Text="Less Than"></asp:ListItem>
                                                        <asp:ListItem Text="Less Than or Equal to"></asp:ListItem>
                                                        <asp:ListItem Text="Greater Than"></asp:ListItem>
                                                        <asp:ListItem Text="Greater Than or Equal to"></asp:ListItem>
                                                        <asp:ListItem Text="Is Empty"></asp:ListItem>
                                                        <asp:ListItem Text="Between"></asp:ListItem>
                                                        <asp:ListItem Text="Contains"></asp:ListItem>
                                                        <asp:ListItem Text="Not Contains"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4" id="lblValues">Values</label>
                                                <div class="col-xs-8">
                                                    <asp:DropDownList ID="tc_values_cb" runat="server" class="form-control input-sm">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-xs-4" id="lblValuesBtw">Values</label>
                                                <div class="col-xs-8">
                                                    <asp:DropDownList ID="tc_betvalues_cb" runat="server" Enabled="false" class="form-control input-sm">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="checkbox-inline">
                                                    <asp:CheckBox ID="tc_view_cb" runat="server" Text="View" CssClass="label" Checked="true" />
                                                </label>
                                                <label class="checkbox-inline">
                                                    <asp:CheckBox ID="tc_edit_cb" runat="server" Text="Edit" CssClass="label" Checked="true" />
                                                </label>
                                                <label class="checkbox-inline">
                                                    <asp:CheckBox ID="tc_delete_cb" runat="server" Text="Delete" CssClass="label" Checked="true" />
                                                </label>
                                            </div>
                                            <div class="form-group" id="divTCActions">
                                                <asp:HiddenField ID="editmode" Value="" runat="server" />
                                                <input type="button" id="btnTCOK" name="name" value="Ok" class="hotbtn btn" onclick="validateTransactionControl()"/>
                                                <input type="button" id="btnTCCancel" name="name" value="Cancel" class="coldbtn btn" onclick="cancelTransactionControl()"/>

                                                <asp:Button ID="tc_ok" runat="server" Text="OK" CssClass="hotbtn btn" OnClientClick="return validateTransactionControl()" Visible="false"/>
                                                <asp:Button ID="tc_cancel" runat="server" Text="Cancel" CssClass="coldbtn btn" OnClick="tc_cancel_Click" visible="false"/>

                                                <%--<input type="button" name="Close" value="Cancel" class="coldbtn btn"  onclick="cancelTransactionControl()"/>--%>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                       
                        <div style="display:none">
                        <asp:Menu ID="Menu1" runat="server"
                            Orientation="Horizontal" RenderingMode="List" IncludeStyleBlock="false" StaticMenuStyle-CssClass="nav nav-tabs" DynamicMenuStyle-CssClass="dropdown-menu" StaticSelectedStyle-CssClass="active"
                            OnMenuItemClick="Menu1_MenuItemClick">
                            <Items>
                                <asp:MenuItem Selected="true" Text="View Control" Value="0"></asp:MenuItem>
                                <asp:MenuItem Text="Transaction Control" Value="1"></asp:MenuItem>
                            </Items>
                        </asp:Menu>
                        <br />
                        <!-- Tab for View Control -->
                        <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
                            <asp:View ID="vc" runat="server">
                                <asp:Menu ID="vc_menu" Width="450px" runat="server"
                                    Orientation="Horizontal" RenderingMode="List" IncludeStyleBlock="false" StaticMenuStyle-CssClass="nav nav-tabs" DynamicMenuStyle-CssClass="dropdown-menu" StaticSelectedStyle-CssClass="active"
                                    OnMenuItemClick="vc_menu_MenuItemClick">
                                    <Items>
                                        <asp:MenuItem Text="DCs" Selected="true" Value="0"></asp:MenuItem>
                                        <asp:MenuItem Text="Fields" Value="1"></asp:MenuItem>
                                        <asp:MenuItem Text="Buttons" Value="2"></asp:MenuItem>
                                        <asp:MenuItem Text="Listview Buttons" Value="3"></asp:MenuItem>
                                    </Items>
                                </asp:Menu>
                            </asp:View>
                            <!-- Tab for Transaction Control -->
                            <asp:View ID="tc" runat="server">
                                
                            </asp:View>
                        </asp:MultiView>
                        <!-- View Control Inner Items -->
                        <asp:MultiView ID="MultiView2" runat="server" ActiveViewIndex="0">
                            <!-- DC's -->
                            <asp:View ID="dcs_view" runat="server">
                                <div style="height: auto; overflow: auto;">
                                    <table class="table">
                                        <tr style="vertical-align: top">
                                            <td style="border-top: none; text-align: left;">
                                                
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </asp:View>
                            <!-- Fields -->
                            <asp:View ID="fields_view" runat="server">
                                <div style="height: auto; overflow: auto;">
                                    <table class="table">
                                        <tr style="vertical-align: top">
                                            <td style="border-top: none; text-align: left;">
                                              
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </asp:View>
                            <!-- Buttons -->
                            <asp:View ID="but_view" runat="server">
                                <div style="height: auto; overflow: auto;">
                                    <table class="table">
                                        <tr style="vertical-align: top;">
                                            <td style="border-top: none; text-align: left;">
                                               
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </asp:View>
                            <!-- List view Buttons -->
                            <asp:View ID="lv_view" runat="server">
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
                            </div>
                        <asp:HiddenField runat="server" id="hdnFormChanges" Value="false" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
        <div class="dialog-footer">
            <div style="padding: 9px">
                <asp:Button runat="server" ID="save" Text="Save" CssClass="hotbtn btn" />
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
