﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Config.aspx.cs" Inherits="Config" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="Axpert LIC-DB-UI Configuration" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>
        <%=appTitle%>
    </title>
    <asp:PlaceHolder runat="server">
        <%:Styles.Render(direction == "ltr" ? "~/UI/axpertUI/ltrBundleCss" : "~/UI/axpertUI/rtlBundleCss") %>
    </asp:PlaceHolder>
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />

    <script>
        if (typeof localStorage != "undefined") {
            var customGS = "<link id=\"customGlobalStyles\" data-proj=\"\" href=\"\" rel=\"stylesheet\" />";
            document.write(customGS);
        }
    </script>
    <link rel="shortcut icon" href="../images/favicon.ico" />
    <meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
    <meta http-equiv="EXPIRES" content="0" />

    <script>
        if (!('from' in Array)) {
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>

    <script type="text/javascript">
        var applist = '<%=jsonText%>';
        var selProj = '<%=selProj%>';
        var IsLicExist = '<%=isLicExist%>';
        var authPopup = '<%=authPopup%>';
        var redislist = '<%=jsonRedisText%>';
    </script>
</head>
<body class="page-header-fixed" id="main_body" runat="server" dir="<%=direction%>">
    <div class="row-fluid m-auto" id="configbody" runat="server">
        <div class="">
            <div class="">
                <form id="form1" runat="server">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                        <Services>
                            <asp:ServiceReference Path="../WebService.asmx" />
                            <asp:ServiceReference Path="../CustomWebService.asmx" />
                        </Services>
                    </asp:ScriptManager>
                    <asp:Panel runat="server" ID="panelewConnection">
                        <div class="configWrapper">
                            <div class="">
                                <div class="configHeader d-flex flex-row flex-column-fluid navbar px-5">
                                    <div class="d-flex flex-row-fluid">
                                        <div class="">
                                            <img class="" src="../images/loginlogo.png" style="max-width: 400px; max-height: 175px;" />
                                        </div>
                                    </div>
                                    <div class="d-flex flex-row-fluid text-center configTitle my-6">
                                        <asp:Label ID="lblSignin" class="form-label fs-1  fw-boldest text-dark" runat="server">Axpert Configuration</asp:Label>
                                    </div>
                                    <div class="d-flex flex-row-auto w-auto flex-center">
                                        <div class="configTopToolbar my-4">
                                            <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm ms-2" id="btnHome" onclick="OpenSignIn();">
                                                <span class="material-icons">home
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                                <div class="content">
                                    <div class="panel-body licActivationWrapper card login-inner w-lg-1000px m-auto my-6">
                                        <div class="card-header align-items-center">
                                            <div class="licKeyActTitle card-title align-items-start flex-column">
                                                <div>
                                                    <h3>
                                                        <asp:Label ID="lbllicinfo" runat="server">License Information</asp:Label>
                                                    </h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row w-lg-1000px p-8 p-lg-12 mx-auto">
                                            <div class="col-sm-12">
                                                <div class="licActivationForm">
                                                    <div class="licKeyActDesc">
                                                        <asp:Label ID="Label1" class="form-label text-dark fs-6 mb-0" runat="server">This is licensed to Demo data corp. 
                                                        <label id="lbllicExpiry" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server"></label>
                                                        </asp:Label>
                                                        <button class="licInfoAccordion btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm float-end" type="button" data-bs-toggle="collapse" data-bs-target="#demo" aria-expanded="false" aria-controls="demo">
                                                            <span class="material-icons">expand_more</span>
                                                        </button>
                                                    </div>

                                                    <div class="collapse" id="demo">
                                                        <div class="licActOptions">
                                                            <div class="col-sm-12 ">
                                                                <asp:RadioButtonList ID="rbllictype" runat="server" RepeatDirection="Horizontal">
                                                                    <asp:ListItem Value="online" Selected="True">Activate online &nbsp;</asp:ListItem>
                                                                    <asp:ListItem Value="offline">Activate offline&nbsp;</asp:ListItem>
                                                                </asp:RadioButtonList>
                                                            </div>
                                                        </div>
                                                        <div class="clearfix"></div>
                                                        <div id="dvOnline">
                                                            <%--Online--%>
                                                            <div class="" id="dvlicmessage">
                                                                <p>
                                                                    The machine/processor ids will be captured and sent to Agile licensing server to get the license file. No other data will be captured.
                                                                </p>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                            <div class="licKeyInfoBox row g-3 align-items-center">
                                                                <div class="col-md-4 col-sm-12">
                                                                    <asp:Label ID="lblerkey" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Enter the registration key: </asp:Label>
                                                                </div>
                                                                <div class="col-md-8 col-sm-12">
                                                                    <asp:TextBox ID="txtlicappkey" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                            <div class="licKeyInfoBox">
                                                                <div class="col-sm-3"></div>
                                                                <div class="col-sm-11 licKeyActivateBtn">
                                                                    <asp:Button ID="btnActivateasp" runat="server" Text="Activate" ToolTip="Activate for new license" OnClick="btnActivate_Click" Style="display: none"></asp:Button>
                                                                    <asp:Button ID="btnRefreshasp" runat="server" Text="Refresh" ToolTip="Refresh existing license" OnClick="btnRefresh_Click" Style="display: none" />
                                                                    <asp:Button ID="btnTrialasp" runat="server" Text="Trial" ToolTip="Activate for trial license" OnClick="btnTrial_Click" Style="display: none" />
                                                                    <a href="javascript:void()" title="Activate" id="btnActivate" onclick="licActivateCheck();"><span class="material-icons licActBtnIcon">check_circle</span><span>Activate</span></a>
                                                                    <a href="javascript:void()" class="btn btn-primary d-inline-flex align-items-center shadow-sm me-2 my-4" title="Refresh" id="btnRefresh" onclick="licRefreshCheck();"><span class="material-icons licActBtnIcon">autorenew</span>Refresh</a>
                                                                    <a href="javascript:void()" title="Activate Trial" id="btnTrial" onclick="licTrialCheck();"><span class="material-icons licActBtnIcon">history_toggle_off</span><span>Activate Trial</span></a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div id="dvOffline" style="display: none">
                                                            <%--Offline--%>
                                                            <div class="">
                                                                <p>
                                                                    The machine/processor ids will be captured and sent to Agile licensing server to get the license file. No other data will be captured.
                                                                </p>
                                                            </div>
                                                            <div class="licKeyInfoBox">
                                                                <div class="col-sm-3">
                                                                    <asp:Label ID="Label3" runat="server">Enter the registration key: </asp:Label>
                                                                </div>
                                                                <div class="col-sm-9">
                                                                    <asp:TextBox ID="txtlicofflinekey" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="licKeyInfoBox">
                                                                <div class="col-sm-3">
                                                                    <asp:Button ID="btndownloadfile" runat="server" Text="Download registration file" ToolTip="Download registration file" OnClick="btndownloadfile_Click" Style="display: none"></asp:Button>
                                                                </div>
                                                                <div class="col-sm-9 licKeyActivateBtn">
                                                                    <asp:Button ID="btnDownloadasp" runat="server" Text="Download registration file" ToolTip="Download registration file" OnClick="btnDownload_Click" Style="display: none"></asp:Button>
                                                                    <a href="javascript:void()" title="Download registration file" id="btnDownload" onclick="offlinelicDownload();"><span class="material-icons licActBtnIcon">file_download</span><span>Download registration file</span></a>
                                                                    <a href="javascript:void()" title="Upload license file" id="btnUpload"><span class="material-icons licActBtnIcon">file_upload</span><span>Upload license file</span></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="dbConnectionWrapper my-6" id="dvdbConnection">
                                        <div class="panel-body card login-inner w-lg-1000px m-auto">
                                            <div class="card-header align-items-center">
                                                <div class="configLeftForm card-title align-items-start flex-column">
                                                    <div>
                                                        <h3>
                                                            <asp:Label ID="lblconnections" runat="server">Database Connections</asp:Label>
                                                        </h3>
                                                    </div>
                                                </div>
                                                <div class="card-header-toolbar">
                                                    <a href="javascript:void()" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm" id="btnaddcon">
                                                        <span class="material-icons material-icons-style">add
                                                        </span>
                                                    </a>
                                                </div>
                                            </div>


                                            <div class=" card-body row w-lg-1000px p-8 p-lg-12 mx-auto">
                                                <div class="">
                                                    <div class="configRightForm">
                                                        <div class="configRightFormFields">
                                                            <div class="dbConnectionTitle col-sm-7x">
                                                                <h3>
                                                                    <asp:Label ID="lblconname" class="form-label fw-boldest text-dark fs-2 mb-0 d-none" runat="server"></asp:Label>
                                                                </h3>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblname" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Connection Name</asp:Label>
                                                            </div>

                                                            <div class="configConList col-md-8 col-sm-12 d-flex flex-row">
                                                                <select id="lstconnection" data-control="select2" data-placeholder="Select Project" runat="server" class="multiselect form-select" size="10">
                                                                </select>
                                                                <a href="javascript:void()" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm ms-2" title="Delete" id="btncdelete"><span class="material-icons">delete</span></a>
                                                                <asp:Button ID="btndelete" class="btn btn-secondary d-none" runat="server" Text="Delete" OnClick="btndelete_Click" />
                                                            </div>

                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lbldatabase" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Database</asp:Label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-12">
                                                                <select class="form-select" runat="server" id="ddldbtype" data-control="select2" data-placeholder="Select Database" data-allow-clear="true">
                                                                    <option></option>
                                                                    <option value="Oracle">Oracle</option>
                                                                    <option value="MS SQL">MS SQL</option>
                                                                    <option value="MYSQL">MYSQL</option>
                                                                    <option value="MariaDB">MariaDB</option>
                                                                    <option value="Postgre">Postgre</option>
                                                                    <option value="Db2">Db2</option>

                                                                </select>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="databasever configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lbldbversion" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Database Version</asp:Label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-12">
                                                                <select class="form-select" runat="server" id="ddldbversion" data-control="select2" data-placeholder="Select an option" data-allow-clear="true">
                                                                    <option></option>
                                                                    <option value="" selected></option>
                                                                    <option value="2008">2008</option>
                                                                    <option value="2012">2012</option>
                                                                    <option value="Above 2012">Above 2012</option>
                                                                </select>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblccname" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Client connection name</asp:Label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtccname" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblusername" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">User name</asp:Label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtusername" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center mb-4">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblPassword" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Password</asp:Label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtPassword" type="password" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields" style="display: none;">
                                                            <div class="col-sm-4">
                                                                <asp:Label ID="lbldriver" runat="server">Driver</asp:Label>
                                                            </div>
                                                            <div class="col-sm-8">
                                                                <asp:DropDownList ID="ddldriver" runat="server" class="form-control">
                                                                    <asp:ListItem Value="dbx">dbx</asp:ListItem>
                                                                    <asp:ListItem Value="ado">ado</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card-footer">
                                                    <div class="configRightFormFields">
                                                        <div class="col-sm-12">
                                                            <div class="configRightFormFooterButton pull-right">
                                                                <input type="button" class="btn btn-active-primary shadow-sm" id="btnTestConnection" onclick="TestConnection();" value="Test Connection" />
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2 mx-2" title="Apply" id="btnApply" disabled="disabled" value="Apply" />
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2" title="Cancel" id="btnCancel" value="Cancel" />
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2" title="Change Password" id="btnChangePassword" class="btndisable" disabled="disabled" value="Change Password" />
                                                            </div>
                                                        </div>
                                                        <div class="clearfix"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="redicConnectionWrapper my-6" id="dvRedisConnection">
                                        <div class="panel-body card login-inner w-lg-1000px m-auto">
                                            <div class="card-header align-items-center">
                                                <div class="configLeftForm card-title align-items-start flex-column">
                                                    <div>
                                                        <h3>
                                                            <asp:Label ID="lblRConnections" runat="server">Redis Connections</asp:Label>
                                                        </h3>
                                                    </div>
                                                </div>
                                                <div class="card-header-toolbar">
                                                    <a href="javascript:void(0);" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm" id="btnRedisAdd">
                                                        <span class="material-icons material-icons-style">add
                                                        </span>
                                                    </a>
                                                </div>
                                            </div>


                                            <div class=" card-body row w-lg-1000px p-8 p-lg-12 mx-auto">
                                                <div class="">
                                                    <div class="configRightForm">
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblrname" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Connection Name</asp:Label>
                                                            </div>

                                                            <%--  <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtrccname" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>--%>
                                                            <div class="configConList col-md-8 col-sm-12 d-flex flex-row">
                                                                <select id="lstRconnection" data-control="select2" data-placeholder="Select Project" runat="server" class="multiselect form-select" size="10">
                                                                </select>
                                                                <a href="javascript:void()" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm ms-2" title="Delete" id="btnRcdelete"><span class="material-icons">delete</span></a>
                                                                <asp:Button ID="btnRedisdelete" class="btn btn-secondary d-none" runat="server" Text="Delete" OnClick="btnRedisdelete_Click" />
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblripaddress" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Host Name</asp:Label>
                                                            </div>

                                                            <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtrhotname" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblrPort" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Port</asp:Label>
                                                            </div>

                                                            <div class="col-md-8 col-sm-12">
                                                                <asp:TextBox ID="txtrport" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                        <div class="configRightFormFields row g-3 align-items-center">
                                                            <div class="col-md-4 col-sm-12">
                                                                <asp:Label ID="lblrpwd" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Password</asp:Label>
                                                            </div>

                                                            <div class="col-md-8 col-sm-12">
                                                                <%-- <asp:TextBox ID="txtrpwd" type="password" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>--%>
                                                                <asp:TextBox ID="txtrpwd" runat="server" autocomplete="off" class="m-wrap placeholder-no-fix form-control"></asp:TextBox>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card-footer">
                                                    <div class="configRightFormFields">
                                                        <div class="col-sm-12">
                                                            <div class="configRightFormFooterButton pull-right">
                                                                <%--<asp:Button ID="btnRedisTestConnection" class="btn btn-active-primary shadow-sm me-2 mx-2" runat="server" Text="Test Connection" OnClick="btnRedisTestConnection_Click" OnClientClick="return applyRedisconnection();" />--%>
                                                                <%--<asp:Button ID="btnRedisTestConnection" class="btn btn-active-primary shadow-sm me-2 mx-2" runat="server" Text="Test Connection" OnClientClick="applyRedisconnection();" />--%>
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2 mx-2" title="Apply" id="btnRedisTestConnection" value="Test Connection" onclick="applyRedisconnection();" />
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2 mx-2" title="Apply" id="btnRedisApply" disabled="disabled" value="Apply" />
                                                                <input type="button" class="btn btn-active-primary shadow-sm me-2" title="Cancel" id="btnRedisCancel" value="Cancel" />
                                                            </div>
                                                        </div>
                                                        <div class="clearfix"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="panel-body licActivationWrapper card login-inner w-lg-1000px m-auto my-6">
                                        <div class="card-header align-items-center py-6">
                                            <div class="col-md-4 col-sm-12">
                                                <h3 class="dbUIHeaderText">UI Configuration </h3>
                                            </div>
                                            <asp:Button ID="newConclick" class="d-none" runat="server" Text="Ok" OnClick="btnok_Click" OnClientClick="return applyconnection();" />
                                            <div class="col-md-8 col-sm-12 d-flex flex-row">
                                                <select id="axSelectProj" runat="server" data-placeholder="Select Project" data-control="select2" class="form-select" size="10">
                                                </select>
                                            </div>
                                        </div>
                                        <div class="dbUIWrapper card-body row w-lg-1000px p-8 p-lg-12 mx-auto">
                                            <div class="dbUIBody">
                                                <div class="row">
                                                    <div class="col-sm-4">
                                                        <div class="dbUIImgTitle p-2">
                                                            <h4>Project Logo</h4>
                                                        </div>
                                                        <div class="avatar-wrapper">
                                                            <div class="image-input image-input-outline" data-kt-image-input="true" style="background-image: url()">
                                                                <img class="profile-pic image-input-wrapper w-70px h-70px" src="../images/loginlogo.png" />
                                                                <label class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow"
                                                                    data-kt-image-input-action="change"
                                                                    data-bs-toggle="tooltip"
                                                                    data-bs-dismiss="click"
                                                                    title="Change avatar">
                                                                    <i class="material-icons">edit</i>
                                                                    <input class="file-upload hide" id="UploadAppLogoImg" data-type="logo" type="file" name="avatar" accept=".png, .jpg, .jpeg" />
                                                                    <input type="hidden" name="avatar_remove" />
                                                                </label>
                                                                <span class="delete-button d-flex btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow "
                                                                    data-kt-image-input-action="remove"
                                                                    data-bs-toggle="tooltip"
                                                                    data-bs-dismiss="click"
                                                                    title="Remove avatar">
                                                                    <i class="material-icons">delete</i>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <div class="dbUIImgTitle p-2 ">
                                                            <h4>Web Project Background</h4>
                                                        </div>
                                                        <div class="image-input image-input-outline" data-kt-image-input="true" style="background-image: url(/assets/media/svg/avatars/blank.svg)">
                                                            <img class="profile-pic image-input-wrapper w-250px h-150px" src="../AxpImages/loginlogo.png" />
                                                            <label class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow"
                                                                data-kt-image-input-action="change"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-dismiss="click"
                                                                title="Change avatar">
                                                                <i class="material-icons">edit</i>
                                                                <input class="file-upload d-none" id="UploadWebBgImg" data-type="webbg" type="file" name="avatar" accept=".png, .jpg, .jpeg" />
                                                                <input type="hidden" name="avatar_remove" />
                                                            </label>
                                                            <span class="delete-button  d-flex btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow"
                                                                data-kt-image-input-action="remove"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-dismiss="click"
                                                                title="Remove avatar">
                                                                <i class="material-icons">delete</i>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <div class="dbUIImgTitle p-2">
                                                            <h4>Mobile Project Background</h4>
                                                        </div>
                                                        <div class="avatar-wrapper">
                                                            <div class="image-input image-input-outline" data-kt-image-input="true" style="background-image: url(/assets/media/avatars/blank.png)">
                                                                <img class="profile-pic image-input-wrapper w-250px h-150px" src="../AxpImages/loginlogo.png" />
                                                                <label class=" upload-button btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow"
                                                                    data-kt-image-input-action="change"
                                                                    data-bs-toggle="tooltip"
                                                                    data-bs-dismiss="click"
                                                                    title="Change avatar">
                                                                    <i class="material-icons">edit</i>

                                                                    <!--begin::Inputs-->
                                                                    <input class="file-upload d-none" id="UploadMobBgImg" data-type="mobbg" type="file" name="avatar" accept=".png, .jpg, .jpeg" />
                                                                    <input type="hidden" name="avatar_remove" />
                                                                    <!--end::Inputs-->
                                                                </label>
                                                                <span class="delete-button  d-flex btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-white shadow"
                                                                    data-kt-image-input-action="remove"
                                                                    data-bs-toggle="tooltip"
                                                                    data-bs-dismiss="click"
                                                                    title="Remove avatar">
                                                                    <i class="material-icons">delete</i>
                                                                </span>
                                                                <!--end::Remove button-->
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer">
                                            <div class="dbUITemplate configRightFormFields row g-3 align-items-center mb-4">
                                                <div class="col-md-4 col-sm-12">
                                                    <label id="templateLabel" class="form-label fw-boldest text-dark fs-6 mb-0" for="templateSelect">UI Template</label>
                                                </div>
                                                <div class="col-md-8 col-sm-12">
                                                    <select id="templateSelect" runat="server" class="form-select" data-placeholder="Select Template" data-control="select2" required disabled="disabled">
                                                        <option value="default" selected="selected">Default</option>
                                                        <option value="cool">Cool</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="myModal" class="modal fade in" role="dialog">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="myModalclose">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                            <h4 class="modal-title">New Connection</h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row g-3 align-items-center mb-4">
                                                <div class="col-md-3 col-sm-12">
                                                    <asp:Label ID="lblpopname" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Name</asp:Label>
                                                </div>
                                                <div class="col-md-9 col-sm-12">
                                                    <asp:TextBox ID="txtNewConName" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                </div>
                                                <div class="col-sm-8" style="display: none;">
                                                    <asp:DropDownList ID="ddlIsNewConnection" runat="server" class="form-control">
                                                        <asp:ListItem Value="new" Selected="True">new</asp:ListItem>
                                                        <asp:ListItem Value="old">old</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <div class="d-flex flex-row-fluid">
                                                <asp:Button ID="btnok" class="btn btn-lg btn-primary mb-5 w-100 mx-3" runat="server" Text="Ok" OnClick="btnok_Click" OnClientClick="return applyconnection();" />
                                                <input type="button" class="btn btn-text-primary btn-active-light-primary btn-lg mb-5 w-100 mx-3 " title="Cancel" id="btnnewcancel" value="Cancel" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="myModaldbpassword" class="modal fade in" role="dialog">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="myModaldbpasswordclose">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                            <h4 class="modal-title">Change Password</h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="panel-body row">
                                                <div class="changePasswordBody row g-3 align-items-center mb-4">
                                                    <div class="col-md-3 col-sm-12">
                                                        <asp:Label ID="Label2" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">New Password</asp:Label>
                                                    </div>
                                                    <div class="col-md-9 col-sm-12">
                                                        <asp:TextBox ID="txtNewPassword" type="password" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="clearfix"></div>
                                                <div class="changePasswordBody row g-3 align-items-center mb-4">
                                                    <div class="col-md-3 col-sm-12">
                                                        <asp:Label ID="Label4" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Confirm Password</asp:Label>
                                                    </div>
                                                    <div class="col-md-9 col-sm-12">
                                                        <asp:TextBox ID="txtConfirmPassword" type="password" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <div class="d-flex flex-row-fluid">
                                                <asp:Button ID="btndbpwd" runat="server" class="btn btn-lg btn-primary mb-5 w-100 mx-3" Text="Apply" OnClick="btndbpwb_Click" OnClientClick="return applydbpwdconnection();" />
                                                <input type="button" title="Cancel" class="btn btn-text-primary btn-active-light-primary btn-lg mb-5 w-100 mx-3" id="btndbpwdcancel" value="Cancel" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="myModalLicUpload" class="modal fade in" role="dialog">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeUploadDialog();">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                            <h4 class="modal-title">Upload License File</h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="panel-body licFileUpload">
                                                <div class="licFileUploadDesc">
                                                    <asp:Label ID="lblslctfilename" runat="server">Please select a lic file and then click 'Upload' button.</asp:Label>
                                                </div>
                                                <div class="clearfix"></div>
                                                <div class="file-upload">
                                                    <div tabindex="0" class="file-select">
                                                        <div class="file-select-button" id="fileName">
                                                            <asp:Label ID="lblfilename" meta:resourcekey="lblfilename" runat="server">Choose File</asp:Label>
                                                        </div>
                                                        <div class="file-select-name" id="noFile">
                                                            <asp:Label ID="lblnofilename" meta:resourcekey="lblnofilename" runat="server">No file chosen...</asp:Label>
                                                        </div>
                                                        <input runat="server" type="file" tabindex="-1" name="filMyFile" id="filMyFile" accept=".lic" />
                                                    </div>
                                                </div>
                                                <div class="clearfix"></div>
                                                <div class="licFileUploadStatus">
                                                    <asp:Label ID="lblfuerror" runat="server"></asp:Label>
                                                </div>
                                                <div class="clearfix"></div>
                                                <div class="licFileUploadFooterButton">
                                                    <asp:Button ID="btnFileUpload" runat="server" Text="Upload" disabled="disabled" OnClick="btnFileUpload_Click" />
                                                    <input name="close" type="button" id="close" value="Close" title="Close" onclick="closeUploadDialog();" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="myModalRedis" class="modal fade in" role="dialog">
                                <div class="modal-dialog ">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title">New Connection</h4>
                                            <button type="button" class="close btn btn-close btn-icon btn-white" data-dismiss="modal" aria-label="Close" id="myModalRedisclose">
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row g-3 align-items-center mb-4">
                                                <div class="col-md-4 col-sm-12">
                                                    <asp:Label ID="lblRNewConnName" class="form-label fw-boldest text-dark fs-6 mb-0" runat="server">Connection Name</asp:Label>
                                                </div>
                                                <div class="col-md-8 col-sm-12">
                                                    <asp:TextBox ID="txtRedisNewConn" runat="server" autocomplete="off" class="form-control"></asp:TextBox>
                                                </div>
                                                <div class="col-sm-8" style="display: none;">
                                                    <asp:DropDownList ID="ddlIsRedisNewConnection" runat="server" class="form-control">
                                                        <asp:ListItem Value="new" Selected="True">new</asp:ListItem>
                                                        <asp:ListItem Value="old">old</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <div class="d-flex flex-row-fluid">
                                                <asp:Button ID="btnRedisOk" class="btn btn-lg btn-primary mb-5 w-100 mx-3" runat="server" Text="Ok" OnClick="btnRedisOk_Click" OnClientClick="return CreateRedisConnection();" />
                                                <input type="button" class="btn btn-text-primary btn-active-light-primary btn-lg mb-5 w-100 mx-3 " title="Cancel" id="btnrnewcancel" value="Cancel" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </asp:Panel>

                    <asp:Panel ID="PanelAuthenticate" runat="server" Visible="false">
                        <div class="">
                            <div class="">
                                <div id="" class="">
                                    <div class="d-flex">
                                        <div class="card w-lg-500px w-100 p-8 p-lg-12 m-auto shadow">
                                            <div class="">
                                                <div class="text-center mb-8"><span class="form-label fs-1 fw-boldest text-dark">Axpert Configuration Credentials</span></div>
                                            </div>
                                            <div class="">
                                                <div class="">
                                                    <div class="fv-row mb-8 fv-plugins-icon-container">
                                                        <div class="input-icon left">
                                                            <asp:Label ID="Label11" class="form-label fs-6 fw-boldest text-dark" runat="server">
                            User Name</asp:Label>
                                                            <input class="m-wrap my-2 placeholder-no-fix form-control form-control-solid" id="txtAuthUsername" runat="server" type="text"
                                                                autocomplete="off" placeholder="" name="uname" title="Username" required>
                                                        </div>
                                                    </div>
                                                    <div class="fv-row mb-8 fv-plugins-icon-container">
                                                        <div class="input-icon left">
                                                            <asp:Label ID="Label12" class="form-label fs-6 fw-boldest text-dark" runat="server">
                            Password</asp:Label>
                                                            <input class="m-wrap my-2 placeholder-no-fix form-control form-control-solid" id="txtAuthPwd" runat="server" type="password"
                                                                autocomplete="off" placeholder="" name="uname" title="Password" required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-row flex-column-fluid">
                                                <div class="d-flex flex-row-fluid">
                                                    <input type="button" id="btnAuthenticate" class="btn btn-lg btn-primary mb-5 w-100" onclick="AuthenticateUser();" value="Authenticate" />
                                                </div>
                                                <div class="Backlink d-flex flex-row-fluid ms-5">
                                                    <input type="button" title="Cancel" class="btn btn-text-primary btn-active-light-primary btn-lg mb-5 w-100" id="btnAuthCancel" value="Cancel" />
                                                </div>
                                            </div>
                                            <input type="hidden" runat="server" name="hdnAxProjs" id="hdnAxProjs" />
                                            <input type="hidden" runat="server" name="hdnselecproj" id="hdnselecproj" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </asp:Panel>
                </form>
            </div>
        </div>
    </div>
    <script src="../Js/jquery.browser.min.js" type="text/javascript"></script>
    <asp:PlaceHolder runat="server">
        <%:Scripts.Render("~/UI/axpertUI/bundleJs") %>
    </asp:PlaceHolder>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script src="../Js/xmlToJson.min.js?v=2"></script>
    <script src="../Js/config.min.js?v=7" type="text/javascript"></script>
    <script src="../Js/lang/content-<%=langType%>.js?v=59" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
</body>
</html>
