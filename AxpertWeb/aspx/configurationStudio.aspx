<%@ Page Language="C#" AutoEventWireup="true" CodeFile="configurationStudio.aspx.cs" Inherits="aspx_configurationStudio" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Widget</title>
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
    <asp:PlaceHolder runat="server">
        <%:Styles.Render(direction == "ltr" ? "~/UI/axpertUI/ltrBundleCss" : "~/UI/axpertUI/rtlBundleCss") %>
    </asp:PlaceHolder>
</head>
<body class="header-fixed header-tablet-and-mobile-fixed toolbar-enabled aside-fixed aside-default-enabled page-loading" data-kt-aside-minimize="off" dir="<%=direction%>">

    <div class="adminMain d-flex flex-column flex-root">
        <div class="adminMainInner page d-flex flex-row flex-column-fluid position-relative">
            <div class="aside aside-default aside-hoverable rounded--- mt-20 mt-lg-0" data-kt-drawer="true" data-kt-drawer-name="aside" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="{default:'200px', '300px': '250px'}" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_aside_toggle">
                <div class="adminMainLeft aside-menu flex-column-fluid">
                    <div class="adminLeftMenu menu menu-column menu-fit menu-rounded menu-title-gray-600 menu-icon-gray-400 menu-state-primary menu-state-icon-primary menu-state-bullet-primary menu-arrow-gray-500 fw-bold fs-5 my-5 mt-lg-5 mb-lg-0" data-kt-menu="true">
                        <div class="pt-lg-20 menu-fit hover-scroll-y hover-scroll-x me-lg-n5 pe-lg-5" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-height="auto" data-kt-scroll-wrappers="#kt_aside_menu" data-kt-scroll-offset="20px">

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad___acs");callParentNew("closeFrame();","function");'>
                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">assignment</i>
                                    </span>
                                    <span class="setting-caption menu-title">Custom Forms</span>

                                </a>
                            </div>

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad___cfd");callParentNew("closeFrame();","function");'>
                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">text_fields</i>
                                    </span>
                                    <span class="setting-caption menu-title">Custom Fields</span>

                                </a>
                            </div>

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad___acr");callParentNew("closeFrame();","function");'>
                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">square_foot</i>
                                    </span>
                                    <span class="setting-caption menu-title">Rules</span>

                                </a>
                            </div>

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad__act");callParentNew("closeFrame();","function");'>
                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">account_circle</i>
                                    </span>
                                    <span class="setting-caption menu-title">Actor listing</span>
                                </a>
                            </div>

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("iview.aspx?ivname=ad__p&tstcaption=Process Engine definition");callParentNew("closeFrame();","function");'>

                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">account_tree</i>
                                    </span>
                                    <span class="setting-caption menu-title">Process Definitions</span>

                                </a>
                            </div>

                            <div class="menu-item d-none">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad___acs");callParentNew("closeFrame();","function");'>

                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">toggle_on</i>
                                    </span>
                                    <span class="setting-caption menu-title">Configuration Parameters</span>
                                </a>
                            </div>

                            <div class="menu-item">
                                <a class="menu-link" onclick='callParentNew("loadFrame();","function");LoadIframeac("ivtoivload.aspx?ivname=ad__fstp");callParentNew("closeFrame();","function");'>
                                    <span class="menu-icon">
                                        <i class="setting-icon material-icons">print</i>
                                    </span>
                                    <span class="setting-caption menu-title">Fast Prints</span>
                                </a>
                            </div>

                        </div>
                    </div>
                </div>

            </div>

            <div class="wrapper d-flex flex-column flex-row-fluid w-100 h-100">
                <div id="kt_header" class="header" data-kt-sticky="true" data-kt-sticky-name="header" data-kt-sticky-offset="{default: '0px', lg: '0px'}" data-kt-sticky-animation="false">
                    <!--begin::Container-->
                    <div class="d-flex align-items-stretch justify-content-between">
                        <!--begin::Logo bar-->
                        <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0">
                            <!--begin::Aside Toggle-->
                            <div class="d-flex align-items-center d-lg-none">
                                <div class="btn btn-icon btn-active-color-primary ms-n2 me-1" id="kt_aside_toggle">

                                    <span class="material-icons material-icons-style material-icons-1">menu
                                    </span>

                                </div>
                            </div>
                            <!--end::Aside Toggle-->
                            <!--begin::Aside toggler-->

                            <div class="btn btn-icon w-auto ps-0 btn-active-color-primary d-none d-lg-inline-flex me-2 me-lg-5 active---" data-kt-toggle="true" data-kt-toggle-state="active" data-kt-toggle-target="body" data-kt-toggle-name="aside-minimize">

                                <span class="material-icons material-icons-style material-icons-2 rotate-180">menu
                                </span>

                            </div>
                            <!--end::Aside toggler-->
                            <h1 class="text-dark fw-bold m-2 fs-2">Axpert Configuration Studio</h1>
                        </div>
                        <!--end::Logo bar-->

                    </div>
                    <!--end::Container-->
                </div>
                <div class="content fs-6 d-flex flex-column flex-column-fluid px-3 pt-3 pb-2 adminRightGap">
                    <div class="btn btn-icon btn-sm position-absolute ms-n20 mt-2 fw-bolder z-index-2 transform-270 appBackBtn" onclick="prevbtn_click($(this))">
                        <span class="btn btn-flex btn-white btn-active-light-primary h-30px shadow-sm fs-6 mt-7 pt-4 pb-3 px-4 rounded-top-0" title="" data-bs-toggle="tooltip-disable" data-bs-placement="left" data-bs-dismiss="click" data-bs-trigger="hover" data-bs-html="true" data-bs-sanitize="false" data-bs-original-title='<button type="button" class="btn btn-icon btn-sm btn-outline btn-outline-dashed btn-outline-primary btn-bg-white btn-active-primary"><i class="material-icons material-icons-style material-icons-2">arrow_back</i></button>'>
                            <span>back</span>
                        </span>
                    </div>
                    <div class="splitter-wrapper flex-column-fluid h-100">
                        <div class="panel-container main-panel-container flex-column-fluid h-100">
                            <div class="panel-left panel-fisrt-part flex-column-fluid h-100">
                                <div class="panel-left-inner flex-column-fluid h-100">
                                    <iframe id="axpiframeac" name="axpiframeac" class="col-xs-12 col-sm-12 col-md-12 col-lg-12 searchOpened flex-column-fluid h-100" style="padding: 0px;" frameborder="0" allowtransparency="True" width="100%"></iframe>
                                </div>
                                <div class="splitter panel-splitter flex-column-fluid h-100" id="drag-point" style="display: none;">
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div id="waitDiv" class="page-loader rounded-2 bg-radial-gradient">
                <div class="loader-box-wrapper d-flex bg-white p-20 shadow rounded">
                    <span class="loader"></span>
                </div>
            </div>

        </div>
    </div>

    <asp:PlaceHolder runat="server">
        <%:Scripts.Render("~/UI/axpertUI/bundleJs") %>
    </asp:PlaceHolder>

    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script src="../Js/helper.min.js?v=141" type="text/javascript"></script>
    <script src="../js/configurationStudio.min.js?v=3" type="text/javascript"></script>
    <script type="text/javascript">
        $(callParentNew("appBackBtn", "class")).hide();
    </script>
    <form id="form1" runat="server">
    </form>
</body>
</html>
