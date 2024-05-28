using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Configuration;
using System.IO;
using System.Web.Caching;
using System.Collections;
using System.Text;
using CacheMgr;
using System.Xml;
using System.Diagnostics;
using System.Data;
using System.Linq;
using Axpert_Object;
using System.Threading;
using ASBExt;
using System.Text.RegularExpressions;
using Ionic.Zip;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Globalization;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Web.Script.Serialization;
using System.Web.Configuration;
using AxInterface;

namespace ASB
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.Web.Script.Services.ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        Util.Util utils = new Util.Util();
        public string strFillDepPName = string.Empty;
        public ArrayList arrFillList = new ArrayList();
        AxpertDotNet ads = new AxpertDotNet();
        public string axpert = "Axpert\\";
        public const string DATA = "data";
        LogFile.Log logobj = new LogFile.Log();
        Util.Util utilObj = new Util.Util();
        CacheMgr.CacheManager cm = new CacheMgr.CacheManager(string.Empty);
        ASBExt.WebServiceExt asbExt = new ASBExt.WebServiceExt();
        string project = string.Empty;
        string user = string.Empty;
        string AxRole = string.Empty;
        string sessionid = string.Empty;
        string transid = string.Empty;
        string ivname = string.Empty;
        public const int capacity = 10;
        List<string> allUrls = new List<string>(capacity);
        List<string> allUrlsIdx = new List<string>(capacity);
        ExecTrace ObjExecTr = ExecTrace.Instance;

        //Since the change theme is done in javascript, on postback the selected theme has to be saved in session.
        //Hence this function acts as a wrapper to update the theme in session and continue to update the db.
        [WebMethod(EnableSession = true)]
        public string UpdateTheme(string theme, string trace)
        {

            string inputXML = string.Empty;
            string result = string.Empty;

            if (trace != "♦♦GetChoicestoUpdateAppearance♦")
                return utilObj.ErrorMsgToJson("Invalid trace value.");

            bool themevalid = utilObj.IsChar(theme);
            if (!themevalid)
            {
                return utilObj.ErrorMsgToJson("Theme Invalid");
            }
            else
            {
                if (HttpContext.Current.Session["project"] == null)
                    return utilObj.SESSTIMEOUT;
                HttpContext.Current.Session["themeColor"] = theme;
                GetGlobalVars();
                inputXML = "<sqlresultset axpapp='" + project + "' transid='" + "" + "' sessionid='" + sessionid + "' trace='" + trace + "' >";
                inputXML += "<sql>Update axusers SET webskin='" + theme + "' where username='" + user + "'</sql>";
                inputXML += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                string iXML = GetTraceString(inputXML);
                if (iXML != string.Empty) inputXML = iXML;
                result = asbExt.CallGetChoiceWebService("", inputXML);
                return result;
            }

        }

        [WebMethod(EnableSession = true)]
        public string SaveDataXML(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList deletedFldArrayValues, string files, string rid, string delRows, string changedRows, string key, string axRulesFlds = "")
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;

            if (tstData.transID != "temps")
            {
                if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
                {
                    return Constants.MALICIOUSNPUTDETECTED;
                }
            }

            string result = string.Empty;
            DateTime eTime1 = DateTime.Now;

            Util.Util.DeletedraftRediskeys(tstData.transid);
            result = tstData.CallSaveDataWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, deletedFldArrayValues, files, rid, delRows, changedRows, axRulesFlds);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            DateTime sTime2 = DateTime.Now;
            if (!result.StartsWith(Constants.ERROR))
            {
                if (tstData.transid.ToLower() == "axglo")
                    Session["AxInternalRefresh"] = "true";
                if (tstData.IsDraftObj && HttpContext.Current.Session["AxEnableDraftSave"] != null && HttpContext.Current.Session["AxEnableDraftSave"].ToString() == "true")
                {
                    user = HttpContext.Current.Session["user"].ToString();
                    utilObj.DeleteDraft(user + "-" + tstData.transid, user);
                }
            }
            DateTime eTime2 = DateTime.Now;

            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;
            return result;
        }

        [WebMethod()]
        public void RemoveNewFiles(string f, string sid)
        {
            string ScriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();

            if ((!string.IsNullOrEmpty(f)))
            {
                //Create a Folder
                DirectoryInfo di = new DirectoryInfo(ScriptsPath + axpert + sid);
                //' Determine whether the directory exists.
                if (di.Exists)
                {
                    string outputPath = null;
                    outputPath = ScriptsPath + axpert + sid + "\\" + f;
                    //' Delete a file
                    File.Delete(outputPath);
                }
            }
        }

        [WebMethod(EnableSession = true)]
        private string GetTraceString(string currentXml)
        {
            string traceVal = string.Empty;
            string errlog = string.Empty;
            traceVal = currentXml;

            if (currentXml.Contains("_#") == true)
            {
                currentXml = currentXml.Replace("_#", "~");
            }

            string filename = string.Empty;
            int sindex = currentXml.IndexOf("♦♦");
            int eindex = currentXml.LastIndexOf("♦");

            if (sindex != -1 && eindex != -1)
            {
                filename = currentXml.Substring(sindex + 2, eindex - sindex - 2);
                sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                errlog = logobj.CreateLog("Executing Action", sessionid, filename, "new");
                traceVal = currentXml.Replace("♦♦" + filename + "♦", errlog);
            }

            if (traceVal.Contains("~") == true)
            {
                traceVal = traceVal.Replace("~", "_#");
            }
            if (traceVal != null && traceVal != "")// Reddy
            {
                if (traceVal.TrimStart().StartsWith("<root"))
                {
                    traceVal = traceVal.Replace("<root", "<root appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'");
                }
                else if (traceVal.TrimStart().StartsWith("<sqlresultset"))
                {
                    traceVal = traceVal.Replace("<sqlresultset", "<sqlresultset appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'");
                }
            }
            return traceVal;
        }

        [WebMethod(EnableSession = true)]
        public string DeleteDataXML(string rid, string s, string key, bool allowCancel = true)
        {
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if ((!utilObj.IsNumber(rid)) || (!utilObj.IsAlphaNumUnd(key)))// IsAlphaNum
                return "{\"error\":[{\"msg\":\"Error: Invalid parameter value.\"}]}";
            else if (!allowCancel)
            {
                sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                logobj.CreateLog("Delete Data: This transaction cannot be deleted. In workflow, 'Allow cancel after approval' is 'false'.", sessionid, "Delete-" + key, "new");
                return "{\"error\":[{\"msg\":\"This transaction cannot be deleted.\"}]}";
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string result = string.Empty;
            //s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</Transaction>";
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallDeleteDataWS(s);
            if (result.ToLower().Contains("success") && utilObj.isRealTimeCacEnabled(transid, tstData.tstStrObj))
                result = result + "*#*" + utilObj.GetAxRelations(tstData.transid);
            DateTime sTime2 = DateTime.Now;
            if (utilObj.IsFileInCache(tstData.transid, rid))
                utilObj.DeleteFromCache(result, rid, tstData.transid);
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string DeleteRowWS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string s, string key, string dcNo)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            TStructData tstData = (TStructData)Session[key];

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            if (tstData == null)
                return Constants.DUPLICATESESS;
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            string result = string.Empty;
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            string errorLog = logobj.CreateLog("Delete row webservice", sessionid, "DeleteRow-" + tstData.transid, "new");
            result = tstData.CallDeleteRowWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, dcNo);
            //TStructDef tstObj = utilObj.GetTstructDefObj("GetStructure", tstData.transid);
            tstData.JsonToArray(result, tstData.tstStrObj, "", "DeleteRow");
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string DeleteRowPerfWS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string s, string key, string dcNo)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;

            if (tstData.transID != "temps")
            {
                if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
                {
                    return Constants.MALICIOUSNPUTDETECTED;
                }
            }

            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            string result = string.Empty;
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            string errorLog = logobj.CreateLog("Delete row webservice", sessionid, "DeleteRow-" + tstData.transid, "new");
            result = tstData.CallDeleteRowPerfWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, dcNo);
            tstData.JsonToArray(result, tstData.tstStrObj, "", "DeleteRow");
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string AddRowWS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            string result = string.Empty;
            string errorLog = logobj.CreateLog("Add row webservice", sessionid, "AddRow-" + tstData.transid, "new");
            result = tstData.CallAddRowWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, dcNo);
            //TStructDef tstObj = utilObj.GetTstructDefObj("GetStructure", tstData.transid);
            tstData.JsonToArray(result, tstData.tstStrObj, "", "AddRow");
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string AddRowPerfWS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo, string key, bool isFromScript = false)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            string result = string.Empty;
            string errorLog = logobj.CreateLog("Add row webservice", sessionid, "AddRow-" + tstData.transid, "new");
            result = tstData.CallAddRowPerfWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, dcNo);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            //TStructDef tstObj = utilObj.GetTstructDefObj("GetStructure", tstData.transid);
            bool isValidRow = true;
            try
            {
                if (isFromScript && result != "")
                {
                    string jsonResult = result.Replace("*$*", "♦");
                    jsonResult = jsonResult.Replace("\\", ";bkslh");
                    string[] resval = jsonResult.Split('♦');
                    for (int j = 0; j < resval.Length; j++)
                    {
                        JArray Data = null;
                        try
                        {
                            JObject tData = JObject.Parse(resval[j]);
                            Data = (JArray)tData["data"];
                        }
                        catch (Exception exe) { }

                        for (int m = 0; m < Data.Count; m++)
                        {
                            Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(Data[m].ToString());
                            string fName = values["n"];
                            string fValue = values["v"];
                            //if (fName.ToLower() == "validrow" + dcNo && fValue != "" && fValue.ToLower() == "f")
                            if (fName.ToLower() == "validrow" + dcNo && fValue != "" && fValue.ToLower() != "t")
                            {
                                isValidRow = false;
                                if (fValue.ToLower() == "f")
                                    result = "Not a valid row!";
                                else
                                    result = "Notavalidrow♦" + fValue;
                                break;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                isValidRow = true;
            }
            if (isValidRow)
                tstData.JsonToArray(result, tstData.tstStrObj, "", "AddRow");

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CreatePDF(string s, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            //s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;
            result = tstData.CallCreatePDFWS(s);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CreateFastReportPDF(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "false", "ALL", "");
            s += "<varlist><row>" + tstData.fldValueXml + tstData.memVarsData + "</row></varlist>";
            //s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;
            result = tstData.CallCreateFastPDFWS(s);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CallActionWS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList deletedFldArrayValues, string ArrActionLog, string visibleDcs, string s, string f, string source, string delRows, string changedRows, string key, string files = "", bool isScript = false, string axRulesFlds = "", bool axRulesScript = false)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            string ires = string.Empty;
            string filename = string.Empty;
            IviewData objIview = new IviewData();
            GetGlobalVars();

            if (!utilObj.IsAlphaNumUnd(key))
                return utilObj.ErrorMsgToJson("Invalid parameter.");

            if (!utilObj.IsParamArrayList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray))
                return utilObj.ErrorMsgToJson("Invalid parameter.");

            if (source != "t" && source != "i")
                return utilObj.ErrorMsgToJson("Invalid parameter.");

            if (source != "t")
            {
                string news = GetTraceString(s);
                if (news != string.Empty)
                {
                    if (news.Contains("_#") && news.Contains("</params><varlist>"))
                    {
                        string[] splitNews = news.Split(new[] { "</params><varlist>" }, StringSplitOptions.None);

                        if (splitNews[1] != string.Empty)
                        {
                            splitNews[1] = splitNews[1].Replace("_#", "~");

                            news = String.Join("</params><varlist>", splitNews);
                        }
                    }

                    s = news;
                }
                string data = string.Empty;

                if ((!string.IsNullOrEmpty(f)))
                {
                    if (File.Exists(f))
                        data = File.ReadAllText(f);

                    utilObj.UploadFiles(f, sessionid);
                }
                if (key != "")
                {
                    objIview = (IviewData)HttpContext.Current.Session[key];
                    if (objIview == null)
                        return Constants.DUPLICATESESS;
                }
                //ires = objIview.StructureXml;
                s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
                if (isScript)
                {
                    filename = "Script-" + transid;
                    logobj.CreateLog("Call to RemoteDoScript Web Service", sessionid, filename, string.Empty);
                    result = asbExt.callRemoteDoScriptWS("", s, ires, asbExt.asbAction.Timeout);
                }
                else
                {
                    filename = "Action-" + transid;
                    logobj.CreateLog("Call to RemoteDoAction Web Service", sessionid, filename, string.Empty);
                    result = asbExt.CallRemoteDoActionWS("", s, ires, asbExt.asbAction.Timeout);
                }

                requestProcess_logtime += result.Split('♠')[0];
                result = result.Split('♠')[1];
                logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, string.Empty);

            }
            else
            {
                string data = string.Empty;
                if ((!string.IsNullOrEmpty(f)))
                {
                    if (File.Exists(f))
                        data = File.ReadAllText(f);

                    utilObj.UploadFiles(f, sessionid);
                }
                TStructData tstData = (TStructData)Session[key];
                if (tstData == null)
                    return Constants.DUPLICATESESS;

                if (tstData != null)
                {
                    Util.Util.DeletedraftRediskeys(tstData.transid);
                    logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
                    string calledFrom = ArrActionLog.StartsWith("CallAction-axpbutton_") ? "axpbutton" : "false";
                    result = tstData.CallActionWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, deletedFldArrayValues, s, f, source, delRows, changedRows, calledFrom: calledFrom, files: new StringBuilder(files), isScript: isScript, axRulesFlds: axRulesFlds, axRulesScript: axRulesScript);
                    requestProcess_logtime += result.Split('♠')[0];
                    result = result.Split('♠')[1];
                    tstData.JsonToArray(result, tstData.tstStrObj, "", "Action");
                    string AxRelKeys = string.Empty;
                    if (Session["AxRelKeys"] != null)
                    {
                        AxRelKeys = "*#*" + Session["AxRelKeys"].ToString();
                        Session["AxRelKeys"] = null;
                    }
                    result = result + "*♠*" + tstData.GetVisibleFormatGridsHtml(tstData.tstStrObj, visibleDcs) + AxRelKeys;
                }
                else
                    result = "{\"error\":[{\"msg\":\"Error: Please reload the page and try again.\"}]}";
            }
            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string ViewAttachment(string s, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;
            string errorLog = logobj.CreateLog("Get Structure object from cache for view attachment.", sessionid, "GetStructXml-", "new");
            s = GetTraceString(s);
            //TStructDef tstObj = utilObj.GetTstructDefObj(errorLog, transid);
            TStructDef tstObj = tstData.tstStrObj;
            string result = string.Empty;
            s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            result = tstData.CallViewAttachWS(s, tstObj.structRes);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string RemoveAttachment(string s, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            if (transid == "")
                transid = tstData.transid;
            string result = string.Empty;
            //s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string errorLog = logobj.CreateLog("Get Structure object from cache for view attachment.", sessionid, "GetStructXml-", "new");
            //TStructDef tstObj = utilObj.GetTstructDefObj(errorLog, transid);
            TStructDef tstObj = tstData.tstStrObj;
            result = tstData.CallRemoveAttachWS(s, tstObj.structRes);
            return result;
        }

        //NOTE: webservice needs to be released in new dll
        [WebMethod(EnableSession = true)]
        public string DeleteIviewRow(string recIds, string transid, string s)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            string news = GetTraceString(s);
            if (news != string.Empty) s = news;
            string result = string.Empty;
            s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            result = asbExt.CallDeleteIVRowWS("", s);
            if (result.ToLower().Contains("done") && utilObj.isRealTimeCacEnabled(transid, null))
                result = result + "*#*" + utilObj.GetAxRelations(transid);
            utilObj.DeleteRecordsFromCache(result, recIds, transid);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetDepFlds(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string visibleDcs, string s, string tid, string key, string frameNo, string rowNo, string fieldName, string subGridInfo, string parentInfo)
        {
            string requestProcess_logtime = string.Empty;
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string result = string.Empty;
            GetGlobalVars();
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            tstData.SetSubGridRows(subGridInfo);
            tstData.AxActiveDc = frameNo;
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallGetDepFldWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, frameNo, rowNo, fieldName, subGridInfo, parentInfo);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            DateTime sTime2 = DateTime.Now;
            //TStructDef tstObj = utilObj.GetTstructDefObj("Get structure object", tid);
            TStructDef tstObj = tstData.tstStrObj;
            if (result != "")
            {
                try
                {
                    if (tstObj.IsDcGrid(Convert.ToInt32(frameNo)))
                        tstData.JsonToArray(result, tstObj, "", "GetDepPerf");
                    else
                        tstData.JsonToArray(result, tstObj, "", "GetDep");
                }
                catch (Exception ex)
                { }
            }
            tstData.AxActiveDc = string.Empty;
            result = result + "*♠*" + tstData.GetVisibleFormatGridsHtml(tstObj, visibleDcs);
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetDepFldsPerf(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList RegVarFldList, string ArrActionLog, string visibleDcs, string s, string tid, string key, string frameNo, string rowNo, string perfDepFldName, string fieldName, string subGridInfo, string parentInfo, ArrayList acceptExpressionFlds)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string result = string.Empty;
            GetGlobalVars();
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            tstData.SetSubGridRows(subGridInfo);
            tstData.AxActiveDc = frameNo;
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallGetDepFldPerfWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, RegVarFldList, s, frameNo, rowNo, perfDepFldName, fieldName, subGridInfo, parentInfo, acceptExpressionFlds);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            DateTime sTime2 = DateTime.Now;
            //TStructDef tstObj = utilObj.GetTstructDefObj("Get structure object", tid);
            TStructDef tstObj = tstData.tstStrObj;
            if (result != "")
            {
                try
                {
                    if (tstObj.IsDcGrid(Convert.ToInt32(frameNo)))
                        tstData.JsonToArray(result, tstObj, "", "GetDepPerf");
                    else
                        tstData.JsonToArray(result, tstObj, "", "GetDep");
                }
                catch (Exception ex)
                { }
            }
            tstData.AxActiveDc = string.Empty;
            result = result + "*♠*" + tstData.GetVisibleFormatGridsHtml(tstObj, visibleDcs);
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;
            return result;
        }


        [WebMethod(EnableSession = true)]
        public string GetRapidDepFlds(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string visibleDcs, string s, string tid, string key, string frameNo, string rowNo, string fieldName, string subGridInfo, string parentInfo)
        {
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string result = string.Empty;
            GetGlobalVars();
            tstData.SetSubGridRows(subGridInfo);
            tstData.AxActiveDc = frameNo;
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallGetRapidDepFldWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, s, frameNo, rowNo, fieldName, subGridInfo, parentInfo);
            DateTime sTime2 = DateTime.Now;
            TStructDef tstObj = tstData.tstStrObj;
            if (result != "")
            {
                try
                {
                    if (tstObj.IsDcGrid(Convert.ToInt32(frameNo)))
                        tstData.JsonToArray(result, tstObj, "", "GetDepPerf");
                    else
                        tstData.JsonToArray(result, tstObj, "", "GetDep");
                }
                catch (Exception ex)
                { }
            }
            tstData.AxActiveDc = string.Empty;
            result = result + "*♠*" + tstData.GetVisibleFormatGridsHtml(tstObj, visibleDcs);
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            return result;
        }


        [WebMethod(EnableSession = true)]
        public string GetSearchResult(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string fldName, string fldValue, string pageNo, string pageSize, string key, string frameNo, string activerow, string parentInfo, string subGridInfo, string includeDcs)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            string result = "";
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;
            string errorLog = logobj.CreateLog("Get Structure object from cache for picklist.", sessionid, "PickList-" + transid, "new");
            errorLog = logobj.CreateLog("Get picklist search result.", sessionid, "GetPickListData-" + transid, "new");
            string activePRow = string.Empty;
            string activePDc = string.Empty;
            if (parentInfo != string.Empty)
            {
                int idx = parentInfo.IndexOf("~");
                if (idx != -1)
                {
                    activePDc = parentInfo.Substring(0, idx);
                    activePRow = parentInfo.Substring(idx + 1);
                }
            }
            string iXml = string.Empty;
            iXml += "<sqlresultset activerow='" + activerow + "' pdc='" + activePDc + "' prow='" + activePRow + "' frameno='" + frameNo + "' axpapp='" + project + "' value='" + fldValue + "' sessionid= '" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' field='" + fldName + "'";
            iXml += " sqlfield='' trace='" + errorLog + "' transid='" + transid + "'  pageno='" + pageNo + "' ";
            iXml += "pagesize='" + pageSize + "'>";
            result = tstData.GetPickListResult(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, iXml, tstData.tstStrObj.structRes, fldName, frameNo, parentInfo, subGridInfo, activerow, includeDcs);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CallLoadDcData(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string iXml, string dcNo, Boolean isFillGrid, string isDisable, string key)
        {
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            string tabHTML = string.Empty;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;
            GetGlobalVars();
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            string errorLog = logobj.CreateLog("Get Structure object from cache for dc info.", sessionid, "GetTabData-" + dcNo, "new");
            //TStructDef strObj = utilObj.GetTstructDefObj(errorLog, transid);
            TStructDef strObj = tstData.tstStrObj;
            string isRapidCall = "false";
            if ((Session["RapidTsTruct"] != null && Session["RapidTsTruct"].ToString() == "true") && (HttpContext.Current.Session["AxIsPerfCode"] != null && HttpContext.Current.Session["AxIsPerfCode"].ToString().ToLower() == "true"))
                isRapidCall = "true";
            DateTime eTime1 = DateTime.Now;
            string isDraft = string.IsNullOrEmpty(tstData.TabDcStatus) ? "no" : tstData.GetCurrTabStatus(dcNo);
            if (isDraft == "yes")
            {
                result = tstData.GetTabDCJson(dcNo);
            }
            else if (isRapidCall != "true")
                result = tstData.LoadComboValues(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, iXml, dcNo);
            else
                tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "LoadTab", "NG", dcNo);
            DateTime sTime2 = DateTime.Now;
            if (result != "")
                tstData.JsonToArray(result, strObj, dcNo, "LoadTab");

            //The return string will contain the MasterRow fields, json string for dependent dc's of the tab dc(excluding the json for tab dc and its sub grid if any),
            //and the html for tab dc and its sub grid html if any.    
            //AJH000011 //if (isFillGrid)
            strObj.IsFillGridCall = true;

            string temptabHTML = strObj.GetTabDcHTML(Convert.ToInt32(dcNo), tstData, isDisable);

            Boolean designMode = false;
            if (HttpContext.Current.Session[transid + "IsDesignMode"] != null && HttpContext.Current.Session[transid + "IsDesignMode"].ToString() != string.Empty)
                designMode = Convert.ToBoolean(HttpContext.Current.Session[transid + "IsDesignMode"]);
            FDW fdwObj = FDW.Instance;
            bool isRedisConnected = fdwObj.IsConnected;

            if (designMode && HttpContext.Current.Session["Axp_DesignJson"] != null && HttpContext.Current.Session["Axp_DesignJson"].ToString() != "")
                strObj.axdesignJObject = tstData.tstStrObj.getDesignObjectFromJson(Session["Axp_DesignJson"].ToString());

            string tempDcDesignJson = string.Empty;
            try
            {
                //tempDcDesignJson = strObj.axdesignJson.
                Dc curDc = tstData.tstStrObj.axdesignJObject.dcs.FirstOrDefault(elm => elm.dc_id == dcNo.ToString());
                tempDcDesignJson = new JavaScriptSerializer().Serialize(curDc);
            }
            catch (Exception ex)
            {

            }
            string tabjson = "";
            bool isDcGrid = tstData.IsDcGrid(dcNo, strObj);
            if ((tstData.recordid != "0" || result != "") && isDcGrid)
            {
                tabjson = tstData.tabJson.ToString();
                tabHTML = tstData.AxDepArrays.ToString() + "*♦*" + tstData.GetMasterRowFlds() + "*♠*" + tabjson + "*♠*" + temptabHTML + "*♠*" + tempDcDesignJson;
            }
            else
                tabHTML = tstData.AxDepArrays.ToString() + "*♦*" + tstData.GetMasterRowFlds() + "*♠*" + tabjson + "*♠*" + temptabHTML + "*♠*" + tempDcDesignJson + "*♠*~false";
            //if (isFillGrid)
            strObj.IsFillGridCall = false;

            //to update design json from tab to object
            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();

            string fdKey = Constants.REDISTSTRUCT;
            if (HttpContext.Current.Session["MobileView"] != null && HttpContext.Current.Session["MobileView"].ToString() == "True")
                fdKey = Constants.REDISTSTRUCTMOB;
            //FDW fdwObj = FDW.Instance;
            fdwObj.SaveInRedisServer(utilObj.GetRedisServerkey(fdKey, transid), strObj, Constants.REDISTSTRUCT, schemaName);
            tstData.tstStrObj = strObj;
            Session[key] = (TStructData)tstData;

            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            return tabHTML;
        }

        [WebMethod(EnableSession = true)]
        public string GetFillGridData(string paramXml, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string dcNo, string fgName, string transid, string src, string key, string exprResult)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            TStructDef strObj = tstData.tstStrObj;
            string errorLog = logobj.CreateLog("Get FillGird values result.", sessionid, "GetFillGridValues-" + transid, "new");
            string iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' frameno='" + dcNo + "' fgname='" + fgName + "' transid='" + transid + "'>";
            iXml += paramXml;

            result = tstData.CallMsFillGrid(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, dcNo, iXml, paramXml, fgName);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            if (result != string.Empty && !result.StartsWith(Constants.ERROR))
            {
                result = tstData.ConstructFillGrid(result, dcNo, fgName, strObj, tstData, src, exprResult);
            }

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠♠*" + requestProcess_logtime + "*♠♠*" + result;

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetFastFillGridData(string dcNo, string fgName, string transid, string src, string key, string exprResult)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            string result = string.Empty;
            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            TStructDef strObj = tstData.tstStrObj;
            string errorLog = logobj.CreateLog("Get FillGird values result.", sessionid, "GetFillGridValues-" + transid, "new");
            string iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' frameno='" + dcNo + "' fgname='" + fgName + "' transid='" + transid + "'>";

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            //result = fObj.GetFastFillGridXML(utilObj.GetTstructDefObj("GetFastAjaxData", tstData.transid), fgName, dcNo);
            result = fObj.GetFastFillGridXML(tstData.tstStrObj, fgName, dcNo);
            if (result != string.Empty && !result.StartsWith(Constants.ERROR))
            {
                result = tstData.ConstructFillGrid(result, dcNo, fgName, strObj, tstData, src, exprResult);
            }

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠*" + requestProcess_logtime + "*♠*" + result;

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string ExecuteFormatFill(string transid, string frameNo, string selection, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            //TStructDef tstObj = utilObj.GetTstructDefObj("GetStructure", transid);
            TStructDef tstObj = tstData.tstStrObj;
            TStructDef.DcStruct dc = (TStructDef.DcStruct)tstObj.dcs[Convert.ToInt32(frameNo) - 1];
            string fileName = "GetFormatFillGrid" + transid;
            string dcHTML = string.Empty;
            string errorLog = logobj.CreateLog("GetFormatFillGrid.", sessionid, fileName, "new");
            dcHTML = tstObj.GetFormatHtmlForGroups(selection, tstData, "false");
            return dcHTML;
        }

        [WebMethod(EnableSession = true)]
        public string ExecuteAction(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string rid, string transid, string frameNo, string s, string selection, string delRows, string changedRows, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            //TStructDef tstObj = utilObj.GetTstructDefObj("GetStructure", transid);
            TStructDef tstObj = tstData.tstStrObj;
            TStructDef.DcStruct dc = (TStructDef.DcStruct)tstObj.dcs[Convert.ToInt32(frameNo) - 1];
            string fileName = "GetFormatFillGrid" + transid;
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            string errorLog = logobj.CreateLog("GetFormatFillGrid.", sessionid, fileName, "new");
            string actions = dc.Action;
            string dcHTML = string.Empty;
            ArrayList deletedFldArrayValues = new ArrayList();
            if (actions != "")
            {
                string[] strActions = actions.Split(',');
                string result = string.Empty;
                transid = tstData.transid;

                for (int i = 0; i < strActions.Length; i++)
                {
                    if (strActions[i].ToString() == string.Empty)
                        continue;

                    string Ixml = "";
                    Ixml = "<root axpapp='" + project + "' trace='" + errorLog + "' recordid='" + rid + "' selection='" + selection + "'  fno='" + frameNo + "' actrow='0' sessionid='" + sessionid + "'  stype='tstructs' sname='" + transid + "' actname='" + strActions[i].ToString() + "' __file='" + fileName + "' options='true'><varlist><row>";
                    Ixml += s;
                    result = tstData.CallActionWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, deletedFldArrayValues, Ixml, "", "t", delRows, changedRows, frameNo: frameNo);

                    if (result != "")
                        tstData.JsonToArray(result, tstObj, frameNo, "ExecAction");
                    tstData.oldRowNos.Clear();
                    tstData.newRowNos.Clear();
                }
                dcHTML = tstData.tabJson.ToString() + "*♠*" + tstObj.GetTabDcHTML(Convert.ToInt32(frameNo), tstData, "false");
            }

            return dcHTML;
        }

        [WebMethod(EnableSession = true)]
        public string DoGetFillGrid(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string fgName, string s, string key)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();

            string dcHTML = string.Empty;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;

            string fileName = "DoFillGrid-" + transid;
            string errorLog = logobj.CreateLog("GetFillGridValues.", sessionid, fileName, "new");
            string Ixml = "";
            Ixml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='" + errorLog + "' frameno='" + frameNo + "' fgname='" + fgName + "' transid='" + transid + "'>";
            Ixml += s;

            TStructDef strObj = tstData.tstStrObj;
            string result = string.Empty;
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallGetFillGridWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, frameNo, Ixml);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            DateTime sTime2 = DateTime.Now;
            if (result != "")
                tstData.JsonToArray(result, strObj, frameNo, "FillGridMS");

            strObj.IsFillGridCall = true;
            dcHTML = tstData.tabJson.ToString() + "*♠*" + strObj.GetTabDcHTML(Convert.ToInt32(frameNo), tstData, "false");
            strObj.IsFillGridCall = false;
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", dcHTML);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            dcHTML = serverprocesstime + "*♠♠*" + requestProcess_logtime + "*♠♠*" + dcHTML;

            return dcHTML;
        }

        [WebMethod(EnableSession = true)]

        public string DoGetFillGridNonMS(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string fgName, string key)
        {
            string requestProcess_logtime = string.Empty;
            ObjExecTr.SetCurrentTime();
            DateTime sTime1 = DateTime.Now;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string fileName = "DoFillGridAutoValues" + tstData.transid;
            string errorLog = logobj.CreateLog("DoFillGridValues.", sessionid, fileName, "new");
            string iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='" + errorLog + "' frameno='" + frameNo + "' fgname='" + fgName + "' transid='" + tstData.transid + "'><GridList></GridList>";
            string result = string.Empty;
            transid = tstData.transid;
            DateTime eTime1 = DateTime.Now;
            result = tstData.CallGetFillGridWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, frameNo, iXml);
            requestProcess_logtime += result.Split('♠')[0];
            result = result.Split('♠')[1];
            DateTime sTime2 = DateTime.Now;
            TStructDef strObj = tstData.tstStrObj;
            if (result != "")
                tstData.JsonToArray(result, strObj, frameNo, "FillGridNMS");
            strObj.IsFillGridCall = true;
            result = tstData.tabJson.ToString() + "*♠*" + strObj.GetTabDcHTML(Convert.ToInt32(frameNo), tstData, "false");
            strObj.IsFillGridCall = false;
            DateTime eTime2 = DateTime.Now;
            if (tstData.logTimeTaken)
                tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));

            requestProcess_logtime += ObjExecTr.RequestProcessTime("Response", result);
            string serverprocesstime = ObjExecTr.TotalServerElapsTime();
            result = serverprocesstime + "*♠♠*" + requestProcess_logtime + "*♠♠*" + result;

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetSubGridDropdown(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string key, string recordid, int parRowNo, string parDcNo, int popRowNo)
        {
            string result = string.Empty;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;
            string errorLog = logobj.CreateLog("Calling GetSubGrid dropdown.", sessionid, "GetSubGridDDL", "new");
            string iXml = "<sqlresultset axpapp='" + project + "' transid='" + tstData.transid + "' recordid='" + recordid + "' dcname='dc" + frameNo + "' sessionid='" + sessionid + "' trace='" + errorLog + "' activerow='1' frameno ='" + frameNo + "' pardc='" + parDcNo + "' pdc='" + parDcNo + "' prow='" + parRowNo + "'>";
            result = tstData.GetSubGridCombos(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, iXml, frameNo, parDcNo, popRowNo, parRowNo);
            return result;
        }



        //[WebMethod()]
        //public string SaveTstXml(string message)
        //{
        //    string ScriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();

        //    return "Hi" + message;
        //}





        [WebMethod(EnableSession = true)]
        public string RefreshDc(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string key, string recordid, string includeDcs)
        {
            string result = string.Empty;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            transid = tstData.transid;
            string errorLog = logobj.CreateLog("Calling Refresh Dc.", sessionid, "RefreshDc-" + frameNo, "new");
            string iXml = "<sqlresultset axpapp='" + project + "' transid='" + tstData.transid + "' recordid='" + recordid + "' dcname='dc" + frameNo + "' sessionid='" + sessionid + "' trace='" + errorLog + "' >";
            result = tstData.CallRefreshDc(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, iXml, frameNo, includeDcs);
            tstData.JsonToArray(result, tstData.tstStrObj, "", "RefreshDc");
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string ProcessWFActionChanges(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string files, string rid, string inputXml, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            inputXml = GetTraceString(inputXml);
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string result = string.Empty;
            if (tstData != null)
            {
                result = tstData.CallWorkFlowActionWS(tstData, fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, files, rid, inputXml);
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string ProcessWFAction(string s)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            string news = GetTraceString(s);
            if (news != string.Empty) s = news;
            string result = null;
            s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            result = asbExt.CallWorkFlowActionWS("", s);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetDependParamsValues(string s, string IVkey)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            IviewData objIview = new IviewData();
            string iStructure = string.Empty;
            try
            {
                objIview = (IviewData)HttpContext.Current.Session[IVkey];
                if (objIview == null)
                    return Constants.DUPLICATESESS;
                iStructure = objIview.StructureXml;
            }
            catch (Exception ex)
            {
                iStructure = string.Empty;
            }
            string news = GetTraceString(s);
            if (news != string.Empty) s = news;
            s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
            string result = null;
            //Call service
            ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.CallGetDependParamsValuesWS(transid, s, iStructure, objIview.WebServiceTimeout);
            UpdateFilterParamXML(result, objIview.IName);
            return result;
        }

        private void UpdateFilterParamXML(string result, string iName)
        {
            Dictionary<string, string> CurDepFields = new Dictionary<string, string>();
            Dictionary<string, string> PreDepFields = new Dictionary<string, string>();

            try
            {
                if (Session["FilterParamResXML" + iName] != null)
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(result);
                    string[] depParams = xmlDoc.DocumentElement.Attributes["depparams"].Value.ToString().Split(',');

                    foreach (var depParam in depParams)
                    {
                        XmlNode field = xmlDoc.SelectSingleNode("//" + depParam + "/response");
                        if (field != null)
                            CurDepFields.Add(depParam, field.InnerXml);
                    }
                    if (Session["UpdateParamsCollection"] == null)
                    {
                        Session["UpdateParamsCollection"] = CurDepFields;
                    }
                    else
                    {
                        PreDepFields = (Dictionary<string, string>)Session["UpdateParamsCollection"];
                        //PreDepFields.Union(CurDepFields); ;
                        foreach (KeyValuePair<string, string> kvp in CurDepFields)
                        {
                            PreDepFields[kvp.Key] = kvp.Value;
                        }
                        Session["UpdateParamsCollection"] = PreDepFields;
                    }
                }
            }
            catch (Exception ex)
            {
                result = "error:" + ex.Message;
            }
        }

        [WebMethod(EnableSession = true)]
        public string ClearCache()
        {
            string result = string.Empty;
            result = utilObj.ClearApplicationCache();
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetAddGroupsHtml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string dcNo, string transid, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            //TStructDef strObj = utilObj.GetTstructDefObj("GetAddGroupHtml", transid);
            TStructDef strObj = tstData.tstStrObj;
            TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[Convert.ToInt32(dcNo) - 1];
            string fgHTML = string.Empty;
            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "false", "ALL", "");
            string mapCol = string.Empty;

            if (dc.Action != "")
            {
                string result = strObj.ExecuteSql(dc.Sql, tstData, Convert.ToInt32(dcNo));
                fgHTML = tstData.ConstructFormatFillGrid(result, strObj, dcNo, "fill");
            }
            else if (dc.KeyColValues.Count > 0 || dc.Sql != "")
            {
                ArrayList groups = new ArrayList();
                groups = strObj.GetGroups(Convert.ToInt32(dcNo), tstData);
                string colWidth = strObj.GetColumnWidth(dcNo, dc.KeyColumn);

                if (dc.MapParentCol != string.Empty)
                    mapCol = dc.MapParentCol;
                else
                    mapCol = dc.KeyColumn;

                string headRow = "<th>" + dc.KeyColumn + "</th>";
                string rowHtml = "<tr>";
                for (int i = 0; i < groups.Count; i++)
                {
                    if (tstData.IsDupKeyColValue(mapCol, dcNo, groups[i].ToString()))
                    {
                        rowHtml += "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox disabled='disabled' name='chkItem' " + i + "  value=\"" + groups[i].ToString() + "\" onclick='javascript:ChkHdrCheckbox();' >";
                    }
                    else
                        rowHtml += "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox name='chkItem' " + i + "  value=\"" + groups[i].ToString() + "\" onclick='javascript:ChkHdrCheckbox();' >";

                    rowHtml += "</span></td><td class='fgData'>" + groups[i].ToString() + "</td></tr>";
                }
                fgHTML = "<div style=\"width:100%;max-height:300px;overflow-x:auto;overflow-y:scroll;padding-top:10px\"><table id='tblFillGrid" + dcNo + "' class='gridData'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' onclick=\"javascript:CheckAll(this);\" ></th>" + headRow + "</tr></thead><tbody>" + rowHtml + "</tbody></table>";
                fgHTML += "<div style='text-align:center;'><input type='button' class='button' value='Ok' onclick=\"javascript:ProcessAddGroup('" + dcNo + "')\"/></div></div>";
            }

            return fgHTML;
        }

        [WebMethod(EnableSession = true)]
        public string GetNewGroupsHtml(int dcNo, string transid, string selectedGroups, string lastRowNo, string key)
        {
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            //TStructDef strObj = utilObj.GetTstructDefObj("GetAddGroupHtml", transid);
            TStructDef strObj = tstData.tstStrObj;
            ArrayList groups = new ArrayList();
            string[] strGroups = selectedGroups.Split('¿');
            for (int i = 0; i < strGroups.Length; i++)
            {
                groups.Add(strGroups[i].ToString());
            }
            string grpHtml = strObj.GetGroupRowHtml(dcNo, groups, lastRowNo, tstData);
            return grpHtml;
        }

        [WebMethod(EnableSession = true)]
        public void DeleteTstDataObj(string key)
        {
            HttpContext.Current.Session.Remove(key);
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }


        [WebMethod(EnableSession = true)]
        public void DeleteIviewDataObj(string key)
        {
            HttpContext.Current.Session.Remove(key);
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }

        [WebMethod(EnableSession = true)]
        public string GetSessionValue(string key)
        {
            string returnString = string.Empty;
            try
            {
                returnString = HttpContext.Current.Session[key].ToString();
            }
            catch (Exception ex) { }
            return returnString;
        }

        [WebMethod(EnableSession = true)]
        public string CreateFastReportDoc(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string tid, string selectedDoc, string rid, string key)
        {
            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string docName = rid + selectedDoc;
            string iXml = string.Empty; string errorLog = string.Empty;
            errorLog = logobj.CreateLog("Calling CreateFastReport", sessionid, "CreateFastReportWord-" + tid, "new");
            iXml = "<root scriptspath='" + utilObj.ScriptsPath + "' axpapp='" + project + "' sessionid='" + sessionid + "' formname='" + selectedDoc + "' filename='" + docName + "' transid='" + tid + "' recordid='" + rid + "' trace='" + errorLog + "'><varlist><row>";

            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "false", "ALL", "");
            iXml += tstData.fldValueXml + tstData.memVarsData + "</row></varlist>";

            //iXml = iXml + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;
            result = tstData.CallCreateFastPDFWS(iXml);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string AddPrintDoc(string tid, string selectedDoc, string rid, string key, string docType)
        {
            string result = string.Empty;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            bool tidvalid = utilObj.IsTransIdValid(tid);
            bool ridvalid = utilObj.IsNumber(rid);
            bool docnamevalid = utilObj.IsDocName(selectedDoc);
            if (!tidvalid || !ridvalid || !docnamevalid)
            {
                string errMsg = string.Empty;
                if (!tidvalid)
                    errMsg = "Invalid Transaction Id";
                else if (!ridvalid)
                    errMsg = "Invalid Record Id";
                else if (!docnamevalid)
                    errMsg = "Invalid Document Name";

                return utilObj.ErrorMsgToJson(errMsg);
            }
            else
            {
                GetGlobalVars();
                string errorLog = string.Empty;

                errorLog = logobj.CreateLog("Adding Print tasks", sessionid, "InsertPrintJob-" + tid, "new");
                string iXml = string.Empty;

                string docName = utilObj.GetDocName(selectedDoc, tid, key);
                string[] docNameStr = docName.Split('♣');
                string printDocName = docNameStr[0].ToString().Substring(0, docNameStr[0].ToString().IndexOf("."));
                string type = string.Empty;
                if (docType == "doc")
                    type = "A";
                else
                    type = "F";

                iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' transid='' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
                //The print doc will be stored as 'print doc name + "_" + axprintfield value + "_" + transid ' and will be stored at 'axpert' folder in the scripts path.
                iXml += "<sql> Insert into Axprinting values('" + tid + "','" + rid + "','" + selectedDoc + "','" + utilObj.ScriptsPath + "axpert\\" + sessionid + "','" + printDocName + "','InProgress','" + type + "')</sql>";
                iXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                string ires = string.Empty;
                ires = asbExt.CallGetChoiceWS(tid, iXml);
                ArrayList printDocs;
                if (ires == "done")
                {
                    if (Session["printingDocs"] != null)
                        printDocs = (ArrayList)Session["printingDocs"];
                    else
                        printDocs = new ArrayList();

                    //The file name format to store in session - "filename_axprintfile/datetime_tid♣tstcaption¿requested on~status "
                    printDocs.Add(docName + "~" + Constants.PROGRESS);
                    Session["printingDocs"] = printDocs;
                }
                return result;
            }
        }
        [WebMethod(EnableSession = true)]
        public string GetPrintDocsHtml()
        {
            ArrayList printDocs;
            string result = string.Empty;
            string res = utilObj.GetPrintDocStatus();
            if (res == utilObj.SESSTIMEOUT)
                return res;
            printDocs = utilObj.GetDocsFromSession();
            result = utilObj.GetPrintCount(printDocs) + "♣" + utilObj.GetPrintDocsHTML(printDocs);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string RefreshPrintCount()
        {
            ArrayList printDocs;
            string result = string.Empty;
            printDocs = utilObj.GetDocsFromSession();
            result = utilObj.GetPrintCount(printDocs);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string RemoveDoc(string fileName)
        {
            string result = string.Empty;
            ArrayList printDocs = utilObj.GetDocsFromSession();
            string status = utilObj.DeleteDocFromSession(fileName, printDocs);
            if (status == utilObj.SESSTIMEOUT)
                return status;
            GetGlobalVars();
            string tid = fileName.Substring(fileName.LastIndexOf("_") + 1, fileName.IndexOf(".") - (fileName.LastIndexOf("_") + 1));
            string errorLog = logobj.CreateLog("Get choices to delete print doc", sessionid, "DeletePrintDoc-" + tid, "new");

            bool tidvalid = utilObj.IsTransIdValid(tid);
            bool filenamevalid = utilObj.IsDocName(fileName);
            if ((!tidvalid) || (!filenamevalid))
            {
                string errmsg = string.Empty;
                if (!tidvalid)
                    errmsg = "Invalid TransistationID ";
                else if (!filenamevalid)
                    errmsg = "Invalid FileName";
                return utilObj.ErrorMsgToJson(errmsg);
            }


            else
            {
                string iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' transid='' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
                //The print doc will be stored as 'print doc name + "_" + axprintfield value + "_" + transid ' and will be stored at 'axpert' folder in the scripts path.
                iXml += "<sql> delete from Axprinting where transid='" + tid + "' and filename='" + fileName + "'</sql>";
                iXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                //The result from CallGetChoice is ignored since it deletes if records are aavailable.
                result = asbExt.CallGetChoiceWS(tid, iXml);
                result = utilObj.GetPrintCount(printDocs);
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public ArrayList GetPrintDocs(string tid)
        {
            GetGlobalVars();
            ArrayList printDocs = new ArrayList();
            string result = string.Empty;
            string errorLog = string.Empty;
            string newTid = null;
            newTid = "t" + tid.ToLower();

            string dbTimesql = null;
            errorLog = logobj.CreateLog("Get Print Docs", sessionid, "GetPrintDocs-" + tid, "new");
            //dbTimesql = "<sqlresultset axpapp='" + project + "' sessionid= '" + sessionid + "' trace='" + errorLog + "'><sql>select distinct caption,name,printdoctype from prints where lower(sname) =  '" + newTid + "'  and blobno=1 order by caption</sql>";
            //dbTimesql += Session["axApps"].ToString() + Application["axProps"].ToString() + "</sqlresultset>";
            string dbTimeres = null;

            dbTimesql = "<root sname='" + tid + "' axpapp='" + project + "' sessionid='" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' stype='tstructs' trace='" + errorLog + "'>";
            dbTimesql += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";

            dbTimeres = asbExt.CallGetPrintDocList(tid, dbTimesql);
            dbTimeres.ToUpper();
            XmlDocument xmlDoc = new XmlDocument();
            XmlNodeList xmlNodes = default(XmlNodeList);
            ArrayList arrDDlItems = new ArrayList();
            printDocs.Add("-- Select --♣-- Select --");
            xmlDoc.LoadXml(dbTimeres.ToString());
            xmlNodes = xmlDoc.SelectNodes("//root");

            foreach (XmlNode productNode in xmlNodes[0])
            {
                if (productNode.Name != "transid")
                {
                    if (productNode.Attributes["source"] != null)
                        printDocs.Add(productNode.Attributes["source"].Value + "♣" + productNode.ChildNodes[0].InnerText);
                }
            }
            return printDocs;

        }

        [WebMethod(EnableSession = true)]
        public string UpdateDocStatus()
        {
            return utilObj.GetPrintDocStatus();
        }

        [WebMethod(EnableSession = true)]
        public string UpdateTraceStatus(string status)
        {
            HttpContext.Current.Session["AxTrace"] = status;
            return "done";
        }

        [WebMethod(EnableSession = true)]
        public string AppendRowToDataObj(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string key)
        {
            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            GetGlobalVars();
            logobj.CreateActionLog(ArrActionLog, sessionid, "ActionLog", "");
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "UpdateNewRow", "ALL", "");
            return result;
        }

        private void GetGlobalVars()
        {
            project = HttpContext.Current.Session["project"].ToString();
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            user = HttpContext.Current.Session["user"].ToString();
            AxRole = HttpContext.Current.Session["AxRole"].ToString();
        }

        #region Save As Draft
        [WebMethod(EnableSession = true)]
        public string SaveAsDraft(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string transid, string key, string tabDCStatusStr)
        {
            if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            GetGlobalVars();
            string result = string.Empty;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            tstData.UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
            tstData.TabDcStatus = tabDCStatusStr;
            int fldIdx = tstData.tstStrObj.GetFieldIndex("axp_draft_name");
            string custVal = string.Empty;
            if (custVal == string.Empty)
                custVal = tstData.tstStrObj.tstCaption;

            //custVal = custVal.Replace('-', '♠');
            try
            {
                Session["DraftHTML"] = Constants.DRAFT_REFRESH;
                if (!utilObj.SaveAsDraft(transid, key, user, custVal))
                    result = "error:";
            }
            catch (Exception ex)
            {
                result = "error:" + ex.Message;
            }
            return result;
        }
        [WebMethod(EnableSession = true)]
        public string GetDraftsFromRedis(string transid, string caption)
        {
            string drafts = string.Empty;
            string userId = string.Empty;
            if (HttpContext.Current.Session["username"] != null)
            {
                userId = HttpContext.Current.Session["username"].ToString();
                try
                {
                    drafts = utilObj.GetDraftsMarkUp(transid, userId, caption);
                }
                catch (Exception ex)
                {
                    drafts = Constants.EX_DRAFT_HTML;
                }
            }
            else
            {
                drafts = Constants.EX_DRAFT_HTML;
            }
            return drafts;
        }
        [WebMethod(EnableSession = true)]
        public string DeleteDraft(string draftId)
        {
            GetGlobalVars();
            string result = string.Empty;
            result = utilObj.DeleteDraft(draftId, user);
            return result;
        }
        #endregion

        //AddToDataCache
        [WebMethod(EnableSession = true)]
        public string AddToDataCache(string html, string key, string jsArrays, string recId)
        {
            GetGlobalVars();
            string result = string.Empty;
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            tstData.recordid = recId;
            tstData.recordID = recId;
            tstData.ires = string.Empty;
            tstData.result = string.Empty;
            tstData.tabJson = new StringBuilder();
            HttpContext.Current.Session[key] = tstData;
            string dirPath = utilObj.CachePath + "datacache\\" + tstData.transid + "\\" + recId;
            try
            {
                utilObj.SaveInDataCache(tstData.transid, key);
                utilObj.WriteToFile(dirPath, recId + "-html", html);
                utilObj.WriteToFile(dirPath, recId + "-js", jsArrays);
                result = recId;
            }
            catch (Exception ex)
            {
                result = "error:" + ex.Message;
                logobj.CreateLog(ex.StackTrace.ToString(), sessionid, "Exception-SaveHtml" + transid, "");
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string RefreshField(string frameNo, string rowNo, string fieldName)
        {
            string result = string.Empty;
            //Needs to be implemented.
            return result;
        }
        #region TStruct Navigation
        [WebMethod(EnableSession = true)]
        public string GetRecord(string nxtprv, string recordId, string transactionId, string columnName, int dataRowIndex, bool isParentIview)
        {
            return utilObj.GetNavigationRecord(nxtprv, recordId, transactionId, columnName, dataRowIndex, isParentIview);
        }

        [WebMethod(EnableSession = true)]
        public bool SessionHasValue(string transactionId, int dataRowIndex, string columnName, bool isParentIview)
        {
            if (isParentIview)
            {
                if (dataRowIndex >= 0 && !string.IsNullOrEmpty(columnName) && Session["iNavigationInfoTable"] != null)
                    return true;
                else
                    return false;
            }
            else
            {
                if (dataRowIndex >= 0 && !string.IsNullOrEmpty(columnName) && columnName != "recordid" && Session["navigationInfoTable"] != null)
                    return true;
                else if (Session["lstRecordIds"] != null && Session["recordTransId"] != null && Session["recordTransId"].ToString() == transactionId)
                    return true;
                else
                    return false;
            }
        }

        [WebMethod(EnableSession = true)]
        public void ClearNavigationSession()
        {
            utilObj.ClearSession();
        }
        #endregion
        #region Back Forward Button
        [WebMethod(EnableSession = true)]
        public string NavigateBackForwardButton(string buttonName)
        {
            if ((buttonName.GetType() != typeof(string)) || (!(buttonName == "back" || buttonName == "forward")))
                return String.Empty;

            string rul = HttpContext.Current.Request.UrlReferrer.ToString().ToLower();
            //if (!(rul.Contains("iview.aspx") || rul.Contains("tstructdesign.aspx") || rul.Contains("listiview.aspx") || rul.Contains("ivtoivload.aspx") || rul.Contains("tstruct.aspx") || rul.Contains("ivtstload.aspx") || rul.Contains("err.aspx") || rul.Contains("cpwd.aspx") || rul.Contains("ParamsTstruct.aspx")))
            //return string.Empty;

            utilObj.ClearSession();
            int urlIndex = -1;
            if (Session["allUrls"] != null)
                allUrls = (List<string>)Session["allUrls"];

            if (Session["urlIndex"] != null)
                urlIndex = (int)Session["urlIndex"];

            bool fromHyperLink = false;
            if (HttpContext.Current.Session["AxFromHypLink"] != null)
            {
                if (HttpContext.Current.Session["AxFromHypLink"].ToString() == "true")
                {
                    fromHyperLink = true;
                    HttpContext.Current.Session["AxFromHypLink"] = "false";
                }
            }
            Session["enableBackButton"] = true;
            Session["enableForwardButton"] = true;
            Session["backForwBtnPressed"] = true;

            if (urlIndex != -1 && allUrls.Count > urlIndex)
            {
                string newUrl = string.Empty;
                //If the url is a iview with hyperlink urls
                if (allUrls[urlIndex].ToString().IndexOf('♣') != -1)
                {
                    newUrl = GetPrevNavUrl(urlIndex);
                    Session["allUrls"] = allUrls;
                }
                else
                {
                    if (buttonName == "back" && !fromHyperLink)
                        urlIndex = urlIndex - 1;
                    else if (buttonName == "forward")
                        urlIndex = urlIndex + 1;
                    if (urlIndex != -1)
                    {
                        if (allUrls[urlIndex].ToString().IndexOf('♣') != -1)
                        {
                            newUrl = GetPrevNavUrl1(urlIndex);
                            if (allUrls[urlIndex + 1].ToString().Contains("tstructdesign.aspx") || allUrls[urlIndex + 1].ToString().Contains("listIview.aspx") || allUrls[urlIndex + 1].ToString().Contains("axp_IsSaveUrl=true") || allUrls[urlIndex + 1].ToString().Contains("tstruct.aspx"))
                            {
                                allUrls.RemoveAt(urlIndex + 1);
                                Session["allUrls"] = allUrls;
                            }
                        }
                        else
                        {
                            if (allUrls.Count() <= urlIndex + 1 && fromHyperLink)
                            {
                                urlIndex = urlIndex - 1;
                                newUrl = allUrls[urlIndex].ToString();
                                allUrls.RemoveAt(urlIndex);
                            }
                            else
                            {
                                newUrl = allUrls[urlIndex].ToString();
                                allUrls.RemoveAt(urlIndex + 1);
                            }
                            Session["allUrls"] = allUrls;
                        }
                        Session["urlIndex"] = urlIndex;
                    }
                }
                return newUrl;
            }
            return string.Empty;
        }

        private string GetPrevNavUrl1(int urlIndex)
        {
            string newUrl = string.Empty;
            string[] newUrls = allUrls[urlIndex].Split('♣');
            newUrl = newUrls[newUrls.Length - 1].ToString();
            return newUrl;
        }

        private string GetPrevNavUrl(int urlIndex)
        {
            string newUrl = string.Empty;
            string[] newUrls = allUrls[urlIndex].Split('♣');
            string updUrl = string.Empty;

            for (int i = 0; i < newUrls.Length - 1; i++)
            {
                if (i == newUrls.Length - 2)
                {
                    newUrl = newUrls[i].ToString();

                }
                if (updUrl == string.Empty)
                    updUrl = newUrls[i].ToString();
                else
                    updUrl += "♣" + newUrls[i].ToString();

            }
            allUrls[urlIndex] = updUrl;
            return newUrl;
        }
        #endregion


        [WebMethod(EnableSession = true)]
        public void CreateTimeLog(string clientStartTime, string clientTime1, string clientTime2, string asbTot, string asbDb, string serviceName, string dataKey)
        {
            GetGlobalVars();
            string path = utilObj.ScriptsPath + "\\log\\" + sessionid;
            string serverTime = string.Empty;
            TStructData tstData = (TStructData)Session[dataKey];
            if (tstData != null)
                serverTime = tstData.strServerTime;
            //Sid,tid,rid,Service,start time,cl1,wt1,asb,wt2 ,cl2, ASBTot, ASBDB
            string logData = sessionid + "," + tstData.transID + "," + tstData.recordid + "," + serviceName + "," + clientStartTime + "," + clientTime1 + "," + serverTime + "," + clientTime2 + "," + asbTot + "," + asbDb;

            utilObj.WriteToFileExt(path, "Timetaken", logData);
        }

        // iview caching : on unload deletes all existing cached iview files.
        [WebMethod(EnableSession = true)]
        public void DeleteIviewCacheFiles(string iName)
        {
            if (Session["project"] == null) return;
            string ScriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            string path = ScriptsPath + "axpert\\" + sessionid + "\\" + iName;
            DirectoryInfo di = new DirectoryInfo(path);
            if (di.Exists)
            {
                try
                {
                    //utilObj.DeleteIviewFiles(path);
                }
                catch (Exception ex)
                {
                    logobj.CreateLog("Exception while Creating session id folder in DeleteIviewCacheFiles" + ex.StackTrace + "------Path-" + ScriptsPath, HttpContext.Current.Session["nsessionid"].ToString(), "Exception", "new");
                }
            }
        }
        [WebMethod(EnableSession = true)]
        public string TestMailSettings(string smptpHost, string smptpPort, string smptpUser, string smptpPassword)
        {
            string errorLog = logobj.CreateLog("Smptp Mail Settings", sessionid, "SmptpMailsettings", "new");
            string result = string.Empty;
            try
            {
                string iXml = string.Empty;
                string tstType = "tstruct";
                string tstName = "Axpert Properties";
                string authMail = "false";
                string userMailfrom = string.Empty;
                if (HttpContext.Current.Session["AxEmailId"] != null && HttpContext.Current.Session["AxEmailId"].ToString() != string.Empty)
                    userMailfrom = HttpContext.Current.Session["AxEmailId"].ToString();
                if (userMailfrom != string.Empty && userMailfrom != "")
                {
                    XmlDocument xDoc = new XmlDocument();
                    xDoc.LoadXml(HttpContext.Current.Session["axGlobalVars"].ToString());
                    if (xDoc != null)
                    {
                        var auth = xDoc.SelectSingleNode("transparent_mailauth");
                        if (auth != null)
                        {

                            authMail = auth.Value.ToString();

                        }

                    }
                    iXml = "<root axpapp='" + HttpContext.Current.Session["project"] + "' sessionid='" + Session["nsessionid"].ToString() + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='" + errorLog + "' host='" + smptpHost + "' portno='" + smptpPort + "' userid='" + smptpUser + "' pwd='" + smptpPassword + "' stype='" + tstType + "' sname='" + tstName + "' mailfrom='" + userMailfrom + "' transparent_mailauth='" + authMail + "'> ";
                    iXml += "</root>";

                    result = asbExt.CallTestMailSettings(iXml);
                }
                else result = "<error>Logged in user email is not set</error>";
            }
            catch (Exception ex)
            {

            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public void UnlockTStructRecord(string transId, string recordId, bool unlockByAdmin = false)
        {
            GetGlobalVars();
            Session["axp_lockonrecid"] = null;
            string errorLog = logobj.CreateLog("Unlocking the record", sessionid, "UnlockRecord", "new");
            string iXml = string.Empty;
            iXml = "<root axpapp='" + project + "' sessionid='" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='" + errorLog + "' transid='" + transId + "' " + (unlockByAdmin ? "unlockby='superuser'" : "") + " recordid='" + recordId + "'>";
            iXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;
            result = asbExt.CallUnlockTStructRecord(iXml);
        }

        [WebMethod(EnableSession = true)]
        public void SignOut()
        {
            try
            {
                GetGlobalVars();
            }
            catch (Exception ex)
            { }
            try
            {
                if (project != "")
                {
                    CallUnlockTstructRecord();
                    string AxCloudDB = string.Empty;
                    if (Session["AxCloudDB"] != null)
                        AxCloudDB = Session["AxCloudDB"].ToString();
                    string errorLog = logobj.CreateLog("Calling Signout ws", sessionid, "Signout", "new");
                    string iXml = string.Empty;
                    string Svrlic_redis = string.Empty;
                    if (Session["Svrlic_redis"] != null)
                        Svrlic_redis = Session["Svrlic_redis"].ToString();
                    iXml = "<root axpapp='" + project + "' sessionid='" + sessionid + "' " + Svrlic_redis + " trace='" + errorLog + "'>";
                    if (Session["axApps"] != null)
                        iXml += Session["axApps"].ToString() + Application["axProps"].ToString();
                    else if (project != "" && Application[project + "-axApps"] != null)
                        iXml += Application[project + "-axApps"].ToString() + Application["axProps"].ToString();
                    iXml += "</root>";
                    utilObj.RemoveLoggedUserDetails(project, sessionid);
                    utilObj.DeleteKeepAliveWebKey();
                    utilObj.SaveExecutionText();
                    utilObj.DeleteUnwantedKeys();
                    utilObj.TempAttaServerFiles();
                    utilObj.ClearUserIviewData();
                    string result = string.Empty;
                    utilObj.delALLNotificiationKeyfromRedis();
                    result = asbExt.CallLogoutWS("Signout", iXml);
                    //utilObj.RemoveLoggedUserDetails(project, sessionid);
                    string scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                    scriptsPath = scriptsPath + "Axpert\\" + sessionid;
                    if (Directory.Exists(scriptsPath) && sessionid != "")
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
                    if (AxCloudDB != string.Empty)
                        Application["AxCloudDB"] = AxCloudDB;
                }
            }
            catch (Exception ex)
            {
                utilObj.KillSession();
            }
        }

        private void CallUnlockTstructRecord()
        {
            if (Session["axp_lockonrecid"] != null && (Session["axp_isLockOnRead"] != null && Session["axp_isLockOnRead"].ToString() == "true"))
            {
                string errorLog = logobj.CreateLog("Calling Unlock Tstruct ws", sessionid, "Unlock", "new");
                try
                {
                    string[] recLockDetails = Session["axp_lockonrecid"].ToString().Split('~');
                    logobj.CreateLog("Transid=" + recLockDetails[0].ToString() + ", Recid=" + recLockDetails[1].ToString(), sessionid, "Unlock", "");
                    UnlockTStructRecord(recLockDetails[0].ToString(), recLockDetails[1].ToString());
                }
                catch (Exception ex)
                {
                    logobj.CreateLog("Exception in Unlock tstruct-" + ex.Message, sessionid, "Unlock", "");
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public string GetRecordId(string transId, string param)
        {
            param = "<values>" + param + "</values>";
            GetGlobalVars();
            string errorLog = logobj.CreateLog("Calling get recordid ws", sessionid, "getrecid", "new");
            string iXml = string.Empty;
            iXml = "<root axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' transid='" + transId + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
            iXml += param + Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            string result = string.Empty;

            result = asbExt.CallGetRecordIdWS(transId, iXml);
            if (result != null)
                result = result.Split('♠')[1];
            return result;
        }


        [WebMethod(EnableSession = true)]
        public void SaveIntUser(string name, string org, string email, string mob, string partner)
        {
            string result = string.Empty;
            string qry = null;
            qry = "insert into intusers values('" + name + "','" + org + "','" + email + "','" + mob + "','" + partner + "')";
            result = ads.GetChoices(qry, false);
            if (result != "done")
            {

            }

        }

        [WebMethod(EnableSession = true)]
        public string SetActionIvParams(string url, string paramStr, string iviewName)
        {
            //HttpContext.Current.Session["AxActionParams" + iviewName] = paramStr;
            // HttpContext.Current.Session["IviewNavigationData-" + iviewName] = paramStr;
            this.SetIviewNavigationData(paramStr, iviewName);
            return url;
        }

        [WebMethod(EnableSession = true)]
        public object SetExportParams(string url, string paramStr, string iviewName)
        {
            HttpContext.Current.Session["AxIvExportParams-" + iviewName] = paramStr;
            return new { url, paramStr, iviewName };
        }

        [WebMethod(EnableSession = true)]
        public bool SetIviewNavigationData(string paramStr, string iviewName)
        {
            bool returnSuccess = false;
            string username = HttpContext.Current.Session["username"].ToString();
            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();
            Util.Util util = new Util.Util();

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            if (fObj == null)
            {
                fObj = new FDR();
                HttpContext.Current.Session["FDR"] = fObj;
            }

            JObject jObj = new JObject();
            if (fObj.IsConnected)
            {
                try
                {
                    jObj = JObject.Parse(fObj.StringFromRedis(util.GetRedisServerkey(Constants.IviewNavigationData, iviewName), schemaName));
                }
                catch (Exception ex)
                { }
            }

            FDW objFDW = FDW.Instance;

            if (objFDW.IsConnected)
            {
                jObj[username] = paramStr;

                returnSuccess = objFDW.SaveInRedisServerDT(util.GetRedisServerkey(Constants.IviewNavigationData, iviewName), jObj, "", schemaName);
            }
            else
            {
                HttpContext.Current.Session["IviewNavigationData-" + iviewName] = paramStr;
                returnSuccess = true;
            }


            return returnSuccess;
        }


        [WebMethod(EnableSession = true)]
        public string GetIviewNavigationData(string iviewName)
        {
            string returnString = string.Empty;
            string username = HttpContext.Current.Session["username"].ToString();
            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();
            Util.Util util = new Util.Util();
            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            if (fObj == null)
            {
                fObj = new FDR();
                HttpContext.Current.Session["FDR"] = fObj;
            }

            if (fObj.IsConnected)
            {
                //returnString = fObj.StringFromRedis(util.GetRedisServerkey(Constants.IviewNavigationData, iviewName), schemaName);
                JObject jObj = new JObject();
                try
                {
                    jObj = JObject.Parse(fObj.StringFromRedis(util.GetRedisServerkey(Constants.IviewNavigationData, iviewName), schemaName));

                    returnString = jObj[username].ToString();
                }
                catch (Exception ex)
                { }
            }
            else if (HttpContext.Current.Session["IviewNavigationData-" + iviewName] != null)
            {
                returnString = HttpContext.Current.Session["IviewNavigationData-" + iviewName].ToString();
            }

            //if (returnString == string.Empty) {
            //    returnString = "{}";
            //}

            return returnString;
        }



        [WebMethod(EnableSession = true)]
        public void GetAxpString()
        {
            string result = string.Empty;
            string trace = "false";
            string errorLog = string.Empty;
            if (ConfigurationManager.AppSettings["LoginTrace"] != null)
                trace = ConfigurationManager.AppSettings["LoginTrace"].ToString().ToLower();

            errorLog = logobj.CreateLog("Calling GetAxpString-", "logAxpString", "GetAxpString", "new", trace);
            result = asbExt.CallAxpString();
            logobj.CreateLog(result, "logAxpString", "GetAxpString", "", trace);
            if (result != string.Empty)
            {
                XmlDocument xmlDoc = new XmlDocument();
                try
                {
                    xmlDoc.LoadXml(result);
                }
                catch (Exception ex)
                {
                }
                XmlNode resultNode = null;


                resultNode = xmlDoc.SelectSingleNode("//result");
                if (resultNode != null)
                {
                    foreach (XmlNode childNode in resultNode.ChildNodes)
                    {
                        if (childNode.Name == "macid")
                            Application["AxpString1"] = childNode.InnerText;
                        else if (childNode.Name == "licfile")
                            Application["AxpString2"] = childNode.InnerText;
                    }
                }

                XmlNode errNode = null;

                errNode = xmlDoc.SelectSingleNode("//e");
                if (errNode != null)
                    Application["AxpString1"] = errNode.OuterXml;
            }
        }

        public void SetServerLicense()
        {
            try
            {
                string redisIp = string.Empty;
                string redisPwd = string.Empty;
                string scrPath = string.Empty;
                if (HttpContext.Current.Application["ScriptsPath"] != null)
                    scrPath = HttpContext.Current.Application["ScriptsPath"].ToString();

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
                    string rcDetails = utilObj.GetAxpLicRedisConnDetails();
                    if (rcDetails != "")
                    {
                        redisIp = rcDetails.Split('♣')[0];
                        redisPwd = rcDetails.Split('♣')[1];
                    }
                }

                if (redisIp != string.Empty)
                {
                    string rlicConn = utils.GetServerLicDetails(redisIp, redisPwd);
                    switch (rlicConn)
                    {
                        case "notConnected":
                            logobj.CreateLog("SetServerLicense: Redis Connection details for Axpert license is not proper. Please contact your support person.", "", "SetServerLicense", "new", "true");
                            break;
                        case "keyNotMatch":
                            logobj.CreateLog("SetServerLicense: Redis IP for Axpert license should be set as 127.0.0.1. Please contact your support person.", "", "SetServerLicense", "new", "true");
                            break;
                        case "keyNotExists":
                            string[] filePaths = Directory.GetFiles(@scrPath, "*-axpertsrvr.lic");
                            if (filePaths.Count() > 0)
                            {
                                string licFileName = filePaths[0].Split('\\').Last();
                                string result = string.Empty;
                                if (redisPwd != string.Empty)
                                    redisPwd = utils.EncryptPWD(redisPwd);
                                string strInpt = redisIp + "~" + redisPwd + "," + licFileName;
                                result = asbExt.CallServerLicense(strInpt);
                                if (result != "done")
                                    logobj.CreateLog("SetServerLicense: Result:" + result, "", "SetServerLicense", "new", "true");
                            }
                            else
                                logobj.CreateLog("SetServerLicense: Server license file not exists in the script folder. please activate server license or if already activated copy lic file in current script folder.", "", "SetServerLicense", "new", "true");
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("SetServerLicense -" + ex.Message, "", "SetServerLicense", "new", "true");
            }
        }

        [WebMethod(EnableSession = true)]
        public string GetParams(string iViewname)
        {
            if (iViewname != "")
            {
                WebServiceExt objWebServiceExt = new WebServiceExt();
                string fileName = "openiview-" + iViewname;
                string errLog = logobj.CreateLog("Call to GetParams Web Service", Session["nsessionid"].ToString(), fileName, "");
                string iXml = string.Empty;
                iXml = "<root name =\"" + iViewname + "\" axpapp = \"" + Session["project"].ToString() + "\" sessionid = \"" + Session["nsessionid"].ToString() + "\" appsessionkey=\"" + HttpContext.Current.Session["AppSessionKey"].ToString() + "\" username=\"" + HttpContext.Current.Session["username"].ToString() + "\" trace = \"" + errLog + "\"  >";
                iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
                string ires = string.Empty;
                IviewData objIview = new IviewData();
                objIview.WebServiceTimeout = objWebServiceExt.asbIview.Timeout;
                ires = objWebServiceExt.CallGetParamsWS(iViewname, iXml, objIview);
                if (ires != null)
                    ires = ires.Split('♠')[1];
                if (ires == "" || ires.Contains("Disconnected because you have logged into another session.") || ires.Contains("error"))
                {
                    return ires;
                }
                return ConstructParamsHtml(ires);
            }
            else
                return "invalid Iview";
            //return ires;
        }

        [WebMethod(EnableSession = true)]
        public string GetContactInfo()
        {
            string result = string.Empty;
            if (HttpContext.Current.Session["project"] != null)
            {
                result = Session["m_contactinfo"].ToString();
            }
            return result;
        }


        private string ConstructParamsHtml(string result)
        {

            StringBuilder strJsArrays = new StringBuilder();
            StringBuilder strParamDetails = new StringBuilder();
            ArrayList iviewParamValues = new ArrayList();
            ArrayList iviewParams = new ArrayList();
            bool isSqlFld = false;
            string clientCulture = null;

            IviewData objIview = new IviewData();
            string _xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
            StringBuilder paramHtml = new StringBuilder();
            result = _xmlString + result;
            // logobj.CreateLog("Loading and setting parameters components", sid, fileName, string.Empty);
            string parameterName = string.Empty;
            string paramCaption = string.Empty;
            string paramType = string.Empty;
            string paramHidden = string.Empty;
            string paramMOE = string.Empty;
            string paramValue = string.Empty;
            string paramSql = string.Empty;
            string paramDepStr = string.Empty;
            Boolean unHideParams = false;
            string expr = string.Empty;
            string vExpr = string.Empty;
            int tabIndex = 0;

            XmlDocument xmlDoc = new XmlDocument();
            XmlNodeList productNodes = default(XmlNodeList);
            XmlNodeList baseDataNodes = default(XmlNodeList);
            //  StringBuilder strJsArrays = new StringBuilder();
            int iCnt = 0;
            int fldNo = 0;
            int dpCnt = 0;
            try
            {
                xmlDoc.LoadXml(result);
            }
            catch (XmlException ex)
            {
                // Response.Redirect(util.ERRPATH + ex.Message);
            }

            productNodes = xmlDoc.SelectNodes("//root");
            bool showParam = false;
            if (productNodes[0].Attributes["showparams"] != null && productNodes[0].Attributes["showparams"].Value != string.Empty)
                showParam = Convert.ToBoolean(productNodes[0].Attributes["showparams"].Value);



            string ivCaption = xmlDoc.SelectSingleNode("root").Attributes["caption"].Value;
            ivCaption = ivCaption.Replace("&&", "&");
            string lblHeading = ivCaption;
            objIview.IviewCaption = ivCaption;
            bool paramsBound = true;
            string Paramsids = string.Empty;
            //string Paramsids = "<div id='paramsValue' style='display:none'>";
            foreach (XmlNode productNode in productNodes)
            {
                baseDataNodes = productNode.ChildNodes;
                paramHtml.Append("<table id=\"ivParamTable\" style='width:100%;border-spacing:0px;padding:10px;border:0px' ><tr style=\"height:15px;\">");
                foreach (XmlNode baseDataNode in baseDataNodes)
                {
                    if (baseDataNode.Attributes["cat"].Value == "params")
                    {
                        paramValue = string.Empty;
                        if (baseDataNode.Attributes["value"] != null)
                            paramValue = baseDataNode.Attributes["value"].Value;

                        iviewParamValues.Add(paramValue);

                        foreach (XmlNode tstNode in baseDataNode)
                        {
                            if (tstNode.Name == "a0")
                            {
                                parameterName = tstNode.InnerText;
                                iviewParams.Add(parameterName);
                            }
                            else if (tstNode.Name == "a2")
                            {
                                paramCaption = tstNode.InnerText;
                                strParamDetails.Append(paramCaption + ",");
                                if (paramCaption == "axp_refresh" && objIview.iviewParams != null)
                                    objIview.iviewParams.Axp_refresh = "true";

                            }
                            else if (tstNode.Name == "a4")
                            {
                                paramType = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a6")
                            {
                                expr = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a10")
                            {
                                vExpr = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a21")
                            {
                                paramHidden = tstNode.InnerText;
                                strParamDetails.Append(paramHidden + "~");
                            }
                            else if (tstNode.Name == "a13")
                            {
                                paramMOE = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a56")
                            {
                                //pvalue = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a11")
                            {
                                paramSql = tstNode.InnerText;
                            }
                            else if (tstNode.Name == "a15")
                            {
                                foreach (XmlNode selNode in tstNode)
                                {
                                    if (selNode.Name == "s")
                                    {
                                        paramDepStr = selNode.InnerText.ToString();
                                    }
                                }
                            }
                            else if (tstNode.Name == "response")
                            {
                                ComboFill(tstNode);
                                isSqlFld = true;
                            }

                        }
                    }
                    if (paramType == "Date/Time" && clientCulture.ToLower() == "en-us")
                    {
                        paramValue = utilObj.GetClientDateString(clientCulture, paramValue);

                        if (paramMOE.ToLower() == "select" && arrFillList.Count > 0)
                        {
                            for (int y = 0; y <= arrFillList.Count - 1; y++)
                                arrFillList[y] = utilObj.GetClientDateString(clientCulture, arrFillList[y].ToString());
                        }
                    }

                    //construction of parameters.
                    strJsArrays.Append("parentArr[" + fldNo + "]='" + parameterName + "';typeArr[" + fldNo + "]='" + paramMOE + "';paramType[" + fldNo + "]='" + paramType + "';depArr[" + fldNo + "]='" + paramDepStr + "';hiddenArr[" + fldNo + "]='" + paramHidden + "';Expressions[" + fldNo + "]='" + expr + "';pCurArr[" + fldNo + "]= '" + paramValue + "';vExpressions[" + fldNo + "]='" + vExpr + "'; ");

                    //string paramsString = "parentArr[" + fldNo + "],typeArr["+ fldNo +"], ";
                    //strJsArrays.Append("saveIviewParams(typeArr[" + fldNo + "] )";
                    paramHidden = paramHidden.ToLower();
                    if (paramHidden == "false" && objIview.iviewParams != null)
                    {
                        objIview.iviewParams.IsParameterExist = true;

                        if (paramsBound && paramValue == string.Empty)
                        {
                            if (paramMOE.ToLower() == "select")
                            {
                                if (arrFillList.Count > 0 && arrFillList[0].ToString() != string.Empty)
                                    paramsBound = true;
                                else
                                    paramsBound = false;
                            }
                            else
                                paramsBound = false;
                        }

                        tabIndex = tabIndex + 1;
                        unHideParams = true;
                        string CallValidateExpr = string.Empty;
                        if (!string.IsNullOrEmpty(vExpr))
                        {
                            if (paramMOE.ToLower() == "accept")
                            {
                                if (paramType == "Date/Time")
                                    CallValidateExpr = "onChange=\"FillDependents('" + parameterName + "');\" ";
                                else
                                    CallValidateExpr = "onBlur=\"FillDependents('" + parameterName + "');\" ";

                            }
                            else if ((paramMOE.ToLower() == "select") | (paramMOE.ToLower() == "pick list"))
                            {
                                CallValidateExpr = "onChange=\"FillDependents('" + parameterName + "');\" ";
                            }
                        }
                        else
                        {
                            if (paramMOE.ToLower() == "accept")
                            {
                                CallValidateExpr = "onblur=\"FillDependents('" + parameterName + "');\" ";
                            }
                            else if ((paramMOE.ToLower() == "select") | (paramMOE.ToLower() == "pick list"))
                            {
                                CallValidateExpr = "onChange=\"FillDependents('" + parameterName + "');\" ";
                            }
                        }

                        if ((paramMOE.ToLower() == "accept") & (paramType == "Date/Time") & (!string.IsNullOrEmpty(expr)))
                        {
                            if (expr.ToLower() != "date()")
                            {
                                paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "' class='tem Family date' style='width:80%' TabIndex='" + tabIndex + "' ></td>");
                                paramHtml.Append("</tr><tr>");
                            }
                            else
                            {
                                paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "' class='tem Family date' style='width:80%' TabIndex='" + tabIndex + "' " + CallValidateExpr + "></td>");
                                paramHtml.Append("</tr><tr>");
                            }
                        }
                        else if ((paramMOE.ToLower() == "accept") & (paramType == "Date/Time") & (string.IsNullOrEmpty(expr)))
                        {
                            if (paramDepStr != string.Empty)
                            {
                                paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "' class='tem Family date' style='width:80%' TabIndex='" + tabIndex + "' " + CallValidateExpr + "></td>");
                                paramHtml.Append("</tr><tr>");
                            }
                            else
                            {
                                paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "' class='tem Family date' style='width:80%' TabIndex='" + tabIndex + "'></td>");
                                paramHtml.Append("</tr><tr>");
                            }
                        }
                        else if ((paramMOE.ToLower() == "accept") & (!string.IsNullOrEmpty(expr)))
                        {
                            paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "' class='tem Family' style='width:80%'  TabIndex='" + tabIndex + "' " + CallValidateExpr + "></td>");
                            paramHtml.Append("</tr><tr>");
                        }
                        else if ((paramMOE.ToLower() == "accept"))
                        {
                            paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' TabIndex='" + tabIndex + "' value='" + paramValue + "' style='width:80%' class='tem Family' " + CallValidateExpr + "></td>");
                            paramHtml.Append("</tr><tr>");
                        }
                        else if ((paramMOE.ToLower() == "pick list"))
                        {
                            paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><input type=text id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "'  class='tem Family'" + CallValidateExpr + " style='width:80%' >&nbsp;<a><img align='middle' src=\"../AxpImages/pickList.png\" id=\"img~" + parameterName + "\"  style=\"cursor:hand;vertical-align: middle;border:0px;\" /></a></td>");
                            paramHtml.Append("</tr><tr>");
                            arrFillList.Clear();
                        }
                        else if ((paramMOE.ToLower() == "select") & isSqlFld == true)
                        {
                            paramHtml.Append("<td class=paramtd1 style='width:50%'><font class=cap>" + paramCaption + "</font></td><td class=paramtd2 style='width:50%'><select TabIndex='" + tabIndex + "' id='" + parameterName + "' name='" + parameterName + "'  class='combotem Family' style='width:85%' " + CallValidateExpr + ">");
                            // onmouseover=\"showHideTooltip(this.id);\"
                            int i = 0;
                            if (arrFillList.Count == 0)
                            {
                                paramHtml.Append("<option selected> </option>");
                            }
                            for (i = 0; i <= arrFillList.Count - 1; i++)
                            {
                                if (arrFillList[i].ToString() == paramValue)
                                {
                                    paramHtml.Append("<option selected value='" + arrFillList[i].ToString() + "'>" + arrFillList[i].ToString() + "</option>");
                                }
                                else
                                {
                                    if (i == 0)
                                    {
                                        paramHtml.Append("<option value=''></option>");
                                        paramHtml.Append("<option value='" + arrFillList[i].ToString() + "'>" + arrFillList[i].ToString() + "</option>");
                                        strFillDepPName = strFillDepPName + parameterName + "¿";
                                    }
                                    else
                                    {
                                        paramHtml.Append("<option value='" + arrFillList[i].ToString() + "'>" + arrFillList[i].ToString() + "</option>");
                                    }
                                }
                            }
                            paramHtml.Append("</select></td>");
                            paramHtml.Append("</tr><tr>");
                            arrFillList.Clear();
                            isSqlFld = false;
                        }
                        else if (paramMOE.ToLower() == "select" & isSqlFld == false)
                        {
                            paramHtml.Append("<td class=paramtd1 ><font class=cap>" + paramCaption + "</font></td><td class=paramtd2><select id='" + parameterName + "' name='" + parameterName + "' TabIndex='" + tabIndex + "'  class='combotem Family' style=width:85%;  " + CallValidateExpr + "></select></td>");
                            paramHtml.Append("</tr><tr>");
                        }
                        else if (((paramMOE.ToLower() == "multi select") & (isSqlFld == true)))
                        {
                            paramHtml.Append("<td  class=paramtd1 valign=top ><font class=cap>" + paramCaption + "</font></td><td class=paramtd2><select id='" + parameterName + "' name='" + parameterName + "' TabIndex='" + tabIndex + "' class='combotem Family' style=width:85%;height:100px;  multiple=\"multiple\"  " + CallValidateExpr + ">");
                            int i = 0;
                            for (i = 0; i <= arrFillList.Count - 1; i++)
                            {
                                if (arrFillList[i].ToString() == paramValue)
                                {
                                    paramHtml.Append("<option selected value='" + arrFillList[i].ToString() + "'>" + arrFillList[i].ToString() + "</option>");
                                }
                                else
                                {
                                    paramHtml.Append("<option value='" + arrFillList[i].ToString() + "'>" + arrFillList[i].ToString() + "</option>");
                                }
                            }
                            paramHtml.Append("</select></td>");
                            paramHtml.Append("</tr><tr>");
                            arrFillList.Clear();
                            isSqlFld = false;
                        }
                        else if (((paramMOE.ToLower() == "multi select") & (isSqlFld == false)))
                        {
                            paramHtml.Append("<td  class=paramtd1 valign=top ><font class=cap>" + paramCaption + "</font></td><td class=paramtd2><select id='" + parameterName + "' name='" + parameterName + "' TabIndex='" + tabIndex + "' class='combotem Family' style=width:85%;height:100px;  multiple=\"multiple\"  " + CallValidateExpr + ">");
                            paramHtml.Append("</select></td>");
                            paramHtml.Append("</tr><tr>");
                        }

                        iCnt = iCnt + 1;
                        if (CallValidateExpr != string.Empty && paramDepStr != string.Empty)
                        {
                            strJsArrays.Append("depParamArr[" + dpCnt + "]='" + parameterName + "';");
                            dpCnt++;
                        }
                        CallValidateExpr = string.Empty;
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(paramValue))
                        {
                            paramHtml.Append("<input type=hidden id='" + parameterName + "' name='" + parameterName + "' value='" + paramValue + "'>");
                        }
                        else
                        {
                            paramHtml.Append("<input type=hidden id='" + parameterName + "' name='" + parameterName + "' value=''>");
                        }


                    }
                    fldNo = fldNo + 1;
                    paramDepStr = string.Empty;
                    if (iCnt == 2)
                    {
                        iCnt = 0;
                        paramHtml.Append("</tr><tr>");

                    }
                    Paramsids += parameterName + ",";

                }

            }
            //Paramsids += "</div>";
            //Session["paramDetails"] = strParamDetails.ToString();
            //Session["FillDepPName"] = strFillDepPName;

            paramHtml.Append("¥");
            //paramHtml.Append(strJsArrays);
            paramHtml.Append(Paramsids);
            return paramHtml.ToString() + "ƒ" + strJsArrays.ToString();


        }


        [WebMethod(EnableSession = true)]
        public void ComboFill(XmlNode baseDataNode)
        {
            foreach (XmlNode rowdNode in baseDataNode.ChildNodes)
            {
                if (rowdNode.ChildNodes[0] != null)
                {
                    if (rowdNode.ChildNodes[0].InnerText != "*")
                    {
                        string ddlValue = utils.CheckSpecialChars(rowdNode.ChildNodes[0].InnerText);

                        ddlValue = Regex.Replace(ddlValue, "&apos;", "&#39;");
                        arrFillList.Add(ddlValue);
                    }
                }

            }
        }

        [WebMethod(EnableSession = true)]
        public string GetIviewRecordCount(string IvName, string Parameters, bool isListView)
        {
            string iXml = string.Empty;
            string errlog = string.Empty;
            string result = string.Empty;
            string fileName = "GetIviewRecordCount-" + IvName;
            string paramXml;
            paramXml = ConstructParamXml(Parameters);
            string sessionId = string.Empty;
            sessionId = HttpContext.Current.Session.SessionID;
            errlog = logobj.CreateLog("GetIviewRecordCount ", sessionId, fileName, "");

            string purposeString = string.Empty;

            if (isListView)
            {
                purposeString = " purpose=\"list\" ";
            }

            iXml = "<root " + purposeString + " name ='" + IvName + "' axpapp = '" + Session["project"].ToString() + "' sessionid = '" + Session["nsessionid"].ToString() + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "' trace = '" + errlog + "' pageno='1' pagesize='1000' firsttime='yes' sqlpagination='true' getrowcount='true' gettotalrows='true'><params>" + paramXml + "</params>";
            //}

            iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root> ";

            //Call service
            result = asbExt.CallGetRecordCount(IvName, iXml, "");
            return result;
        }

        public string GetFilterData(string IvName, string Parameters)
        {
            string iXml = string.Empty;
            string errlog = string.Empty;
            string result = string.Empty;

            string title = string.Empty;
            string subTitle = string.Empty;
            string customText = string.Empty;
            string footer = string.Empty;
            DataSet dst = new DataSet();
            string fileName = "GetIViewFromObject-" + IvName;
            string paramXml;


            paramXml = ConstructParamXml(Parameters);

            iXml = "<root name ='" + IvName + "' axpapp = '" + Session["project"].ToString() + "' sessionid = '" + Session["nsessionid"].ToString() + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "' trace = '" + errlog + "' pageno='" + 1 + "' pagesize='" + 10 + "' firsttime='" + "yes" + "' sqlpagination='" + "true" + "'><params>" + paramXml + "</params>";
            //}

            iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root> ";

            //Call service
            IviewData objIview = new IviewData();
            objIview.WebServiceTimeout = asbExt.asbIview.Timeout;
            result = asbExt.CallGetIViewWS(IvName, iXml, "", objIview);
            if (result != null)
                result = result.Split('♠')[1];



            string errMsg = utils.ParseXmlErrorNode(result);

            if (errMsg != string.Empty)
            {
                return dst.GetXml();
            }
            else
            {
                XmlDocument xmlDoc = new XmlDocument();
                XmlNodeList XmlNodeList = default(XmlNodeList);

                try
                {
                    xmlDoc.LoadXml(result);
                }
                catch (Exception ex)
                {
                    // if (trace)
                    // {
                    //  logobj.CreateLog("Exception in GetIview Service :--- " + ex.Message.ToString(), sessionId, fileName, "");
                    // }
                    return null;
                }
                //GetSubCaptions(xmlDoc);
                //CreateHeaderRow(xmlDoc, pageNo.ToString());
                XmlNodeList = xmlDoc.SelectNodes("//headrow");
                int recCount = Convert.ToInt32(XmlNodeList[0].Attributes["reccount"].Value);
                //remove all other nodes other than data and call binddata
                XmlNode rnode = xmlDoc.SelectSingleNode("//headrow/pivotghead");
                if (rnode != null)
                    rnode.ParentNode.RemoveChild(rnode);


                DataTable dt = new DataTable();

                dt.Columns.Add("title");
                dt.Columns.Add("subtitle");
                dt.Columns.Add("text");
                //GetCustomString();
                DataRow dr = dt.NewRow();
                XmlNodeList parentNodes = default(XmlNodeList);
                parentNodes = XmlNodeList[0].ChildNodes;
                for (int count = 0; count <= parentNodes.Count - 1; count++)
                {
                    foreach (XmlNode chldNode in parentNodes)
                    {
                        if (chldNode.Name == title)
                        {
                            dr["title"] = title;
                        }
                        else if (chldNode.Name == subTitle)
                        {
                            dr["subtitle"] = subTitle;
                        }
                        else if (chldNode.Name == customText)
                        {
                            dr["text"] = customText;
                        }

                    }
                }
                dt.Rows.Add(dr);

                XmlNode headRow = xmlDoc.SelectSingleNode("//headrow");
                headRow.ParentNode.RemoveChild(headRow);

                XmlNode cNode = xmlDoc.SelectSingleNode("//comps");
                cNode.ParentNode.RemoveChild(cNode);
                StringWriter sw = new StringWriter();
                XmlTextWriter xw = new XmlTextWriter(sw);

                try
                {
                    xmlDoc.WriteTo(xw);
                }
                catch (Exception ex)
                {
                    //if (trace)
                    // {
                    //    logobj.CreateLog("Exception in GetIview Service :--- " + ex.Message.ToString(), sessionId, fileName, "");
                    //}
                    return null;
                }
                //Bind the dataset
                string nXml = string.Empty;
                nXml = sw.ToString();
                // assign XML Val to Properite
                //IvResult = nXml;
                StringReader sr = new StringReader(nXml);
                dst.ReadXml(sr);
                //dt.TableName = "Head";
                //dst.Tables.Add(dt);
            }
            return dst.GetXml();
        }

        public string ConstructParamXml(string Parameters)
        {
            string pXml = string.Empty;
            string str = string.Empty;
            str = Parameters;
            string[] strp = utils.AxSplit1(str, "¿");
            int i = 0;

            for (i = 0; i <= strp.Length - 1; i++)
            {
                if (!string.IsNullOrEmpty(strp[i]))
                {
                    string[] arrparam = strp[i].ToString().Split('~');
                    arrparam[0] = utils.CheckSpecialChars(arrparam[0].ToString());
                    arrparam[1] = utils.CheckSpecialChars(arrparam[1].ToString());
                    if (arrparam[1].Contains("&amp;grave;") == true)
                    {
                        arrparam[1] = arrparam[1].ToString().Replace("&amp;grave;", "~");
                    }
                    pXml = pXml + "<" + arrparam[0].ToString() + ">";
                    pXml = pXml + arrparam[1].ToString();
                    pXml = pXml + "</" + arrparam[0].ToString() + ">";

                    //arrparam[1] = arrparam[1].ToString().Replace(",", "`");

                }

            }
            return pXml;
        }



        [WebMethod(EnableSession = true)]
        public string GetNewsfeed()
        {
            string result = string.Empty;
            if (HttpContext.Current.Session["project"] != null)
            {
                if (Session["NewsFeeds"] != null)
                {
                    result = Session["NewsFeeds"].ToString();
                }
                else
                {

                    string project = HttpContext.Current.Session["project"].ToString();
                    string sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                    string user = HttpContext.Current.Session["user"].ToString();
                    string AxRole = HttpContext.Current.Session["AxRole"].ToString();
                    string errorLog = string.Empty;

                    errorLog = logobj.CreateLog("Get Newsfeed", sessionid, "newsfeed", "new");
                    string iXml = string.Empty;
                    string tid = string.Empty;
                    string sql = string.Empty;
                    //string sql = "select msg, dte, msgtype from CMIS.get_livefeedvalues(:usr, getdate()) order by dte desc";

                    if (Session["AxLatestNews"] != null)
                    {
                        sql = Session["AxLatestNews"].ToString();
                    }
                    if (sql.Contains('#'))
                    {
                        sql = sql.Substring(sql.IndexOf('#') + 1);
                    }

                    string replaceStr = "'" + Session["user"].ToString() + "'";
                    //parameter with usr,uname,user is replaced.
                    sql = sql.Replace(":usr", replaceStr);
                    sql = sql.Replace(":user", replaceStr);
                    sql = sql.Replace(":uname", replaceStr);

                    iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' transid='' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
                    iXml += "<sql>" + sql + "</sql>";
                    iXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                    result = asbExt.CallGetChoiceWS(tid, iXml);
                    Session["NewsFeeds"] = result;
                }
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetLiveFeeds()
        {
            string result = string.Empty;
            if (HttpContext.Current.Session["project"] != null)
            {
                if (Session["EventReminders"] != null)
                {
                    result = Session["EventReminders"].ToString();
                }
                else
                {
                    string project = HttpContext.Current.Session["project"].ToString();
                    string sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                    string user = HttpContext.Current.Session["user"].ToString();
                    string AxRole = HttpContext.Current.Session["AxRole"].ToString();
                    string errorLog = string.Empty;

                    errorLog = logobj.CreateLog("Get EventReminders", sessionid, "eventreminders", "new");
                    string iXml = string.Empty;
                    string tid = string.Empty;
                    string sql = "";


                    //string sql = "select msg, dte, msgtype from CMIS.get_livefeedvalues(:usr, getdate()) order by dte desc";
                    if (Session["AxLiveFeeds"] != null)
                    {
                        sql = Session["AxLiveFeeds"].ToString();
                    }
                    if (sql.Contains('#'))
                    {
                        sql = sql.Substring(sql.IndexOf('#') + 1);
                    }
                    string replaceStr = "'" + Session["user"].ToString() + "'";
                    //parameter with usr,uname,user is replaced.
                    sql = sql.Replace(":usr", replaceStr);
                    sql = sql.Replace(":user", replaceStr);
                    sql = sql.Replace(":uname", replaceStr);

                    iXml = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' transid='' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
                    iXml += "<sql>" + sql + "</sql>";
                    iXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                    result = asbExt.CallGetChoiceWS(tid, iXml);
                    Session["EventReminders"] = result;
                }
            }
            return result;
        }



        [WebMethod(EnableSession = true)]
        public string GetFilePathForIviewAttachment(string proj, string tid, string fldname, string filename, string attachtype, string onlyRecordId, string onlyFileName, bool isDbAttachment, bool onlygetPath = false)
        {
            string result = "";
            string authenticationStatus = string.Empty;
            //if (!string.IsNullOrEmpty(proj) && !string.IsNullOrEmpty(tid) && !string.IsNullOrEmpty(filename))
            //proj is removed to map path same as in SaveImageToFolder in tstructdata.cs
            if (!string.IsNullOrEmpty(tid) && !string.IsNullOrEmpty(filename))
            {
                if (Session["nsessionid"] == null || string.IsNullOrEmpty(Session["nsessionid"].ToString()))
                    return utilObj.SESSTIMEOUT;
                string path = string.Empty;//concatenate the path for the file.

                if (!isDbAttachment)
                {
                    if (attachtype == "fullpath")
                    {
                        filename = utilObj.CheckReverseUrlSpecialChars(filename);
                        string splitter = Regex.Match("\\/", @"\\|\/").ToString();
                        if (splitter.Length > 0)
                        {
                            List<string> splittedArr = filename.Split(splitter.ToCharArray()[0]).ToList();
                            if (splittedArr.Count > 0)
                            {
                                //path = splittedArr
                                filename = splittedArr[splittedArr.Count - 1];
                                splittedArr.RemoveAt(splittedArr.Count - 1);
                                path = String.Join(splitter, splittedArr.ToArray()) + splitter;

                            }
                        }
                    }
                    else if (attachtype == "header" && HttpContext.Current.Session["AxpAttachmentPathGbl"] != null)
                    {
                        string tempAttachFilePath = HttpContext.Current.Session["AxpAttachmentPathGbl"].ToString();
                        if (!tempAttachFilePath.Contains(":\\") && !tempAttachFilePath.Contains("\\\\"))
                        {
                            //tempAttachFilePath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + tempAttachFilePath;
                            tempAttachFilePath = HttpContext.Current.Application["ScriptsPath"].ToString() + axpert + Session["nsessionid"] + "\\" + tempAttachFilePath;
                            if (!Directory.Exists(tempAttachFilePath))
                            {
                                Directory.CreateDirectory(tempAttachFilePath);
                            }
                        }
                        path = tempAttachFilePath + "\\" + tid + "\\";
                    }
                    else if (HttpContext.Current.Session["AxpImagePathGbl"] != null)
                    {
                        string tempGridAttachPath = HttpContext.Current.Session["AxpImagePathGbl"].ToString();
                        if (!tempGridAttachPath.Contains(":\\") && !tempGridAttachPath.Contains("\\\\"))
                        {
                            //tempGridAttachPath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + tempGridAttachPath;
                            tempGridAttachPath = HttpContext.Current.Application["ScriptsPath"].ToString() + axpert + Session["nsessionid"] + "\\" + tempGridAttachPath;
                            if (!Directory.Exists(tempGridAttachPath))
                            {
                                Directory.CreateDirectory(tempGridAttachPath);
                            }
                        }
                        path = tempGridAttachPath + "\\" + tid + "\\" + fldname + "\\";
                    }
                }

                string dPath = string.Empty;
                //string recordID = filename.Split('-')[0];
                //string fileList = filename.Replace(recordID + "-", "");

                if (path != string.Empty && !isDbAttachment && utilObj.GetAuthentication(ref authenticationStatus))
                {
                    //string resolvedFilePath = path + filename;
                    foreach (string file in filename.Split(','))
                    {
                        string internalFileName = "";
                        //filename = recordID + "-" + file;
                        DirectoryInfo di = new DirectoryInfo(path);
                        if (!di.Exists)
                            di.Create();

                        FileInfo[] fileEntries = null;

                        if (attachtype == "fullpath" || attachtype == "gridattach")
                        {
                            fileEntries = di.GetFiles(file);
                        }
                        else if (attachtype == "image")
                        {
                            fileEntries = di.GetFiles(file + ".*");
                        }
                        else if (attachtype == "header")
                        {
                            fileEntries = di.GetFiles(file + "-*");
                        }

                        if (fileEntries != null && fileEntries.Length > 0)
                        {
                            if (attachtype == "fullpath" || attachtype == "gridattach")
                            {
                                internalFileName = file;
                                FileInfo dirFile = (FileInfo)fileEntries[0];

                                result += genericFileDownloader(dirFile, internalFileName, path, ref dPath, filename, attachtype, onlygetPath);
                            }
                            else if (attachtype == "image" || attachtype == "header")
                            {
                                for (int i = 0; i < fileEntries.Length; i++)
                                {
                                    internalFileName = file;
                                    FileInfo dirFile = (FileInfo)fileEntries[i];

                                    result += genericFileDownloader(dirFile, internalFileName, path, ref dPath, filename, attachtype, onlygetPath);
                                }
                            }
                        }

                    }
                    if (!onlygetPath && attachtype == "header")
                    {
                        try
                        {
                            DirectoryInfo di = new DirectoryInfo(dPath);
                            if (!di.Exists)
                                di.Create();

                            FileInfo[] fileEntries = di.GetFiles();
                            //if (fileEntries.Length > 1)
                            //{
                            using (ZipFile zipFile = new ZipFile(Encoding.UTF8)) //to handle file name characters in all languages(UTF8)
                            {
                                try
                                {
                                    zipFile.AddDirectory(dPath);
                                    zipFile.Save(dPath.Substring(0, dPath.Length - 1) + ".zip");
                                    result = dPath.Substring(0, dPath.Length - 1) + ".zip";
                                }
                                catch (Exception)
                                {
                                    //result = "Error: Failure while processing Zipping file.";
                                }
                            }
                            //}
                        }
                        catch (Exception ex) { }
                    }
                }
                else if (isDbAttachment)
                {
                    string inputXML = string.Empty;

                    inputXML = "<root axpapp=\"" + proj + "\"  sessionid=\"" + Session["nsessionid"].ToString() + "\"  filename=\"" + onlyFileName + "\" transid=\"" + tid /*+ fldname*/ + "\"  recordid=\"" + onlyRecordId + "\"   trace=\"♦♦GetAttachedFile♦\">";

                    string errorLog = logobj.CreateLog("Get Structure object from cache for view attachment.", sessionid, "GetStructXml-", "new");
                    inputXML = GetTraceString(inputXML);

                    inputXML = inputXML + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";

                    ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();

                    result = objWebServiceExt.CallViewAttachmentsWS(tid, inputXML, "");

                    JObject resultJSON = new JObject();

                    try
                    {
                        resultJSON = JObject.Parse(result);
                        resultJSON["basePath"] = utilObj.ScriptsurlPath + "Axpert/" + Session["nsessionid"].ToString() + "/";

                        result = resultJSON.ToString();
                    }
                    catch (Exception ex)
                    { }
                }
            }
            else
                return "Error: Invalid Param Values.";

            if (!onlygetPath && result == "" || result == "♠")
            {
                if (authenticationStatus == "" || authenticationStatus == "success")
                {
                    if (attachtype == "header")
                    {
                        result = "Error: There is no attachment to download for this record." + "♠";
                    }
                    else
                    {
                        result = String.Format("Error: File '{0}' is not available.", filename) + "♠";
                    }
                }
                else
                {
                    result = String.Format("Error: File '{0}' is not accessible => {1}.", filename, authenticationStatus) + "♠";
                }
            }

            return result.Trim('♠');
        }

        [WebMethod(EnableSession = true)]
        public string GetAxpFilePathForListviewAttachment(string filepath, string filename)
        {
            string result = "";
            string authenticationStatus = string.Empty;
            if (!string.IsNullOrEmpty(filename))
            {
                if (Session["nsessionid"] == null || string.IsNullOrEmpty(Session["nsessionid"].ToString()))
                    return utilObj.SESSTIMEOUT;
                string path = string.Empty;//concatenate the path for the file.

                if (filepath == string.Empty)
                {
                    if (HttpContext.Current.Session["AxpImagePathGbl"] != null)
                    {
                        string tempGridAttachPath = HttpContext.Current.Session["AxpImagePathGbl"].ToString();
                        if (!tempGridAttachPath.Contains(":\\") && !tempGridAttachPath.Contains("\\\\"))
                        {
                            tempGridAttachPath = HttpContext.Current.Application["ScriptsPath"].ToString() + axpert + Session["nsessionid"] + "\\" + tempGridAttachPath;
                            if (!Directory.Exists(tempGridAttachPath))
                            {
                                Directory.CreateDirectory(tempGridAttachPath);
                            }
                        }
                        filepath = tempGridAttachPath + "\\\\";
                    }
                }

                path = filepath;
                filename = utilObj.CheckReverseUrlSpecialChars(filename);

                string dPath = string.Empty;

                if (utilObj.GetAuthentication(ref authenticationStatus))
                {
                    foreach (string file in filename.Split(','))
                    {
                        string internalFileName = "";
                        DirectoryInfo di = new DirectoryInfo(path);
                        if (!di.Exists)
                            di.Create();

                        FileInfo[] fileEntries = di.GetFiles(file);

                        if (fileEntries != null && fileEntries.Length > 0)
                        {
                            internalFileName = file;
                            FileInfo dirFile = (FileInfo)fileEntries[0];

                            result += genericFileDownloader(dirFile, internalFileName, path, ref dPath, filename);
                        }
                    }
                }
            }
            else
                return "Error: Invalid Param Values.";

            if (result == "" || result == "♠")
            {
                if (authenticationStatus != "" && authenticationStatus != "success")
                {
                    result = String.Format("Error: File '{0}' is not available.", filename) + "♠";
                }
                else
                {
                    result = String.Format("Error: File '{0}' is not accessible => {1}.", filename, authenticationStatus) + "♠";
                }
            }

            return result.Trim('♠');
        }

        private string genericFileDownloader(FileInfo dirFile, string internalFileName, string path, ref string dPath, string filename, string attachtype = "", bool onlygetPath = false)
        {
            string result = string.Empty;

            if (dirFile.Name.StartsWith(internalFileName + "."))
            {
                internalFileName = dirFile.Name;
            }
            else if (attachtype == "header" && dirFile.Name.StartsWith(internalFileName + "-"))
            {
                internalFileName = dirFile.Name;
            }
            //else if(attachtype == "gridattach" && i > 0)
            //{
            //    break;
            //}



            if (System.IO.Directory.Exists(path) && System.IO.File.Exists(path + internalFileName))
            {

                dPath = utilObj.ScriptsPath + "axpert\\" + Session["nsessionid"].ToString() + "\\";
                if (filename.Contains(".docx"))
                {
                    dPath += "Docs" + "\\";
                }
                if (!onlygetPath && attachtype == "header")
                {
                    dPath += filename + "\\";
                }
                try
                {
                    if (!System.IO.Directory.Exists(dPath))
                        System.IO.Directory.CreateDirectory(dPath);
                    System.IO.File.Copy(path + internalFileName, dPath + internalFileName, true);
                    //if(!onlygetPath && attachtype == "header")
                    //{
                    //    internalFileName = tid + "-" + internalFileName;
                    //}
                    if (filename.Contains(".docx"))
                    {
                        result += utilObj.ScriptsurlPath + "Axpert/" + Session["nsessionid"].ToString() + "/" + "Docs" + "/" + internalFileName + "♠";
                    }
                    else
                    {
                        result += utilObj.ScriptsurlPath + "Axpert/" + Session["nsessionid"].ToString() + "/" + internalFileName + "♠";
                    }
                }
                catch (Exception ex)
                {
                    result += String.Format("Error: Failure while processing the file '{0}'.", internalFileName) + "♠";
                }
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetHelpText(string tid)
        {
            GetGlobalVars();
            string errorLog = string.Empty;
            string helpRes = string.Empty;
            string getHelpsql = string.Empty;
            string fileName = string.Empty;

            try
            {
                if (Session["nsessionid"] == null || string.IsNullOrEmpty(Session["nsessionid"].ToString()))
                    return utilObj.SESSTIMEOUT;

                ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();

                getHelpsql = "<sqlresultset axpapp='" + project + "' sessionid='" + sessionid + "' trace='" + errorLog + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'><sql>select rtf_hint from AxTstructHint where tid='" + tid + "'</sql>";
                getHelpsql += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                fileName = "LoadHint-" + tid;
                logobj.CreateLog("Getting Help Text.", sessionid, fileName, "");
                //Call service
                helpRes = objWebServiceExt.CallGetChoiceWS(tid, getHelpsql);

                if (helpRes.Contains(Constants.ERROR) == true)
                {
                    helpRes = helpRes.Replace(Constants.ERROR, "");
                    helpRes = helpRes.Replace("</error>", "");
                    helpRes = helpRes.Replace("\n", "");
                    throw (new Exception(helpRes));
                }
            }
            catch (Exception ex)
            {
                return "Error";
            }
            string hintText = string.Empty;
            if (helpRes != string.Empty)
            {
                XmlDocument xmlDoc = new XmlDocument();
                try
                {
                    xmlDoc.LoadXml(helpRes);
                }
                catch (Exception ex)
                {
                }
                XmlNode resultNode = null;


                resultNode = xmlDoc.SelectSingleNode("//row");
                if (resultNode != null)
                {
                    foreach (XmlNode childNode in resultNode.ChildNodes)
                    {
                        if (childNode.Name.ToLower() == "rtf_hint")
                            hintText = childNode.InnerText;
                    }
                }
            }
            return hintText;
        }

        [WebMethod(EnableSession = true)]
        public string GetZipPathForIviewAttachment(string[] proj, string[] tids, string[] rowids, string[] filenames)
        {
            string result = string.Empty;
            string dPath = string.Empty;
            string gridAttachPath = string.Empty;
            string AttachFilePath = string.Empty;
            if (Session["nsessionid"] == null)
                return "Error: Your Session has expired";
            if (HttpContext.Current.Session["AxGridAttachPath"] != null && HttpContext.Current.Session["AxAttachFilePath"] != null)
            {

                gridAttachPath = HttpContext.Current.Session["AxGridAttachPath"].ToString();
                AttachFilePath = HttpContext.Current.Session["AxAttachFilePath"].ToString();

                if (!gridAttachPath.Contains(":\\") && !gridAttachPath.Contains("\\\\"))
                {
                    gridAttachPath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + gridAttachPath;
                    if (!Directory.Exists(gridAttachPath))
                    {
                        Directory.CreateDirectory(gridAttachPath);
                    }
                }

                if (!AttachFilePath.Contains(":\\") && !AttachFilePath.Contains("\\\\"))
                {
                    AttachFilePath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + AttachFilePath;
                    if (!Directory.Exists(AttachFilePath))
                    {
                        Directory.CreateDirectory(AttachFilePath);
                    }
                }
            }
            else
                return "Error: Failure while processing the file.";

            if (!CheckDestinationFolder(utilObj.ScriptsPath + "axpert\\" + Session["nsessionid"].ToString()))
                result = "Error: While Creating folder";
            if (proj.Length > 0 && proj.Length == tids.Length && proj.Length == filenames.Length)
            {
                try
                {
                    dPath = utilObj.ScriptsPath + "axpert\\" + Session["nsessionid"].ToString() + "\\ZipDownloads\\";
                    for (int i = 0; i < proj.Length; i++)
                    {
                        if (!utilObj.IsNullOrEmpty(proj[i]) && !string.IsNullOrEmpty(tids[i].ToString()) && !string.IsNullOrEmpty(filenames[i].ToString()))
                        {
                            string path = string.Empty;//concatenate the path for the file. 
                            path = !string.IsNullOrEmpty(rowids[i]) ? gridAttachPath + "\\" + proj[i] + "\\" + tids[i] + "\\" + rowids[i] + "\\" : AttachFilePath + "\\" + proj[i] + "\\" + tids[i] + "\\";

                            string recordID = filenames[i].Split('-')[0];
                            string fileList = filenames[i].Replace(recordID + "-", "");

                            foreach (string file in fileList.Split(','))
                            {
                                string filename = recordID + "-" + file;

                                if (System.IO.File.Exists(path + filename))
                                    System.IO.File.Copy(path + filename, dPath + filename, true);
                            }
                        }
                        else
                            return "Error: Invalid Param Values.";
                    }
                }
                catch (Exception ex)
                {
                    return "Error: Failure while processing the file.";
                }
            }
            else
                return "Error: Failure while processing the file.";

            using (ZipFile zipFile = new ZipFile(Encoding.UTF8)) //to handle file name characters in all languages(UTF8)
            {
                try
                {
                    zipFile.AddDirectory(utilObj.ScriptsPath + "axpert\\" + Session["nsessionid"].ToString() + "\\ZipDownloads");
                    zipFile.Save(utilObj.ScriptsPath + "axpert\\" + Session["nsessionid"].ToString() + "\\ZipDownloads\\SelectedFiles.zip");
                    result = utilObj.ScriptsurlPath + "Axpert/" + Session["nsessionid"].ToString() + "/ZipDownloads/SelectedFiles.zip";
                }
                catch (Exception)
                {
                    result = "Error: Failure while processing Zipping file.";
                }
            }
            return result;
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetLanguage(string proj, string source)
        {
            string strLang = "ENGLISH";
            if (source == "Login")
            {
                strLang = utilObj.GetConfigAttrValue(proj, "AxLanguages");
            }
            else
            {
                DataSet ds = new DataSet();
                DataTable dt = new DataTable();
                string inputXML = string.Empty;
                string result = string.Empty;


                //Call service
                try
                {
                    inputXML = "<sqlresultset axpapp='" + proj + "' sessionid='" + Session["nsessionid"].ToString() + "' direct='true' trace='" + "true" + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "' >";
                    inputXML += "<sql>select distinct LANGNAME from axlangsource</sql>";
                    inputXML += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
                    result = asbExt.CallGetChoiceWS("", inputXML);

                }
                catch (Exception ex) { }
                string errMsg = string.Empty;
                errMsg = utilObj.ParseXmlErrorNode(result);

                if (errMsg != string.Empty)
                {
                    if (errMsg == Constants.SESSIONERROR)
                    {
                        Session.RemoveAll();
                        Session.Abandon();
                        utilObj.IFrameSessExpiry();
                    }
                }
                else if (result != string.Empty)
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(result);
                    XmlNodeList WrproductNodes = default(XmlNodeList);
                    WrproductNodes = xmlDoc.GetElementsByTagName("row");
                    if ((WrproductNodes.Count == 0))
                    { }
                    else
                    {
                        DataSet dsPages = new DataSet();
                        System.IO.StringReader sr = new System.IO.StringReader(result);
                        dsPages.ReadXml(sr);

                        ds = dsPages;

                        if (ds.Tables.Count > 1)
                        {
                            dt = ds.Tables["row"];
                        }
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    for (int idx = 0; idx < dt.Rows.Count; idx++)
                    {
                        strLang += "," + dt.Rows[idx][0].ToString();
                    }
                }
            }

            return strLang;
        }

        private bool CheckDestinationFolder(string path)
        {
            try
            {
                if (!System.IO.Directory.Exists(path + "\\ZipDownloads"))
                    System.IO.Directory.CreateDirectory(path + "\\ZipDownloads");
                else
                {
                    System.IO.Directory.Delete(path + "\\ZipDownloads", true);
                    System.IO.Directory.CreateDirectory(path + "\\ZipDownloads");
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;

        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetRoles()
        {
            try
            {
                string inputXML = string.Empty;
                logobj.CreateLog("GetRolesforDefaultLandingPage", Session["nsessionid"].ToString(), "GetRolesList", "Configuration");
                inputXML = "<root axpapp='" + Session["Project"].ToString() + "' sessionid= '" + Session["nsessionid"].ToString() + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='' role ='' act='' res='' page='' struct='' pagesize='10' pageno='1'>";
                inputXML += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";

                string result = string.Empty;
                //Call service
                result = asbExt.CallGetRolesListWS("Role", inputXML);
                if ((!result.Contains(Constants.ERROR) == true) || (result != ""))
                {
                    return result;
                }
                else
                {
                    return string.Empty;
                }
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }




        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetChoices(string tStrType, string value)
        {
            string sqlQuery = string.Empty;
            string resGetCh = string.Empty;

            if (tStrType == "design" && HttpContext.Current.Session["axdb"].ToString().ToLower() == "oracle")
                sqlQuery = Constants.ORCL_QRY_PRPS_DSGN;
            else if (tStrType == "design" && HttpContext.Current.Session["axdb"].ToString().ToLower() == "ms sql")
                sqlQuery = Constants.SQL_QRY_PRPS_DSGN;
            else if (tStrType == "normal" && HttpContext.Current.Session["axdb"].ToString().ToLower() == "oracle")
                sqlQuery = Constants.ORCL_QRY_PRPS_USER;
            else if (tStrType == "normal" && HttpContext.Current.Session["axdb"].ToString().ToLower() == "ms sql")
                sqlQuery = Constants.SQL_QRY_PRPS_USER;

            ASBCustom.CustomWebservice objCWbSer = new ASBCustom.CustomWebservice();
            try
            {
                if (!string.IsNullOrEmpty(sqlQuery))
                {
                    sqlQuery = sqlQuery.Replace("$USERID$", HttpContext.Current.Session["user"].ToString());
                    sqlQuery = sqlQuery.Replace("$TRANID$", HttpContext.Current.Session["transid"].ToString());
                    sqlQuery = sqlQuery.Replace("$VALUE$", value);
                    sqlQuery = sqlQuery.Replace("$TYPE$", "axPurpose");
                }

                string result = objCWbSer.GetChoices(HttpContext.Current.Session["transid"].ToString(), sqlQuery);
            }
            catch (Exception ex)
            {
                return resGetCh;
            }
            return resGetCh;
        }


        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetPrpLblStatus()
        {
            string resGetCh = "false";
            string dbType = HttpContext.Current.Session["axdb"].ToString().ToLower();
            ASBCustom.CustomWebservice objCWbSer = new ASBCustom.CustomWebservice();
            try
            {
                string sql = "Select ( CASE WHEN (Select Value  from axpCloudDevSettings where ID='" + HttpContext.Current.Session["user"] + "' and type=\'axPurpose\') IS NULL THEN 0 else (Select Value  from axpCloudDevSettings where ID='" + HttpContext.Current.Session["user"] + "' and type=\'axPurpose\') end ) AS admn,(CASE WHEN (Select Value  from axpCloudUserSettings where USERID='" + HttpContext.Current.Session["user"] + "' and \'axPurpose\') IS NULL THEN 0 else (Select Value  from axpCloudUserSettings where USERID='" + HttpContext.Current.Session["user"] + "' and type=\'axPurpose\')end ) AS usr " + (dbType == "oracle" ? "from dual" : "");
                if (!string.IsNullOrEmpty(sql))
                    sql = sql.Replace("$USERID", HttpContext.Current.Session["user"].ToString());

                string result = objCWbSer.GetChoices(HttpContext.Current.Session["transid"].ToString(), sql);
                if (result != string.Empty)
                {
                    DataSet ds = new DataSet();
                    StringReader sr = new StringReader(result);
                    ds.ReadXml(sr);
                    DataTable dt = ds.Tables["row"];
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[0]["admn"].ToString()))
                        {
                            int adminValue = Convert.ToInt32(dt.Rows[0]["admn"]);
                            int userValue = Convert.ToInt32(dt.Rows[0]["usr"]);
                            if (adminValue > 0 && userValue > 0)
                                resGetCh = "true";
                            else if (adminValue <= 0 && userValue > 0)
                                resGetCh = "true";
                            else if (adminValue > 0 && userValue <= 0)
                                resGetCh = "false";
                            else if (adminValue <= 0 && userValue <= 0)
                                resGetCh = "false";
                        }
                        else
                            resGetCh = "false";
                    }
                }
            }
            catch (Exception ex)
            {
                return resGetCh;
            }
            return resGetCh;
        }


        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetFastDepFlds(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string ArrActionLog, string visibleDcs, string str, string tid, string key, string frameNo, string rowNo, string changeFieldName, string subGridInfo, string parentInfo, string fieldName)
        {
            DateTime stDate = DateTime.Now;
            string result = string.Empty;
            try
            {
                if (HttpContext.Current.Session["project"] == null)
                    return utilObj.SESSTIMEOUT;

                if (Util.Util.CheckCrossScriptingInString(String.Join(",", fldValueArray.ToArray())))
                {
                    return Constants.MALICIOUSNPUTDETECTED;
                }

                DateTime sTime1 = DateTime.Now;
                TStructData tstData = (TStructData)Session[key];
                if (tstData == null)
                    return Constants.DUPLICATESESS;
                tstData.UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
                //FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                //result = fObj.GetDepFastDataJson(fieldName, tid, tstData, rowNo);
                DateTime eTime1 = DateTime.Now;
                DateTime sTime2 = DateTime.Now;
                tstData.AxActiveDc = string.Empty;
                DateTime eTime2 = DateTime.Now;
                if (tstData.logTimeTaken)
                    tstData.strServerTime = (tstData.webTime1 + (eTime1.Subtract(sTime1).TotalMilliseconds)) + "," + tstData.asbTime + "," + (tstData.webTime2 + (eTime2.Subtract(sTime2).TotalMilliseconds));
            }
            catch (Exception ex)
            {
                logobj.CreateLog("Exception in GetFastDepFlds-" + ex.Message, sessionid, "GetFastDep", "new");
            }
            DateTime edTime = DateTime.Now;
            logobj.CreateLog("Timetaken in GetFastDepFlds- Field" + fieldName + "-" + stDate.Subtract(edTime).TotalMilliseconds.ToString(), sessionid, "LogTimeTaken", "");
            return result;
        }

        public string GetRapidAutoComplete(string tstDataId, string fldName, string fldValue, ArrayList ChangedFields, ArrayList ChangedFieldDbRowNo, ArrayList ChangedFieldValues, ArrayList DeletedDCRows, string pageData, string fastdll, string fldNameAc, string refreshAC, TStructData tstData)
        {
            //pageNo,pagesize, frameno, activerow, parinfo subinfo, includedcs
            string[] pgData = pageData.Split('~');
            string errorLog = logobj.CreateLog("Autocomplete- GetRapidAutoComplete.", sessionid, "Rapid_Autocomplete-" + fldName, "new");
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join("", ChangedFieldValues)))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            try
            {
                transid = tstData.transid;
                string activePRow = string.Empty; string activePDc = string.Empty;

                if (pageData != string.Empty)
                {
                    int idx = pageData.IndexOf("♠");
                    if (idx != -1)
                    {
                        activePDc = pageData.Substring(0, idx);
                        if (!string.IsNullOrEmpty(activePDc) && activePDc != "")
                            activePDc = activePDc.Split('~').Last();
                        activePRow = pageData.Substring(idx + 1);
                        if (!string.IsNullOrEmpty(activePRow) && activePRow != "")
                            activePRow = activePRow.Split('~').First();
                    }
                }

                StringBuilder iXml = new StringBuilder();
                string token = utilObj.GetToken();
                HttpContext.Current.Session["axpToken"] = token;
                iXml.Append("<sqlresultset token='" + token + "' activerow='" + pgData[3] + "' pdc='" + activePDc + "' prow='" + activePRow + "' frameno='" + pgData[2] + "' axpapp='" + project + "' value='" + fldValue + "' sessionid= '" + sessionid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' field='" + fldName + "'");
                iXml.Append(" sqlfield='' trace='" + errorLog + "' transid='" + transid + "' pageno='" + pgData[0] + "' ");
                iXml.Append("pagesize='" + pgData[1] + "'>");
                iXml.Append(tstData.GetRapidFieldValueXml(ChangedFields, ChangedFieldDbRowNo, ChangedFieldValues, DeletedDCRows, pgData[2], pgData[3], fldName));
                iXml.Append(tstData.fieldValueXml + tstData.memVarsData);
                iXml.Append(HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString());
                iXml.Append("</sqlresultset>");
                result = asbExt.CallRapidSearchWS(transid, iXml.ToString());
                if (fastdll == "True" && result != "" && utilObj.ParseJSonErrorNode(result) == "")
                    tstData.AddToFasDDl(fldNameAc, result);
            }
            catch (Exception ex)
            {
                logobj.CreateLog("Exception while calling Autocomplete- field-" + fldName, sessionid, "Autocomp-Exc", "new");
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public bool SetSavedAndPublishedID(string transId, string designJSON, string savedID = "", string publishedID = "", string ispublish = "N")
        {
            bool saved = false;
            bool update = false;

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            FDW fdwObj = FDW.Instance;
            string fdKey = Constants.REDISTSTRUCT;
            string fdKeyMob = Constants.REDISTSTRUCTMOB;
            string designKey = Constants.REDISTSTRUCTAXDESIGN;
            string designCustHtmlKey = Constants.REDISTSTRUCTAXCUSTHTML;
            //string designTblKey = Constants.REDISTSTRUCTAXDESIGNTABLE;
            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();
            //fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(designTblKey, transId), "", false, schemaName);
            fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(fdKey, transId), "", false, schemaName);
            fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(fdKeyMob, transId), "", false, schemaName);
            saved = fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(designKey, transId), "", false, schemaName);
            fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(designCustHtmlKey, transId), "", false, schemaName);
            return saved;
        }

        public string GetdllAutoComplete(string tstDataId, string fldName, string fldValue, ArrayList ChangedFields, ArrayList ChangedFieldDbRowNo, ArrayList ChangedFieldValues, ArrayList DeletedDCRows, string pageData, string fastdll, string fldNameAc, string refreshAC, string pickArrow, string parentFlds, string rfSave, string IsApiFld, string tblSourceParams)
        {
            HttpContext.Current.Session["LastUpdatedSess"] = DateTime.Now.ToString();//.ToShortTimeString();
            DateTime stTime = DateTime.Now;
            string strJson = string.Empty;
            string requestProcess_logtime = string.Empty;
            GetGlobalVars();
            //pageNo,pagesize, frameno, activerow, parinfo subinfo, includedcs
            string[] pgData = pageData.Split('~');
            string errorLog = logobj.CreateLog("Autocomplete- GetdllAutoComplete.", sessionid, "autocomplete-" + fldName, "new");
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;

            if (Util.Util.CheckCrossScriptingInString(String.Join("", ChangedFieldValues)))
            {
                return Constants.MALICIOUSNPUTDETECTED;
            }

            string result = string.Empty;
            TStructData tstData = (TStructData)Session[tstDataId];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string isRapidCall = "false";
            if ((Session["RapidTsTruct"] != null && Session["RapidTsTruct"].ToString() == "true") && (HttpContext.Current.Session["AxIsPerfCode"] != null && HttpContext.Current.Session["AxIsPerfCode"].ToString().ToLower() == "true") && tstData.transid.ToLower() != "axglo")
                isRapidCall = "true";

            //if (tstData.tstStrObj.IsFldInFastData(fldName))//Bringing values from fast data object
            //{
            //    FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            //    logobj.CreateLog("Autocomplete- Getting data from Redis.", sessionid, "autocomplete-" + fldName, "");
            //    tstData.UpdateDataList(ChangedFields, ChangedFieldDbRowNo, ChangedFieldValues, DeletedDCRows);
            //    string resFastData = fObj.GetFromFastData(fldName, tstData.transID, tstData, pgData, fastdll, fldValue);
            //    result = resFastData;
            //}
            if (isRapidCall == "true")//Rapid tstruct 
            {
                result = GetRapidAutoComplete(tstDataId, fldName, fldValue, ChangedFields, ChangedFieldDbRowNo, ChangedFieldValues, DeletedDCRows, pageData, fastdll, fldNameAc, refreshAC, tstData);
            }
            else
            {
                int fetchRCount = 1000;
                if (Session["PickListFetchSize"] != null && Session["PickListFetchSize"].ToString() != "")
                    fetchRCount = int.Parse(Session["PickListFetchSize"].ToString());
                int pgNumber = int.Parse(pgData[0]);
                if (fastdll == "True")
                    fldValue = ""; //Making value empty if the field is normal select 
                else
                    pgData[1] = fetchRCount.ToString();//If the field is picklist set row count is 1000.
                transid = tstData.transid;
                logobj.CreateLog("AutoComplete from service.", sessionid, "autocomplete-" + fldName, "");
                string activePRow = string.Empty; string activePDc = string.Empty;
                if (pageData != string.Empty)
                {
                    int idx = pageData.IndexOf("♠");
                    if (idx != -1)
                    {
                        activePDc = pageData.Substring(0, idx);
                        if (!string.IsNullOrEmpty(activePDc) && activePDc != "")
                            activePDc = activePDc.Split('~').Last();
                        activePRow = pageData.Substring(idx + 1);
                        if (!string.IsNullOrEmpty(activePRow) && activePRow != "")
                            activePRow = activePRow.Split('~').First();
                    }
                }
                string spfldValue = utilObj.CheckSpecialChars(fldValue);
                string iXml = string.Empty;
                string activeRow = pgData[3];
                string aucSearchPattern = "contains";
                if (HttpContext.Current.Session["AxpautoCompPatt"] != null && HttpContext.Current.Session["AxpautoCompPatt"].ToString() != "")
                    aucSearchPattern = HttpContext.Current.Session["AxpautoCompPatt"].ToString();
                iXml += "<sqlresultset activerow='" + pgData[3] + "' pdc='" + activePDc + "' prow='" + activePRow + "' frameno='" + pgData[2] + "' axpapp='" + project + "' value='" + spfldValue + "' sessionid= '" + sessionid + "' field='" + fldName + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'";
                iXml += " sqlfield='' trace='" + errorLog + "' transid='" + transid + "' pageno='" + pgData[0] + "' cond='" + aucSearchPattern + "'";//cond='starts with'
                iXml += " pagesize='" + pgData[1] + "'>";
                logobj.CreateLog("Input xml-" + iXml, sessionid, "autocomplete-" + fldName, "");
                tstData.GetFieldValueXml(ChangedFields, ChangedFieldDbRowNo, ChangedFieldValues, DeletedDCRows, "-1", "AutoComplete", "NG", tstData.tstStrObj.GetFieldDc(fldName).ToString());

                string SessAutKey = "autocomplete♦" + transid + "-" + fldName + "-" + parentFlds;
                if (Session[SessAutKey] != null && int.Parse(activeRow) == 0)
                    iXml += Session[SessAutKey].ToString();
                else
                {
                    var lstAutKeys = Session.Keys.Cast<string>().Where(x => x.StartsWith("autocomplete♦")).ToList();
                    if (lstAutKeys.Count > 0)
                        Session.Remove(lstAutKeys[0]);
                    iXml += tstData.GetFieldSqlQuery(fldName, tstData.fieldValueXml, HttpContext.Current.Session["axGlobalVars"].ToString(), HttpContext.Current.Session["axUserVars"].ToString(), int.Parse(activeRow), parentFlds, tblSourceParams);
                }
                parentFlds = iXml.Split('♠')[1];
                iXml = iXml.Split('♠')[0];

                //string dbmemvarsXML = utilObj.GetDBMemVarsXML(transid);
                //string cdVarsXML = utilObj.GetConfigDataVarsXML(transid);
                iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString();
                iXml += "</sqlresultset>";
                iXml = utilObj.CheckSplChrInputXML(iXml);

                DateTime etTime = DateTime.Now;
                string cTime = etTime.Subtract(stTime).TotalMilliseconds.ToString();
                DateTime wstime = DateTime.Now;

                string strParent = string.Empty;
                int keyIndex = 0;
                bool isCache = false, isParFld = false;
                try
                {
                    FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                    if (fastdll == "True" && rfSave != "True" && refreshAC == "False")//Fetching data from redis for combobox field based on bound parents, if parents got changed with these parents will call the db then cached same.
                    {
                        string fldkey = utilObj.GetRedisServerFieldkey(tstData.transid, Constants.FIELDNAME, fldName, 0);
                        string dllData = fObj.HashGetKey(fldkey, parentFlds);
                        logobj.CreateLog("Data from Redis.-" + dllData, sessionid, "autocomplete-" + fldName, "");
                        if (dllData != string.Empty && refreshAC == "False" && pickArrow == "False")
                        {
                            result = dllData;
                            isCache = true;
                            return result;
                        }
                    }
                    else if (fastdll == "True" && rfSave == "True" && refreshAC == "False")//Fetching data from session for combobox+refreshonsave filed.
                    {
                        string sessCacheKey = transid + "-" + fldName + "-" + parentFlds;
                        if (Session[sessCacheKey] != null)
                        {
                            result = Session[sessCacheKey].ToString();
                            isCache = true;
                            return result;
                        }
                    }
                    else if (fastdll == "False" && fldValue == "")//Fetching data from session for picklist field and input vaue is empty(that means user clicked on ENTER key, ARROW key or field arrow icon).
                    {
                        string sessCacheKey = transid + "-" + fldName + "-" + parentFlds + "-empty";
                        if (Session[sessCacheKey] != null)
                        {
                            result = Session[sessCacheKey].ToString();
                            var pickData = JsonConvert.DeserializeObject<pickdatalist>(result.ToString());
                            var rcount = pickData.pickdata[0].rcount;
                            var fname = pickData.pickdata[1].fname;
                            var dfname = pickData.pickdata[2].dfname;
                            var data = pickData.pickdata[3].data;
                            int rows = 50;
                            int totalRecords = int.Parse(rcount) < fetchRCount ? int.Parse(rcount) : fetchRCount;
                            int totalPages = totalRecords / rows;
                            int perPage = pgNumber > totalPages ? totalRecords % rows : rows;
                            string json = new JavaScriptSerializer().Serialize(data.GetRange(50 * (pgNumber - 1), perPage));
                            result = "{\"pickdata\":[{\"rcount\":\"" + rcount + "\"},{\"fname\":\"" + fname + "\"},{\"dfname\":\"" + dfname + "\"},{\"data\":" + json + "}]}";
                            isCache = true;
                            return result;
                        }
                    }
                    else if (fastdll == "False" && fldValue.Length < 3)//Fetching data from session for Picklist field if the input is 1 or 2 character. that means filterig empty picklist session values if the same session is empty user will get this message "Please enter minimum of 3 character to search".
                    {
                        result = "{\"pickdata\":[{\"rcount\":\"0\"},{\"fname\":\"" + fldName + "\"},{\"data\":[{\"i\":\"Please enter minimum of 3 characters to search\",\"v\":\"\",\"d\":\"\"}]}]}";
                        return result;
                    }
                    else if (fastdll == "False" && fldValue.Length >= 3)//Fetching data from session for Picklist field and input values is >=3 characters, if not match the pattern of input will delete the existing session key and will create new session key with matched data.
                    {
                        string SessPickKey = transid + "-" + fldName + "-" + parentFlds + "-♦";
                        if (Session[SessPickKey] != null)
                        {

                            bool isPickCache = false, issvChanged = false;
                            string SCacheKey = transid + "-" + fldName + "-" + parentFlds + "-♦" + fldValue;
                            string SessPickKeyValue = Session[SessPickKey].ToString();
                            if (SessPickKeyValue == SCacheKey)
                                isPickCache = true;
                            else if (fldValue.Contains(SessPickKeyValue.Split('♦')[1]))//(fldValue.StartsWith(SessPickKeyValue.Split('♦')[1]))
                            {
                                issvChanged = true;
                                isPickCache = true;
                            }
                            else
                            {
                                Session.Remove(SessPickKeyValue);
                                Session.Remove(SessPickKey);
                            }
                            if (isPickCache)
                            {
                                result = Session[SessPickKeyValue].ToString();
                                var pickData = JsonConvert.DeserializeObject<pickdatalist>(result.ToString());
                                var tolrcount = long.Parse(pickData.pickdata[0].rcount);
                                var fname = pickData.pickdata[1].fname;
                                var dfname = pickData.pickdata[2].dfname;
                                var data = pickData.pickdata[3].data;
                                string spcfldValue = string.Empty;
                                if (issvChanged == true)
                                {
                                    spcfldValue = fldValue.Replace(SessPickKeyValue, "");
                                    var splFldVals = spcfldValue.Split('%');
                                    for (int j = 0; j < splFldVals.Length; j++)
                                    {
                                        var splFldVal = splFldVals[j].Split('_');
                                        for (int k = 0; k < splFldVal.Length; k++)
                                        {
                                            data = data.AsEnumerable().Where(x => x.i.ToLower().Contains(splFldVal[k].ToLower())).ToList();
                                        }
                                    }
                                }
                                int rcount = data.Count();
                                if (tolrcount == fetchRCount && rcount == 0 && issvChanged == true)
                                {
                                    Session.Remove(SessPickKeyValue);
                                    Session.Remove(SessPickKey);
                                }
                                else if (tolrcount == fetchRCount && issvChanged == true && (spcfldValue.Contains("%") || spcfldValue.Contains("_")))
                                {
                                    Session.Remove(SessPickKeyValue);
                                    Session.Remove(SessPickKey);
                                }
                                else
                                {
                                    int rows = 50;
                                    int totalRecords = rcount < fetchRCount ? rcount : fetchRCount;
                                    int totalPages = totalRecords / rows;
                                    int perPage = pgNumber > totalPages ? totalRecords % rows : rows;
                                    string json = new JavaScriptSerializer().Serialize(data.GetRange(50 * (pgNumber - 1), perPage));
                                    result = "{\"pickdata\":[{\"rcount\":\"" + rcount + "\"},{\"fname\":\"" + fname + "\"},{\"dfname\":\"" + dfname + "\"},{\"data\":" + json + "}]}";
                                    isCache = true;
                                    return result;
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                { }

                if (IsApiFld == "true")
                {
                    result = GetDataFromApi(fldName, tstData.tstStrObj, tstData.fieldValueXml);
                }
                else
                {
                    result = asbExt.CallAutoGetSearchNewWS(transid, iXml, tstData.tstStrObj.structRes);
                    requestProcess_logtime = result.Split('♠')[0];
                    result = result.Split('♠')[1];
                }
                logobj.CreateLog("AutoComplete from CallAutoGetSearchNewWS.-" + result, sessionid, "autocomplete-" + fldName, "");

                if (utils.ParseJSonErrorNode(result) != "")//To check is there error node.
                {
                    return result;
                }
                try
                {
                    if (ParseJSonResultNode(result))// To check is result is empty or not.
                    {
                        if (IsApiFld != "true")
                        {
                            if (fastdll == "True" && rfSave != "True" && isCache == false && result != "" && pickArrow == "False")//Storing combobox values in redis with parent field key pair.
                            {
                                string schemaName = string.Empty;
                                if (HttpContext.Current.Session["dbuser"] != null)
                                    schemaName = HttpContext.Current.Session["dbuser"].ToString();

                                FDW fdwObj = FDW.Instance;
                                string fldkey = utilObj.GetRedisServerFieldkey(tstData.transid, Constants.FIELDNAME, fldName, 0);
                                fdwObj.HashSetKey(fldkey, parentFlds, result);
                            }
                            else if (fastdll == "True" && rfSave == "True" && isCache == false && result != "" && pickArrow == "False")//Saving combobox+refreshonsave field values in session with parent field key pair.
                            {
                                string sessCacheKey = transid + "-" + fldName + "-" + parentFlds;
                                Session[sessCacheKey] = result;
                                utilObj.AddKeyOnRefreshSave(sessCacheKey);
                            }
                            else if (fastdll == "False" && fldValue == "" && isCache == false && result != "" && pickArrow == "False")//Saving picklist field values in session with parent field key pair if the input value is empty.
                            {
                                string sessCacheKey = transid + "-" + fldName + "-" + parentFlds + "-empty";
                                Session[sessCacheKey] = result;
                                if (rfSave == "True")
                                    utilObj.AddKeyOnRefreshSave(sessCacheKey);
                                var pickData = JsonConvert.DeserializeObject<pickdatalist>(result.ToString());
                                var rcount = pickData.pickdata[0].rcount;
                                var fname = pickData.pickdata[1].fname;
                                var dfname = pickData.pickdata[2].dfname;
                                var data = pickData.pickdata[3].data;
                                int rows = 50;
                                int totalRecords = int.Parse(rcount) < fetchRCount ? int.Parse(rcount) : fetchRCount;
                                int totalPages = totalRecords / rows;
                                int perPage = pgNumber > totalPages ? totalRecords % rows : rows;
                                string json = new JavaScriptSerializer().Serialize(data.GetRange(50 * (pgNumber - 1), perPage));
                                result = "{\"pickdata\":[{\"rcount\":\"" + rcount + "\"},{\"fname\":\"" + fname + "\"},{\"dfname\":\"" + dfname + "\"},{\"data\":" + json + "}]}";
                            }
                            else if (fastdll == "False" && fldValue != "" && isCache == false && result != "" && pickArrow == "False")//Saving picklist field values in session with parent field key pair if the input value lenght is greater than or equal to(>=) 3 characters.
                            {
                                string SessCacheKey = transid + "-" + fldName + "-" + parentFlds + "-♦" + fldValue;
                                string SessPickKey = transid + "-" + fldName + "-" + parentFlds + "-♦";
                                Session[SessCacheKey] = result;
                                Session[SessPickKey] = SessCacheKey;
                                if (rfSave == "True")
                                {
                                    utilObj.AddKeyOnRefreshSave(SessCacheKey);
                                    utilObj.AddKeyOnRefreshSave(SessPickKey);
                                }
                                var pickData = JsonConvert.DeserializeObject<pickdatalist>(result.ToString());
                                var rcount = pickData.pickdata[0].rcount;
                                var fname = pickData.pickdata[1].fname;
                                var dfname = pickData.pickdata[2].dfname;
                                var data = pickData.pickdata[3].data;
                                int rows = 50;
                                int totalRecords = int.Parse(rcount) < fetchRCount ? int.Parse(rcount) : fetchRCount;
                                int totalPages = totalRecords / rows;
                                int perPage = pgNumber > totalPages ? totalRecords % rows : rows;
                                string json = new JavaScriptSerializer().Serialize(data.GetRange(50 * (pgNumber - 1), perPage));
                                result = "{\"pickdata\":[{\"rcount\":\"" + rcount + "\"},{\"fname\":\"" + fname + "\"},{\"dfname\":\"" + dfname + "\"},{\"data\":" + json + "}]}";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                }
            }
            return result + "♠" + requestProcess_logtime;
        }

        public bool ParseJSonResultNode(string result)
        {
            var pickData = JsonConvert.DeserializeObject<pickdatalist>(result.ToString());
            if (pickData.pickdata != null && pickData.pickdata.Count() > 0)
                return true;
            else
                return false;
        }

        public class pickdatalist
        {
            public List<pickdata> pickdata { get; set; }
        }

        public class pickdata
        {
            public string rcount { get; set; }
            public string fname { get; set; }
            public string dfname { get; set; }
            public List<fieldValues> data { get; set; }
        }

        public class fieldValues
        {
            public string i { get; set; }
            public string v { get; set; }
            public string d { get; set; }

        }

        public string GetDataFromApi(string fldName, TStructDef tstStrObj, string fieldValueXml)
        {
            string result = string.Empty;
            int fldidx = tstStrObj.GetFieldIndex(fldName);
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[fldidx];
            string api = fld.fieldSelAPI;
            string apiParams = fld.fieldSelAPIParams;
            string[] strDetails = apiParams.Split('♠');
            string mapname = strDetails[0];
            string apiType = strDetails[1];
            string contType = strDetails[2];

            ArrayList fromApiName = new ArrayList();
            ArrayList fromApiExp = new ArrayList();
            ArrayList dfnames = tstStrObj.fldAcceptFromApi;

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(api);

            string DATA = string.Empty;
            if (apiType == "Axpert")
            {
                request.Method = "POST";
                request.ContentType = "application/" + contType;
                DATA = strDetails[5];
                DATA = ParseAxpertApiParams(DATA, "sqlparams", fieldValueXml, tstStrObj);
                request.ContentLength = DATA.Length;
                StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                requestWriter.Write(DATA);
                requestWriter.Close();
            }
            else
            {
                request.Method = "GET";
                request.ContentType = "application/" + contType;
            }

            try
            {
                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                result = responseReader.ReadToEnd();
                Console.Out.WriteLine(result);
                responseReader.Close();

                if (result != string.Empty && apiType.ToLower() == "external")
                {
                    try
                    {
                        if (dfnames.Count > 0)
                        {
                            foreach (var dfN in dfnames)
                            {
                                if (dfN.ToString().Split('^').Length > 2)
                                {
                                    string faName = dfN.ToString().Split('^')[0];
                                    string isFromApi = dfN.ToString().Split('^')[1];
                                    string fromapiExp = dfN.ToString().Split('^')[2];
                                    if (isFromApi == "true" && fromapiExp != "" && fromapiExp.Split('~').Length > 0)
                                    {
                                        if (fromapiExp.Split('~')[0] == fldName)
                                        {
                                            fromApiName.Add(faName);
                                            if (mapname != "" && fromapiExp.Split('~').Length > 1)
                                                fromApiExp.Add(fromapiExp.Split('~')[1]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception)
                    {
                        fromApiName = new ArrayList();
                        fromApiExp = new ArrayList();
                    }
                    result = ApiResultParser(result, contType, mapname, fldName, fromApiName, fromApiExp);
                }
                else if (result != string.Empty)
                {
                    JObject obj = JObject.Parse(result);
                    result = obj["result"].First.ToString();
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("AutoComplete from API.-" + ex.Message, sessionid, "FromApi-" + fldName, "new");
            }
            return result;
        }

        private string ApiResultParser(string response, string contType, string mapname, string fldName, ArrayList fromApiName, ArrayList fromApiExp)
        {
            string result = string.Empty;
            try
            {
                if (contType.ToLower() == "json")
                {
                    JObject obj = JObject.Parse(response);
                    string json = string.Empty;
                    int ic = 0;
                    if (mapname != "")
                    {
                        foreach (var attNode in obj["data"])
                        {
                            string strValue = attNode[mapname].ToString();
                            if (fromApiName.Count > 0 && fromApiExp.Count > 0)
                            {
                                string fromApiExpVal = "";
                                foreach (var fax in fromApiExp)
                                {
                                    fromApiExpVal += attNode[fax].ToString() + "^";
                                }
                                json += "{\"i\":\"" + strValue + "\",\"v\":\"\",\"d\":\"" + fromApiExpVal.TrimEnd('^') + "\"},";
                            }
                            else
                                json += "{\"i\":\"" + strValue + "\",\"v\":\"\"},";
                            ic++;
                        }
                    }
                    else
                    {
                        //JObject ooBj = JObject.Parse("{\"AED\": \"United Arab Emirates Dirham\",\"AFN\": \"Afghan Afghani\",\"ALL\": \"Albanian Lek\",\"AMD\": \"Armenian Dram\",\"ANG\": \"Netherlands Antillean Guilder\"}");                       
                        //Considering first position of json 
                        foreach (var kval in obj)
                        {
                            if (fromApiName.Count > 0)
                                json += "{\"i\":\"" + kval.Key + "\",\"v\":\"\",\"d\":\"" + kval.Value.ToString() + "\"},";
                            else
                                json += "{\"i\":\"" + kval.Key + "\",\"v\":\"\"},";
                            ic++;
                        }
                    }
                    result = "{\"pickdata\":[{\"rcount\":\"" + ic + "\"},{\"fname\":\"" + fldName + "\"},{\"dfname\":\"" + string.Join("^", fromApiName.ToArray()) + "\"},{\"data\":[" + json.TrimEnd(',') + "]}]}";
                }
                else if (contType == "xml")
                {
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(response);
                    XmlNodeList elemList = doc.SelectNodes("//root/data/element");
                    string json = string.Empty;
                    int ic = 0;
                    foreach (XmlNode attNode in elemList)
                    {
                        foreach (XmlNode chlNode in attNode.ChildNodes)
                        {
                            if (chlNode.Name == mapname)
                            {
                                json += "{\"i\":\"" + chlNode.InnerText + "\",\"v\":\"\"},";
                                ic++;
                                break;
                            }
                        }

                    }
                    result = "{\"pickdata\":[{\"rcount\":\"" + ic + "\"},{\"fname\":\"" + fldName + "\"},{\"dfname\":\"\"},{\"data\":[" + json.TrimEnd(',') + "]}]}";
                }
                else if (contType == "csvl")
                {
                    result = "";
                }
            }
            catch (Exception ex)
            {
                result = "";
            }
            return result;
        }

        private string ParseAxpertApiParams(string RequestData, string paramsNodeName, string fieldValueXml, TStructDef tstStrObj)
        {
            string parseData = string.Empty;
            try
            {
                JObject obj = JObject.Parse(RequestData);
                string json = string.Empty;

                string fldValues = "<fldxml>" + fieldValueXml + "</fldxml>";
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(fldValues);

                string globalvars = HttpContext.Current.Session["axGlobalVars"].ToString();
                XmlDocument xmlDocgbl = new XmlDocument();
                xmlDocgbl.LoadXml(globalvars);

                string blgAppVar = string.Empty;
                if (xmlDocgbl.SelectSingleNode("globalvars/appvartypes") != null)
                    blgAppVar = xmlDocgbl.SelectSingleNode("globalvars/appvartypes").InnerXml;

                string uservars = HttpContext.Current.Session["axUserVars"].ToString();
                XmlDocument xmlDocul = new XmlDocument();
                xmlDocul.LoadXml(uservars);

                foreach (JProperty attNode in obj["_parameters"][0][paramsNodeName])
                {
                    if (attNode.Name == "recordid" && xmlDoc.SelectSingleNode("/fldxml/axp_recid1") != null)
                    {
                        string propVal = xmlDoc.SelectSingleNode("/fldxml/axp_recid1").InnerText;
                        RequestData = RequestData.Replace("\"" + attNode.Name + "\":\"\"", "\"" + attNode.Name + "\":\"" + propVal + "~n\"");
                    }
                    else if (xmlDoc.SelectSingleNode("/fldxml/" + attNode.Name) != null && tstStrObj != null)
                    {
                        string propVal = xmlDoc.SelectSingleNode("/fldxml/" + attNode.Name).InnerText;
                        int fldidxs = tstStrObj.GetFieldIndex(attNode.Name);
                        TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                        string VarTypes = "c";
                        if (flds.datatype == "Character" || flds.datatype == "Text")
                            VarTypes = "c";
                        else if (flds.datatype == "Numeric")
                            VarTypes = "n";
                        else if (flds.datatype == "Date/Time")
                            VarTypes = "d";
                        RequestData = RequestData.Replace("\"" + attNode.Name + "\":\"\"", "\"" + attNode.Name + "\":\"" + propVal + "~" + VarTypes + "\"");
                    }
                    else if (xmlDocgbl.SelectSingleNode("/globalvars/" + attNode.Name) != null)
                    {
                        string propVal = xmlDocgbl.SelectSingleNode("/globalvars/" + attNode.Name).InnerText;
                        string VarTypes = "c";
                        int gblIcnt = 1;
                        foreach (XmlNode parms in xmlDocgbl.ChildNodes[0].ChildNodes)
                        {
                            if (parms.Name == attNode.Name)
                            {
                                if (blgAppVar.Length >= gblIcnt)
                                    VarTypes = blgAppVar[gblIcnt - 1].ToString();
                                else if (blgAppVar.Length < gblIcnt)
                                    VarTypes = "c";
                                break;
                            }
                            gblIcnt++;
                        }
                        RequestData = RequestData.Replace("\"" + attNode.Name + "\":\"\"", "\"" + attNode.Name + "\":\"" + propVal + "~" + VarTypes + "\"");
                    }
                    else if (xmlDocul.SelectSingleNode("/uservars/" + attNode.Name) != null)
                    {
                        string propVal = xmlDocul.SelectSingleNode("/uservars/" + attNode.Name).InnerText;
                        RequestData = RequestData.Replace("\"" + attNode.Name + "\":\"\"", "\"" + attNode.Name + "\":\"" + propVal + "~c\"");
                    }
                }
                parseData = RequestData;
            }
            catch (Exception ex)
            {
                parseData = RequestData;
            }
            return parseData;
        }

        public string GetFieldChoices(string transid, string inputXml, string strucXml, string key)
        {
            string result = string.Empty;
            result = asbExt.CallFastFieldChoicesWS(transid, inputXml, strucXml);
            return result;
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public bool SetListViewDictionary(string[] listviewRecords, int viewRecordKey, string transId)
        {
            Dictionary<int, string> lvRecordListing = new Dictionary<int, string>();
            int index = 0;
            foreach (string navPath in listviewRecords)
            {
                lvRecordListing.Add(++index, navPath);
            }
            utils.SetlvRecordList(transId, lvRecordListing);
            Session["lvRecordKey"] = viewRecordKey;
            Session["OpenedRecord-" + transId] = viewRecordKey;
            return true;
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetListViewNext(string transId, string key)
        {
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string recId = tstData.recordID;
            Dictionary<int, string> lvRecordListing = new Dictionary<int, string>();
            lvRecordListing = utils.GetlvRecordList(transId);
            string returnQuery = string.Empty;
            try
            {
                int recordKey = Convert.ToInt32(Session["lvRecordKey"]);

                KeyValuePair<int, string> recordkeyValuePair = new KeyValuePair<int, string>();

                while (recordkeyValuePair.Key == 0 && lvRecordListing.Count > recordKey)
                {
                    recordKey++;
                    recordkeyValuePair = lvRecordListing.SingleOrDefault(x => x.Key == recordKey && x.Value != null);
                }
                Session["lvRecordKey"] = recordKey;

                returnQuery = recordkeyValuePair.Value;
                if (returnQuery == null)
                {
                    returnQuery = string.Empty;
                }
            }
            catch (Exception ex) { }
            return returnQuery;

        }
        [System.Web.Services.WebMethod(EnableSession = true)]
        public string GetListViewPrev(string transId, string key)
        {
            TStructData tstData = (TStructData)Session[key];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string recId = tstData.recordID;
            Dictionary<int, string> lvRecordListing = new Dictionary<int, string>();
            lvRecordListing = utils.GetlvRecordList(transId);
            string returnQuery = string.Empty;
            try
            {
                int recordKey = Convert.ToInt32(Session["lvRecordKey"]);

                KeyValuePair<int, string> recordkeyValuePair = new KeyValuePair<int, string>();

                while (recordkeyValuePair.Key == 0 && recordKey > 1)
                {
                    recordKey--;
                    recordkeyValuePair = lvRecordListing.SingleOrDefault(x => x.Key == recordKey && x.Value != null);
                }
                Session["lvRecordKey"] = recordKey;

                returnQuery = recordkeyValuePair.Value;
                if (returnQuery == null)
                {
                    returnQuery = string.Empty;
                }
            }
            catch (Exception ex) { }
            return returnQuery;

        }
        public string GetListViewRecordsDictionary(string transId, string type, int pageNo)
        {
            string _xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
            Dictionary<int, string> lvRecordListing = new Dictionary<int, string>();
            lvRecordListing = utils.GetlvRecordList(transId);

            string ires = string.Empty;
            string iXml = string.Empty;
            string fileName = "GetNextRecords-" + transId;
            string errorLog = logobj.CreateLog("GetNextRecords.", Session.SessionID.ToString(), fileName, "new");
            iXml = "<root name =\"" + transId + "\"  custviewname=\"" + transId + "\" axpapp = \"" + Session["Project"].ToString() + "\" sessionid = \"" + Session.SessionID.ToString() + "\" appsessionkey=\"" + HttpContext.Current.Session["AppSessionKey"].ToString() + "\" username=\"" + HttpContext.Current.Session["username"].ToString() + "\" trace = \"" + errorLog + "\" list=\"true\"  pageno=\"" + pageNo + "\" pagesize=\"" + Session["lvPageSize"].ToString() + "\" ><params>";
            iXml = iXml + "</params>" + Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            ires = asbExt.CallGetLViewWS(transId, iXml, asbExt.asbIview.Timeout);


            string errMsg = string.Empty;
            errMsg = utils.ParseXmlErrorNode(ires);

            if (errMsg != string.Empty)
            {
                if (errMsg == Constants.SESSIONERROR)
                {
                    Session.RemoveAll();
                    Session.Abandon();
                    return "sess.aspx";
                }
                else
                {
                    return "err.aspx?errmsg=" + errMsg;
                }
            }
            else
            {
                logobj.CreateLog("Setting Lview components", Session.SessionID.ToString(), fileName, "");
                ires = _xmlString + ires;
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(ires);

                //Remove headrow
                XmlNode rnode = default(XmlNode);
                rnode = xmlDoc.SelectSingleNode("//headrow");
                if (rnode != null)
                    rnode.ParentNode.RemoveChild(rnode);

                //Remove Comps
                XmlNode cNode = default(XmlNode);
                cNode = xmlDoc.SelectSingleNode("//comps");
                cNode.ParentNode.RemoveChild(cNode);

                XmlNode vNode = default(XmlNode);
                vNode = xmlDoc.SelectSingleNode("//customizeview");
                if (vNode != null)
                    vNode.ParentNode.RemoveChild(vNode);

                StringWriter sw = new StringWriter();
                XmlTextWriter xw = new XmlTextWriter(sw);
                xmlDoc.WriteTo(xw);

                string nXml = null;
                nXml = sw.ToString();
                if (nXml != "<?xml version=\"1.0\" encoding=\"utf-8\"?><data></data>")
                {
                    ArrayList colType = new ArrayList();
                    DataSet ds = new DataSet();
                    StringReader sr = new StringReader(nXml);
                    try
                    {
                        ds.ReadXml(sr);
                    }
                    catch (Exception ex)
                    {
                        //CloseDimmerJS();
                        //Response.Redirect(util.ERRPATH + ex.Message);
                        return "err.aspx?errmsg=" + ex.Message;
                    }
                    int n = 0;
                    n = 0;
                    DataSet ds1 = new DataSet();
                    ds1 = ds.Clone();

                    int rno = 0;
                    rno = 0;
                    foreach (DataRow dr1 in ds.Tables[0].Rows)
                    {


                        ds1.Tables[0].ImportRow(dr1);
                        int recPos = (Convert.ToInt32(ds1.Tables[0].Rows[rno]["rowno"]) + ((Convert.ToInt32(pageNo) - 1) * Convert.ToInt32(Session["lvPageSize"].ToString())));

                        lvRecordListing.Add(recPos, ds1.Tables[0].Rows[rno]["recordid"].ToString());
                        rno = rno + 1;
                    }
                    utils.SetlvRecordList(transId, lvRecordListing);
                }
                return "";
            }

        }

        //For AutoFill on configuration page of ddlsource under globalization tab
        [WebMethod(EnableSession = true)]
        public string FormAutoComplete(string FldValue, string fltValue, string ddlLanguage)
        {
            string jsonstring = string.Empty;
            try
            {
                DirectoryInfo dir = new DirectoryInfo(Server.MapPath("~/aspx/App_LocalResources"));
                var files = dir.GetFiles("*.aspx.resx");
                List<string> PageList = new List<string>();
                jsonstring = "[";
                foreach (var file in files)
                {
                    string statusfile = FileExistInternal(file.Name.Remove(file.Name.Length - 10), ddlLanguage);
                    if (file.Name.Remove(file.Name.Length - 10).ToLower().Contains(fltValue.ToLower()) || fltValue == "")
                    {
                        jsonstring += "{\"item\":\"" + file.Name.Remove(file.Name.Length - 10) + "\",\"status\":\"" + statusfile + "\"},";
                    }

                }
                if (jsonstring != "[")
                {
                    jsonstring = jsonstring.Substring(0, jsonstring.Length - 1);
                }
                jsonstring += "]";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return jsonstring;
        }

        //Draw all content of a page in form of textarea on configuration page
        [WebMethod(EnableSession = true)]
        public string FileXml(string ddlsource, string ddlLanguage)
        {
            StringBuilder sbContent = new StringBuilder();
            try
            {
                StreamReader SR;
                int count = 0;
                string ln = GetCultureInfo(ddlLanguage);
                string fname = ddlsource + ".aspx" + '.' + ln + ".resx";
                List<String> sbtarget = new List<String>();
                if (File.Exists(Server.MapPath("~/aspx/App_LocalResources/" + fname)))
                {
                    SR = File.OpenText(Server.MapPath("~/aspx/App_LocalResources/" + fname));
                    string strval = SR.ReadToEnd();
                    SR.Close();
                    if (!string.IsNullOrEmpty(strval))
                    {
                        XmlDocument xmlDoc = new XmlDocument();
                        xmlDoc.LoadXml(strval);
                        XmlNodeList resulttarget = xmlDoc.SelectNodes("/root/data");
                        foreach (XmlNode node in resulttarget)
                        {
                            sbtarget.Add(node.ChildNodes[1].InnerText);
                        }
                    }
                }

                SR = File.OpenText(Server.MapPath("~/aspx/App_LocalResources/" + ddlsource + ".aspx.resx"));
                string str = SR.ReadToEnd();
                SR.Close();
                if (!string.IsNullOrEmpty(str))
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(str);
                    XmlNodeList result = xmlDoc.SelectNodes("/root/data");

                    if (sbtarget.Count <= 0)
                    {
                        foreach (XmlNode node in result)
                        {
                            count++;
                            sbContent.Append("<div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-6\" runat=\"server\"><div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-1\" runat=\"server\"><label class=\"rowserial\"> " + count + "</label></div><div class=\"col-sm-11\" runat=\"server\"><textarea id =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  name =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  class=\"form-control \" readonly=\"true\" title=\"" + node.ChildNodes[1].InnerText + "\" placeholder=\"" + node.ChildNodes[1].InnerText + "\" style=\"height: 30px\" value=\"" + node.ChildNodes[1].InnerText + "\">" + node.ChildNodes[1].InnerText + "</textarea></div></div></div><div runat =\"server\" class=\"col-sm-6\"><textarea id=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  class=\"form-control targettext \" style=\"height: 30px\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"></textarea></div><div class=\"col-sm-1\"></div></div>");
                        }
                    }
                    else
                    {
                        int i = 0;
                        foreach (XmlNode node in result)
                        {
                            count++;
                            if (i < sbtarget.Count)
                            {
                                sbContent.Append("<div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-6\" runat=\"server\"><div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-1\" runat=\"server\"><label class=\"rowserial\"> " + count + "</label></div><div class=\"col-sm-11\" runat=\"server\"><textarea id =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  name =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  class=\"form-control \" readonly=\"true\" title=\"" + node.ChildNodes[1].InnerText + "\" placeholder=\"" + node.ChildNodes[1].InnerText + "\" style=\"height: 30px\" value=\"" + node.ChildNodes[1].InnerText + "\">" + node.ChildNodes[1].InnerText + "</textarea></div></div></div><div runat =\"server\" class=\"col-sm-6\"><textarea id=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\" class=\"form-control targettext \" style=\"height: 30px\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\" placeholder=\"" + sbtarget[i] + "\">" + sbtarget[i] + "</textarea></div><div class=\"col-sm-1\"></div></div>");
                                i++;
                            }
                            else
                            {
                                sbContent.Append("<div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-6\" runat=\"server\"><div class=\"row configformone\" runat=\"server\"><div class=\"col-sm-1\" runat=\"server\"><label class=\"rowserial\"> " + count + "</label></div><div class=\"col-sm-11\" runat=\"server\"><textarea id =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  name =\"" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  class=\"form-control \" readonly=\"true\" title=\"" + node.ChildNodes[1].InnerText + "\" placeholder=\"" + node.ChildNodes[1].InnerText + "\" style=\"height: 30px\" value=\"" + node.ChildNodes[1].InnerText + "\">" + node.ChildNodes[1].InnerText + "</textarea></div></div></div><div runat =\"server\" class=\"col-sm-6\"><textarea id=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"  class=\"form-control targettext \" style=\"height: 30px\" name=\"txt" + node.Attributes[0].Value.ToString().Split('.')[0] + "\"></textarea></div><div class=\"col-sm-1\"></div></div>");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return sbContent.ToString();
        }

        //Check Is file before exist or note on configuration page for 

        public string FileExistInternal(string filename, string ddlLanguage)
        {
            DirectoryInfo dir = new DirectoryInfo(Server.MapPath("~/aspx/App_LocalResources"));
            try
            {
                string language = GetCultureInfo(ddlLanguage);
                var file = filename + ".aspx." + language + ".resx";
                if (File.Exists(Server.MapPath("~/aspx/App_LocalResources/" + file)))
                {
                    return "yes";
                }
                return "No";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        [WebMethod(EnableSession = true)]
        public Boolean SaveLanFileData(string ddlSource, string ddlLanguage, string textvalue)
        {

            StreamReader SR;
            try
            {
                SR = File.OpenText(Server.MapPath("~/aspx/App_LocalResources/" + ddlSource + ".aspx.resx"));
                string str = SR.ReadToEnd();

                string[] dataval = textvalue.Split('♠');
                int lenghtdata = dataval.Length - 1;
                SR.Close();
                if (!string.IsNullOrEmpty(str))
                {

                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(str);
                    XmlNodeList result = xmlDoc.SelectNodes("/root/data");
                    int i = 0;
                    string textval = string.Empty;
                    foreach (XmlNode node in result)
                    {
                        node.InnerXml = "<value>" + dataval[i] + "</value>";
                        i++;
                    }
                    string language = GetCultureInfo(ddlLanguage);
                    string filename = ddlSource;
                    filename = filename + ".aspx" + '.' + language + ".resx";
                    xmlDoc.Save(Server.MapPath("~/aspx/App_LocalResources/" + filename + ""));
                }
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public string GetCultureInfo(string language)
        {
            CultureInfo[] cinfo = CultureInfo.GetCultures(CultureTypes.AllCultures & ~CultureTypes.NeutralCultures);
            for (int i = 0; i <= 732; i++)
            {
                if (cinfo[i].DisplayName.ToLower() == language.ToLower())
                {
                    return cinfo[i].Name;
                }
            }
            return string.Empty;
        }
        [WebMethod(EnableSession = true)]
        public string AddSessionPair(string key, string val)
        {
            HttpContext.Current.Session[key] = val;
            return "Session Added";
        }
        [WebMethod(EnableSession = true)]
        public string CompareLastUpdated()
        {
            if (System.Web.HttpContext.Current.Session["LastUpdatedSess"] != null)
            {
                DateTime lastUpdatedTime = DateTime.Parse(HttpContext.Current.Session["LastUpdatedSess"].ToString());
                DateTime currentTime = DateTime.Now;
                int deferenceTime = (int)(currentTime - lastUpdatedTime).TotalMinutes;
                return deferenceTime.ToString();
            }
            else
                return "Session does not exist";
        }

        [WebMethod(EnableSession = true)]
        public string KeepSignLastUpdated(int AliveTime, string currPageUrl)
        {
            try
            {
                if (HttpContext.Current.Session["LastUpdatedSess"] != null)
                {
                    if (Session["hybridDeviceId"] != null && Session["hybridDeviceId"].ToString() != "")
                    {
                        Session["KeepMeHybridExpiry"] = "true";
                        string devId = Session["hybridDeviceId"].ToString();
                        string hyProj = HttpContext.Current.Session["project"].ToString();
                        string devStr = "&deviceid=" + devId + "&projname=" + hyProj;
                        return devStr;
                    }
                    else
                    {
                        Session["KeepMeWebExpiry"] = "true";
                        utils.SaveKeepAliveWebDetails(currPageUrl);
                        return "web";
                    }
                }
                else
                    return "false";
            }
            catch (Exception ex)
            {
                return "false";
            }
        }

        [WebMethod(EnableSession = true)]
        public object GetSession(string key)
        {
            if (System.Web.HttpContext.Current.Session[key] != null && key == "appsessionkey")
            {
                string appsessKey = string.Empty;
                if (HttpContext.Current.Session["lictype"] != null && HttpContext.Current.Session["lictype"].ToString() == "limited")
                    appsessKey = "l~";
                else
                    appsessKey = "u~";
                return appsessKey + System.Web.HttpContext.Current.Session[key];
            }
            else if (System.Web.HttpContext.Current.Session[key] != null)
            {
                return System.Web.HttpContext.Current.Session[key];
            }
            else
                return "Session does not exist";
        }

        //Method to Set a value to a session or append value to a existing session with a delimiter
        [WebMethod(EnableSession = true)]
        public string SetSession(string key, string val, bool appendVal = false, string delimiter = "")
        {
            if (!appendVal || System.Web.HttpContext.Current.Session[key] == null || System.Web.HttpContext.Current.Session[key].ToString() == "")
            {
                System.Web.HttpContext.Current.Session[key] = val;
                return "Session Added";
            }
            else
            {
                System.Web.HttpContext.Current.Session[key] = System.Web.HttpContext.Current.Session[key].ToString() + delimiter + val;
                return "Value appended to Session";
            }
        }

        [WebMethod(EnableSession = true)]
        public string SetNodeApineeds(string key, string val)
        {
            System.Web.HttpContext.Current.Session[key] = val;
            return "added";
        }

        //Method to get the new tab page url
        [WebMethod(EnableSession = true)]
        public string GetNewTabPageSess(string key)
        {
            string pageUrl = String.Empty;
            if (!(System.Web.HttpContext.Current.Session[key] == null || System.Web.HttpContext.Current.Session[key].ToString() == ""))
            {
                pageUrl = System.Web.HttpContext.Current.Session[key].ToString();

                if (pageUrl.Contains('♠'))
                    System.Web.HttpContext.Current.Session[key] = pageUrl.Substring(pageUrl.IndexOf('♠') + 1);
                else
                    System.Web.HttpContext.Current.Session[key] = null;

                pageUrl = pageUrl.Split('♠')[0];
            }
            return pageUrl;
        }

        [WebMethod(EnableSession = true)]
        public string CallRestWS(string jsonData, string webServiceName)
        {
            string response = string.Empty;
            string DATA = string.Empty;
            string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBDefineRest.dll/datasnap/rest/TASBDefineRest/" + webServiceName + "";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentType = "application/json";
            if (webServiceName.ToLower() == "savestruct")
            {
                string appsesskey = Session["AppSessionKey"].ToString();
                string globalvars = xmltojson(Session["axGlobalVars"].ToString());
                string uservars = xmltojson(Session["axUserVars"].ToString());
                string axapps = xmltojson(Session["axApps"].ToString());
                jsonData = jsonData.Remove(jsonData.Length - 2);
                DATA = jsonData + ",\"appsessionkey\":\" " + appsesskey + " \" " + ",\"globalvars\":{" + globalvars + "},\"uservars\":{" + uservars + "},\"axapps\":{" + axapps + "}}}";//appsessionkey
            }
            else
                DATA = jsonData;
            request.ContentLength = DATA.Length;
            StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
            requestWriter.Write(DATA);
            requestWriter.Close();

            try
            {
                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                response = responseReader.ReadToEnd();
                Console.Out.WriteLine(response);
                responseReader.Close();
                return response;
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("-----------------");
                Console.Out.WriteLine(e.Message);
                return response;
            }

        }

        public string xmltojson(string xml)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);
            string json = JsonConvert.SerializeXmlNode(doc);
            var parsed = JObject.Parse(json);
            var jtoken = ((Newtonsoft.Json.Linq.JContainer)parsed.First).First;
            return jtoken.ToString().Trim('{').Trim('}');
        }

        //Method to Unlock ConfigApp Page
        [WebMethod(EnableSession = true)]
        public string UnlockConfigApp(bool forceUnlock = false)
        {
            string sessID = string.Empty;
            if (HttpContext.Current.Session["nsessionid"] != null)
                sessID = HttpContext.Current.Session["nsessionid"].ToString();

            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();

            FDR fdrObj = (FDR)HttpContext.Current.Session["FDR"];
            string lockedBy = fdrObj.StringFromRedis(Constants.CONFIG_LOCK_KEY);
            string[] lockDetails = lockedBy.Split('♦');

            if ((lockDetails.Length == 4 && lockDetails[2] == sessID) || forceUnlock)
            {
                FDW fdwObj = FDW.Instance;
                fdwObj.Initialize(schemaName);
                fdwObj.ClearRedisServerDataByKey(Constants.CONFIG_LOCK_KEY, Constants.CONFIG_LOCK_KEY, false, schemaName);
            }

            return "Unlocked Config App.";
        }

        //Method to take assocaited tstruct from Iview
        [WebMethod(EnableSession = true)]
        public string GetAssociatedTstruct(string key)
        {

            IviewData iviewObj = (IviewData)HttpContext.Current.Session[key];
            return iviewObj.AssociatedTStruct;
        }

        //Method to Refresh Menu

        [WebMethod(EnableSession = true)]
        public string RefreshMenu()
        {
            string sXml = string.Empty;
            string result1 = string.Empty;
            string lang_at = "";
            string errlog = logobj.CreateLog("Getting Menu", sessionid, "GetMultiMenu", "new");
            sXml = sXml + "<root menucached='false' axpapp='" + HttpContext.Current.Session["project"] + "' sessionid='" + HttpContext.Current.Session["nsessionid"].ToString() + "' trace='" + errlog + "' mname =\"\" " + lang_at + " appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "'";
            // if (Session["MobileView"] != null && Session["MobileView"].ToString() == "True")
            //     sXml = sXml + " mobdev='yes'";
            sXml = sXml + "> ";
            sXml = sXml + Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + Session["axGlobalVars"].ToString() + Session["axUserVars"].ToString();
            sXml = sXml + "</root>";
            result1 = asbExt.CallGetMultiLevelMenuWS("main", sXml);
            if (result1 != string.Empty)
            {
                result1 = result1.Split('♠')[1];
                result1 = Regex.Replace(result1, ";fwdslh", "/");
                result1 = Regex.Replace(result1, ";hpn", "-");
                result1 = Regex.Replace(result1, ";bkslh", "\\");
                result1 = Regex.Replace(result1, ";eql", "=");
                result1 = Regex.Replace(result1, ";qmrk", "?");

                string fdKeyMenuData = Constants.REDISMENUDATA;
                string schemaName = HttpContext.Current.Session["dbuser"].ToString();
                FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                FDW fdwObj = FDW.Instance;
                fdwObj.SaveInRedisServer(utilObj.GetRedisServerkey(fdKeyMenuData, "Menu"), result1, Constants.REDISMENUDATA, schemaName);
            }
            return result1;
        }

        [WebMethod(EnableSession = true)]
        public string CreateLoginKey(string proj, string userName, string pwd, string seed, string language, string mobileDevice, string hybridGUID, string guid)
        {
            Cache cacObj = new Cache();
            HttpContext.Current.Cache.Insert(guid, proj + "~" + userName + "~" + pwd + "~" + seed + "~" + language + "~" + mobileDevice + "~" + hybridGUID);
            return "Session Added";
        }

        [WebMethod(EnableSession = true)]
        public bool FlushAllKeys()
        {
            bool clearRedis = false;
            FDR fObj = null;
            try
            {
                fObj = (FDR)Session["FDR"];
            }
            catch (Exception ex)
            {
                Session["FDR"] = null;
            }
            if (fObj == null)
            {
                fObj = new FDR();
                Session["FDR"] = fObj;
            }
            try
            {
                clearRedis = fObj.FlushAllRedisKeys();
            }
            catch (Exception ex) { }
            return clearRedis;
        }

        [WebMethod(EnableSession = true)]
        public void SetHybridInfo(dynamic hybridinfo)
        {
            string result = JsonConvert.SerializeObject(hybridinfo);
            var parsedResult = JObject.Parse(result);
            string strGUID = parsedResult.SelectToken("GUID").Value<string>().ToLower();
            FDR fObj = null;
            try
            {
                fObj = (FDR)Session["FDR"];
            }
            catch (Exception ex)
            {
                Session["FDR"] = null;
            }
            if (fObj == null)
            {
                fObj = new FDR();
                Session["FDR"] = fObj;
            }
            string locKey = Constants.AXHYBRIDINFO;
            Util.Util util;
            util = new Util.Util();
            FDW fdwObj = FDW.Instance;
            fdwObj.SaveInRedisServer(util.GetRedisServerkey(locKey, strGUID), result, Constants.AXHYBRIDINFO, "♠");
            //var existingvalues = fObj.StringFromRedis(util.GetRedisServerkey(locKey, strGUID), "♠");
        }

        [WebMethod(EnableSession = true)]
        public string GetRedisString(string key, string id, string user = "ALL")
        {
            string redisValues = "";
            Util.Util util;
            util = new Util.Util();
            FDR fObj = null;
            string GUID = string.Empty;
            string schemaName = string.Empty;
            try
            {
                fObj = (FDR)Session["FDR"];
            }
            catch (Exception ex)
            {
                Session["FDR"] = null;
            }
            if (fObj == null)
            {
                fObj = new FDR();
                Session["FDR"] = fObj;
            }
            if (key == "hybridinfo")
            {
                key = Constants.AXHYBRIDINFO;
                schemaName = "♠";
            }
            else if (key == Constants.AXHYBRIDWEIGHTSCALEINFO)
            {
                schemaName = "♠";
            }
            try
            {
                redisValues = fObj.StringFromRedis(util.GetRedisServerkey(key, id, user), schemaName).ToString();
                if (key == Constants.AXHYBRIDWEIGHTSCALEINFO && redisValues != "")
                {
                    FDW fdwObj = FDW.Instance;
                    fdwObj.ClearRedisServerDataByKey(util.GetRedisServerkey(key, id, user), "", false, schemaName);
                }
            }
            catch (Exception ex) { }

            return redisValues;
        }

        [WebMethod(EnableSession = true)]
        public void SetHybridNotifiInfo(dynamic notification_info)
        {
            string result = JsonConvert.SerializeObject(notification_info);
            var parsedResult = JObject.Parse(result);
            string strGUID = parsedResult.SelectToken("GUID").Value<string>().ToLower();
            FDR fObj = null;
            try
            {
                fObj = (FDR)Session["FDR"];
            }
            catch (Exception ex)
            {
                Session["FDR"] = null;
            }
            if (fObj == null)
            {
                fObj = new FDR();
                Session["FDR"] = fObj;
            }
            string notifiKey = Constants.AXHYBRIDNOTIFIINFO;
            Util.Util util;
            util = new Util.Util();
            FDW fdwObj = FDW.Instance;
            fdwObj.SaveInRedisServer(util.GetRedisServerkey(notifiKey, strGUID), result, Constants.AXHYBRIDNOTIFIINFO, "♠");
            //logobj.CreateLog("SetHybridNotifiInfo-" + notification_info + " --strGUID--" + strGUID + "--result--" + result, sessionid, "SetHybridNotifiInfo", "new", "true");
        }

        [WebMethod(EnableSession = true)]
        public string GetHybridNotifiInfo(string id, string status)
        {
            string redisValues = "";
            Util.Util util;
            util = new Util.Util();
            FDR fObj = null;
            string GUID = string.Empty;
            string schemaName = string.Empty;
            try
            {
                fObj = (FDR)Session["FDR"];
            }
            catch (Exception ex)
            {
                Session["FDR"] = null;
            }
            if (fObj == null)
            {
                fObj = new FDR();
                Session["FDR"] = fObj;
            }
            string notifiKey = Constants.AXHYBRIDNOTIFIINFO;
            schemaName = "♠";
            try
            {
                redisValues = fObj.StringFromRedis(util.GetRedisServerkey(notifiKey, id), schemaName).ToString();
            }
            catch (Exception ex)
            {
                logobj.CreateLog("GetHybridNotifiInfo- --redisvalues--" + redisValues + " --Id--" + id + "--Exception--" + ex.Message, sessionid, "GetHybridNotifiInfo", "new");
                return "Redis error";
            }

            if (redisValues != "")
            {
                try
                {
                    dynamic mbNotify = JsonConvert.DeserializeObject(redisValues);
                    DBContext obj = new DBContext();
                    obj.SaveMobileNotification(mbNotify.GUID.Value, mbNotify.firebase_id.Value, mbNotify.imei_no.Value, status);
                    logobj.CreateLog("GetHybridNotifiInfo- --redisvalues--" + redisValues + " --Id--" + id + "--mbNotify--" + mbNotify + "--guid--" + mbNotify.GUID.Value + "--firebase_id--" + mbNotify.firebase_id.Value + "--imei_no--" + mbNotify.imei_no.Value, sessionid, "GetHybridNotifiInfoLog", "new");
                }
                catch (Exception ex)
                {
                    logobj.CreateLog("GetHybridNotifiInfo-" + redisValues + " --Id--" + id + "--Ex:" + ex.Message, sessionid, "GetHybridNotifiInfo", "new");
                    return "DB error";
                }
            }

            return "done";
        }

        [WebMethod(EnableSession = true)]
        public string ResetFormLoadCache(string transid)
        {
            string result = string.Empty;
            string schemaName = string.Empty;
            if (Session["SessResetFormLoad"] != null)
            {
                if (HttpContext.Current.Session["dbuser"] != null)
                    schemaName = HttpContext.Current.Session["dbuser"].ToString();
                var sKey = Session["SessResetFormLoad"].ToString().Split('¿').ToList();
                FDR fObj = (FDR)Session["FDR"];
                string flArray = utilObj.GetRedisServerFieldkey(transid, Constants.FORMLOADARRAY, "", 0);
                string strflKeys = fObj.StringFromRedis(flArray);
                var keyList = strflKeys.Split('¿').ToList();
                FDW fdwObj = FDW.Instance;
                fdwObj.Initialize(schemaName);
                if (int.Parse(sKey[0]) != keyList.Count() - 1)
                {
                    string keyDelete = keyList[int.Parse(sKey[0])];
                    strflKeys = strflKeys.Replace(keyDelete, "deleted");
                    fdwObj.SaveInRedisServer(flArray, strflKeys, "", schemaName);
                }
                else if (int.Parse(sKey[0]) == keyList.Count() - 1 && keyList.Count() > 1)
                {
                    string keyDelete = keyList[int.Parse(sKey[0])];
                    strflKeys = strflKeys.Replace("¿" + keyDelete, "");
                    fdwObj.SaveInRedisServer(flArray, strflKeys, "", schemaName);
                }
                else if (keyList.Count() == 1)
                    fdwObj.ClearRedisServerDataByKey(flArray, "", false, schemaName);
                fdwObj.ClearRedisServerDataByKey(sKey[1], "", false, schemaName);
                string fdKey = Constants.REDISTSTRUCTDOFORM;
                fdwObj.ClearRedisServerDataByKey(utilObj.GetRedisServerkey(fdKey, transid), "", false, schemaName);
                result = "done";
            }
            return result;
        }

        public string GetMultiSelectValues(string tstDataId, string fldName, string fldValue, ArrayList ChangedFields, ArrayList ChangedFieldDbRowNo, ArrayList ChangedFieldValues, ArrayList DeletedDCRows, string fldNameMs, string refreshMs, string parentFlds, string rfSave, string pageData)
        {
            HttpContext.Current.Session["LastUpdatedSess"] = DateTime.Now.ToString();
            string result = string.Empty;
            string iXml = string.Empty;
            GetGlobalVars();
            string[] pgData = pageData.Split('~');
            string activeRow = pgData[3];
            string errorLog = logobj.CreateLog("MultiSelect- GetMultiSelectValues.", sessionid, "MultiSelect-" + fldName, "new");
            TStructData tstData = (TStructData)Session[tstDataId];
            if (tstData == null)
                return Constants.DUPLICATESESS;
            string activePRow = string.Empty; string activePDc = string.Empty;
            if (pageData != string.Empty)
            {
                int idx = pageData.IndexOf("♠");
                if (idx != -1)
                {
                    activePDc = pageData.Substring(0, idx);
                    if (!string.IsNullOrEmpty(activePDc) && activePDc != "")
                        activePDc = activePDc.Split('~').Last();
                    activePRow = pageData.Substring(idx + 1);
                    if (!string.IsNullOrEmpty(activePRow) && activePRow != "")
                        activePRow = activePRow.Split('~').First();
                }
            }
            iXml += "<sqlresultset activerow='" + pgData[3] + "' pdc='" + activePDc + "' prow='" + activePRow + "' frameno='" + pgData[2] + "' axpapp='" + project + "' value='' sessionid= '" + sessionid + "' field='" + fldName + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'";
            iXml += " sqlfield='' trace='" + errorLog + "' transid='" + tstData.transid + "' pageno='" + pgData[0] + "' cond='contains'";
            iXml += " pagesize='" + pgData[1] + "'>";
            tstData.GetFieldValueXml(ChangedFields, ChangedFieldDbRowNo, ChangedFieldValues, DeletedDCRows, "-1", "AutoComplete", "NG", tstData.tstStrObj.GetFieldDc(fldName).ToString());
            string SessAutKey = "MultiSelect♦" + tstData.transid + "-" + fldName + "-" + parentFlds;
            if (Session[SessAutKey] != null)
                iXml += Session[SessAutKey].ToString();
            else
            {
                var lstAutKeys = Session.Keys.Cast<string>().Where(x => x.StartsWith("MultiSelect♦")).ToList();
                if (lstAutKeys.Count > 0)
                    Session.Remove(lstAutKeys[0]);
                iXml += tstData.GetFieldSqlQuery(fldName, tstData.fieldValueXml, HttpContext.Current.Session["axGlobalVars"].ToString(), HttpContext.Current.Session["axUserVars"].ToString(), int.Parse(activeRow), parentFlds);
            }
            parentFlds = iXml.Split('♠')[1];
            iXml = iXml.Split('♠')[0];
            //string dbmemvarsXML = utilObj.GetDBMemVarsXML(tstData.transid);
            //string cdVarsXML = utilObj.GetConfigDataVarsXML(tstData.transid);
            iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString();
            iXml += "</sqlresultset>";
            iXml = utilObj.CheckSplChrInputXML(iXml);
            logobj.CreateLog("Input xml-" + iXml, sessionid, "MultiSelect-" + fldName, "");

            string strParent = string.Empty;
            bool isCache = false;
            try
            {
                FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                if (rfSave != "True" && refreshMs == "False")
                {
                    string fldkey = utilObj.GetRedisServerFieldkey(tstData.transid, Constants.FIELDNAME, fldName, 0);
                    string dllData = fObj.HashGetKey(fldkey, parentFlds);
                    logobj.CreateLog("Data from Redis.-" + dllData, sessionid, "MultiSelect-" + fldName, "");
                    if (dllData != string.Empty && refreshMs == "False")
                    {
                        result = dllData;
                        isCache = true;
                        return result;
                    }
                }
                else if (rfSave == "True" && refreshMs == "False")
                {
                    string sessCacheKey = tstData.transid + "-" + fldName + "-" + parentFlds;
                    if (Session[sessCacheKey] != null)
                    {
                        result = Session[sessCacheKey].ToString();
                        isCache = true;
                        return result;
                    }
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("MultiSelect from GetMultiSelectValues.-" + ex.Message, sessionid, "MultiSelect-" + fldName, "");
            }

            result = asbExt.CallGetMultiSelectValues(tstData.transid, iXml, tstData.tstStrObj.structRes);
            logobj.CreateLog("MultiSelect from GetMultiSelectValues.-" + result, sessionid, "MultiSelect-" + fldName, "");

            try
            {
                if (rfSave != "True" && isCache == false && result != "")
                {
                    string schemaName = string.Empty;
                    if (HttpContext.Current.Session["dbuser"] != null)
                        schemaName = HttpContext.Current.Session["dbuser"].ToString();

                    FDW fdwObj = FDW.Instance;
                    string fldkey = utilObj.GetRedisServerFieldkey(tstData.transid, Constants.FIELDNAME, fldName, 0);
                    fdwObj.HashSetKey(fldkey, parentFlds, result);
                }
                else if (rfSave == "True" && isCache == false && result != "")
                {
                    string sessCacheKey = tstData.transid + "-" + fldName + "-" + parentFlds;
                    Session[sessCacheKey] = result;
                    utilObj.AddKeyOnRefreshSave(sessCacheKey);
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("MultiSelect from GetMultiSelectValues.-" + ex.Message, sessionid, "MultiSelect-cache-" + fldName, "");
            }
            return result;
        }


        [WebMethod(EnableSession = true)]
        public string SaveSmartViews(string iView, string key, string userSmartViewJSON, string uname)
        {
            string result = string.Empty;
            //string structurePlusAccessControl = string.Empty;
            IviewData objIview = new IviewData();
            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();
            if (key != "")
            {
                try
                {
                    //objIview = new IviewData();
                    objIview = (IviewData)HttpContext.Current.Session[key];
                    if (objIview == null)
                        return Constants.DUPLICATESESS;
                    //if (!objIview.requestJSON)
                    //{
                    //    structurePlusAccessControl = objIview.StructureXml;
                    //}
                    //else if (objIview.StructureXml != string.Empty)
                    //{
                    //    structurePlusAccessControl = objIview.AccessControlXml + "#$#" + objIview.StructureXml;
                    //}
                }
                catch (Exception ex)
                {
                    //structurePlusAccessControl = string.Empty;
                }
            }


            string trace = "false";
            // string uname = (HttpContext.Current.Session["build"].ToString() == "T") ? "ALL": user ;


            GetGlobalVars();
            string filename = "SaveSmartViews-" + iView;
            trace = logobj.CreateLog("Call to SaveSmartViews Web Service", sessionid, filename, string.Empty);


            //string errorLog = string.Empty;
            //if (ConfigurationManager.AppSettings["LoginTrace"] != null)
            //    trace = ConfigurationManager.AppSettings["LoginTrace"].ToString().ToLower();

            string inputXML = "<root name='" + iView + "' axpapp='" + project + "' sessionid='" + sessionid + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + user + "' applyto='" + uname + "' trace='" + trace + "'><config_data>" + userSmartViewJSON + "</config_data>";


            inputXML = inputXML + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";


            result = asbExt.SaveSmartViews(iView, inputXML, objIview.WebServiceTimeout);

            string error = string.Empty;


            error = utilObj.ParseXmlErrorNode(result);

            logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, string.Empty);

            if (error != "")
            {
                return error;
            }
            else
            {
                try
                {
                    if (uname == "ALL")
                    {
                        uname = uname.ToLower();
                    }


                    Session[key] = objIview;

                    FDW fdwObj = FDW.Instance;
                    //string fdKey = Constants.RedisIviewObj;
                    string fdSettingsKey = Constants.RedisIviewSettings;
                    if (objIview.purposeString != "")
                    {
                        //fdKey = Constants.RedisListviewObj;
                        fdSettingsKey = Constants.RedisListviewSettings;
                    }
                    //fdwObj.SaveInRedisServer(utilObj.GetRedisServerkey(fdKey, objIview.IName), objIview, fdKey, schemaName);

                    FDR fObj = (FDR)HttpContext.Current.Session["FDR"];

                    fdwObj.SaveInRedisServer(fObj.MakeKeyName(fdSettingsKey, objIview.IName, uname), userSmartViewJSON, fdSettingsKey, schemaName);
                }
                catch (Exception ex) { }
                return result;
            }
        }

        [WebMethod(EnableSession = true)]
        public void RemoveUnwantedAxpFiles()
        {
            try
            {
                if (HttpContext.Current.Session["AxpAttFileServer"] != null)
                {
                    ArrayList attServerFiles = (ArrayList)HttpContext.Current.Session["AxpAttFileServer"];
                    string authenticationStatus = string.Empty;
                    if (attServerFiles.Count > 0 && utils.GetAuthentication(ref authenticationStatus))
                    {
                        foreach (var lstFile in attServerFiles)
                        {
                            string filePath = lstFile.ToString().Split('~')[1];
                            try
                            {
                                File.Delete(filePath);
                            }
                            catch (Exception) { }
                        }
                    }
                    HttpContext.Current.Session["AxpAttFileServer"] = null;
                }
            }
            catch (Exception) { }
        }

        [WebMethod(EnableSession = true)]
        public string LoadAxpFileToScript(string filePath, string fileName)
        {
            string copied = "false";
            try
            {
                string PrefixFilename = string.Empty;
                string sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                string scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();
                string scrPath = scriptsPath + "axpert\\" + sessionid + "\\";
                if (!File.Exists(scrPath + fileName))
                {
                    if (filePath == string.Empty)
                    {
                        if (HttpContext.Current.Session["grdAttPath"] != null)
                            filePath = HttpContext.Current.Session["grdAttPath"].ToString();
                        else
                        {
                            GetGlobalAttachPath();
                            filePath = HttpContext.Current.Session["grdAttPath"].ToString();
                        }
                    }
                    else if (filePath != string.Empty && filePath.EndsWith("*"))
                    {
                        string axpFilePath = filePath.Substring(0, filePath.LastIndexOf('\\')) + "\\";
                        PrefixFilename = filePath.Substring(filePath.LastIndexOf("\\") + 1).Replace("*", "");
                        filePath = axpFilePath;
                    }
                    CopyFiles(filePath, scrPath, PrefixFilename + fileName, fileName);
                    copied = "true";
                }
            }
            catch (Exception) { }
            return copied;
        }

        [WebMethod(EnableSession = true)]
        public string IsAxpFileExists(string filePath)
        {
            string fileExist = string.Empty;
            try
            {
                if (File.Exists(filePath))
                    fileExist = "true";
                else
                    fileExist = "false";
            }
            catch (Exception)
            {
                fileExist = "error";
            }
            return fileExist;
        }

        [WebMethod(EnableSession = true)]
        public string IsGridAttFileExists(string filePath)
        {
            string fileExist = string.Empty;
            try
            {
                if (File.Exists(filePath))
                    fileExist = "true";
                else
                    fileExist = "false";
            }
            catch (Exception)
            {
                fileExist = "error";
            }
            return fileExist;
        }

        [WebMethod(EnableSession = true)]
        public string AxpFileMoveToNewFolder(string axpOldPath, string axpNewPath, string axpFileList)
        {
            string copied = "false";
            try
            {
                if (axpOldPath == string.Empty)
                {
                    if (HttpContext.Current.Session["grdAttPath"] != null)
                        axpOldPath = HttpContext.Current.Session["grdAttPath"].ToString();
                    else
                    {
                        GetGlobalAttachPath();
                        axpOldPath = HttpContext.Current.Session["grdAttPath"].ToString();
                    }
                }
                foreach (var flname in axpFileList.Split(','))
                {
                    CopyFiles(axpOldPath, axpNewPath, flname, flname);
                    if (File.Exists(axpOldPath + "\\" + flname))
                    {
                        File.Delete(axpOldPath + "\\" + flname);
                    }
                }
                copied = "true";
            }
            catch (Exception) { }
            return copied;
        }

        [WebMethod(EnableSession = true)]
        public string GetTstructFieldsForListView(string transId)
        {
            string returnString = string.Empty;

            if (HttpContext.Current.Session["project"] == null)
            {
                return null;
            }
            try
            {

                string schemaName = string.Empty;
                if (HttpContext.Current.Session["dbuser"] != null)
                    schemaName = HttpContext.Current.Session["dbuser"].ToString();

                FDR fObj = (FDR)HttpContext.Current.Session["FDR"];

                string fdListViewFieldsInfoKey = Constants.ListViewFieldsInfo;

                string loadString = fObj.StringFromRedis(utilObj.GetRedisServerkey(fdListViewFieldsInfoKey, transId), schemaName);
                if (loadString == string.Empty)
                {
                    loadString = HttpContext.Current.Session[transId + "_" + fdListViewFieldsInfoKey].ToString();
                }
                returnString = loadString;
            }
            catch (Exception ex)
            { }

            return returnString;
        }

        [WebMethod(EnableSession = true)]
        public string GetCardsData()
        {
            string returnString = string.Empty;

            if (HttpContext.Current.Session["project"] == null)
            {
                return null;
            }

            LogFile.Log logobj = new LogFile.Log();
            string cardId = string.Empty;

            try
            {
                string wgData = string.Empty;
                //string sqlInput = "select axp_cardsid,cardname,cardtype,charttype,chartjson,cardicon, width, height,cachedata,autorefresh,sql_editor_cardsql as cardsql,orderno,accessstring, pagename, pagedesc, cardbgclr, axpfile_imgcard, htype, htransid, hcaption from axp_cards where accessstring='' or lower(accessstring) like '%all%' or lower(accessstring) like concat('%', '" + System.Web.HttpContext.Current.Session["userroles"].ToString() + "', '%') order by orderno";

                string[] roles = System.Web.HttpContext.Current.Session["userroles"].ToString().Split(',');

                string roleString = string.Join(" or ", roles.Select(role =>
                   {
                       return ("lower(accessstring) like '%," + role + ",%'");
                   }
                ));

                string sqlInput = "select axp_cardsid,cardname,cardtype,charttype,chartjson,cardicon,pagename,pagedesc,cardbgclr,width,height,cachedata,autorefresh,sql_editor_cardsql as cardsql,orderno,accessstring,htransid,htype,hcaption,axpfile_imgcard,html_editor_card,calendarstransid from axp_cards where " + roleString + " order by orderno";

                ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
                wgData = asbExt.ExecuteSQL("", sqlInput, "JSON");

                JArray returnArray = new JArray();

                JObject resultRows = JObject.Parse(wgData);

                if (wgData != string.Empty)
                {
                    try
                    {

                        string qdata = string.Empty;

                        JObject wgResult = new JObject();

                        JArray cards = (JArray)resultRows["result"]["row"];

                        foreach (JObject card in cards)
                        {

                            string node = card["cardsql"].ToString();

                            if (node != "")
                            {
                                string sqlQuery = node.Trim();
                                if (sqlQuery.Contains(":"))// to check any of tstruct fields & global Vars
                                {
                                    XmlDocument docGbl = new XmlDocument();
                                    docGbl.LoadXml(HttpContext.Current.Session["axGlobalVars"].ToString());
                                    foreach (XmlNode gblNode in docGbl.DocumentElement.ChildNodes)
                                    {
                                        if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", gblNode.Name), RegexOptions.IgnoreCase).Success)
                                            sqlQuery = sqlQuery.Replace(":" + gblNode.Name, "'" + gblNode.InnerText + "'");
                                    }
                                    if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", "username"), RegexOptions.IgnoreCase).Success)
                                        sqlQuery = sqlQuery.Replace(":username", "'" + HttpContext.Current.Session["username"].ToString() + "'");
                                }
                                sqlQuery = utilObj.CheckSpecialChars(sqlQuery);

                                qdata = asbExt.ExecuteSQL("", sqlQuery, "JSON"); ;


                                //XmlDocument docQuery = new XmlDocument();
                                //XmlNodeList queryResponse = docQuery.SelectNodes("sqlresultset");
                                //XmlDocument queryDocs = new XmlDocument();
                                //try
                                //{
                                //    docQuery.LoadXml(qdata.ToString());
                                //    queryDocs.LoadXml(queryResponse[0].InnerXml);
                                //    qdata = JsonConvert.SerializeXmlNode(queryDocs);
                                //}
                                //catch (Exception ex)
                                //{
                                //    qdata = (new JObject()).ToString();
                                //}
                                try
                                {
                                    node = (JObject.Parse(qdata)["result"]).ToString();
                                }
                                catch (Exception ex)
                                {
                                    node = "";
                                }

                            }

                            try
                            {
                                card["cardsql"] = JObject.Parse(node.ToString());
                            }
                            catch (Exception ex)
                            {
                                card["cardsql"] = "";
                            }
                            returnArray.Add(card);
                        }

                    }
                    catch (Exception ex)
                    { }
                }


                returnString = returnArray.ToString();
            }
            catch (Exception ex)
            { }

            return returnString;
        }

        [WebMethod(EnableSession = true)]
        public string saveCardsDesign(string design)
        {
            string result = string.Empty;

            if (HttpContext.Current.Session["project"] == null)
            {
                return null;
            }

            design = design.Replace("'", "''");
            string sqlInput = "update axusers Set carddetails = '" + design + "' where username='" + HttpContext.Current.Session["username"].ToString() + "'";

            //ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
            //result = asbExt.ExecuteSQL("", sqlInput, "JSON");

            //DBContext obj = new DBContext();
            //obj.ExecuteSqlQueryInline(sqlInput);

            ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
            result = asbExt.ExecuteSQL("", sqlInput, "JSON");

            if (result.Contains("success"))
            {
                result = "true";
            }

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string refreshCards(string cards)
        {
            string result = string.Empty;

            if (HttpContext.Current.Session["project"] == null)
            {
                return null;
            }

            ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();

            string sid = Session["nsessionid"].ToString();
            sid = utilObj.CheckSpecialChars(sid);

            string errlog = logobj.CreateLog("Refresh Cards", sid, "RefreshCards", "");

            string sXml = string.Empty;

            sXml = sXml + "<root cardids='" + cards + "' axpapp='" + Session["project"].ToString() + "' sessionid='" + sid + "' trace='" + errlog + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "'";
            sXml = sXml + "> ";
            sXml = sXml + Session["axApps"].ToString() + Application["axProps"].ToString() + Session["axGlobalVars"].ToString() + Session["axUserVars"].ToString();
            sXml = sXml + "</root>";

            result = objWebServiceExt.GetIndividualCardDetails("main", sXml);

            return result;
        }

        protected void CopyFiles(string sourcePath, string destPath, string srcFileName, string desFileName)
        {
            string authenticationStatus = string.Empty;
            if (utils.GetAuthentication(ref authenticationStatus))
            {
                DirectoryInfo sPath = new DirectoryInfo(sourcePath);
                DirectoryInfo dPath = new DirectoryInfo(destPath);

                if (!dPath.Exists)
                    dPath.Create();

                if (sPath.Exists)
                {
                    BinaryReader brReader = default(BinaryReader);
                    BinaryWriter brWriter = default(BinaryWriter);

                    string strFile = sourcePath + "\\" + srcFileName;
                    string strDest = destPath + "\\" + desFileName;
                    FileStream input = null;
                    try
                    {
                        input = new FileStream(strFile, FileMode.Open, FileAccess.Read);
                    }
                    catch (FileNotFoundException ex) { }
                    if (input != null)
                    {
                        FileStream output = new FileStream(strDest, FileMode.Create, FileAccess.Write);
                        brReader = new System.IO.BinaryReader(input);
                        brWriter = new System.IO.BinaryWriter(output);
                        int bufsize = 30000;
                        // this is buffer size
                        int readcount = 0;
                        int bsize = 0;

                        int indexer = 0;
                        FileInfo fileInfo = new FileInfo(strFile);

                        int FileLen = Convert.ToInt32(fileInfo.Length);
                        while ((readcount < FileLen))
                        {
                            if (bufsize < FileLen - readcount)
                            {
                                bsize = bufsize;
                            }
                            else
                            {
                                bsize = FileLen - readcount;
                            }
                            byte[] buffer = new byte[bsize];

                            brReader.Read(buffer, indexer, bsize);
                            brWriter.Write(buffer, indexer, bsize);

                            readcount = readcount + bsize;
                        }

                        brReader.Close();
                        brWriter.Close();
                        brReader.Dispose();
                        brWriter.Dispose();
                        output.Dispose();
                        input.Dispose();
                    }
                }
            }
        }

        protected void GetGlobalAttachPath()
        {
            bool isLocalFolder = false;
            bool isRemoteFolder = false;
            string imagePath = string.Empty;
            string imageServer = string.Empty;
            string grdAttPath = string.Empty;
            string errorMessage = string.Empty;
            string mapUsername = string.Empty;
            string mapPassword = string.Empty;

            if (HttpContext.Current.Session["AxpImageServerGbl"] != null)
            {
                imageServer = HttpContext.Current.Session["AxpImageServerGbl"].ToString();
                imageServer = imageServer.Replace(";bkslh", @"\");
            }
            if (HttpContext.Current.Session["AxpImagePathGbl"] != null)
            {
                imagePath = HttpContext.Current.Session["AxpImagePathGbl"].ToString();
                imagePath = imagePath.Replace(";bkslh", @"\");

                if (imagePath.IndexOf(":") > -1)
                    isLocalFolder = true;
                else
                    if (imagePath.IndexOf(@"\") > -1)
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
            else
            {
                if (HttpContext.Current.Session["AxGridAttachPath"] != null)
                {
                    grdAttPath = HttpContext.Current.Session["AxGridAttachPath"].ToString();
                }
            }
            HttpContext.Current.Session["grdAttPath"] = grdAttPath;
        }

        public string saveArrangeMenuData(string menuXml)
        {
            string result = string.Empty;
            string errLog = logobj.CreateLog("ArrangeMenu- callRearrangeMenuWS.", sessionid, "ArrangeMenu-" + project, "new");
            if (HttpContext.Current.Session["project"] == null)
                return utils.SESSTIMEOUT;
            string proj = HttpContext.Current.Session["project"].ToString();
            string InputXml = "<ArrangeMenu axpapp=\"" + proj + "\" trace=\"" + errLog + "\" sessionid=\"" + sessionid + "\" appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
            InputXml += menuXml + "</ArrangeMenu>";
            result = asbExt.callRearrangeMenuWS(InputXml);
            string errMsg = utils.ParseXmlErrorNode(result);
            if (errMsg != string.Empty)
            {
                if (errMsg == Constants.SESSIONERROR || errMsg == Constants.SESSIONEXPMSG || errMsg == Constants.SESSIONEXPMSG || errMsg == Constants.ERAUTHENTICATION)
                {
                    return utils.SESSTIMEOUT;
                }
                else
                {
                    return errMsg;
                }
            }
            return result;
        }
        public string callGetToolbarWS(string stype, string name)
        {
            string result = string.Empty;
            string errLog = logobj.CreateLog("ToolbarManager- callGetToolbarWS.", System.Web.HttpContext.Current.Session["nsessionid"].ToString(), "ToolbarManager-" + System.Web.HttpContext.Current.Session["project"].ToString(), "new");
            if (HttpContext.Current.Session["project"] == null)
                return utils.SESSTIMEOUT;
            string proj = HttpContext.Current.Session["project"].ToString();
            string InputXml = "<root name =\"" + name + "\"  stype = \"" + stype + "\" axpapp = \"" + System.Web.HttpContext.Current.Session["project"].ToString() + "\" sessionid = \"" + System.Web.HttpContext.Current.Session["nsessionid"].ToString() + "\" appsessionkey = '" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username = \"" + HttpContext.Current.Session["username"].ToString() + "\"  trace = '' responseformat = 'json' ></root >";
            result = asbExt.GetToolBar(InputXml);
            return result;
        }
        public string callSaveToolbarWS(string stype, string name, string toolbarJSON)
        {
            string result = string.Empty;
            string errLog = logobj.CreateLog("ArrangeMenu- callRearrangeMenuWS.", HttpContext.Current.Session["nsessionid"].ToString(), "ArrangeMenu-" + System.Web.HttpContext.Current.Session["project"].ToString(), "new");
            if (HttpContext.Current.Session["project"] == null)
                return utils.SESSTIMEOUT;
            string proj = HttpContext.Current.Session["project"].ToString();
            string InputXml = "<root name =\"" + name + "\"  stype = \"" + stype + "\" axpapp = \"" + System.Web.HttpContext.Current.Session["project"].ToString() + "\" sessionid = \"" + System.Web.HttpContext.Current.Session["nsessionid"].ToString() + "\" appsessionkey = '" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username = \"" + HttpContext.Current.Session["username"].ToString() + "\"  trace = ''>";
            InputXml += " <toolbar_data>" + toolbarJSON + "</toolbar_data></root>";
            result = asbExt.saveToolbar(InputXml);
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string SendNotificationFromFirebase(string guId)
        {
            string result = "-1";
            try
            {
                string firebase_id = string.Empty;
                if (guId == "")
                    return "";
                string redisValues = "";
                Util.Util util;
                util = new Util.Util();
                FDR fObj = null;
                string GUID = string.Empty;
                string schemaName = string.Empty;
                try
                {
                    fObj = (FDR)Session["FDR"];
                }
                catch (Exception ex)
                {
                    Session["FDR"] = null;
                }
                if (fObj == null)
                {
                    fObj = new FDR();
                    Session["FDR"] = fObj;
                }
                string notifiKey = Constants.AXHYBRIDNOTIFIINFO;
                schemaName = "♠";
                try
                {
                    redisValues = fObj.StringFromRedis(util.GetRedisServerkey(notifiKey, guId), schemaName).ToString();
                    dynamic mbNotify = JsonConvert.DeserializeObject(redisValues);
                    firebase_id = mbNotify.firebase_id.Value;
                }
                catch (Exception ex)
                {
                    return "Redis error";
                }

                string webAddr = "";
                string firebase_server_key = "";
                if (ConfigurationManager.AppSettings["mobileFCMAPI"] != null && ConfigurationManager.AppSettings["mobileFCMAPI"].ToString() != "")
                    webAddr = ConfigurationManager.AppSettings["mobileFCMAPI"].ToString();
                if (ConfigurationManager.AppSettings["mobileFCMKey"] != null && ConfigurationManager.AppSettings["mobileFCMKey"].ToString() != "")
                    firebase_server_key = ConfigurationManager.AppSettings["mobileFCMKey"].ToString();

                var httpWebRequest = (HttpWebRequest)WebRequest.Create(webAddr);
                httpWebRequest.ContentType = "application/json";
                httpWebRequest.Headers.Add("Authorization:key=" + firebase_server_key);
                httpWebRequest.Method = "POST";

                using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                {
                    string json = "{\"to\": \"" + firebase_id + "\",\"data\": {\"isaxp_locationdata\":\"true\"}}";
                    streamWriter.Write(json);
                    streamWriter.Flush();
                }

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex) { }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetNewGlobalVars(string lang)
        {
            string sXml = string.Empty;
            string result = string.Empty;
            string errlogapp = logobj.CreateLog("Calling Get New global variables", HttpContext.Current.Session["nsessionid"].ToString(), "GetNewGlobalVars", "");
            string iXml = "<root " + lang + " scriptpath='" + HttpContext.Current.Application["ScriptsPath"].ToString() + "' axpapp='" + HttpContext.Current.Session["project"] + "' trace='" + errlogapp + "' sessionid='" + HttpContext.Current.Session["nsessionid"] + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' user='" + HttpContext.Current.Session["username"].ToString() + "'>";
            iXml += HttpContext.Current.Session["axApps"].ToString();
            iXml += HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            WebServiceExt objWebServiceExt = new WebServiceExt();
            result = objWebServiceExt.CallGetNewGlobalVarsWS("refreshparams", iXml);
            if (result != string.Empty && !result.Contains("\"error\""))
            {
                ParseGlobalVarsResult(result);
                result = "done";
            }
            else
                result = "Please try again later.";
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CallRestGetChoice(string jsonData, string projectname, string username)
        {
            string sqlQuery = Constants.SQL_GET_EMAIL;
            sqlQuery = sqlQuery.Replace("$USERNAME$", username);
            string Sessionid = Session.SessionID;
            string response = string.Empty;
            string DATA = string.Empty;
            utils.GetAxApps(projectname);
            string webServiceNames = "GetChoices";
            string axapps = xmltojson(Session["axApps"].ToString());
            string axprops = HttpContext.Current.Application["axProps"].ToString();
            axprops = xmltojson(axprops);
            string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBMenuRest.dll/datasnap/rest/TASBMenuRest/" + webServiceNames + "";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentType = "application/json";
            jsonData = jsonData.Substring(0, jsonData.Length - 2);
            jsonData = jsonData + "," + "\"sql\" :\"" + sqlQuery + "\"";
            jsonData = jsonData + "," + "\"sessionid\" :\"" + Session.SessionID + "\"";
            jsonData = jsonData + "," + "\"username\" :\"" + username + "\"}";
            //DATA = jsonData +","+ "\"" + webServiceName + "\":{" + axapps + "},\"axprops\":{" + axprops + "},\"globalvars\":\"\",\"uservars\":\"\"}";
            DATA = jsonData + "," + "\"" + projectname + "\":{" + axapps + "},\"axprops\":{" + axprops + "}}";

            try
            {
                //DATA = utilObj.ServiceInputSpecialChars(DATA);

                request.ContentLength = DATA.Length;
                StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                requestWriter.Write(DATA);
                requestWriter.Close();

                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                response = responseReader.ReadToEnd();
                Console.Out.WriteLine(response);
                responseReader.Close();

                return response;
            }
            catch (Exception e)
            {
                LogFile.Log logObj = new LogFile.Log(); //hwayetntwam14k1ztv0pbpxy

                logobj.CreateLog("Call to Getchoices Web Service input json " + e.Message, Sessionid, "CallRestGetChoice", string.Empty);
                Console.Out.WriteLine("-----------------");
                Console.Out.WriteLine(e.Message);
                return response;
            }
        }

        private void ParseGlobalVarsResult(string result)
        {
            ArrayList globalVariables = new ArrayList();
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(result);
            XmlNode childNode = xmlDoc.SelectSingleNode("/result/globalvars");

            string axGridAttachPath = string.Empty, axAttachmentpath = string.Empty;
            if (HttpContext.Current.Session["AxGridAttachPath"] != null && HttpContext.Current.Session["AxGridAttachPath"].ToString() != "")
            {
                if (childNode.SelectSingleNode("AXPIMAGEPATH") != null)
                {
                    childNode.SelectSingleNode("AXPIMAGEPATH").InnerText = HttpContext.Current.Session["AxGridAttachPath"].ToString();
                    axGridAttachPath = "";
                }
                else
                {
                    axGridAttachPath = HttpContext.Current.Session["AxGridAttachPath"].ToString();
                    axGridAttachPath = "<AXPIMAGEPATH>" + axGridAttachPath + "</AXPIMAGEPATH>";
                }
            }
            if (HttpContext.Current.Session["AxAttachFilePath"] != null && HttpContext.Current.Session["AxAttachFilePath"].ToString() != "")
            {
                if (childNode.SelectSingleNode("AXPATTACHMENTPATH") != null)
                {
                    childNode.SelectSingleNode("AXPATTACHMENTPATH").InnerText = HttpContext.Current.Session["AxAttachFilePath"].ToString();
                    axAttachmentpath = "";
                }
                else
                {
                    axAttachmentpath = HttpContext.Current.Session["AxAttachFilePath"].ToString();
                    axAttachmentpath = "<AXPATTACHMENTPATH>" + axAttachmentpath + "</AXPATTACHMENTPATH>";
                }
            }

            try
            {
                if (Session["AxTimezoneVariation"] != null && Session["AxTimezoneVariation"].ToString() == "false")
                {
                    if (childNode.SelectSingleNode("timediff") != null)
                    {
                        childNode.SelectSingleNode("timediff").InnerText = "0";
                    }
                }
            }
            catch (Exception ex) { }

            HttpContext.Current.Session["axGlobalVars"] = "<globalvars>" + childNode.InnerXml + axGridAttachPath + axAttachmentpath + "</globalvars>";
            string defProject = string.Empty;
            if (HttpContext.Current.Session["project"] != null)
                defProject = HttpContext.Current.Session["project"].ToString();
            foreach (XmlNode xmlNode in childNode.ChildNodes)
            {
                if (xmlNode.Name.ToLower() == "axp_lockonread" && (xmlNode.InnerText.ToLower() == "t" || xmlNode.InnerText.ToLower() == "true"))
                    HttpContext.Current.Session["axp_isLockOnRead"] = "true";
                globalVariables.Add(xmlNode.Name + "=" + xmlNode.InnerText);

                if (xmlNode.Name.ToLower() == "axglo_hide")
                    HttpContext.Current.Session["AxGloHideShow"] = xmlNode.InnerText;
                if (xmlNode.Name.ToLower() == "axglo_recordid")
                    HttpContext.Current.Session["AxGloRecId"] = xmlNode.InnerText;
                if (xmlNode.Name.ToLower() == "rolename")
                    HttpContext.Current.Session["AxRole"] = xmlNode.InnerText;
                if (xmlNode.Name.ToLower() == "responsibilies")
                    HttpContext.Current.Session["AxResponsibilities"] = xmlNode.InnerText;

                if (xmlNode.Name.ToLower() == "axpimagepath")
                    HttpContext.Current.Session["AxpImagePathGbl"] = xmlNode.InnerText;
                if (xmlNode.Name.ToLower() == "axpimageserver")
                    HttpContext.Current.Session["AxpImageServerGbl"] = xmlNode.InnerText;
                if (xmlNode.Name.ToLower() == "axpattachmentpath")
                    HttpContext.Current.Session["AxpAttachmentPathGbl"] = xmlNode.InnerText;
            }

            if (globalVariables.Count > 0)
            {
                CreateParamaterArray(globalVariables);
            }
            HttpContext.Current.Session["project"] = defProject;
        }

        private void CreateParamaterArray(ArrayList globalVariables)
        {
            StringBuilder paramlist = new StringBuilder();
            string value = string.Empty;
            int paramCnt = 0;

            for (int i = 0; i < globalVariables.Count; i++)
            {
                string[] strVar = globalVariables[i].ToString().Split('=');
                value = utils.CheckSpecialChars(strVar[1].ToString());
                paramlist.Append("Parameters[" + i + "] = " + "\"" + strVar[0] + "~" + value + "\";  ");
                if (strVar[0].ToString() == "project" && value.Contains(','))
                    HttpContext.Current.Session[strVar[0].ToString()] = value.Split(',')[1];
                else
                    HttpContext.Current.Session[strVar[0].ToString()] = value;
            }
            Boolean useCulture = false;
            string dtCulture = HttpContext.Current.Request.UserLanguages[0];
            if (HttpContext.Current.Session["AxUSCulture"] != null)
                useCulture = Convert.ToBoolean(HttpContext.Current.Session["AxUSCulture"].ToString());
            if (!useCulture)
                dtCulture = "en-gb";
            else
            {
                if (dtCulture.ToLower() == "en" || dtCulture.ToLower() == "en-us")
                    dtCulture = "en-us";
            }
            paramCnt = globalVariables.Count;
            paramlist.Append("Parameters[" + paramCnt + "] = " + "\"username~" + HttpContext.Current.Session["user"].ToString() + "\";  ");
            paramlist.Append("Parameters[" + (paramCnt + 1) + "] = " + "\"Culture~" + dtCulture + "\";  ");

            HttpContext.Current.Session["ClientLocale"] = dtCulture;
            if (paramlist.ToString() != string.Empty)
                utils.SetGlobalVarString(paramlist.ToString());
        }

        [WebMethod(EnableSession = true)]
        public string switchLanguage(string lang)
        {
            string langAttribute = "";

            langAttribute = " lang='" + lang + "' ";

            HttpContext.Current.Session["language"] = lang;
            HttpContext.Current.Session["AxInternalRefresh"] = "true";
            HttpContext.Current.Session["isLanguageRefresh"] = "true";

            return GetNewGlobalVars(langAttribute);
        }

        [WebMethod(EnableSession = true)]
        public string GetAcceptDataFromAPI(string tstDataId, string fldname, string apiInfo)
        {
            string result = string.Empty;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            try
            {
                TStructData tstData = (TStructData)Session[tstDataId];
                if (tstData == null)
                    return Constants.DUPLICATESESS;
                TStructDef tstStrObj = tstData.tstStrObj;
                int fldidx = tstStrObj.GetFieldIndex(fldname);
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[fldidx];
                string api = fld.fieldSelAPI;
                string apiParams = fld.fieldSelAPIParams;
                string[] strDetails = apiParams.Split('♠');
                string apiType = strDetails[1];
                string contType = strDetails[2];


                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(api);

                string DATA = string.Empty;
                if (apiType == "Axpert")
                {
                    request.Method = "POST";
                    request.ContentType = "application/" + contType;
                    DATA = strDetails[5];
                    DATA = ParseAxpertApiParams(DATA, "sqlparams", tstData.fieldValueXml, tstStrObj);
                    request.ContentLength = DATA.Length;
                    StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                    requestWriter.Write(DATA);
                    requestWriter.Close();
                }
                else
                {
                    request.Method = "GET";
                    request.ContentType = "application/" + contType;
                }
                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                result = responseReader.ReadToEnd();
                Console.Out.WriteLine(result);
                responseReader.Close();
                if (result != string.Empty)
                {
                    var obj = JObject.Parse(result);
                    foreach (var attNode in obj["result"][0]["result"]["row"])
                    {
                        result = attNode.First.Last.ToString();
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("Get Accept field value from API.-" + ex.Message, sessionid, "AcceptApi-" + fldname, "new");
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CallGetDBConnectionWS(string jsonData)
        {
            string response = string.Empty;
            string DATA = string.Empty;
            string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBMenuRest.dll/datasnap/rest/TASBMenuRest/GetDBConnection";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentType = "application/json";

            try
            {
                DATA = utilObj.ServiceInputSpecialChars(jsonData);

                request.ContentLength = DATA.Length;
                StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                requestWriter.Write(DATA);
                requestWriter.Close();

                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                response = responseReader.ReadToEnd();
                Console.Out.WriteLine(response);
                responseReader.Close();
                return response;
            }
            catch (Exception e)
            {
                LogFile.Log logObj = new LogFile.Log();
                logobj.CreateLog("Call to GetDBConnection Service input json " + jsonData + " URL:" + URL + " Error:" + e.Message, Session.SessionID, "CallGetDBConnection", "new", "true");
                Console.Out.WriteLine("-----------------");
                Console.Out.WriteLine(e.Message);
                return response;
            }

        }

        [WebMethod(EnableSession = true)]
        public string CallActivateLicenseWS(string xmlData)
        {
            string result = string.Empty;
            WebServiceExt objWebServiceExt = new WebServiceExt();
            result = objWebServiceExt.CallActivateLicenseWS(xmlData);

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string CallGetLicenseInfoWS(string jsonData)
        {
            string response = string.Empty;
            string DATA = string.Empty;
            string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBMenuRest.dll/datasnap/rest/TASBMenuRest/GetLicenseInfo";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentType = "application/json";

            try
            {
                DATA = utilObj.ServiceInputSpecialChars(jsonData);

                request.ContentLength = DATA.Length;
                StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                requestWriter.Write(DATA);
                requestWriter.Close();

                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                response = responseReader.ReadToEnd();
                Console.Out.WriteLine(response);
                responseReader.Close();
                return response;
            }
            catch (Exception e)
            {
                LogFile.Log logObj = new LogFile.Log();
                logobj.CreateLog("Call to GetLicenseInfo Service input json " + jsonData + " URL:" + URL + " Error:" + e.Message, Session.SessionID, "CallGetLicenseInfo", "new", "true");
                Console.Out.WriteLine("-----------------");
                Console.Out.WriteLine(e.Message);
                return response;
            }

        }

        [WebMethod(EnableSession = true)]
        public string CallSetDBPasswordWS(string jsonData)
        {
            string response = string.Empty;
            string DATA = string.Empty;
            string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBMenuRest.dll/datasnap/rest/TASBMenuRest/SetDBPassword";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
            request.Method = "POST";
            request.ContentType = "application/json";

            try
            {
                DATA = utilObj.ServiceInputSpecialChars(jsonData);

                request.ContentLength = DATA.Length;
                StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                requestWriter.Write(DATA);
                requestWriter.Close();

                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                response = responseReader.ReadToEnd();
                Console.Out.WriteLine(response);
                responseReader.Close();
                return response;
            }
            catch (Exception e)
            {
                LogFile.Log logObj = new LogFile.Log();
                logobj.CreateLog("Call to SetDBPassword Service input json " + jsonData + " URL:" + URL + " Error:" + e.Message, Session.SessionID, "CallSetDBPassword", "new", "true");
                Console.Out.WriteLine("-----------------");
                Console.Out.WriteLine(e.Message);
                return response;
            }

        }

        [WebMethod(EnableSession = true)]
        public string GetProjectAppLogo(string projName)
        {
            JObject returnObject = new JObject();

            string logoPath = string.Empty;
            string webBgPath = string.Empty;
            string mobBgPath = string.Empty;

            if (projName != string.Empty)
            {
                try
                {
                    string logoDir = "~/" + projName + "";

                    var dirPath = HttpContext.Current.Server.MapPath(logoDir);

                    DirectoryInfo dir = new DirectoryInfo(dirPath);


                    var logos = dir.GetFiles("axAppLogo.*");
                    if (logos.Count() > 0 && logos[0].Name != string.Empty)
                    {
                        logoPath = "../" + projName + "/" + logos[0].Name + "";
                    }

                    var webBgs = dir.GetFiles("axAppWebBG.*");
                    if (webBgs.Count() > 0 && webBgs[0].Name != string.Empty)
                    {
                        webBgPath = "../" + projName + "/" + webBgs[0].Name + "";
                    }

                    var mobBgs = dir.GetFiles("axAppMobBG.*");
                    if (mobBgs.Count() > 0 && mobBgs[0].Name != string.Empty)
                    {
                        mobBgPath = "../" + projName + "/" + mobBgs[0].Name + "";
                    }
                }
                catch (Exception ex)
                {
                }
            }

            returnObject["logo"] = logoPath;
            returnObject["webbg"] = webBgPath;
            returnObject["mobbg"] = mobBgPath;

            return returnObject.ToString();
        }

        [WebMethod(EnableSession = true)]
        public string NotifyHybridForWeightScale(string guId)
        {
            string result = string.Empty;
            string redisValues = "";
            string firebase_id = string.Empty;

            try
            {
                LogFile.Log logObj = new LogFile.Log();
                if (guId == "")
                {
                    logObj.CreateLog("NotifyHybridForWeightScale- --GUID is empty.", Session.SessionID, "NotifyHybridForWeightScale", "new", "true");
                    return "";
                }

                Util.Util util = new Util.Util();
                FDR fObj = null;
                string GUID = string.Empty;
                string schemaName = string.Empty;
                try
                {
                    fObj = (FDR)Session["FDR"];
                }
                catch (Exception ex)
                {
                    Session["FDR"] = null;
                }
                if (fObj == null)
                {
                    fObj = new FDR();
                    Session["FDR"] = fObj;
                }
                string notificationKey = Constants.AXHYBRIDNOTIFIINFO;
                schemaName = "♠";
                try
                {
                    redisValues = fObj.StringFromRedis(util.GetRedisServerkey(notificationKey, guId), schemaName).ToString();
                    dynamic mbNotify = JsonConvert.DeserializeObject(redisValues);
                    firebase_id = mbNotify.firebase_id.Value;
                }
                catch (Exception ex)
                {
                    logObj.CreateLog("NotifyHybridForWeightScale- --redisValues-- " + redisValues + "--firebase_id--" + firebase_id + " --GUID--" + guId + " --Exception Message--" + ex.Message, Session.SessionID, "NotifyHybridForWeightScale", "new", "true");
                    return "Redis error";
                }

                string webAddr = "";
                string firebase_server_key = "";
                if (ConfigurationManager.AppSettings["mobileFCMAPI"] != null && ConfigurationManager.AppSettings["mobileFCMAPI"].ToString() != "")
                    webAddr = ConfigurationManager.AppSettings["mobileFCMAPI"].ToString();
                if (ConfigurationManager.AppSettings["mobileFCMKey"] != null && ConfigurationManager.AppSettings["mobileFCMKey"].ToString() != "")
                    firebase_server_key = ConfigurationManager.AppSettings["mobileFCMKey"].ToString();

                var httpWebRequest = (HttpWebRequest)WebRequest.Create(webAddr);
                httpWebRequest.ContentType = "application/json";
                httpWebRequest.Headers.Add("Authorization:key=" + firebase_server_key);
                httpWebRequest.Method = "POST";

                using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                {
                    string json = "{\"to\": \"" + firebase_id + "\",\"data\": {\"isaxp_weightscaledata\":\"true\"}}";
                    streamWriter.Write(json);
                    streamWriter.Flush();
                }

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
                logObj.CreateLog("NotifyHybridForWeightScale- --redisValues-- " + redisValues + "--firebase_id--" + firebase_id + " --GUID--" + guId + "--result--" + result, Session.SessionID, "NotifyHybridForWeightScale", "new", "true");
            }
            catch (Exception ex)
            {
                LogFile.Log logObj = new LogFile.Log();
                logObj.CreateLog("NotifyHybridForWeightScale- --redisValues-- " + redisValues + "--firebase_id--" + firebase_id + " --GUID--" + guId + "--result--" + result + " --Exception Message--" + ex.Message, Session.SessionID, "NotifyHybridForWeightScale", "new", "true");
            }
            result = "success";
            return result;
        }

        [WebMethod(EnableSession = true)]
        public void SetHybridWeightScaleInfo(dynamic weightScaleInfo)
        {
            Util.Util util = new Util.Util();
            LogFile.Log logObj = new LogFile.Log();

            string result = JsonConvert.SerializeObject(weightScaleInfo);
            var parsedResult = JObject.Parse(result);
            string strGUID = parsedResult.SelectToken("GUID").Value<string>().ToLower();

            try
            {
                FDR fObj = null;
                try
                {
                    fObj = (FDR)Session["FDR"];
                }
                catch (Exception ex)
                {
                    Session["FDR"] = null;
                }
                if (fObj == null)
                {
                    fObj = new FDR();
                    Session["FDR"] = fObj;
                }
                string weightScaleKey = Constants.AXHYBRIDWEIGHTSCALEINFO;

                FDW fdwObj = FDW.Instance;
                fdwObj.SaveInRedisServer(util.GetRedisServerkey(weightScaleKey, strGUID), result, Constants.AXHYBRIDWEIGHTSCALEINFO, "♠");
                logObj.CreateLog("SetHybridWeightScaleInfo-" + weightScaleInfo + " --strGUID--" + strGUID + "--result--" + result, Session.SessionID, "SetHybridWeightScaleInfo", "new", "true");
            }
            catch (Exception ex)
            {
                logObj.CreateLog("SetHybridWeightScaleInfo-" + weightScaleInfo + " --strGUID--" + strGUID + "--result--" + result + " --Exception Message--" + ex.Message, Session.SessionID, "SetHybridWeightScaleInfo", "new", "true");
            }
        }

        [WebMethod(EnableSession = true)]
        public string NotifyCloseWeightScalePort(string guId)
        {
            string result = string.Empty;
            string redisValues = "";
            string firebase_id = string.Empty;

            try
            {
                if (guId == "")
                    return "";

                Util.Util util = new Util.Util();
                FDR fObj = null;
                string GUID = string.Empty;
                string schemaName = string.Empty;
                try
                {
                    fObj = (FDR)Session["FDR"];
                }
                catch (Exception ex)
                {
                    Session["FDR"] = null;
                }
                if (fObj == null)
                {
                    fObj = new FDR();
                    Session["FDR"] = fObj;
                }
                string notificationKey = Constants.AXHYBRIDNOTIFIINFO;
                schemaName = "♠";
                try
                {
                    redisValues = fObj.StringFromRedis(util.GetRedisServerkey(notificationKey, guId), schemaName).ToString();
                    dynamic mbNotify = JsonConvert.DeserializeObject(redisValues);
                    firebase_id = mbNotify.firebase_id.Value;
                }
                catch (Exception ex)
                {
                    return "Redis error";
                }

                string webAddr = "";
                string firebase_server_key = "";
                if (ConfigurationManager.AppSettings["mobileFCMAPI"] != null && ConfigurationManager.AppSettings["mobileFCMAPI"].ToString() != "")
                    webAddr = ConfigurationManager.AppSettings["mobileFCMAPI"].ToString();
                if (ConfigurationManager.AppSettings["mobileFCMKey"] != null && ConfigurationManager.AppSettings["mobileFCMKey"].ToString() != "")
                    firebase_server_key = ConfigurationManager.AppSettings["mobileFCMKey"].ToString();

                var httpWebRequest = (HttpWebRequest)WebRequest.Create(webAddr);
                httpWebRequest.ContentType = "application/json";
                httpWebRequest.Headers.Add("Authorization:key=" + firebase_server_key);
                httpWebRequest.Method = "POST";

                using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                {
                    string json = "{\"to\": \"" + firebase_id + "\",\"data\": {\"isaxp_weightscaleclose\":\"true\"}}";
                    streamWriter.Write(json);
                    streamWriter.Flush();
                }

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                LogFile.Log logObj = new LogFile.Log();
                logObj.CreateLog("NotifyCloseWeightScalePort- --redisValues-- " + redisValues + "--firebase_id--" + firebase_id + " --GUID--" + guId + "--result--" + result + " --Exception Message--" + ex.Message, Session.SessionID, "NotifyCloseWeightScalePort", "new", "true");
            }
            return "";
        }

        [WebMethod(EnableSession = true)]
        public string CallApiDefinations(string api = "", string type = "axpert", string cacheInfo = "[]")
        {
            if (HttpContext.Current.Session["Project"] == null || Convert.ToString(HttpContext.Current.Session["Project"]) == string.Empty)
            {
                return utils.SESSTIMEOUT;
            }

            FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
            LogFile.Log logobj = new LogFile.Log();

            ArrayList nonCachedApi = new ArrayList();
            string baseName = string.Empty;
            string apiNameKeyPrefix = string.Empty;

            try
            {
                baseName = JArray.Parse(cacheInfo)[0]["id"].ToString();
            }
            catch (Exception ex)
            { }

            apiNameKeyPrefix = type.ToUpper() + "-" + (baseName != string.Empty ? baseName + "-" : "");

            string schemaName = string.Empty;
            if (HttpContext.Current.Session["dbuser"] != null)
                schemaName = HttpContext.Current.Session["dbuser"].ToString();

            string returnString = string.Empty;

            bool cacheMeightExist = false;
            try
            {
                cacheMeightExist = utilObj.getExpiredCache(cacheInfo, JObject.Parse("{\"id\": \"id\", \"cache\": \"cachedata\", \"cachedTime\": \"cachedTime\", \"refreshAfter\": \"autorefresh\"}")) == string.Empty;
            }
            catch (Exception ex)
            { }

            JObject returnObject = new JObject();

            if (api == string.Empty)
            {
                return returnObject.ToString();
            }

            if (cacheMeightExist)
            {
                string[] apiArr = api.Split(',');

                foreach (string apiName in apiArr)
                {
                    if (apiName == string.Empty)
                    {
                        continue;
                    }

                    string redisData = fObj.StringFromRedis(fObj.MakeKeyName(Constants.REDISAPIKEYS, apiNameKeyPrefix + apiName), schemaName);

                    if (redisData != string.Empty)
                    {
                        try
                        {
                            returnObject[apiName] = JToken.Parse(redisData);
                            //nonCachedApi.Add(apiName);
                        }
                        catch (Exception ex)
                        {
                            returnObject[apiName] = redisData;
                            //nonCachedApi.Add(apiName);
                        }
                    }
                }
            }

            if (type.ToLower() == "axpert")
            {

                try
                {
                    string wgData = string.Empty;

                    //string[] roles = System.Web.HttpContext.Current.Session["userroles"].ToString().Split(',');

                    string apiNameString = string.Join(", ", api.Split(',').Where(apiName =>
                    {
                        return returnObject[apiName] == null || returnObject[apiName].ToString() == string.Empty;
                    }).Select(apiName =>
                    {
                        return ("'" + apiName + "'");
                    }));

                    if (apiNameString == string.Empty)
                    {
                        return returnObject.ToString();
                    }

                    string sqlInput = "select a.execapidefname, a.execapiurl, a.apiresponsetype, a.execapimethod, a.apiresponseformat, a.execapirequeststring from executeapidef a where a.execapidefname in (" + apiNameString + ")";

                    ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
                    wgData = asbExt.ExecuteSQL("", sqlInput, "JSON");



                    JObject resultRows = JObject.Parse(wgData);

                    if (wgData != string.Empty)
                    {
                        try
                        {

                            string qdata = string.Empty;

                            JObject wgResult = new JObject();

                            JArray apiInfos = (JArray)resultRows["result"]["row"];

                            foreach (JObject apiResp in apiInfos)
                            {
                                try
                                {
                                    string requestName = apiResp["execapidefname"].ToString();
                                    string requestUrl = apiResp["execapiurl"].ToString();
                                    string requestMethod = apiResp["execapimethod"].ToString();
                                    string requestData = apiResp["execapirequeststring"].ToString();
                                    string responseType = apiResp["apiresponsetype"].ToString();
                                    string responseFormat = apiResp["apiresponseformat"].ToString();

                                    string apiResponse = string.Empty;

                                    if (responseType.ToLower() == "axpert" || requestMethod.ToLower() == "post")
                                    {
                                        apiResponse = GetDataFromPostAPI(requestUrl, responseFormat, requestData);
                                    }
                                    else
                                    {
                                        apiResponse = GetDataFromGetAPI(requestUrl, responseType, requestMethod);
                                    }

                                    if (requestName != string.Empty)
                                    {
                                        try
                                        {
                                            returnObject[requestName] = JToken.Parse(apiResponse);
                                            nonCachedApi.Add(requestName);
                                        }
                                        catch (Exception ex)
                                        {
                                            returnObject[requestName] = apiResponse;
                                            nonCachedApi.Add(requestName);
                                        }
                                    }
                                }
                                catch (Exception ex)
                                {

                                }

                            }
                        }
                        catch (Exception ex)
                        { }
                    }


                }
                catch (Exception ex)
                { }
            }
            else if (type.ToLower() == "sql")
            {
                try
                {
                    string apiNameString = string.Join(",", api.Split(',').Where(apiName =>
                    {
                        return returnObject[apiName] == null || returnObject[apiName].ToString() == string.Empty;
                    }));

                    if (apiNameString == string.Empty)
                    {
                        return returnObject.ToString();
                    }

                    AxpertInterGetCustomSql objWData = new AxpertInterGetCustomSql(apiNameString, new ArrayList());
                    string apiResponses = objWData.GetCustomSqlData().ToString();

                    if (apiResponses != string.Empty)
                    {
                        try
                        {
                            JObject apiResponsesObject = JObject.Parse(apiResponses);

                            foreach (var apiResponse in apiResponsesObject)
                            {
                                returnObject[apiResponse.Key] = apiResponse.Value;
                                if (apiResponse.Key != "error")
                                {
                                    nonCachedApi.Add(apiResponse.Key);
                                }
                            }
                        }
                        catch (Exception ex)
                        { }
                    }
                }
                catch (Exception ex)
                {

                }
            }

            FDW fdwObj = FDW.Instance;
            bool isRedisConnected = fdwObj.IsConnected;

            if (isRedisConnected)
            {
                foreach (string cachingApi in nonCachedApi)
                {
                    try
                    {
                        if (returnObject[cachingApi] != null)
                        {
                            bool saved = fdwObj.SaveInRedisServer(fObj.MakeKeyName(Constants.REDISAPIKEYS, apiNameKeyPrefix + cachingApi), returnObject[cachingApi].ToString(), "", schemaName);
                        }
                    }
                    catch (Exception ex)
                    { }
                }
            }

            returnString = returnObject.ToString();

            return returnString;
        }

        [WebMethod(EnableSession = true)]
        public string GetDataFromGetAPI(string ApiUrl, string ApiMethodType, string ApiRespType)
        {
            string result = string.Empty;
            ApiMethodType = ApiMethodType.ToUpper();
            string DATA = string.Empty;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl);
            request.Method = "GET";
            request.ContentType = "application/" + ApiRespType;

            try
            {
                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                result = responseReader.ReadToEnd();
                Console.Out.WriteLine(result);
                responseReader.Close();
            }
            catch (Exception e)
            {
                result = e.Message;
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetDataFromPostAPI(string ApiUrl, string ApiRespType, string ApiData)
        {
            string result = string.Empty;

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl);

            //string DATA = string.Empty;
            //if (apiType == "Axpert")
            //{
            request.Method = "POST";
            request.ContentType = "application/" + ApiRespType;
            //DATA = strDetails[5];
            ApiData = ParseAxpertApiParams(ApiData, "sqlparams", "", null);
            request.ContentLength = ApiData.Length;
            StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
            requestWriter.Write(ApiData);
            requestWriter.Close();
            //}

            try
            {
                WebResponse webResponse = request.GetResponse();
                Stream webStream = webResponse.GetResponseStream();
                StreamReader responseReader = new StreamReader(webStream);
                result = responseReader.ReadToEnd();
                Console.Out.WriteLine(result);
                responseReader.Close();

                //if (result != string.Empty && apiType.ToLower() == "external")
                //{
                //    result = ApiResultParser(result, contType, mapname, fldName, fromApiName, fromApiExp);
                //}
                //else if (result != string.Empty)
                //{

                if (result != string.Empty && ApiRespType.ToLower() == "xml")
                {
                    try
                    {
                        XmlDocument doc = new XmlDocument();
                        doc.LoadXml(result);

                        result = JsonConvert.SerializeXmlNode(doc);

                    }
                    catch (Exception ex) { }
                }

                try
                {
                    JObject obj = JObject.Parse(result);
                    result = obj["result"].First.ToString();
                }
                catch (Exception ex) { }

                //}
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }


        [WebMethod(EnableSession = true)]
        public string CallExecuteScriptAPI(string apifrom, string tstDataId, string apiButtonName, string apiInfo)
        {
            string result = string.Empty;
            if (HttpContext.Current.Session["project"] == null)
                return utilObj.SESSTIMEOUT;
            try
            {
                if (apifrom == "t")
                {
                    TStructData tstData = (TStructData)Session[tstDataId];
                    if (tstData == null)
                        return Constants.DUPLICATESESS;
                    TStructDef tstStrObj = tstData.tstStrObj;
                    int fldidx = tstStrObj.GetButtonIndex(apiButtonName);
                    TStructDef.ButtonStruct btn = (TStructDef.ButtonStruct)tstStrObj.btns[fldidx];
                    string api = btn.btnapi.url;
                    string apiType = btn.btnapi.restype;
                    string contType = btn.btnapi.resformat;

                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(api);

                    string DATA = string.Empty;
                    if (apiType == "Axpert")
                    {
                        request.Method = "POST";
                        request.ContentType = "application/" + contType;
                        DATA = btn.btnapi.reqstr;
                        DATA = ParseAxpertApiParams(DATA, "apiparams", tstData.fieldValueXml, tstStrObj);
                        request.ContentLength = DATA.Length;
                        StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                        requestWriter.Write(DATA);
                        requestWriter.Close();
                    }
                    else
                    {
                        request.Method = "GET";
                        request.ContentType = "application/" + contType;
                    }
                    WebResponse webResponse = request.GetResponse();
                    Stream webStream = webResponse.GetResponseStream();
                    StreamReader responseReader = new StreamReader(webStream);
                    result = responseReader.ReadToEnd();
                    Console.Out.WriteLine(result);
                    responseReader.Close();
                }
                else
                {

                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("Call ExecuteScript APi.-" + ex.Message, sessionid, "ExecuteScriptAPi-" + apiButtonName, "new", "true");
            }
            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetAxpertCunfigInfo(string additionalInfo)
        {
            string axpertdeveloperUrl = string.Empty;
            try
            {
                if (ConfigurationManager.AppSettings["axpertdeveloper"] != null)
                {
                    string adDetails = HttpContext.Current.Session["project"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["user"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["pwd"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["language"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["hybridGUID"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["AxAppTitle"].ToString();
                    adDetails += "♦" + HttpContext.Current.Session["userDetails"].ToString();
                    if (additionalInfo != "")
                        adDetails += "♦" + additionalInfo;
                    axpertdeveloperUrl = ConfigurationManager.AppSettings["axpertdeveloper"].ToString();
                    adDetails = utils.encrtptDecryptAES(adDetails);
                    axpertdeveloperUrl += "aspx/dwbsignin.aspx?adInfo=" + adDetails;
                }
            }
            catch (Exception ex)
            {
                axpertdeveloperUrl = string.Empty;
            }
            return axpertdeveloperUrl;
        }

        [WebMethod(EnableSession = true)]
        public string GetInternalSSOToken(string _thisProj)
        {
            string InterSSOToken = string.Empty;
            if (_thisProj != string.Empty)
            {
                try
                {
                    string _thisUser = string.Empty;
                    if (HttpContext.Current.Session["username"] != null && HttpContext.Current.Session["username"].ToString() != "")
                        _thisUser = HttpContext.Current.Session["username"].ToString();
                    else
                        return "";
                    string response = string.Empty;
                    string DATA = string.Empty;
                    string URL = System.Configuration.ConfigurationManager.AppSettings["RestDllPath"] + "ASBDefineRest.dll/datasnap/rest/TASBDefineRest/GetInternalSSOKey";
                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
                    request.Method = "POST";
                    request.ContentType = "application/json";
                    DATA = "{\"_parameters\":[{\"getssokey\":{\"axpapp\": \"" + _thisProj + "\",\"username\":\"" + _thisUser + "\"}}]}";
                    request.ContentLength = DATA.Length;
                    StreamWriter requestWriter = new StreamWriter(request.GetRequestStream(), System.Text.Encoding.ASCII);
                    requestWriter.Write(DATA);
                    requestWriter.Close();

                    try
                    {
                        WebResponse webResponse = request.GetResponse();
                        Stream webStream = webResponse.GetResponseStream();
                        StreamReader responseReader = new StreamReader(webStream);
                        response = responseReader.ReadToEnd();
                        //Console.Out.WriteLine(response);
                        responseReader.Close();

                        try
                        {
                            JArray jData = null;
                            JObject tData = JObject.Parse(response);
                            jData = (JArray)tData["result"];
                            string authKey = jData[0]["result"][0]["key"].ToString();
                            InterSSOToken = "proj=" + _thisProj + "&username=" + _thisUser + "&uKey=" + authKey + "&lang=" + Session["language"].ToString();

                            /// 
                            /// 
                            ///

                            InterSSOToken = utilObj.encrtptDecryptAES(InterSSOToken);
                            //This URL is hardcoded for the understanding purpose which need to be constructed for the production instant.
                            InterSSOToken = "http://demo.agile-labs.com/aspx/signin.aspx?InternalSSO=" + InterSSOToken;
                        }
                        catch (Exception exe)
                        {
                            InterSSOToken = string.Empty;
                        }
                    }
                    catch (Exception e)
                    {
                        InterSSOToken = string.Empty;
                    }
                }
                catch (Exception ex)
                {
                    InterSSOToken = string.Empty;
                }
            }
            return InterSSOToken;
        }
    }
}

