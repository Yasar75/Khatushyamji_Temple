<%@ Page Language="VB" AutoEventWireup="false" CodeFile="sess.aspx.vb" Inherits="sess" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta name="description" content="Session Expire" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title><%=appTitle%></title>
    <link rel="shortcut icon" href="../images/favicon.ico" />
    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <asp:PlaceHolder runat="server">
        <%:Styles.Render(If(direction = "ltr", "~/UI/axpertUI/ltrBundleCss", "~/UI/axpertUI/rtlBundleCss")) %>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server">
        <%:Scripts.Render("~/UI/axpertUI/bundleJs") %>
    </asp:PlaceHolder>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>
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
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118"></script>
    <script type="text/javascript" src="../Js/alerts.min.js?v=30"></script>
    <script type="text/javascript" src="../Js/lang/content-<%=langType%>.js?v=59"></script>
    <script>
        var isMobile = isMobileDevice();
        //localStorage.clear();
        sessionStorage.removeItem("homeJsonObj");
        sessionStorage.clear();
        clearLocalStorage = function (exceptions, contains) {
            contains = contains || false;
            var storage = localStorage
            var keys = [];
            var exceptions = [].concat(exceptions) //prevent undefined

            //get storage keys
            $.each(localStorage, function (key, val) {
                keys.push(key);
            });

            //loop through keys
            for (i = 0; i < keys.length; i++) {
                var key = keys[i]
                var deleteItem = true
                //check if key excluded
                for (j = 0; j < exceptions.length; j++) {
                    var exception = exceptions[j];
                    if (key.indexOf(exception) > -1 && contains) { deleteItem = false; }
                    else if (key == exception) { deleteItem = false; }
                }
                //delete key
                if (deleteItem) {
                    localStorage.removeItem(key)
                }
            }
        }
        let appSessUrl = top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
        let duplicateUser = localStorage.getItem("duplicateUser-" + appSessUrl);
        let instanceName = localStorage.getItem("instanceName-" + appSessUrl);

        clearLocalStorage(['projInfo-', 'versionInfo-', 'langInfo-', 'hybridGUID-', 'hybridDeviceId-', 'compressedMode-', 'duplicateUser-', 'instanceName-'], true);
        var diFileInfo = '<%=strFileinfo%>';
        var showAlertMsgText = '<%=showAlertMsgText%>';
        $(document).ready(function () {

            if (typeof instanceName != "undefined" && instanceName != null) {
                let hrefVal = $("#btnSessLogin").attr('href');
                $("#btnSessLogin").attr("href", hrefVal + "?" + instanceName);
            }
            if (typeof duplicateUser != "undefined" && duplicateUser != "") {
                try {
                    $.ajax({
                        url: 'sess.aspx/ClearSessExpiry',
                        type: 'POST',
                        cache: false,
                        async: true,
                        data: JSON.stringify({
                            duplicateUser: duplicateUser
                        }),
                        dataType: 'json',
                        contentType: "application/json",
                        success: function (data) { }
                    });
                } catch (ex) { }
            }
            $("#lblsesslogin").parent().prop('title', lcm[389]);
            if (isMobileDevice()) {
                let custommoblogoexist = false;
                if (diFileInfo != "") {
                    $j("#main_body").removeAttr("style");
                    var imageUrl = "./../images/Custom/" + diFileInfo;
                    $j("#main_body").css({ "background-image": "url(" + imageUrl + ")", "background-size": "cover", "height": "100vh" });
                    custommoblogoexist = true;
                }
                if (custommoblogoexist == false) {
                    $j("#main_body").removeAttr("style");
                    var imageUrl = "./../AxpImages/login-img.png";
                    $j("#main_body").css({ "background-image": "url(" + imageUrl + ")", "background-size": "cover", "height": "100vh" });
                }

            }

            if (typeof localStorage != "undefined") {
                var projUrl = top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
                var proj = localStorage["projInfo-" + projUrl] || "";
                setProjectImages(proj);
            }

            if (showAlertMsgText != "") {
                showAlertDialog("error", showAlertMsgText);
            }
        });

        function setProjectImages(proj) {
            var webBgImage = "../AxpImages/login-img.png";
            var mobBgImage = "../AxpImages/login-img.png";
            var webBgImageDiv = $("body");
            var mobBgImageDiv = $("body");

            if (proj) {
                getProjectAppLogo(proj, async = true, function (success) {
                    if (success !== null && success !== void 0 && success.d) {
                        var _JSON$parse = JSON.parse(success.d),
                            webbg = _JSON$parse.webbg,
                            mobbg = _JSON$parse.mobbg;

                        if (webbg && !mobbg) {
                            mobbg = webbg;
                        }

                        if (!isMobile) {
                            webBgImageDiv.css("background", "url(".concat(webbg ? "".concat(webbg, "?v=").concat(new Date().getTime()) : webBgImage, ") ").concat(webbg ? "no-repeat center center fixed" : "no-repeat fixed bottom")).css("background-size", "cover");
                        } else {
                            mobBgImageDiv.css("background", "url(".concat(mobbg ? "".concat(mobbg, "?v=").concat(new Date().getTime()) : mobBgImage, "?v=").concat(new Date().getTime(), ") ").concat(mobbg ? "no-repeat center center fixed" : "no-repeat fixed bottom")).css("background-size", "cover");
                        }
                    } else {
                        if (!isMobile) {
                            webBgImageDiv.css("background", "url(".concat(webBgImage, ") no-repeat fixed bottom")).css("background-size", "cover");
                        } else {
                            mobBgImageDiv.css("background", "url(".concat(mobBgImage, "?v=").concat(new Date().getTime(), ") no-repeat fixed bottom ")).css("background-size", "cover");
                        }
                    }
                }, function (error) {
                    if (!isMobile) {
                        webBgImageDiv.css("background", "url(".concat(webBgImage, ") no-repeat fixed bottom")).css("background-size", "cover");
                    } else {
                        mobBgImageDiv.css("background", "url(".concat(mobBgImage, "?v=").concat(new Date().getTime(), ") no-repeat fixed bottom")).css("background-size", "cover");
                    }
                });
            } else {
                if (!isMobile) {
                    webBgImageDiv.css("background", "url(".concat(webBgImage, ") no-repeat fixed bottom")).css("background-size", "cover");
                } else {
                    mobBgImageDiv.css("background", "url(".concat(mobBgImage, "?v=").concat(new Date().getTime(), ") no-repeat fixed bottom")).css("background-size", "cover");
                }
            }
        }
    </script>

</head>
<body id="main_body" runat="server" dir="<%=direction%>">
    <video id="bgvid" runat="server" playsinline="" autoplay="" muted="" loop="" class="d-none">
        <source src="" type="video/mp4" id="bgvidsource" runat="server" class="d-none">
    </video>

    <div id="login-prouct-name" class="d-none">
        <%=appName%>
    </div>
    <div class="login-wrapper card login-inner w-lg-500px m-auto">
        <div id="info-box" class="card-body w-lg-500px p-8 p-lg-12 mx-auto">
            <h1 class="text-dark fs-2x mb-5">
                <asp:Label ID="lblsessexp" CssClass="" runat="server" meta:resourcekey="lblsessexp">Your session has expired</asp:Label>
            </h1>
            <div class="fw-bold fs-4 text-gray-600">
                <div class="d-flex align-items-top py-4">
                    <asp:Label ID="lblsessrsn" class="" runat="server" meta:resourcekey="lblsessrsn">This has happened due to the following reasons:</asp:Label>
                </div>
                <div class="d-flex align-items-top py-2">
                    <span class="bullet bg-primary me-3 mt-3"></span>
                    <asp:Label ID="lblsessbrwsr" class="" runat="server" meta:resourcekey="lblsessbrwsr">You have kept the browser window idle for a long time.</asp:Label>
                </div>
                <div class="d-flex align-items-top py-2">
                    <span class="bullet bg-primary me-3 mt-3"></span>
                    <asp:Label ID="lblsessstatic" class="" runat="server" meta:resourcekey="lblsessstatic">You are accessing the application URL from a saved or static page.</asp:Label>
                </div>
                <div class="d-flex align-items-top py-2">
                    <span class="bullet bg-primary me-3 mt-3"></span>
                    <asp:Label ID="lblsessdup" class="" runat="server" meta:resourcekey="lblsessdup">You might have logged into another session.</asp:Label>
                </div>


                <div class="d-flex align-items-center pt-2">
                    <a href="<%=loginStr %>" class="btn btn-lg btn-primary m-auto w-50" id="btnSessLogin">
                        <asp:Label ID="lblsesslogin" runat="server" meta:resourcekey="lblsesslogin">Log in</asp:Label>
                    </a>
                </div>
            </div>
        </div>

    </div>
</body>
</html>
