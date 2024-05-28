using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Optimization;

/// <summary>
/// CSS and JS Bundles for all pages : BundleConfig
/// </summary>
/// <Author>  Prashik  </Author>

public class BundleConfig
{
    private static readonly BundleMimeType CssContentMimeType = new BundleMimeType("text/css");
    private static readonly BundleMimeType JsContentMimeType = new BundleMimeType("text/javascript");
    public static void RegisterBundles(BundleCollection bundles)
    {
        #region ltrBundleCss + rtlBundleCss + bundleJs => iview.aspx
        var ltrBundleCss = new Bundle("~/UI/axpertUI/ltrBundleCss");
        ltrBundleCss.Include(
            "~/UI/axpertUI/style.bundle.css",
            "~/UI/axpertUI/plugins.bundle.css"
        );
        ltrBundleCss.EnableFileExtensionReplacements = true;
        ltrBundleCss.Transforms.Add(CssContentMimeType);
        ltrBundleCss.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        ltrBundleCss.Orderer = new BundleSorter();
        bundles.Add(ltrBundleCss);

        var rtlBundleCss = new Bundle("~/UI/axpertUI/rtlBundleCss");
        rtlBundleCss.Include(
            "~/UI/axpertUI/style.bundle.rtl.css",
            "~/UI/axpertUI/plugins.bundle.rtl.css"
        );
        rtlBundleCss.EnableFileExtensionReplacements = true;
        rtlBundleCss.Transforms.Add(CssContentMimeType);
        rtlBundleCss.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        rtlBundleCss.Orderer = new BundleSorter();
        bundles.Add(rtlBundleCss);

        var bundleJs = new Bundle("~/UI/axpertUI/bundleJs")
            .Include(
             "~/UI/axpertUI/plugins.bundle.js",
             "~/UI/axpertUI/scripts.bundle.js"
        );
        bundleJs.EnableFileExtensionReplacements = true;
        bundleJs.Transforms.Add(JsContentMimeType);
        bundleJs.Orderer = new BundleSorter();
        bundles.Add(bundleJs);
        #endregion

        #region SmartViews + Listviews + InMemoryDB => iview.aspx
        var smartviewsCSS = new Bundle("~/Css/smartviews");
        smartviewsCSS.Include(
            "~/UI/axpertUI/datatables.bundle.css",
            //"~/UI/axpertUI/style.bundle.css",            
            //"~/UI/axpertUI/plugins.bundle.css",
            "~/ThirdParty/jquery-confirm-master/jquery-confirm.min.css",
            "~/ThirdParty/bgrins-spectrum/spectrum.css"
        );
        smartviewsCSS.EnableFileExtensionReplacements = true;
        smartviewsCSS.Transforms.Add(CssContentMimeType);
        smartviewsCSS.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        smartviewsCSS.Orderer = new BundleSorter();
        bundles.Add(smartviewsCSS);

        var smartviewsJS = new Bundle("~/Js/smartviews")
            .Include(
             //"~/UI/axpertUI/plugins.bundle.js",
             //"~/UI/axpertUI/scripts.bundle.js",
             "~/UI/axpertUI/datatables.bundle.js",
             "~/Js/noConflict.min.js",
             "~/ThirdParty/lodash.min.js",
             "~/ThirdParty/jquery-confirm-master/jquery-confirm.min.js",
             "~/Js/alerts.js",//min
             "~/Js/handlebars.min.js",
             "~/Js/handleBarsHelpers.js",//min
             "~/ThirdParty/Highcharts/highcharts.js",
             "~/ThirdParty/Highcharts/highcharts-3d.js",
             "~/ThirdParty/Highcharts/highcharts-more.js",
             "~/ThirdParty/Highcharts/highcharts-exporting.js",
             "~/Js/common.js",//min
             "~/Js/iview.js",//min
             "~/Js/jsclient.js",//min
             "~/Js/process.js",//min
             "~/Js/helper.js",//min
             "~/Js/util.min.js",
             "~/Js/JDate.min.js",
             "~/Js/jquery.browser.min.js",
             "~/Js/printjs.js",//min
             "~/Js/iviewjs.js",//min
             "~/Js/smartViews.js",//min
             "~/ThirdParty/bgrins-spectrum/spectrum.js"
            );
        smartviewsJS.EnableFileExtensionReplacements = true;
        smartviewsJS.Transforms.Add(JsContentMimeType);
        smartviewsJS.Orderer = new BundleSorter();
        bundles.Add(smartviewsJS);
        #endregion

        #region reports => html
        var reportCss = new Bundle("~/Css/report");
        reportCss.Include(
            "~/ThirdParty/DataTables-1.10.13/media/css/jquery.dataTables.css",
            "~/ThirdParty/DataTables-1.10.13/extensions/FixedColumns/css/les.min.css",
            "~/ThirdParty/bgrins-spectrum/spectrum.css",
            "~/Thirdparty/newMaterialUI/plugins/node-waves/waves.css",
            "~/Css/iviewNewUi.css",
            "~/Css/animate.min.css"
        );
        reportCss.EnableFileExtensionReplacements = true;
        reportCss.Transforms.Add(CssContentMimeType);
        reportCss.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        reportCss.Orderer = new BundleSorter();
        bundles.Add(reportCss);

        var reportJs = new Bundle("~/Js/report")
            .Include(
             "~/Thirdparty/newMaterialUI/plugins/node-waves/waves.js",
             "~/ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.js",
             "~/ThirdParty/DataTables-1.10.13/media/js/dataTables.bootstrap.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/dataTables.buttons.js",
             //"~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/buttons.flash.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/buttons.html5.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/buttons.print.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/jszip.min.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/pdfmake.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Buttons/js/vfs_fonts.min.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/FixedColumns/js/dataTables.fixedColumns.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/ColReorderWithResize/ColReorderWithResize.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Scroller/js/dataTables.scroller.js",
             "~/Js/handlebars.min.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Extras/moment.min.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Extras/jquery.visible.min.js",
             "~/ThirdParty/DataTables-1.10.13/extensions/Extras/datetime-moment.js",
             "~/ThirdParty/bgrins-spectrum/spectrum.js"
            );
        reportJs.EnableFileExtensionReplacements = true;
        reportJs.Transforms.Add(JsContentMimeType);
        reportJs.Orderer = new BundleSorter();
        bundles.Add(reportJs);
        #endregion


        #region Form => tstruct.aspx
        var formCSS = new Bundle("~/Css/form");
        formCSS.Include(
            "~/ThirdParty/jquery-confirm-master/jquery-confirm.min.css",
            //"~/UI/axpertUI/plugins.bundle.css",
            //"~/UI/axpertUI/style.bundle.css",
            "~/ThirdParty/gridstack.js-0.3.0/dist/jquery-ui/jquery-ui.css",
            "~/ThirdParty/gridstack.js-0.3.0/dist/jquery-ui/jquery-ui.structure.css",
            "~/ThirdParty/gridstack.js-0.3.0/dist/gridstack.css",
            "~/UI/axpertUI/datatables.bundle.css",
            "~/ThirdParty/codemirror/codemirror.css"
        );
        formCSS.EnableFileExtensionReplacements = true;
        formCSS.Transforms.Add(CssContentMimeType);
        formCSS.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        formCSS.Orderer = new BundleSorter();
        bundles.Add(formCSS);

        var formBasic = new Bundle("~/Js/formBasic")
            .Include(
             //"~/UI/axpertUI/plugins.bundle.js",
             //"~/UI/axpertUI/scripts.bundle.js",
             "~/ThirdParty/jquery-confirm-master/jquery-confirm.min.js",
             "~/UI/axpertUI/datatables.bundle.js",
             "~/Js/jquery.browser.min.js",
             "~/Js/printjs.js",//min
             "~/Js/noConflict.min.js",
             "~/Js/propSheet.js",
             "~/Js/alerts.js",
             "~/Js/common.js",
             "~/Js/ckeditor/ckeditor.js",
             "~/Js/ckRtf.js",
             "~/Js/JDate.min.js",
             "~/ThirdParty/lodash.min.js",
             "~/ThirdParty/gridstack.js-0.3.0/dist/jquery-ui/jquery-ui.js",
             "~/ThirdParty/gridstack.js-0.3.0/dist/gridstack.js",
             "~/ThirdParty/gridstack.js-0.3.0/dist/gridstack.jQueryUI.js",
             "~/Js/tstructvars.js",
             "~/Js/md5.min.js",
             "~/Js/util.min.js",
             "~/Js/tstruct-pdf.min.js",
             "~/Js/expressions_config.min.js",
             "~/Js/multiselect.min.js",
             "~/Js/sqlBuilder.js",
             "~/Js/createTheEditor.js",//min
             "~/Js/codemirror/codemirror.js",
             "~/Js/codemirror/mode/sql.js",
             "~/Js/codemirror/addon/hint/sql-hint.js",
             "~/Js/codemirror/mode/javascript.js",
             "~/Js/codemirror/addon/hint/javascript-hint.js"
            );
        formBasic.EnableFileExtensionReplacements = true;
        formBasic.Transforms.Add(JsContentMimeType);
        formBasic.Orderer = new BundleSorter();
        bundles.Add(formBasic);

        var formInit = new Bundle("~/Js/formInit")
            .Include(
             "~/Js/process.js",//min
             "~/Js/tstruct.js",//min
             "~/Js/helper.js",//min
             "~/Js/jsclient.js",//min
             "~/Js/main-tstruct.js",//min
             "~/Js/newGridJS.js",//min
             "~/Js/select2.js",//min
             "~/Js/multigroupselect.js"//min
            );
        formInit.EnableFileExtensionReplacements = true;
        formInit.Transforms.Add(JsContentMimeType);
        formInit.Orderer = new BundleSorter();
        bundles.Add(formInit);
        #endregion

        #region axpert standard page => standardPage.aspx
        //var aspCss = new Bundle("~/Css/aspCss");
        //aspCss.Include(
        //);
        //aspCss.EnableFileExtensionReplacements = true;
        //aspCss.Transforms.Add(CssContentMimeType);
        //aspCss.Transforms.Insert(0, new CssRewriteUrlTransformWrapper());
        //aspCss.Orderer = new BundleSorter();
        //bundles.Add(aspCss);

        var aspJs = new Bundle("~/Js/aspJs")
            .Include(
             "~/Js/noConflict.js",//min
             "~/ThirdParty/lodash.js",//min
             "~/ThirdParty/jquery-confirm-master/jquery-confirm.js",//min
             "~/Js/alerts.js",//min
             "~/Js/handlebars.js",//min
             "~/Js/handleBarsHelpers.js",//min
             "~/Js/common.js",//min
             "~/Js/AxInterface.js",//min
             "~/Js/standardPage.js"
            );
        aspJs.EnableFileExtensionReplacements = true;
        aspJs.Transforms.Add(JsContentMimeType);
        aspJs.Orderer = new BundleSorter();
        bundles.Add(aspJs);
        #endregion

        bundles.Add(new StyleBundle("~/bundles/Css/HomepagenewCss").Include(
       "~/Css/Homepagenew.css",
       "~/Css/thirdparty/bootstrap/5.0/bootstrap-5.0.0.min.css",
       "~/Css/thirdparty/bootstrap/5.3/bootstrap-5.3.0.min.css"
       ));

        bundles.Add(new ScriptBundle("~/bundles/Scripts/HomepagenewJs").Include(
               "~/Js/Homepagenew.js",
               "~/Js/thirdparty/bootstrap/5.0/bootstrap-5.0.min.js",
               "~/Js/thirdparty/bootstrap/5.3/bootstrap_bundle-5.3.0.min.js",
               "~/Js/thirdparty/jquery/3.6.0/jquery-3.6.0.min.js"
               ));


    }
}

public class CssRewriteUrlTransformWrapper : IBundleTransform
{
    private static Regex pattern = new Regex(@"url\s*\(\s*([""']?)([^:)]+)\1\s*\)", RegexOptions.IgnoreCase);

    public void Process(BundleContext context, BundleResponse response)
    {
        response.Content = string.Empty;
        foreach (BundleFile file in response.Files)
        {
            using (var reader = new StreamReader(file.VirtualFile.Open()))
            {
                var contents = reader.ReadToEnd();
                var matches = pattern.Matches(contents);
                if (matches.Count > 0)
                {
                    var directoryPath = VirtualPathUtility.GetDirectory(file.VirtualFile.VirtualPath);
                    foreach (Match match in matches)
                    {
                        var fileRelativePath = match.Groups[2].Value;
                        var fileVirtualPath = VirtualPathUtility.Combine(directoryPath, fileRelativePath);
                        var quote = match.Groups[1].Value;
                        var replace = String.Format("url({0}{1}{0})", quote, VirtualPathUtility.ToAbsolute(fileVirtualPath));
                        contents = contents.Replace(match.Groups[0].Value, replace);
                    }
                }
                response.Content = String.Format("{0}\r\n{1}", response.Content, contents);
            }
        }
    }
}

internal sealed class BundleMimeType : IBundleTransform
{
    private readonly string _mimeType;

    public BundleMimeType(string mimeType) { _mimeType = mimeType; }

    public void Process(BundleContext context, BundleResponse response)
    {
        if (context == null)
            throw new ArgumentNullException();
        if (response == null)
            throw new ArgumentNullException();
        response.ContentType = _mimeType;
    }
}
