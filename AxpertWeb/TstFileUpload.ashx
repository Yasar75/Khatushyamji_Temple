<%@ WebHandler Language="C#" Class="TstFileUpload" %>

using System;
using System.Web;
using System.IO;
using System.Collections;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class TstFileUpload : IHttpHandler, IRequiresSessionState
{
    Util.Util util = new Util.Util();
    int attachmentSizeMB = 1;
    long lMaxFileSize = 1000000;
    string concatFileName = string.Empty;
    bool rncName = false;
    bool isExpExtend = true;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.Files.Count > 0)
        {
            HttpPostedFile file = context.Request.Files[0];
            string fname = file.FileName;
            string filePath = string.Empty;
            string fldNameId = string.Empty;
            string fldName = string.Empty;
            string dcNo = string.Empty;
            string FileExt = string.Empty;
            if (context.Request.QueryString["thisFld"] != null)
                fldNameId = context.Request.QueryString["thisFld"];

            if (context.Request.QueryString["attFldName"] != null)
                fldName = context.Request.QueryString["attFldName"];

            if (context.Request.QueryString["filePath"] != null)
                filePath = context.Request.QueryString["filePath"];
            // thisFName
            if (context.Request.QueryString["dcNo"] != null)
                dcNo = context.Request.QueryString["dcNo"];
            if (context.Request.QueryString["fileExt"] != null)
                FileExt = context.Request.QueryString["fileExt"];
            //to get maximum attachment size from Config app
            if (context.Session["AxAttachmentSize"] != null)
                attachmentSizeMB = Convert.ToInt32(context.Session["AxAttachmentSize"]);
            lMaxFileSize = attachmentSizeMB * 1024 * 1024; //convert MB to Bytes

            filePath = GetDestFilePath(filePath, context);


            string authenticationStatus = string.Empty;
            if (filePath != string.Empty && util.GetAuthentication(ref authenticationStatus))
            {
                if (filePath != string.Empty && !filePath.EndsWith("\\"))
                    filePath += "\\";
                filePath = filePath.Replace("\\", "\\\\");
                DirectoryInfo di = new DirectoryInfo(filePath);
                //' Determine whether the directory exists.
                if (!di.Exists)
                    di.Create();
            }

            if (filePath == string.Empty)
            {
                context.Response.Write("error:File server path is empty / invalid.");
            }
            else
            {
                HttpPostedFile httpAttFile = file;
                if ((httpAttFile != null) && (httpAttFile.ContentLength > 0))
                {
                    string thisFileName = Path.GetFileName(httpAttFile.FileName);
                    string Ext = thisFileName.Substring(thisFileName.LastIndexOf("."));
                    //hdnType.Value = Ext;
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    string json = js.Serialize(Constants.fileTypes);

                    try
                    {
                        if (!util.IsFileTypeValid(httpAttFile))
                        {
                            //upsts.Value = "";
                            //fileuploadsts.Text = "[" + GetLocalResourceObject("lblInvFile.Text").ToString() + "]";
                            //fileuploadsts.ForeColor = System.Drawing.Color.Red;
                            //cmdSend.Enabled = false;
                            context.Response.Write("error:Invalid File.");
                            return;
                        }
                        else if (httpAttFile.ContentLength > lMaxFileSize)
                        {
                            //upsts.Value = "";
                            //fileuploadsts.Text = "[" + lblfilecn.Text + "]";
                            //fileuploadsts.ForeColor = System.Drawing.Color.Red;
                            //cmdSend.Enabled = false;
                            //break;
                            context.Response.Write("error:File could not be uploaded. Filesize is more than " + lMaxFileSize + " MB");
                            return;
                        }
                        else if ((filePath + thisFileName).Length > 260)//display warning message if file path exceeds 260 characters
                        {
                            //fileuploadsts.Text = "[" + GetLocalResourceObject("lblFileSaveErr.Text").ToString() + "]";
                            //fileuploadsts.ForeColor = System.Drawing.Color.Red;
                            //upsts.Value = "";
                            //cmdSend.Enabled = false;
                            //break;
                            context.Response.Write("error:Too many characters in the filename");
                            return;
                        }
                        else if (FileExt != string.Empty && FileExt.Contains(httpAttFile.FileName.Substring(thisFileName.LastIndexOf(".") + 1).ToLower()) == false)
                        {
                            context.Response.Write("error:Selected file type not allowed in this form as per the setting.");
                            return;
                        }
                        else if (json.Contains(httpAttFile.FileName.Substring(thisFileName.LastIndexOf(".")).ToLower()) == false)
                        {
                            //fileuploadsts.Text = "[" + GetLocalResourceObject("lblInvFileExt.Text").ToString() + "]";
                            //fileuploadsts.ForeColor = System.Drawing.Color.Red;
                            //cmdSend.Enabled = false;
                            //break;
                            context.Response.Write("error:Invalid File Extension.");
                            return;
                        }
                        else
                        {
                            //if (hdnAttName.Value == "")
                            //    break;

                            string fullPath = filePath + concatFileName + thisFileName;
                            if (isExpExtend == true)
                            {
                                if (File.Exists(fullPath))
                                {
                                    //ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:CheckIsFileExists();", true);
                                    //cmdSend.Enabled = false;
                                    //return;
                                    context.Response.Write("error:File already exists, please rename and upload again!");
                                    return;
                                }
                            }
                            ArrayList arListExist = new ArrayList();
                            string attFldName = fldName;
                            if (context.Session["AxpAttFileServer"] != null)
                                arListExist = (ArrayList)context.Session["AxpAttFileServer"];
                            if (arListExist.IndexOf(attFldName + "~" + fullPath) == -1)
                            {
                                arListExist.Add(attFldName + "~" + fullPath);
                                context.Session["AxpAttFileServer"] = arListExist;
                            }
                            //Save File on disk
                            httpAttFile.SaveAs(filePath + concatFileName + thisFileName);
                            //hdnaxpFileSavedPath.Value = filePath + concatFileName + thisFileName;
                            //fileuploadsts.Text = "[" + lblFileUp.Text + "]";
                            //fileuploadsts.ForeColor = System.Drawing.Color.Green;
                            //upsts.Value = "Uploaded Successfully";

                            context.Response.Write("success:File uploaded successfully~filepath:" + filePath + concatFileName + thisFileName + "♠" + concatFileName + thisFileName);
                            //if (rncName)
                            //{
                            //    randNumber.Value = "true";
                            //    fname.Value = concatFileName + thisFileName;
                            //}
                            //else
                            //    fname.Value = thisFileName;
                            //Page.ClientScript.RegisterStartupScript(this.GetType(), "DoClientFunction", "DoClientFunction()", true);
                        }
                    }
                    catch (Exception ex)//in case of an error
                    {
                        //fileuploadsts.Text = lblAnError.Text;
                        //upsts.Value = fileuploadsts.Text;
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
                destFilePath = AttPath = filePath;
                if (AttPath.EndsWith("*"))
                {
                    destFilePath = AttPath.Substring(0, AttPath.LastIndexOf('\\'));
                    concatFileName = AttPath.Substring(AttPath.LastIndexOf("\\") + 1).Replace("*", "");
                    if (concatFileName == string.Empty)
                    {
                        isExpExtend = false;
                        rncName = true;
                        Random rand = new Random();
                        string rnd_key = rand.Next(100000, 999999).ToString();
                        concatFileName = DateTime.Now.ToString("ddMMyyyyHHmmss") + rnd_key;
                    }
                }
            }
            else // Global var file server path 
            {
                isExpExtend = false;
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
