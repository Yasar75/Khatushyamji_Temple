using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class aspx_AddEditResponsibility : System.Web.UI.Page
{
    public string proj = string.Empty;
    public string sid = string.Empty;
    public string trace = string.Empty;
    public string user = string.Empty;
    public string language = string.Empty;
    public string acScript = string.Empty;
    public string direction = "ltr";
    public string langType = "en";
    string errorLog = string.Empty;
    string txtFilter = string.Empty;
    ArrayList arrPages = new ArrayList();
    ArrayList arrForms = new ArrayList();
    ArrayList arrReports = new ArrayList();
    LogFile.Log logObj = new LogFile.Log();
    Util.Util util = new Util.Util();
    ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();
    int totalResrows = 0;
    string currentRes = string.Empty, ixml = string.Empty;
    //bool currentResStatus = false;
    string actionType = string.Empty, result = string.Empty;
    public bool isCloudApp = false;

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
        util = new Util.Util();
        util.IsValidSession();
        //util.IsValidAxpertSession();
        ResetSessionTime();
        if (Session["project"] == null)
        {
            SessionExpired();
            return;
        }
        GetGlobalVariables();
        if (!Page.IsPostBack)
        {
            var qryStr = Request.QueryString;
            if (qryStr["action"] != null)
                actionType = qryStr["action"].ToString();
            if (util.IsValidQueryString(Request.RawUrl) == false)
                HttpContext.Current.Response.Redirect(util.ERRPATH + Constants.INVALIDURL);

            if (actionType == "add")
            {
                hdnAction.Value = "Add";
                AddResponsibility();
            }
            else if (actionType == "edit")
            {
                hdnAction.Value = "Update";
                if (qryStr["name"] != null)
                {
                    currentRes = qryStr["name"].ToString();
                    //currentResStatus = Convert.ToBoolean(qryStr["status"]);
                    EditResponsibility();
                }
            }
            else
            {
                currentRes = qryStr["name"].ToString();
                CopyResponsibility();
            }
        }

        if (ConfigurationManager.AppSettings["isCloudApp"] != null)
        {
            isCloudApp = Convert.ToBoolean(ConfigurationManager.AppSettings["isCloudApp"].ToString()); ;
        }
        Page.ClientScript.RegisterStartupScript(GetType(), "set global var in iview", "<script>var isCloudApp = '" + isCloudApp.ToString() + "';</script>");
    }

    private void AddResponsibility()
    {
        ViewState["ResAction"] = "AddRes";
        Session["CurrentRes"] = "default";
        GetAllTreeNodes("add", "defalut");
        //ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "tabFocusEvent('txtReEditResp', 'btnClose');", true);
    }

    private void EditResponsibility()
    {
        ViewState["ResAction"] = "UpdateRes";
        txtReEditResp.Text = currentRes;
        txtReEditResp.ReadOnly = true;
        //if (currentResStatus)
        //    ddlStatus.SelectedIndex = 0;
        //else
        //    ddlStatus.SelectedIndex = 1;
        GetAllTreeNodes("update", currentRes);
        //ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "tabFocusEvent('txtReEditResp', 'btnClose');", true);
    }

    private void CopyResponsibility()
    {
        ViewState["ResAction"] = "CopyRes";
        GetAllTreeNodes("copy", currentRes);
        //ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "tabFocusEvent('txtReEditResp', 'btnClose');", true);
    }

    private void GetAllTreeNodes(string actionType, string currentRes)
    {
        errorLog = logObj.CreateLog("Calling GetResponsibilityDetails Service", sid, "GetRespDetails", "new");
        ixml = "<root axpapp='" + proj + "' sessionid= '" + sid + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' trace='" + errorLog + "' role='" + currentRes + "'>";
        ixml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        //Call service
        result = objWebServiceExt.CallGetAccessRightsDetailsWS("Resp", ixml);

        if (result.Contains(Constants.ERROR) == true)
        {
            result = util.ParseXmlErrorNode(result);
            if (result == Constants.SESSIONERROR || result == Constants.SESSIONEXPMSG)
            {
                Session.RemoveAll();
                Session.Abandon();
                SessionExpired();
                return;
            }
            Response.Redirect("../err.aspx?errmsg=" + result);
        }
        else
        {
            FillAccessRights(result, treeEditRes);
            TreeNodeCollection treeNodes = treeEditRes.Nodes;
            treeEditRes.ExpandAll();
            treeEditRes.EnableClientScript = true;
        }
    }

    /// <summary>
    /// Function to populate the treeview with Access rights
    /// </summary>
    /// <param name="result"></param>
    /// <param name="MyTree"></param>
    private void FillAccessRights(string result, TreeView MyTree)
    {
        XmlDocument xmldoc = new XmlDocument();
        xmldoc.LoadXml(result);
        Session["ResTreeXml"] = result;
        XmlNodeList roots;
        //XmlNode prnode;
        XmlNodeList baseDataNodes = default(XmlNodeList);
        roots = xmldoc.SelectNodes("//root");

        foreach (XmlNode prnode in roots)
        {
            baseDataNodes = prnode.ChildNodes;
            foreach (XmlNode baseDataNode in baseDataNodes)
            {
                if (baseDataNode.Name == "Pages")
                {
                    TreeNode pages = new TreeNode("Pages");
                    string chkparent = null;
                    XmlNode nodex = baseDataNode.Attributes["checked"];
                    if (nodex == null)
                        chkparent = "";
                    else
                        chkparent = nodex.Value;
                    if (chkparent == "true")
                        pages.Checked = true;
                    pages.SelectAction = TreeNodeSelectAction.None;
                    MyTree.Nodes.Add(pages);
                    XmlNodeList cNodes = default(XmlNodeList);
                    cNodes = baseDataNode.ChildNodes;
                    foreach (XmlNode vNode in cNodes)
                    {
                        string IsChecked = "";
                        if (vNode.Attributes["checked"] != null)
                        {
                            IsChecked = vNode.Attributes["checked"].Value;
                        }
                        populateChild(vNode, pages, IsChecked);
                    }
                }
                else if (baseDataNode.Name == "Tstructs")
                {
                    TreeNode pages = new TreeNode("Tstructs");
                    string chkparent = null;
                    XmlNode nodex = baseDataNode.Attributes["checked"];
                    if (nodex == null)
                        chkparent = "";
                    else
                        chkparent = nodex.Value;
                    if (chkparent == "true")
                        pages.Checked = true;
                    pages.SelectAction = TreeNodeSelectAction.None;
                    MyTree.Nodes.Add(pages);
                    XmlNodeList cNodes = default(XmlNodeList);
                    cNodes = baseDataNode.ChildNodes;
                    foreach (XmlNode vNode in cNodes)
                    {
                        string IsChecked = "";
                        if (vNode.Attributes["checked"] != null)
                        {
                            IsChecked = vNode.Attributes["checked"].Value;
                        }
                        populateChild(vNode, pages, IsChecked, "tstruct");
                    }
                }
                else
                {
                    TreeNode pages = new TreeNode("IViews");
                    string chkparent = null;
                    XmlNode nodex = baseDataNode.Attributes["checked"];
                    if (nodex == null)
                        chkparent = "";
                    else
                        chkparent = nodex.Value;
                    if (chkparent == "true")
                        pages.Checked = true;
                    pages.SelectAction = TreeNodeSelectAction.None;
                    MyTree.Nodes.Add(pages);
                    XmlNodeList cNodes = default(XmlNodeList);
                    cNodes = baseDataNode.ChildNodes;
                    foreach (XmlNode vNode in cNodes)
                    {
                        string IsChecked = "";
                        if (vNode.Attributes["checked"] != null)
                        {
                            IsChecked = vNode.Attributes["checked"].Value;
                        }
                        populateChild(vNode, pages, IsChecked, "iview");
                    }
                }
            }
        }
    }

    public void populateChild(XmlNode parent, TreeNode pnode, string isChecked, string pageType = null)
    {

        TreeNode tnode = new TreeNode();
        XmlNode nodecap = parent.Attributes["cap"];

        if (nodecap == null)
            tnode.Text = "";
        else
            tnode.Text = nodecap.Value;

        XmlNode nodePar = parent.Attributes["parent"];
        XmlNode nodeSname = parent.Attributes["sname"];

        if (nodePar != null && nodePar.Value == "" && nodeSname != null && nodeSname.Value != "")
        {
            string sName = nodeSname.Value;
            if (sName.Substring(0, 1) == "t")
            {
                tnode.NavigateUrl = "javascript:openChildwintst('" + sName.Substring(1, sName.Length - 1) + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/tstruct.png";
                tnode.ImageToolTip = "TStruct";
                tnode.ToolTip = "page";
            }
            else
            {
                tnode.NavigateUrl = "javascript:openChildwiniv('" + sName.Substring(1, sName.Length - 1) + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/iview.png";
                tnode.ImageToolTip = "IView";
                tnode.ToolTip = "page";
            }
        }
        tnode.Value = parent.Name;

        string chkpar = null;
        if (isChecked == "")
        {
            XmlNode node3 = parent.Attributes["checked"];

            if (node3 == null)
                chkpar = "";
            else
                chkpar = node3.Value;
        }
        else
        {
            chkpar = isChecked;
        }
        if (chkpar == "true")
            tnode.Checked = true;
        if (pageType != null)
        {
            if (pageType == "tstruct")
            {
                tnode.NavigateUrl = "javascript:openChildwintst('" + tnode.Value + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/tstruct.png";
                tnode.ImageToolTip = "TStruct";
            }
            else
            {
                tnode.NavigateUrl = "javascript:openChildwiniv('" + tnode.Value + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/iview.png";
                tnode.ImageToolTip = "IView";
            }
        }
        tnode.SelectAction = TreeNodeSelectAction.None;
        pnode.ChildNodes.Add(tnode);

        XmlNodeList dNodes = default(XmlNodeList);
        dNodes = parent.ChildNodes;

        foreach (XmlNode mNode in dNodes)
        {
            if (mNode.Attributes["sname"] != null)
            {
                string sName = mNode.Attributes["sname"].Value;
                if (sName != "")
                {
                    if (sName.Substring(0, 1) == "t")
                        popLeaf(mNode, tnode, "yestst");
                    else
                        popLeaf(mNode, tnode, "yesiv");
                }
                else
                {
                    popLeaf(mNode, tnode, "no");
                }
            }
        }
    }

    public void popLeaf(XmlNode sparent, TreeNode snode, string link, bool tstruct = false)
    {

        string pare = null;
        XmlNode nodea = sparent.Attributes["type"];
        string parentName = string.Empty;
        if ((nodea == null))
        {
            pare = "";
            if (sparent.Attributes["sname"] != null)
            {
                string sname = sparent.Attributes["sname"].Value;
                if (sname != "")
                {
                    parentName = sname.Substring(1, sname.Length - 1);
                    if (sname.Substring(0, 1) == "t")
                        link = "yestst";
                    else
                        link = "yesiv";
                }
            }
        }
        else
        {
            pare = nodea.Value;
        }

        string IsChecked = "";
        if (sparent.Attributes["checked"] != null)
            IsChecked = sparent.Attributes["checked"].Value;

        if (pare == "parent")
        {
            populateChild(sparent, snode, IsChecked);
        }
        else
        {
            string chk = null;
            XmlNode node1 = sparent.Attributes["checked"];
            if ((node1 == null))
                chk = "";
            else
                chk = node1.Value;

            TreeNode tnode = new TreeNode();

            XmlNode nodecap = sparent.Attributes["cap"];
            if (nodecap == null)
                tnode.Text = "";
            else
                tnode.Text = nodecap.Value;

            tnode.Value = sparent.Name;

            if (link == "yestst")
            {
                if (parentName != "")
                    tnode.NavigateUrl = "javascript:openChildwintst('" + parentName + "');";
                else
                    tnode.NavigateUrl = "javascript:openChildwintst('" + tnode.Value + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/tstruct.png";
                tnode.ImageToolTip = "TStruct";
                tnode.ToolTip = "page";
            }
            else if (link == "yesiv")
            {
                if (parentName != "")
                    tnode.NavigateUrl = "javascript:openChildwiniv('" + parentName + "');";
                else
                    tnode.NavigateUrl = "javascript:openChildwiniv('" + tnode.Value + "');";
                tnode.ImageUrl = "~/App_Themes/green/images/iview.png";
                tnode.ImageToolTip = "IView";
                tnode.ToolTip = "page";
            }
            else
            {
                tnode.SelectAction = TreeNodeSelectAction.None;
            }

            if (chk == "true")
                tnode.Checked = true;
            else
                tnode.Checked = false;

            snode.ChildNodes.Add(tnode);
        }
    }

    private void SessionExpired()
    {
        string url = Convert.ToString(HttpContext.Current.Application["SessExpiryPath"]);
        Response.Write("<script>" + Constants.vbCrLf);
        Response.Write("parent.parent.location.href='" + url + "';");
        Response.Write(Constants.vbCrLf + "</script>");
    }

    private void ResetSessionTime()
    {
        if (Session["AxSessionExtend"] != null && Session["AxSessionExtend"].ToString() == "true")
        {
            HttpContext.Current.Session["LastUpdatedSess"] = DateTime.Now.ToString();
            ClientScript.RegisterStartupScript(this.GetType(), "SessionAlert", "eval(callParent('ResetSession()', 'function'));", true);
        }
    }

    private void GetGlobalVariables()
    {
        proj = Session["project"].ToString();
        ViewState["proj"] = proj;
        user = Session["user"].ToString();
        ViewState["user"] = user;
        sid = Session["nsessionid"].ToString();
        ViewState["sid"] = sid;
        language = Session["language"].ToString();
        ViewState["language"] = language;
        if (Session["language"].ToString() == "ARABIC")
        {
            direction = "rtl";
        }
    }

    /// <summary>
    /// Function to Update a single responsibility details.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnReEdSave_Click(object sender, EventArgs e)
    {
        TreeNodeCollection Treenodes = treeEditRes.CheckedNodes;
        string resName = txtReEditResp.Text.Trim();
        string active = string.Empty;
        //if (ddlStatus.SelectedIndex == 0)
        //    active = "Y";
        //else
        //    active = "N";

        for (int i = 0; i < treeEditRes.CheckedNodes.Count; i++)
        {
            TreeNode pNode = treeEditRes.CheckedNodes[i];
            while (pNode.Parent != null)
            {
                pNode = pNode.Parent;
                pNode.Checked = true;
            }
        }

        Session["CurrentRes"] = "";
        if (ViewState["ResAction"].ToString() == "AddRes")
            ProcessRes(resName, "add", Treenodes, active);
        else if (ViewState["ResAction"].ToString() == "CopyRes")
            ProcessRes(resName, "copy", Treenodes, active);
        else
            ProcessRes(resName, "update", Treenodes, active);
    }

    /// <summary>
    /// function for replacing the special characters in a given string.
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    /// <remarks></remarks>
    private string CheckSpecialChars(string str)
    {
        str = Regex.Replace(str, "&", "&amp;");
        str = Regex.Replace(str, "<", "&lt;");
        str = Regex.Replace(str, ">", "&gt;");
        str = Regex.Replace(str, "'", "&apos;");
        str = Regex.Replace(str, "\"", "&quot;");
        if (str == "dd/mm/yyyy")
            str = "";
        return str;
    }

    /// <summary>
    /// Function to display only selected Access rights
    /// </summary>
    /// <param name="tree"></param>
    private void ProcessRes(string ResName, string action, TreeNodeCollection TreeNodes, string Active)
    {
        string fileName = "ProcessRole-" + action, accessRgtXml = string.Empty, res = string.Empty;
        errorLog = logObj.CreateLog("Loading Structure.", sid, fileName, "new");
        accessRgtXml = "<root axpapp='" + proj + "' trace='" + errorLog + "' appsessionkey='" + Session["AppSessionKey"].ToString() + "' username='" + Session["username"].ToString() + "' action='" + action + "'  role='" + ResName + "' act='" + Active + "'  sessionid= '" + sid + "'>";

        if (action != "remove")
        {
            Boolean isTstructSel = false;
            Boolean isIviewSel = false;
            string formsXml = string.Empty;
            foreach (TreeNode Tn in TreeNodes)
            {
                string tnVal = string.Empty, tnPar = string.Empty, tnTxt = string.Empty;
                tnVal = Tn.Value;
                tnTxt = Tn.Text;

                if (Tn.Parent == null)
                    tnPar = "";
                else
                    tnPar = Tn.Parent.Value;

                tnTxt = CheckSpecialChars(tnTxt);
                if (Tn.Parent == null)
                {
                    accessRgtXml += "<" + tnVal + "  parent=''>" + tnTxt + "</" + tnVal + ">";
                }
                else
                {
                    accessRgtXml += "<" + tnVal + "  parent='" + tnPar + "'>" + tnTxt + "</" + tnVal + ">";

                    string tstTnVal = string.Empty;
                    if (tnVal.Contains("PageTs"))
                    {
                        tstTnVal = tnVal.Substring(6);
                        accessRgtXml += "<" + tstTnVal + " parent='Tstructs'>" + tnTxt + "</" + tstTnVal + ">";
                        isTstructSel = true;
                    }
                    else if (tnVal.Contains("PageIv"))
                    {
                        tstTnVal = tnVal.Substring(6);
                        accessRgtXml += "<" + tstTnVal + " parent='Iviews'>" + tnTxt + "</" + tstTnVal + ">";
                        isIviewSel = true;
                    }
                }

                if (tnVal != "" && Tn.NavigateUrl != "")
                {
                    string resXml = Session["ResTreeXml"].ToString();
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(resXml);
                    if (tnVal.Contains("PageTs") || tnVal.Contains("PageIv"))
                    {
                        tnVal = tnVal.Substring(6, tnVal.Length - 6);
                    }
                    else if (tnVal.Contains("Page"))
                    {
                        int urlIndx = Tn.NavigateUrl.IndexOf("(");
                        urlIndx += 1;
                        tnVal = Tn.NavigateUrl.Substring(urlIndx + 1, Tn.NavigateUrl.LastIndexOf("'") - urlIndx - 1);
                    }

                    XmlNodeList formNodes = xmlDoc.GetElementsByTagName(tnVal);
                    string caption = string.Empty;
                    if (formNodes.Count > 0)
                    {
                        if (formNodes[0].Attributes["cap"] != null)
                            caption = formNodes[0].Attributes["cap"].Value;
                        caption = CheckSpecialChars(caption);
                        formsXml += "<" + formNodes[0].Name + " parent='" + formNodes[0].ParentNode.Name + "'>" + caption + "</" + formNodes[0].Name + ">";
                        if (formNodes[0].ParentNode.Name == "Tstructs")
                            isTstructSel = true;
                        if (formNodes[0].ParentNode.Name == "Iviews")
                            isIviewSel = true;
                    }

                }
            }
            if (isTstructSel)
                accessRgtXml += "<Tstructs  parent=''>Tstructs</Tstructs>";
            if (isIviewSel)
                accessRgtXml += "<Iviews  parent=''>Iviews</Iviews>";
            accessRgtXml += formsXml;
            accessRgtXml += Session["axApps"].ToString() + Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
            if (TreeNodes.Count > 0)
            {
                //Call service
                res = objWebServiceExt.CallProcessRoleWS("Resp", accessRgtXml);
                if (res.Contains(Constants.ERROR) == true)
                {
                    res = util.ParseXmlErrorNode(res);
                    if (res == Constants.SESSIONERROR || res == Constants.SESSIONEXPMSG)
                    {
                        Session.RemoveAll();
                        Session.Abandon();
                        SessionExpired();
                        return;
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "showAlertDialog('warning','" + res + "');", true);
                    }
                }
                else
                {
                    if (action == "add")
                        ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "showAlertDialog('success','Responsibility added successfully.');bindResponsibilityGrid();clearResponsibility();", true);
                    else if (action == "update")
                        ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "showAlertDialog('success','Responsibility updated successfully.');bindResponsibilityGrid();", true);
                    else if (action == "copy")
                        ScriptManager.RegisterStartupScript(addEditRespUpdatePanel, typeof(UpdatePanel), "responsibilitymsg", "showAlertDialog('success','Responsibility copied successfully.');bindResponsibilityGrid();", true);

                    clearRolesKeysFromInmemoryDB(ResName);


                }
            }
        }
    }

    protected void clearRolesKeysFromInmemoryDB(string responsibility)
    {
        try
        {
            string sql = "select userroles from axusergroups where groupname  = '" + responsibility + "'";
            ASBCustom.CustomWebservice objCWbSer = new ASBCustom.CustomWebservice();
            string strv = objCWbSer.GetChoices("", sql);
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(strv);
            XmlNodeList xmlChild = xmlDoc.GetElementsByTagName("row");
            string tstructName = string.Empty, tstructCaption = string.Empty;
            ArrayList roles = new ArrayList();
            if (xmlChild.Count > 0)
            {
                for (int i = 0; i < xmlChild.Count; i++)
                    roles.Add(xmlChild[i].ChildNodes.Item(0).InnerText.Trim());
                if (roles.Count > 0)
                {
                    FDW fdwObj = FDW.Instance;
                    bool flresult = fdwObj.FlushRedisKeysByRoles(roles);
                }
            }

        }
        catch (Exception ex)
        {
            logObj.CreateLog("DeleteAllRedisKeysByRoles, Message:" + ex.Message, "", "RedisServer", "new");
        }
    }

    protected void btnTreeViewExpand_Click(object sender, EventArgs e)
    {
        treeEditRes.ExpandAll();
    }
}
