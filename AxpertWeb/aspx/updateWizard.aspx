﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="updateWizard.aspx.cs" Inherits="aspx_updateWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wizard Setting</title>
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
    <link href="../Css/Icons/icon.css" rel="stylesheet" />
    <link href="../Css/developerWorkBench.min.css?v=14" rel="stylesheet" />
    <link href="../Css/iviewnewui.min.css?v=21" rel="stylesheet" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <script src="../Js/Jquery-2.2.2.min.js" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="wizardMain-container">
            <div class="container1">
                <div class="col-sm-12 col-md-12">
                    <div class="developerWorkBenchToolbar">
                        <ul class="dwbiconsUl" id="Formstb">

                            <li>
                                <a href="wizardsetting_new.aspx" title="Form Design" class="btn btn-secondary dropdown-toggle">New</a>
                            </li>
                            <li>
                                <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-secondary dropdown-toggle" BackColor="White" Text="Delete" />
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
        <div class="table-responsive">
  
                                

                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div id="mainContainer" class="container">  
            <div class="shadowBox">  
                <div class="page-container">  
                    <div class="container">  
                        <div class="row">  
                            <div class="col-lg-12 ">  
                                <div class="table-responsive">  
<asp:GridView ID="gdWizard" runat="server" AutoGenerateColumns="false" AllowPaging="true"
                                    OnPageIndexChanging="OnPageIndexChanging" PageSize="10" CssClass="table table-striped table-bordered table-hover">
                                    <Columns>
                                        <asp:TemplateField HeaderText="" HeaderStyle-Width="3%">
                                            <ItemTemplate>
                                                <input type="checkbox" id="chk" name="chk" value="<%#Eval("mst_wizardsettingid")%>" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Wizard Code">
                                            <ItemTemplate>
                                                <%#Eval("wizard_id")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Wizard Title">
                                            <ItemTemplate>
                                                <%#Eval("wizardTitle")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <a href="Wizardsetting_new.aspx?cId=<%#Eval("mst_wizardsettingid")%>">Edit</a>

                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>  
                                </div>  
                            </div>  
                        </div>  
                    </div>  
                </div>  
            </div>  
        </div>  


    </form>
</body>
</html>
