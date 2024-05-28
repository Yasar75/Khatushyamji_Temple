<%@ WebHandler Language="C#" Class="TstGridFileUpload" %>

using System;
using System.Web;
using System.IO;
using System.Collections;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class TstGridFileUpload : IHttpHandler, IRequiresSessionState
{
    Util.Util util = new Util.Util();
    int attachmentSizeMB = 1;
    long lMaxFileSize = 1000000;
    string concatFileName = string.Empty;
    bool rncName = false;
    bool isLocalPath = false;
    bool isFileServer = false;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.Files.Count > 0)
        {
            HttpPostedFile file = context.Request.Files[0];
            string fname = file.FileName;
            string destFilePath = string.Empty;
            string fldNameId = string.Empty;
            string fldName = string.Empty;
            string dcNo = string.Empty;
            string attTransId = string.Empty;
            if (context.Request.QueryString["thisFld"] != null)
                fldNameId = context.Request.QueryString["thisFld"];

            if (context.Request.QueryString["attFldName"] != null)
                fldName = context.Request.QueryString["attFldName"];

            if (context.Request.QueryString["filePath"] != null)
                destFilePath = context.Request.QueryString["filePath"];
            if (context.Request.QueryString["dcNo"] != null)
                dcNo = context.Request.QueryString["dcNo"];
            if (context.Request.QueryString["attTransId"] != null)
                attTransId = context.Request.QueryString["attTransId"];
            //to get maximum attachment size from Config app
            if (context.Session["AxAttachmentSize"] != null)
                attachmentSizeMB = Convert.ToInt32(context.Session["AxAttachmentSize"]);
            lMaxFileSize = attachmentSizeMB * 1024 * 1024; //convert MB to Bytes

            destFilePath = GetDestFilePath(destFilePath, context);


            string authenticationStatus = string.Empty;
            if (destFilePath != string.Empty && util.GetAuthentication(ref authenticationStatus))
            {
                if (destFilePath != string.Empty && !destFilePath.EndsWith("\\"))
                    destFilePath += "\\";
                destFilePath = destFilePath.Replace("\\", "\\\\");
                if (!isLocalPath)
                {
                    if (fldName.ToLower() == "axp_gridattach_" + dcNo)
                        destFilePath += attTransId + "\\\\" + context.Session["username"].ToString() + "\\\\" + fldName + "\\\\";
                    else
                        destFilePath += attTransId + "\\\\" + fldName + "\\\\";
                }
                try
                {
                    DirectoryInfo di = new DirectoryInfo(destFilePath);
                    //' Determine whether the directory exists.
                    if (!di.Exists)
                        di.Create();
                    isFileServer = true;
                }
                catch (Exception ex)
                {
                    isFileServer = false;
                    destFilePath = HttpContext.Current.Application["scriptspath"].ToString() + "axpert\\" + context.Session.SessionID;
                    string thisPath = HttpContext.Current.Application["scriptsurlpath"].ToString() + "axpert//" + context.Session.SessionID + "//";
                    DirectoryInfo di = new DirectoryInfo(thisPath);
                    //' determine whether the directory exists.
                    if (!di.Exists)
                        di.Create();
                }
            }

            if (destFilePath == string.Empty)
            {
                context.Response.Write("error:File server path is empty / invalid.");
            }
            else
            {
                int idx = fldNameId.LastIndexOf("F");
                string rowNo = fldNameId.Substring(idx - 3, 3);
                HttpPostedFile httpAttFile = file;
                if ((httpAttFile != null) && (httpAttFile.ContentLength > 0))
                {
                    string thisFileName = Path.GetFileName(httpAttFile.FileName);
                    string Ext = thisFileName.Substring(thisFileName.LastIndexOf("."));
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    string json = js.Serialize(Constants.fileTypes);

                    try
                    {
                        if (!util.IsFileTypeValid(httpAttFile))
                        {
                            context.Response.Write("error:Invalid File.");
                            return;
                        }
                        else if (httpAttFile.ContentLength > lMaxFileSize)
                        {
                            context.Response.Write("error:File could not be uploaded. Filesize is more than " + lMaxFileSize + " MB");
                            return;
                        }
                        else if ((destFilePath + thisFileName).Length > 260)//display warning message if file path exceeds 260 characters
                        {
                            context.Response.Write("error:Too many characters in the filename");
                            return;
                        }
                        else if (json.Contains(httpAttFile.FileName.Substring(thisFileName.LastIndexOf(".")).ToLower()) == false)
                        {
                            context.Response.Write("error:Too many characters in the filename");
                            return;
                        }
                        else
                        {
                            if (isFileServer)
                            {
                                if (fldName.ToLower() == "axp_gridattach_" + dcNo)
                                {
                                    string fullPath = destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName;
                                    string attFldNameRow = fldName + int.Parse(rowNo);
                                    context.Session["attGridFileServer"] = (context.Session["attGridFileServer"] != null && context.Session["attGridFileServer"].ToString() != string.Empty) ? (context.Session["attGridFileServer"].ToString() + "♦" + attFldNameRow + "~" + fullPath) : (attFldNameRow + "~" + fullPath);
                                    //Save File on disk
                                    httpAttFile.SaveAs(destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName);//+ rowNo
                                    context.Response.Write("success:File uploaded successfully~filepath:" + destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName);
                                }
                                else
                                {
                                    string fullPath = destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName;
                                    string attFldNameRow = fldName + int.Parse(rowNo);
                                    context.Session["attGridFileServer"] = (context.Session["attGridFileServer"] != null && context.Session["attGridFileServer"].ToString() != string.Empty) ? (context.Session["attGridFileServer"].ToString() + "♦" + attFldNameRow + "~" + fullPath) : (attFldNameRow + "~" + fullPath);
                                    //Save File on disk
                                    httpAttFile.SaveAs(destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName);//+ rowNo
                                    context.Response.Write("success:File uploaded successfully~filepath:" + destFilePath + HttpContext.Current.Session["username"].ToString() + "-" + thisFileName);
                                }
                            }
                            else
                            {
                                httpAttFile.SaveAs(destFilePath + "\\" + thisFileName);//+ rowNo
                                context.Response.Write("success:File uploaded successfully~filepath:" + destFilePath + "\\" + thisFileName);
                            }
                        }
                    }
                    catch (Exception ex)//in case of an error
                    {
                        context.Response.Write("success:An Error Occured. Please Try Again!");
                    }
                }
            }
        }
        else
            context.Response.Write("error");
    }

    public string GetGlobalAttachPath(HttpContext context)
    {
        bool isLocalFolder = false;
        bool isRemoteFolder = false;
        string imagePath = string.Empty;
        string imageServer = string.Empty;
        string grdAttPath = string.Empty;
        string errorMessage = string.Empty;
        string mapUsername = string.Empty;
        string mapPassword = string.Empty;

        if (context.Session["AxpImageServerGbl"] != null)
        {
            imageServer = context.Session["AxpImageServerGbl"].ToString();
            imageServer = imageServer.Replace(";bkslh", @"\");
        }
        if (context.Session["AxpImagePathGbl"] != null)
        {
            imagePath = context.Session["AxpImagePathGbl"].ToString();
            imagePath = imagePath.Replace(";bkslh", @"\");

            if (imagePath.IndexOf(":") > -1)
                isLocalFolder = true;
            else if (imagePath.IndexOf(@"\") > -1)
                isRemoteFolder = true;
        }

        if (imagePath != string.Empty)
        {
            if (isLocalFolder || isRemoteFolder)
                grdAttPath = imagePath;
            else
                grdAttPath = imageServer + @"\" + imagePath;
        }
        else if (imageServer != string.Empty)
        {
            grdAttPath = imageServer;
        }
        else //If the global variables AxpimageServer and AxpImagePath is not defined
        {
            if (context.Session["AxGridAttachPath"] != null)
            {
                grdAttPath = context.Session["AxGridAttachPath"].ToString();
            }
        }
        return grdAttPath;
    }

    public string GetDestFilePath(string filePath, HttpContext context)
    {
        string destFilePath = string.Empty;
        try
        {
            string sid = string.Empty;
            if (context.Session["nsessionid"] != null)
                sid = context.Session["nsessionid"].ToString();
            string AttPath = string.Empty;
            if (filePath != "")// AxpFilePath_ field value 
            {
                string grdAttPath = string.Empty;
                if (context.Session["AxpImageServerGbl"] != null)
                {
                    grdAttPath = context.Session["AxpImageServerGbl"].ToString();
                    grdAttPath = grdAttPath.Replace(";bkslh", @"\");
                }
                if (filePath != string.Empty && filePath.Contains(":"))
                    grdAttPath = filePath;
                else if (grdAttPath != string.Empty)
                    grdAttPath = grdAttPath + "\\" + filePath;
                else if (grdAttPath == string.Empty && filePath != "")
                    grdAttPath = filePath;
                destFilePath = grdAttPath;
                isLocalPath = true;
            }
            else // Global var file server path 
            {
                destFilePath = GetGlobalAttachPath(context);
            }
        }
        catch (Exception ex)
        {
            destFilePath = string.Empty;
            throw ex;
        }
        return destFilePath;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}