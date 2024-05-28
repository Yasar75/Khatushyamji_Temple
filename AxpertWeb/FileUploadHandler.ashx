<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.Web;
using System.IO;
using System.Data;
using System.Web.SessionState;
public class FileUploadHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                string fname = file.FileName;
                string sid = context.Session["nsessionid"].ToString();
                string ScriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                context.Response.ContentType = "text/plain";
                try
                {
                    DirectoryInfo di = new DirectoryInfo(ScriptsPath + "Axpert\\" + sid);
                    //' Determine whether the directory exists.
                    if (!di.Exists)
                    {
                        // create the directory.
                        di.Create();
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }

                string sFileName = System.IO.Path.GetFileName(fname.Substring(0, fname.IndexOf(".")));
                string sFileDir = ScriptsPath + "Axpert\\" + sid + "\\";
                long lMaxFileSize = 1000000;
                try
                {
                    if (file.ContentLength <= lMaxFileSize)
                    {
                        //Save File on disk
                        sFileName = DateTime.Now.ToString("ddMMyyymmssfffff") + Path.GetExtension(fname);
                        file.SaveAs(sFileDir +sFileName );
                        context.Response.Write("File Uploaded successfully &&"+sFileName);
                    }
                    else
                    {
                        context.Response.Write("File could not be uploaded. Filesize is more than 1MB.");
                    }
                }
                catch (Exception ex)//in case of an error
                {
                    context.Response.Write("An Error Occured. Please Try Again!");
                }
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