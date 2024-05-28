using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.SessionState;
/// <summary>
/// Summary description for NewLogin
/// </summary>
[Serializable()]
public class LoginHelper
{
    public string axApps { get; set; }
    public string axProps { get; set; }
    public string AxCloudDb { get; set; }
    public string ipaddress { get; set; }
    public string rnd_key { get; set; }
    public string userDetails { get; set; }
    public string proj { get; set; }
    public string sid { get; set; }
    public string user { get; set; }
    public string isMobile { get; set; }
    public string timeZone { get; set; }
    public string hybridGUID { get; set; }
    public string hybridDeviceId { get; set; }
    public string hybridDefaultPage { get; set; }
    public string staySignedId { get; set; }
    public string privateSsoToken { get; set; }
    public string SsoName { get; set; }
    public string lic_redis { get; set; }
    public string lastOpenPage { get; set; }
    public string loggedBroserId { get; set; }
    public string diffTime { get; set; }
    public string oldsid { get; set; }
    public string SSOType { get; set; }

    public string clientLocale { get; set; }

    public bool isSSO
    {
        get { return IsSSO; }
        set
        {
            IsSSO = value;
            if (isSSO)
            {
                privateSsoToken = "";
                SsoName = "";
            }
            else
            {
                privateSsoToken = string.Empty;
                SsoName = string.Empty;
            }
        }
    }

    private string Password;




    public string password
    {
        get { return Password; }
        set
        {
            Password = value;
            if (!string.IsNullOrEmpty(Password))
            {
                Random rand = new Random();
                rnd_key = rand.Next(1000, 9999).ToString();

                HashedPassword = MD5Hash(rnd_key + MD5Hash(Password));
            }
        }
    }

    public static string MD5Hash(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();

        //compute hash from the bytes of text  
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));

        //get hash result after compute it  
        byte[] result = md5.Hash;

        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            //change it into 2 hexadecimal digits  
            //for each byte  
            strBuilder.Append(result[i].ToString("x2"));
        }

        return strBuilder.ToString();
    }

    private string HashedPassword { get; set; }
    public string pwd { get; set; }
    public string errlog { get; set; }
    public string lang_attr { get; set; }
    public string licDetails { get; set; }
    public string result { get; set; }
    public string loginTrace { get; set; }
    private string loginXml { get; set; }
    public string selectedLanguage { get; set; }
    private bool IsSSO;


    public Dictionary<string, string> sessions = new Dictionary<string, string>();


    LogFile.Log logobj = new LogFile.Log();
    Util.Util util = new Util.Util();
    public LoginHelper()
    {

    }

    public LoginHelper(string projectName, string browserDetails)
    {

        proj = projectName;
        util.GetAxApps(projectName);
        axApps = HttpContext.Current.Session["axApps"].ToString();
        userDetails = browserDetails;
        if (HttpContext.Current.Session["AxCloudDB"] != null)
            AxCloudDb = HttpContext.Current.Session["AxCloudDB"].ToString();
        ipaddress = util.GetIpAddress();

        axProps = HttpContext.Current.Application["axProps"].ToString();
        oldsid = HttpContext.Current.Session.SessionID;
        System.Web.Configuration.SessionStateSection sessionStateSection = (System.Web.Configuration.SessionStateSection)ConfigurationManager.GetSection("system.web/sessionState");
        string cookieName = sessionStateSection.CookieName;

        HttpCookie mycookie = new HttpCookie(cookieName);
        mycookie.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(mycookie);
        System.Web.HttpContext.Current.Session.Abandon();

        SessionIDManager manager = new SessionIDManager();
        manager.RemoveSessionID(System.Web.HttpContext.Current);
        var newId = manager.CreateSessionID(System.Web.HttpContext.Current);
        var isRedirected = true;
        var isAdded = true;
        manager.SaveSessionID(System.Web.HttpContext.Current, newId, out isRedirected, out isAdded);
        sid = newId;
        loginTrace = ConfigurationManager.AppSettings["LoginTrace"].ToString();
    }

    private void GetLoginXml()
    {
        if (loginTrace.ToLower() == "true")
            errlog = logobj.CreateLog("Call to Login Web Service", sid, "login", "", "true");
        else
            errlog = logobj.CreateLog("Call to Login Web Service", sid, "login", "");
        if (selectedLanguage == string.Empty)
            selectedLanguage = "English";

        string lang_at = "";
        if (selectedLanguage != null && selectedLanguage.ToUpper() != "ENGLISH")
            lang_at = " lang=\"" + selectedLanguage + "\"";
        string scriptsPath = "";
        if (ConfigurationManager.AppSettings["scriptsUrlPath"] != null)
            scriptsPath = ConfigurationManager.AppSettings["scriptsUrlPath"].ToString();
        string isInternalSSO = string.Empty;
        if (SsoName != "" && SsoName == "InternalSSO")
        {
            isInternalSSO = " internalsso=\"yes\" appsessionkey=\"" + privateSsoToken + "\" ";
            privateSsoToken = "";
            SsoName = "";
            isSSO = false;
        }

        if (isSSO)
        {
            if (rnd_key == string.Empty)
            {
                Random rand = new Random();
                rnd_key = rand.Next(1000, 9999).ToString();
            }
            loginXml = "<login " + lang_at + isInternalSSO + " singleloginkey=\"" + privateSsoToken + "\" ssoname=\"" + SsoName + "\" " + lic_redis + " clouddb ='" + AxCloudDb + "' ip='" + ipaddress + "' other='" + userDetails + "'  seed='" + rnd_key + "'  axpapp='" + proj + "' sessionid='" + sid + "' username='" + user + "' password='' url='' direct='t' scriptpath='" + scriptsPath + "' axp_clientlocale='" + clientLocale + "' trace='" + errlog + "' " + lang_attr + licDetails + ">" + axApps + axProps + "</login>";
        }
        else
        {
            loginXml = "<login " + lang_at + isInternalSSO + " clouddb='" + AxCloudDb + "' " + lic_redis + " ip='" + ipaddress + "' other='" + userDetails + "' timediff='" + diffTime + "' seed='" + rnd_key + "'  axpapp='" + proj + "' sessionid='" + sid + "' username='" + user + "' password='" + HashedPassword + "' url='' direct='t' scriptpath='" + scriptsPath + "' axp_clientlocale='" + clientLocale + "' trace='" + errlog + "' " + lang_attr + licDetails + ">" + axApps + axProps + "</login>";
        }
    }


    public void CallLoginService()
    {
        GetLoginXml();
        ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallLoginWS("main", loginXml);
    }
}
