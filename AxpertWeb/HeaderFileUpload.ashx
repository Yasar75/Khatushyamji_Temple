<%@ WebHandler Language="C#" Class="HeaderFileUpload" %>

using System;
using System.Web;
using System.IO;
using System.Collections;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class HeaderFileUpload : IHttpHandler, IRequiresSessionState
{
    Util.Util util = new Util.Util();
    int attachmentSizeMB = 1;
    long lMaxFileSize = 1000000;
    string scriptsPath = string.Empty;
    string scriptsUrlPath = string.Empty;
    string sid = string.Empty;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.Files.Count > 0)
        {
            HttpPostedFile file = context.Request.Files[0];
            string fname = file.FileName;
            string act = string.Empty;

            if (context.Request.QueryString["act"] != null)
                act = context.Request.QueryString["act"];

            if (context.Session["nsessionid"] != null)
                sid = context.Session["nsessionid"].ToString();
            else
            {
                context.Response.Write("error:sessionexpired");
                return;
            }
            scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
            scriptsUrlPath = HttpContext.Current.Application["ScriptsurlPath"].ToString();
            //to get maximum attachment size from Config app
            if (context.Session["AxAttachmentSize"] != null)
                attachmentSizeMB = Convert.ToInt32(context.Session["AxAttachmentSize"]);
            lMaxFileSize = attachmentSizeMB * 1024 * 1024; //convert MB to Bytes

            try
            {

                DirectoryInfo di = new DirectoryInfo(scriptsPath + "Axpert\\" + sid);
                //' Determine whether the directory exists.
                if (di.Exists)
                {

                }
                else
                {
                    // create the directory.
                    di.Create();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            string sFileDir = scriptsPath + "Axpert\\" + sid + "\\";

            try
            {
                if (util.IsFileTypeValid(file))
                {
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    string json = js.Serialize(Constants.fileTypes);

                    if (file.ContentLength <= lMaxFileSize)
                    {
                        if ((sFileDir + fname).Length > 260)//display warning message if file path exceeds 260 characters
                        {
                            context.Response.Write("error:Too many characters in the filename");
                            return;
                        }
                        if (json.Contains(file.FileName.Substring(fname.LastIndexOf(".")).ToLower()) == false)//(Constants.fileTypes.Contains(filMyFile.PostedFile.FileName.Substring(sFileName.LastIndexOf(".")).ToLower()) == false)
                        {
                            context.Response.Write("error:Invalid File Extension");
                            return;
                        }
                        else
                        {
                            //Save File on disk
                            file.SaveAs(sFileDir + fname);
                            context.Response.Write("success:Uploaded Successfully");
                        }
                    }
                    else
                    {
                        context.Response.Write("error:File could not be uploaded. Filesize is more than " + lMaxFileSize + " MB");
                        return;
                    }
                }
            }
            catch (Exception ex)//in case of an error
            {
                context.Response.Write("error:An Error Occured. Please Try Again!");
            }

        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}