<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Comments.aspx.vb" Inherits="Comments" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="description" content="Comments"/>
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP"/>
    <meta name="author" content="Agile Labs"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>    
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Comments</title>
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
    <%If EnableOldTheme = "true" Then%>
    <link href="../Css/genericOld.min.css" rel="stylesheet" type="text/css" />
    <%Else%>
    <link href="../Css/generic.min.css?v=10" rel="stylesheet" type="text/css" />
    <%End If%>
    <link id="themecss" type="text/css" rel="Stylesheet" href="" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <%--custom alerts start--%>
    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <%--custom alerts end--%>

    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../Js/Comments.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
</head>
<body class="Pagebody bodymargin">
    <form id="form1" runat="server" dir="<%=direction%>">
        <div style="margin-left: 20px; width: 840px">
            <div id="breadcrumb-panel" style="width: 800px">
                <div id="breadcrumb">
                    <h3>
                        <asp:Label ID="lblComments" runat="server" Text="Comments"></asp:Label></h3>
                </div>
            </div>
            <asp:Label ID="lblMsg" runat="server" Visible="False" ForeColor="Red"></asp:Label>
            <asp:GridView CellSpacing="-1" ID="gvComments" runat="server" AutoGenerateColumns="False" AllowPaging="True"
                CssClass="gridData" AllowSorting="true" Height="16px" Width="95%">
                <RowStyle Height="5px" />
                <Columns>
                    <asp:TemplateField HeaderText="User">
                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="20%" />
                        <HeaderStyle />
                        <ItemTemplate>
                            <asp:Label ID="lblUser" runat="server" Text='<%# Bind("From")%>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Comments">
                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="50%" />
                        <HeaderStyle />
                        <ItemTemplate>
                            <asp:Label ID="lblComments" runat="server" Text='<%# Bind("Comments")%>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" ShowHeader="True">
                        <ItemStyle Width="20%" HorizontalAlign="Left" VerticalAlign="Middle" />
                        <HeaderStyle />
                        <ItemTemplate>
                            <asp:Label ID="lblTime" runat="server" Text='<%# Bind("Time")%>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" ShowHeader="False">
                        <ItemStyle Width="10%" HorizontalAlign="Left" VerticalAlign="Middle" />
                        <HeaderStyle />
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("Status")%>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle />
                <AlternatingRowStyle />
            </asp:GridView>
        </div>
    </form>
</body>
</html>
