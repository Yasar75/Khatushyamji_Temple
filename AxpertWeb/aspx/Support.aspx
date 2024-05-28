<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Support.aspx.vb" Inherits="Support" ValidateRequest="false" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="Axpert Support" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>Support</title>
    <link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />
    <link href="../App_Themes/Default/Stylesheet.min.css?v=23" rel="stylesheet" />
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
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <link href="../Css/Icons/icon.css" rel="stylesheet" />
    <script type="text/javascript" src="../Js/thirdparty/jquery/3.1.1/jquery.min.js"></script>
    <script src="../Js/Support.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <link href="../Css/Support.min.css" rel="stylesheet" />
</head>
<body>
    <div id="errmsg" runat="server" style="position: absolute; left: 30%; top: 27px;"></div>
    <form id="form1" runat="server" style="background: white;">
        <br />
        <div id="dvEntire">
            <button id="showHideSQlBtn" type="button" onclick="ToHideOrShow()"><i id="iBtnClick" class="glyphicon glyphicon-minus icon-arrows-minus"></i><span>SQL</span></button>
            <div id="dvSql" style="padding: 0px 10px;">
                <asp:Label ID="Label1" runat="server" Text="SQL"></asp:Label>
                <textarea id="insql" cols="100" rows="5" class="form-control" runat="server"></textarea>
                <br />
                <asp:Button ID="Button1" runat="server" CssClass="hotbtn btn" Text="Execute Query" />
                <br />
                <br />
                <div id="dvRadioBtns" style="padding-left: 2%">
                    <asp:Label ID="Label3" runat="server" Text="Output Format :"></asp:Label>
                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="true">
                        <asp:ListItem Text="Data" Value="Data" Selected></asp:ListItem>
                        <asp:ListItem Text="XML" Value="XML"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>

            <br />
            <asp:Label ID="lblErr" runat="server"></asp:Label>

            <div runat="server" id="outxml" style="padding-left: 2%; width: 100%; overflow: auto; margin-bottom: 15px;"></div>
            <asp:Panel runat="server" ID="Panel2" Visible="false">
                <div id="dvGrdData" style="width: auto; height: 250px; overflow: auto;">
                    <asp:GridView CellSpacing="-1" ID="GridView1" runat="server" AllowPaging="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px"
                        CellPadding="3" GridLines="Vertical" Visible="false"
                        Font-Names="Segoe UI" Font-Size="Smaller" Style="overflow: auto" CssClass="gridData">
                        <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
                        <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="#DCDCDC" />
                    </asp:GridView>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
