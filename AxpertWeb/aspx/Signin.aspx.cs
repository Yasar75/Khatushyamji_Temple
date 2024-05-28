using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Net;
using System.IO;
using System.Xml;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Security.Principal;
using System.Collections.Generic;
using System.Linq;
using System.Web.Caching;
using Newtonsoft.Json.Linq;
using System.Threading;
using System.Web.Security;
using Saml;
using System.Collections;
using System.Web.UI;
using System.Web.UI.WebControls;
using BotDetect;
using BotDetect.Web;

public partial class Signin : System.Web.UI.Page
{
    Util.Util util = new Util.Util();
    LogFile.Log logobj = new LogFile.Log();
    public string appTitle = string.Empty;
    public string direction = "ltr";
    public string langType = "en";
    public string strFileinfo = string.Empty;
    public string hybridGUID = string.Empty;
    public string hybridDeviceId = string.Empty;
    public string hybridDefaultPage = string.Empty;
    public string KeepMeAutoLogin = "false";
    public string KeepMeAutoLoginWeb = "false";
    public string KeepMeAutoPwd = string.Empty;
    public static string isMobDevice = string.Empty;
    public static string btforDupLogin = string.Empty;
    public static string timeZone = string.Empty;
    public static string staySignIn = "false";
    public string isOfficeSSO = string.Empty;
    string slproject = string.Empty;
    string proj = string.Empty;
    string axProjs = string.Empty;
    string language = string.Empty;
    public string isUserLang = string.Empty;
    public string isPowerBy = string.Empty;
    public StringBuilder strParams = new StringBuilder();

    public static string ssoredirecturl = string.Empty;

    public string oktaclientKey = string.Empty;
    public string oktasecretKey = string.Empty;
    public string oktadomain = string.Empty;

    public string office365clientKey = string.Empty;
    public string office365secretKey = string.Empty;

    public static string googleclientKey = string.Empty;
    public static string googlesecretKey = string.Empty;

    public static string fbclientKey = string.Empty;
    public static string fbsecretKey = string.Empty;

    ExecTrace ObjExecTr = ExecTrace.Instance;
    //public static string StartTime = string.Empty;
    string requestProcess_logtime = string.Empty;
    public string isPostback = "false";
    protected override void InitializeCulture()
    {
        if (ConfigurationManager.AppSettings["proj"] != null && ConfigurationManager.AppSettings["proj"].ToString() != string.Empty)
        {
            language = LoadLanguages();
            string dirLang = string.Empty;
            dirLang = util.SetCulture(language.ToUpper());
            if (!string.IsNullOrEmpty(dirLang))
            {
                direction = dirLang.Split('-')[0];
                langType = dirLang.Split('-')[1];
            }
            FileInfo filcustom = new FileInfo(HttpContext.Current.Server.MapPath("~/Js/lang/content-" + langType + ".js"));
            if (!(filcustom.Exists))
            {
                langType = "en";
                direction = "ltr";
            }
        }
    }

    protected void Pre_Load(object sender, EventArgs e)
    {
        if (HttpContext.Current.Request.Url.AbsolutePath.ToLower().IndexOf(Request.FilePath.ToLower() + "/") > -1)
            Response.Redirect("~/CusError/AxCustomError.aspx");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            AntiforgeryChecker.Check(this, _antiforgery);
        }
        catch (Exception ex)
        {
            Response.Redirect("~/CusError/AxCustomError.aspx");
        }

        if (!IsPostBack)
        {
            if (Util.Util.CheckCrossScriptingInString(Request.QueryString.ToString()))
                Response.Redirect("~/CusError/AxCustomError.aspx");
            if (Session["LoginWith"] != null)
            {
                if (Session["Project"] != null && Session["Project"].ToString() != string.Empty && Session["username"] != null && Session["username"].ToString() != string.Empty)
                {
                    if (util.CheckLoggedUserDetails(Session["Project"].ToString(), Session.SessionID) == true)
                    {
                        ASB.WebService wsObj = new ASB.WebService();
                        wsObj.SignOut();
                    }
                }
                switch (Session["LoginWith"].ToString())
                {
                    case "google":
                        FetchUserSocialDetail("google");
                        break;
                    case "facebook":
                        FetchUserSocialDetail("facebook");
                        break;
                    case "saml":
                        FetchUserSocialDetail("saml");
                        break;
                }
            }
            else if (Request.QueryString["ssotype"] != null)
            {
                isMobDevice = Request.QueryString["ismobile"].ToString();
                staySignIn = Request.QueryString["ssin"].ToString();
                if (Request.QueryString["ssotype"] == "office365")
                {
                    Session["LoginWith"] = "office365";
                    FetchUserSocialDetail("office365", Request.QueryString["code"].ToString());
                }
                else if (Request.QueryString["ssotype"] == "okta")
                {
                    isOfficeSSO = "true";
                    Session["LoginWith"] = "okta";
                    FetchUserSocialDetail("okta", Request.QueryString["code"].ToString());
                }
            }
            else if (Request.QueryString["duplicateUser"] != null && Session["duplicateUser"] != null)
            {
                panelSignin.Visible = false;
                isMobDevice = Request.QueryString["mobDevice"];
                btforDupLogin = Request.QueryString["hbtforDupLogin"];
                string[] duplicateUser = Session["duplicateUser"].ToString().Split('♦');
                Session["duplicateUser"] = null;
                UserIsLoggedIn(bool.Parse(duplicateUser[0]), duplicateUser[1], duplicateUser[2], duplicateUser[3], duplicateUser[4], duplicateUser[5]);
            }
            else if (Request.QueryString["InternalSSO"] != null)
            {
                FetchUserSocialDetail("InternalSSO", Request.QueryString["InternalSSO"].ToString());
            }
            else
            {
                if (ConfigurationManager.AppSettings["EnableAxpertConfiguration"] != null && ConfigurationManager.AppSettings["EnableAxpertConfiguration"].ToString() == "true")
                {
                    axpertConfig.Visible = true;
                }
                if (Session["duplicateUser"] != null)
                {
                    Session["duplicateUser"] = null;
                    Session["loggedUserDetails"] = null;
                }
                if (Session["Project"] != null && Session["Project"].ToString() != string.Empty)
                {
                    if (util.CheckLoggedUserDetails(Session["Project"].ToString(), Session.SessionID) == true)
                    {
                        ASB.WebService wsObj = new ASB.WebService();
                        wsObj.SignOut();
                    }
                }

                if (ConfigurationManager.AppSettings["HomeSessExpriesUrl"] != null & ConfigurationManager.AppSettings["HomeSessExpriesUrl"].ToString() != "" & Session["AxCloudDB"] != null)
                {
                    string url;
                    Session["AxCloudDB"] = null;
                    url = ConfigurationManager.AppSettings["HomeSessExpriesUrl"];
                    Response.Redirect(url);
                }

                if (Request.QueryString["hybridGUID"] != null)
                    hybridGUID = Request.QueryString["hybridGUID"].ToString();
                else
                    hybridGUID = string.Empty;

                SetAxpertLogo();

                IsLicExist();

                //string axpertVersion = "";
                //if (ConfigurationManager.AppSettings["axpertVersion"] != null)
                //{
                //    if (ConfigurationManager.AppSettings["axpertVersion"].ToString() != string.Empty)
                //        axpertVersion = "Version " + ConfigurationManager.AppSettings["axpertVersion"].ToString();
                //}
                //axpertVer.InnerText = axpertVersion;

                if (ConfigurationManager.AppSettings["staysignin"] != null && ConfigurationManager.AppSettings["staysignin"].ToString() == "true")
                    axstaysignin.Visible = true;
                else
                    axstaysignin.Visible = false;

                if (Session["Project"] != null)
                    Session["Project"] = null;
                if (Session["queryProj"] != null)
                    Session["queryProj"] = null;

                if (ConfigurationManager.AppSettings["proj"] != null && ConfigurationManager.AppSettings["proj"].ToString() != string.Empty)
                {
                    Session["Project"] = proj = ConfigurationManager.AppSettings["proj"].ToString();
                    hdnAxProjs.Value = proj;
                    selectProj.Style.Add("display", "none");
                    axSelectProj.Value = proj;
                }
                else
                {
                    string dProj = string.Empty;
                    string queryProj = Request.QueryString.ToString();
                    if (queryProj != string.Empty && !queryProj.Contains("&") && !queryProj.Contains("="))
                        dProj = queryProj;
                    else if (queryProj != string.Empty && (queryProj.Contains("&") && !queryProj.Split('&')[0].Contains("=")))
                        dProj = queryProj.Split('&')[0];
                    else
                    {
                        string subDomain = HttpContext.Current.Request.ApplicationPath;
                        string urlDomain = HttpContext.Current.Request.Url.Host;
                        if (subDomain != "/")
                            dProj = subDomain.Split('/').Last();
                        else if (urlDomain != string.Empty && urlDomain.ToLower() != "localhost")
                            dProj = urlDomain;
                    }
                    if (dProj != string.Empty)
                        GetWebSiteProjectDetails(dProj);
                    else
                        GetProjectDetails();
                }

                if (language != string.Empty)
                {
                    Session["AxLanguages"] = language;
                    isUserLang = language;
                    hdnLangs.Value = language;
                    //axLangFld.Style.Add("display", "none");
                }
                else if (proj != string.Empty)
                {
                    language = LoadLanguages();
                    if (language == string.Empty)
                        isUserLang = "";
                    else
                        isUserLang = language;
                    StringBuilder axLangs = new StringBuilder();
                    if ((string.IsNullOrEmpty(language)))
                        axLangs.Append("ENGLISH");
                    else
                    {
                        var strLang = language.Split(',');
                        if (strLang.Length > 1 && strLang[1].ToString() != "")
                            axLangs.Append(language);
                    }
                    hdnLangs.Value = axLangs.ToString();
                }

                string copyRightTxt = string.Empty;
                if (proj != string.Empty)
                {
                    copyRightTxt = util.GetConfigAttrValue(proj, "AxCopyRightText", language);
                    isPowerBy = "true";
                    copyRightTxt = copyRightTxt.Replace("#br#", "<br/>");
                    if (copyRightTxt != string.Empty)
                        dvCopyRight.InnerText = copyRightTxt;
                }
                RenderLandingPage();
                if (ConfigurationManager.AppSettings["ssoredirecturl"] != null && ConfigurationManager.AppSettings["ssoredirecturl"].ToString() != string.Empty)
                {
                    ssoredirecturl = ConfigurationManager.AppSettings["ssoredirecturl"].ToString();
                }
                if (ConfigurationManager.AppSettings["ssologin"] != null && ConfigurationManager.AppSettings["ssologin"].ToString() != string.Empty)
                {
                    string[] ssoclientKey = null;
                    if (ConfigurationManager.AppSettings["ssoclientKey"] != null && ConfigurationManager.AppSettings["ssoclientKey"].ToString() != string.Empty)
                    {
                        string ssoclientKeys = ConfigurationManager.AppSettings["ssoclientKey"].ToString();
                        ssoclientKey = ssoclientKeys.Split(',');
                    }
                    string[] ssoclientsecretKey = null;
                    if (ConfigurationManager.AppSettings["ssoclientsecretKey"] != null && ConfigurationManager.AppSettings["ssoclientsecretKey"].ToString() != string.Empty)
                    {
                        string ssoclientsecretKeys = ConfigurationManager.AppSettings["ssoclientsecretKey"].ToString();
                        ssoclientsecretKey = ssoclientsecretKeys.Split(',');
                    }
                    string ssologin = ConfigurationManager.AppSettings["ssologin"].ToString();
                    string[] ssologinAcc = ssologin.Split(',');

                    for (int i = 0; i < ssologinAcc.Count(); i++)
                    {
                        if (ssologinAcc[i] == "office365")
                        {
                            Office365Btn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                            if (ssoclientKey != null && ssoclientKey[i] != null)
                                office365clientKey = ssoclientKey[i];
                            if (ssoclientsecretKey != null && ssoclientsecretKey[i] != null)
                                office365secretKey = ssoclientsecretKey[i];
                        }
                        else if (ssologinAcc[i] == "okta")
                        {
                            OktaBtn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                            if (ssoclientKey != null && ssoclientKey[i] != null)
                                oktaclientKey = ssoclientKey[i];
                            if (ssoclientsecretKey != null && ssoclientsecretKey[i] != null)
                                oktasecretKey = ssoclientsecretKey[i];
                            if (ConfigurationManager.AppSettings["ssooktadomain"] != null && ConfigurationManager.AppSettings["ssooktadomain"].ToString() != string.Empty)
                                oktadomain = ConfigurationManager.AppSettings["ssooktadomain"].ToString();
                        }
                        else if (ssologinAcc[i] == "google")
                        {
                            GoogleBtn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                            if (ssoclientKey != null && ssoclientKey[i] != null)
                                googleclientKey = ssoclientKey[i];
                            if (ssoclientsecretKey != null && ssoclientsecretKey[i] != null)
                                googlesecretKey = ssoclientsecretKey[i];
                        }
                        else if (ssologinAcc[i] == "facebook")
                        {
                            FacebookBtn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                            if (ssoclientKey != null && ssoclientKey[i] != null)
                                fbclientKey = ssoclientKey[i];
                            if (ssoclientsecretKey != null && ssoclientsecretKey[i] != null)
                                fbsecretKey = ssoclientsecretKey[i];
                        }
                        else if (ssologinAcc[i] == "windows")
                        {
                            WindowsBtn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                        }
                        else if (ssologinAcc[i] == "saml")
                        {
                            SamlBtn.Visible = true;
                            divsso.Attributes["class"] = divsso.Attributes["class"].Replace("d-none", "").Trim();
                        }
                    }
                }
                if (Request.QueryString["deviceid"] != null)
                {
                    string projName = string.Empty;
                    if (Request.QueryString["projname"] != null)
                        projName = Request.QueryString["projname"].ToString();
                    hybridDeviceId = Request.QueryString["deviceid"].ToString();
                    HybridAppKeepSigninDetails(hybridDeviceId, projName);
                    if (Request.QueryString["type"] != null && Request.QueryString["name"] != null)
                        hybridDefaultPage = Request.QueryString["type"].ToString() + "^" + Request.QueryString["name"].ToString();
                    else
                        hybridDefaultPage = string.Empty;
                }
                else
                {
                    hybridDeviceId = string.Empty;
                    hybridDefaultPage = string.Empty;
                }
                string kmsin = "true";
                if (Request.QueryString["keepmesignin"] != null)
                    kmsin = Request.QueryString["keepmesignin"];
                if (hybridDeviceId == string.Empty && (kmsin == "" || kmsin == "true"))
                    KeepMeAutoLoginWeb = "true";

                Session.Remove("LoginWith");
            }
            //StartTime = DateTime.Now.ToString();//.ToString("dd-MM-yyyy HH:mm:ss.fff");
            hdnSrtforLogin.Value = DateTime.Now.ToString();
        }
        else
        {
            string browserElapstm = browserElapsTime.Value;
            requestProcess_logtime += ObjExecTr.WireElapsTime(browserElapstm, hdnSrtforLogin.Value);
            isPostback = "true";
            panelSignin.Visible = false;
        }
        AddCustomLinks();
    }

    protected void SetAxpertLogo()
    {

        main_body.Attributes.Add("Dir", direction);
        string folderPath = Server.MapPath("~/images/Custom");
        DirectoryInfo di = new DirectoryInfo(folderPath);
        FileInfo[] diFileinfo = di.GetFiles();
        var customlogoexist = "False";
        //foreach (var drfile in diFileinfo)
        //{
        //    if (drfile.Length > 0 && drfile.Name.Contains("homelogo_mob"))
        //    {
        //        strFileinfo = drfile.Name;
        //        break;
        //    }
        //}

        //foreach (var drfile in diFileinfo)
        //{
        //    if (drfile.Length > 0 && drfile.Name.Contains("homelogo"))
        //    {
        //        if (drfile.Name.Contains("mp4"))
        //        {
        //            main_body.Attributes.CssStyle.Add("background", "");
        //            bgvid.Attributes.CssStyle.Add("display", "block");
        //            bgvidsource.Attributes.Add("src", "./../images/Custom/homelogo.mp4?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + "");
        //            customlogoexist = "True";
        //            break;
        //        }
        //        else
        //        {
        //            main_body.Attributes.CssStyle.Add("background", "url(./../images/Custom/" + drfile.Name + "?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + ") no-repeat center center fixed !important ");
        //            main_body.Attributes.CssStyle.Add("background-size", "cover !important");
        //            main_body.Attributes.CssStyle.Add("height", "100vh !important");
        //            customlogoexist = "True";
        //            break;
        //        }
        //    }
        //}
        if (customlogoexist == "False")
        {
            main_body.Attributes.CssStyle.Add("background", "url(./../AxpImages/login-img.png)");
            main_body.Attributes.CssStyle.Add("background-repeat", "no-repeat");
            main_body.Attributes.CssStyle.Add("background-attachment", "fixed");
            main_body.Attributes.CssStyle.Add("background-position", "bottom");
            main_body.Attributes.CssStyle.Add("background-size", "cover !important");
        }
    }

    private string LoadLanguages()
    {
        string language = string.Empty;
        if (ConfigurationManager.AppSettings["proj"] != null && ConfigurationManager.AppSettings["proj"] != string.Empty)
        {
            string proj = ConfigurationManager.AppSettings["proj"].ToString();
            language = util.GetConfigAttrValue(proj, "AxLanguages");
        }
        return language;
    }

    private void AddCustomLinks()
    {
        Custom cusObj = Custom.Instance;
        for (int i = 0; i <= cusObj.jsPageName.Count - 1; i++)
        {
            string fileName = string.Empty;

            if (cusObj.jsPageName[i].ToString() == "Signin.aspx")
            {
                fileName = cusObj.jsPageFiles[i].ToString();
                HtmlGenericControl js = new HtmlGenericControl("script");
                js.Attributes["type"] = "text/javascript";
                string path = "../" + (proj != string.Empty ? proj + "/" : "") + fileName;
                js.Attributes["src"] = path;
                ScriptManager1.Controls.Add(js);
            }
        }

        for (int j = 0; j <= cusObj.cssPageName.Count - 1; j++)
        {
            string fileName = string.Empty;

            if (cusObj.cssPageName[j].ToString() == "Signin.aspx")
            {
                fileName = cusObj.cssPageFiles[j].ToString();
                HtmlGenericControl css = new HtmlGenericControl("link");
                css.Attributes["type"] = "text/css";
                css.Attributes["rel"] = "stylesheet";
                string path = "../" + (proj != string.Empty ? proj + "/" : "") + fileName;
                css.Attributes["href"] = path;
                ScriptManager1.Controls.Add(css);
            }
        }
    }

    private void GetProjectDetails()
    {
        axProjs = util.CheckForAvailableProjects();
        if (axProjs != string.Empty)
        {
            hdnAxProjs.Value = axProjs;
            var isProjValid = util.IsProjectValid(axProjs);
            if (!isProjValid)
            {
                try
                {
                    Response.Redirect(Constants.LOGINPAGE, true);
                }
                catch (ThreadAbortException)
                {
                    ​​Thread.ResetAbort();
                }
            }
        }
        else
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "showAlertDialog(\"error\", \"Connection details not available.\");", true);
    }

    private void GetWebSiteProjectDetails(string dproject)
    {
        axProjs = util.CheckForAvailableProjects();
        if (axProjs != string.Empty)
        {
            var dsproj = axProjs.Split(',').AsEnumerable().Where(x => x.ToLower() == dproject.ToLower()).ToList();
            if (dsproj.Count() > 0)
            {
                axProjs = dsproj[0];
                var isProjValid = util.IsProjectValid(axProjs);
                if (!isProjValid)
                {
                    try
                    {
                        Response.Redirect(Constants.LOGINPAGE, true);
                    }
                    catch (ThreadAbortException ex)
                    {​​​​​
                      Thread.ResetAbort();
                    }​​​​​
                }
                else
                {
                    Session["Project"] = axProjs;
                    hdnAxProjs.Value = axProjs;
                    selectProj.Style.Add("display", "none");
                    axSelectProj.Value = axProjs;
                    Session["queryProj"] = axProjs;
                }
            }
            else
            {
                hdnAxProjs.Value = axProjs;
                var isProjValid = util.IsProjectValid(axProjs);
                if (!isProjValid)
                {
                    try
                    {
                        Response.Redirect(Constants.LOGINPAGE, true);
                    }
                    catch (ThreadAbortException ex)
                    {​​​​​
                      Thread.ResetAbort();
                    }​​​​​
                }
            }
        }
        else
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "showAlertDialog(\"error\", \"Connection details not available.\");", true);
    }

    private void GetSocialCredentials(String provider)
    {
        ISSO ssoObject = SSO.ObjectHelper(provider);
        Session["LoginWith"] = provider;
        if (proj == string.Empty)
            Session["Project"] = axSelectProj.Value;
        if (provider == "google")
        {
            ssoObject.clientID = googleclientKey;
            ssoObject.clientSecret = googlesecretKey;
            ssoObject.redirectUrl = ssoredirecturl + "aspx/signin.aspx";
        }
        else if (provider == "facebook")
        {
            ssoObject.clientID = fbclientKey;
            ssoObject.clientSecret = fbsecretKey;
            ssoObject.redirectUrl = ssoredirecturl + "aspx/signin.aspx";
        }
        Response.Redirect(ssoObject.GetRequestURL());
    }

    private void FetchUserSocialDetail(String provider, string SSOIdUser = "")
    {
        try
        {
            if (provider == "google")
            {
                var url = Request.Url.Query;
                if (!string.IsNullOrEmpty(url))
                {
                    string queryString = url.ToString();
                    string[] words = queryString.Split('=');
                    string code = words[1];
                    if (!string.IsNullOrEmpty(code))
                    {
                        Google.Request request = new Google.Request();
                        request.clientID = googleclientKey;
                        request.clientSecret = googlesecretKey;
                        request.redirectUrl = ssoredirecturl + "aspx/signin.aspx";
                        string parameters = request.GetParameters(code);
                        string response = MakeWebRequest("https://accounts.google.com/o/oauth2/token", "POST", "application/x-www-form-urlencoded", parameters);
                        Google.Token tokenInfo = new JavaScriptSerializer().Deserialize<Google.Token>(response);

                        if (tokenInfo != null)
                        {
                            if (!string.IsNullOrEmpty(tokenInfo.access_token))
                            {
                                var googleInfo = MakeWebRequest("https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + tokenInfo.access_token, "GET");
                                Google.Info profile = new JavaScriptSerializer().Deserialize<Google.Info>(googleInfo);
                                CallLoginService(true, profile.email, hdnPuser.Value, Session["Project"].ToString(), Session["AxLanguages"].ToString(), profile.id);// tokenInfo.access_token);
                            }
                        }
                    }
                }
                Session.Remove("LoginWith");
            }
            else if (provider == "facebook")
            {
                if (Request["code"] != null)
                {
                    Facebook.Request request = new Facebook.Request();
                    request.clientID = fbclientKey;
                    request.clientSecret = fbsecretKey;
                    request.redirectUrl = ssoredirecturl + "aspx/signin.aspx";
                    string url = request.GetParameters(Request["code"]);
                    string tokenResponse = MakeWebRequest(url, "GET");
                    var tokenInfo = new JavaScriptSerializer().Deserialize<Facebook.Token>(tokenResponse);
                    //var facebookInfoJson = MakeWebRequest(ConfigurationManager.AppSettings["FacebookAccessUrl"] + tokenInfo.access_token, "GET");
                    var facebookInfoJson = MakeWebRequest(request.AccessUrl + tokenInfo.access_token, "GET");
                    Facebook.Info objUser = new JavaScriptSerializer().Deserialize<Facebook.Info>(facebookInfoJson);
                    CallLoginService(true, objUser.email, hdnPuser.Value, Session["Project"].ToString(), Session["AxLanguages"].ToString(), tokenInfo.access_token);
                }
                Session.Remove("LoginWith");
            }
            else if (provider == "office365")
            {
                string officeDetail = SSOIdUser;
                if (officeDetail != string.Empty)
                {
                    string[] officeDetails = officeDetail.Split(new[] { "*$*" }, StringSplitOptions.None);
                    CallLoginService(true, officeDetails[1].ToString(), hdnPuser.Value, Session["Project"].ToString(), Session["AxLanguages"].ToString(), officeDetails[0].ToString());
                }
                Session.Remove("LoginWith");
            }
            else if (provider == "okta")
            {
                string officeDetail = SSOIdUser;
                if (officeDetail != string.Empty)
                {
                    string[] officeDetails = officeDetail.Split(new[] { "*$*" }, StringSplitOptions.None);
                    CallLoginService(true, officeDetails[1].ToString(), hdnPuser.Value, Session["Project"].ToString(), Session["AxLanguages"].ToString(), officeDetails[0].ToString());
                }
                Session.Remove("LoginWith");
            }
            else if (provider == "saml")
            {
                try
                {
                    string qstr = util.encrtptDecryptAES(Request.QueryString["res"], false);
                    string[] resQstr = qstr.Split('&');
                    string samlDetail = string.Empty;
                    foreach (var resVar in resQstr)
                    {
                        string[] resStr = resVar.Split('=');
                        if (resStr[0] == "Project")
                            Session["Project"] = resStr[1];
                        else if (resStr[0] == "AxLanguages")
                            Session["AxLanguages"] = resStr[1];
                        else if (resStr[0] == "isMobDevice")
                            isMobDevice = resStr[1];
                        else if (resStr[0] == "staySignIn")
                            staySignIn = resStr[1];
                        else if (resStr[0] == "code")
                            samlDetail = resStr[1];
                    }
                    if (samlDetail != string.Empty)
                    {
                        string[] samlDetails = samlDetail.Split(new[] { "*$*" }, StringSplitOptions.None);
                        CallLoginService(true, samlDetails[1].ToString(), hdnPuser.Value, Session["Project"].ToString(), Session["AxLanguages"].ToString(), samlDetails[0].ToString());
                    }
                }
                catch (Exception ex) { }
                Session.Remove("LoginWith");
            }
            else if (provider == "InternalSSO")
            {
                try
                {
                    string qstr = util.encrtptDecryptAES(Request.QueryString["InternalSSO"], false);
                    string[] resQstr = qstr.Split('&');
                    string interKey = string.Empty;
                    string uName = string.Empty;
                    foreach (var resVar in resQstr)
                    {
                        string[] resStr = resVar.Split('=');
                        if (resStr[0] == "proj")
                            Session["Project"] = resStr[1];
                        else if (resStr[0] == "username")
                            uName = resStr[1];
                        else if (resStr[0] == "uKey")
                            interKey = resStr[1];
                        else if (resStr[0] == "lang")
                            Session["AxLanguages"] = resStr[1];
                    }
                    if (interKey != string.Empty && uName != string.Empty)
                    {
                        Session["LoginWith"] = "InternalSSO";
                        CallLoginService(true, uName, "", Session["Project"].ToString(), Session["AxLanguages"].ToString(), interKey);
                    }
                }
                catch (Exception ex) { }
                Session.Remove("LoginWith");
            }
        }
        catch (Exception ex)
        {
            Session.Remove("LoginWith");
            Response.Redirect("error.aspx");
        }
    }

    /// <summary>
    /// Calling 3rd party web apis. 
    /// </summary>
    /// <param name="destinationUrl"></param>
    /// <param name="methodName"></param>
    /// <param name="requestJSON"></param>
    /// <returns></returns>
    public string MakeWebRequest(string destinationUrl, string methodName, string contentType = "", string requestJSON = "")
    {
        try
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(destinationUrl);
            request.Method = methodName;
            if (methodName == "POST")
            {
                byte[] bytes = System.Text.Encoding.ASCII.GetBytes(requestJSON);
                request.ContentType = contentType;
                request.ContentLength = bytes.Length;
                using (Stream requestStream = request.GetRequestStream())
                {
                    requestStream.Write(bytes, 0, bytes.Length);
                }
            }
            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }

            return null;
        }
        catch (WebException webEx)
        {
            return webEx.Message;
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        isMobDevice = hdnMobDevice.Value;
        hybridGUID = hdnHybridGUID.Value;
        hybridDeviceId = hdnHybridDeviceId.Value;
        timeZone = hdnTimeZone.Value;
        if (signedin.Checked)
            staySignIn = "true";
        else
            staySignIn = "false";
        //UserIsLoggedIn(false, axUserName.Value, axPassword.Value, hdnProjName.Value, hdnProjLang.Value, staySignIn);
        UserIsLoggedIn(false, axUserName.Value, hdnPuser.Value, hdnProjName.Value, hdnProjLang.Value, staySignIn);
    }

    protected bool UserIsLoggedIn(bool isSSO, string userName, string password, string project, string language, string signedIn)
    {
        bool isunlimited = false;
        if (ConfigurationManager.AppSettings["landingPageHTML"] != null && ConfigurationManager.AppSettings["landingPageHTML"].ToString() == "true")
        {
            string axInstance = util.CheckForAvailableProjects();
            if (axInstance != string.Empty)
            {
                var dsproj = axInstance.Split(',').AsEnumerable().Where(x => x.ToLower() == project.ToLower()).ToList();
                if (dsproj.Count() == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('Invalid Schema name.');", true);
                    return false;
                }
                else
                {
                    axProjs = dsproj[0];
                    var isProjValid = util.IsProjectValid(axProjs);
                    if (!isProjValid)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('Invalid Schema name.');", true);
                        return false;
                    }
                    else
                    {
                        Session["Project"] = axProjs;
                        hdnAxProjs.Value = axProjs;
                        selectProj.Style.Add("display", "none");
                        axSelectProj.Value = axProjs;
                        if (Session["queryProj"] != null)
                            Session["queryProj"] = axProjs;
                        project = axProjs;
                    }
                }
            }
        }
        try
        {
            if (Application["lstunlimited"] != null)
            {
                string lstunlimited = Application["lstunlimited"].ToString();
                var lstunlim = lstunlimited.Split(',').Where(x => x == project).ToList();
                if (lstunlim.Count > 0)
                {
                    isunlimited = true;
                }
            }
        }
        catch (Exception ex)
        {
            isunlimited = false;
        }
        if (isunlimited == false)
        {
            string existSid = string.Empty, existUser = string.Empty, existLic = string.Empty;
            existUser = userName;
            string checkValue = string.Empty;
            var loggedUserList = new List<string>();
            loggedUserList = util.GetUserList(project);
            if (loggedUserList != null)
                checkValue = string.Join(",", loggedUserList.Select(x => x.ToString()).ToList());
            if (loggedUserList != null && checkValue.IndexOf(existUser + "♦") != -1 && Session["loggedUserDetails"] == null)
            {
                var prevValue = loggedUserList.AsEnumerable().Where(x => x.Contains(existUser + "♦")).ToList();
                Session["loggedUserDetails"] = prevValue[0];
                Session["duplicateUser"] = isSSO + "♦" + userName + "♦" + password + "♦" + project + "♦" + language + "♦" + signedIn;
                if (hybridDeviceId != string.Empty && Session["loggedUserDetails"] != null)
                {
                    HybridLogin(userName, project, loggedUserList);
                    CallLoginService(isSSO, userName, password, project, language);
                    return false;
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:CheckIsUserLogged();", true);
                    return true;
                }
            }
            else if (Session["loggedUserDetails"] != null)
            {
                if (Session["axApps"] == null || Session["axApps"].ToString() == "")
                {
                    util.GetAxApps(project);
                }
                existSid = Session["loggedUserDetails"].ToString().Split('♦')[1].Split('♣')[0];
                existLic = Session["loggedUserDetails"].ToString().Split('♣')[1];
                string Svrlic_redis = string.Empty;
                if (existLic == "limited")
                {
                    string redisLicDetails = GetServerLicDetails();
                    if (redisLicDetails != string.Empty && !redisLicDetails.StartsWith("error:"))
                        Svrlic_redis = redisLicDetails;
                    if (Svrlic_redis == string.Empty)
                    {
                        string errorLog = logobj.CreateLog("Calling Signout ws", existSid, "Signout", "new");
                        string iXml = string.Empty;
                        iXml = "<root axpapp='" + project + "' sessionid='" + existSid + "' " + Svrlic_redis + " trace='" + errorLog + "'>";
                        if (Session["axApps"] != null && Session["axApps"].ToString() != "")
                            iXml += Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString();
                        iXml += "</root>";
                        string result = string.Empty;
                        ASBExt.WebServiceExt asbExt = new ASBExt.WebServiceExt();
                        result = asbExt.CallLogoutNewWS("Signout", iXml);
                        util.KillSession();
                        string scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                        scriptsPath = scriptsPath + "Axpert\\" + existSid;
                        if (Directory.Exists(scriptsPath) && existSid != "")
                        {
                            try
                            {
                                Directory.Delete(scriptsPath, true);
                            }
                            catch (Exception Ex)
                            {
                                //Do nothing
                            }
                        }
                    }
                }
                if (Svrlic_redis == string.Empty)
                    loggedUserList.Remove(existUser + "♦" + existSid + "♣" + existLic);
                util.SetUserList(project, loggedUserList);
                Session["loggedUserDetails"] = null;
                CallLoginService(isSSO, userName, password, project, language);
                return false;
            }
            else
            {
                CallLoginService(isSSO, userName, password, project, language);
                return false;
            }
        }
        else
        {
            CallLoginService(isSSO, userName, password, project, language);
            return false;
        }
    }

    protected void HybridLogin(string existUser, string project, List<string> loggedUserList)
    {
        string existSid = string.Empty, existLic = string.Empty;
        try
        {
            if (Session["axApps"] == null || Session["axApps"].ToString() == "")
            {
                util.GetAxApps(project);
            }
            existSid = Session["loggedUserDetails"].ToString().Split('♦')[1].Split('♣')[0];
            existLic = Session["loggedUserDetails"].ToString().Split('♣')[1];
            string Svrlic_redis = string.Empty;
            if (existLic == "limited")
            {
                string redisLicDetails = GetServerLicDetails();
                if (redisLicDetails != string.Empty && !redisLicDetails.StartsWith("error:"))
                    Svrlic_redis = redisLicDetails;
                if (Svrlic_redis == string.Empty)
                {
                    string errorLog = logobj.CreateLog("Calling Signout ws", existSid, "Signout", "new");
                    string iXml = string.Empty;
                    iXml = "<root axpapp='" + project + "' sessionid='" + existSid + "' " + Svrlic_redis + " trace='" + errorLog + "'>";
                    if (Session["axApps"] != null && Session["axApps"].ToString() != "")
                        iXml += Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString();
                    iXml += "</root>";
                    string result = string.Empty;
                    ASBExt.WebServiceExt asbExt = new ASBExt.WebServiceExt();
                    result = asbExt.CallLogoutNewWS("Signout", iXml);
                    util.KillSession();
                    string scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                    scriptsPath = scriptsPath + "Axpert\\" + existSid;
                    if (Directory.Exists(scriptsPath) && existSid != "")
                    {
                        try
                        {
                            Directory.Delete(scriptsPath, true);
                        }
                        catch (Exception Ex)
                        {
                            //Do nothing
                        }
                    }
                }
            }
            if (Svrlic_redis == string.Empty)
                loggedUserList.Remove(existUser + "♦" + existSid + "♣" + existLic);
            util.SetUserList(project, loggedUserList);
            Session["loggedUserDetails"] = null;
        }
        catch (Exception ex) { }
    }

    private void CallLoginService(bool isSSO, string userName, string password, string project, string language, string ssoKey = "")
    {
        string redisLicDetails = GetServerLicDetails();
        if (redisLicDetails.StartsWith("error:"))
        {
            redisLicDetails = redisLicDetails.Replace("error:", "");
            string loginPath = Application["LoginPath"].ToString();
            //Response.Redirect(loginPath + "?lnmsg=" + redisLicDetails, false);
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + redisLicDetails + "');", true);
            return;
        }
        string proj = project;
        string browserDetails = GetBrowserDetails();
        LoginHelper login = new LoginHelper(proj, browserDetails);
        login.user = userName;
        login.password = password;
        login.selectedLanguage = language;
        login.isSSO = isSSO;
        login.isMobile = isMobDevice;
        login.timeZone = timeZone;
        login.hybridGUID = hybridGUID;
        login.hybridDeviceId = hybridDeviceId;
        login.hybridDefaultPage = hybridDefaultPage;
        login.staySignedId = staySignIn;
        login.lic_redis = redisLicDetails;
        login.lastOpenPage = hdnLastOpenpage.Value;
        login.loggedBroserId = hdnBwsrid.Value;
        login.diffTime = GetDiffTime();
        login.clientLocale = GetClientLocale(login.diffTime);
        if (isSSO)
        {
            switch (Session["LoginWith"].ToString())
            {
                case "google":
                    login.SsoName = "ga";
                    break;
                case "facebook":
                    login.SsoName = "fb";
                    break;
                case "office365":
                    login.SsoName = "of365";
                    break;
                case "okta":
                    login.SsoName = "ot";
                    break;
                case "windows":
                    login.SsoName = "windows";
                    break;
                case "saml":
                    login.SsoName = "saml";
                    break;
                case "InternalSSO":
                    login.SsoName = "InternalSSO";
                    break;
            }
            login.SSOType = login.SsoName;
            Session.Remove("LoginWith");
        }
        login.privateSsoToken = ssoKey;
        try
        {
            bool allowLogin = true;

            //if (IsPostBack && ConfigurationManager.AppSettings["enableCaptcha"] != null && ConfigurationManager.AppSettings["enableCaptcha"].ToString() == "true")
            //{
            //    allowLogin = DynamicCaptcha.Validate();
            //}


            if (allowLogin)
            {
                login.CallLoginService();
                requestProcess_logtime += login.result.Split('♠')[0];
                login.result = login.result.Split('♠')[1];
            }
            else
            {
                login.result = "<error><msg>Wrong Captcha, Please Try Again.</msg></error>";
            }

        }
        catch (Exception ex)
        {
            string strErrMsg = ex.Message;
            if (strErrMsg.ToLower().Contains("ora-"))
            {
                strErrMsg = "Error occurred(2). Please try again or contact administrator.";
            }
            else if (strErrMsg.Length > 50)
            {
                strErrMsg = strErrMsg.Substring(0, 50);
                strErrMsg += "...";
            }
            else
            {
                strErrMsg = ex.Message;
            }
        }
        finally
        {

        }
        if (login.result == string.Empty || login.result.StartsWith(Constants.ERROR) || login.result.Contains(Constants.ERROR))
        {
            XmlDocument xmldoc = new XmlDocument();
            xmldoc.LoadXml(login.result);
            string msg = string.Empty;
            XmlNode errorNode = xmldoc.SelectSingleNode("/error");
            if (login.result.Contains("\n"))
                login.result = login.result.Replace("\n", "");

            foreach (XmlNode msgNode in errorNode)
            {
                if (msgNode.Name == "msg")
                {
                    msg = msgNode.InnerText;
                    break;
                }
            }

            if (msg == string.Empty && errorNode.InnerText != string.Empty)
                msg = errorNode.InnerText;
            if (msg != string.Empty && msg.Contains("\n"))
                msg = msg.Replace("\n", "");
            string loginPath = Application["LoginPath"].ToString();
            string queryProj = string.Empty;
            if (Session["queryProj"] != null)
                queryProj = Session["queryProj"].ToString();

            //Unique Constraint Violation error
            if (msg.Contains("Duplicate entry") || msg.Contains("Violation of PRIMARY KEY constraint"))
            {
                Session["Project"] = proj;
                Session["nsessionid"] = login.sid;
                try
                {
                    Response.Redirect(HttpContext.Current.Application["SessExpiryPath"] + "?msg=" + msg, true);
                }
                catch (ThreadAbortException ex)
                {​​​​​ 
                 Thread.ResetAbort();
                }​​​​​
            }
            else if (msg.ToLower().Contains("ora-"))
            {
                msg = "Error occurred(2). Please try again or contact administrator.";
                ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
            }
        }
        else
        {
            foreach (var item in Session)
            {
                if (item.ToString() != "FDR" && item.ToString() != "allUrls" && item.ToString() != "urlIndex" && item.ToString() != "kernelTime")
                    login.sessions.Add(item.ToString(), Session[item.ToString()] != null ? Session[item.ToString()].ToString() : null);
                else if (item.ToString() == "allUrls" || item.ToString() == "urlIndex")
                    login.sessions.Add(item.ToString(), null);
            }
            Guid guid = Guid.NewGuid();
            string guidVal = project + "-" + userName + "-" + guid.ToString();
            try
            {
                FDW fdwObj = FDW.Instance;
                bool added = fdwObj.WriteKeyNoSchema(guidVal, Newtonsoft.Json.JsonConvert.SerializeObject(login), 5);
                if (added == false)
                    HttpContext.Current.Cache.Insert(guidVal, Newtonsoft.Json.JsonConvert.SerializeObject(login));
            }
            catch (Exception) { }
            strParams.Append("<input type=hidden name=\"hdnAxGKey\" value=\"" + guidVal + "\">");
            strParams.Append("<input type=hidden name=\"hdnLanguage\" value=\"" + login.selectedLanguage + "\">");
            strParams.Append("<input type=hidden name=\"hdnSSTime\" value=\"" + hdnSrtforLogin.Value + "\">");

            if (project == "bafco")//temporary code added to analyse the issue duplicate user issue in BACFO
            {
                string AxLoggedUser = userName + "~" + login.oldsid + "~" + login.sid + "~" + guidVal;
                strParams.Append("<input type=hidden name=\"hdnAxLoggedUser\" value=\"" + AxLoggedUser + "\">");
            }
            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response");

            string setIns = string.Empty;
            if (Session["queryProj"] != null)
                setIns = "javascript:SetInstance('" + project + "','" + login.sid + "','true','" + requestProcess_logtime + "','" + ObjExecTr.TotalServerElapsTime() + "');";
            else
                setIns = "javascript:SetInstance('" + project + "','" + login.sid + "','false','" + requestProcess_logtime + "','" + ObjExecTr.TotalServerElapsTime() + "');";
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", setIns + "window.document.form2.submit();", true);
        }
    }

    private string GetServerLicDetails()
    {
        string licdetails = string.Empty;
        try
        {
            string redisIp = string.Empty;
            string redisPwd = string.Empty;
            //if (ConfigurationManager.AppSettings["axpLic_RedisIp"] != null)
            //    redisIp = ConfigurationManager.AppSettings["axpLic_RedisIp"].ToString();

            //if (ConfigurationManager.AppSettings["axpLic_RedisPass"] != null)
            //    redisPwd = ConfigurationManager.AppSettings["axpLic_RedisPass"].ToString();
            if (HttpContext.Current.Session != null && HttpContext.Current.Session["axpLic_RedisIP"] != null && HttpContext.Current.Session["axpLic_RedisIP"].ToString() != "")
            {
                redisIp = HttpContext.Current.Session["axpLic_RedisIP"].ToString();
                if (HttpContext.Current.Session["axpLic_RedisPwd"] != null && HttpContext.Current.Session["axpLic_RedisPwd"].ToString() != "")
                    redisPwd = HttpContext.Current.Session["axpLic_RedisPwd"].ToString();
            }
            else
            {
                string rcDetails = util.GetAxpLicRedisConnDetails();
                if (rcDetails != "")
                {
                    redisIp = rcDetails.Split('♣')[0];
                    redisPwd = rcDetails.Split('♣')[1];
                }
            }

            if (redisIp != string.Empty)
            {
                string rlicConn = util.GetServerLicDetails(redisIp, redisPwd);
                switch (rlicConn)
                {
                    case "notConnected":
                        licdetails = "error:Redis Connection details for Axpert license is not proper. Please contact your support person.";
                        break;
                    case "keyNotExists":
                        licdetails = "error:Server seems to be not licensed. Please contact your support person.";
                        break;
                    case "keyNotMatch":
                        licdetails = "error:Redis IP for Axpert license should be set as 127.0.0.1. Please contact your support person.";
                        break;
                    case "keyExists":
                        if (redisPwd != string.Empty)
                            redisPwd = util.EncryptPWD(redisPwd);
                        licdetails = "lic_redis='" + redisIp + "~" + redisPwd + "'";
                        break;
                }
            }
            else
                licdetails = string.Empty;
        }
        catch (Exception ex)
        {
        }
        return licdetails;
    }

    private void OktaHelper()
    {

    }

    [WebMethod]
    public static string GetCurrLang(string name)
    {
        Util.Util utilObj = new Util.Util();
        return utilObj.GetConfigAttrValue(name, "AxLanguages");
    }

    [WebMethod]
    public static string GetCurrCopyRightTxt(string name, string lang)
    {
        Util.Util utilObj = new Util.Util();
        return utilObj.GetConfigAttrValue(name, "AxCopyRightText", lang);
    }

    protected void GoogleBtn_Click(object sender, EventArgs e)
    {
        isMobDevice = hdnMobDevice.Value;
        hybridGUID = hdnHybridGUID.Value;
        hybridDeviceId = hdnHybridDeviceId.Value;
        timeZone = hdnTimeZone.Value;
        if (signedin.Checked)
            staySignIn = "true";
        else
            staySignIn = "false";
        GetSocialCredentials("google");
    }

    protected void FacebookBtn_Click(object sender, EventArgs e)
    {
        isMobDevice = hdnMobDevice.Value;
        hybridGUID = hdnHybridGUID.Value;
        hybridDeviceId = hdnHybridDeviceId.Value;
        timeZone = hdnTimeZone.Value;
        if (signedin.Checked)
            staySignIn = "true";
        else
            staySignIn = "false";
        GetSocialCredentials("facebook");
    }

    protected void RenderLandingPage()
    {
        string headerPath = string.Empty;
        string headerPathFull = string.Empty;
        string templateText = "";
        string isCustomHtml = "";
        if (ConfigurationManager.AppSettings["landingPageHTML"] != null)
            isCustomHtml = ConfigurationManager.AppSettings["landingPageHTML"].ToString();
        if (isCustomHtml == "true" && hybridGUID == string.Empty)
        {
            try
            {
                if (Session["Project"] != null)
                    headerPath = "~/CustomPages/" + Session["Project"].ToString() + ".html";

                if (headerPath == string.Empty || (headerPath != string.Empty && !File.Exists(Server.MapPath(headerPath))))
                    headerPath = "~/CustomPages/AgBizLandingPage.html";

                if (File.Exists(Server.MapPath(headerPath)))
                    headerPathFull = Server.MapPath(headerPath);

                if (headerPathFull != string.Empty)
                    templateText = File.ReadAllText(headerPathFull);
            }
            catch (Exception ex)
            {
                LogFile.Log logObj = new LogFile.Log();
                logObj.CreateLog("LoginPage Templete - \n\tPath- " + headerPath + "\n\tError - " + ex.Message, HttpContext.Current.Session.SessionID, "LoginPage Templete", "");

            }
            LandPageTemplate.Text = templateText;
        }

        if (templateText == string.Empty)
        {
            divPanelSignin.Style.Add("display", "block");
            SigninTemplate.Style.Add("display", "none");
        }
    }

    private string GetBrowserDetails()
    {
        System.Web.HttpBrowserCapabilities browser = HttpContext.Current.Request.Browser;
        string browserDetails = string.Empty;
        if (isMobDevice == "True")
        {
            string lattitude = "", longitude = "";
            if (hybridGUID != string.Empty)
            {
                string hybridInfo = string.Empty;
                try
                {
                    FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                    if (fObj == null)
                    {
                        fObj = new FDR();
                    }
                    hybridInfo = fObj.StringFromRedis(util.GetRedisServerkey(Constants.AXHYBRIDINFO, hybridGUID), "♠");

                }
                catch (Exception ex) { }

                if (hybridInfo != string.Empty)
                {
                    try
                    {
                        JObject parsedHybridInfo = JObject.Parse(hybridInfo);
                        lattitude = parsedHybridInfo["location"]["coords"]["latitude"].ToString();
                        longitude = parsedHybridInfo["location"]["coords"]["longitude"].ToString();

                    }
                    catch (Exception ex) { }
                }
                browserDetails = "hyb" + "~" + hybridGUID + "~" + lattitude + "~" + longitude + "¿" + timeZone + "¿" + browser.Type + "¿" + browser.Browser + "¿"
                   + browser.Version + "¿" + browser.MajorVersion + "¿"
                   + browser.MinorVersion + "¿" + browser.Platform + "¿"
                   + HttpContext.Current.Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"];
            }
            else
            {
                browserDetails = "hyb¿" + timeZone + "¿" + browser.Type + "¿" + browser.Browser + "¿"
                    + browser.Version + "¿" + browser.MajorVersion + "¿"
                    + browser.MinorVersion + "¿" + browser.Platform + "¿"
                    + HttpContext.Current.Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"];
            }
        }
        else
        {
            browserDetails = timeZone + "¿" + browser.Type + "¿" + browser.Browser + "¿"
                + browser.Version + "¿" + browser.MajorVersion + "¿"
                + browser.MinorVersion + "¿" + browser.Platform + "¿"
                + HttpContext.Current.Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"];
        }

        if (browserDetails.Length > 200)
            browserDetails = browserDetails.Substring(0, 200);

        return browserDetails;
    }

    protected void WindowsBtn_Click(object sender, EventArgs e)
    {
        if (ConfigurationManager.AppSettings["ssowindowsdomain"] != null && ConfigurationManager.AppSettings["ssowindowsdomain"].ToString() != string.Empty)
        {
            string domainName = ConfigurationManager.AppSettings["ssowindowsdomain"].ToString();
            string[] dname = domainName.Split('.');
            string adPath = string.Empty;
            if (dname.Length > 0)
            {
                adPath = "LDAP://" + domainName + "/";
                foreach (var dcItem in dname)
                {
                    adPath += "DC=" + dcItem + ",";
                }
                adPath = adPath.Remove(adPath.Length - 1, 1);
            }
            LdapAuthentication adAuth = new LdapAuthentication(adPath);
            try
            {
                Session["LoginWith"] = "windows";
                if (true == adAuth.IsAuthenticated(domainName, axUserName.Value, hdnPuser.Value))
                {
                    string SSOKey = adAuth._guid;
                    string groups = adAuth.GetGroups();
                    FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(1, axUserName.Value, DateTime.Now, DateTime.Now.AddMinutes(60), false, groups);
                    string encryptedTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                    Response.Cookies.Add(authCookie);
                    // Response.Redirect(FormsAuthentication.GetRedirectUrl(axUserName.Value, false));

                    isMobDevice = hdnMobDevice.Value;
                    hybridGUID = hdnHybridGUID.Value;
                    hybridDeviceId = hdnHybridDeviceId.Value;
                    timeZone = hdnTimeZone.Value;
                    if (signedin.Checked)
                        staySignIn = "true";
                    else
                        staySignIn = "false";

                    string thisProj = string.Empty;
                    if (Session["Project"] != null)
                        thisProj = Session["Project"].ToString();
                    else
                        thisProj = axSelectProj.Value;

                    string thisLang = string.Empty;
                    if (Session["AxLanguages"] != null)
                        thisLang = Session["AxLanguages"].ToString();
                    else
                        thisLang = hdnProjLang.Value;
                    CallLoginService(true, axUserName.Value, hdnPuser.Value, thisProj, thisLang, SSOKey);
                }
                else
                {
                    string loginPath = Application["LoginPath"].ToString();
                    string queryProj = string.Empty;
                    if (Session["queryProj"] != null)
                        queryProj = Session["queryProj"].ToString();
                    string msg = "Authentication failed, check username and password.";
                    ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
                }
                Session.Remove("LoginWith");
            }
            catch (Exception ex)
            {
                Session.Remove("LoginWith");
                ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + ex.Message.ToString().Replace("\r\n", "") + "');", true);
                return;
            }
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('Authentication failed, check windows doamin name.');", true);
            return;
        }
    }

    protected void HybridAppKeepSigninDetails(string hybridDevId, string projName)
    {
        string hybridDetails = string.Empty;
        try
        {
            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            if (fObj == null)
            {
                fObj = new FDR();
            }
            hybridDetails = fObj.ReadKeyNoSchema(fObj.MakeKeyName(Constants.REDISHYBRIDINFO, hybridDevId));
            if (hybridDetails != string.Empty)
            {
                string urlDomain = System.Web.HttpContext.Current.Request.Url.ToString();
                urlDomain = urlDomain.Substring(0, urlDomain.ToLower().IndexOf("/aspx/"));
                string savedUrl = hybridDetails.Split('~')[5];
                string prjName = hybridDetails.Split('~')[0];
                if (savedUrl == urlDomain && prjName == projName)
                {
                    signedin.Checked = true;
                    axSelectProj.Value = hybridDetails.Split('~')[0];
                    axUserName.Value = hybridDetails.Split('~')[1];
                    KeepMeAutoPwd = hybridDetails.Split('~')[2];
                    hdnProjLang.Value = hybridDetails.Split('~')[4];
                    KeepMeAutoLogin = "true";
                }
                else
                {
                    KeepMeAutoLogin = "false";
                    signedin.Checked = true;
                }
            }
            else
            {
                KeepMeAutoLogin = "false";
                signedin.Checked = true;
            }
        }
        catch (Exception ex) { }
    }

    protected string GetDiffTime()
    {
        string diffTime = string.Empty;
        try
        {
            string btForLogin = hdnbtforLogin.Value;
            if (btForLogin == string.Empty)
            {
                btForLogin = btforDupLogin;
                btforDupLogin = string.Empty;
            }
            DateTime bst = DateTime.Parse(btForLogin);
            diffTime = bst.Subtract(DateTime.Parse(hdnSrtforLogin.Value)).TotalMilliseconds.ToString();
            //logobj.CreateLog("Calling server and client time diff ServerTime:" + hdnSrtforLogin.Value + " ClientTime:" + bst + " DiffTime:" + diffTime + " CurrentServerTime:" + DateTime.Now.ToString(), "difftime", "difftime" + Session.SessionID, "new", "true");
        }
        catch (Exception ex) { }
        return diffTime;
    }

    protected void IsLicExist()
    {
        try
        {
            bool licExist = false;
            string redisLicDetails = GetServerLicDetails();
            if (redisLicDetails != string.Empty && !redisLicDetails.StartsWith("error:"))
                licExist = true;
            else
            {
                string ScriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                string[] files = System.IO.Directory.GetFiles(ScriptsPath, "*.lic");
                if (files.Count() > 0)
                {
                    licExist = true;
                }
            }
            if (licExist == false)
            {
                if (ConfigurationManager.AppSettings["EnableAxpertConfiguration"] != null && ConfigurationManager.AppSettings["EnableAxpertConfiguration"].ToString() == "true")
                    Response.Redirect("config.aspx", true);
            }
        }
        catch (Exception ex) { }
    }

    protected void SamlBtn_Click(object sender, EventArgs e)
    {
        try
        {
            Session["LoginWith"] = "saml";
            isMobDevice = hdnMobDevice.Value;
            hybridGUID = hdnHybridGUID.Value;
            hybridDeviceId = hdnHybridDeviceId.Value;
            timeZone = hdnTimeZone.Value;
            if (signedin.Checked)
                staySignIn = "true";
            else
                staySignIn = "false";
            Session["Project"] = axSelectProj.Value;
            Session["AxLanguages"] = hdnProjLang.Value;

            //TODO: specify the SAML provider url here, aka "Endpoint"
            var samlEndpoint = ConfigurationManager.AppSettings["SamlPartnerIdP"].ToString();
            string returnUrl = ConfigurationManager.AppSettings["ssoredirecturl"].ToString();
            returnUrl += "aspx/samlresponse.aspx?Project=" + Session["Project"].ToString() + "&AxLanguages=" + Session["AxLanguages"].ToString() + "&isMobDevice=" + isMobDevice + "&staySignIn=" + staySignIn;
            string SamlIdentifier = ConfigurationManager.AppSettings["SamlIdentifier"].ToString();
            var request = new AuthRequest(SamlIdentifier, returnUrl);

            //redirect the user to the SAML provider
            //return Redirect(request.GetRedirectUrl(samlEndpoint));
            Response.Redirect(request.GetRedirectUrl(samlEndpoint));
        }
        catch (Exception ex)
        {
            Session.Remove("LoginWith");
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + ex.Message.ToString().Replace("\r\n", "") + "');", true);
            return;
        }
    }


    [WebMethod]
    public static string KeepSigninWebDetailsNew(string hdnBwsrid)
    {
        string result = "";
        string kaDetails = string.Empty;
        try
        {
            Util.Util utilObj = new Util.Util();
            string ipad = utilObj.GetIpAddress();
            ipad = ipad.Replace(".", "1");
            string brOwner = hdnBwsrid;
            string urlDomain = System.Web.HttpContext.Current.Request.Url.ToString();
            urlDomain = urlDomain.Substring(0, urlDomain.ToLower().IndexOf("/aspx/"));
            ipad += "-" + brOwner + "-" + urlDomain;
            LogFile.Log logobj = new LogFile.Log();
            //logobj.CreateLog("Owner:" + brOwner, "BrowserInfo", "BrowserInfo", "", "true");

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            if (fObj == null)
            {
                fObj = new FDR();
            }

            string rsKey = fObj.MakeKeyName(Constants.REDISKEEPWEBINFO, ipad);
            var KeysList = fObj.GetAllKeys(rsKey, false);//Not getting keys due to contains of project name
            if (KeysList.Count > 0)
            {
                ArrayList lstNames = new ArrayList();
                foreach (var nameList in KeysList)
                {
                    lstNames.Add(nameList.ToString().Split(new[] { "keepaliveweb-" }, StringSplitOptions.None)[1]);
                }
                string strNames = string.Join(",", lstNames.ToArray());
                result = "{\"userlist\":\"" + strNames + "\"}";
            }
        }
        catch (Exception ex) { }
        return result;
    }

    [WebMethod]
    public static string loginKeepSigninUser(string usrName, string hdnBwsrid)
    {
        string result = "";
        try
        {
            Util.Util utilObj = new Util.Util();
            string ipad = utilObj.GetIpAddress();
            ipad = ipad.Replace(".", "1");
            string brOwner = hdnBwsrid;
            string urlDomain = System.Web.HttpContext.Current.Request.Url.ToString();
            urlDomain = urlDomain.Substring(0, urlDomain.ToLower().IndexOf("/aspx/"));
            ipad += "-" + brOwner + "-" + urlDomain;

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            if (fObj == null)
            {
                fObj = new FDR();
            }

            string rsKey = fObj.MakeKeyName(Constants.REDISKEEPWEBINFO, ipad) + "-" + usrName;
            string kaDetails = fObj.ReadKeyNoSchema(rsKey);
            if (kaDetails != string.Empty)
            {
                string savedUrl = kaDetails.Split('~')[4];
                if (savedUrl == urlDomain)
                    result = "{\"signedin\":\"true\",\"axSelectProj\":\"" + kaDetails.Split('~')[0] + "\",\"axUserName\":\"" + kaDetails.Split('~')[1] + "\",\"KeepMeAutoPwd\":\"" + kaDetails.Split('~')[2] + "\",\"axLanguage\":\"" + kaDetails.Split('~')[3] + "\",\"hdnLastOpenpage\":\"" + kaDetails.Split('~')[6] + "\",\"ssotype\":\"" + kaDetails.Split('~')[7] + "\"}";
            }
        }
        catch (Exception ex)
        {
            result = "";
        }
        return result;
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        bool allowLogin = true;

        if (IsPostBack && ConfigurationManager.AppSettings["enableCaptcha"] != null && ConfigurationManager.AppSettings["enableCaptcha"].ToString() == "true")
        {
            allowLogin = DynamicCaptcha.Validate();
        }

        if (allowLogin)
        {
            if (hdnProjName.Value == "")
            {
                string msg = "<error><msg>Invalid Schema name.</msg></error>";
                ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
            }
            else if (axUserName.Value == "")
            {
                string msg = "<error><msg>Please enter your username.</msg></error>";
                ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
            }
            else
            {
                string axInstance = util.CheckForAvailableProjects();
                if (axInstance != string.Empty)
                {
                    var dsproj = axInstance.Split(',').AsEnumerable().Where(x => x.ToLower() == hdnProjName.Value.ToLower()).ToList();
                    if (dsproj.Count() == 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('Invalid Schema name.');", true);
                    }
                    else
                    {
                        if (util.GetConfigAttrValue(hdnProjName.Value, "AxUserLevelLang") == "true")
                        {
                            //DB Call
                            util.GetAxApps(hdnProjName.Value);
                            string ulLang = util.GetUserLevelLangFromDB(axUserName.Value);
                            if (ulLang != string.Empty)
                                hdnLangs.Value = ulLang;
                            else
                                hdnLangs.Value = util.GetConfigAttrValue(hdnProjName.Value, "AxLanguages");
                        }
                        else
                            hdnLangs.Value = util.GetConfigAttrValue(hdnProjName.Value, "AxLanguages");
                        panelUser.Visible = false;
                        StringBuilder sb = new StringBuilder();
                        sb.Append("<div class=\"control-group\"><div class=\"fv-row mb-4 fv-plugins-icon-container\"><div class=\"input-icon left\"><div class=\"d-flex flex-stack mb-2\"><asp:Label ID=\"lblpwd\" class=\"form-label fw-boldest text-dark fs-6 mb-0\" runat=\"server\" meta:resourcekey=\"lblpwd\">Password</asp:Label></div><input id=\"axPassword\" runat=\"server\" class=\"m-wrap placeholder-no-fix form-control form-control-solid\" tabindex=\"1\" type=\"password\" autocomplete=\"off\" placeholder=\"\" name=\"axPassword\" title=\"Password\" required /><div class=\"fv-plugins-message-container invalid-feedback\"></div></div></div></div>");
                        sb.Append("<div class=\"hide control-group\" id=\"axLangFld\" runat=\"server\"><div class=\"fv-row my-8 mb-4 fv-plugins-icon-container\"><div class=\"input-icon left\"><div class=\"d-flex flex-stack mb-1\"><asp:Label ID=\"lblslctlang\" class=\"form-label fs-6 fw-boldest text-dark\" runat=\"server\" meta:resourcekey=\"lblslctlang\">Select Language</asp:Label></div><select class=\"form-select form-select-solid\" data-control=\"select2\" data-placeholder=\"Select Language\" data-allow-clear=\"true\" tabindex=\"3\" id=\"axLanguage\" name=\"axLanguage\" runat=\"server\" value=''></select><div class=\"fv-plugins-message-container invalid-feedback\"></div></div></div></div>");

                        sb.Append("<div class=\"control-group my-8 mb-12\"><a href=\"javascript:void(0)\" class=\"link-primary fs-6 fw-boldest\" tabindex=\"5\" onclick=\"OpenForgotPwdNew()\"><asp:label id=\"lblForgot\" runat=\"server\" meta:resourcekey=\"lblForgot\">Forgot password?</asp:label></a></div>");

                        sb.Append("<div class=\"form-actions d-flex flex-row flex-column-fluid\"><div class=\"d-flex flex-row-fluid justify-content-between\"><a href=\"javascript:void(0)\" tabindex=\"4\" id=\"btnBackLink\" class=\"text-gray-600 d-flex my-auto fs-4 mt-4\" onclick=\"backToMainDiv()\"><span class=\"material-icons material-icons-style\">chevron_left</span>Back</a><input type=\"button\" value=\"Login\" title=\"Login\" TabIndex=\"2\" ID=\"btnSubmitNew\" class=\"btn btn-lg btn-primary mb-5 w-50\" onclick=\"return chkLoginFormHiden();\" /></div></div>");
                        panelSignin.Visible = true;
                        panelUser.Visible = false;
                        panelPwd.Text = sb.ToString();
                    }
                }
            }
        }
        else
        {
            string msg = "<error><msg>Wrong Captcha, Please Try Again.</msg></error>";
            ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
        }
    }

    protected string GetClientLocale(string timeDiff)
    {
        string strCL = string.Empty;
        try
        {
            strCL = hdnClientDt.Value;
            strCL = strCL + "*" + timeDiff;
        }
        catch (Exception ex)
        { }
        return strCL;
    }
}
