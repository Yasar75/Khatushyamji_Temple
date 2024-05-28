using ASBExt;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net.Configuration;
using System.Net;
using RestSharp;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
using System.Web.Script.Services;

namespace ASBCustom
{

    /// <summary>
    /// Summary description for customwebservice
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [ScriptService]
    public class CustomWebservice : System.Web.Services.WebService
    {
        Util.Util utilObj = new Util.Util();
        ASBExt.WebServiceExt asbExt = new ASBExt.WebServiceExt();
        LogFile.Log logobj = new LogFile.Log();

        [WebMethod(EnableSession = true)]
        public string CustomFunction()
        {
            string result = string.Empty;
            result = Session["project"].ToString();
            return result;
        }
        [WebMethod(EnableSession = true)]
        public string SetIvparams(string param)
        {
            string result = "done";
            Session["iviewcustomparams"] = param;
            return result;
        }
        [WebMethod(EnableSession = true)]
        public string GetChoices(string transid, string sqlQuery)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            string errorLog = logobj.CreateLog("Call GetChoices", Session["nsessionid"].ToString(), "CallGetChoices-" + transid + "", "new");
            string inputXML = string.Empty;
            inputXML = "<sqlresultset axpapp='" + Session["project"].ToString() + "' sessionid='" + Session["nsessionid"].ToString() + "' trace='" + errorLog + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "' ><sql>" + sqlQuery + "</sql>";
            inputXML += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
            string result = asbExt.CallGetChoiceWS(transid, inputXML);
            return result;
        }



        [WebMethod(EnableSession = true)]
        public string CreateFastReportPDF(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            TStructData tstData = (TStructData)Session[key];
            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "false", "ALL", "");
            s += "<varlist><row>" + tstData.fldValueXml + tstData.memVarsData + "</row></varlist>";
            s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;
            result = tstData.CallCreateFastPDFWS(s);
            return result;
        }


        [WebMethod()]
        public string HelloWorld()
        {
            string result = string.Empty;

            return "Hi Hello";
        }


        public string CheckDMSIntegration(string structid)
        {
            string dmsSql = string.Empty;
            string res = string.Empty;
            string errorLog = string.Empty;

            ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
            /*  dmsSql = "<sqlresultset axpapp='" + HttpContext.Current.Session["project"].ToString() + "' sessionid='" + HttpContext.Current.Session["nsessionid"].ToString() + "' trace='" + errorLog + "'><sql>select  url,add_view,dc, fieldnames from tomni  where dmsid = '" + structid + "' </sql>";
              dmsSql += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + "</sqlresultset>";
              res = objWebServiceExt.CallGetChoiceWS("", dmsSql);
              if (res.Contains(Constants.ERROR) == true)
              {
                  res = res.Replace(Constants.ERROR, "");
                  res = res.Replace("</error>", "");
                  res = res.Replace("\n", "");
                  throw (new Exception(res));
              }*/
            return res;


        }

        [WebMethod(EnableSession = true)]
        public string SendMail(string toAddress, string msgBody, string subject, string userMail)
        {

            string status = "Failure";
            try
            {
                MailMessage message = new MailMessage();
                SmtpClient smtp = new SmtpClient();
                NetworkCredential credential = (NetworkCredential)smtp.Credentials;

                string from = credential.UserName;
                string host = smtp.Host;
                int port = smtp.Port;
                bool enableSsl = smtp.EnableSsl;
                string user = credential.UserName;
                string password = credential.Password;

                message.From = new MailAddress(from);
                message.To.Add(new MailAddress(toAddress));
                message.CC.Add(from + "," + userMail);
                message.Subject = subject;
                message.IsBodyHtml = false; //to make message body as html  
                message.Body = msgBody;
                smtp.Port = port;
                smtp.Host = host; //for gmail host  
                smtp.EnableSsl = enableSsl;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(user, password);
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Send(message);
                status = "Success";
            }
            catch (Exception ex)
            {
                LogFile.Log logObj = new LogFile.Log();
                logObj.CreateLog("Send Mail -\n\tError - " + ex.Message, HttpContext.Current.Session.SessionID, "Send Mail", "");
            }
            return status;
        }

        [WebMethod]
        [ScriptMethod]
        public string SaveData(string uemail, string dob, string category, string ugender, string ssoid, string mob, string ename)
        {
            // Create the data object
            var data = new
            {
                savedata = new
                {
                    axpapp = "khatushyamapp",
                    username = "citizen",
                    password = "22723bbd4217a0abf6d3e68073c7603d",
                    transid = "ures",
                    s = "",
                    changedrows = new
                    {
                        dc2 = " * ",
                        dc3 = " * "
                    },
                    trace = "true",
                    recordid = "0",
                    recdata = new[]
                    {
                new
                {
                    axp_recid1 = new[]
                    {
                        new
                        {
                            rowno = "001",
                            text = "0",
                            columns = new
                            {
                                uemail = uemail,
                                dob = dob,
                                category = category,
                                ugender = ugender,
                                ssoid = ssoid,
                                mob = mob,
                                ename = ename
                            }
                        }
                    }
                }
            }
                }
            };

            // Convert the data object to JSON format
            string jsonData = JsonConvert.SerializeObject(data);

            // Send the data to the server
            var client = new RestClient("http://127.0.0.1/AxpertDeveloperScripts/ASBTStructRest.dll/datasnap/rest/TASBTStruct/savedata");
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", jsonData, ParameterType.RequestBody);

            IRestResponse response = client.Execute(request);

            // Add cache control headers to prevent caching
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HttpContext.Current.Response.Cache.SetNoStore();

            return response.Content;
        }

        //[WebMethod]
        //private void SendSMS()
        //{
        //    System.Net.ServicePointManager.SecurityProtocol =
        //    System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11 |
        //    System.Net.SecurityProtocolType.Tls;
        //    HttpClient client = new HttpClient();
        //    client.BaseAddress = new
        //    Uri("https://api.sewadwaar.rajasthan.gov.in/app/live/eSanchar/Prod/");
        //    object p = client.DefaultRequestHeaders.Add("username", "<user_name>");
        //    client.DefaultRequestHeaders.Add("password", "<password>");
        //    client.DefaultRequestHeaders.Accept.Add(new
        //    MediaTypeWithQualityHeaderValue("application/json"));
        //    MultipartFormDataContent form = new MultipartFormDataContent();
        //    System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate
        //    (
        //    Object obj, System.Security.Cryptography.X509Certificates.X509Certificate
        //    certificate, System.Security.Cryptography.X509Certificates.X509Chain chain,
        //    System.Net.Security.SslPolicyErrors errors)
        //    {
        //        return (true);
        //    };
        //    var inputparams = new ExternalSMSApiInfo();
        //    inputparams.UniqueID = < Unique_ID >;
        //    inputparams.serviceName = < Service_Name >;
        //    inputparams.language = "ENG" or "HIN";
        //    inputparams.message = < Message >;
        //    inputparams.mobileNo = List of Mobile Numbers;
        //    inputparams.templateID =< TemplateId >;
        //    var response =
        //    client.PostAsJsonAsync("api/OBD/CreateSMS/Request?client_id=<client_id>",
        //    inputparams).Result;
        //    var asyncResponse = response.Content.ReadAsStringAsync().Result;
        //    var jsonResponse = JObject.Parse(asyncResponse);
        //    string status = "Response Code: " + jsonResponse["responseCode"] +
        //    "\n\nResponse Message - " + jsonResponse["responseMessage"];
        //}
        ////oD3jJ8jN5rR4mO7yV1wG8iD7oE2mW6wY5kM1oX5vQ7uD3eD7pW
        //public class ExternalSMSApiInfo
        //{
        //    public string UniqueID { get; set; }
        //    public string serviceName { get; set; }
        //    public string language { get; set; }
        //    public string message { get; set; }
        //    public List<string> mobileNo { get; set; }
        //    public string templateID { get; set; }
        //}
    }
}