<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ImportNew.aspx.cs" Inherits="aspx_ImportNew"
    EnableEventValidation="false" %>

    <!DOCTYPE html>
    <html>

    <head runat="server">
        <meta charset="utf-8" />
        <meta name="description" content="Import" />
        <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
        <meta name="author" content="Agile Labs" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />



        <title>Import Data</title>
        <asp:PlaceHolder runat="server">
            <%:Styles.Render(direction=="ltr" ? "~/UI/axpertUI/ltrBundleCss" : "~/UI/axpertUI/rtlBundleCss" ) %>
        </asp:PlaceHolder>
        <%-- <link href="../Css/bootstrap-select.min.css" rel="stylesheet" />--%>
        <%--<link href="../Css/thirdparty/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet" />--%>
        <%--<link href="../Css/animate.min.css" rel="stylesheet" />
        <link href="../Css/import.min.css?v=31" rel="stylesheet" />--%>
        <%--<link href="..//UI/axpertUI/style.bundle.css" rel="stylesheet" type="text/css" />
        <link href="../assets/css/style.bundle.css" rel="stylesheet" type="text/css" />--%>
        <%-- <link rel="stylesheet" href="../Css/wizardComp.min.css?v=19">--%>
            <%--<link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />--%>
            <%-- <link href="../Css/Icons/icon.css" rel="stylesheet" />--%>
            <%-- <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
            <link href="../ThirdParty/Linearicons/Font/library/linearIcons.css" rel="stylesheet" />--%>
            <%--<link href="../App_Themes/Gray/Stylesheet.min.css?v=23" rel="stylesheet" />--%>
            <%--<link id="themecss" type="text/css" href="" rel="stylesheet" />--%>
            <%--<link href="../Css/globalStyles.min.css?v=36" rel="stylesheet" />--%>
            <script>
                if (typeof localStorage != "undefined") {
                    var projUrl = top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
                    var lsTimeStamp = localStorage["customGlobalStylesExist-" + projUrl]
                    if (lsTimeStamp && lsTimeStamp != "false") {
                        var appProjName = localStorage["projInfo-" + projUrl] || "";
                        var customGS = "<link id=\"customGlobalStyles\" data-proj=\"" + appProjName + "\" href=\"../" + appProjName + "/customGlobalStyles.css?v=" + lsTimeStamp + "\" rel=\"stylesheet\" />";
                        document.write(customGS);
                    }
                }
            </script>
            <%--<link href="../Css/import.min.css?v=32" rel="stylesheet" />--%>
            <script>
                if (!('from' in Array)) {
                    // IE 11: Load Browser Polyfill
                    document.write('<script src="../Js/polyfill.min.js"><\/script>');
                }
            </script>
    </head>

    <body dir='<%=direction%>' class="btextDir-<%=direction%> iframeScrollFix content p-0 fs-6  page-loading">
        <form id="form1" runat="server">
             <asp:PlaceHolder runat="server">
                <%:Scripts.Render("~/UI/axpertUI/bundleJs") %>
            </asp:PlaceHolder>
            <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="600">
                <Services>
                    <asp:ServiceReference Path="../WebService.asmx" />
                </Services>
            </asp:ScriptManager>
            <div class="stepper stepper-pills card bg-transparent border-0 h-100 first"
                id="kt_stepper_example_clickable" data-kt-stepper="true">
                <!--begin::Nav-->
                <div class="card-header d-block px-0 py-5 bg-transparent border-0 mx-20">
                    <div class="stepper-nav bg-white rounded-2 flex-center flex-wrap">
                        <!--begin::Step 1-->
                        <div class="stepper-item mx-2 my-4 current" data-kt-stepper-element="nav"
                            data-kt-stepper-action="step">
                            <!--begin::Line-->
                            <div class="stepper-line w-40px"></div>
                            <!--end::Line-->

                            <!--begin::Icon-->
                            <div class="stepper-icon w-40px h-40px">
                                <span
                                    class="stepper-check material-icons material-icons-style material-icons-2">done</span>
                                <span class="stepper-number">1</span>
                            </div>
                            <!--end::Icon-->

                            <!--begin::Label-->
                            <div class="stepper-label">
                                <h3 class="stepper-title">Data Search
                                </h3>

                                <div class="stepper-desc">
                                    <%--Description--%>
                                </div>
                            </div>
                            <!--end::Label-->
                        </div>
                        <!--end::Step 1-->

                        <!--begin::Step 2-->
                        <div class="stepper-item mx-2 my-4 pending" data-kt-stepper-element="nav"
                            data-kt-stepper-action="step">
                            <!--begin::Line-->
                            <div class="stepper-line w-40px"></div>
                            <!--end::Line-->

                            <!--begin::Icon-->
                            <div class="stepper-icon w-40px h-40px">
                                <span
                                    class="stepper-check material-icons material-icons-style material-icons-2">done</span>
                                <span class="stepper-number">2</span>
                            </div>
                            <!--begin::Icon-->

                            <!--begin::Label-->
                            <div class="stepper-label">
                                <h3 class="stepper-title">Upload
                                </h3>

                                <div class="stepper-desc">
                                    <%--Description--%>
                                </div>
                            </div>
                            <!--end::Label-->
                        </div>
                        <!--end::Step 2-->

                        <!--begin::Step 3-->
                        <div class="stepper-item mx-2 my-4 pending" data-kt-stepper-element="nav"
                            data-kt-stepper-action="step">
                            <!--begin::Line-->
                            <div class="stepper-line w-40px"></div>
                            <!--end::Line-->

                            <!--begin::Icon-->
                            <div class="stepper-icon w-40px h-40px">
                                <span
                                    class="stepper-check material-icons material-icons-style material-icons-2">done</span>
                                <span class="stepper-number">3</span>
                            </div>
                            <!--begin::Icon-->

                            <!--begin::Label-->
                            <div class="stepper-label">
                                <h3 class="stepper-title">Edit
                                </h3>

                                <div class="stepper-desc">
                                    <%--Description--%>
                                </div>
                            </div>
                            <!--end::Label-->
                        </div>
                        <!--end::Step 3-->

                        <!--begin::Step 4-->
                        <div class="stepper-item mx-2 my-4 pending" data-kt-stepper-element="nav"
                            data-kt-stepper-action="step">
                            <!--begin::Line-->
                            <div class="stepper-line w-40px"></div>
                            <!--end::Line-->

                            <!--begin::Icon-->
                            <div class="stepper-icon w-40px h-40px">
                                <span
                                    class="stepper-check material-icons material-icons-style material-icons-2">done</span>
                                <span class="stepper-number">4</span>
                            </div>
                            <!--begin::Icon-->

                            <!--begin::Label-->
                            <div class="stepper-label">
                                <h3 class="stepper-title">Summary
                                </h3>

                                <div class="stepper-desc">
                                    <%--Description--%>
                                </div>
                            </div>
                            <!--end::Label-->
                        </div>
                        <!--end::Step 4-->
                    </div>
                </div>
                <div class="card card-body h-400px mx-20 overflow-auto">
                    <div class="form w-lg-700px mx-auto" novalidate="novalidate" id="kt_stepper_example_basic_form">
                        <!--begin::Group-->
                        <div class="mb-5">
                            
                            <div class="flex-column current" data-kt-stepper-element="content">
                                <%--Step 1--%>
                                    <div id="wizardBodyContent">
                                        <!-- Widget Data Search - begins -->
                                        <div class="wizardContainer wizardValidation animated fadeIn"
                                            id="imWizardDataSearch">
                                            <section class="form-group col-md-12 mb-4">
                                                <asp:Label runat="server" AssociatedControlID="ddlImpTbl"
                                                    class="selectalign form-label col-form-label pb-1 fw-boldest required">
                                                    <asp:Label ID="lblImptbl" runat="server"
                                                        meta:resourcekey="lblImptbl" Text="Select Form"></asp:Label>
                                                    <span class="allowempty d-none">*</span>
                                                </asp:Label>
                                                <i tabindex="0" data-trigger="focus" class="icon-arrows-question"
                                                    data-toggle="popover" id="icocl1"
                                                    data-content="Select a TStruct from which the data needs to be imported."
                                                    data-placement="right"></i>
                                                <asp:DropDownList runat="server" ID="ddlImpTbl"
                                                    CssClass="form-select forValidation selectpicker"
                                                    data-live-search="true" data-size="6" AutoPostBack="true"
                                                    placeholder="Select Form"
                                                    OnSelectedIndexChanged="ddlImpTbl_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </section>
                                            <section class="form-group col-md-12">
                                                <label class="selectalignn my-4 required" for="txtExFields"
                                                    onclick="$('.ms-selectable ul.ms-list').focus();">
                                                    <asp:Label ID="lbltxtim" CssClass="form-label col-form-label pb-1 fw-boldest"
                                                        runat="server" meta:resourcekey="lbltxtim" Text="Fields">
                                                    </asp:Label><span class="allowempty d-none">*</span>
                                                </label>
                                                <i tabindex="0" data-trigger="focus" class="icon-arrows-question"
                                                    data-toggle="popover" id="icocl2"
                                                    data-content="Select the field(s) to be included in the import template."
                                                    data-placement="right"></i>
                                                <table class="table table-borderless w-100">
                                                    <tr class="d-flex flex-row-auto flex-center">
                                                        <td class="d-block d-sm-table-cell col-12 col-sm-5 p-0">
                                                            <select id="mSelectLeft" name="from[]"
                                                                class="multiselect form-control scroll-x" size="8"
                                                                multiple="multiple" data-right="#mSelectRight"
                                                                data-right-all="#right_All_1"
                                                                data-right-selected="#right_Selected_1"
                                                                data-left-all="#left_All_1"
                                                                data-left-selected="#left_Selected_1">
                                                                <asp:Repeater ID="rptSelectFields" runat="server">
                                                                    <ItemTemplate>
                                                                        <option
                                                                            value='<%# Container.DataItem.ToString().Substring(0,Container.DataItem.ToString().IndexOf("&&")) %>'>
                                                                            <%#
                                                                                Container.DataItem.ToString().Substring(Container.DataItem.ToString().IndexOf("&&")+2)%>
                                                                        </option>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </select>
                                                        </td>
                                                        <td class="d-block d-sm-table-cell col-12 col-sm-2 py-0">
                                                            <%--button icons are updating based on the lang selection
                                                                <,>, <<,>>--%>
                                                                    <div class="text-center py-1"><a
                                                                            href="javascript:void(0);" id="right_All_1"
                                                                            title="Select All"
                                                                            class="btn btn-sm btn-icon btn-active-primary shadow-sm"><span
                                                                                class="material-icons material-icons-style">keyboard_double_arrow_right</span></a>
                                                                    </div>
                                                                    <div class="text-center py-1"><a
                                                                            href="javascript:void(0);"
                                                                            id="right_Selected_1" title="Select"
                                                                            class="btn btn-sm btn-icon btn-active-primary shadow-sm"><span
                                                                                class="material-icons material-icons-style">keyboard_arrow_right</span></a>
                                                                    </div>
                                                                    <div class="text-center py-1"><a
                                                                            href="javascript:void(0);"
                                                                            id="left_Selected_1" title="Unselect"
                                                                            class="btn btn-sm btn-icon btn-active-primary shadow-sm"><span
                                                                                class="material-icons material-icons-style">keyboard_arrow_left</span></a>
                                                                    </div>
                                                                    <div class="text-center py-1"><a
                                                                            href="javascript:void(0);" id="left_All_1"
                                                                            title="Unselect All"
                                                                            class="btn btn-sm btn-icon btn-active-primary shadow-sm"><span
                                                                                class="material-icons material-icons-style">keyboard_double_arrow_left</span></a>
                                                                    </div>
                                                        </td>
                                                        <td class="d-block d-sm-table-cell col-12 col-sm-5 p-0">
                                                            <select name="to[]" id="mSelectRight"
                                                                class="multiselect form-control scroll-x" size="8"
                                                                multiple="multiple"></select>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </section>

                                            <asp:UpdatePanel runat="server" ID="plnUpdate1">
                                                <ContentTemplate>
                                                    <asp:Button Text="text" class="btn btn-primary btn-icon d-none"
                                                        runat="server" ID="btnCreateTemplate"
                                                        OnClick="btnCreateTemplate_Click" />
                                                    <asp:Button Text="text" class="btn btn-primary btn-icon d-none"
                                                        runat="server" ID="ColHeaderClick"
                                                        OnClick="btnColHeader_Click" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                            <asp:HiddenField ID="hdnMandatoryColCount" runat="server" Value="0" />
                                            <asp:HiddenField ID="hdnMandatoryFields" runat="server" Value="" />
                                            <asp:HiddenField ID="hdnSelectedColumnCount" runat="server" Value="0" />
                                            <asp:HiddenField ID="hdnColValues" runat="server" Value="" />
                                            <asp:HiddenField ID="hdnColNames" runat="server" Value="" />
                                        </div>
                                    </div>
                            </div>
                            

                            <div class="flex-column" data-kt-stepper-element="content">
                                <%--Step 2--%>
                                    <div class="wizardContainer animated fadeIn" id="imWizardUpload">
                                        <span class="customMessage fileUploadErrorMessage"></span>
                                        <section class="col-md-12  upload-section  d-flex justify-content-center py-4">
                                            <div class="btn btn-icon btn-active-light-primary w-30px h-30px w-md-40px h-md-40px position-relative"
                                                data-kt-menu-trigger="click" data-kt-menu-attach="parent"
                                                data-kt-menu-placement="bottom" data-kt-menu-flip="top-end">
                                                <button class="btn btn-primary dropdown-toggle" id="lnkExpTemp"
                                                    type="button" data-toggle="dropdown" aria-expanded="true">
                                                    Download Data Template
                                                    <span class="caret"></span>
                                                </button>
                                                  <span tabindex="0" 
                                                            class="material-icons material-icons-style material-icons-2 align-middle ms-2" data-bs-toggle="tooltip"
                                                            id="datetip"
                                                            data-bs-original-title="Date should be in DD/MM/YYYY or MM/DD/YYYY format"
                                                            data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>
                                            </div>
                                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-primary fw-bold py-4 fs-6 w-200px" data-kt-menu="true">                                               
                                                    <div id="exceldiv" class="menu-item px-3"><a href="#"
                                                            id="excel1" class="menu-link">Excel</a></div>
                                                    <div id="csvdiv" class="menu-item px-3"><a href="#"
                                                            id="CSV1" class="menu-link">CSV</a></div>
                                            </div>


                                            <%--<div class="dropdown open  d-flex justify-content-center"
                                                id="dropdowncss">

                                                <a id="lnkExpTemp" class="hotbtn btn" title="Download Data Template"
                                                    style="
                     display: none;">
                                                    <span id="ico"
                                                        class=" glyphicon glyphicon-download-alt icon-basic-download"></span><span
                                                        id="lbldwnldtmp">Download Data Template</span>
                                                </a>
                                                <ul class="dropdown-menu" id="dopdownmenucss">
                                                    <li><a href="#" id="excel1">Excel</a></li>
                                                    <li><a href="#" id="CSV1">CSV</a></li>
                                                    <li><a href="#">JavaScript</a></li>
                                                        </ul>

                                    </div>--%>
                                    <i tabindex="0" data-trigger="focus" class="icon-arrows-question"
                                        data-toggle="popover" id="icocl3"
                                        data-content="Template should be available in .CSV format"
                                        data-placement="right"></i>
                                    <br />
                                    <asp:Label ID="lblTemplateNtAvalble" runat="server" Text="" class="lblleft"
                                        ForeColor="#cf4444" Visible="false"></asp:Label>
                                    </section>
                                    <section class="col-md-12  d-flex justify-content-center">
                                        <asp:UpdatePanel ID="updatePnl2" class="w-100" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <div class="my-4">
                                                    <span class="file-upload ">
                                                        <div class="form-group form-control">
                                                            <div id="dropzone_AxpFileImport"
                                                                class="dropzone dropzone-queue min-h-1px border-0 px-3 py-3">
                                                                <div
                                                                    class="d-flex flex-row-auto flex-center dropzone-panel mb-lg-0 m-0">
                                                                    <a class="dropzone-select fs-7"><span
                                                                            class="material-icons material-icons-style material-icons-2 float-start mx-2">upload_file</span>
                                                                        Drop files here or click to upload</a><span
                                                                        class="material-icons material-icons-style material-icons-2 float-end ms-4 fileuploadmore d-none"
                                                                        data-bs-toggle="popover"
                                                                        data-bs-sanitize="false"
                                                                        data-bs-placement="bottom"
                                                                        data-bs-html="true">more</span><a
                                                                        class="dropzone-remove-all btn btn-sm btn-light-primary d-none">Remove
                                                                        All</a>
                                                                </div>
                                                                <div class="dropzone-items wm-200px d-none">
                                                                    <div class="dropzone-item" style="display: none">
                                                                        <div class="dropzone-file">
                                                                            <div class="dropzone-filename"
                                                                                title="some_image_file_name.jpg"><span
                                                                                    data-dz-name>some_image_file_name.jpg</span>
                                                                            </div>
                                                                            <div class="dropzone-error"
                                                                                data-dz-errormessage></div>
                                                                        </div>
                                                                        <div class="dropzone-progress d-none">
                                                                            <div class="progress">
                                                                                <div class="progress-bar bg-primary"
                                                                                    role="progressbar" aria-valuemin="0"
                                                                                    aria-valuemax="100"
                                                                                    aria-valuenow="0"
                                                                                    data-dz-uploadprogress></div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="dropzone-toolbar"><span
                                                                                class="dropzone-delete"
                                                                                data-dz-remove><span
                                                                                    class="material-icons material-icons-style material-icons-2 float-end dropzoneItemDelete">clear</span></span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:Label ID="fileuploadsts" Text="" runat="server"
                                                            ForeColor="#DB2222"></asp:Label>
                                                        <input type="button" name="name" value="Upload"
                                                            class=" btn d-none" id="btnFileUpload" />
                                                        <asp:Button runat="server" ID="UploadButton"
                                                            class="btn  btn-primary d-none" Text="Upload"
                                                            OnClick="UploadButton_Click" />
                                                        <%--<span class="file-select" tabindex="0" id="spnFileSelect">
                                                            <span class="file-select-button" id="fileName">
                                                                <asp:Label ID="lblfilename" runat="server"
                                                                    meta:resourcekey="lblfilename">Choose File
                                                                </asp:Label>
                                                            </span>
                                                            <span class="file-select-name" id="noFile">
                                                                <asp:Label ID="lblnofile" runat="server"
                                                                    meta:resourcekey="lblnofile">No file chosen...
                                                                </asp:Label>
                                                            </span>
                                                            <asp:FileUpload runat="server" ID="fileToUpload"
                                                                TabIndex="-1" />
                                                    </span>
                                                    </span>
                                                    <asp:Label ID="fileuploadsts" Text="" runat="server"
                                                        ForeColor="#DB2222"></asp:Label>
                                                    <input type="button" name="name" value="Upload" class="hotbtn btn"
                                                        id="btnFileUpload" />
                                                    <asp:Button runat="server" ID="UploadButton" class="hotbtn btn"
                                                        Text="Upload" OnClick="UploadButton_Click" />--%>
                                                </div>
                                                <div id="axstaysignin"
                                                    class=" agform form-check form-switch form-check-custom form-check-solid px-1 align-self-end mb-4">
                                                    <div class="controls">
                                                        <div
                                                            class="input-icon left d-flex justify-content-center customclscol">
                                                            <input name="signedin" type="checkbox" id="ChkColNameInfile"
                                                                class="m-wrap placeholder-no-fix form-check-input h-25px w-40px my-2"
                                                                title="Keep me sign in?"
                                                                onchange="ColNameInfileChanged()" checked="checked"
                                                                meta:resourcekey="lblFileHeaders" runat="server">
                                                            <span id="lblstaysin"
                                                                class="form-check-label form-label col-form-label pb-1 fw-boldest text-dark fs-6 mb-0"
                                                                for="ChkColNameInfile" runat="server">File contains
                                                                Headers</span>
                                                             <span tabindex="0" 
                                                            class="material-icons material-icons-style material-icons-2 align-middle ms-2 my-3" data-bs-toggle="tooltip"
                                                            id="headertip"
                                                            data-bs-original-title="Enable this after uploading the file only."
                                                            data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>
                                                           <%-- <span tabindex="0" class="material-icons material-icons-style material-icons-2 align-middle ms-2 initialized my-3" data-bs-toggle="tooltip" id="headertip" data-bs-original-title="Enable this after uploading the file only" data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>--%>
                                                        </div>
                                                    </div>
                                                </div>
                                                <%--<div class="d-flex justify-content-center customclscol">
                                                    <asp:Label runat="server"
                                                        class="form-check-label form-label col-form-label pb-1 fw-boldest text-dark fs-6 mb-0"
                                                        AssociatedControlID="ChkColNameInfile">
                                                        <asp:CheckBox runat="server" ID="ChkColNameInfile"
                                                            class="m-wrap placeholder-no-fix form-check-input h-25px w-40px"
                                                            onchange="ColNameInfileChanged()" Checked="true"
                                                            meta:resourcekey="lblFileHeaders" />
                                                    </asp:Label>
                            </div>--%>
                            </ContentTemplate>
                            </asp:UpdatePanel>
                            </section>
                            <section class="col-xs-12">
                                <div class="col-xs-12 customclscol">
                                    <div class="form-group upload-progress">
                                        <div id="divProgress" class="progress d-none">
                                            <div id="divProgressBar" class="progress-bar progress-bar-striped active"
                                                role="progressbar" aria-valuemin="0" aria-valuemax="100">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <div class="form-group col-md-12 row g-3 align-items-center my-2">
                                <div class="col-sm-6">
                                    <asp:Label class="form-label fw-boldest text-dark fs-6 mb-2" runat="server" ID="lblseparator"
                                        meta:resourcekey="lblseparator" AssociatedControlID="ddlSeparator">
                                    </asp:Label>
                                    <i tabindex="0" data-trigger="focus" class="icon-arrows-question helptxt"
                                        data-toggle="popover" id="icocl6"
                                        data-content="Select character used for separating columns in the data file."
                                        data-placement="right"></i>
                                    <asp:DropDownList ID="ddlSeparator" CssClass="form-select" runat="server">
                                        <asp:ListItem Value="," Selected="True">Comma [ , ]</asp:ListItem>
                                        <asp:ListItem Value=";">Semicolon [ ; ]</asp:ListItem>
                                        <asp:ListItem Value="|">Pipe [ | ]</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-sm-6 customclscol">
                                    <asp:Label runat="server" class="form-label fw-boldest text-dark fs-6 mb-2" ID="lblimgroupby"
                                        meta:resourcekey="lblimgroupby" AssociatedControlID="ddlGroupBy">
                                    </asp:Label>
                                    <i tabindex="0" data-trigger="focus" class="icon-arrows-question helptxt"
                                        data-toggle="popover" id="icocl7"
                                        data-content="Form contains data grid, please select column with unique values."
                                        data-placement="right" data-original-title="" title=""></i>
                                    <asp:DropDownList ID="ddlGroupBy" CssClass="form-select" runat="server"
                                        placeholder="Please select GroupBy Condition">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                    </div>
                   
                    <div class="flex-column" data-kt-stepper-element="content">
                        <%--Step 3--%>

                            <div class="wizardContainer animated fadeIn" id="imWizardEdit">
                                <div class="d-flex justify-content-between mb-5">
                                    <%--<table>
                                        <tr>
                                            <td>--%>
                                                <div id="axstaysignin1"
                                                    class=" agform form-check form-switch form-check-custom form-check-solid">
                                                    <div class="controls">
                                                        <input type="checkbox" id="chkForIgnoreErr" runat="server"
                                                            class="m-wrap placeholder-no-fix form-check-input h-25px w-40px align-middle"
                                                            checked="checked" />
                                                        <asp:Label ID="lblForIgnoreErr"
                                                            class="form-check-label form-label col-form-label pb-1 fw-boldest text-dark fs-6"
                                                            AssociatedControlID="chkForIgnoreErr"
                                                            meta:resourcekey="lblForIgnoreErr" runat="server"> Ignore
                                                            errors</asp:Label>
                                                        <span tabindex="0" 
                                                            class="material-icons material-icons-style material-icons-2 align-middle ms-2" data-bs-toggle="tooltip"
                                                            id="icocl4"
                                                            data-bs-original-title="Check this to ignore errors in the rows during file upload."
                                                            data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>
                                                    </div>
                                                </div>
                                            <%--</td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td>--%>
                                                <div id="axstaysignin2"
                                                    class=" agform form-check form-switch form-check-custom form-check-solid">
                                                    <div class="controls">
                                                        <input type="checkbox" id="chkForAllowUpdate" runat="server"
                                                            class="m-wrap placeholder-no-fix form-check-input h-25px w-40px align-middle"
                                                            onclick="javascript: ChkAllowUpdate();" />
                                                        <asp:Label ID="lblAllowUpdate"
                                                            AssociatedControlID="chkForAllowUpdate" runat="server" CssClass="form-check-label form-label col-form-label pb-1 fw-boldest text-dark fs-6">Allow Update
                                                            <%--<asp:Label ID="lblAllowUpdte"
                                                                class="form-check-label form-label col-form-label pb-1 fw-boldest text-dark fs-6"
                                                                runat="server" meta:resourcekey="lblAllowUpdte">Allow
                                                                Update</asp:Label>--%>
                                                        </asp:Label>
                                                        <span tabindex="0" 
                                                            class="material-icons material-icons-style material-icons-2 align-middle ms-2" data-bs-toggle="tooltip"
                                                            id="icocl5"
                                                            data-bs-original-title="If allow update is checked,the rows will be updated using the primary key."
                                                            data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>
                                                    </div>
                                                </div>
                                          <%--  </td>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td>--%>
                                    <div class ="d-flex justify-content-between my-1">
                                                            <asp:Label ID="lblprimarycolmn" runat="server"
                                                                meta:resourcekey="lblprimarycolmn" CssClass="form-label col-form-label pb-1 fw-boldest d-none">Primary Column
                                                            </asp:Label>
                                                      <%--  </td>
                                                        <td>--%>
                                                            <asp:DropDownList runat="server" ID="ddlPrimaryKey" CssClass="form-select form-select-sm w-100px">
                                                            </asp:DropDownList>
                                        <span tabindex="0" class="material-icons material-icons-style material-icons-2 align-middle my-2 me-n7 ms-3" data-bs-toggle="tooltip" data-bs-original-title="Please select a Primary key column to allow update." data-bs-placement="bottom" data-bs-dismiss="click">help_outline</span>
                                                            <asp:HiddenField ID="hdnPrimaryKey" runat="server"
                                                                Value="" />
                                        </div>
                                                        <%--</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>--%>

                                </div>
                                <section class="">
                                    <%--<asp:Button ID="RefreshGridButton" runat="server" OnClick="GridRefresh" >d-flex flex-center
                                        CssClass="hide" />--%>
                                    <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                                    <asp:UpdatePanel runat="server">
                                        <ContentTemplate>
                                            <div class="importrecord">
                                                <asp:Label ID="lblrecords" CssClass ="form-label col-form-label pb-1 fw-boldest text-dark fs-6 mb-0" runat="server" meta:resourcekey="lblrecords">
                                                    Top 5 records</asp:Label>
                                            </div>
                                            <hr class="text-gray-500" />
                                            <div class="importrecordtable">
                                                <asp:GridView CellSpacing="-1" ID="gridImpData" runat="server"
                                                    Visible="true" OnRowDataBound="gridImpData_RowDataBound" CssClass="table w-100"
                                                    BorderStyle="None"></asp:GridView>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </section>
                                <section class="col-sm-12">
                                    <asp:HiddenField ID="hdnIgnoredColumns" runat="server" Value="" />
                                    <asp:HiddenField ID="colheader" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnCOLheaders" runat="server" Value="" />
                                </section>
                            </div>
                    </div>
                    
                    <div class="flex-column" data-kt-stepper-element="content">
                        <%--Step 4--%>

                            <div class="wizardContainer animated fadeIn d-flex justify-content-center"
                                id="imWizardSummary">
                                <asp:Label runat="server" ID="lblPleaseWait" Visible="false"></asp:Label>
                                <asp:UpdatePanel ID="updatePln3" runat="server">
                                    <ContentTemplate>
                                        <textarea name="text" id="summaryText" runat="server" rows="11"
                                            class="resize:none d-none" cols="70"></textarea>
                                        <div class="form-group col-md-12">
                                            <h3>
                                                <asp:Label ID="lblimportsum" runat="server"
                                                    meta:resourcekey="lblimportsum">Import Summary</asp:Label>
                                            </h3>
                                            <asp:Label runat="server" ID="lblTest"></asp:Label>
                                            <br />
                                            <a id="SummaryDwnld" runat="server" class="btn btn-primary" tabindex="0"
                                                visible="false" title="Download Summary"><span
                                                    class=" glyphicon glyphicon-download-alt icon-basic-download"></span>
                                                <asp:Label ID="lbldwnldsum" runat="server"
                                                    meta:resourcekey="lbldwnldsum">Download Summary</asp:Label>
                                            </a>
                                        </div>
                                        <asp:HiddenField ID="hdnIgnoredColCount" runat="server" Value="0" />
                                        <asp:HiddenField ID="uploadFileName" runat="server" Value="" />
                                        <asp:HiddenField ID="uploadIviewName" runat="server" Value="" />
                                        <asp:HiddenField ID="upFileName" runat="server" Value="" />
                                        <asp:HiddenField ID="IsFileUploaded" runat="server" Value="" />
                                        <asp:HiddenField ID="fileUploadComplete" runat="server" Value="0" />
                                        <asp:HiddenField ID="hdnTemplateName" runat="server" Value="" />
                                        <asp:HiddenField ID="hdnUploadFileWarnings" runat="server" Value="" />
                                        <asp:HiddenField ID="hdnGroupBy" runat="server" Value="NA" />
                                        <asp:HiddenField ID="hdnGroupByColName" runat="server" Value="" />
                                        <asp:HiddenField ID="hdnGroupByColVal" runat="server" Value="" />
                                        <asp:HiddenField ID="hdnCheckHeader" runat="server" Value="" />
                                        <asp:Button ID="btnImport" runat="server" Text="Import"
                                            OnClick="btnImport_Click" CssClass="cloudButton btn btn-primary d-none"  OnClientClick="callParentNew('loadFrame();','function');"/>
                                        <br />
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnImport" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                    </div>
                    
                </div>
                <!--end::Group-->


                </div>
            </div>
          
                                <div class="card-footer ">
                                    <%--bg-transparent border-0 px-0 py-2--%>
                                        <!--begin::Actions-->
                                        <div class="d-flex d-flex justify-content-end mx-2">
                                            <!--begin::Wrapper-->
                                            <div class="me-2">
                                                <button type="button"
                                                    class="btn btn-white btn-color-gray-700 btn-active-primary shadow-sm"
                                                    data-kt-stepper-action="previous">
                                                    Back
                                                </button>
                                            </div>
                                            <!--end::Wrapper-->

                                            <!--begin::Wrapper-->
                                            <div>
                                                <button type="button" class="btn btn-primary shadow-sm"
                                                    data-kt-stepper-action="submit">
                                                    <span class="indicator-label">Submit
                                                    </span>
                                                    <span class="indicator-progress">Please wait... <span
                                                            class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                                    </span>
                                                </button>

                                                <button type="button" class="btn btn-primary shadow-sm"
                                                    data-kt-stepper-action="next">
                                                    Continue
                                                </button>
                                            </div>
                                            <!--end::Wrapper-->
                                        </div>
                                    </div>
                                        <!--end::Actions-->
                                
                                </div>
                
            
                                <div id="wizardFooter" class="wizard-footer d-none">
                                    <div class="pull-left">
                                        <button onclick="impWizardObj.checkClick(this,'prev')" type="button"
                                            title="Previous" id="wizardPrevbtn"
                                            class="btn hotbtn prev-step">Prev</button>
                                    </div>
                                    <div class="pull-right">
                                        <button id="wizardCancelbtn" onclick="closeWindow()" type="button"
                                            title="Cancel" class="coldbtn btn btn-info-full ">Cancel</button>
                                        <button onclick="impWizardObj.checkClick(this,'next')" data-validator=""
                                            title="Next" id="wizardNextbtn" type="button"
                                            class="hotbtn btn ">Next</button>
                                        <button type="button" id="wizardCompbtn" class="hotbtn btn  "
                                            title="Done">Done</button>
                                    </div>
                                </div>
                                <!-- Widget work flow - end -->
                                    <div id="waitDiv1" class="page-loader rounded-2 bg-radial-gradient">
                                        <div class="loader-box-wrapper d-flex bg-white p-20 shadow rounded">
                                            <span class="loader"></span>
                                        </div>
                                    </div>
                                <div id='waitDiv'>
                                    <div id='backgroundDiv'>
                                    </div>
                                </div>

                                <%--<script src="../UI/axpertUI/plugins.bundle.js"></script>
                                <script src="../UI/axpertUI/scripts.bundle.js"></script>--%>
                                <%--<asp:PlaceHolder runat="server">
                                    <%:Scripts.Render("~ /UI/axpertUI/bundleJs") %>
                                        </asp:PlaceHolder>--%>
                                        <%-- <script src="../Js/Jquery-2.2.2.min.js" type="text/javascript">
                                            </script>--%>
                                            <%--<script src="../AssetsNew/js/bootstrap.min.js">
                                                </script>--%>
                                                <%--<script src="../Js/wizard.min.js?v=10">
                                                    </script>--%>
                                                    <script src="../Js/helper.min.js?v=141"></script>
                                                    <script src="../Js/common.min.js?v=118"></script>
                                                    <%--<script src="../Js/wizardComp.min.js?v=10"
                                                        type="text/javascript">
                                                        </script>--%>
                                                        <script src="../Js/alerts.min.js?v=30"></script>
                                                        <script src="../Js/import.min.js?v=39"></script>
                                                        <script src="../Js/multiselect.min.js"
                                                            type="text/javascript"></script>
                                                        <script src="../Js/jquery.multi-select.min.js"
                                                            type="text/javascript"></script>


                                                        <script>
           // DropzoneInitImport();
            // Stepper lement
            //Dropzone.autoDiscover = false;
                                                        </script>

                                                        <script>
                                                            var proj = '<%=proj%>';
                                                            var sid = '<%=sid%>';

                                                            var $j = jQuery.noConflict();
                                                            var $ = jQuery.noConflict();
                                                            var AxwizardType = '<%=Session["AxWizardType"]%>';
                                                        </script>

        </form>
    </body>

    </html>