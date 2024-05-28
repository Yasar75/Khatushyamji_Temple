<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tstructhtml.aspx.cs" Inherits="tstructhtml" EnableEventValidation="false" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="description" content="File Upload" />
    <meta name="keywords" content="Agile Cloud, Axpert,HMS,BIZAPP,ERP" />
    <meta name="author" content="Agile Labs" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Custom HTML</title>
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
    <link href="../Css/generic.min.css?v=10" rel="stylesheet" type="text/css" id="generic" />
    <link href="../Css/thirdparty/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" />
    <link href="../newPopups/Remodal/remodal-default-theme.min.css" rel="stylesheet" />
    <link href="../newPopups/Remodal/remodal.min.css?v=4" rel="stylesheet" />
    <link href="../Css/axpertPopup.min.css?v=24" rel="stylesheet" />

    <script>
        if (!('from' in Array)) {
            // IE 11: Load Browser Polyfill
            document.write('<script src="../Js/polyfill.min.js"><\/script>');
        }
    </script>
    <script src="../Js/thirdparty/jquery/3.1.1/jquery.min.js" type="text/javascript"></script>
    <script src="../Js/iFrameHandler.min.js"></script>
    <script src="../Js/noConflict.min.js?v=1" type="text/javascript"></script>

    <link href="../Css/animate.min.css" rel="stylesheet" />
    <link href="../ThirdParty/jquery-confirm-master/jquery-confirm.min.css?v=1" rel="stylesheet" />
    <script src="../ThirdParty/jquery-confirm-master/jquery-confirm.min.js?v=2" type="text/javascript"></script>
    <script src="../Js/alerts.min.js?v=30" type="text/javascript"></script>
    <script src="../newPopups/axpertPopup.min.js?v=45" type="text/jscript"></script>
    <script src="../Js/gen.min.js?v=14" type="text/javascript"></script>
    <script src="../Js/common.min.js?v=118" type="text/javascript"></script>
    <script src="../Js/thirdparty/bootstrap/3.3.6/bootstrap.min.js" type="text/javascript"></script>
    <style>
        .bodytsthtml textarea {
            max-height: 100%;
            height: 300px;
            max-width: 400px;
        }

        .footertsthtml {
            text-align: right;
            margin-top: 20px;
        }
    </style>
    <script type="text/javascript">
        $j(document).ready(function () {
            var CustHTML = callParentNew("tstructCustomHTML");
            $("#currenttstHtml").val(CustHTML);
        });
        function closeUploadDialog() {
            if ($(parent.$('.modal .close') != undefined) && $(parent.$('.modal .close')).length)
                $(parent.$('.modal .close')).click();
           
             }
        function saveTsthtml() {
            let customHtml = $("#customHtml").val();
            let ttransId = callParentNew("transid");
            let tstCaption = callParentNew("tstructCaption");
            if (customHtml != "") {
                $.ajax({
                    url: 'tstructhtml.aspx/TstructSaveHtml',
                    type: 'POST',
                    cache: false,
                    async: true,
                    data: JSON.stringify({
                        transId: ttransId, tstCaption: tstCaption, strInput: customHtml
                    }),
                    dataType: 'json',
                    contentType: "application/json",
                    success: function (data) {
                        if (data.d != "") {
                            let saveMsg = data.d.split("*$*");
                            if (JSON.parse(saveMsg[1]).result == "error") {
                                showAlertDialog("error", JSON.parse(saveMsg[0]).message);
                            }
                            else if (JSON.parse(saveMsg[2]).result[0].save == "success") {
                                showAlertDialog("success", "Custom HTML saved successfully");
                                //closeUploadDialog();
                            }
                            else
                                showAlertDialog("warning", "Custom HTML not saved successfully!");
                        }
                    }, error: function (error) {
                        showAlertDialog("error", error);
                    }
                })
            }
            else
                showAlertDialog("error", "Custom HTML should not allow empty value!");
        }
    </script>


</head>
<body dir='<%=direction%>'>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="bodytsthtml">
            <div class="col-sm-6 col-md-6">
                <span>HTML</span>
                <div>
                    <textarea name="currenttstHtml" id="currenttstHtml" runat="server" class="combotem Family form-control" readonly></textarea>
                </div>
            </div>
            <div class="col-sm-6 col-md-6">
                <span>Custom HTML</span>
                <div>
                    <textarea name="customHtml" id="customHtml" runat="server" class="combotem Family form-control"></textarea>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="col-sm-12 col-md-12">
            <div class="footertsthtml">
                <input class="hotbtn" type="button" id="btnSaveHtml" title="Ok" name="Ok" value="Ok" onclick="saveTsthtml();" />
                <input name="close" type="button" id="close" value="Close" title="Close" class="coldbtn" onclick="closeUploadDialog();" />
            </div>
        </div>
    </form>
</body>
</html>
