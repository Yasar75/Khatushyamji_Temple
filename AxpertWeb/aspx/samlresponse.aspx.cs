using System;
using System.Collections.Generic;
using System.Web.Security;
using Saml;
using System.Security.Cryptography.X509Certificates;
using System.IO;
using System.Configuration;
using System.Web;

public partial class samlresponse : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string SamlCertificate = ConfigurationManager.AppSettings["SamlCertificate"].ToString();
            string certificate = File.ReadAllText(Path.GetDirectoryName(System.AppDomain.CurrentDomain.BaseDirectory) + "/Saml_Certificates/" + SamlCertificate);
            Response samlResponse = new Response(certificate, Request.Form["SAMLResponse"]);
            if (samlResponse != null)
            {
                if (samlResponse.IsValid())
                {
                    //Session["LoggedInId"] = samlResponse.GetNameID();
                    //Session["SAML_USER_PROFILE"] = samlResponse.GetNameID();

                    Session["LoginWith"] = "saml";
                    Util.Util util = new Util.Util();
                    string qstr = "Project=" + Request.QueryString["Project"].ToString() + "&";
                    string wfenc = string.Empty;
                    bool isFromWF = false;
                    if (Request.QueryString["fromwf"] != null && Request.QueryString["fromwf"].ToString() == "true")
                    {
                        isFromWF = true;
                        wfenc = Request.QueryString["enc"] != null ? Request.QueryString["enc"].ToString() : "";
                    }
                    else
                    {
                        qstr += "AxLanguages=" + Request.QueryString["AxLanguages"].ToString() + "&";
                        qstr += "isMobDevice=" + Request.QueryString["isMobDevice"].ToString() + "&";
                        qstr += "staySignIn=" + Request.QueryString["staySignIn"].ToString() + "&";
                    }
                    string objectidentifier = samlResponse.GetCustomAttribute("http://schemas.microsoft.com/identity/claims/objectidentifier");
                    qstr += "code=" + objectidentifier + "*$*" + samlResponse.GetNameID();
                    qstr = util.encrtptDecryptAES(qstr);
                    string returnUrl = ConfigurationManager.AppSettings["ssoredirecturl"].ToString();
                    string targetUrl = string.Empty;
                    if (isFromWF)
                        targetUrl = returnUrl + "aspx/Workflownotification.aspx?res=" + qstr + "&enc=" + wfenc;
                    else
                        targetUrl = returnUrl + "aspx/signin.aspx?res=" + qstr;
                    Response.Redirect(targetUrl, false);
                }
                else
                {
                    Response.Redirect("~/aspx/Signin.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/aspx/Signin.aspx", false);
            }
        }
        catch (Exception ex)
        {
            Session.Remove("LoginWith");
            // In production application, we recommend logging the exception and redirecting the user to a generic error page.
            throw ex;
        }
    }
}

