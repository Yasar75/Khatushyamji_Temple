using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Xml;

public partial class aspx_AxDBScript : System.Web.UI.Page
{
    #region variable
    public string DbObjDataXML = string.Empty;
    ASBExt.WebServiceExt asbEx = new ASBExt.WebServiceExt();
    public string direction = "ltr";
    Util.Util util;
    public string langType = "en";
    DBquery DBQobj;
    #endregion
    protected override void InitializeCulture()
    {
        if (Session["language"] != null)
        {
            util = new Util.Util();
            string dirLang = string.Empty;
            dirLang = util.SetCulture(Session["language"].ToString().ToUpper());
            if (!string.IsNullOrEmpty(dirLang))
            {
                direction = dirLang.Split('-')[0];
                langType = dirLang.Split('-')[1];
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        if (HttpContext.Current.Session["Project"] == null || Convert.ToString(HttpContext.Current.Session["Project"]) == string.Empty)
        {
            SessExpires();
            return;
        }
        loadTheSchema();
    }

    private void SessExpires()
    {
        string url = Convert.ToString(HttpContext.Current.Application["SessExpiryPath"]);
        Response.Write("<script>" + Constants.vbCrLf);
        Response.Write("parent.parent.location.href='" + url + "';");
        Response.Write(Constants.vbCrLf + "</script>");
    }

    private void loadTheSchema()
    {
        DBQobj = new DBquery();
        string query = string.Empty;
        string result = string.Empty;
        string rowXML = string.Empty;
        string[] DbObjects = { "Table", "View", "Function", "Procedure", "Trigger", "Index", "Sequence" };
        try
        {
            foreach (string obj in DbObjects)
            {
                //query = "select object_name from user_objects where object_type='" + obj +"'";
                string title;
                query = DBQobj.getSQLqueryString("", "getObjList", obj.ToUpper());
                result = asbEx.ExecuteSQL("", query);
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(result);
                rowXML = xmlDoc["sqlresultset"]["response"].InnerXml;
                if (obj == "Index")
                    title = obj + "es";
                else
                    title = obj + "s";
                DbObjDataXML += "<parent folder=\"True\" title=\"" + title + "\">" + rowXML + "</parent>";
            }
            DbObjDataXML = "<root><parent folder=\"False\" title=\"Editor\" icon=\"filter_frames\">Editor</parent>" + DbObjDataXML + "</root>";
            Session["DbObjData"] = DbObjDataXML;
        }
        catch (Exception ex)
        {

        }
    }

    [WebMethod]
    public static string callExecuteSQL(string queryString)
    {
        ASBExt.WebServiceExt asbExt = new ASBExt.WebServiceExt();
        string result = "";
        try
        {
            result = asbExt.ExecuteSQL("", queryString,"JSON");
           
        }
        catch (Exception ex) { }
        return result;

    }
    [WebMethod]
    public static string loadObjectInfo(string objName, string objType, string objInfo)
    {
        string finalResult = string.Empty;
        string query = string.Empty;
        if (HttpContext.Current.Session["Project"] == null || Convert.ToString(HttpContext.Current.Session["Project"]) == string.Empty)
        {
            finalResult = "SESSION_TIMEOUT";
        }
        else
        {
            DBquery DBQobj = new DBquery();
            ASBExt.WebServiceExt asbEx = new ASBExt.WebServiceExt();

            if (objType == "Indexes")
                objType = "INDEX";
            else
                objType = objType.Substring(0, objType.Length - 1).ToUpper();


            switch (objInfo)
            {

                case "Columns":
                    query = DBQobj.getSQLqueryString(objName, "getStruct", objType);
                    break;
                case "Script/Source":
                    query = DBQobj.getSQLqueryString(objName, "getSource", objType);
                    break;
                case "Indexes":
                    query = DBQobj.getSQLqueryString(objName, "getIndex");
                    break;
                case "Triggers":
                    query = DBQobj.getSQLqueryString(objName, "getTrig");
                    break;
                case "Data":
                    query = DBQobj.getSQLqueryString(objName, "getData");
                    break;
                case "Error":
                    query = DBQobj.getSQLqueryString(objName, "getError", objType);
                    break;
                case "Argument":
                    query = DBQobj.getSQLqueryString(objName, "getArgs", objType);
                    break;
                case "Info":
                    query = DBQobj.getSQLqueryString(objName, "getSeqInfo", objType);
                    break;
                case "allobjData":
                    query = DBQobj.getSQLqueryString(objName, "allObjData", objType);
                    break;
            }
            finalResult = asbEx.ExecuteSQL("", query, "JSON");
        }
        return finalResult;
    }
}