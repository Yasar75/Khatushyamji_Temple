#region NameSpaces

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
#endregion

#region TstructData Class
/// <summary>
/// TstructData class stores all the field related data like, field Name,value,oldvalue,componentname
/// rowno,frameno. Using this fieldvaluexml is constructed and stored in a string.
/// </summary>
[Serializable()]
public class TStructData
{
    #region Attributes
    /// <summary>
    /// Declaration of all attributes related to Tstruct Data Class
    /// </summary>   
    public ArrayList fieldIndexArray = new ArrayList();
    public ArrayList fieldName = new ArrayList();
    public ArrayList fieldFrameNo = new ArrayList();
    public ArrayList fieldControlName = new ArrayList();
    public ArrayList fieldRowNo = new ArrayList();
    public ArrayList fieldValue = new ArrayList();
    public ArrayList fieldOldValue = new ArrayList();
    public ArrayList fieldIdValue = new ArrayList();
    public ArrayList fieldOldIdValue = new ArrayList();
    public ArrayList dcRowCntVals = new ArrayList();
    public ArrayList fieldRowValues = new ArrayList();
    public ArrayList fldIdCol = new ArrayList();
    public ArrayList fldMasterRow = new ArrayList();
    public ArrayList fieldDPMVals = new ArrayList();
    public ArrayList fieldDPVals = new ArrayList();
    public ArrayList ChangedDcs = new ArrayList();
    public ArrayList DelRowFldsXml = new ArrayList();
    public ArrayList newRowNos = new ArrayList();
    public ArrayList oldRowNos = new ArrayList();
    // TODO: Get the attachment files from the client and update the attachment array in the object.
    public ArrayList attachArray = new ArrayList();
    public String fieldValueXml = string.Empty;
    private StringBuilder dsDataXML = new StringBuilder();
    public String fgFieldValueXml = string.Empty;
    public String popFGFieldValueXml = string.Empty;
    public String transactionID = string.Empty;
    public String recordID = string.Empty;
    private string jsonString = string.Empty;
    private string defaultDateStr = "dd/mm/yyyy";
    public ArrayList imageFldNames = new ArrayList();
    public ArrayList imageFldSrc = new ArrayList();
    ArrayList depFormatDcs = new ArrayList();
    public StringBuilder tabJson = new StringBuilder();
    public ArrayList AxMasterRowFlds = new ArrayList();
    public StringBuilder AxDepArrays = new StringBuilder();
    public string project = string.Empty;
    public string user = string.Empty;
    public string AxRole = string.Empty;
    public string sessionid = string.Empty;
    public string errlog = string.Empty;
    public string filename = string.Empty;
    public DataSet dsData;
    public string ires = string.Empty;
    public string serviceInputXml = string.Empty;
    public string result = string.Empty;
    public string axpert = "Axpert\\";
    public string transID = "";
    public string rid = string.Empty;
    private int deletedCount = -1;
    public bool IsDraftObj = false;
    public string AxActDepField = "";
    public string TabDcStatus = string.Empty;
    ArrayList AxSubGridRows = new ArrayList();
    ArrayList AxDelDcNo = new ArrayList();
    ArrayList AxDelRecIds = new ArrayList();
    ArrayList subWsRows = new ArrayList();
    ArrayList subDsRows = new ArrayList();
    public string AxActiveDc = string.Empty;
    public ArrayList removeFiles = new ArrayList();
    //Variables to store the memVars details 
    ArrayList memVarNames = new ArrayList();
    ArrayList memVarValues = new ArrayList();
    ArrayList memVarTypes = new ArrayList();
    public string memVarsData = string.Empty;
    bool hasMemVars = false;
    public string strServerTime = string.Empty;
    public double webTime1;
    public double webTime2;
    public double asbTime;
    //public DateTime asbTime2;
    public bool logTimeTaken = false;
    public bool hasImagePath = false;
    string scriptsPath = HttpContext.Current.Application["ScriptsPath"].ToString();

    public string attachDirPath = "";
    public string imgAttachPath = "";

    public string AxActiveAction = string.Empty;
    List<string> deletedRowCount = new List<string>();
    bool isDeletedRow = false;
    public ArrayList AxGridAttNotExistList = new ArrayList();
    public string strExecTrace = string.Empty;
    [NonSerialized]
    public ASBExt.WebServiceExt objWebServiceExt = new ASBExt.WebServiceExt();

    LogFile.Log logobj = new LogFile.Log();
    Util.Util util = new Util.Util();
    CacheMgr.CacheManager cm = new CacheMgr.CacheManager("");
    Boolean isDebugFileCreated = false;
    public TStructDef tstStrObj;
    public bool attachDir = false;
    public Dictionary<string, string> fastDDL = new Dictionary<string, string>();

    int DeleteRowTopNo = 0;
    #endregion

    #region Attributes with get,set properties.
    /// <summary>
    /// Attributes with get, set properties.
    /// </summary>
    public ArrayList fldNames
    {
        get { return fieldName; }
        set { fieldName = value; }
    }

    public ArrayList fldFrameNos
    {
        get { return fieldFrameNo; }
        set { fieldFrameNo = value; }
    }

    public ArrayList fldControlNames
    {
        get { return fieldControlName; }
        set { fieldControlName = value; }
    }

    public ArrayList fldRowNos
    {
        get { return fieldRowNo; }
        set { fieldRowNo = value; }
    }

    public ArrayList fldValues
    {
        get { return fieldValue; }
        set { fieldValue = value; }
    }

    public ArrayList fldOldValues
    {
        get { return fieldOldValue; }
        set { fieldOldValue = value; }
    }

    public ArrayList fldIdValues
    {
        get { return fieldIdValue; }
        set { fieldIdValue = value; }
    }

    public ArrayList fldOldIdValues
    {
        get { return fieldOldIdValue; }
        set { fieldOldIdValue = value; }
    }

    public ArrayList attachments
    {
        get { return attachArray; }
        set { attachArray = value; }
    }

    public String fldValueXml
    {
        get { return fieldValueXml; }
        set { fieldValueXml = value; }
    }

    public String fgFldValueXml
    {
        get { return fgFieldValueXml; }
        set { fgFieldValueXml = value; }
    }

    public String transid
    {
        get { return transactionID; }
        set { transactionID = value; }
    }

    public String recordid
    {
        get { return recordID; }
        set { recordID = value; }
    }

    public string newJson
    {
        get { return jsonString; }
        set { jsonString = value; }
    }
    public DataSet dsDataSet
    {
        get { return dsData; }
        set { dsData = value; }
    }

    public bool isSaveCalled = false;
    public bool isAxpImagePath = false;
    #endregion

    #region Constructor which parses the jsonData.
    /// <summary>
    /// Constructor which gets the JsonData from the service and updates all the field related information
    /// to the array list by parsing through json data.
    /// </summary>
    /// <param name="jsonData"></param>
    public TStructData(string jsonData, string transId, string recId, TStructDef strObj)
    {
        if (HttpContext.Current.Session["AxLogging"] != null)
        {
            if (Convert.ToString(HttpContext.Current.Session["AxLogging"]).ToLower() == "true")
                logTimeTaken = true;
        }

        tstStrObj = strObj;
        CreateDataSets(strObj);

        this.rid = recId;
        transID = transId;

        if (HttpContext.Current.Session["AxAttachFilePath"] != null)
            attachDirPath = HttpContext.Current.Session["AxAttachFilePath"].ToString();

        if (HttpContext.Current.Session["AxpAttachmentPathGbl"] != null)
            attachDirPath = HttpContext.Current.Session["AxpAttachmentPathGbl"].ToString();

        if (attachDirPath != string.Empty)
            attachDir = true;


        if (HttpContext.Current.Session["AxImagePath"] != null && HttpContext.Current.Session["AxImagePath"].ToString() != "")
        {
            imgAttachPath = HttpContext.Current.Session["AxImagePath"].ToString();
            //CommonDir directory creation taken back due to application server memory usage.
            //if (!imgAttachPath.Contains(":\\") && !imgAttachPath.StartsWith("\\"))
            //{
            //    CreateDirectoryInCommonDir(ref imgAttachPath);
            //}
        }
        if (HttpContext.Current.Session["AxpImagePathGbl"] != null && HttpContext.Current.Session["AxpImagePathGbl"].ToString() != "")
        {
            imgAttachPath = HttpContext.Current.Session["AxpImagePathGbl"].ToString();
            imgAttachPath = imgAttachPath.Replace(";bkslh", "\\");
        }
        if (HttpContext.Current.Session["AxpSaveImageDb"] != null && HttpContext.Current.Session["AxpSaveImageDb"].ToString() == "true")
            imgAttachPath = "";

        ArrayList imageFlds = new ArrayList();
        ArrayList imageSrc = new ArrayList();
        GetGlobalVars();


        jsonData = jsonData.Replace("*$*", "♦");
        jsonData = jsonData.Replace("\\", ";bkslh");
        string[] resval = jsonData.Split('♦');
        StringBuilder dataJson = new StringBuilder();

        for (int j = 0; j < resval.Length; j++)
        {
            //TODO: all other json nodes should be handled in the json parsing
            JArray Data = null;
            try
            {
                if (resval[j] != "")
                {
                    JObject tstData = JObject.Parse(resval[j]);
                    Data = (JArray)tstData["data"];
                    jsonString = @"{""data"":[";
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog("JsonToArray function - " + ex.Message, sessionid, "Exception-" + transid, "new");
                logobj.CreateLog("JsonData - " + jsonData, sessionid, "Exception-" + transid, "");

                //throw ex;
            }


            if (Data != null)
            {
                string fName = string.Empty;
                string fValue = string.Empty;
                string delRows = string.Empty;
                string rowNo = string.Empty;
                string fDatatype = string.Empty;
                string name = string.Empty;
                string fldName = string.Empty;
                string fldFrameNo = string.Empty;
                string frmNum = string.Empty;
                string frowValues = string.Empty;
                string fldIdValues = string.Empty;
                string idCol = string.Empty;
                string masterRow = string.Empty;
                string comboVal = string.Empty;
                string comboIdCol = string.Empty;
                string dcNo = "0";
                string dpmValue = string.Empty;
                string dpValue = string.Empty;
                string idVal = string.Empty;
                string oldIdVal = string.Empty;
                StringBuilder ddlVals = new StringBuilder();
                StringBuilder ddlDpVals = new StringBuilder();
                //TODO: Create a single function for parsing the json result- The same code is used in JsonToArray
                for (int m = 0; m < Data.Count; m++)
                {
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(Data[m].ToString());

                    fDatatype = "";
                    delRows = "";
                    masterRow = string.Empty;
                    dpmValue = string.Empty;
                    dpValue = string.Empty;
                    string dcHasRows = string.Empty;

                    if (values.ContainsKey("t"))
                        fDatatype = values["t"];
                    if (values.ContainsKey("n"))
                        fName = values["n"];
                    if (values.ContainsKey("v"))
                        fValue = values["v"];
                    if (values.ContainsKey("cr"))
                        delRows = values["cr"];
                    if (values.ContainsKey("mr"))
                        masterRow = values["mr"];
                    if (values.ContainsKey("idcol"))
                        idCol = values["idcol"];
                    if (values.ContainsKey("id"))
                        idVal = values["id"];
                    if (values.ContainsKey("oldid"))
                        oldIdVal = values["oldid"];
                    if (values.ContainsKey("dpm"))
                        dpmValue = values["dpm"];
                    if (values.ContainsKey("dp"))
                        dpValue = values["dp"];
                    if (values.ContainsKey("r"))
                    {
                        rowNo = values["r"];
                        if (rowNo.Length == 1)
                            rowNo = "00" + rowNo;
                        else if (rowNo.Length == 2)
                            rowNo = "0" + rowNo;
                    }



                    string rowValues = string.Empty;

                    if (fName != string.Empty)
                    {
                        fValue = fValue.Replace("^^dq", "\"");
                        fValue = fValue.Replace(";bkslh", "\\");

                        if (fName == "axp_recid1" && fValue != "0" && fValue != "" && recId == "0")
                            recId = fValue;

                        if (fName.ToLower() == Constants.AXPATTACHMENTPATH && fValue.Trim() != String.Empty)
                        {
                            attachDirPath = fValue;
                            attachDir = true;
                        }

                        ////TODO: The same code is there in the UpdateDataList, and Jsontoarray
                        //if (fName.ToLower() == "axpcurrencydec")
                        //   CheckAxpCurrDec(fName, fValue);

                        string rowVal = "";
                        if (fDatatype == "i")
                        {
                            //On loading the data, if there is a image field whose image is stored in folders, 
                            //Add it to the array to call the MoveImage function to move it to the scripts folder.
                            string fldId = string.Empty;
                            fldId = fName + rowNo + "F" + dcNo;
                            if (fName.StartsWith(Constants.IMGPrefix))
                            {
                                imageFlds.Add(fldId);
                                fValue = string.Empty;
                            }
                            else if (fName.StartsWith(Constants.IMGSRCPrefix))
                            {
                                imageSrc.Add(fValue);
                            }
                        }
                        else if (fDatatype == "c")
                        {
                            comboVal = fValue;
                        }
                        else if (fDatatype == "dv")
                        {
                            rowVal = fValue;
                            if (rowValues == "")
                                rowValues = rowVal;
                            else
                                rowValues += "" + rowVal;

                            string[] temp = rowVal.Split('?');
                            if (temp.Length <= 3 && comboVal == string.Empty && temp.Length > 1)
                            {
                                StringBuilder strVal = new StringBuilder();
                                for (int i = 0; i < temp.Length; i++)
                                {
                                    if (temp[i].ToString() != string.Empty)
                                        strVal.Append(temp[i].ToString());
                                }
                                if (strVal.ToString().ToLower() == "yesno" || strVal.ToString().ToLower() == "noyes")
                                {
                                    //To set the default value of checkbox in the grid dc to "no".
                                    fValue = "no";
                                }
                            }
                        }
                        else if (fDatatype == "dc")
                        {
                            string dcRowCount = fName + "~" + fValue;
                            dcNo = fName.Substring(2);

                            if (values.ContainsKey("hasdatarows"))
                                dcHasRows = values["hasdatarows"];

                            bool isGrid = IsDcGrid(dcNo, strObj);

                            if (isGrid)
                            {
                                if (dcHasRows != "")
                                {
                                    TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[Convert.ToInt32(dcNo) - 1];
                                    if (dcHasRows == "yes")
                                        dc.DCHasDataRows = true;
                                    else
                                        dc.DCHasDataRows = false;
                                    strObj.dcs[Convert.ToInt32(dcNo) - 1] = dc;
                                }

                                //This condition is added to maintain the field array for all the dc fields. 
                                //In case of index calculation if some dc's fields are not there then it throws error.
                                if (fValue == "0" && delRows == "")
                                {
                                    fValue = "1";
                                    delRows = "i1";
                                    dcRowCount = fName + "~" + fValue;
                                }
                            }
                            UpdateRowCount(fName, dcRowCount);
                        }


                        if (idCol == "no" || idCol == "")
                            idCol = "0";
                        else
                            idCol = "1";

                        if (fDatatype == "c")
                            comboIdCol = idCol;

                        if (fDatatype == "dv")
                        {
                            ddlVals.Append(rowValues);
                            ddlVals.Append("♣");
                            ddlDpVals.Append(dpValue);
                            ddlDpVals.Append("♣");
                            DSUpdateRowValues(fName, Convert.ToInt32(rowNo), ddlVals.ToString(), ddlDpVals.ToString(), masterRow, comboIdCol);
                        }
                        else
                        {
                            ddlVals = new StringBuilder();
                            if (fDatatype != "dc")
                            {
                                string rowFrmNo = string.Empty;
                                if (rowNo != "")
                                {
                                    name = fName + rowNo + "F" + dcNo;
                                    rowFrmNo = rowFrmNo + "F" + dcNo;
                                    DSSubmitWithOld(fName, Convert.ToInt32(rowNo), fValue, idVal, oldIdVal);
                                }
                            }
                        }
                    }
                }
                CreateFieldValueXml("ALL", "", "LoadData");
            }
        }
        //Loop through the image fields and load the images in the scripts folder
        for (int i = 0; i < strObj.AxImageFields.Count; i++)
        {
            if (imageSrc.Count != 0 && imageSrc.Count >= i)
            {
                if (imageSrc[i].ToString() != "")
                {
                    string[] fvalues = imageSrc[i].ToString().Split('~');
                    string recordId = fvalues[2].ToString();

                    LoadImageToFolder(strObj.AxImageFields[i].ToString(), recordId);
                }
            }
            else if (recId != "0" && recId != "")
            {
                LoadImageToFolder(strObj.AxImageFields[i].ToString(), recId);
            }
        }

        //Load the grid attachments in the folder
        if ((recId != "0" && recId != "" && tstStrObj.ContainsGridAttach) || (recId == "0" && tstStrObj.ContainsGridRefer))
        {
            GetGlobalAttachPath();
            LoadGridAttsToFolder(recId, transID);
        }

        //Call the function which parses thge memvar node and updates the arrays.
        ParseMemVarNode(jsonData, "LoadData");
    }


    #endregion

    #region Methods

    #region Public Methods
    /// <summary>
    /// This method is invoked by end user to update the list with new fieldnames and fieldvalues.
    /// This method inturn calls other methods for updating the list and construct the new field value xml.
    /// Here there is a assumption that fldArray and fldValueArray are consistent, means both has same number
    /// of rows and maintain the index.
    /// </summary>
    /// <param name="fldArray">
    /// fldArray consists the updated/new component names.
    /// </param>
    /// <param name="fldValueArray">
    /// fldValueArray consists the updated/new component values.
    /// </param>
    /// <param name="deletedArray">
    /// deletedArray is specific to grid fields , it consists the row no. which is deleted and frame no. 
    /// the particular dc no. from where the row is deleted.
    /// </param>
    public void GetFieldValueXml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList deletedArray, string frameNo, string calledFrom, string condition, string includeDcs)
    {
        //first update the list with the new fldArray.
        UpdateDataList(fldArray, fldDbRowNo, fldValueArray, deletedArray);
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
        if (deletedRowCount.Count > 0)
        {
            deleteRowOnSave();
        }
        //Create the xml from the updated list.
        CreateFieldValueXml(condition, includeDcs, calledFrom);
    }

    public void GetPerfFieldValueXml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList deletedArray, string frameNo, string calledFrom, string condition, string includeDcs)
    {
        //first update the list with the new fldArray.
        UpdateDataList(fldArray, fldDbRowNo, fldValueArray, deletedArray);
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);

    }


    /// <summary>
    /// This method is invoked by end user to update the list with new fieldnames and fieldvalues.
    /// This method inturn calls other methods for updating the list and construct the new field value xml.
    /// Here there is a assumption that fldArray and fldValueArray are consistent, means both has same number
    /// of rows and maintain the index.
    /// </summary>
    /// <param name="fldArray">
    /// fldArray consists the updated/new component names.
    /// </param>
    /// <param name="fldValueArray">
    /// fldValueArray consists the updated/new component values.
    /// </param>
    /// <param name="deletedArray">
    /// deletedArray is specific to grid fields , it consists the row no. which is deleted and frame no. 
    /// the particular dc no. from where the row is deleted.
    /// </param>
    public void GetPopFieldValueXml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList deletedArray, string frameNo, string parDcNo, int parRowNo, string popDcNo, int popRowNo)
    {
        //first update the list with the new fldArray.
        UpdateDataList(fldArray, fldDbRowNo, fldValueArray, deletedArray);
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);

        // Create the xml from the updated list.
        CreateFieldValueXml("-1", parDcNo, parRowNo, popDcNo, popRowNo);
    }


    public void UpdateAttachments(string attachFiles)
    {
        string[] attach = attachFiles.Split(',');

        for (int j = 0; j < attach.Length; j++)
            attachArray.Add(attach[j].ToString());
    }

    private string GetDelRowDataIndex(string axpRecId)
    {
        string delXml = string.Empty;
        for (int j = 0; j < DelRowFldsXml.Count; j++)
        {
            string[] strDelData = DelRowFldsXml[j].ToString().Split('♦');
            if (strDelData[0].ToString() == axpRecId)
            {
                delXml = strDelData[1].ToString();
                break;
            }
        }
        return delXml;
    }

    /// <summary>
    /// Function to get the deleted row info from the server side deleted rows.
    /// </summary>
    /// <param name="delRows"></param>
    /// <returns></returns>
    private string GetDelRowsInServer(string delRows)
    {
        StringBuilder strDelDcData = new StringBuilder();
        //the delrows will be in the below format 
        //dc1-recid1,recid2~dc2-recid1,recid2
        if (delRows != string.Empty)
        {
            string[] delRowStr = delRows.Split('~');
            for (int i = 0; i < delRowStr.Length; i++)
            {
                string[] dcStr = delRowStr[i].ToString().Split('-');
                string recIds = string.Empty;
                bool found = false;
                for (int j = AxDelDcNo.Count - 1; j >= 0; j--)
                {
                    if (AxDelDcNo[j].ToString() == dcStr[0])
                    {
                        found = true;
                        recIds = AxDelRecIds[j].ToString();
                        AxDelDcNo.RemoveAt(j);
                        AxDelRecIds.RemoveAt(j);
                        break;
                    }
                }

                if (strDelDcData.ToString() != "")
                    strDelDcData.Append("~");

                if (found)
                    strDelDcData.Append(dcStr[0] + "-" + dcStr[1] + "," + recIds);
                else
                    strDelDcData.Append(dcStr[0] + "-" + dcStr[1]);
            }
        }

        for (int k = 0; k < AxDelDcNo.Count; k++)
        {
            if (strDelDcData.ToString() != "")
                strDelDcData.Append("~");
            strDelDcData.Append(AxDelDcNo[k] + "-" + AxDelRecIds[k]);
        }

        return strDelDcData.ToString();
    }

    public string GetDelRowsNode(string delRows)
    {
        //delrow format will be dcno~recid1,recid2-dcno~recid1,recid2..
        StringBuilder strRows = new StringBuilder();
        //hook to add deleted rows info from server side
        delRows = GetDelRowsInServer(delRows);

        string[] delRowStr = delRows.Split('~');

        if (delRows != "")
        {
            strRows.Append("<delrows>");
            for (int i = 0; i < delRowStr.Length; i++)
            {
                string[] dcStr = delRowStr[i].ToString().Split('-');
                strRows.Append("<" + dcStr[0].ToString() + ">");
                string[] strRecIds = dcStr[1].ToString().Split(',');
                for (int j = 0; j < strRecIds.Length; j++)
                {
                    string axp_recId = strRecIds[j].ToString();
                    string delXml = GetDelRowDataIndex(axp_recId);

                    if (delXml != "")
                        strRows.Append(delXml);
                }

                strRows.Append("</" + dcStr[0].ToString() + ">");
            }
            strRows.Append("</delrows>");
        }
        return strRows.ToString();
    }

    private string GetChangedRows(string changedRows)
    {
        StringBuilder strRows = new StringBuilder();

        string[] chngRowStr = changedRows.Split('~');
        if (changedRows != "")
        {
            strRows.Append("<changedrows>");
            for (int i = 0; i < chngRowStr.Length; i++)
            {
                string[] dcStr = chngRowStr[i].ToString().Split('-');

                strRows.Append("<" + dcStr[0].ToString() + ">");
                strRows.Append(dcStr[1].ToString());
                strRows.Append("</" + dcStr[0].ToString() + ">");
            }
            strRows.Append("</changedrows>");
        }
        else if (recordID == "0")
            strRows.Append("<changedrows>*</changedrows>");
        return strRows.ToString();
    }

    private string GetAttachTransid()
    {
        string tidValue = string.Empty;
        int idx = tstStrObj.GetFieldIndex("axp_attachtransid");
        if (idx != -1)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
            tidValue = GetFieldValue(fld.fldframeno.ToString(), fld.name);
        }
        else
        {
            tidValue = tstStrObj.transId;
        }
        return tidValue;
    }



    //save attached file into local
    public void SaveAttached(string files, string RecordId)
    {
        //CommonDir directory creation taken back due to application server memory usage.
        //if (!attachDirPath.Contains(":\\") && !attachDirPath.StartsWith("\\"))
        //{
        //    CreateDirectoryInCommonDir(ref attachDirPath);
        //}

        DirectoryInfo srcDir = new DirectoryInfo(scriptsPath + "Axpert\\" + sessionid);
        string tidValue = string.Empty;
        //string schemaName = project;
        tidValue = GetAttachTransid();

        DirectoryInfo desDir = new DirectoryInfo(attachDirPath + "\\" + tidValue + "\\");
        if (files != string.Empty)
        {
            string[] fnames = files.Split(',');
            string[] sFileName = new string[fnames.Length];
            for (int i = 0; i < fnames.Length; i++)
                sFileName[i] = Directory.GetFiles(scriptsPath + "Axpert\\" + sessionid, fnames[i])[0];

            string sFileDir = scriptsPath + "Axpert\\" + sessionid;
            string desPath = attachDirPath + "\\" + tidValue + "\\";
            try
            {
                //Save File on disk
                if (!desDir.Exists)
                    desDir.Create();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            string authenticationStatus = string.Empty;
            if (util.GetAuthentication(ref authenticationStatus))
            {
                foreach (var file in sFileName)
                    File.Copy(file, Path.Combine(desPath, RecordId + "-" + Path.GetFileName(file)), true);
            }
        }
        //Delete the files from folder
        if (removeFiles.Count > 0 && desDir.Exists)
        {
            for (int i = 0; i < removeFiles.Count; i++)
            {
                try
                {
                    foreach (FileInfo fi in desDir.GetFiles(removeFiles[i].ToString().Replace("%20", " ")))
                        fi.Delete();
                }
                catch { }
            }
        }
    }

    protected void RemoveUnwantedAxpFiles(string transid, string recId, string delRows, TStructData tstData, ArrayList deletedFldArrayValues)
    {
        try
        {
            GetGlobalAttachPath();
            ArrayList lstAttFileServer = new ArrayList();
            if (HttpContext.Current.Session["AxpAttFileServer"] != null)
                lstAttFileServer = (ArrayList)HttpContext.Current.Session["AxpAttFileServer"];

            foreach (var axpFlds in tstStrObj.AxpFileUploadFields)
            {
                if (!axpFlds.ToString().ToLower().StartsWith("axpfilepath_"))
                {
                    int idx = tstStrObj.GetFieldIndex(axpFlds.ToString());
                    TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
                    int axpFldDcNo = fld.fldframeno;
                    DataTable oldDcTable = dsDataSet.Tables["deldc" + axpFldDcNo];
                    if (oldDcTable != null && oldDcTable.Rows.Count > 0)
                        RemoveDeletedRowAxpFiles(oldDcTable, axpFlds.ToString());

                    var axpFld = lstAttFileServer.Cast<string>().Where(i => i.StartsWith(axpFlds + "~")).ToArray();
                    if (axpFld.Count() == 0)
                        continue;
                    else
                    {
                        // Need to remove saved files from list.     
                        DataTable dcTable = dsDataSet.Tables["dc" + axpFldDcNo];
                        DataView dv = new DataView(dcTable);
                        dv.Sort = "axp__rowno ASC";
                        dcTable = dv.ToTable();
                        string axpGrAttPath = string.Empty;
                        for (int j = 0; j < dcTable.Rows.Count; j++)
                        {
                            string axpValues = string.Empty;
                            axpValues = dcTable.Rows[j][axpFlds.ToString()].ToString();
                            foreach (var existFiles in axpValues.Split(','))
                            {
                                var removeValue = lstAttFileServer.Cast<string>().Where(i => i.StartsWith(axpFlds + "~") && i.EndsWith(existFiles)).ToArray();
                                if (removeValue.Count() > 0)
                                    lstAttFileServer.Remove(removeValue[0]);
                            }
                        }
                    }
                }
            }
            if (deletedFldArrayValues.Count > 0)
            {
                foreach (var delFile in deletedFldArrayValues)
                {
                    string[] dltfnameval = delFile.ToString().Split('~');
                    string dlFName = dltfnameval[0].Substring(0, dltfnameval[0].LastIndexOf("F") - 3);
                    string dlRow = dltfnameval[0].Substring(dltfnameval[0].LastIndexOf("F") - 3, 3);
                    var dlFullname = lstAttFileServer.Cast<string>().Where(i => i.StartsWith(dlFName + "~") && i.EndsWith(dltfnameval[1])).ToArray();
                    // TO delete file from folder and remove from list which are deleted before save the transaction
                    if (dlFullname.Count() > 0)
                    {
                        lstAttFileServer.Remove(dlFullname[0]);
                        string dlFullPath = dlFullname[0].Replace(dlFName + "~", "");
                        RemoveDeletedAxpFileFromFolder(dlFullPath);
                    }
                    else
                    {
                        // To delete file from folder after load transaction and delete files                        
                        var axpfilepath_ = tstStrObj.AxpFileUploadFields.Cast<string>().Where(i => i.ToLower().StartsWith("axpfilepath") && i.EndsWith("_" + dlFName.ToString().Substring(8))).ToArray();
                        int idx = tstStrObj.GetFieldIndex(dlFName.ToString());
                        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
                        int axpFldDcNo = fld.fldframeno;
                        DataTable dcTable = dsDataSet.Tables["dc" + axpFldDcNo];
                        bool isDcGrid = false;
                        isDcGrid = IsDcGrid(axpFldDcNo.ToString(), tstStrObj);
                        int rNo = 0;
                        if (isDcGrid)
                            rNo = int.Parse(dlRow) - 1;
                        else
                            rNo = int.Parse(dlRow);
                        string axpFPath = string.Empty;
                        if (dcTable.Rows.Count > 0)
                            axpFPath = dcTable.Rows[rNo][axpfilepath_[0]].ToString();
                        if (axpFPath == string.Empty)
                            axpFPath = HttpContext.Current.Session["grdAttPath"].ToString();
                        if (axpFPath.EndsWith("*"))
                        {
                            string axpFilePath = axpFPath.Substring(0, axpFPath.LastIndexOf('\\')) + "\\";
                            string PrefixFilename = axpFPath.Substring(axpFPath.LastIndexOf("\\") + 1).Replace("*", "");
                            string axpFileName = dltfnameval[1];
                            if (PrefixFilename != string.Empty)
                                axpFileName = PrefixFilename + axpFileName;
                            RemoveDeletedAxpFileFromFolder(axpFilePath + axpFileName);
                        }
                        else
                            RemoveDeletedAxpFileFromFolder(axpFPath + dltfnameval[1]);
                    }
                }
            }
            if (lstAttFileServer.Count > 0)
                HttpContext.Current.Session["AxpAttFileServer"] = lstAttFileServer;
            else
                HttpContext.Current.Session["AxpAttFileServer"] = null;
        }
        catch (Exception ex)
        {
            logobj.CreateLog("Error while deleting-" + ex.Message, sessionid, "RemoveUnwantedAxpFiles", "new");
        }
    }

    protected void RemoveDeletedRowAxpFiles(DataTable oldDcTable, string axpFld)
    {
        try
        {
            var axpfilepath_ = tstStrObj.AxpFileUploadFields.Cast<string>().Where(i => i.ToLower().StartsWith("axpfilepath") && i.EndsWith("_" + axpFld.ToString().Substring(8))).ToArray();
            string axpFPath = string.Empty;
            string axpValues = string.Empty;
            for (int j = 0; j < oldDcTable.Rows.Count; j++)
            {
                axpFPath = oldDcTable.Rows[j][axpfilepath_[0]].ToString();
                axpValues = oldDcTable.Rows[j][axpFld].ToString();
                if (axpFPath == string.Empty)
                    axpFPath = HttpContext.Current.Session["grdAttPath"].ToString();
                foreach (var existFiles in axpValues.Split(','))
                {
                    if (axpFPath.EndsWith("*"))
                    {
                        string axpFilePath = axpFPath.Substring(0, axpFPath.LastIndexOf('\\')) + "\\";
                        string PrefixFilename = axpFPath.Substring(axpFPath.LastIndexOf("\\") + 1).Replace("*", "");
                        string existFile = existFiles;
                        if (PrefixFilename != string.Empty)
                            existFile = PrefixFilename + existFiles;
                        RemoveDeletedAxpFileFromFolder(axpFilePath + existFile);
                    }
                    else
                        RemoveDeletedAxpFileFromFolder(axpFPath + existFiles);
                }
            }
        }
        catch (Exception ex)
        {
            logobj.CreateLog("Error while deleting OldFiles-" + ex.Message, sessionid, "RemoveDeletedRowAxpFiles", "new");
        }
    }

    protected void RemoveDeletedAxpFileFromFolder(string fullPath)
    {
        try
        {
            File.Delete(fullPath);
        }
        catch (Exception ex)
        {
            logobj.CreateLog("Error while RemoveDeletedAxpFileFromFolder-" + ex.Message, sessionid, "RemoveDeletedAxpFileFromFolder", "new");
        }
    }


    public string CallSaveDataWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList deletedFldArrayValues, string files, string rid, string delRows, string changedRows, string axRulesFlds)
    {

        DateTime stTime = DateTime.Now;
        string successMsg = string.Empty;
        string gridAttSaveResult = string.Empty;
        string AxRelKeys = string.Empty;
        bool holdpopup = false;
        if (!string.IsNullOrEmpty(files))
            UpdateAttachments(files);
        string filesCpy = files;
        if (attachDir)
            files = "";


        string cngRows = GetChangedRows(changedRows);

        transid = tstData.transid.ToString();
        filename = "save-" + transid;
        errlog = logobj.CreateLog("Saving Data", sessionid, filename, "new");
        string imagefromdb = "false";
        if (HttpContext.Current.Session["AxpSaveImageDb"] != null)
            imagefromdb = HttpContext.Current.Session["AxpSaveImageDb"].ToString();
        serviceInputXml = "<Transaction axpapp=\"" + project + "\" imagefromdb=\"" + imagefromdb + "\" afiles=\"" + files + "\" trace=\"" + errlog + "\" sessionid=\"" + sessionid + "\" appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'><data  transid=\"" + transid + "\"  recordid=\"" + rid + "\"> ";
        result = string.Empty;
        logobj.CreateLog("Cross checking field value xml length sent from client and received xml length", sessionid, filename, "");
        //call  a function to delete the default row in pop grid
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
        isSaveCalled = true;
        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "true", "ALL", "");
        delRows = GetDelRowsNode(delRows);
        isSaveCalled = false;
        if (tstData.fldValueXml.Contains("docid"))
        {
            holdpopup = true;
        }

        serviceInputXml += tstData.fldValueXml + memVarsData + "</data>";
        serviceInputXml += delRows + cngRows;
        if (axRulesFlds != "")
        {
            serviceInputXml += GetAxRuleFlsXML(axRulesFlds, transid);
        }
        string AxErroCodeNode = string.Empty;
        AxErroCodeNode = util.GetAxvalErrorcode(transid);

        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);

        serviceInputXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + AxErroCodeNode + HttpContext.Current.Session["axUserVars"].ToString();
        serviceInputXml += "</Transaction>";
        logobj.CreateLog("Call to SaveData Web Service", sessionid, filename, "");
        ires = tstStrObj.structRes;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        DateTime asStart = DateTime.Now;
        result = objWebServiceExt.CallSaveDataWS(transid, serviceInputXml, ires);
        string requestProcess_logtime = result.Split('♠')[0];
        result = result.Split('♠')[1];
        DateTime asEnd = DateTime.Now;
        logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, "");

        //{"message":[{"msg":"Master Saved,recordid=20054000000070"}]}
        result = result.Replace("\\", ";bkslh");
        //To save the image fields in server folders, 
        //the below code checks if the record is saved and copies the images to the folders.
        if (result.ToLower().Contains("ora-"))
        {
            result = result.Replace("ora-", "");
            result = result.Replace("ORA-", "");
        }
        if (!result.StartsWith(Constants.ERROR))
        {
            string returnStr = result.Replace("*$*", "¿");
            string[] newResult = returnStr.Split('¿');
            for (int i = 0; i < newResult.Length; i++)
            {
                JArray msg, rslt;
                try
                {
                    JObject message = JObject.Parse(newResult[i].ToString());
                    msg = (JArray)message["message"];
                    rslt = (JArray)message["result"];
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                if (rslt != null)
                {
                    string saveStatus = rslt[0].SelectToken("save").ToString();
                    if (saveStatus == "success" && util.isRealTimeCacEnabled(transid, tstStrObj))
                        AxRelKeys = util.GetAxRelations(tstData.transid);
                    if (saveStatus == "success" && transID == "axstc")
                    {
                        DataTable dt = tstData.dsDataSet.Tables["dc1"];
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            string props = dt.Rows[0]["PROPS"].ToString();
                            if (props.ToLower() == "general")
                                util.ClearAxpStructConfigInRedis(Constants.AXCONFIGGENERAL, transID, GetFieldValue("1", "userroles"), "general", "");
                            else
                            {
                                string stype = dt.Rows[0]["STYPE"].ToString();
                                string sname = dt.Rows[0]["STRUCTNAME"].ToString();
                                if (stype == "Tstruct")
                                    util.ClearAxpStructConfigInRedis(Constants.AXCONFIGTSTRUCT, transID, GetFieldValue("1", "userroles"), "tstruct", sname);
                                if (stype == "Iview")
                                {
                                    util.ClearAxpStructConfigInRedis(Constants.AXCONFIGTSTRUCT, transID, GetFieldValue("1", "userroles"), "iview", sname);
                                }
                            }
                        }
                    }
                }

                if (msg != null)
                {
                    string saveResult = msg[0].SelectToken("msg").ToString();

                    if (saveResult.IndexOf(',') != -1)
                    {
                        string recId = "";
                        string[] resultData = saveResult.Split(',');
                        if (resultData.Length > 1)
                        {
                            successMsg = resultData[0];
                            if (resultData[resultData.Length - 1].ToString().IndexOf("=") != -1 && resultData[resultData.Length - 1].ToString().IndexOf("recordid") != -1)
                            {
                                string[] recordDts = resultData[resultData.Length - 1].ToString().Split('=');
                                recId = recordDts[1].ToString();
                            }
                            else if (resultData[resultData.Length - 1].ToString().IndexOf("=") == -1 && Array.FindIndex(resultData, x => x.Trim().Contains("recordid=")) > -1)
                            {
                                int recIdx = Array.FindIndex(resultData, x => x.Contains("recordid"));
                                if (resultData[recIdx].ToString().Contains("="))
                                {
                                    string[] recordDts = resultData[recIdx].ToString().Split('=');
                                    recId = recordDts[1].ToString();
                                }
                            }
                            else
                            {
                                continue;
                            }
                        }

                        if (recId != string.Empty)
                        {
                            ClearIviewDataKey();
                            if (tstStrObj.AxpFileUploadFields.Count > 0)
                                RemoveUnwantedAxpFiles(transid, recId, delRows, tstData, deletedFldArrayValues);

                            if (tstStrObj.ContainsGridAttach)
                            {
                                strExecTrace = string.Empty;
                                try
                                {
                                    gridAttSaveResult = SaveGridAttachments(transid, sessionid, recId, delRows, tstData, changedRows, deletedFldArrayValues);
                                    requestProcess_logtime += strExecTrace + " ♦ ";
                                }
                                catch (Exception ex)
                                {
                                    if (strExecTrace != string.Empty)
                                        requestProcess_logtime += strExecTrace + " ♦ ";
                                    requestProcess_logtime += "Exception in SaveGridAttachments:" + ex.Message + " ♦ ";
                                    logobj.CreateLog("Error while SaveGridAttachments-" + ex.Message, sessionid, "SaveGridAttachments", "new", "true");
                                }
                            }

                            if (tstStrObj.ContainsImage)
                            {
                                string authenticationStatus = string.Empty;
                                bool isAuthenticated = util.GetAuthentication(ref authenticationStatus);
                                SaveImageToFolder(tstStrObj, transid, sessionid, recId, deletedFldArrayValues);
                            }
                            //Save the attach file  into the dir
                            if (attachDir && (!string.IsNullOrEmpty(filesCpy) || removeFiles.Count > 0))
                                SaveAttached(filesCpy, recId);
                            try
                            {
                                Custom custObj = Custom.Instance;
                                custObj.AxAfterAttSave(transid, sessionid, recId);
                            }
                            catch (Exception ex)
                            {

                            }
                            RefFastDataOnSave("save");
                            RefInMemOnSave();
                        }
                    }
                }
            }
            if (transid == "axrlr")//Delete tstruct cached keys for particular form On Save of AxRules
            {
                try
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(serviceInputXml);
                    XmlNode stIdNode = xmlDoc.SelectSingleNode("//Transaction/data/stransid");
                    if (stIdNode != null && stIdNode.InnerText != "")
                    {
                        FDW fdwObj = FDW.Instance;
                        FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                        if (fObj == null)
                            fObj = new FDR();
                        string fdData = Constants.REDISTSTRUCTALL;
                        var dbVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdData, stIdNode.InnerText));
                        fdwObj.DeleteKeys(dbVarKeys);

                        string fdMemVar = Constants.DBMEMVARSFORMLOAD;
                        var dbMemVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdMemVar, stIdNode.InnerText, "*"));
                        fdwObj.DeleteKeys(dbMemVarKeys);
                    }
                }
                catch (Exception ex) { }
            }
            else if (transid == "ad_ve")//Delete tstruct cached keys for particular form On Save of Error Codes
            {
                try
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    xmlDoc.LoadXml(serviceInputXml);
                    XmlNode stIdNode = xmlDoc.SelectSingleNode("//Transaction/data/applicabletransid");
                    if (stIdNode != null && stIdNode.InnerText != "")
                    {
                        FDW fdwObj = FDW.Instance;
                        FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                        if (fObj == null)
                            fObj = new FDR();

                        string _trTransId = stIdNode.InnerText;
                        string[] _trTransIds = _trTransId.Split(',');
                        foreach (var _trId in _trTransIds)
                        {
                            if (_trId != "")
                            {
                                string fdData = Constants.REDISTSTRUCTALL;
                                var dbVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdData, _trId));
                                fdwObj.DeleteKeys(dbVarKeys);

                                string fdMemVar = Constants.DBMEMVARSFORMLOAD;
                                var dbMemVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdMemVar, _trId, "*"));
                                fdwObj.DeleteKeys(dbMemVarKeys);
                            }
                        }
                    }
                }
                catch (Exception ex) { }
            }
        }

        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        if (AxRelKeys != string.Empty)
            result = result + "*#*" + AxRelKeys;
        if (holdpopup != false)
        {
            result = "{" + "\"holdpopup\"" + ":[{" + "\"hold\"" + ":\" " + holdpopup + "\"}]}" + "*$*" + result;
        }
        if (gridAttSaveResult != string.Empty)
        {
            result = "{" + "\"GridAttachments\"" + ":[{" + "\"Message\"" + ":\" Attachment is not Saved : " + gridAttSaveResult + "\"}]}" + "*$*" + result;
        }
        result = requestProcess_logtime + "♠" + result;
        return result;
    }

    private void ModifyAsNewRecord()
    {
        if (dsDataSet.Tables.Count > 0)
        {
            for (int i = 1; i <= tstStrObj.dcs.Count; i++)
            {
                DataTable dt = dsDataSet.Tables["dc" + i];
                if (dt.Rows.Count > 0)
                {
                    if (((TStructDef.DcStruct)(tstStrObj.dcs[i - 1])).isgrid)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            row["axp_recid" + i] = "0";
                        }
                    }
                    else
                    {
                        dt.Rows[0]["axp_recid" + i] = "0";
                    }
                }
            }
        }
    }

    public string CallWorkFlowActionWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string files, string rid, string inputXml)
    {
        if (!string.IsNullOrEmpty(files))
        {
            UpdateAttachments(files);
        }
        //GetGlobalVars();
        transid = tstData.transid.ToString();
        filename = "WorkFlow-" + transid;
        errlog = logobj.CreateLog("Saving Workflow Data", sessionid, filename, "new");
        result = string.Empty;
        logobj.CreateLog("Cross checking field value xml length send from client and received xml length", sessionid, filename, "");
        //call  a function to delete the default row in pop grid
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);

        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "true", "ALL", "");
        inputXml += "<data>" + tstData.fldValueXml + "</data>";

        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);

        inputXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        logobj.CreateLog("Call to WorkFlowAction Web Service", sessionid, filename, "");
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallWorkFlowActionWS(transid, inputXml);
        logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, "");
        return result;
    }


    public string GetErrorInResultJson(string result)
    {
        result = result.Replace("\\", ";bkslh");
        result = result.Replace("^^dq", "\"");
        string returnStr = result.Replace("*$*", "¿");
        string[] newResult = returnStr.Split('¿');
        for (int i = 0; i < newResult.Length; i++)
        {
            JArray msg;
            try
            {
                JObject message = JObject.Parse(newResult[i].ToString());
                msg = (JArray)message["error"];
            }
            catch (Exception ex)
            {
                throw ex;
            }

            if (msg != null)
            {
                string saveResult = msg[0].SelectToken("msg").ToString();
                saveResult = saveResult.Remove(0, 1);
                saveResult = saveResult.Remove(saveResult.Length - 1, 1);
                return saveResult;
            }
        }
        return result;
    }

    private string SaveGridAttachments(string transid, string sid, string recId, string delRows, TStructData tstData, string changedRows, ArrayList deletedFldArrayValues)
    {
        GetGlobalAttachPath();
        string saveResult = string.Empty;

        if (recId != "0")
        {
            string sourceFilePath = scriptsPath + "axpert\\" + sid;
            string destFilePath = string.Empty;
            string grdAttPath = string.Empty;
            bool hasMultipleFiles = false;
            bool isAxpAttachFld = false;
            hasImagePath = false;
            string fldName = string.Empty;
            ArrayList attFldNames = new ArrayList();
            ArrayList attDestPath = new ArrayList();
            ArrayList attFileNames = new ArrayList();
            ArrayList renamedFiles = new ArrayList();
            StringBuilder strFiles = new StringBuilder();
            ArrayList attWantToDelete = new ArrayList();
            //string schemaName = project;
            string attachTid = GetAttachTransid();
            int attTotalFileCount = 0;
            int attDelFileCount = 0;
            int attSavedFileCount = 0;
            ArrayList isRecordFile = new ArrayList();
            //bool isRecordFile = false;
            if (HttpContext.Current.Session["attGridFileServer"] != null && HttpContext.Current.Session["attGridFileServer"].ToString() != string.Empty)
            {
                string attTotalFile = HttpContext.Current.Session["attGridFileServer"].ToString();
                string[] attTotalFiles = attTotalFile.Split('♦');
                attTotalFileCount = attTotalFiles.Length;
            }

            bool deletedGridFilesExist = false;
            foreach (var attFld in tstStrObj.AxAttachFields)
            {
                int idx = tstStrObj.GetFieldIndex(attFld.ToString());
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];

                if ((fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_image") || fld.name.StartsWith("axp_gridattach_")) && IsDcGrid(fld.fldframeno.ToString(), tstStrObj))
                {
                    TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];
                    fldName = fld.name;

                    //For all attachment fields now the global variables AxpImageServer and AxpImagePath will be used for destination path
                    // GetGlobalAttachPath();
                    grdAttPath = HttpContext.Current.Session["grdAttPath"].ToString();
                    DataTable dcTable = dsDataSet.Tables["dc" + dc.frameno];

                    DataTable dcDelRowTable = dsDataSet.Tables["deldc" + dc.frameno];

                    bool hasDcImagePath = false;
                    hasDcImagePath = dcTable.Columns.Contains("dc" + dc.frameno + "_imagepath");
                    hasImagePath = hasDcImagePath;

                    if (dc.DCHasDataRows && (grdAttPath != string.Empty || hasDcImagePath == true))
                    {
                        if (!grdAttPath.EndsWith("\\"))
                            grdAttPath = grdAttPath + "\\";

                        string value = string.Empty;
                        string destFileName = string.Empty;
                        string sfileEx = string.Empty;


                        bool hasAxpAttachCol = false;
                        hasAxpAttachCol = dcTable.Columns.Contains("axp_gridattach_" + dc.frameno);
                        bool hasAxpAttFileName = false;
                        hasAxpAttFileName = dcTable.Columns.Contains("axpattach_filename" + dc.frameno);

                        DataView dv = new DataView(dcTable);
                        dv.Sort = "axp__rowno ASC";
                        dcTable = dv.ToTable();
                        string axpGrAttPath = string.Empty;
                        int delRowCnt = 0;
                        for (int j = 0; j < dcTable.Rows.Count; j++)
                        {
                            //If dc_image is used for referimages, then don't add the referred files for saving, save only newly attached files   
                            if (!hasAxpAttachCol)
                                value = GetFilesforSave(dcTable.Rows[j][fld.name].ToString());
                            else
                                value = dcTable.Rows[j]["axp_gridattach_" + dc.frameno].ToString();

                            if (value == string.Empty && (changedRows != string.Empty || delRows == string.Empty) && !hasDcImagePath && !hasAxpAttachCol && (fld.name.StartsWith("dc" + dc.frameno + "_image")))
                            {
                                try
                                {
                                    DataTable oldDcTable = dsDataSet.Tables["dc_old" + dc.frameno];
                                    if (dsDataSet.Tables["dc_old" + dc.frameno].Rows[0]["old__" + fld.name].ToString() != string.Empty)
                                    {
                                        deletedGridFilesExist = true;
                                    }
                                }
                                catch (Exception ex) { }
                            }

                            if (value.Contains(","))
                                hasMultipleFiles = true;

                            if (value == string.Empty && HttpContext.Current.Session["attGridFileServer"] != null && HttpContext.Current.Session["attGridFileServer"].ToString() != string.Empty)
                            {
                                string attServerFiles = HttpContext.Current.Session["attGridFileServer"].ToString();
                                string[] lstServerFiles = attServerFiles.Split('♦');
                                int irow = j + 1;
                                var lstServerFile = lstServerFiles.AsEnumerable().Where(x => x.StartsWith(fldName + irow + "~") && x.Contains(HttpContext.Current.Session["username"].ToString() + "-")).ToList();
                                string authenticationStatus = string.Empty;
                                if (lstServerFile.Count > 0 && util.GetAuthentication(ref authenticationStatus))
                                {
                                    foreach (var lst in lstServerFile)
                                    {
                                        string savedFileName = lst.Split('~')[1];
                                        File.Delete(savedFileName);
                                        strExecTrace += "Deleted File:" + savedFileName + " ♦ ";
                                        attDelFileCount++;
                                        HttpContext.Current.Session["attGridFileServer"] = attServerFiles = attServerFiles.Replace(lst + "♦", "").Replace(lst, "");
                                    }
                                }
                            }

                            if (value != string.Empty || deletedGridFilesExist)
                            {
                                //If axp_gridattach
                                if (hasAxpAttachCol)
                                {
                                    if (hasAxpAttFileName && !hasMultipleFiles)
                                    {
                                        sfileEx = value.Substring(value.LastIndexOf("."));
                                        destFileName = dcTable.Rows[j]["axpattach_filename" + dc.frameno].ToString() + sfileEx;
                                    }
                                    isAxpAttachFld = true;
                                    //destFilePath = grdAttPath + schemaName + "\\" + attachTid + "\\" + recId + "\\" + fld.name;
                                    destFilePath = grdAttPath + "\\" + attachTid + "\\" + recId + "\\" + fld.name;
                                }
                                else if (fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_image") && !hasDcImagePath)
                                {
                                    //destFilePath = grdAttPath + schemaName + "\\" + attachTid + "\\" + fld.name;
                                    destFilePath = grdAttPath + "\\" + attachTid + "\\" + fld.name;
                                }
                                else if (hasDcImagePath && !hasAxpAttachCol)
                                {
                                    if (dcTable.Rows[j]["dc" + +dc.frameno + "_imagepath"].ToString() != string.Empty)
                                    {
                                        hasImagePath = true;
                                        grdAttPath = GetdcImagePath(dcTable.Rows[j]["dc" + +dc.frameno + "_imagepath"].ToString());
                                        destFilePath = grdAttPath;
                                    }
                                    else
                                    {
                                        string errorLog = string.Empty;
                                        string errMessage = "Value for dc_imagepath field is not specified";
                                        errorLog = logobj.CreateLog("Error in Saving Grid attachments - " + errMessage, sid, "GridAttachments", "new");
                                        saveResult = errMessage;

                                    }
                                }
                            }

                            if ((value != string.Empty || deletedGridFilesExist) && destFilePath != string.Empty)
                            {
                                try
                                {
                                    DirectoryInfo di = new DirectoryInfo(destFilePath);
                                    if (!di.Exists)
                                        di.Create();

                                }
                                catch (Exception ex)
                                {
                                    saveResult = "Destination Path is empty";
                                }
                                if (destFileName != "") value = destFileName;
                                string[] fileNames = value.Split(',');
                                //These arrays will be used to delete the deleted attachments
                                attFldNames.Add(fldName);
                                if (attDestPath.Count > 0)
                                {
                                    if (attDestPath.IndexOf(destFilePath) == -1)
                                    {
                                        attDestPath.Add(destFilePath);
                                        if (hasImagePath || hasAxpAttachCol)
                                            isRecordFile.Add("false");
                                        else
                                            isRecordFile.Add("true");
                                    }
                                }
                                else
                                {
                                    attDestPath.Add(destFilePath);
                                    if (hasImagePath || hasAxpAttachCol)
                                        isRecordFile.Add("false");
                                    else
                                        isRecordFile.Add("true");
                                }

                                for (int fIdx = 0; fIdx < fileNames.Length; fIdx++)
                                {
                                    if (HttpContext.Current.Session["attGridFileServer"] != null && HttpContext.Current.Session["attGridFileServer"].ToString() != string.Empty)
                                    {
                                        int irow = j + delRowCnt + 1;
                                        if (dcDelRowTable != null && dcDelRowTable.Rows.Count > 0)
                                        {
                                            int iDelrow = j + 1;
                                            var delRowList = dcDelRowTable.AsEnumerable().Where(s => s.Field<string>("axp__delrow") == iDelrow.ToString()).Select(s => s.Field<string>("axp__delrow")).ToList();
                                            if (delRowList != null && delRowList.Count > 0)
                                            {
                                                string attServerFiless = HttpContext.Current.Session["attGridFileServer"].ToString();
                                                string[] lstServerFiless = attServerFiless.Split('♦');
                                                var lstMatchFiles = lstServerFiless.AsEnumerable().Where(x => x.StartsWith(fldName + irow + "~") && x.Contains(HttpContext.Current.Session["username"].ToString() + "-")).ToList();
                                                delRowCnt = delRowCnt + 1;
                                                irow = irow + 1;
                                                foreach (var lst in lstMatchFiles)
                                                {
                                                    string savedFileName = lst.Split('\\').Last();
                                                    string attdestFilePath = string.Empty;
                                                    attdestFilePath = destFilePath + "\\" + savedFileName;
                                                    // File.Delete(attdestFilePath);
                                                    attWantToDelete.Add(attdestFilePath);
                                                    HttpContext.Current.Session["attGridFileServer"] = attServerFiless.Replace(lst + "♦", "").Replace(lst, "");
                                                }
                                            }
                                        }
                                        string attServerFiles = HttpContext.Current.Session["attGridFileServer"].ToString();
                                        string[] lstServerFiles = attServerFiles.Split('♦');


                                        var lstServerFile = lstServerFiles.AsEnumerable().Where(x => x.StartsWith(fldName + irow + "~") && x.Contains(HttpContext.Current.Session["username"].ToString() + "-")).ToList();
                                        string authenticationStatus = string.Empty;
                                        if (lstServerFile.Count > 0 && util.GetAuthentication(ref authenticationStatus))
                                        {
                                            foreach (var lst in lstServerFile)
                                            {
                                                string savedFileName = lst.Split('\\').Last();// lst.Split('~')[1];
                                                string attdestFilePath = string.Empty;
                                                attdestFilePath = destFilePath + "\\" + savedFileName;
                                                string atFileName = savedFileName.Replace(HttpContext.Current.Session["username"].ToString() + "-", "");
                                                var saveFileLst = fileNames.AsEnumerable().Where(x => x == atFileName).ToList();
                                                if (saveFileLst.Count > 0)
                                                {
                                                    if (fileNames[fIdx] == atFileName)
                                                    {
                                                        if (hasAxpAttachCol)
                                                        {
                                                            string renameFilePath = grdAttPath + attachTid + "\\" + HttpContext.Current.Session["username"].ToString() + "\\" + fld.name;
                                                            axpGrAttPath = grdAttPath + attachTid + "\\" + HttpContext.Current.Session["username"].ToString();

                                                            try
                                                            {
                                                                if (File.Exists(renameFilePath + "\\" + savedFileName))
                                                                {
                                                                    Microsoft.VisualBasic.FileIO.FileSystem.RenameFile(renameFilePath + "\\" + savedFileName, atFileName);
                                                                    strExecTrace += "RenameFile:" + renameFilePath + "\\" + savedFileName + " To ♦ " + atFileName + " ♦ ";
                                                                }
                                                                //else
                                                                //{
                                                                //    strExecTrace += "File does not exist to Rename:" + renameFilePath + "\\" + savedFileName + " ♦ ";
                                                                //}
                                                            }
                                                            catch (Exception ex)
                                                            {
                                                                if (File.Exists(renameFilePath + "\\" + savedFileName))
                                                                {
                                                                    string destException = renameFilePath + "\\ExceptionFiles";
                                                                    DirectoryInfo destdi = new DirectoryInfo(destException);
                                                                    if (!destdi.Exists)
                                                                        destdi.Create();
                                                                    string destExcPath = destException + "\\" + savedFileName;
                                                                    File.Move(@renameFilePath + "\\" + savedFileName, @destExcPath);
                                                                    strExecTrace += "Exception in RenameFile and the file moved to:" + destExcPath + " Exception is: " + ex.Message + " ♦ ";
                                                                }
                                                                else
                                                                    strExecTrace += "Exception in RenameFile:" + renameFilePath + "\\" + savedFileName + " To ♦ " + atFileName + " Exception is: " + ex.Message + " ♦ ";
                                                            }

                                                            renameFilePath = renameFilePath + "\\" + atFileName;
                                                            destFilePath = destFilePath + "\\" + atFileName;
                                                            File.Move(@renameFilePath, @destFilePath);
                                                            attSavedFileCount++;
                                                            if (strFiles.ToString() == string.Empty)
                                                                strFiles.Append(atFileName);
                                                            else
                                                                strFiles.Append("," + atFileName);

                                                        }
                                                        else if (hasImagePath)
                                                        {
                                                            if (renamedFiles.Count == 0 || (renamedFiles.Count > 0 && renamedFiles.IndexOf(atFileName) == -1))
                                                                File.Delete(destFilePath + "\\" + atFileName);
                                                            try
                                                            {
                                                                //if (File.Exists(attdestFilePath))
                                                                //{
                                                                Microsoft.VisualBasic.FileIO.FileSystem.RenameFile(attdestFilePath, atFileName);
                                                                renamedFiles.Add(atFileName);
                                                                strExecTrace += "RenameFile:" + attdestFilePath + " To ♦ " + atFileName + " ♦ ";
                                                                //}
                                                                //else
                                                                //{
                                                                //    strExecTrace += "File does not exist to Rename:" + attdestFilePath + " ♦ ";
                                                                //}
                                                            }
                                                            catch (Exception ex)
                                                            {
                                                                if (File.Exists(attdestFilePath))
                                                                {
                                                                    string destException = destFilePath + "\\ExceptionFiles";
                                                                    DirectoryInfo destdi = new DirectoryInfo(destException);
                                                                    if (!destdi.Exists)
                                                                        destdi.Create();
                                                                    string destExcPath = destException + "\\" + savedFileName;
                                                                    File.Move(@attdestFilePath, @destExcPath);
                                                                    strExecTrace += "Exception in RenameFile and the file moved to:" + destExcPath + " Exception is: " + ex.Message + " ♦ ";
                                                                }
                                                                else
                                                                    strExecTrace += "Exception in RenameFile:" + attdestFilePath + " To ♦ " + atFileName + " Exception is: " + ex.Message + " ♦ ";
                                                            }
                                                            if (strFiles.ToString() == string.Empty)
                                                                strFiles.Append(atFileName);
                                                            else
                                                                strFiles.Append("," + atFileName);
                                                            attSavedFileCount++;
                                                        }
                                                        else
                                                        {
                                                            if (renamedFiles.Count == 0 || (renamedFiles.Count > 0 && renamedFiles.IndexOf(recId + "-" + atFileName) == -1))
                                                                File.Delete(destFilePath + "\\" + recId + "-" + atFileName);
                                                            try
                                                            {
                                                                //if (File.Exists(attdestFilePath))
                                                                //{
                                                                Microsoft.VisualBasic.FileIO.FileSystem.RenameFile(attdestFilePath, recId + "-" + atFileName);
                                                                renamedFiles.Add(recId + "-" + atFileName);
                                                                strExecTrace += "RenameFile:" + attdestFilePath + " To ♦ " + recId + "-" + atFileName + " ♦ ";
                                                                //}
                                                                //else
                                                                //{
                                                                //    strExecTrace += "File does not exist to Rename:" + attdestFilePath + " ♦ ";
                                                                //}
                                                            }
                                                            catch (Exception ex)
                                                            {
                                                                if (File.Exists(attdestFilePath))
                                                                {
                                                                    string destException = destFilePath + "\\ExceptionFiles";
                                                                    DirectoryInfo destdi = new DirectoryInfo(destException);
                                                                    if (!destdi.Exists)
                                                                        destdi.Create();
                                                                    string destExcPath = destException + "\\" + savedFileName;
                                                                    File.Move(@attdestFilePath, @destExcPath);
                                                                    strExecTrace += "Exception in RenameFile and the file moved to:" + destExcPath + " Exception is: " + ex.Message + " ♦ ";
                                                                }
                                                                else
                                                                    strExecTrace += "Exception in RenameFile:" + attdestFilePath + " To ♦ " + recId + "-" + atFileName + " Exception is: " + ex.Message + " ♦ ";
                                                            }
                                                            if (strFiles.ToString() == string.Empty)
                                                                strFiles.Append(recId + "-" + atFileName);
                                                            else
                                                                strFiles.Append("," + recId + "-" + atFileName);
                                                            attSavedFileCount++;
                                                        }
                                                        HttpContext.Current.Session["attGridFileServer"] = attServerFiles = attServerFiles.Replace(lst + "♦", "").Replace(lst, "");
                                                    }
                                                    else
                                                    {
                                                        if (hasImagePath || hasAxpAttachCol)
                                                        {
                                                            if (strFiles.ToString() == string.Empty)
                                                                strFiles.Append(fileNames[fIdx]);
                                                            else
                                                                strFiles.Append("," + fileNames[fIdx]);
                                                        }
                                                        else
                                                        {
                                                            if (strFiles.ToString() == string.Empty)
                                                                strFiles.Append(recId + "-" + fileNames[fIdx]);
                                                            else
                                                                strFiles.Append("," + recId + "-" + fileNames[fIdx]);
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    if (hasImagePath || hasAxpAttachCol)
                                                    {
                                                        if (strFiles.ToString() == string.Empty)
                                                            strFiles.Append(fileNames[fIdx]);
                                                        else
                                                            strFiles.Append("," + fileNames[fIdx]);
                                                    }
                                                    else
                                                    {
                                                        if (strFiles.ToString() == string.Empty)
                                                            strFiles.Append(recId + "-" + fileNames[fIdx]);
                                                        else
                                                            strFiles.Append("," + recId + "-" + fileNames[fIdx]);
                                                    }
                                                    attDelFileCount++;
                                                    File.Delete(attdestFilePath);
                                                    strExecTrace += "Deleted File:" + attdestFilePath + " ♦ ";
                                                    HttpContext.Current.Session["attGridFileServer"] = attServerFiles = attServerFiles.Replace(lst + "♦", "").Replace(lst, "");
                                                }
                                            }
                                        }
                                        else
                                        {
                                            string fNames = fileNames[fIdx].ToString();
                                            if (fNames == "") continue;
                                            if (!hasDcImagePath && !hasAxpAttachCol)
                                                fNames = recId + "-" + fileNames[fIdx].ToString();
                                            if (strFiles.ToString() == string.Empty)
                                                strFiles.Append(fNames);
                                            else
                                                strFiles.Append("," + fNames);
                                        }
                                        continue;
                                    }

                                    string fName = fileNames[fIdx].ToString();
                                    if (fName == "") continue;
                                    if (!hasDcImagePath && !hasAxpAttachCol)
                                        fName = recId + "-" + fileNames[fIdx].ToString();
                                    if (strFiles.ToString() == string.Empty)
                                        strFiles.Append(fName);
                                    else
                                        strFiles.Append("," + fName);

                                    CopyFiles(sourceFilePath, destFilePath, fileNames[fIdx], fName);
                                }
                            }
                        }
                        if (axpGrAttPath != string.Empty && Directory.Exists(axpGrAttPath))
                        {
                            try
                            {
                                Directory.Delete(axpGrAttPath, true);
                            }
                            catch { }
                        }
                    }
                }
            }

            string attDelPath = "";
            if (attWantToDelete.Count > 0)//Delete and add same file in another row
            {
                attDelFileCount += attWantToDelete.Count;
                foreach (string wtdFile in attWantToDelete)
                {
                    string attFName = wtdFile.Split('\\').Last();
                    attDelPath = wtdFile;
                    attDelPath = attDelPath.Replace("\\" + attFName, "");
                    try
                    {
                        File.Delete(wtdFile);
                        strExecTrace += "Deleted File:" + wtdFile + " ♦ ";
                    }
                    catch (Exception ex) { }
                }
            }


            if (changedRows != string.Empty || delRows != string.Empty)//Delete any file or load record and delete file
            {
                int delFcnt = DeleteGridAttachments(delRows, recId, grdAttPath, transid, isAxpAttachFld, fldName, attFldNames, attDestPath, strFiles, isRecordFile);
                //attDelPath = attDelPath == "" ? attDestPath[0].ToString() : attDelPath;
                if (attDelPath == "" && attDestPath.Count > 0)
                    attDelPath = attDestPath[0].ToString();
                if (delFcnt != 0)
                    attDelFileCount += delFcnt;
            }
            if (attDelPath != "" && attDelFileCount != 0)
            {
                AttDelLogFile(attDelPath, recId, attTotalFileCount, attSavedFileCount, attDelFileCount);
            }

        }
        return saveResult;
    }

    private void AttDelLogFile(string attDelPath, string strRecId, int attTotalFileCount, int attSavedFileCount, int attDelFileCount)
    {
        // Total uploaded files: , Saved files: and deleted files : 
        // Log file recid-attdetails.txt
        try
        {
            if (attDelPath != "")
            {
                //attTotalFileCount
                //string attFName = attDelPath.Split('\\').Last();
                //attDelPath = attDelPath.Replace("\\" + attFName, "");
                attDelPath = attDelPath + "\\Temp";
                DirectoryInfo diDel = new DirectoryInfo(attDelPath);
                if (!diDel.Exists)
                    diDel.Create();
                string attFPath = diDel + "\\" + strRecId + "-attdetails.txt";
                StreamWriter sw = default(StreamWriter);
                if (File.Exists(attFPath))
                {
                    sw = new StreamWriter(attFPath, true);
                    sw.WriteLine("********** {0} **********", DateTime.Now.ToString());
                    sw.Flush();
                    sw.Close();
                    sw = new StreamWriter(attFPath, true);
                }
                else
                {
                    sw = new StreamWriter(attFPath, false);
                    sw.WriteLine("********** {0} **********", DateTime.Now.ToString());
                    sw.Flush();
                    sw.Close();
                    sw = new StreamWriter(attFPath, true);
                }
                string text = "Total uploaded files:" + attTotalFileCount + " , saved files:" + attSavedFileCount + " and deleted files :" + attDelFileCount;
                sw.WriteLine(text);
                sw.Flush();
                sw.Close();
            }
        }
        catch (Exception exs) { }
    }

    public string GetFilesforSave(string referredFiles)
    {
        string nonReferredFiles = referredFiles;
        return nonReferredFiles;

        string[] refFiles = referredFiles.Split(')');

        if (refFiles.Length > 1 && refFiles[1] != string.Empty)
            nonReferredFiles = refFiles[1];
        else if (refFiles.Length > 1 && refFiles[1] == string.Empty)
            nonReferredFiles = string.Empty;

        return nonReferredFiles;
    }
    //Get dc_imagepath field value
    public string GetdcImagePath(string dcImagePath)
    {
        string grdAttPath = GetImgServerPath();

        if (dcImagePath != string.Empty && dcImagePath.Contains(":"))
        {
            grdAttPath = dcImagePath;
        }
        else if (grdAttPath != string.Empty)
        {
            grdAttPath = grdAttPath + "\\" + dcImagePath;

        }
        else if (grdAttPath == string.Empty && dcImagePath != "")
            grdAttPath = dcImagePath;
        else if (dcImagePath == string.Empty)
        {
            string errorLog = string.Empty;
            string errMessage = "Value for dc_imagepath field is not specified";
            errorLog = logobj.CreateLog("Error in loading Grid attachments - " + errMessage, sessionid, "GridAttachments", "new");
            grdAttPath = string.Empty;
        }

        return grdAttPath;
    }

    public void GetGlobalAttachPath()
    {
        bool isLocalFolder = false, isOnlyFolder = false;
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
            else
                isOnlyFolder = true;
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
        //If the global variables AxpimageServer and AxpImagePath is not defined
        {

            if (HttpContext.Current.Session["AxGridAttachPath"] != null)
            {
                grdAttPath = HttpContext.Current.Session["AxGridAttachPath"].ToString();
                //CommonDir directory creation taken back due to application server memory usage.
                //if (!grdAttPath.Contains(":\\"))
                //{
                //    // ftp server path
                //    if (!grdAttPath.Contains("\\\\"))
                //    {
                //        grdAttPath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + grdAttPath;
                //        if (!Directory.Exists(grdAttPath))
                //        {
                //            Directory.CreateDirectory(grdAttPath);
                //        }
                //    }
                //}
            }
        }
        HttpContext.Current.Session["grdAttPath"] = grdAttPath;
    }

    private int DeleteGridAttachments(string delRows, string recId, string grdAttPath, string transId, bool isAxpAttachFld, string fld, ArrayList attFldNames, ArrayList attDestPath, StringBuilder attFileNames, ArrayList isRecordFile)
    {
        int DelfCnt = 0;
        try
        {
            for (int i = 0; i < attDestPath.Count; i++)
            {
                //abc.txt,xyz.txt,
                string isRecFile = isRecordFile[i].ToString();
                string attFiles = attFileNames.ToString() + ",";
                DirectoryInfo di = new DirectoryInfo(attDestPath[i].ToString());
                if (di.Exists)
                {
                    FileInfo[] files = isRecFile == "true" ? di.GetFiles(recId + "-*") : di.GetFiles();
                    for (int j = 0; j < files.Length; j++)
                    {
                        FileInfo file = (FileInfo)files[j];
                        string strFileName = file.Name + ",";
                        if (attFiles.IndexOf(strFileName) == -1 && (file.Name).IndexOf(recId) != -1)
                        {
                            file.Delete();
                            DelfCnt++;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            logobj.CreateLog("Error while deleting-" + ex.Message, sessionid, "DeleteGridAttachments", "new");
        }
        return DelfCnt;
    }

    //For deleting nongrid attachment files from file server
    private void DeleteNonGridAttachments(string recId, string grdAttPath, string transId, string fieldName, ArrayList attFldNames, ArrayList nonGridAttDestPath, StringBuilder attFileNames)
    {
        try
        {
            for (int i = 0; i < nonGridAttDestPath.Count; i++)
            {
                //abc.txt,xyz.txt,
                string attFiles = attFileNames.ToString() + ",";
                DirectoryInfo di = new DirectoryInfo(nonGridAttDestPath[i].ToString());
                if (di.Exists)
                {
                    FileInfo[] files = di.GetFiles();
                    for (int j = 0; j < files.Length; j++)
                    {
                        FileInfo file = (FileInfo)files[j];
                        string strFileName = file.Name + ",";
                        if (attFiles.IndexOf(strFileName) == -1 && (file.Name).IndexOf(recId) != -1)
                            file.Delete();

                    }
                }
            }
        }
        catch (Exception ex)
        {
            logobj.CreateLog("Error while deleting-" + ex.Message, sessionid, "DeleteGridAttachments", "new");
        }
    }

    //Function to save the image in the server folder if the image starts with fld_ddo
    private void SaveImageToFolder(TStructDef strObj, string transid, string sid, string recId, ArrayList deletedFldArrayValues)
    {

        bool deletedGridFilesExist = false;

        if (recId != "0")
        {

            foreach (var imgFld in tstStrObj.AxImageFields)
            {
                int idx = tstStrObj.GetFieldIndex(imgFld.ToString());
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)strObj.flds[idx];
                TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];
                DataTable dcTable = dsDataSet.Tables["dc" + dc.frameno];

                if (fld.fieldIsImage)
                {
                    if (!IsDcGrid(fld.fldframeno.ToString(), strObj))
                    {

                        string value = string.Empty, destValue = string.Empty;
                        ArrayList nonGridAttDestPath = new ArrayList();
                        ArrayList attFldNames = new ArrayList();
                        StringBuilder nonGrdStrFiles = new StringBuilder();
                        destValue = value = GetFieldValue(fld.fldframeno.ToString(), fld.name);
                        if (value == string.Empty && (fld.name.StartsWith("dc" + fld.fldframeno + "_image") || fld.name.StartsWith("axp_nga_")))
                        {
                            try
                            {
                                DataTable oldDcTable = dsDataSet.Tables["dc_old" + fld.fldframeno];
                                if (dsDataSet.Tables["dc_old" + fld.fldframeno].Rows[0]["old__" + fld.name].ToString() != string.Empty)
                                {
                                    deletedGridFilesExist = true;
                                }
                            }
                            catch (Exception ex) { }
                        }
                        if (value != string.Empty || deletedGridFilesExist)
                        {

                            string fieldName = fld.name;//fieldControlName[index].ToString();
                            string strFile = "";
                            if (!(fieldName.StartsWith("axp_nga_")))
                            {
                                strFile = scriptsPath + "axpert\\" + sid + "\\" + fieldName;
                                if (!File.Exists(strFile + "\\" + value))
                                {
                                    string strFileNew = scriptsPath + "axpert\\" + sid;
                                    if (File.Exists(strFileNew + "\\" + value))
                                        strFile = strFileNew;
                                }

                                string strDest = "";
                                if (imgAttachPath != "")
                                {
                                    string imgName = destValue.Substring(0, destValue.LastIndexOf('.'));
                                    destValue = destValue.Replace(imgName, recId);
                                    //strDest = imgAttachPath + "\\axpert\\" + transid + "\\" + recId + "\\" + fieldName;
                                    strDest = imgAttachPath + "\\" + transid + "\\" + fieldName;
                                }
                                else
                                {
                                    //strDest = scriptsPath + "axpert\\" + transid + "\\" + recId + "\\" + fieldName;
                                    strDest = scriptsPath + "axpert\\" + transid + "\\" + fieldName;
                                }

                                //loop to check if multiple images exist for same field, if yes then delete all.
                                string authenticationStatus = string.Empty;
                                if (util.GetAuthentication(ref authenticationStatus))
                                {
                                    DirectoryInfo di = new DirectoryInfo(strDest);
                                    if (!di.Exists)
                                    {
                                        di.Create();
                                    }
                                    else if (imgAttachPath == "")
                                    {
                                        FileInfo[] files = di.GetFiles();
                                        for (int j = 0; j < files.Length; j++)
                                        {
                                            FileInfo file = (FileInfo)files[j];
                                            file.Delete();
                                        }
                                    }
                                    else if (imgAttachPath != "")
                                    {
                                        FileInfo[] files = di.GetFiles();
                                        if (files.Length > 0)
                                        {
                                            var ImgExist = files.Where(x => x.Name.Split('.')[0] == recId).ToList();
                                            if (ImgExist.Count > 0)
                                            {
                                                foreach (var lstImg in ImgExist)
                                                {
                                                    FileInfo file = (FileInfo)lstImg;
                                                    file.Delete();
                                                }
                                            }
                                        }
                                    }
                                    if (value != string.Empty || deletedGridFilesExist)
                                    {
                                        CopyFiles(strFile, strDest, value, destValue);
                                    }
                                }
                            }
                            else
                            {

                                //strFile = scriptsPath + "axpert\\" + sid + "\\" + fieldName;
                                strFile = scriptsPath + "axpert\\" + sid;
                                if (!File.Exists(strFile + "\\" + value))
                                {
                                    string strFileNew = scriptsPath + "axpert\\" + sid;
                                    if (File.Exists(strFileNew + "\\" + value))
                                        strFile = strFileNew;
                                }

                                string strDest = "";
                                if (imgAttachPath != "" && !(deletedGridFilesExist))
                                {
                                    string imgName = destValue.Substring(0, destValue.LastIndexOf('.'));
                                    destValue = destValue.Replace(imgName, recId);
                                    //strDest = imgAttachPath + "\\axpert\\" + transid + "\\" + recId + "\\" + fieldName;
                                    strDest = imgAttachPath + "\\" + transid + "\\" + fieldName;
                                }
                                else if (!deletedGridFilesExist)
                                {
                                    //strDest = scriptsPath + "axpert\\" + transid + "\\" + recId + "\\" + fieldName;
                                    strDest = scriptsPath + "axpert\\" + transid + "\\" + fieldName;
                                }
                                else
                                {
                                    strDest = imgAttachPath + "\\" + transid + "\\" + fieldName;
                                }

                                //loop to check if multiple images exist for same field, if yes then delete all.
                                string authenticationStatus = string.Empty;
                                if (util.GetAuthentication(ref authenticationStatus))
                                {
                                    DirectoryInfo di = new DirectoryInfo(strDest);
                                    if (!di.Exists)
                                    {
                                        di.Create();
                                    }
                                    else if (imgAttachPath == "")
                                    {
                                        FileInfo[] files = di.GetFiles();
                                        for (int j = 0; j < files.Length; j++)
                                        {
                                            FileInfo file = (FileInfo)files[j];
                                            file.Delete();
                                        }
                                    }
                                    else if (imgAttachPath != "")
                                    {
                                        FileInfo[] files = di.GetFiles();
                                        if (files.Length > 0)
                                        {
                                            var ImgExist = files.Where(x => x.Name.Split('.')[0] == recId).ToList();
                                            if (ImgExist.Count > 0)
                                            {
                                                foreach (var lstImg in ImgExist)
                                                {
                                                    FileInfo file = (FileInfo)lstImg;
                                                    file.Delete();
                                                }
                                            }
                                        }
                                    }
                                    if (value != string.Empty || deletedGridFilesExist)
                                    {
                                        string[] fileNames = value.Split(',');
                                        nonGridAttDestPath.Add(strDest);
                                        attFldNames.Add(fieldName);
                                        for (int fIdx = 0; fIdx < fileNames.Length; fIdx++)
                                        {
                                            string fName = fileNames[fIdx].ToString();
                                            if (fName == "") continue;
                                            fName = recId + "-" + fileNames[fIdx].ToString();
                                            CopyFiles(strFile, strDest, fileNames[fIdx], fName);
                                            if (nonGrdStrFiles.ToString() == string.Empty)
                                                nonGrdStrFiles.Append(fName);
                                            else
                                                nonGrdStrFiles.Append("," + fName);
                                        }
                                    }
                                }

                                DeleteNonGridAttachments(recId, imgAttachPath, transid, fieldName, attFldNames, nonGridAttDestPath, nonGrdStrFiles);

                            }
                        }
                    }
                }
            }
        }
    }

    /// <summary>
    /// Function to get a non grid field's value.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <param name="fldName"></param>
    /// <returns></returns>
    public string GetFieldValue(string dcNo, string fldName)
    {
        string fldValue = string.Empty;
        DataTable dcTable = dsDataSet.Tables["dc" + dcNo];
        if (dcTable.Rows.Count > 0)
        {
            try
            {
                fldValue = dcTable.Rows[0][fldName].ToString();
            }
            catch (Exception ex)
            { }
        }
        return fldValue;
    }

    public string DeleteImages(TStructData tstData, string recId, string fieldName)
    {
        string res = "";
        transid = tstData.transid.ToString();
        fieldName = fieldName.Substring(0, fieldName.LastIndexOf("F") - 3);
        int index = fldNames.IndexOf(fieldName);
        string fldFrameNo = GetFrameNo(fieldName);
        string value = GetFieldValue(fldFrameNo, fieldName);

        string strFile = "";
        strFile = scriptsPath + "axpert\\" + sessionid;

        string strDest = "", strDestNew = "";
        if (imgAttachPath != "")
        {
            strDest = imgAttachPath + "\\axpert\\" + transid + "\\" + fldNames[index].ToString();
            strDestNew = imgAttachPath + "\\" + transid + "\\" + fldNames[index].ToString();
        }
        else
        {
            strDest = scriptsPath + "axpert\\" + sessionid + "\\" + fldNames[index].ToString();
        }

        //loop to check if multiple images exist for same field, if yes then delete all.
        DirectoryInfo di = new DirectoryInfo(strDestNew);
        try
        {
            if (di.Exists)
            {
                FileInfo[] files = di.GetFiles();
                for (int j = 0; j < files.Length; j++)
                {
                    FileInfo file = (FileInfo)files[j];
                    string[] fileStr = file.Name.Split('-');
                    if (fileStr[0].ToString() == recId)
                    {
                        file.Delete();
                    }
                }
            }
            DirectoryInfo diNew = new DirectoryInfo(strDest);
            if (diNew.Exists)
            {
                FileInfo[] files = diNew.GetFiles();
                for (int j = 0; j < files.Length; j++)
                {
                    FileInfo file = (FileInfo)files[j];
                    string[] fileStr = file.Name.Split('-');
                    if (fileStr[0].ToString() == recId)
                    {
                        file.Delete();
                    }
                }
            }

        }
        catch (Exception ex)
        {
            res = ex.Message;
        }

        return res;
    }

    //Function to copy the image from the given source path to the destination path.
    private void CopyFiles(string sourcePath, string destPath, string srcFileName, string desFileName)
    {
        string authenticationStatus = string.Empty;
        if (util.GetAuthentication(ref authenticationStatus))
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
                catch (FileNotFoundException ex)
                {

                }
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
    #region GridAttachments
    public void LoadGridAttsToFolder(string recId, string tid)
    {
        string destFilePath = scriptsPath + "axpert\\" + HttpContext.Current.Session["nsessionid"];
        string srcFilePath = string.Empty;
        string srcpathValue = string.Empty;
        string grdAttPath = string.Empty;
        //string schemaName = project;
        grdAttPath = HttpContext.Current.Session["grdAttPath"].ToString();
        string attachTid = GetAttachTransid();

        ArrayList attFileNames = new ArrayList();
        bool hasGridAttachFld = false;
        foreach (var attFld in tstStrObj.AxAttachFields)
        {
            int idx = tstStrObj.GetFieldIndex(attFld.ToString());
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];

            if ((fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_imagepath")) && IsDcGrid(fld.fldframeno.ToString(), tstStrObj))
                hasImagePath = true;

            //If dc_referimages is defined for referring Attachments
            if ((fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_referimages")) && IsDcGrid(fld.fldframeno.ToString(), tstStrObj))
            {
                TStructDef.DcStruct dc1 = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];

                DataTable dcTable1 = dsDataSet.Tables["dc" + dc1.frameno];

                string refVal1 = string.Empty;
                for (int k = 0; k < dcTable1.Rows.Count; k++)
                {
                    if (string.IsNullOrEmpty(Convert.ToString(dcTable1.Rows[k]["dc" + dc1.frameno + "_referimages"])))
                        refVal1 = dcTable1.Rows[k]["dc" + dc1.frameno + "_referimages"].ToString();
                    GetReferedFiles(refVal1, hasImagePath);
                }

            }
            if (((fld.name.StartsWith("axp_gridattach_")) || (fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_image"))) && !(fld.name.StartsWith("axp_nga_")) && IsDcGrid(fld.fldframeno.ToString(), tstStrObj))
            {
                TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];
                if (dc.DCHasDataRows)
                {
                    if (!(fld.name.StartsWith("axp_gridattach_")))
                        srcFilePath = grdAttPath + "\\" + attachTid + "\\" + fld.name;
                    //srcFilePath = grdAttPath + "\\" + schemaName + "\\" + attachTid + "\\" + fld.name;
                    else
                    {
                        hasGridAttachFld = true;
                        srcFilePath = grdAttPath + "\\" + attachTid + "\\" + recId + "\\" + fld.name;
                        //srcFilePath = grdAttPath + "\\" + schemaName + "\\" + attachTid + "\\" + recId + "\\" + fld.name;
                    }

                    string value = string.Empty;
                    DataTable dcTable = dsDataSet.Tables["dc" + dc.frameno];
                    string sfileEx = string.Empty;

                    for (int j = 0; j < dcTable.Rows.Count; j++)
                    {
                        attFileNames.Clear();
                        value = dcTable.Rows[j][fld.name].ToString();
                        string[] attFiles;
                        if (value != "")
                            sfileEx = value.Substring(value.LastIndexOf("."));
                        //If axpattach_filename is defined
                        if (dcTable.Columns.Contains("axpattach_filename" + dc.frameno))
                        {
                            if (value != string.Empty)
                                if (dcTable.Rows[j]["axpattach_filename" + dc.frameno].ToString() != string.Empty)
                                    value = dcTable.Rows[j]["axpattach_filename" + dc.frameno].ToString() + sfileEx;
                        }
                        //If dc_imagepath is defined
                        if (dcTable.Columns.Contains("dc" + dc.frameno + "_imagepath"))
                        {
                            srcFilePath = GetdcImagePath(dcTable.Rows[j]["dc" + dc.frameno + "_imagepath"].ToString());

                        }
                        //If dc_image field is referring attachments
                        if (value.Contains("@"))
                        {
                            GetReferedFiles(value, hasImagePath);
                        }
                        if (value.Contains(","))
                        {
                            attFiles = value.Split(',');
                            for (int attCount = 0; attCount < attFiles.Length; attCount++)
                                attFileNames.Add(recId + "-" + attFiles[attCount]);
                        }
                        else
                            attFileNames.Add(recId + "-" + value);

                        LoadFilefromFolder(srcFilePath, destFilePath, attFileNames, recId);
                    }

                }
                else
                {
                    //If no DataRows are there, and the Tstruct is referring attachments through dc_image field
                    if (fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_image"))
                    {
                        DataTable dcTableRef = dsDataSet.Tables["dc" + dc.frameno];
                        for (int j = 0; j < dcTableRef.Rows.Count; j++)
                        {
                            string dcrefVal1 = dcTableRef.Rows[j]["dc" + dc.frameno + "_image"].ToString();
                            if (dcrefVal1.Contains("@"))
                            {
                                GetReferedFiles(dcrefVal1, hasImagePath);
                            }
                        }
                    }
                }
            }
            else if (fld.name.StartsWith("axp_nga_"))
            {
                sessionid = HttpContext.Current.Session["nsessionid"].ToString();
                TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];
                DataTable dcTable = dsDataSet.Tables["dc" + dc.frameno];
                if (dcTable != null && dcTable.Rows.Count > 0)
                {
                    string value = dcTable.Rows[0][fld.name].ToString();
                    string[] attFiles;
                    attFileNames.Clear();
                    if (value.Contains(","))
                    {
                        attFiles = value.Split(',');
                        for (int attCount = 0; attCount < attFiles.Length; attCount++)
                            attFileNames.Add(recId + "-" + attFiles[attCount]);
                    }
                    else
                        attFileNames.Add(recId + "-" + value);
                    string scrPath = scriptsPath + "axpert\\" + sessionid;
                    string desFilePath = "", desFilePathOld = "";
                    if (imgAttachPath != "")
                    {
                        desFilePathOld = imgAttachPath + "\\axpert\\" + transID + "\\" + recId + "\\" + fld.name;
                        desFilePath = imgAttachPath + "\\" + transID + "\\" + fld.name;
                    }
                    else
                    {
                        desFilePath = scriptsPath + "axpert\\" + transID + "\\" + fld.name;
                    }
                    string authenticationStatus = string.Empty;
                    if (util.GetAuthentication(ref authenticationStatus))
                    {
                        DirectoryInfo di = new DirectoryInfo(desFilePath);
                        if (!di.Exists)
                            di.Create();

                        FileInfo[] fileEntries = di.GetFiles();
                        //TODO: since the loop is breaking after the first loop, the i need not be incremented
                        for (int k = 0; k < fileEntries.Length; k++)
                        {
                            FileInfo file = (FileInfo)fileEntries[k];
                            string imgName = file.Name.Substring(0, 13);
                            if (imgName == recId)
                            {
                                string destValue = file.Name.Replace(imgName, recId);
                                if (File.Exists(desFilePath + "\\" + destValue))
                                {
                                    imageFldSrc.Add(scrPath + "axpert\\" + sessionid + "\\" + destValue);
                                    LoadFilefromFolder(desFilePath, scrPath, attFileNames, recId);
                                }
                                else
                                {
                                    DirectoryInfo diOld = new DirectoryInfo(desFilePathOld);
                                    if (diOld.Exists)
                                    {
                                        FileInfo[] fileEntriesOld = diOld.GetFiles();
                                        //TODO: since the loop is breaking after the first loop, the i need not be incremented
                                        for (int j = 0; j < fileEntriesOld.Length; j++)
                                        {
                                            FileInfo fileOld = (FileInfo)fileEntriesOld[j];
                                            imageFldSrc.Add(scrPath + "axpert\\" + sessionid + "\\" + fileOld.Name);
                                            LoadFilefromFolder(desFilePath, scrPath, attFileNames, recId);
                                        }
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    private string GetImgServerPath()
    {

        string grdAttPath = string.Empty;
        string imageServer = string.Empty;

        if (HttpContext.Current.Session["AxpImageServerGbl"] != null)
        {
            imageServer = HttpContext.Current.Session["AxpImageServerGbl"].ToString();
            imageServer = imageServer.Replace(";bkslh", @"\");
        }

        return imageServer;
    }
    private void LoadFilefromFolder(string fPath, string destFilePath, ArrayList attFileNames, string recId)
    {
        if (fPath != string.Empty)
        {
            DirectoryInfo di = new DirectoryInfo(fPath);
            if (!di.Exists)
                di.Create();
            foreach (string fileName in attFileNames)
            {
                bool isFileCopied = false;
                FileInfo[] fileEntries = di.GetFiles(fileName);
                if (fileEntries != null && fileEntries.Length > 0)
                {
                    FileInfo file = (FileInfo)fileEntries[0];
                    string[] fileVal = file.Name.Split(new[] { '-' }, 2);

                    if (attFileNames.IndexOf(file.Name) != -1 && fileVal.Length > 1)
                    {
                        CopyFiles(fPath, destFilePath, file.Name, fileVal[1].ToString());
                    }
                    else
                        CopyFiles(fPath, destFilePath, file.Name, file.Name);
                    isFileCopied = true;
                }
                else
                {
                    string[] fileVal = fileName.Split(new[] { '-' }, 2);
                    string worFlname = string.Empty;
                    if (fileVal.Length > 1 && fileVal[0] == recId)
                        worFlname = fileVal[1].ToString();
                    else
                        worFlname = fileName;
                    FileInfo[] fileEntrie = di.GetFiles(worFlname);
                    if (fileEntrie != null && fileEntrie.Length > 0)
                    {
                        FileInfo file = (FileInfo)fileEntrie[0];
                        CopyFiles(fPath, destFilePath, file.Name, file.Name);
                        isFileCopied = true;
                    }
                }
                if (isFileCopied == false)
                {
                    string[] fileVal = fileName.Split(new[] { '-' }, 2);
                    string neFlname = string.Empty;
                    if (fileVal.Length > 1 && fileVal[0] == recId)
                        neFlname = fileVal[1].ToString();
                    else
                        neFlname = fileName;
                    AxGridAttNotExistList.Add(neFlname);
                }
            }
        }
    }
    private void GetReferedFiles(string dcfldValue, bool hasImagePath)
    {
        string destPath = scriptsPath + "axpert\\" + HttpContext.Current.Session["nsessionid"];
        string fldValue = string.Empty;
        string folderPath = string.Empty;
        string destFname = string.Empty;
        string grdAttPath = string.Empty;
        string referRecid = string.Empty;
        string referfNames = string.Empty;
        string[] referfNameOnebyOne;
        try
        {
            string[] fldValues = dcfldValue.Split('@');
            if (hasImagePath)
            {
                grdAttPath = GetImgServerPath();
                for (int i = 0; i < fldValues.Length; i++)
                {
                    //Eg:{@India\BLR\license.txt,release.txt}

                    if (fldValues[i] != string.Empty)
                    {
                        string[] fValues = fldValues[i].Split('(');
                        for (int indx = 0; indx < fValues.Length; indx++)
                        {
                            if (fValues[indx].ToString() != String.Empty)
                            {
                                string[] fvalue = fValues[indx].Split(',');
                            }
                        }
                        folderPath = fldValues[i].Substring(0, fldValues[i].LastIndexOf("\\"));
                        referfNames = fldValues[i].Substring(fldValues[i].LastIndexOf("\\") + 1);
                        if (hasImagePath)
                            grdAttPath = grdAttPath + "\\" + folderPath;
                    }
                }

            }
            else
            {
                //Eg : {@MyDocs\transid\fieldname,recordid(filename1,f2,f3)}

                grdAttPath = HttpContext.Current.Session["grdAttPath"].ToString();

                fldValue = dcfldValue.Substring(1, dcfldValue.Length - 1);
                fldValues = fldValue.Split(new[] { ',' }, 2);
                if (fldValues.Length > 1)
                {
                    grdAttPath += "\\" + fldValues[0].ToString();
                    int nFileSIndex = fldValues[1].IndexOf("(");
                    int nFileEIndex = fldValues[1].IndexOf(")") - 1;

                    referfNames = fldValues[1].Substring(nFileSIndex + 1, nFileEIndex - nFileSIndex);
                    referRecid = fldValues[1].Substring(0, nFileSIndex);
                }

            }
            //Copying Files to Session folder
            referfNameOnebyOne = referfNames.Split(',');
            for (int k = 0; k < referfNameOnebyOne.Length; k++)
            {
                if (referfNameOnebyOne[k] != "")
                    if (hasImagePath)
                        CopyFiles(grdAttPath, destPath, referfNameOnebyOne[k], referfNameOnebyOne[k]);
                    else
                    {
                        destFname = referRecid + "-" + referfNameOnebyOne[k];
                        CopyFiles(grdAttPath, destPath, destFname, destFname);
                    }
            }



        }
        catch (Exception ex)
        {
        }
    }

    #endregion
    //Function to check all images for the given record id and copy them to scripts folder.
    private void LoadImageToFolder(string fldName, string recId)
    {
        string tmpFldName = fldName;//.Substring(0, fldName.LastIndexOf("F") - 3);
        if (recId != "0")
        {
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            //scriptsPath += "axpert\\" + sessionid + "\\" + fldName;
            string scrPath = scriptsPath + "axpert\\" + sessionid + "\\" + fldName;
            string desFilePath = "", desFilePathOld = "";
            if (imgAttachPath != "")
            {
                desFilePathOld = imgAttachPath + "\\axpert\\" + transID + "\\" + recId + "\\" + fldName;
                desFilePath = imgAttachPath + "\\" + transID + "\\" + fldName;
            }
            else
            {
                desFilePath = scriptsPath + "axpert\\" + transID + "\\" + fldName;
                //desFilePath = scriptsPath + "axpert\\" + transID + "\\" + recId + "\\" + fldName;
            }
            string authenticationStatus = string.Empty;
            if (util.GetAuthentication(ref authenticationStatus))
            {
                DirectoryInfo di = new DirectoryInfo(desFilePath);
                if (!di.Exists)
                    di.Create();

                FileInfo[] fileEntries = di.GetFiles();
                //TODO: since the loop is breaking after the first loop, the i need not be incremented
                for (int i = 0; i < fileEntries.Length; i++)
                {
                    FileInfo file = (FileInfo)fileEntries[i];
                    //imageFldNames.Add(fldName);
                    string imgName = file.Name.Substring(0, file.Name.LastIndexOf('.'));
                    if (imgName == recId)
                    {
                        imageFldNames.Add(fldName);
                        string destValue = file.Name.Replace(imgName, recId);
                        if (File.Exists(desFilePath + "\\" + destValue))
                        {
                            imageFldSrc.Add(scriptsPath + "axpert\\" + sessionid + "\\" + destValue);
                            CopyFiles(desFilePath, scrPath, destValue, destValue);
                        }
                        else
                        {
                            DirectoryInfo diOld = new DirectoryInfo(desFilePathOld);
                            if (diOld.Exists)
                            {
                                FileInfo[] fileEntriesOld = diOld.GetFiles();
                                //TODO: since the loop is breaking after the first loop, the i need not be incremented
                                for (int j = 0; j < fileEntriesOld.Length; j++)
                                {
                                    FileInfo fileOld = (FileInfo)fileEntriesOld[j];
                                    imageFldNames.Add(fldName);
                                    imageFldSrc.Add(scriptsPath + "axpert\\" + sessionid + "\\" + fileOld.Name);
                                    CopyFiles(desFilePathOld, scrPath, fileOld.Name, fileOld.Name);
                                }
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    //Get the row numbers for the given dc no from the field array
    private ArrayList GetGridRowsFromArray(string frmNo)
    {
        ArrayList gridRows = new ArrayList();
        for (int k = 0; k < fieldControlName.Count; k++)
        {
            int fIndx = 0;
            fIndx = fieldControlName[k].ToString().LastIndexOf("F");
            string frameNo = fieldControlName[k].ToString().Substring(fIndx + 1);
            string rowNo = fieldControlName[k].ToString().Substring(fIndx - 3, 3);
            if (frameNo == frmNo)
            {
                int index = -1;
                index = gridRows.IndexOf(rowNo);
                if (index == -1)
                    gridRows.Add(rowNo);
            }
        }
        return gridRows;
    }

    //Function to get the concatenated string of parent field values in the pop grid dc. 
    private string GetParentValues(string[] popParentFlds, string rowNo, string frmNo)
    {
        return DSGetParentValues(popParentFlds, rowNo, frmNo);
    }

    //Function to get the concatenated string of parent field values in the pop grid dc. 
    private string DSGetParentValues(string[] popParentFlds, string rowNo, string frmNo)
    {
        string parFldVals = "";
        for (int j = 0; j < popParentFlds.Length; j++)
        {
            double fldNumber;
            string popFielsName = "sub" + frmNo + "_" + popParentFlds[j].Trim();
            string popFldValue = string.Empty;
            if (DSGetRow(rowNo, Convert.ToInt32(frmNo)).Table.Columns.Contains(popFielsName))
                popFldValue = DSGetRow(rowNo, Convert.ToInt32(frmNo))[popFielsName].ToString();
            else
            {
                popFielsName = "Sub" + frmNo + "_" + popParentFlds[j].Trim();
                popFldValue = DSGetRow(rowNo, Convert.ToInt32(frmNo))[popFielsName].ToString();
            }

            bool isNumber = double.TryParse(popFldValue, out fldNumber);
            if (isNumber == true)
            {
                double popVal = double.Parse(popFldValue);
                parFldVals += popVal.ToString();
            }
            else
            {
                parFldVals += popFldValue;
            }
        }
        return parFldVals;
    }

    public DataRow DSGetRow(string rowNo, int dcNo)
    {
        if (dcNo == 0) return null;
        DataTable dt = dsDataSet.Tables["dc" + dcNo];
        int rNo = Convert.ToInt32(rowNo);
        if (rNo == 0) rNo = 1;
        return dt.Rows.Find(rNo);
    }

    public DataRow DsGetRow(string fldName, string rowNo)
    {
        return DSGetRow(rowNo, tstStrObj.GetFieldDc(fldName));
    }


    public void GetKeyColValues(int dcNo, ArrayList arrKeyCols, ArrayList keyRowNos)
    {
        DSGetKeyColValues(dcNo, arrKeyCols, keyRowNos);
    }

    private void DSGetKeyColValues(int dcNo, ArrayList arrKeyCols, ArrayList arrKeyRowNos)
    {
        DataTable dt = dsDataSet.Tables["dc" + dcNo];
        foreach (DataRow dr in dt.Rows)
        {
            string keyValue = string.Empty;
            string keyRow = string.Empty;
            TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[dcNo - 1];
            keyValue = dr[dc.KeyColumn].ToString();
            keyRow = dr["axp__rowno"].ToString();
            int keyIndex = arrKeyCols.IndexOf(keyValue);
            if (keyIndex == -1)
            {
                arrKeyCols.Add(keyValue);
                arrKeyRowNos.Add(keyRow);
            }
            else
            {
                arrKeyRowNos[keyIndex] += "," + keyRow;
            }
        }
    }

    private int GetFldArrayIndex(string fieldName)
    {
        int index = -1;
        for (int cnt = 0; cnt < fieldControlName.Count; cnt++)
        {
            if (fieldControlName[cnt].ToString().ToLower() == fieldName.ToLower())
                index = cnt;
        }
        return index;
    }

    private void DeleteDefaultRowInPopDc(string project, string user, string transid, string sessionId, string AxRole)
    {

        ArrayList deleteRows = new ArrayList();
        bool isRowFound = false;
        for (int i = 0; i < tstStrObj.popdcs.Count; i++)
        {
            TStructDef.PopDcStruct popDc = (TStructDef.PopDcStruct)tstStrObj.popdcs[i];
            string[] popParentFlds = popDc.pfields.Split(',');

            TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[popDc.frameno - 1];

            if (popDc.pFirm == "t" || !dc.DCHasDataRows)
                continue;

            int rowCount = GetDcRowCount(dc.frameno.ToString());
            for (int k = 1; k < rowCount; k++)
            {
                for (int j = 0; j < popParentFlds.Length; j++)
                {
                    string prefix = "sub";
                    string popFielsName = prefix + popDc.frameno + "_" + popParentFlds[j].Trim() + GetRowNoHelper(k.ToString()) + "F" + popDc.frameno;
                    //int idx = GetFldIndex(dc.frameno, "sub" + popDc.frameno + "_" + popParentFlds[j].Trim(), k;                    
                    DataRow dr = DsGetRow(prefix + popDc.frameno + "_" + popParentFlds[j].Trim(), k.ToString());
                    if (dr == null)
                    {
                        prefix = "Sub";
                        DsGetRow(prefix + popDc.frameno + "_" + popParentFlds[j].Trim(), k.ToString());

                    }
                    if (dr != null)
                    {
                        string fldValue = dr[prefix + popDc.frameno + "_" + popParentFlds[j].Trim()].ToString();

                        if (fldValue == "" || fldValue == "***")
                        {
                            string rowNo = k.ToString();
                            if (rowNo != "-1")
                                deleteRows.Add(rowNo + "F" + popDc.frameno);
                            isRowFound = true;
                            break;
                        }
                    }
                }
                if (isRowFound)
                {
                    isRowFound = false;
                    break;
                }

            }
            for (int dCnt = 0; dCnt < deleteRows.Count; dCnt++)
            {
                int fIdx = deleteRows[dCnt].ToString().IndexOf("F");
                string delRowNo = deleteRows[dCnt].ToString().Substring(0, fIdx);
                string delDcNo = deleteRows[dCnt].ToString().Substring(fIdx + 1);
                if (GetDcRowCount(delDcNo) == 1 && delRowNo == "001")
                {
                    TStructDef.DcStruct pdc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(delDcNo) - 1];
                    pdc.DCHasDataRows = false;
                    tstStrObj.dcs[Convert.ToInt32(delDcNo) - 1] = pdc;
                    break;
                }
                DeleteRowInFldArrays(delDcNo, delRowNo);
                int tmpRowCnt = GetDcRowCount(delDcNo);
                tmpRowCnt = tmpRowCnt - 1;
                UpdateRowCount("DC" + delDcNo, "DC" + delDcNo + "~" + tmpRowCnt);
            }
        }
    }

    /// <summary>
    /// Function to be called to add group
    /// </summary>
    /// <param name="tstData"></param>
    /// <param name="fldArray"></param>
    /// <param name="fldDbRowNo"></param>
    /// <param name="fldValueArray"></param>
    /// <param name="fldDeletedArray"></param>
    /// <param name="s"></param>
    /// <param name="f"></param>
    /// <param name="source"></param>
    /// <param name="delRows"></param>
    /// <param name="changedRows"></param>
    /// <param name="frameNo"></param>
    /// <returns></returns>
    public string CallActionWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList deletedFldArrayValues, string s, string f, string source, string delRows, string changedRows, string frameNo, string calledFrom = "false", bool isScript = false)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        result = string.Empty;
        //GetGlobalVars();

        string cngRows = GetChangedRows(changedRows);
        delRows = GetDelRowsNode(delRows);
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        frameNo = (Convert.ToInt32(frameNo) - 1).ToString();

        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, frameNo, calledFrom, "ALL", "");


        s += tstData.fieldValueXml + memVarsData + "</row></varlist>" + delRows + cngRows;

        string AxErroCodeNode = string.Empty;
        AxErroCodeNode = util.GetAxvalErrorcode(transid);

        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);

        s += HttpContext.Current.Session["axApps"].ToString();
        s += HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + AxErroCodeNode + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";


        if (ires == null)
            ires = "";

        if (isScript)
        {
            filename = "Script-" + transid;
            logobj.CreateLog("Call to RemoteDoScript Web Service", sessionid, filename, "");

            //Call service
            objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.callRemoteDoScriptWS(transid, s, ires, tstData.tstStrObj.WebServiceTimeout);

        }
        else
        {
            filename = "Action-" + transid;
            logobj.CreateLog("Call to RemoteDoAction Web Service", sessionid, filename, "");


            //Call service
            objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.CallRemoteDoActionWS(transid, s, ires, tstData.tstStrObj.WebServiceTimeout);

        }
        if (result != null)
            result = result.Split('♠')[1];
        CheckSave(result, delRows, tstData, changedRows, deletedFldArrayValues);
        logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, "");
        return result;
    }

    public string CallActionWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList deletedFldArrayValues, string s, string f, string source, string delRows, string changedRows, string calledFrom = "false", StringBuilder files = null, bool isScript = false, string axRulesFlds = "", bool axRulesScript = false)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        result = string.Empty;
        if (source == "t")
        {
            string imagefromdb = "false";
            if (HttpContext.Current.Session["AxpSaveImageDb"] != null)
                imagefromdb = HttpContext.Current.Session["AxpSaveImageDb"].ToString();
            if (s != string.Empty)
                s = s.Replace("<root", "<root imagefromdb='" + imagefromdb + "'");
            string cngRows = GetChangedRows(changedRows);
            delRows = GetDelRowsNode(delRows);
            transid = tstData.transid.ToString();
            ires = tstStrObj.structRes;
            tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", calledFrom, "ALL", "");
            s += tstData.fldValueXml + memVarsData + "</row></varlist>" + delRows + cngRows;

            string AxErroCodeNode = string.Empty;
            AxErroCodeNode = util.GetAxvalErrorcode(transid);

            string dbmemvarsXML = GetDBMemVarsXML(transid);
            string cdVarsXML = GetConfigDataVarsXML(transid);
            bool isAxRulesScript = false;
            if (isScript && axRulesScript)
                isAxRulesScript = true;
            if (axRulesFlds != "" || (isAxRulesScript && axRulesFlds == ""))
            {
                s += GetAxRuleFlsXML(axRulesFlds, transid, isAxRulesScript);
            }
            s += HttpContext.Current.Session["axApps"].ToString();
            s += HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + AxErroCodeNode + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        }
        else
            ires = "";

        XmlDocument xmlDoc = new XmlDocument();
        string newfilename = "";
        if (f != "" && f.Contains("&"))
        {

            newfilename = f.Replace("&", "&amp;");

            s = s.Replace("__file=\"" + f.ToString() + "\"", "__file=\"" + newfilename.ToString() + "\"");//&amp

        }
        xmlDoc.LoadXml(s);
        XmlNode rootNode = xmlDoc.SelectSingleNode("//root");
        if (rootNode != null)
        {
            if (rootNode.Attributes["actname"].Value != string.Empty)
                AxActiveAction = rootNode.Attributes["actname"].Value;
        }

        if (ires == null)
            ires = "";
        if (isScript)
        {
            filename = "Script-" + transid;
            logobj.CreateLog("Call to RemoteDoScript Web Service", sessionid, filename, "");

            //Call service
            objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.callRemoteDoScriptWS(transid, s, ires, tstData.tstStrObj.WebServiceTimeout);

        }
        else
        {
            filename = "Action-" + transid;
            logobj.CreateLog("Call to RemoteDoAction Web Service", sessionid, filename, "");

            //Call service
            objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.CallRemoteDoActionWS(transid, s, ires, tstData.tstStrObj.WebServiceTimeout);
        }

        string requestProcess_logtime = result.Split('♠')[0];
        result = result.Split('♠')[1];
        //avoid special chars in result DURING notify
        if (result != "This proces taking time is more than expected. You will get a notification once completed")
            CheckSave(result, delRows, tstData, changedRows, deletedFldArrayValues, (files != null ? files.ToString() : ""));
        if (transid == "axrlr" && AxActiveAction == "iSave")//Delete tstruct cached keys for particular form On Save of AxRules
        {
            try
            {
                XmlNode stIdNode = xmlDoc.SelectSingleNode("//root/varlist/row/stransid");
                if (stIdNode != null && stIdNode.InnerText != "")
                {
                    FDW fdwObj = FDW.Instance;
                    FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                    if (fObj == null)
                        fObj = new FDR();
                    string fdData = Constants.REDISTSTRUCTALL;
                    var dbVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdData, stIdNode.InnerText));
                    fdwObj.DeleteKeys(dbVarKeys);

                    string fdMemVar = Constants.DBMEMVARSFORMLOAD;
                    var dbMemVarKeys = fObj.GetWildCardKeyNames(util.GetRedisServerkey(fdMemVar, stIdNode.InnerText, "*"));
                    fdwObj.DeleteKeys(dbMemVarKeys);
                }
            }
            catch (Exception ex) { }
        }
        AxActiveAction = string.Empty;
        logobj.CreateLog("End Time : " + DateTime.Now.ToString(), sessionid, filename, "");
        result = requestProcess_logtime + strExecTrace + "♠" + result;
        return result;
    }

    private void CheckSave(string result, string delRows, TStructData tstData, string changedRows, ArrayList deletedFldArrayValues, string files = "")
    {
        if (result == "") return;
        result = result.Replace("\\", ";bkslh");
        //To save the image fields in server folders, 
        //the below code checks if the action was 'save' and copies the images to the folders.

        string returnStr = result.Replace("*$*", "¿");
        string[] newResult = returnStr.Split('¿');
        for (int i = 0; i < newResult.Length; i++)
        {
            if (newResult[i].ToString() == "")
                continue;
            JArray action;
            try
            {
                JObject actionresult = JObject.Parse(newResult[i].ToString());
                action = (JArray)actionresult["command"];
            }
            catch (Exception ex)
            {
                throw ex;
            }

            if (action != null)
            {
                string cmd = string.Empty;
                string cmdVal = string.Empty;
                string pname = string.Empty;
                string pvalue = string.Empty;
                string showin = string.Empty;
                string recId = string.Empty;
                string actionValue = string.Empty;
                for (int m = 0; m < action.Count; m++)
                {
                    cmd = (string)action[m]["cmd"].ToString().Trim('"');

                    cmdVal = (string)action[m]["cmdval"].ToString().Trim('"');

                    if (cmd == "openiview")
                    {
                        pname = (string)action[m]["pname"].ToString().Trim('"');
                        pvalue = (string)action[m]["pvalue"].ToString().Trim('"');
                        showin = (string)action[m]["showin"].ToString().Trim('"');
                        AddParamsToSession(cmdVal, pname, pvalue, showin);
                    }


                    if (cmd == "action")
                        actionValue = cmdVal;
                    else if (cmd == "recid")
                        recId = cmdVal;
                }


                if (actionValue.ToLower() == "save")
                {
                    if (HttpContext.Current.Session["AxReloadCloud"] != null)
                    {
                        if (HttpContext.Current.Session["AxReloadCloud"].ToString() == transid)
                        {
                            try
                            {
                                HttpContext.Current.Session["IscloudRelogin"] = "true";
                                HttpContext.Current.Session["AxInternalRefresh"] = "true";
                                util.ClearAxpStructConfigInRedis(Constants.AXCONFIGGENERAL, "", "", "general", "");
                            }
                            catch (Exception ex)
                            {
                                HttpContext.Current.Session["IscloudRelogin"] = "true";
                                HttpContext.Current.Session["AxInternalRefresh"] = "true";
                                logobj.CreateLog("Main Page Reload-" + ex.Message, sessionid, "MainPageReload", "new", "true");
                            }
                        }
                    }

                    if (util.isRealTimeCacEnabled(transid, tstStrObj))
                        HttpContext.Current.Session["AxRelKeys"] = util.GetAxRelations(tstData.transid);
                    else
                        HttpContext.Current.Session["AxRelKeys"] = null;

                    if (recId != string.Empty)
                    {
                        if (tstStrObj.AxpFileUploadFields.Count > 0)
                            RemoveUnwantedAxpFiles(transid, recId, delRows, tstData, deletedFldArrayValues);

                        //TStructDef strObj = cm.GetStructDef(project, sessionid, user, transid, AxRole);
                        if (tstStrObj.ContainsImage)

                            SaveImageToFolder(tstStrObj, transid, sessionid, recId, deletedFldArrayValues);

                        if (tstStrObj.ContainsGridAttach)
                        {
                            strExecTrace = string.Empty;
                            try
                            {
                                string gridAttSaveResult = SaveGridAttachments(transid, sessionid, recId, delRows, tstData, changedRows, deletedFldArrayValues);
                            }
                            catch (Exception ex)
                            {
                                strExecTrace += "Exception in SaveGridAttachments:" + ex.Message + " ♦ ";
                                logobj.CreateLog("Error while SaveGridAttachments-" + ex.Message, sessionid, "SaveGridAttachments", "new", "true");
                            }
                        }

                        if (attachDir && (!string.IsNullOrEmpty(files) || removeFiles.Count > 0))
                            SaveAttached(files, recId);

                        ClearIviewDataKey();
                    }
                    RefFastDataOnSave(AxActiveAction);
                    RefInMemOnSave();
                }
            }
        }
    }

    private void RefFastDataOnSave(string taskName)
    {
        //If fast data refresh events are not empty
        FDW fobj = FDW.Instance;
        for (int i = 0; i < tstStrObj.fastDataRefEvent.Count; i++)
        {
            if (tstStrObj.fastDataRefEvent[i].ToString().Contains(taskName))
            {
                //TODO: Push refresh in Fastdata
                string dsName = string.Empty;
                dsName = tstStrObj.fastDataRefDSName[i].ToString();
                fobj.PushToDsRefresh(util.GetFastDataDSName(null, dsName));
                //objfd.RefreshFastDataset(dsName);
                //Thread thread = new Thread(() => objfd.PushRefreshDs(dsName, user));
                //thread.Start();               
            }
        }
    }

    private void AddParamsToSession(string ivName, string paramNames, string paramVals, string showIn)
    {

        string customIv = GetFieldValue("1", "axp_ivname");
        if (customIv != "")
            ivName = customIv;

        if (paramNames.IndexOf("###") != -1)
            paramNames = paramNames.Replace("###", "¿");

        if (paramVals.IndexOf("###") != -1)
            paramVals = paramVals.Replace("###", "¿");

        string[] strParams = paramNames.Split('¿');
        string[] strParamVals = paramVals.Split('¿');
        var paramsStr = "";
        int pCount = strParams.Length;
        Util.Util utilObj = new Util.Util();

        if (pCount != 0)
        {

            var paraName = ""; var paraVal = ""; var fres = "";
            for (var cmp = 0; cmp < pCount; cmp++)
            {
                paraName = strParams[cmp];
                paraVal = strParamVals[cmp];
                //paraVal = utilObj.CheckUrlSpecialChars(paraVal);
                paraVal = paraVal.Replace("=", "@eq@");
                fres = paraName + "=" + paraVal;
                fres = fres.Replace("&", "--.--");
                paramsStr = paramsStr + "&" + fres;
            }

        }
        if (showIn != "" && showIn == "pop")
            showIn = "&pop=true";
        paramsStr = paramsStr + showIn;
        //HttpContext.Current.Session["AxActionParams" + ivName] = paramsStr;
        //HttpContext.Current.Session["IviewNavigationData-" + ivName] = paramsStr;

        ASB.WebService webService = new ASB.WebService();

        webService.SetIviewNavigationData(paramsStr, ivName);
    }

    private string AddToken(string iXml)
    {
        string token = "";
        token = util.GetToken();
        HttpContext.Current.Session["axpToken"] = token;
        iXml = iXml.Replace("<sqlresultset ", "<sqlresultset token='" + token + "' ");
        return iXml;
    }

    public string GetRapidFieldValueXml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string rowNo, string fieldName)
    {
        string iXml = string.Empty;
        int idx = tstStrObj.GetFieldIndex(fieldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
        DSRapidFieldValueXML(frameNo, rowNo, fieldName, "Rapid", fld);

        if (fld.FldRapidAllParents != string.Empty)
            iXml = GetGlobalVarValues(fld.FldRapidAllParents);
        return iXml;
    }

    public string CallGetRapidDepFldWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string inputXml, string frameNo, string rowNo, string fieldName, string subGridInfo, string parentInfo)
    {
        DateTime stTime = DateTime.Now;
        string traceSep = GetTraceString(inputXml);
        if (traceSep != "") inputXml = traceSep;

        //insert token in the input xml
        inputXml = AddToken(inputXml);

        string result = null;
        transid = tstData.transid.ToString();
        AxActDepField = fieldName;
        int idx = tstStrObj.GetFieldIndex(fieldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        bool isDcGrid = false;
        Dictionary<string, string> IncludeDcRows = new Dictionary<string, string>();
        isDcGrid = IsDcGrid(frameNo, tstStrObj);
        logobj.CreateLog("Constructing input xml GetRapidDepFLd-field" + fld.name, sessionid, "GetRapidDep-" + transid, "new");
        UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
        DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
        DSRapidFieldValueXML(frameNo, rowNo, fieldName, "RapidDep", fld);
        if (fld.FldRapidAllParents != string.Empty)
            inputXml += GetGlobalVarValues(fld.FldRapidAllParents);
        inputXml += tstData.fieldValueXml + memVarsData;
        inputXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString();
        inputXml += "</sqlresultset>";
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        logobj.CreateLog("Input xml GetRapidDepFLd=" + inputXml, sessionid, "GetRapidDep-" + transid, "");
        DateTime asStart = DateTime.Now;
        result = objWebServiceExt.CallGetRapidDepFldVals(transid, inputXml);
        logobj.CreateLog("RapidGetDepentendFieldValues Result=" + result, sessionid, "GetRapidDep-" + transid, "");
        DateTime asEnd = DateTime.Now;
        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }

    private string GetGlobalVarValues(string parentFlds)
    {
        StringBuilder paramsNode = new StringBuilder();
        paramsNode.Append("<params>");
        List<string> paramFlds = parentFlds.Split(',').ToList();

        for (int j = 0; j < paramFlds.Count; j++)
        {
            for (int i = 0; i < tstStrObj.lstGlobalParams.Count; i++)
            {
                string[] strVar = tstStrObj.lstGlobalParams[i].ToString().Split('=');
                string value = CheckSpecialChars(strVar[1].ToString());
                string pName = paramFlds[j].ToString();
                if (strVar[0].ToString() == pName)
                {
                    paramsNode.Append("<" + pName + ">" + value + "</" + pName + ">");
                }
            }
        }

        if (HttpContext.Current.Session["user"] != null)
            paramsNode.Append("<username>" + HttpContext.Current.Session["user"].ToString() + "</username>");

        paramsNode.Append("</params>");
        return paramsNode.ToString();
    }

    public string CallGetDepFldWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string frameNo, string rowNo, string fieldName, string subGridInfo, string parentInfo)
    {
        DateTime stTime = DateTime.Now;
        string news = GetTraceString(s);
        if (news != "") s = news;
        string result = null;
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        AxActDepField = fieldName;
        int idx = tstStrObj.GetFieldIndex(fieldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        ArrayList AxDepFields = new ArrayList();
        bool isDcGrid = false;
        Dictionary<string, string> IncludeDcRows = new Dictionary<string, string>();
        isDcGrid = IsDcGrid(frameNo, tstStrObj);

        if (isDcGrid)
        {
            string DepFlds = fld.fieldSqlDepParents;
            AxDepFields = GetParDepFlds(fld.fieldSqlDepParents);
        }

        if (fld.fieldSqlGridDeps != string.Empty)
        {
            string[] strSDeps = fld.fieldSqlGridDeps.Split(',');
            for (int i = 0; i < strSDeps.Length; i++)
            {
                AxDepFields.Add(strSDeps[i].ToString());
            }

            //The below statement will add the current field to the dependent fields if the current dc is a grid dc 
            //and it has dependents in other grid, then all the row values for the field should be sent in the input xml.
            if (isDcGrid)
                AxDepFields.Add(fld.name);
        }


        //If the field has non grid sql dependents, then send the parent values for that dep field also
        if (IsDcGrid(frameNo, tstStrObj))
        {

            //If the call is made from a parent grid, then all its subgriud and their respective rows for the given parent row 
            //will be sent in the given format: dcno~rowno1,rowno2¿dcno~rowno1,rowno2...
            if (subGridInfo != "")
            {
                if (subGridInfo.IndexOf("¿") != -1)
                {
                    string[] subgridDcs = subGridInfo.Split('¿');
                    for (int i = 0; i < subgridDcs.Length; i++)
                    {
                        if (subgridDcs[i] != string.Empty)
                        {
                            string[] dcInfo = subgridDcs[i].ToString().Split('~');
                            IncludeDcRows.Add(dcInfo[0], dcInfo[1]);
                        }
                    }
                }
                else
                {
                    IncludeDcRows.Add(subGridInfo.Substring(0, subGridInfo.IndexOf("~")), subGridInfo.Substring(subGridInfo.IndexOf("~") + 1));
                }
            }

            //If the call is made from sub grid, then the parentinfo will contain the parent dc no and parent row no in the given format : dcno~rowno
            if (parentInfo != "")
            {
                IncludeDcRows.Add(parentInfo.Substring(0, parentInfo.IndexOf("~")), parentInfo.Substring(parentInfo.IndexOf("~") + 1));
            }


            //first update the list with the new fldArray.
            UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);

            DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);

            CreateFieldValueXmlPerf(frameNo, rowNo, AxDepFields, fld.fieldDepGridDcs, IncludeDcRows, "");

            //Refer bug - AGI003591
            //This function was converting the last invalid row to valid row
            //UpdateGridDelRowVal(int.Parse(frameNo));

            s += tstData.fieldValueXml;
        }
        else
        {

            if (AxDepFields.Count > 0)
            {
                //if a non grid fields has dependent grid dc fields, then send that dc fields data also.            
                //first update the list with the new fldArray.
                UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
                DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
                CreateFieldValueXmlPerf(frameNo, rowNo, AxDepFields, fld.fieldDepGridDcs, IncludeDcRows, "");
                s += tstData.fieldValueXml;
            }
            else
            {
                //if (fld.fieldDepFillDcs != string.Empty)
                //{
                //    string[] depFillDcs = fld.fieldDepFillDcs.Split(',');
                //    for (int dIdx = 0; dIdx < depFillDcs.Length; dIdx++)
                //    {
                //        TStructDef.DcStruct depDc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(depFillDcs[dIdx].ToString()) - 1];

                //    }
                //}


                //if a non grid fields has dependent grid Fill grid dc, then send that dc data also.  
                //TODO: this condition should not send all the fillgrid dep dc data
                tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "GetDependents", "NG", fld.fieldDepFillDcs);
                s += tstData.fieldValueXml;
            }
        }

        s += memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();

        DateTime asStart = DateTime.Now;
        result = objWebServiceExt.CallGetDepentendFieldValuesWS(transid, s, ires);
        DateTime asEnd = DateTime.Now;
        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }

    public string CallGetDepFldPerfWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, ArrayList regVarFldList, string s, string frameNo, string rowNo, string perfDepFldName, string fieldName, string subGridInfo, string parentInfo, ArrayList acceptExpressionFlds)
    {
        DateTime stTime = DateTime.Now;
        string news = GetTraceString(s);
        if (news != "") s = news;
        string result = null;
        transid = tstData.transid.ToString();
        AxActDepField = fieldName;
        ires = tstStrObj.structRes;
        tstData.GetPerfFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "GetDependents", "NG", "");

        string imagefromdb = "false";
        if (HttpContext.Current.Session["AxpSaveImageDb"] != null)
            imagefromdb = HttpContext.Current.Session["AxpSaveImageDb"].ToString();
        if (s != string.Empty)
            s = s.Replace("<sqlresultset", "<sqlresultset imagefromdb='" + imagefromdb + "'");
        s += PerfGetDepFldInput(fieldName, perfDepFldName, frameNo, rowNo, acceptExpressionFlds);
        s += memVarsData;
        if (regVarFldList.Count > 0)
        {
            string regVarXml = "";
            try
            {
                foreach (var varVal in regVarFldList)
                {
                    regVarXml += "<" + varVal.ToString().Split(':')[0] + " t='" + varVal.ToString().Split(':')[1] + "'>" + varVal.ToString().Split(':')[2] + "</" + varVal.ToString().Split(':')[0] + ">";
                }
            }
            catch (Exception ex) { }
            s += regVarXml;
        }
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        DateTime asStart = DateTime.Now;
        result = objWebServiceExt.CallGetDepentendFieldValuesWS(transid, s, ires);
        DateTime asEnd = DateTime.Now;
        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }


    public string PerfGetDepFldInput(string fieldName, string perfDepFldName, string frameNo, string rowNo, ArrayList acceptExpressionFlds)
    {
        string inputFldXML = string.Empty;
        try
        {
            int dfIndx = tstStrObj.GetFieldIndex(fieldName);
            TStructDef.FieldStruct dfld = (TStructDef.FieldStruct)tstStrObj.flds[dfIndx];
            string[] parentFlds = dfld.fieldParents.Replace("~", ",").Split(',');// a66 node of dependent field
            string[] parentDcFlds = new string[] { };
            if (perfDepFldName.StartsWith("dc"))
            {
                try
                {
                    int dcFrame = int.Parse(perfDepFldName.Substring(2));
                    TStructDef.DcStruct pfldDc = (TStructDef.DcStruct)tstStrObj.dcs[dcFrame - 1];
                    if (pfldDc.dcPList != "")
                        parentDcFlds = pfldDc.dcPList.Replace("~", ",").Split(',');
                }
                catch (Exception ex) { }
            }
            string[] lstparentFlds = parentFlds.Union(parentDcFlds).ToArray();
            string globalVars = HttpContext.Current.Session["axGlobalVars"].ToString();
            string userVars = HttpContext.Current.Session["axUserVars"].ToString();
            TStructDef.DcStruct dfldDc = (TStructDef.DcStruct)tstStrObj.dcs[dfld.fldFrameNo - 1];
            for (int i = 0; i < lstparentFlds.Length; i++)
            {
                int arNumber = 0;
                int pIndx = tstStrObj.GetFieldIndex(lstparentFlds[i]);
                if (pIndx == -1)
                {
                    if (globalVars.ToLower().IndexOf("<" + lstparentFlds[i].ToLower() + ">") > -1)
                        continue;
                    else if (userVars.ToLower().IndexOf("<" + lstparentFlds[i].ToLower() + ">") > -1)
                        continue;
                    else
                        continue;
                }
                TStructDef.FieldStruct pfld = (TStructDef.FieldStruct)tstStrObj.flds[pIndx];
                TStructDef.DcStruct pfldDc = (TStructDef.DcStruct)tstStrObj.dcs[pfld.fldFrameNo - 1];
                //if (pfld.fldFrameNo == dfld.fldFrameNo && dfldDc.isgrid) // Dependent & Parent fields both are in same dc and the dc is grid dc should take active row only
                //    arNumber = int.Parse(rowNo);

                bool isAcceptExp = false;
                if (acceptExpressionFlds.IndexOf(pfld.name) > -1)
                    isAcceptExp = true;

                if (pfldDc.isgrid && pfldDc.DCHasDataRows)// Grid dc field should have 1 row minimum else the field not required in input 
                    inputFldXML += PerfGetDepFldValues(pfld.fldFrameNo, arNumber, "GetDep", pfld, isAcceptExp);
                else if (!pfldDc.isgrid)// Should take all the non grid dc fields following teh parents. 
                    inputFldXML += PerfGetDepFldValues(pfld.fldFrameNo, arNumber, "GetDep", pfld, isAcceptExp);
            }
        }
        catch (Exception ex)
        {
            logobj.CreateLog("PerfGetDepFldInput function -" + ex.Message, sessionid, "Exception-" + transid, "");
        }
        return inputFldXML;
    }

    private string PerfGetDepFldValues(int dcNo, int arNumber, string calledFrom, TStructDef.FieldStruct fld = new TStructDef.FieldStruct(), bool isAcceptExp = false)
    {
        string iXml = string.Empty;
        TStructDef.DcStruct pfldDc = (TStructDef.DcStruct)tstStrObj.dcs[dcNo - 1];
        DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
        string dcNumber = dcNo.ToString();
        string isGrdVld = string.Empty;
        foreach (DataRow dr in thisDataTable.Rows)
        {
            int rowNo = Convert.ToInt32(dr["axp__rowno"]);
            if (pfldDc.isgrid)//Refer Bug:AGI004107
                isGrdVld = dr["axp__isGrdVld" + dcNo].ToString();
            if (isGrdVld != "false")
            {
                DataTable dtOld = dsDataSet.Tables["dc_old" + dcNo];
                DataRow drOld = dtOld.Rows.Find(rowNo);
                string value = string.Empty;
                string oldValue = string.Empty;
                string idValue = string.Empty;
                string oldIdValue = string.Empty;
                value = dr[fld.name].ToString();
                if (fld.savenormal)
                    idValue = dr["id__" + fld.name].ToString();

                if (drOld != null)
                {
                    oldValue = drOld["old__" + fld.name].ToString();
                    if (fld.savenormal)
                        oldIdValue = drOld["oldid__" + fld.name].ToString();
                }
                if (calledFrom == "GetDep" && isAcceptExp)
                    value = "";
                iXml += WsPerfFieldToXML(fld.name, Convert.ToString(rowNo), value, oldValue, idValue, oldIdValue, dcNumber, fld.savenormal, fld);
            }
        }
        return iXml;
    }

    public string CallRefreshDc(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string iXml, string frameNo, string includeDcs)
    {
        string strTrace = GetTraceString(iXml);
        if (strTrace != "") iXml = strTrace;
        string result = string.Empty;
        ires = tstStrObj.structRes;
        GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "RefreshDc", "NG", includeDcs);
        iXml += fieldValueXml + memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        iXml += "</sqlresultset>";
        //Call service     
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallRefreshDc(iXml, ires);
        return result;
    }

    private ArrayList GetParDepFlds(string depStr)
    {
        ArrayList arrDeps = new ArrayList();
        string[] depFlds = depStr.Split(',');
        for (int i = 0; i < depFlds.Length; i++)
        {
            arrDeps.Add(depFlds[i].ToString());
        }
        return arrDeps;
    }

    public string GetVisibleFormatGridsHtml(TStructDef strObj, string visibleDCsStr)
    {
        string[] visibleDCs = visibleDCsStr.Split(',');

        StringBuilder strDcHtml = new StringBuilder();
        for (int i = 0; i < visibleDCs.Length; i++)
        {
            string dcStr = visibleDCs[i].ToString().Substring(2);
            int dcNo = Convert.ToInt32(dcStr);
            if (depFormatDcs.IndexOf(dcStr) != -1 && ChangedDcs.IndexOf(dcStr) != -1)
                try
                {
                    strDcHtml.Append(strObj.GetTabDcHTML(dcNo, this, "false"));
                }
                catch (Exception ex)
                {

                }
        }

        return strDcHtml.ToString();
    }

    public string CallMsFillGrid(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string s, string paramXml, string fgName)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        string result = null;
        //GetGlobalVars();
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;

        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "FillGrid", "NG", "");

        s += tstData.fieldValueXml + memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";

        #region Data cache in session
        //var dcFsg = tstStrObj.fgs.Cast<TStructDef.FGStruct>().Where(f => f.fgtargetdc == ("dc" + frameNo) && f.fgName == fgName).ToList();
        //string fgSqlParam = string.Empty, fgSqlParamVal = string.Empty;
        //if (dcFsg.Count > 0)
        //{
        //    TStructDef.FGStruct fg = ((TStructDef.FGStruct)dcFsg[0]);
        //    fgSqlParam = fg.fgSqlParams;
        //    if (fgSqlParam != string.Empty)
        //    {
        //        XmlDocument xml = new XmlDocument();
        //        xml.LoadXml(s.ToLower());
        //        foreach (var name in fgSqlParam.Split(','))
        //        {
        //            var xnList = xml.SelectNodes("/sqlresultset/" + name);
        //            foreach (XmlNode text in xnList)
        //                fgSqlParamVal += "~" + name + ":" + text.InnerText.ToLower();
        //        }
        //    }
        //}
        //if (HttpContext.Current.Session["FillGrid-" + transid + "-" + fgName + "-" + fgSqlParamVal] != null)
        //    result = HttpContext.Current.Session["FillGrid-" + transid + "-" + fgName + "-" + fgSqlParamVal].ToString();
        //else
        //{
        //    //Call service
        //    objWebServiceExt = new ASBExt.WebServiceExt();
        //    result = objWebServiceExt.CallGetFillGridValuesWS(transid, s, ires);
        //    HttpContext.Current.Session["FillGrid-" + transid + "-" + fgName + "-" + fgSqlParamVal] = result;
        //}
        #endregion
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallGetFillGridValuesWS(transid, s, ires);
        return result;
    }

    public string GetCacheFileRecId(string recId)
    {
        string recIddataJson = "{\"data\": [";

        recIddataJson += "{\"n\":\"DC1\",\"v\":\"1\",\"t\":\"dc\"},{\"n\":\"recid\",\"v\":\"" + recId + "\",\"r\":\"0\",\"t\":\"s\"}]}";
        DSSubmit("recid", 0, recId, "");
        return recIddataJson;
    }

    /// <summary>
    /// Function to return the Fill pop up html for the format fill grid.
    /// </summary>
    /// <param name="result"></param>
    /// <param name="strObj"></param>
    /// <param name="dcNo"></param>
    /// <param name="src"></param>
    /// <returns></returns>
    public string ConstructFormatFillGrid(string result, TStructDef strObj, string dcNo, string src)
    {
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(result);
        int m = 0;
        string fgRows = "";
        string cRows = "";
        string headRow = "";
        string chkboxVal = "";
        int colcount = 0;
        string fgHTML = string.Empty;
        XmlNodeList headNodes;
        int rowCnt = 0;
        string firstColValue = string.Empty;
        headNodes = xmlDoc.SelectNodes("//response/row");
        TStructDef.DcStruct dc = ((TStructDef.DcStruct)(strObj.dcs[Convert.ToInt32(dcNo) - 1]));
        foreach (XmlNode resNode in headNodes)
        {
            colcount = 0;
            rowCnt = rowCnt + 1;
            XmlNodeList headers = resNode.ChildNodes;
            foreach (XmlNode hdrNode in headers)
            {
                colcount = colcount + 1;
                string selColName = hdrNode.Name.ToLower();
                int hIndex = dc.HideColumns.IndexOf(selColName);

                if (hIndex == -1 && selColName != "nselection" && selColName != "cselection" && selColName != "dselection")
                {
                    if (rowCnt == 1)
                    {
                        headRow = headRow + "<th>" + hdrNode.Name + "</th>";
                    }
                    cRows = cRows + "<td class='fgData'><label>" + hdrNode.InnerText + "</label></td>";
                }

                if (selColName.ToLower() == dc.MapColumn)
                {
                    firstColValue = hdrNode.InnerText;
                }
                if (dc.Action != "")
                {
                    if (selColName.Substring(1, selColName.Length - 1) == "selection")
                    {
                        if (chkboxVal == "")
                            chkboxVal = selColName + "♣" + hdrNode.InnerText;
                        else
                            chkboxVal += "¿" + selColName + "♣" + hdrNode.InnerText;
                    }
                }
                else
                {
                    if (selColName == dc.KeyColumn)
                    {
                        if (chkboxVal == "")
                            chkboxVal = selColName + "♣" + hdrNode.InnerText;
                        else
                            chkboxVal += "¿" + selColName + "♣" + hdrNode.InnerText;
                    }
                }
            }

            string keyColName = dc.KeyColumn;
            if (dc.MapParentCol != string.Empty)
                keyColName = dc.MapParentCol;
            else
                keyColName = dc.KeyColumn;

            if (firstColValue != "" && IsDupKeyColValue(keyColName, dcNo, firstColValue))
            {
                fgRows = fgRows + "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox disabled='disabled' name='chkItem' " + m + "  value=\"" + chkboxVal + "\" onclick='javascript:ChkHdrCheckbox(this,\"t\");' ></span></td>" + cRows + "</tr>";
            }
            else
                fgRows = fgRows + "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox name='chkItem' " + m + "  value=\"" + chkboxVal + "\" onclick='javascript:ChkHdrCheckbox(this,\"t\");' ></span></td>" + cRows + "</tr>";

            cRows = "";
            chkboxVal = "";
        }

        if (fgRows.ToString() != "")
        {
            if (src == "add")
                //fgHTML = "<div style=\"overflow: auto;\"><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' onclick=\"javascript:CheckAll(this,'t');\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
                fgHTML = "<div><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' onclick=\"javascript:CheckAll(this,'t');\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
            else
                //fgHTML = "<div style=overflow: auto;\"><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' onclick=\"javascript:CheckAll(this,'t');\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
                fgHTML = "<div><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' onclick=\"javascript:CheckAll(this,'t');\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
            if (src == "add")
                fgHTML += "<div><center><input class='hotbtn btn' type='button' value='Ok' onclick=\"javascript:ProcessAddGroup('" + dcNo + "')\"/></center></div></div>";
            else
            {
                if (dc.Action == "")
                    fgHTML += "<div><center><input class='hotbtn btn' type='button' value='Ok' onclick=\"javascript:ProcessFormatStaticFill('" + dcNo + "')\"/></center></div></div>";
                else
                    fgHTML += "<div><center><input class='hotbtn btn' type='button' value='Ok' onclick=\"javascript:ProcessFormatFill('" + dcNo + "')\"/></center></div></div>";
            }
        }
        else
            fgHTML = "<label>" + Constants.REC_NOT_FOUND + "</label>";

        return fgHTML;
    }

    /// <summary>
    /// Function to check if the key column value already exists in the field arrays.
    /// </summary>
    /// <param name="keyColName"></param>
    /// <param name="dcNo"></param>
    /// <param name="currFldvalue"></param>
    /// <returns></returns>
    public bool IsDupKeyColValue(string keyColName, string dcNo, string currFldvalue)
    {
        bool IsDupValue = false;

        int rCnt = GetDcRowCount(dcNo);

        for (int i = 1; i <= rCnt; i++)
        {
            string FldValue = string.Empty;
            if (DSGetRow(i.ToString(), Convert.ToInt32(dcNo))[keyColName] != null)
                FldValue = DSGetRow(i.ToString(), Convert.ToInt32(dcNo))[keyColName].ToString();

            if (FldValue == currFldvalue)
            {
                IsDupValue = true;
                break;
            }
        }

        return IsDupValue;
    }

    /// <summary>
    /// Function to return the index of the fill grid from the fill grid struct.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <returns></returns>
    private int GetDcFillGridIndex(string dcName, string fillGridName)
    {
        if (fillGridName == string.Empty)
        {
            for (int i = 0; i < tstStrObj.fgs.Count; i++)
            {
                TStructDef.FGStruct fg = (TStructDef.FGStruct)tstStrObj.fgs[i];
                if (fg.fgtargetdc.ToLower() == dcName.ToLower())
                {
                    return i;
                }
            }
        }
        else
        {
            for (int i = 0; i < tstStrObj.fgs.Count; i++)
            {
                TStructDef.FGStruct fg = (TStructDef.FGStruct)tstStrObj.fgs[i];
                if (fg.fgName.ToLower() == fillGridName.ToLower())
                {
                    return i;
                }
            }
        }
        return -1;
    }

    /// <summary>
    /// Function to construct the fill grid pop up html for the given dc.
    /// </summary>
    /// <param name="iXml"></param>
    /// <param name="dcNo"></param>
    /// <param name="strObj"></param>
    /// <param name="tstData"></param>
    /// <param name="src"></param>
    /// <returns></returns>
    public string ConstructFillGrid(string iXml, string dcNo, string fgName, TStructDef strObj, TStructData tstData, string src, string expResult)
    {
        string fgHTML = "";
        expResult = expResult.ToLower();
        string chkChecked = string.Empty;

        if (expResult == "t" || expResult == "true")
            //TODO: to avoid default selection of all items, we have made it unchecked always
            //chkChecked = "checked";
            chkChecked = "";
        else
            chkChecked = "";

        if (iXml.Contains(Constants.ERROR))
        {
            string errMsg = tstData.GetErrorInResultJson(iXml);
            if (errMsg != "")
                fgHTML = "<label>" + errMsg + "</label>";
            else
                fgHTML = "<label>" + Constants.REC_NOT_FOUND + "</label>";
        }
        else
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(iXml);
            int m = 0;
            string fgRows = "";
            bool allrowSelected = false;
            string cRows = "";
            string headRow = "";
            string chkboxVal = "";
            string fgtlhw = "";
            int colcount = 0;
            XmlNodeList headNodes;
            List<string> headerCaption = new List<string>();
            List<string> headerNode = new List<string>();
            int hdrCnt = 0;
            headNodes = xmlDoc.SelectNodes("//response/headrow");
            foreach (XmlNode resNode in headNodes)
            {
                if (resNode.Attributes["tlhw"] != null)
                {
                    fgtlhw = resNode.Attributes["tlhw"].Value;
                }
                XmlNodeList headers = resNode.ChildNodes;
                foreach (XmlNode hdrNode in headers)
                {
                    for (int i = 0; i < strObj.fgs.Count; i++)
                    {
                        TStructDef.FGStruct fg = (TStructDef.FGStruct)strObj.fgs[i];
                        if (fg.fgtargetdc == "dc" + dcNo && fg.fgName == fgName)
                        {
                            string colWidth = "50";
                            if (hdrNode.Attributes["width"] != null)
                            {
                                colWidth = hdrNode.Attributes["width"].Value;
                            }
                            // string colWidth = strObj.GetColumnWidth(dcNo, fg.fgDcFldName[j].ToString());
                            //string colWidth = strObj.GetColumnWidth(dcNo, hdrNode.Name);
                            if (!string.IsNullOrEmpty(hdrNode.InnerText) && (hdrNode.InnerText.ToLower() == "hide" || hdrNode.InnerText.ToLower().StartsWith("hide_")))
                                headRow = headRow + "<th style='display:none;'>" + hdrNode.InnerText + "</th>";
                            else
                                headRow = headRow + "<th width=\"" + colWidth + "\">" + hdrNode.InnerText + "</th>";
                            headerCaption.Add(hdrNode.InnerText);
                            headerNode.Add(hdrNode.Name);
                            hdrCnt++;
                            break;
                        }
                    }
                }
            }

            DataTable fgData = dsDataSet.Tables["dc" + dcNo];
            XmlNodeList dataNodes;
            dataNodes = xmlDoc.SelectNodes("//response/row");
            string fgCondition = string.Empty; //APPEND
            foreach (XmlNode dataNode in dataNodes)
            {
                XmlNodeList baseDataNodes = dataNode.ChildNodes;
                ArrayList ExitFld = new ArrayList();
                ArrayList ExitFldVal = new ArrayList();
                foreach (XmlNode baseDataNode in baseDataNodes)
                {

                    colcount = colcount + 1;

                    for (int i = 0; i < strObj.fgs.Count; i++)
                    {
                        TStructDef.FGStruct fg = (TStructDef.FGStruct)strObj.fgs[i];
                        if (fg.fgtargetdc == "dc" + dcNo && fg.fgName == fgName)
                        {
                            fgCondition = fg.FGCondition;
                            string strVal = CheckSpecialChars(baseDataNode.InnerText);
                            for (int j = 0; j < fg.fgSqlFldName.Count; j++)
                            {
                                if (fg.fgSqlFldName[j].ToString().ToLower() == baseDataNode.Name.ToLower())
                                {
                                    ExitFld.Add(fg.fgDcFldName[j]);
                                    ExitFldVal.Add(strVal);
                                    break;
                                }
                            }
                            if (headerNode.IndexOf(baseDataNode.Name) != -1 && !string.IsNullOrEmpty(headerCaption[headerNode.IndexOf(baseDataNode.Name)]) && (headerCaption[headerNode.IndexOf(baseDataNode.Name)].ToLower() == "hide" || headerCaption[headerNode.IndexOf(baseDataNode.Name)].ToLower().StartsWith("hide_")))
                                cRows = cRows + "<td style='display:none;'><label>" + strVal + "</label></td>";
                            else
                                cRows = cRows + "<td class='fgData'><label>" + strVal + "</label></td>";

                            if (fg.fgSqlFldName.IndexOf(baseDataNode.Name.ToLower()) != -1)
                            {
                                if (chkboxVal == "")
                                    chkboxVal = baseDataNode.Name + "♣" + strVal;
                                else
                                    chkboxVal += "¿" + baseDataNode.Name + "♣" + strVal;
                            }
                        }
                    }
                }

                if (fgData.Rows.Count > 0 && fgCondition == "APPEND")
                {
                    bool rowExit = false;
                    var fgData1 = fgData;
                    for (int i = 0; i < ExitFld.Count; i++)
                    {
                        try
                        {
                            fgData1 = fgData1.AsEnumerable().Where(r => r.Field<string>(ExitFld[i].ToString()) == ExitFldVal[i].ToString()).CopyToDataTable();
                            rowExit = true;
                        }
                        catch (Exception ex)
                        {
                            rowExit = false;
                            break;
                        }
                    }
                    if (!rowExit)
                        fgRows = fgRows + "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox " + chkChecked + " name='chkItem' " + m + "  value=\"" + chkboxVal + "\" onclick='javascript:ChkHdrCheckbox(this," + "\"" + expResult + "\"" + ");' ></span></td>" + cRows + "</tr>";
                    else
                        allrowSelected = true;
                }
                else
                    fgRows = fgRows + "<tr><td width='15'><span class=tem1><input class='fgChk' type=checkbox " + chkChecked + " name='chkItem' " + m + "  value=\"" + chkboxVal + "\" onclick='javascript:ChkHdrCheckbox(this," + "\"" + expResult + "\"" + ");' ></span></td>" + cRows + "</tr>";
                cRows = "";
                chkboxVal = "";

            }
            if (fgRows.ToString() != "")
            {
                //fgHTML = "<div style=\"overflow: auto;\"><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' " + chkChecked + " onclick=\"javascript:CheckAll(this, " + "'" + expResult + "'" + ");\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
                fgHTML = "<div><table id='tblFillGrid" + dcNo + "' class='gridData customSetupTableMN'><thead><tr><th width=\"15\"><input type=checkbox name='chkall' class='fgHdrChk' id='chkall' " + chkChecked + " onclick=\"javascript:CheckAll(this, " + "'" + expResult + "'" + ");\" ></th>" + headRow + "</tr></thead><tbody>" + fgRows + "</tbody></table>";
                fgHTML += "</div>";
                fgHTML += "*♠*" + fgtlhw;
            }
            else if (allrowSelected)
                fgHTML = "<label>" + Constants.SEL_ROWS_FOUND + "</label>";
            else
                fgHTML = "<label>" + Constants.REC_NOT_FOUND + "</label>";

        }
        return fgHTML;
    }

    /// <summary>
    /// Function to get the fill grid data for the selected rows in the fill grid pop up.
    /// </summary>
    /// <param name="tstData"></param>
    /// <param name="fldArray"></param>
    /// <param name="fldDbRowNo"></param>
    /// <param name="fldValueArray"></param>
    /// <param name="fldDeletedArray"></param>
    /// <param name="frameNo"></param>
    /// <param name="s"></param>
    /// <returns></returns>
    public string CallGetFillGridWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNo, string s)
    {
        DateTime stTime = DateTime.Now;
        string result = null;
        string dcNo = frameNo;
        //GetGlobalVars();
        frameNo = Convert.ToString(Convert.ToInt32(frameNo) + 1);
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        //tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, frameNo, "FillGrid", "NG", dcNo);
        tstData.GetPerfFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, frameNo, "FillGrid", "NG", dcNo);
        s += "<FieldList>" + WsPerfAddRowLoadDc(dcNo, "FillGrid") + memVarsData + "</FieldList>" + HttpContext.Current.Session["axApps"].ToString();
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString() + "</sqlresultset>";
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        DateTime asStart = DateTime.Now;

        string isRapidCall = "false";
        if ((HttpContext.Current.Session["RapidTsTruct"] != null && HttpContext.Current.Session["RapidTsTruct"].ToString() == "true") && (HttpContext.Current.Session["AxIsPerfCode"] != null && HttpContext.Current.Session["AxIsPerfCode"].ToString().ToLower() == "true"))
            isRapidCall = "true";
        if (isRapidCall == "true")
        {
            s = AddToken(s);
            result = objWebServiceExt.CallRapidDoFillGridValuesWS(transid, s);
        }
        else
        {
            result = objWebServiceExt.CallDoFillGridValuesWS(transid, s, ires);
        }

        DateTime asEnd = DateTime.Now;

        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }

    public string CallCreatePDFWS(string s)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        string result = null;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallCreatePDFWS(transid, s);
        return result;
    }

    public string CallCreateFastPDFWS(string s)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        string result = null;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallCreateFastPDFWS(transid, s, tstStrObj.structRes);
        return result;
    }

    public string CallViewAttachWS(string s, string structXml)
    {
        string result = string.Empty;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        try
        {
            if (attachDir)
                result = GetViewAttachment(s);
            if (result == string.Empty)
                result = objWebServiceExt.CallViewAttachmentsWS(transid, s, structXml);

            if (result != string.Empty)
            {
                JObject res = null;
                JArray command = null;
                try
                {
                    res = JObject.Parse(result);
                    command = (JArray)res["command"];
                    JObject item = (JObject)command[0];
                    item.Add(new JProperty("isatt", "T"));
                    result = res.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    //copy files from local to script
    public string GetViewAttachment(string inputXML)
    {
        string result = string.Empty;
        //CommonDir directory creation taken back due to application server memory usage.
        //if (!attachDirPath.Contains(":\\") && !attachDirPath.StartsWith("\\"))
        //{
        //    CreateDirectoryInCommonDir(ref attachDirPath);
        //}

        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(inputXML);
        XmlNode rootNode = default(XmlNode);
        rootNode = xmlDoc.SelectSingleNode("root");
        string fname = string.Empty;
        if (rootNode.Attributes["filename"] != null)
            fname = rootNode.Attributes["filename"].Value;
        else
            return result;
        string srcPath = attachDirPath + "\\" + transid + "\\";
        DirectoryInfo tarDir = new DirectoryInfo(scriptsPath + "Axpert\\" + sessionid);
        DirectoryInfo sPath = new DirectoryInfo(srcPath);
        try
        {
            if (!tarDir.Exists)
                tarDir.Create();
            if (sPath.Exists)
            {
                string[] sFileName = Directory.GetFiles(srcPath, recordid + "-" + fname);
                string authenticationStatus = string.Empty;
                if (util.GetAuthentication(ref authenticationStatus))
                {
                    foreach (var file in sFileName)
                    {
                        string fileName = Path.GetFileName(file);
                        File.Copy(file, Path.Combine(tarDir.ToString(), fileName.Substring(fileName.IndexOf("-") + 1)), true);
                    }
                }
                result = "{\"command\":[{\"cmd\":\"openfile\",\"cmdval\":\"" + fname + "\"}]}";
            }
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }
    //Remove the file from dir
    public string RemoveAttachFromDir(string inputXML)
    {
        string myPath = attachDirPath + "\\" + transid + "\\";
        string result = string.Empty;
        DirectoryInfo dir = new DirectoryInfo(myPath);
        if (inputXML != string.Empty)
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(inputXML);
            XmlNode rootNode = default(XmlNode);
            rootNode = xmlDoc.SelectSingleNode("root");
            string fname = string.Empty;
            if (rootNode.Attributes["filename"] != null)
                fname = rootNode.Attributes["filename"].Value;
            else
                return result;
            if (dir.Exists && !string.IsNullOrEmpty(fname))
            {
                removeFiles.Add(recordid + "-" + fname);
                result = "{\"message\":[{\"msg\":\"done\"}]}";
            }
            return result;
        }
        else
        {
            try
            {
                if (dir.Exists)
                    dir.Delete(true);
                return result;
            }
            catch { return result; }
        }
    }

    public string RemoveAttachFromServer(string inputXML, string stransId)
    {
        string result = string.Empty;
        XmlDocument xml = new XmlDocument();
        xml.LoadXml(inputXML);
        XmlElement root = xml.DocumentElement;
        string recordid = string.Empty;
        if (root.HasAttribute("recordid"))
            recordid = root.GetAttribute("recordid");
        if (imgAttachPath != "" && recordid != "0")
        {
            for (int i = 0; i < tstStrObj.flds.Count; i++)
            {
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[i];
                if (fld.fieldIsImage)
                {
                    if (!IsDcGrid(fld.fldframeno.ToString(), tstStrObj) && !fld.name.StartsWith("axp_nga_"))
                    {
                        string strDest = imgAttachPath + "\\" + transid + "\\" + fld.name;
                        string authenticationStatus = string.Empty;
                        if (util.GetAuthentication(ref authenticationStatus))
                        {
                            DirectoryInfo di = new DirectoryInfo(strDest);
                            if (di.Exists)
                            {
                                FileInfo[] files = di.GetFiles();
                                if (files.Length > 0)
                                {
                                    var ImgExist = files.Where(x => x.Name.Split('.')[0] == recordid).ToList();
                                    if (ImgExist.Count > 0)
                                    {
                                        foreach (var lstImg in ImgExist)
                                        {
                                            FileInfo file = (FileInfo)lstImg;
                                            file.Delete();
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (fld.name.StartsWith("axp_nga_"))
                    {
                        string strDest = imgAttachPath + "\\" + transid + "\\" + fld.name;
                        string authenticationStatus = string.Empty;
                        if (util.GetAuthentication(ref authenticationStatus))
                        {
                            DirectoryInfo di = new DirectoryInfo(strDest);
                            if (di.Exists)
                            {
                                FileInfo[] files = di.GetFiles();
                                if (files.Length > 0)
                                {
                                    var ImgExist = files.Where(x => x.Name.StartsWith(recordid + "-")).ToList();
                                    if (ImgExist.Count > 0)
                                    {
                                        foreach (var lstImg in ImgExist)
                                        {
                                            FileInfo file = (FileInfo)lstImg;
                                            file.Delete();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if ((fld.name.StartsWith("dc") && fld.name.ToLower().EndsWith("_image") || fld.name.StartsWith("axp_gridattach_")) && IsDcGrid(fld.fldframeno.ToString(), tstStrObj))
                {
                    TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[fld.fldframeno - 1];
                    string fldName = fld.name;
                    string grdAttPath = HttpContext.Current.Session["grdAttPath"].ToString();

                    if (dc.DCHasDataRows && grdAttPath != string.Empty)
                    {
                        if (!grdAttPath.EndsWith("\\"))
                            grdAttPath = grdAttPath + "\\";

                        string destFilePath = destFilePath = grdAttPath + "\\" + stransId + "\\" + fld.name;
                        string authenticationStatus = string.Empty;
                        if (util.GetAuthentication(ref authenticationStatus))
                        {
                            DirectoryInfo di = new DirectoryInfo(destFilePath);
                            if (di.Exists)
                            {
                                FileInfo[] files = di.GetFiles();
                                if (files.Length > 0)
                                {
                                    var ImgExist = files.Where(x => x.Name.StartsWith(recordid + "-")).ToList();
                                    if (ImgExist.Count > 0)
                                    {
                                        foreach (var lstImg in ImgExist)
                                        {
                                            FileInfo file = (FileInfo)lstImg;
                                            file.Delete();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if (attachDirPath != "" && recordid != "0")
        {
            string strDest = imgAttachPath + "\\" + stransId;
            DirectoryInfo di = new DirectoryInfo(strDest);
            if (di.Exists)
            {
                FileInfo[] files = di.GetFiles();
                if (files.Length > 0)
                {
                    var ImgExist = files.Where(x => x.Name.StartsWith(recordid + "-")).ToList();
                    if (ImgExist.Count > 0)
                    {
                        foreach (var lstImg in ImgExist)
                        {
                            FileInfo file = (FileInfo)lstImg;
                            file.Delete();
                        }
                    }
                }
            }
        }
        return result;
    }

    public string CallRemoveAttachWS(string s, string structXml)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</root>";
        string result = null;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        s = util.CheckReverseUrlSpecialChars(s);
        if (attachDir)
            result = RemoveAttachFromDir(s);
        if (string.IsNullOrEmpty(result))
            result = objWebServiceExt.CallRemoveAttachmentsWS(transid, s, structXml);
        return result;
    }

    //This function creates new directories inside the 'CommonDir' folder in web server.
    public void CreateDirectoryInCommonDir(ref String dirPath)
    {
        dirPath = AppDomain.CurrentDomain.BaseDirectory + "CommonDir\\" + dirPath;
        if (!Directory.Exists(dirPath))
        {
            Directory.CreateDirectory(dirPath);
        }
    }

    private string GetTraceString(string currentXml)
    {
        string traceVal = string.Empty;
        traceVal = currentXml;
        if (currentXml.Contains("_#") == true)
        {
            currentXml = currentXml.Replace("_#", "~");
        }

        string filename = string.Empty;
        int sindex = currentXml.IndexOf(Constants.TRACESPLITSTR2);
        int eindex = currentXml.LastIndexOf(Constants.TRACESPLITSTR1);

        if (sindex != -1 && eindex != -1)
        {
            filename = currentXml.Substring(sindex + 2, eindex - sindex - 2);
            sessionid = HttpContext.Current.Session["nsessionid"].ToString();
            errlog = logobj.CreateLog("Executing Action", sessionid, filename, "new");
            traceVal = currentXml.Replace(Constants.TRACESPLITSTR2 + filename + Constants.TRACESPLITSTR1, errlog);
        }

        if (traceVal.Contains("~") == true)
        {
            traceVal = traceVal.Replace("~", "_#");
        }
        if (scriptsPath != string.Empty)
        {
            traceVal = traceVal.Replace("<root", "<root scriptpath=" + '"' + scriptsPath + '"');
        }
        if (traceVal != null && traceVal != "")// Reddy
        {
            if (traceVal.TrimStart().StartsWith("<root "))
            {
                traceVal = traceVal.Replace("<root", "<root appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'");
            }
            else if (traceVal.TrimStart().StartsWith("<sqlresultset "))
            {
                traceVal = traceVal.Replace("<sqlresultset", "<sqlresultset appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'");
            }
            else if (traceVal.TrimStart().StartsWith("<Transaction "))
            {
                traceVal = traceVal.Replace("<Transaction", "<Transaction appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'");
            }
        }

        return traceVal;
    }

    public string GetAxFormDetails()
    {
        string frmDetails = string.Empty;
        string trace = HttpContext.Current.Session["AxTrace"].ToString();
        frmDetails = "<script type='text/javascript'>";
        frmDetails += "function GetFormDetails() { var a = '" + project + "';var b='" + user + "';var c='" + transactionID + "';var d='" + sessionid + "';var e = '" + AxRole + "';var f='" + trace + "';SetTstProps(a,b,c,d,e,f);}";
        frmDetails += "</script>";

        return frmDetails;
    }

    public string CallGetFormLoad(TStructData tstData, string errorLog)
    {
        string result = null;
        string visibleDCs = string.Empty;
        visibleDCs = tstStrObj.GetVisibleDCs();
        string loadXml = "<root axpapp='" + HttpContext.Current.Session["project"].ToString() + "' sessionid='" + HttpContext.Current.Session["nsessionid"].ToString() + "' transid='" + tstData.transid + "' recordid='" + rid + "' dcname='" + visibleDCs + "' trace='" + errorLog + "' appsessionkey='" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username='" + HttpContext.Current.Session["username"].ToString() + "'>";
        string dbmemvarsXML = GetDBMemVarsXML(tstData.transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        loadXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        loadXml += "</root>";
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallDoFormLoadWS(tstData.transid, loadXml, tstStrObj.structRes);
        //requestProcess_logtime += loadRes.Split('♠')[0];
        result = result.Split('♠')[1];
        return result;
    }

    public string CallGetLoadData(TStructData tstData, string recordid, string errorLog)
    {
        string result = null;
        string visibleDCs = string.Empty;
        visibleDCs = tstStrObj.GetVisibleDCs();
        string proj = HttpContext.Current.Session["project"].ToString();
        string imagefromdb = "false";
        if (HttpContext.Current.Session["AxpSaveImageDb"] != null)
            imagefromdb = HttpContext.Current.Session["AxpSaveImageDb"].ToString();
        string loadXml = "<root imagefromdb='" + imagefromdb + "' axpapp = '" + proj + "' sessionid = '" + HttpContext.Current.Session["nsessionid"].ToString() + "' appsessionkey = '" + HttpContext.Current.Session["AppSessionKey"].ToString() + "' username = '" + HttpContext.Current.Session["username"].ToString() + "' transid = '" + tstData.transid + "' recordid = '" + recordid + "' dcname = '" + visibleDCs + "' trace = '" + errorLog + "' > ";
        string dbmemvarsXML = GetDBMemVarsXML(tstData.transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        loadXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        loadXml += "</root>";
        loadXml = util.ReplaceImagePath(loadXml);
        string tsId = tstData.transid;
        string sXml = tstStrObj.structRes;
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallLoadDataWS(tsId, loadXml, sXml, recordid, proj);
        HttpContext.Current.Session["axp_lockonrecid"] = tsId + "~" + recordid;
        return result;
    }
    #endregion

    #region Private Methods

    /// <summary>
    /// Function to update the decimal value for the given field in the structure xml
    /// </summary>
    /// <param name="fieldName"></param>
    /// <param name="dec"></param>
    private void UpdateAxpCurrDec(string[] fieldNames, int dec)
    {
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(tstStrObj.structRes);
        XmlNodeList fieldNode;
        //looping from i=1 as the first item is decimal    
        for (int i = 1; i < fieldNames.Length; i++)
        {
            fieldNode = xmlDoc.GetElementsByTagName(fieldNames[i].ToString().Trim());
            if (fieldNode.Count > 0)
            {
                foreach (XmlNode childNode in fieldNode[0].ChildNodes)
                {
                    if (childNode.Name == "a5")
                    {
                        childNode.InnerText = dec.ToString();
                        tstStrObj.structRes = xmlDoc.OuterXml;
                        break;
                    }
                }
            }
        }
    }

    /// <summary>
    /// Function to check if the field is axpcurrencydec and call update struct xml
    /// </summary>
    /// <param name="fldName"></param>
    /// <param name="fldVal"></param>
    private void CheckAxpCurrDec(string fldName, string fldVal)
    {
        string[] axpCurrDetails = new string[] { };
        axpCurrDetails = fldVal.Split(',');
        if (axpCurrDetails.Length > 0 && fldVal != "")
        {
            int decNo = Convert.ToInt32(axpCurrDetails[0]);
            UpdateAxpCurrDec(axpCurrDetails, decNo);
        }
    }


    /// <summary>
    /// Function which loads the given image from the image folder to scripts.
    /// On change of the product, if the image should be replaced, this function is called.
    /// </summary>
    /// <param name="imageName"></param>
    /// <param name="imageSrc"></param>
    /// <returns>It returns the imagename along with the source value for the image, which is set in the client function</returns>
    public string GetImageSource(string imageName, string imageSrc)
    {
        if (imageSrc != "")
        {
            string[] fvalues = imageSrc.ToString().Split('~');
            string recordId = fvalues[2].ToString();
            imageFldNames.Clear();
            imageFldSrc.Clear();
            LoadImageToFolder(imageName, recordId);


            string imgSrc = "";
            for (int i = 0; i < imageFldNames.Count; i++)
            {
                if (imageFldNames[i].ToString() == imageName)
                {
                    imgSrc = imageFldSrc[i].ToString();
                    break;
                }
            }

            return imageName + "♣" + imgSrc;
        }
        return imageFldSrc + "♣" + "";
    }

    private void CreateFieldValueXmlLoadTab(string frameNo)
    {
        string fValue = string.Empty;
        StringBuilder fldXml = new StringBuilder();
        string curFldFrmNo = "0";
        for (int i = 0; i < fieldName.Count; i++)
        {
            int fIndex = 0;
            fIndex = fieldControlName[i].ToString().LastIndexOf("F");
            fIndex = fIndex + 1;
            curFldFrmNo = fieldControlName[i].ToString().Substring(fIndex, fieldControlName[i].ToString().Length - fIndex);

            if (Convert.ToInt32(curFldFrmNo) <= Convert.ToInt32(frameNo))
            {
                fldXml.Append("<" + fieldName[i] + ">");
                fValue = CheckSpecialChars(fieldValue[i].ToString());
                fldXml.Append(fValue);
                fldXml.Append("</" + fieldName[i] + ">");
            }
        }

        fgFieldValueXml = fldXml.ToString();
    }
    private void CreateFieldValueXmlPerf(string frameNum, string ActiveRowNo, ArrayList AxDepFields, string fldDepGridDcs, Dictionary<string, string> includeDcRows, string includeDcs)
    {
        DSFieldValueXMLPerf(frameNum, ActiveRowNo, AxDepFields, fldDepGridDcs, includeDcRows, includeDcs);
    }

    private void CreateFieldValueXml(string condition, string includeDcs, string calledFrom)
    {
        DSFieldValueXML(condition, includeDcs, calledFrom);
    }

    private void FieldToXML(string fldName, string rowNo, string value, string oldValue, string idvalue, string oldIdValue, string dcNo, Boolean fldSaveNormal, bool isSubGrid, string subRowNo, TStructDef.FieldStruct fld = new TStructDef.FieldStruct())
    {
        rowNo = GetRowNoHelper(rowNo.ToString());
        value = CheckSpecialChars(value);
        oldValue = CheckSpecialChars(oldValue);
        string oldVal = "";
        if (recordid != "0")
        {
            if (value != oldValue)
                oldVal = "ov='" + oldValue + "'";
            else
                oldVal = "";
        }
        if (fldName.StartsWith(Constants.IMGPrefix))
            return;
        if (fldName.ToLower() == (Constants.AXPIMAGEPATH))
            isAxpImagePath = true;
        //if (fld.datatype != null && fld.datatype.ToLower() == "image" && imgAttachPath != "")
        //    return;
        if (fldSaveNormal)
        {
            if (Convert.ToString(idvalue) == "") idvalue = "0";
            if (Convert.ToString(oldIdValue) == "") oldIdValue = "0";
            if (isSubGrid)
                dsDataXML.Append("<" + fldName + " rowno='" + subRowNo + "' id='" + idvalue + "' oldid='" + oldIdValue + "' " + oldVal + ">" + value + "</" + fldName + ">");
            else
                dsDataXML.Append("<" + fldName + " rowno='" + rowNo + "' id='" + idvalue + "' oldid='" + oldIdValue + "' " + oldVal + ">" + value + "</" + fldName + ">");
        }
        else
        {
            if (isSubGrid)
                dsDataXML.Append("<" + fldName + " rowno='" + subRowNo + "' " + oldVal + ">" + value + "</" + fldName + ">");
            else if (fld.fldMultiSelect != null)
            {
                dsDataXML.Append("<" + fldName + " rowno='" + rowNo + "' " + oldVal + " multiselect='true' separator='" + fld.fldMultiSelectSep + "'>" + value + "</" + fldName + ">");
            }
            else
                dsDataXML.Append("<" + fldName + " rowno='" + rowNo + "' " + oldVal + ">" + value + "</" + fldName + ">");
        }
    }

    private void DSFieldValueXML(string frameNum, string parDcNo, int ParRowNo, string popDcNo, int popRowNo)
    {
        int fNo = -1;
        bool isNumber = false;
        try
        {
            fNo = int.Parse(frameNum);
            isNumber = true;
            frameNum = "F" + frameNum;
        }
        catch
        {
        }

        dsDataXML.Length = 0;

        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            //This condition will construct xml till the given dc if the given number is a frame no, 
            //else it will continue and create the xml for all dc's.
            if ((frameNum != "F-1") && (isNumber))
            {
                if (dc.frameno > fNo)
                    break;
            }

            if (dc.isgrid && dc.DCHasDataRows == false)
                continue;

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);
            string subGridRow = string.Empty;
            bool isSubGrid = false;

            foreach (DataRow dr in thisDataTable.Rows)
            {
                int rowNo = Convert.ToInt32(dr["axp__rowno"]);
                if (dc.frameno.ToString() == parDcNo && rowNo != ParRowNo)
                    continue;

                //Sub-Grid - only the newly added row should be sent in the input xml.
                if (dc.frameno.ToString() == popDcNo && rowNo != popRowNo)
                {
                    continue;
                }
                else if (dc.frameno.ToString() == popDcNo)
                {
                    subGridRow = "001";
                    isSubGrid = true;
                }

                DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, isSubGrid, subGridRow);
            }
        }

        fieldValueXml = dsDataXML.ToString();
    }

    private void DSFieldValueXMLHelperPerf(string dcNo, int rowNo, int startIdx, int endIdx, DataRow dr, ArrayList depFields)
    {
        DataTable dtOld = dsDataSet.Tables["dc_old" + dcNo];
        DataRow drOld = dtOld.Rows.Find(rowNo);

        for (int j = startIdx; j <= endIdx; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
            if (depFields.IndexOf(fld.name) == -1)
                continue;

            string value = string.Empty;
            string oldValue = string.Empty;
            string idValue = string.Empty;
            string oldIdValue = string.Empty;

            string FldValue = string.Empty;

            value = dr[fld.name].ToString();
            if (fld.savenormal)
                idValue = dr["id__" + fld.name].ToString();

            if (drOld != null)
            {
                oldValue = drOld["old__" + fld.name].ToString();
                if (fld.savenormal)
                    oldIdValue = drOld["oldid__" + fld.name].ToString();
            }

            FieldToXML(fld.name, Convert.ToString(rowNo), value, oldValue, idValue, oldIdValue, dcNo, fld.savenormal, false, "");
        }
    }

    private void DSFieldValueXMLHelper(string dcNo, int rowNo, int startIdx, int endIdx, DataRow dr, bool isSubGrid, string subGridRowNo)
    {
        DataTable dtOld = dsDataSet.Tables["dc_old" + dcNo];
        DataRow drOld = dtOld.Rows.Find(rowNo);

        for (int j = startIdx; j <= endIdx; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
            string value = string.Empty;
            string oldValue = string.Empty;
            string idValue = string.Empty;
            string oldIdValue = string.Empty;

            string FldValue = string.Empty;

            value = dr[fld.name].ToString();
            if (fld.savenormal)
                idValue = dr["id__" + fld.name].ToString();

            if (drOld != null)
            {
                oldValue = drOld["old__" + fld.name].ToString();
                if (fld.savenormal)
                    oldIdValue = drOld["oldid__" + fld.name].ToString();
            }
            ////// is save true and rtf check.. 
            if (isSaveCalled)
            {
                if ((fld.name.Contains("rtf_") || fld.name.Contains("rtfm_") || fld.name.Contains("fr_rtf_")) && fld.name.Contains("_printable"))
                    value = ReplaceRTFTagsForPrint(dr[fld.name.Replace("_printable", "")].ToString());
            }

            FieldToXML(fld.name, Convert.ToString(rowNo), value, oldValue, idValue, oldIdValue, dcNo, fld.savenormal, isSubGrid, subGridRowNo, fld);
        }
    }

    private void RapidFieldValueXML(string dcNo, int rowNo, int startIdx, int endIdx, DataRow dr, bool isSubGrid, string subGridRowNo, TStructDef.FieldStruct Parfld, string actRow, string calledFrom)
    {
        DataTable dtOld = dsDataSet.Tables["dc_old" + dcNo];
        DataRow drOld = dtOld.Rows.Find(rowNo);
        string[] arrParams;
        if (calledFrom == "Rapid")
            arrParams = Parfld.FldRapidParents.Split(',');
        else
            arrParams = Parfld.FldRapidAllParents.Split(',');
        List<string> lstParams = new List<string>();
        lstParams.AddRange(arrParams);

        string[] arrParAllRows = Parfld.FldRapidAllRows.Split(',');
        List<string> lstParAllRows = new List<string>();
        lstParAllRows.AddRange(arrParAllRows);

        for (int j = startIdx; j <= endIdx; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
            int dIdx = -1;
            dIdx = lstParams.IndexOf(fld.name);
            //If the field is not there in the params array, continue the loop
            if (dIdx == -1 && !fld.name.StartsWith("axp_recid")) continue;

            //If the allrows for the current parent is false, then only if the current dc and parent dc are same row should be constructed for active row else continue
            //arrParAllRows.Length > dIdx - this condition needs to be handled
            if (IsDcGrid(fld.fldframeno.ToString(), tstStrObj) && dIdx != -1 && arrParAllRows.Length > dIdx)
            {
                if (!(fld.fldframeno == Parfld.fldframeno && arrParAllRows[dIdx] == "F" && rowNo.ToString() == actRow)) continue;
            }
            string value = string.Empty;
            string oldValue = string.Empty;
            string idValue = string.Empty;
            string oldIdValue = string.Empty;

            string FldValue = string.Empty;

            value = dr[fld.name].ToString();
            if (fld.savenormal)
                idValue = dr["id__" + fld.name].ToString();

            if (drOld != null)
            {
                oldValue = drOld["old__" + fld.name].ToString();
                if (fld.savenormal)
                    oldIdValue = drOld["oldid__" + fld.name].ToString();
            }
            ////// is save true and rtf check.. 
            if (isSaveCalled)
            {
                if ((fld.name.Contains("rtf_") || fld.name.Contains("rtfm_") || fld.name.Contains("fr_rtf_")) && fld.name.Contains("_printable"))
                    value = ReplaceRTFTagsForPrint(dr[fld.name.Replace("_printable", "")].ToString());
            }

            FieldToXML(fld.name, Convert.ToString(rowNo), value, oldValue, idValue, oldIdValue, dcNo, fld.savenormal, isSubGrid, subGridRowNo);
        }
    }


    private string ReplaceRTFTagsForPrint(string inpStr)
    {
        // string[] rtfTags = new string[] { "<pre", "<span", "<div", "<ul", "<li", "<ol", "<span", "<blockquote", "<font", "<h1", "<h2", "<h3", "<h4", "<h5", "<p", "<em", "<br" };
        // string[] rtfEndTags = new string[] { "</pre>", "</span>", "</div>", "</ul>", "</li>", "</ol>", "</span>", "</blockquote>", "</font>", "</h1>", "</h2>", "</h3>", "</h4>", "</h5>", "</p>", "</em>", "</br>" };

        string[] rtfTags = new string[] { "<pre", "<span", "<div", "<ul", "<li", "<ol", "<span", "<blockquote", "<h1", "<h2", "<h3", "<h4", "<h5", "<p", "<em", "<br" };
        string[] rtfEndTags = new string[] { "</pre>", "</span>", "</div>", "</ul>", "</li>", "</ol>", "</span>", "</blockquote>", "</h1>", "</h2>", "</h3>", "</h4>", "</h5>", "</p>", "</em>", "</br>" };

        for (int i = 0; i < rtfTags.Length; i++)
            while (inpStr.Contains(rtfTags[i]))
            {
                int startIdx = -1;
                int endIdx = -1;

                startIdx = inpStr.IndexOf(rtfTags[i]);
                endIdx = inpStr.IndexOf(">", startIdx);

                string replaceStr = string.Empty;

                string strNode = inpStr.Substring(startIdx, (endIdx - startIdx) + 1);
                //Code to replace <div> with new line in fast report
                if (strNode == "<div>" || strNode == "<li>")
                {
                    //replaceStr = "#13#10";
                    inpStr = inpStr.Insert(endIdx + 1, "~");
                }

                inpStr = inpStr.Remove(startIdx, (endIdx + 1) - startIdx);
                inpStr = inpStr.Replace(rtfEndTags[i], replaceStr);
            }

        string[] rtfSupportedTags = new string[] { "<em", "<i", "<b", "<u", "<strong" };

        for (int i = 0; i < rtfSupportedTags.Length; i++)
        {
            int startIdx = -1;
            int endIdx = -1;
            while (true)
            {
                startIdx = inpStr.IndexOf(rtfSupportedTags[i], endIdx + 1);
                if (startIdx == -1)
                    break;

                endIdx = inpStr.IndexOf(">", startIdx);
                inpStr = inpStr.Remove(startIdx, (endIdx + 1) - startIdx);
                inpStr = inpStr.Insert(startIdx, rtfSupportedTags[i] + ">");
                endIdx = endIdx - (endIdx - startIdx);
            }
        }

        inpStr = inpStr.Replace("&nbsp;", "");
        inpStr = inpStr.Replace("\n", "~");

        return inpStr;
    }

    private void DSFieldValueXML(string frameNum, string calledFrom)
    {
        int fNo = -1;
        bool isNumber = true;
        try
        {
            fNo = int.Parse(frameNum);
            isNumber = true;
        }
        catch
        {
            isNumber = false;
        }

        if (isNumber)
            frameNum = "F" + frameNum;

        dsDataXML.Length = 0;

        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            //This condition will construct xml till the given dc if the given number is a frame no, 
            //else it will continue and create the xml for all dc's.            
            if ((frameNum != "F-1") && (isNumber))
            {
                if (calledFrom == "FillGrid")
                {
                    //– Only non grid data will be sent in input xml.For all grid dcs only row count will be sent.
                    if (dc.isgrid)
                    {
                        int rCnt = GetDcRowCount(dcNo);
                        dsDataXML.Append("<dc" + dcNo + " type=dc >" + rCnt + "</dc" + dcNo + ">");
                        continue;
                    }
                }
                else if (calledFrom == "LoadDc")
                {
                    //Only non grid data and this DC data will be sent as parameter
                    if (fNo != dc.frameno || dc.isgrid)
                        continue;
                }
                //TODO: why this is empty?
                else if (calledFrom == "GetDep")
                {

                }
                else
                {
                    //NOTE: for a webservice where the frame no is sent, all other grid dcs data should also be sent to the web service.
                    if (dc.frameno > fNo && dc.isgrid)
                        continue;
                }
            }

            int rowCnt = 0;
            if (dc.isgrid)
            {
                rowCnt = GetDcRowCount(dcNo);
                if (rowCnt == 0) rowCnt = 1;
                if (calledFrom != "PickList" && dc.DCHasDataRows == false)
                    continue;
            }

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);

            foreach (DataRow dr in thisDataTable.Rows)
            {
                int rowNo = Convert.ToInt32(dr["axp__rowno"]);
                DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
            }
        }
        if (frameNum == "F-1")
            fieldValueXml = dsDataXML.ToString();
        else
            fgFieldValueXml = dsDataXML.ToString();

    }

    public void DSRapidFieldValueXML(string frameNo, string actRowNo, string fieldName, string calledFrom, TStructDef.FieldStruct fld)
    {
        dsDataXML = new StringBuilder();
        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            //This condition will construct xml for all the non grids in the given tstruct, 
            //if the includeDcs contains any grid dc then that dc also will be included in the xml construction.                    
            //TODO:RAPID - Check allrows along with params
            int rowCnt = 0;
            if (dc.isgrid)
            {
                rowCnt = GetDcRowCount(dcNo);
                if (rowCnt == 0) rowCnt = 1;
                //if (calledFrom != "PickList" && dc.DCHasDataRows == false && calledFrom != "RefreshDc")
                //    continue;
            }

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            try
            {
                if (calledFrom != "AutoComplete" && calledFrom != "axpbutton")
                {
                    DataRow[] rows;
                    rows = thisDataTable.Select("axp__isGrdVld" + dcNo + " = 'false'"); // axp__isGrdVld is Column Name
                    foreach (DataRow r in rows)
                        thisDataTable.Rows.Remove(r);
                }
            }
            catch (Exception ex)
            {
                //catch block is not handlink because - we are skipping the rows which does not contains axp__isGrdVld+dcno column 
            }

            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);

            foreach (DataRow dr in thisDataTable.Rows)
            {
                int rowNo = Convert.ToInt32(dr["axp__rowno"]);
                if (calledFrom != "AutoComplete" && calledFrom != "axpbutton" && thisDataTable.Columns.Contains(Constants.AXPISROWVALID + dcNo) && dr[Constants.AXPISROWVALID + dcNo].ToString() == "false")
                    continue;

                RapidFieldValueXML(dcNo, rowNo, startIdx, endIdx, dr, false, "", fld, actRowNo, calledFrom);

            }
        }

        fieldValueXml = dsDataXML.ToString();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="condition">NG</param>
    /// <param name="includeDcs"></param>
    /// <param name="calledFrom"></param>
    public void DSFieldValueXML(string condition, string includeDcs, string calledFrom)
    {
        dsDataXML.Length = 0;

        ArrayList incGridDcs = new ArrayList();
        if (!string.IsNullOrEmpty(includeDcs))
        {
            string[] incDcs = includeDcs.Split(',');
            for (int idx = 0; idx < incDcs.Length; idx++)
            {
                if (!string.IsNullOrEmpty(incDcs[idx].ToString()))
                {
                    incGridDcs.Add(incDcs[idx].ToString());
                    if (IsParentDc(incDcs[idx].ToString()))
                    {
                        ArrayList arrPopDcs = new ArrayList();
                        arrPopDcs = GetPopDcsForParent(incDcs[idx].ToString());
                        for (int pIdx = 0; pIdx < arrPopDcs.Count; pIdx++)
                        {
                            if (incGridDcs.IndexOf(arrPopDcs[pIdx].ToString()) == -1)
                                incGridDcs.Add(arrPopDcs[pIdx].ToString());
                        }
                    }
                }
            }
        }
        string sourceDc = string.Empty;
        ArrayList tabParentFlds = new ArrayList();
        if (calledFrom == "LoadTab" || calledFrom == "FillGrid" || calledFrom == "AutoComplete")
        {
            if (includeDcs != string.Empty)
            {
                TStructDef.DcStruct tabDc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(includeDcs) - 1];
                tabParentFlds = tabDc.tabParentFields;
            }
            //incGridDcs.Clear();
            if (calledFrom == "FillGrid")
            {
                int idx = tstStrObj.GetFillGridIndex("dc" + includeDcs.ToString());
                includeDcs = "";
                if (idx != -1)
                {
                    TStructDef.FGStruct fg = (TStructDef.FGStruct)tstStrObj.fgs[idx];
                    if (fg.fgSourceDC != "")
                        sourceDc = fg.fgSourceDC.Substring(2);
                }
            }
        }

        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            //This condition will construct xml for all the non grids in the given tstruct, 
            //if the includeDcs contains any grid dc then that dc also will be included in the xml construction.                    
            if (condition == "NG")
            {
                //– Only non grid data will be sent in input xml.For all grid dcs only row count will be sent.
                if (dc.isgrid)
                {
                    //For getdep web service, the other grid dcs rowcount also should be sent.
                    //if ((calledFrom == "GetDep" || calledFrom == "GetDependents") && incGridDcs.IndexOf(dcNo) == -1)
                    if (calledFrom == "GetDep" && incGridDcs.IndexOf(dcNo) == -1)
                    {
                        int rCnt = GetDcRowCount(dcNo);
                        dsDataXML.Append("<dc" + dcNo + " type=dc >" + rCnt + "</dc" + dcNo + ">");
                    }

                    //Refer bug - IWA-C-0000024
                    //Removed LoadData as current dc data should not be sent to webservice- This will result in tabdata bringing empty row.
                    if (calledFrom != "FillGrid" && calledFrom != "AutoComplete" && calledFrom != "axpbutton" && incGridDcs.IndexOf(dcNo) == -1)
                        continue;
                }
            }

            int rowCnt = 0;
            if (dc.isgrid)
            {
                rowCnt = GetDcRowCount(dcNo);
                if (rowCnt == 0) rowCnt = 1;
                if (calledFrom != "PickList" && dc.DCHasDataRows == false && calledFrom != "RefreshDc")
                    continue;
            }

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            try
            {
                if (calledFrom != "AutoComplete" && calledFrom != "axpbutton")
                {
                    DataRow[] rows;
                    rows = thisDataTable.Select("axp__isGrdVld" + dcNo + " = 'false'"); // axp__isGrdVld is Column Name
                    foreach (DataRow r in rows)
                        thisDataTable.Rows.Remove(r);
                }
            }
            catch (Exception ex)
            {
                //catch block is not handlink because - we are skipping the rows which does not contains axp__isGrdVld+dcno column 
            }
            bool isAddRow = false;

            if (calledFrom == "RefreshDc" && thisDataTable.Rows.Count == 0)
            {
                DataRow newRow = thisDataTable.NewRow();
                newRow["axp__rowno"] = 1;
                newRow["axp__delrow"] = 0;
                thisDataTable.Rows.Add(newRow);
                thisDataTable.AcceptChanges();
                isAddRow = true;
            }

            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);

            foreach (DataRow dr in thisDataTable.Rows)
            {

                int rowNo = Convert.ToInt32(dr["axp__rowno"]);

                if (calledFrom != "AutoComplete" && calledFrom != "axpbutton" && thisDataTable.Columns.Contains(Constants.AXPISROWVALID + dcNo) && dr[Constants.AXPISROWVALID + dcNo].ToString() == "false")
                    continue;

                if (calledFrom == "LoadTab" && dcNo == includeDcs)
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if (calledFrom == "FillGrid" && dc.isgrid && dcNo == sourceDc)
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if (calledFrom == "LoadTab" && dc.isgrid && incGridDcs.IndexOf(dcNo) != -1)
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if ((calledFrom == "LoadTab" || calledFrom == "FillGrid" || calledFrom == "AutoComplete") && dc.isgrid && dcNo != includeDcs)
                    DSFieldValueXMLHelperPerf(dcNo, rowNo, startIdx, endIdx, dr, tabParentFlds);
                else
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");

            }

            if (isAddRow && calledFrom == "RefreshDc")
            {
                thisDataTable.Rows.RemoveAt(0);
                isAddRow = false;
            }
        }

        fieldValueXml = dsDataXML.ToString();

    }
    private void DSFieldValueXMLPerf(string frameNum, string ActiveRowNo, ArrayList depFields, string fldDepGridDcs, Dictionary<string, string> includeDcRows, string includeDcs)
    {
        int fNo = -1;
        bool isNumber = true;
        bool IsDcInclude = false;
        string[] refreshdc = new string[10];
        if (includeDcs != string.Empty)
            refreshdc = includeDcs.Split(',');

        try
        {
            fNo = int.Parse(frameNum);
            isNumber = true;
        }
        catch
        {
            isNumber = false;
        }

        if (isNumber)
            frameNum = "F" + frameNum;

        dsDataXML.Length = 0;

        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            string incRowsStr = string.Empty;
            ArrayList includeRows = new ArrayList();
            if (includeDcRows.ContainsKey(dcNo))
            {
                IsDcInclude = true;
                includeDcRows.TryGetValue(dcNo, out incRowsStr);
                string[] incRows = incRowsStr.Split(',');
                for (int j = 0; j < incRows.Length; j++)
                {
                    if (incRows[j] != "")
                        includeRows.Add(Convert.ToInt32(incRows[j].ToString()));
                }
            }
            else
            {
                IsDcInclude = false;
                if (Array.IndexOf(refreshdc, dcNo) > -1)
                    IsDcInclude = true;
                else if (!dc.isgrid)
                    IsDcInclude = true;
                string[] depDcs = fldDepGridDcs.Split(',');
                for (int dIdx = 0; dIdx < depDcs.Length; dIdx++)
                {
                    if (depDcs[dIdx].ToString() == dcNo)
                    {
                        IsDcInclude = true;
                        break;
                    }
                }
            }

            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);

            int rowCnt = 0;
            if (dc.isgrid)
            {
                if (dc.frameno == fNo || IsDcInclude)
                {
                    rowCnt = GetDcRowCount(dcNo);
                    if (rowCnt == 0) rowCnt = 1;
                    if (dc.DCHasDataRows == false)
                        continue;
                }
                else
                    continue;
            }

            int ActRowNo = Convert.ToInt32(ActiveRowNo);

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            int subRowNo = 0;
            //This loop will run through all the rows in the grid, if the given rowno is same as activerowno, then it will construct for all the fields
            //Else it will construct xml only for the fields given in the depFields parameter.
            foreach (DataRow dr in thisDataTable.Rows)
            {


                int rowNo = Convert.ToInt32(dr["axp__rowno"]);

                //If a non grid field is changed and a grid has record in add panel(Invalid row) it should not be sent to web-service
                if (frameNum != "F" + dc.frameno.ToString() && dc.isgrid && dr[Constants.AXPISROWVALID + dcNo].ToString() == "false")
                    continue;

                if ((Array.IndexOf(refreshdc, dcNo) > -1) && (dc.frameno != fNo))
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if (!dc.isgrid)
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if (dc.frameno == fNo && rowNo == ActRowNo)
                    DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                else if (IsDcInclude && includeRows.IndexOf(rowNo) != -1)
                {
                    if (dc.ispopgrid)
                    {
                        subRowNo++;
                        DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, dc.ispopgrid, subRowNo.ToString());
                    }
                    else
                    {
                        DSFieldValueXMLHelper(dcNo, rowNo, startIdx, endIdx, dr, false, "");
                    }
                }
                else
                    DSFieldValueXMLHelperPerf(dcNo, rowNo, startIdx, endIdx, dr, depFields);
            }
        }

        fieldValueXml = dsDataXML.ToString();
    }

    private void CreateFieldValueXml(string frameNum, string parDcNo, int ParRowNo, string popDcNo, int popRowNo)
    {
        DSFieldValueXML(frameNum, parDcNo, ParRowNo, popDcNo, popRowNo);
        return;
    }

    public DataTable CreateDataTable()
    {
        return new DataTable();
    }

    /// <summary>
    /// This method loops through the lists and construct the field value xml.
    /// and updates the object variable “PopfieldValueXml”.
    /// </summary>
    private void CreatePopFieldValueXml(ArrayList fldArray, ArrayList fldValueArray, ArrayList fldDeletedArray, string frameNum, string pframeno, string maxRows, ArrayList popRows)
    {

        string fValue = string.Empty;
        frameNum = "F" + frameNum;
        StringBuilder fldXml = new StringBuilder();
        StringBuilder popFldXml = new StringBuilder();
        string rnList = "";
        popFldXml.Append("<row>");
        for (int i = 0; i < fieldName.Count; i++)
        {
            if (fieldControlName[i].ToString().IndexOf(frameNum.ToString()) == -1)
            {
                fldXml.Append("<" + fieldName[i] + ">");
                fValue = CheckSpecialChars(fieldValue[i].ToString());
                fldXml.Append(fValue);
                fldXml.Append("</" + fieldName[i] + ">");
            }
            else
            {
                popFldXml.Append("<" + fieldName[i] + ">");
                fValue = CheckSpecialChars(fieldValue[i].ToString());
                popFldXml.Append(fValue);
                popFldXml.Append("</" + fieldName[i] + ">");
            }
        }

        popFGFieldValueXml = "";
        if (popFldXml.ToString() == "") popFldXml.Append("<row>");
        popFGFieldValueXml = "<GridList rnlist=\"" + rnList.ToString() + "\"  mrno=\"" + maxRows.ToString() + "\"  prno=\"" + pframeno.ToString() + "\">" + popFldXml.ToString() + "</row></GridList>" + "<FieldList>" + fgFieldValueXml.ToString() + "</FieldList>";
    }

    /// <summary>
    /// function for replacing the special characters in a given string.
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    /// <remarks></remarks>
    private string CheckSpecialChars(string str)
    {
        //hack: The below line is used to make sure that the & in &amp; is not converted inadvertantly
        //      for other chars this scenario will not come as it does not contains the same char.
        str = Regex.Replace(str, "&amp;", "&");
        str = Regex.Replace(str, "&quot;", "“");
        str = Regex.Replace(str, "\n", "<br>");
        str = Regex.Replace(str, "&", "&amp;");
        str = Regex.Replace(str, "<", "&lt;");
        str = Regex.Replace(str, ">", "&gt;");
        str = Regex.Replace(str, "'", "&apos;");
        str = Regex.Replace(str, "\"", "&quot;");
        str = Regex.Replace(str, "’", "&apos;");
        str = Regex.Replace(str, "“", "&quot;");
        str = Regex.Replace(str, "”", "&quot;");
        str = Regex.Replace(str, "™", "&#8482;");
        str = Regex.Replace(str, "®", "&#174;");

        str = str.Replace((char)160, ' ');

        if (str == defaultDateStr)
            str = "";
        return str;
    }

    private string GetDbFieldName(string fieldCompName, string dbRowNo)
    {
        if (dbRowNo.Length == 1)
            dbRowNo = "00" + dbRowNo;
        else if (dbRowNo.Length == 2)
            dbRowNo = "0" + dbRowNo;

        int fIndx = fieldCompName.LastIndexOf("F");
        if (fIndx != -1)
        {
            string fldDcNo = fieldCompName.Substring(fIndx + 1);
            string dbFldName = fieldCompName.Substring(0, fIndx - 3);
            string newCompName = dbFldName + dbRowNo + "F" + fldDcNo;
            return newCompName;
        }
        else
        {
            if (fieldCompName.StartsWith("dc") && dbRowNo == "0-1")
                return "dc";
            else
                return fieldCompName;
        }
    }

    /// <summary>
    /// This method for for updating the existing field values and adding any new values. 
    /// Note: Only grid field values can be added and deleted.
    /// </summary>
    /// <param name="fldArray"></param>
    /// <param name="fldValueArray"></param>
    /// <param name="deletedArray"></param>
    public void UpdateDataList(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList deletedArray)
    {

        for (int j = 0; j < fldArray.Count; j++)
        {
            if (fldArray[j] != null)
            {
                if (fldValueArray[j].ToString() == defaultDateStr)
                    fldValueArray[j] = "";

                string fldname = string.Empty; string frmNum = string.Empty; string fldRowNo = string.Empty;
                string newCompName = GetDbFieldName(fldArray[j].ToString(), fldDbRowNo[j].ToString());

                if (newCompName == "dc")
                {
                    string[] dcData = fldValueArray[j].ToString().Split('♦');
                    string newRowCnt = dcData[0];
                    string changedRows = dcData[1];
                    if (changedRows != "")
                    {
                        SetDbRows(changedRows, fldArray[j].ToString().Substring(2), tstStrObj, "");
                    }

                    UpdateRowCount(fldArray[j].ToString(), newRowCnt);
                    continue;
                }

                int lastIndex = newCompName.LastIndexOf('F');
                if (lastIndex != -1)
                {
                    fldname = newCompName.Substring(0, lastIndex - 3);
                    fldRowNo = newCompName.Substring(lastIndex - 3, 3);
                    frmNum = newCompName.Substring(lastIndex + 1);
                }
                else
                {
                    fldname = newCompName.Substring(0, newCompName.Length - 5);
                    fldRowNo = newCompName.Substring(lastIndex - 3, 3);
                    frmNum = newCompName.Substring(newCompName.Length - 2);
                }

                //Update the dc dchasdatarowws property.
                TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(frmNum) - 1];
                if (dc.isgrid)
                {
                    if (!dc.DCHasDataRows)
                    {
                        //Refer bugid- AXP-C-0000136
                        //If the row comes from client due to expression eval for pop up grid row, do not mark it valid
                        var valIdx = fldArray.IndexOf("axp__isGrdVld" + frmNum + fldRowNo + "F" + frmNum);
                        if (valIdx != -1 && fldValueArray[valIdx].ToString() == "false")
                        {
                            //In case of grid(pop) a new row value will be sent after expression evaluation but the row is not valid. In this case the dchasDataRows should not be changed to true.
                        }
                        else
                        {
                            dc.DCHasDataRows = true;
                            tstStrObj.dcs[Convert.ToInt32(frmNum) - 1] = dc;
                        }
                    }
                }

                //int index = fieldControlName.IndexOf(newCompName);
                // int index = GetFldIndex(Convert.ToInt32(frmNum), fldname, Convert.ToInt32(fldDbRowNo[j]));
                string newFldValue = fldValueArray[j].ToString();

                //TODO: The same code is there in the TstructData constructor, and Jsontoarray
                //if (fldname.ToLower() == "axpcurrencydec")
                //   CheckAxpCurrDec(fldname, newFldValue);

                if (newCompName.StartsWith("axp_recid") && newFldValue == "") newFldValue = "0";

                string tmpFldVal = string.Empty;
                string tmpFldIdVal = string.Empty;

                if (newCompName != string.Empty)
                {
                    if (newFldValue.Contains("¿"))
                    {
                        string[] idVal = newFldValue.Split('¿');
                        tmpFldVal = idVal[1];
                        tmpFldIdVal = idVal[0];
                    }
                    else
                        tmpFldVal = newFldValue.ToString();
                }
                DSSubmit(fldname, Convert.ToInt32(fldDbRowNo[j].ToString()), tmpFldVal, tmpFldIdVal);
            }
        }

        // For deleting the fields from the list.
        for (int k = 0; k < deletedArray.Count; k++)
        {
            int fIdx = deletedArray[k].ToString().IndexOf("F");
            string delRowNo = deletedArray[k].ToString().Substring(0, fIdx);
            string delDcNo = deletedArray[k].ToString().Substring(fIdx + 1);
            int tmpRowCnt = GetActualDcRowCount(delDcNo);//GetDcRowCount(delDcNo);//Refer Bug: AGI003750
            if (tmpRowCnt == 1 && (delRowNo == "001" || delRowNo == "1"))
            {
                TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(delDcNo) - 1];
                dc.DCHasDataRows = false;
                tstStrObj.dcs[Convert.ToInt32(delDcNo) - 1] = dc;
            }
            if (recordID != "0" && recordID != "")
                DeleteRowInFldArrays(delDcNo, delRowNo);
            else
                DeleteRowInFldArrays(delDcNo, delRowNo);

            tmpRowCnt = tmpRowCnt - 1;
            if (tmpRowCnt >= 0)
                UpdateRowCount("DC" + delDcNo, "DC" + delDcNo + "~" + tmpRowCnt);
        }
    }

    private int GetActualDcRowCount(string dcNo)
    {
        int rowCount = 0;
        DataTable dt = dsDataSet.Tables["dc" + dcNo];
        if (dt.Rows.Count > 0)
        {
            rowCount = dt.Select("axp__isGrdVld" + dcNo + " = ''").Count();
        }
        return rowCount;
    }

    private string GetFrameNo(string fieldId)
    {
        return fieldId.Substring(fieldId.LastIndexOf("F") + 1);
    }

    private int GetDCRowCntIndex(string dcNo)
    {
        int index = -1;
        for (int i = 0; i < dcRowCntVals.Count; i++)
        {
            string[] dcName = dcRowCntVals[i].ToString().Split('~');
            if (dcName[0] == dcNo)
                index = i;
        }
        return index;
    }

    private ArrayList GetSubGridDcsInTabDC(TStructDef strObj, string TabDcNo)
    {
        ArrayList subGridDcs = new ArrayList();
        for (int i = 0; i < strObj.popdcs.Count; i++)
        {
            if (TabDcNo == ((TStructDef.PopDcStruct)(strObj.popdcs[i])).pdcno.ToString())
            {
                subGridDcs.Add(((TStructDef.PopDcStruct)(strObj.popdcs[i])).frameno);
            }
        }
        return subGridDcs;
    }

    /// <summary>
    /// Function to parse the memvar node from the json and update the memvar arrays
    /// </summary>
    /// <param name="jsonData"></param>
    /// <param name="calledFrom"></param>
    public void ParseMemVarNode(string jsonData, string calledFrom)
    {
        jsonData = jsonData.Replace("*$*", "♦");
        jsonData = jsonData.Replace("\\", ";bkslh");
        string[] resval = jsonData.Split('♦');
        StringBuilder dataJson = new StringBuilder();
        if (jsonData == string.Empty)
            return;

        for (int j = 0; j < resval.Length; j++)
        {
            JArray memVarNode = null;
            try
            {
                JObject tstData = JObject.Parse(resval[j]);
                memVarNode = (JArray)tstData["memvar"];
            }
            catch (Exception ex)
            {
                logobj.CreateLog("ParseMemVarNode function -" + ex.Message, sessionid, "Exception-" + transid, "new");
            }

            if (memVarNode != null)
            {
                for (int m = 0; m < memVarNode.Count; m++)
                {
                    string memVarName = string.Empty;
                    string memVarValue = string.Empty;
                    string memVarType = string.Empty;

                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(memVarNode[m].ToString());

                    if (values.ContainsKey("n"))
                        memVarName = values["n"];
                    if (values.ContainsKey("v"))
                        memVarValue = values["v"];
                    if (values.ContainsKey("t"))
                        memVarType = values["t"];

                    memVarValue = CheckSpecialChars(memVarValue);
                    int idx = memVarNames.IndexOf(memVarName);
                    if (idx == -1)
                    {
                        memVarNames.Add(memVarName);
                        memVarValues.Add(memVarValue);
                        memVarTypes.Add(memVarType);
                    }
                    else
                    {
                        memVarNames[idx] = memVarName;
                        memVarValues[idx] = memVarValue;
                        memVarTypes[idx] = memVarType;
                    }
                }

                //Construct the fieldvaluexml for memvar node and update the global variable
                ConstructMemVarNode();
            }
        }
    }

    /// <summary>
    /// Function to construct the field value xml for memvar nodes from the arrays
    /// </summary>
    public void ConstructMemVarNode()
    {
        StringBuilder strXml = new StringBuilder();
        //strXml.Append("<axp_memvars>");
        for (int i = 0; i < memVarNames.Count; i++)
        {
            strXml.Append("<" + memVarNames[i].ToString() + " t='" + memVarTypes[i].ToString() + "'>" + memVarValues[i].ToString() + "</" + memVarNames[i].ToString() + ">");
        }
        //strXml.Append("</axp_memvars>");
        memVarsData = strXml.ToString();

    }

    public void JsonToArray(string jsonResult, TStructDef strObj, string tabDcNo, string calledFrom)
    {


        ChangedDcs.Clear();
        depFormatDcs.Clear();
        if (jsonResult == string.Empty) return;
        ArrayList tabDcs = new ArrayList();
        AxDepArrays = new StringBuilder();

        if (tabDcNo != "")
        {
            tabDcs = GetSubGridDcsInTabDC(strObj, tabDcNo);
            tabDcs.Add(tabDcNo);
        }

        //Get the non grid experssion dependent fields if the call is done from a grid field.
        ArrayList fldExpDeps = new ArrayList();
        if (calledFrom == "GetDepPerf")
            fldExpDeps = GetFldExpDependents(AxActDepField);

        // dcRowCntVals = new ArrayList();
        jsonResult = jsonResult.Replace("*$*", "♦");
        jsonResult = jsonResult.Replace("\\", ";bkslh");
        string[] resval = jsonResult.Split('♦');
        StringBuilder dataJson = new StringBuilder();
        tabJson = new StringBuilder();
        string dcHasDataRowsStr = string.Empty;
        string tabJsonPrefix = "{\"data\": [";
        string timeTakenJson = string.Empty;

        //Sub grid for GetDep related variables.
        bool isDcPopGrid = false;
        int dsRowNo = 0;

        for (int j = 0; j < resval.Length; j++)
        {
            //TODO: all other json nodes should be handled in the json parsing
            JArray Data = null;
            try
            {
                JObject tstData = JObject.Parse(resval[j]);
                Data = (JArray)tstData["data"];
            }
            catch (Exception ex)
            {
                logobj.CreateLog("JsonToArray function -" + ex.Message, sessionid, "Exception-" + transid, "new");
                logobj.CreateLog("JsonData -" + jsonResult, sessionid, "Exception-" + transid, "");
                //throw ex;
            }

            if (Data != null)
            {
                string fName = string.Empty;
                string fValue = string.Empty;
                string changedRows = string.Empty;
                string delRows = string.Empty;
                string rowNo = string.Empty;
                string fDatatype = string.Empty;
                string name = string.Empty;
                string fldName = string.Empty;
                string fldFrameNo = string.Empty;
                string frmNum = string.Empty;
                string frowValues = string.Empty;
                string fldIdValues = string.Empty;
                string idCol = string.Empty;
                string masterRow = string.Empty;
                string comboVal = string.Empty;
                string comboFld = string.Empty;
                string comboIdCol = "0";
                string dcNo = "0";
                string dpmStr = string.Empty;
                string dpValues = string.Empty;
                string idVal = string.Empty;
                string oldIdVal = string.Empty;
                string rowFromJson = string.Empty;
                int DCPriorRowCount = 0;
                string fillGridName = string.Empty;
                StringBuilder ddlVals = new StringBuilder();
                StringBuilder ddlDpVals = new StringBuilder();
                bool isTabDc = false;
                for (int m = 0; m < Data.Count; m++)
                {
                    fDatatype = "";
                    idCol = "";
                    changedRows = string.Empty;
                    delRows = string.Empty;
                    masterRow = string.Empty;

                    dpValues = "";
                    string dcHasRows = string.Empty;
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(Data[m].ToString());


                    if (values.ContainsKey("t"))
                        fDatatype = values["t"];
                    if (values.ContainsKey("n"))
                        fName = values["n"];
                    if (values.ContainsKey("v"))
                        fValue = values["v"];
                    if (values.ContainsKey("cr"))
                        changedRows = values["cr"];
                    if (values.ContainsKey("fg"))
                        fillGridName = values["fg"];
                    if (values.ContainsKey("dr"))
                        delRows = values["dr"];
                    if (values.ContainsKey("mr"))
                        masterRow = values["mr"];
                    if (values.ContainsKey("idcol"))
                        idCol = values["idcol"];
                    if (values.ContainsKey("id"))
                        idVal = values["id"];
                    if (values.ContainsKey("oldid"))
                        oldIdVal = values["oldid"];
                    if (values.ContainsKey("r"))
                    {
                        rowNo = values["r"];
                        if (rowNo.Length == 1)
                            rowNo = "00" + rowNo;
                        else if (rowNo.Length == 2)
                            rowNo = "0" + rowNo;
                        rowFromJson = rowNo;
                    }
                    if (values.ContainsKey("dp"))
                        dpValues = values["dp"];
                    if (values.ContainsKey("dpm"))
                        dpmStr = values["dpm"];


                    string rowValues = string.Empty;
                    if (idCol == "no" || idCol == "")
                        idCol = "0";
                    else
                        idCol = "1";

                    if (fName != string.Empty)
                    {
                        //This condition will get the fields in the tab dc which have master row true.
                        if (masterRow == "1" && dcNo == tabDcNo)
                        {
                            if (AxMasterRowFlds.IndexOf(fName) == -1)
                                AxMasterRowFlds.Add(fName);
                        }

                        fValue = fValue.Replace("^^dq", "&quot;");
                        fValue = fValue.Replace(";bkslh", "\\");

                        //To copy the dc2_referimage file from the given path to Axpert Session folder
                        if ((fName.StartsWith("dc") && fName.ToLower().EndsWith("_imagepath")))
                            hasImagePath = true;
                        if (fName.ToLower().Contains("dc2_referimages") && fValue != string.Empty)
                            GetReferedFiles(fValue, hasImagePath);

                        //TODO: Same code is available in TStructData constructor and UpdateDataList.
                        //if (fName.ToLower() == "axpcurrencydec")
                        //    CheckAxpCurrDec(fName, fValue);

                        if (fDatatype != "c" && fDatatype != "dv")
                            dpmStr = string.Empty;

                        string rowVal = "";

                        if (fDatatype == "c" || fDatatype == "cl" || fDatatype == "rg")
                        {
                            comboVal = fValue;
                            comboFld = fName;
                            comboIdCol = idCol;
                        }
                        else if (fDatatype == "dv")
                        {
                            rowVal = fValue;
                            if (rowValues == "")
                                rowValues = rowVal;
                            else
                                rowValues += "" + rowVal;

                            string[] temp = rowVal.Split('?');
                            if (temp.Length <= 3 && comboVal == string.Empty)
                            {
                                StringBuilder strVal = new StringBuilder();
                                for (int i = 0; i < temp.Length; i++)
                                {
                                    if (temp[i].ToString() != string.Empty)
                                        strVal.Append(temp[i].ToString());
                                }
                                if (strVal.ToString().ToLower() == "yesno" || strVal.ToString().ToLower() == "noyes")
                                {
                                    //To set the default value of checkbox in the grid dc to "no".
                                    fValue = "no";
                                }
                            }

                            if (dpValues != string.Empty)
                            {
                                string[] dpVals = dpValues.Split('~');
                                string[] depFlds = dpmStr.Split(',');
                                string cbVal = string.Empty;
                                if (comboIdCol == "1")
                                    cbVal = fValue.Substring(fValue.IndexOf("~") + 1);
                                else
                                    cbVal = fValue;
                                cbVal = CheckSpecialChars(cbVal);
                                for (int depIdx = 0; depIdx < depFlds.Length; depIdx++)
                                {
                                    AxDepArrays.Append("ComboParentField.push(\"" + comboFld + "\");ComboParentValue.push(\"" + cbVal + "\");ComboDepField.push(\"" + depFlds[depIdx] + "\");ComboDepValue.push(\"" + dpVals[depIdx] + "\");");
                                }

                            }
                        }
                        else if (fDatatype == "dc")
                        {
                            if (values.ContainsKey("hasdatarows"))
                                dcHasRows = values["hasdatarows"];

                            comboFld = "";
                            string dcRowCount = fName + "~" + fValue;
                            dcNo = fName.Substring(2);
                            DCPriorRowCount = 0;
                            //Code to avoid tabbed dc and its sub grid in the construction of json for GetTabData.
                            int tabIndx = tabDcs.IndexOf(dcNo);
                            if (tabIndx != -1)
                                isTabDc = true;
                            else
                                isTabDc = false;

                            if (strObj.IsDcFormatGrid(Convert.ToInt32(dcNo)))
                            {
                                depFormatDcs.Add(dcNo);
                                isTabDc = true;
                            }

                            if (isTabDc)
                            {
                                dcHasDataRowsStr = "{\"n\":\"DC" + dcNo + "\",\"v\":\"" + fValue + "\",\"t\":\"dc\",\"hasdatarows\":\"" + dcHasRows + "\"}";
                            }

                            bool dcOldHasRows = false;
                            bool isGrid = IsDcGrid(dcNo, strObj);
                            TStructDef.DcStruct dc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(dcNo) - 1];
                            if (dc.ispopgrid)
                                isDcPopGrid = true;
                            else
                                isDcPopGrid = false;
                            if (isGrid)
                            {
                                if (dcHasRows != "")
                                {
                                    dcOldHasRows = dc.DCHasDataRows;
                                    if (dcHasRows == "yes")
                                        dc.DCHasDataRows = true;
                                    else
                                        dc.DCHasDataRows = false;
                                    tstStrObj.dcs[Convert.ToInt32(dcNo) - 1] = dc;
                                }
                            }

                            if (fValue == "0")
                            {
                                fValue = "1";
                                dcRowCount = fName + "~" + fValue;
                            }

                            if (isDcPopGrid && calledFrom == "GetDepPerf" && IsParentDc(AxActiveDc))
                            {
                                //Code to add the dr attribute recids to deleted row information.
                                if (delRows != string.Empty)
                                    SetPopDeletedRows(dcNo, delRows);
                                // delete the old subgrid rows sent to the webservice for the getdep call
                                DeletePopRowsAfterDep();
                                AxSubGridRows = new ArrayList();
                                subWsRows = new ArrayList();
                                subDsRows = new ArrayList();
                                dsRowNo = 1;
                                //Since the full sub grid data will not be sent to the webservice, 
                                //the row numbers will always start from 1 hence appending the rows to the grid.
                                DCPriorRowCount = GetDcRowCount(dcNo);
                            }

                            if (changedRows != "" && isGrid)
                            {
                                if (dcOldHasRows == false && dcHasRows == "yes")
                                    changedRows = "d*," + changedRows;
                                if (ChangedDcs.IndexOf(dcNo) == -1)
                                    ChangedDcs.Add(dcNo);

                                //If the dc has fill grid, and if the fillgrid condition is INIT or AOWE 
                                //then the existing rows should be cleared and added.
                                //The same condition is also added in ExecData in process.js
                                int fgIdx = GetDcFillGridIndex(fName, fillGridName);
                                if (fgIdx != -1 && calledFrom != "ExecAction" && calledFrom != "AddRow")
                                {
                                    TStructDef.FGStruct fg = (TStructDef.FGStruct)tstStrObj.fgs[fgIdx];
                                    if (fg.FGCondition == Constants.INIT || fg.FGCondition == Constants.AOWE)
                                    {
                                        if (changedRows.IndexOf("d*") == -1)
                                            changedRows = "d*," + changedRows;
                                        if (IsParentDc(dcNo))
                                        {
                                            ArrayList arrPopDcs = new ArrayList();
                                            arrPopDcs = GetPopDcsForParent(dcNo);
                                            for (int pIdx = 0; pIdx < arrPopDcs.Count; pIdx++)
                                            {
                                                TStructDef.DcStruct pdc = (TStructDef.DcStruct)tstStrObj.dcs[Convert.ToInt32(arrPopDcs[pIdx].ToString()) - 1];
                                                if (pdc.DCHasDataRows)
                                                    SetDbRows("d*", pdc.frameno.ToString(), tstStrObj, "");

                                            }
                                        }
                                    }
                                    else if (fg.FGCondition == Constants.APPEND && dcHasRows == "yes" && calledFrom == "Action")
                                    {
                                        DCPriorRowCount = 0;// GetDcRowCount(dcNo);
                                        if (changedRows.IndexOf("d*") != -1)
                                            dcRowCount = fName + "~" + (Convert.ToInt32(fValue));
                                        else
                                            dcRowCount = fName + "~" + (Convert.ToInt32(fValue) + GetDcRowCount(dcNo));
                                    }
                                    else if (fg.FGCondition == Constants.APPEND && dcOldHasRows)
                                    {
                                        DCPriorRowCount = GetDcRowCount(dcNo);
                                        dcRowCount = fName + "~" + (Convert.ToInt32(fValue) + GetDcRowCount(dcNo));
                                    }
                                }

                                if (dcHasRows == "yes" || (dcOldHasRows && dcHasRows == "no"))
                                {
                                    //The cr attribute from the getdep will be ignored for subgrid
                                    if (isDcPopGrid && calledFrom == "GetDepPerf" && IsParentDc(AxActiveDc))
                                        continue;
                                    SetDbRows(changedRows, dcNo, strObj, calledFrom);
                                }
                            }
                            else if (calledFrom == "FillGridMS" && isGrid && dcOldHasRows == false && dcHasRows == "yes")//Refer Bug: HEA000021-- Multy select fillgrid having hidden row its not adding based on srvice result. 
                            {
                                SetDbRows("d*", dcNo, strObj, calledFrom);
                            }
                            UpdateRowCount(fName, dcRowCount);
                        }
                        else
                        {
                            //Code for setting default item value for auto select
                            comboFld = "";
                        }

                        //The isTabDc can be used for format grid dc, for returning the json without format grid data.
                        if (!isTabDc)
                        {
                            if (dataJson.ToString() == "")
                                dataJson.Append(Data[m].ToString());
                            else
                                dataJson.Append("," + Data[m].ToString());
                        }
                        else
                        {

                            if (dcHasDataRowsStr != "")
                            {
                                if (dataJson.ToString() == "")
                                    dataJson.Append(dcHasDataRowsStr);
                                else
                                    dataJson.Append("," + dcHasDataRowsStr);

                                dcHasDataRowsStr = string.Empty;
                            }
                        }

                        if (fDatatype == "dv")
                        {
                            ddlVals.Append(rowValues);
                            ddlVals.Append("♣");
                            ddlDpVals.Append(dpValues);
                            ddlDpVals.Append("♣");
                            DSUpdateRowValues(fName, Convert.ToInt32(rowNo) + DCPriorRowCount, ddlVals.ToString(), ddlDpVals.ToString(), masterRow, comboIdCol);
                        }
                        else
                        {
                            ddlVals = new StringBuilder();
                            if (fDatatype != "dc")
                            {
                                string rowFrmNo = string.Empty;
                                if (rowNo != "")
                                {
                                    name = fName + rowNo + "F" + dcNo;
                                    rowFrmNo = rowFrmNo + "F" + dcNo;
                                }
                                //If the get dependents is called on a grid field, then the below code will ignore all expression dependents in the non grid.
                                if (calledFrom == "GetDepPerf")
                                {
                                    if (fldExpDeps.IndexOf(fName) != -1)
                                        continue;
                                }

                                if (isDcPopGrid && calledFrom == "GetDepPerf" && IsParentDc(AxActiveDc))
                                {
                                    dsRowNo = GetSubDsRowNo(Convert.ToInt32(rowNo), dcNo);
                                    DSSubmit(fName, dsRowNo, fValue, idVal);
                                }
                                else
                                    DSSubmit(fName, Convert.ToInt32(rowNo) + DCPriorRowCount, fValue, idVal);
                            }
                        }
                    }
                }
            }
            else
            {

                ParseJsonNodes(resval[j].ToString());
                JArray timeTaken = null;
                try
                {
                    JObject tstData = JObject.Parse(resval[j]);
                    timeTaken = (JArray)tstData["timetaken"];
                }
                catch (Exception ex)
                {

                }

                if (timeTaken != null)
                {
                    timeTakenJson = resval[j].ToString() + "*$*";
                    continue;
                }

                if (dataJson.ToString() != "")
                {
                    tabJson.Insert(0, tabJsonPrefix);
                    tabJson.Append(dataJson + "]}");
                    dataJson.Remove(0, dataJson.ToString().Length);
                }
                tabJson.Append(resval[j].ToString());
            }
        }
        if (dataJson.ToString() != "")
        {
            tabJson.Insert(0, tabJsonPrefix);
            tabJson.Append(dataJson + "]}");
            dataJson.Remove(0, dataJson.ToString().Length);
            tabJson.Insert(0, timeTakenJson);
        }

        //Call the function which parses thge memvar node and updates the arrays.
        ParseMemVarNode(jsonResult, calledFrom);
    }


    //Function to get the exact rowno for the new row being added.
    private int GetSubDsRowNo(int wsRowNo, string dcNo)
    {
        int dsRowNo = 0;
        int idx = -1;
        idx = subWsRows.IndexOf(wsRowNo);
        if (idx == -1)
        {
            subWsRows.Add(wsRowNo);
            dsRowNo = GetDcRowCount(dcNo) + 1;
            subDsRows.Add(dsRowNo);
        }
        else
        {
            dsRowNo = (Int32)subDsRows[idx];
        }

        return dsRowNo;
    }

    /// <summary>
    /// Function return true if the given dc is a parent dc.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <returns></returns>
    private bool IsParentDc(string dcNo)
    {
        bool isParDc = false;
        for (int i = 0; i < tstStrObj.popdcs.Count; i++)
        {
            if (dcNo == ((TStructDef.PopDcStruct)(tstStrObj.popdcs[i])).pdcno.ToString())
            {
                isParDc = true;
                break;
            }
        }
        return isParDc;
    }

    /// <summary>
    /// Function returns array of popdcs defined for a given dc.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <returns></returns>
    public ArrayList GetPopDcsForParent(string dcNo)
    {
        ArrayList arrPopDcs = new ArrayList();
        for (int i = 0; i < tstStrObj.popdcs.Count; i++)
        {
            if (dcNo == ((TStructDef.PopDcStruct)(tstStrObj.popdcs[i])).pdcno.ToString())
            {
                arrPopDcs.Add(((TStructDef.PopDcStruct)(tstStrObj.popdcs[i])).frameno);
            }
        }
        return arrPopDcs;
    }

    /// <summary>
    /// Function to get the non grid expression dependents for a field.
    /// </summary>
    /// <param name="fName"></param>
    /// <returns></returns>
    private ArrayList GetFldExpDependents(string fName)
    {
        int idx = tstStrObj.GetFieldIndex(fName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        ArrayList fldExpDep = new ArrayList();
        string[] fldDeps = fld.fieldDependents.Split(',');
        for (int i = 0; i < fldDeps.Length; i++)
        {
            string depFldName = fldDeps[i].ToString();
            string prefix = depFldName.Substring(0, 1);
            int depIdx = tstStrObj.GetFieldIndex(depFldName.Substring(1));
            if (depIdx != -1)
            {
                TStructDef.FieldStruct depFld = (TStructDef.FieldStruct)tstStrObj.flds[depIdx];
                if (prefix == "e" && fld.fldframeno > depFld.fldframeno && !IsDcGrid(depFld.fldframeno.ToString(), tstStrObj))
                {
                    fldExpDep.Add(fldDeps[i].ToString());
                }
            }
        }
        return fldExpDep;
    }

    /// <summary>
    /// Function to get the dependent grid dc for a given field.
    /// </summary>
    /// <param name="fieldName"></param>
    /// <returns></returns>
    public ArrayList GetGridDepForField(string fieldName)
    {
        int idx = tstStrObj.GetFieldIndex(fieldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        ArrayList sqlDepDc = new ArrayList();
        string[] fldDeps = fld.fieldDependents.Split(',');
        for (int i = 0; i < fldDeps.Length; i++)
        {
            string depFldName = fldDeps[i].ToString();
            string prefix = depFldName.Substring(0, 1);
            int depIdx = tstStrObj.GetFieldIndex(depFldName.Substring(1));
            if (depIdx != -1)
            {
                TStructDef.FieldStruct depFld = (TStructDef.FieldStruct)tstStrObj.flds[depIdx];
                if (prefix != "e" && sqlDepDc.IndexOf(depFld.fldframeno) == -1 && IsDcGrid(depFld.fldframeno.ToString(), tstStrObj))
                {
                    sqlDepDc.Add(depFld.fldframeno);
                }
            }
        }
        return sqlDepDc;
    }

    private void StringToFile(string strDebugText)
    {
        if (!isDebugFileCreated)
        {
            logobj.CreateLog(strDebugText, HttpContext.Current.Session["nsessionid"].ToString(), "DebugValues", "new");
            isDebugFileCreated = true;
        }
        logobj.CreateLog(strDebugText, HttpContext.Current.Session["nsessionid"].ToString(), "DebugValues", "");

    }

    private void ParseJsonNodes(string result)
    {
        if (result == string.Empty) return;
        JArray cmdNode = null;
        try
        {
            JObject tstData = JObject.Parse(result);
            cmdNode = (JArray)tstData["command"];
        }
        catch (Exception ex)
        {
            logobj.CreateLog("ParseJsonNodes function -" + ex.Message, sessionid, "Exception-" + transid, "new");
        }

        if (cmdNode != null)
        {
            string cmdName = string.Empty;
            string cmdVal = string.Empty;
            for (int i = 0; i < cmdNode.Count; i++)
            {
                Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(cmdNode[i].ToString());


                for (int k = 0; k < values.Count; k++)
                {
                    if (values.ContainsKey("cmd"))
                        cmdName = values["cmd"];
                    if (values.ContainsKey("cmdval"))
                        cmdVal = values["cmdval"];

                    if (cmdName == "newtrans" || cmdName == "copytrans")
                    {
                        recordid = "0";
                        recordID = "0";
                        rid = "0";
                        ModifyAsNewRecord();
                        break;
                    }
                }
            }
        }
    }

    public string GetMasterRowFlds()
    {
        string AxFlds = string.Empty;
        for (int i = 0; i < AxMasterRowFlds.Count; i++)
        {
            if (AxFlds == string.Empty)
                AxFlds = AxMasterRowFlds[i].ToString();
            else
                AxFlds += "," + AxMasterRowFlds[i].ToString();
        }

        return AxFlds == string.Empty ? "Ax-NA" : AxFlds;
    }

    private void SetDbRowsOnLoad(string changedRows, string dcNo, TStructDef strObj)
    {
        int frameNo = Convert.ToInt32(dcNo);
        string[] rowStr = changedRows.Split(',');

        for (int i = 0; i < rowStr.Length; i++)
        {
            string firstChar = rowStr[i].Substring(0, 1);
            string rowNo = rowStr[i].Substring(1);
            if (firstChar == "d")
            {
                if (rowNo == "*")
                    DeleteAllRowsInDc(dcNo);
                else
                    DeleteRowInFldArrays(dcNo, rowNo);
            }
        }
    }

    public void SetSubGridRows(string subGridRows)
    {//The string will be in the format of popdc1~row1,row2,row3¿popdc2~row1,row2
        if (subGridRows != string.Empty)
        {
            string[] subrows = subGridRows.Split('¿');
            for (int i = 0; i < subrows.Length; i++)
            {
                if (subrows[i].ToString() != string.Empty)
                {
                    AxSubGridRows.Add(subrows[i].ToString());
                }
            }
        }
    }

    private void SetDbRows(string changedRows, string dcNo, TStructDef strObj, string calledFrom)
    {
        int frameNo = Convert.ToInt32(dcNo);
        string[] rowStr = changedRows.Split(',');

        for (int i = 0; i < rowStr.Length; i++)
        {
            if (rowStr[i] == string.Empty)
                continue;
            try
            {
                string firstChar = rowStr[i].Substring(0, 1);
                string rowNo = rowStr[i].Substring(1);
                if (firstChar == "d")
                {
                    if (rowNo == "*")
                        DeleteAllRowsInDc(dcNo);
                    else
                        DeleteRowInFldArrays(dcNo, rowNo);
                }
            }
            catch (Exception ex)
            {
                logobj.CreateLog(ex.StackTrace, HttpContext.Current.Session["nsessionid"].ToString(), "Exception", "new");
            }
        }
    }

    private string GetMaxDcRowNo(string dcNo)
    {
        int rowNo = 0;
        for (int i = 0; i < fieldControlName.Count; i++)
        {
            if (fieldFrameNo[i].ToString() == dcNo)
            {
                string rNo = fieldRowNo[i].ToString();
                if (Convert.ToInt32(rNo) > rowNo)
                    rowNo = Convert.ToInt32(rNo);
            }
        }

        return GetRowNoHelper(Convert.ToString(rowNo + 1));
    }

    private string GetFieldsRowNo(string fldId)
    {
        int idx = fldId.LastIndexOf("F");
        if (idx != -1)
            return fldId.Substring(idx - 3, 3);
        else
            return "000";
    }

    private string GetRowNoHelper(string rowNo)
    {
        if (rowNo.Length == 1)
            rowNo = "00" + rowNo;
        else if (rowNo.Length == 2)
            rowNo = "0" + rowNo;
        return rowNo;
    }

    private string CreateDataJson(Boolean IsDc, string dcNo, string Value, string rowCnt, string dataJson)
    {
        string dcDataRowsStr = string.Empty;
        if (IsDc)
            dcDataRowsStr = "{\"n\":\"DC" + dcNo + "\",\"v\":\"" + rowCnt + "\",\"t\":\"dc\"}";
        else
            dcDataRowsStr = "{\"n\":\"axp_recid" + dcNo + "\",\"v\":\"0\",\"r\":\"" + rowCnt + "\",\"t\":\"s\"}";
        if (dataJson.ToString() != "")
            dcDataRowsStr = "," + dcDataRowsStr;

        return dcDataRowsStr;
    }

    public void UpdateRowCount(string dcNo, string newRowCnt)
    {
        int index = -1;
        for (int i = 0; i < dcRowCntVals.Count; i++)
        {
            string[] dcRCnt = dcRowCntVals[i].ToString().Split('~');
            if (dcRCnt[0].ToString().ToLower() == dcNo.ToLower())
            {
                index = i;
                break;
            }
        }

        if (index == -1)
            dcRowCntVals.Add(newRowCnt);
        else
            dcRowCntVals[index] = newRowCnt;
    }

    /// <summary>
    /// Function to get the fields index from the fieldControlName array.
    /// </summary>
    /// <param name="fieldName"></param>
    /// <returns></returns>
    public int GetFieldIndex(string fldName)
    {
        for (int j = 0; j < fieldControlName.Count; j++)
        {
            if (fieldControlName[j] != null)
            {
                if (fieldControlName[j].ToString() == fldName)
                {
                    return j;
                }
            }
        }

        return -1;
    }

    public string CallDeleteDataWS(string s)
    {
        DateTime stTime = DateTime.Now;
        string news = GetTraceString(s);
        if (news != "") s = news;
        s = s + HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString() + "</Transaction>";
        string result = null;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        DateTime asStart = DateTime.Now;
        result = objWebServiceExt.CallDeleteDataWS(transid, s);
        DateTime asEnd = DateTime.Now;
        if (result.ToLower().IndexOf("data deleted successfully") > -1)
        {
            ClearIviewDataKey();
            RemoveAttachFromServer(s, transid);
        }
        //RemoveAttachFromDir("");
        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }

    public string CallAddRowWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "", "NG", dcNo);
        s += tstData.fieldValueXml + memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        string result = string.Empty;

        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallAddRowWS(transid, s, ires);
        return result;
    }

    public string CallAddRowPerfWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        tstData.GetPerfFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "", "NG", dcNo);
        s += WsPerfAddRowLoadDc(dcNo, "AddRow");
        s += memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        string result = string.Empty;

        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallAddRowWS(transid, s, ires);
        return result;
    }

    private string WsPerfAddRowLoadDc(string dcno, string calledFrom)
    {
        string iXml = string.Empty;
        int dcFrame = int.Parse(dcno);
        TStructDef.DcStruct pfldDc = (TStructDef.DcStruct)tstStrObj.dcs[dcFrame - 1];
        if (pfldDc.dcPList != "")
        {
            string[] parentFlds = pfldDc.dcPList.Replace("~", ",").Split(',');
            string globalVars = HttpContext.Current.Session["axGlobalVars"].ToString();
            string userVars = HttpContext.Current.Session["axUserVars"].ToString();
            for (int i = 0; i < parentFlds.Length; i++)
            {
                int pIndx = tstStrObj.GetFieldIndex(parentFlds[i]);
                if (pIndx == -1)
                {
                    if (globalVars.ToLower().IndexOf("<" + parentFlds[i].ToLower() + ">") > -1)
                        continue;
                    else if (userVars.ToLower().IndexOf("<" + parentFlds[i].ToLower() + ">") > -1)
                        continue;
                    else
                        continue;
                }
                TStructDef.FieldStruct pfld = (TStructDef.FieldStruct)tstStrObj.flds[pIndx];
                if (calledFrom == "AddRow" || calledFrom == "DeleteRow")
                    iXml += PerfGetDepFldValues(pfld.fldFrameNo, 0, calledFrom, pfld);
                else if ((calledFrom == "LoadDc" || calledFrom == "FillGrid") && pfld.fldFrameNo != dcFrame)
                    iXml += PerfGetDepFldValues(pfld.fldFrameNo, 0, calledFrom, pfld);
            }
        }
        return iXml;
    }

    private string WsPerfFieldToXML(string fldName, string rowNo, string value, string oldValue, string idvalue, string oldIdValue, string dcNo, Boolean fldSaveNormal, TStructDef.FieldStruct fld = new TStructDef.FieldStruct())
    {
        string dsDataXML = string.Empty;
        rowNo = GetRowNoHelper(rowNo.ToString());
        value = CheckSpecialChars(value);
        oldValue = CheckSpecialChars(oldValue);
        string oldVal = "";
        if (recordid != "0")
        {
            if (value != oldValue)
                oldVal = "ov=\"" + oldValue + "\"";
            else
                oldVal = "";
        }
        if (fldName.StartsWith(Constants.IMGPrefix))
            return dsDataXML;
        if (fld.datatype != null && fld.datatype.ToLower() == "image" && imgAttachPath != "")
            return dsDataXML;
        if (fldSaveNormal)
        {
            if (Convert.ToString(idvalue) == "") idvalue = "0";
            if (Convert.ToString(oldIdValue) == "") oldIdValue = "0";
            dsDataXML += "<" + fldName + " rowno=\"" + rowNo + "\" id=\"" + idvalue + "\" oldid=\"" + oldIdValue + "\" " + oldVal + ">" + value + "</" + fldName + ">";
        }
        else
        {
            dsDataXML += "<" + fldName + " rowno=\"" + rowNo + "\" " + oldVal + ">" + value + "</" + fldName + ">";
        }
        return dsDataXML;
    }

    public string CallDeleteRowWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "", "NG", dcNo);
        s += tstData.fieldValueXml + memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        string result = string.Empty;
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallDeleteRowWS(transid, s, ires);
        return result;
    }

    public string CallDeleteRowPerfWS(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string s, string dcNo)
    {
        string news = GetTraceString(s);
        if (news != "") s = news;
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        tstData.GetPerfFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "", "NG", dcNo);
        s += WsPerfAddRowLoadDc(dcNo, "DeleteRow");
        s += memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        s += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        s += "</sqlresultset>";
        string result = string.Empty;
        bool callService = false;
        if (tstStrObj.wsPerfEnabled == true)
        {
            if (tstStrObj.wsPerfGRDDcs != null && tstStrObj.wsPerfGRDDcs.IndexOf(dcNo) != -1)
                callService = true;
        }
        else
            callService = true;
        if (callService)
        {
            objWebServiceExt = new ASBExt.WebServiceExt();
            result = objWebServiceExt.CallDeleteRowWS(transid, s, ires);
        }
        return result;
    }

    public string LoadComboValues(TStructData tstData, ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string iXml, string dcNo)
    {
        DateTime stTime = DateTime.Now;
        string strTrace = GetTraceString(iXml);
        if (strTrace != "") iXml = strTrace;
        string result = string.Empty;
        //GetGlobalVars();
        transid = tstData.transid.ToString();
        ires = tstStrObj.structRes;
        //tstData.GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "LoadTab", "NG", dcNo);
        //iXml += tstData.fieldValueXml + memVarsData;
        tstData.GetPerfFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "LoadTab", "NG", dcNo);
        iXml += WsPerfAddRowLoadDc(dcNo, "LoadDc");
        iXml += memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        iXml += "</sqlresultset>";
        //Call service     
        objWebServiceExt = new ASBExt.WebServiceExt();
        DateTime asStart = DateTime.Now;

        if (CallWsPerfLoadDc(dcNo))
            result = objWebServiceExt.CallLoadDCCombosWS(transid, iXml, ires);
        DateTime asEnd = DateTime.Now;
        if (logTimeTaken)
        {
            webTime1 = asStart.Subtract(stTime).TotalMilliseconds;
            webTime2 = DateTime.Now.Subtract(asEnd).TotalMilliseconds;
            asbTime = asEnd.Subtract(asStart).TotalMilliseconds;
        }
        return result;
    }

    private bool CallWsPerfLoadDc(string dcNo)
    {
        bool isCallDcCombo = false;
        //If dc has fillgrid
        if (dcNo != "" && tstStrObj.wsPerfFGDcName != null && rid == "0")
        {
            string[] flGridDc = tstStrObj.wsPerfFGDcName;
            var loaddcFG = flGridDc.Where(d => d.ToLower() == "dc" + dcNo).ToList();
            if (loaddcFG.Count > 0)
                isCallDcCombo = true;
        }
        //Below condition not required to now becuse of accept sql field will take cae either doformload, addrow or getdependency 
        ////If dc has accept sql or select with auto select fields
        //if (tstStrObj.wsPerfLDcName != null && isCallDcCombo == false && rid == "0")
        //{
        //    string[] fldldCall = tstStrObj.wsPerfLDcName;
        //    var loaddcFld = fldldCall.Where(fd => fd.ToLower() == "dc" + dcNo).ToList();
        //    if (loaddcFld.Count > 0)
        //        isCallDcCombo = true;
        //}
        return isCallDcCombo;
    }

    public string GetSubGridCombos(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string iXml, string dcNo, string parDcNo, int popRowNo, int parRowNo)
    {
        string strTrace = GetTraceString(iXml);
        if (strTrace != "") iXml = strTrace;
        string result = string.Empty;
        ires = tstStrObj.structRes;
        GetPopFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", parDcNo, parRowNo, dcNo, popRowNo);
        iXml += fieldValueXml + memVarsData;
        iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + HttpContext.Current.Session["axUserVars"].ToString();
        iXml += "</sqlresultset>";
        //Call service     
        objWebServiceExt = new ASBExt.WebServiceExt();
        result = objWebServiceExt.CallGetSubGridCCombosWS(transid, iXml, ires);
        return result;
    }


    #endregion

    #endregion

    private void UpdateRowValues(string fldName, string rowNo, string dcNo, string comboValues, string dpValues)
    {
        int idx = GetFldIndex(Convert.ToInt32(dcNo), fldName, Convert.ToInt32(rowNo));
        if (idx != -1)
        {
            fieldRowValues[idx] = comboValues;
            fieldDPVals[idx] = dpValues;
        }
    }

    public bool IsDcGrid(string dcNo, TStructDef strObj)
    {
        bool isGrid = false;
        for (int i = 0; i < strObj.dcs.Count; i++)
        {
            TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[i];
            if (dc.frameno.ToString() == dcNo && dc.isgrid == true)
            {
                isGrid = true;
                break;
            }
        }
        return isGrid;
    }

    public int GetDcRowCount(string dcNo)
    {
        return dsDataSet.Tables["dc" + dcNo].Rows.Count;
    }

    #region PickList Methods
    /// <summary>
    /// Function to call the webservice which returns the filtered value for the picklist field.
    /// </summary>
    /// <param name="iXml"></param>
    /// <returns></returns>
    public string GetPickListResult(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string iXml, string structXml, string fldName, string frameNo, string parentInfo, string subGridInfo, string activeRow, string includeDcs)
    {
        string res = "";
        GetPicklistInputXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, fldName, frameNo, parentInfo, subGridInfo, activeRow);
        iXml += this.fieldValueXml + memVarsData;
        string dbmemvarsXML = GetDBMemVarsXML(transid);
        string cdVarsXML = GetConfigDataVarsXML(transid);
        iXml += HttpContext.Current.Session["axApps"].ToString() + HttpContext.Current.Application["axProps"].ToString() + HttpContext.Current.Session["axGlobalVars"].ToString() + dbmemvarsXML + cdVarsXML + HttpContext.Current.Session["axUserVars"].ToString();
        iXml += "</sqlresultset>";
        //Call service
        objWebServiceExt = new ASBExt.WebServiceExt();
        iXml = util.CheckSplChrInputXML(iXml);
        res = objWebServiceExt.CallGetSearchResultWS(transid, iXml, structXml);
        if (res != "done" && res != "" && !res.StartsWith(Constants.ERROR))
        {
            res = ParsePickListJson(res);
        }
        return res;
    }

    public void GetPicklistInputXml(ArrayList fldArray, ArrayList fldDbRowNo, ArrayList fldValueArray, ArrayList fldDeletedArray, string fldName, string frameNo, string parentInfo, string subGridInfo, string activeRow)
    {
        int idx = tstStrObj.GetFieldIndex(fldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[idx];
        ArrayList AxDepFields = new ArrayList();
        bool isDcGrid = false;
        Dictionary<string, string> IncludeDcRows = new Dictionary<string, string>();
        isDcGrid = IsDcGrid(frameNo, tstStrObj);

        if (isDcGrid)
        {
            string DepFlds = fld.fieldSqlDepParents;
            AxDepFields = GetParDepFlds(fld.fieldSqlDepParents);
        }

        if (fld.fieldSqlGridDeps != string.Empty)
        {
            string[] strSDeps = fld.fieldSqlGridDeps.Split(',');
            for (int i = 0; i < strSDeps.Length; i++)
            {
                AxDepFields.Add(strSDeps[i].ToString());
            }

            //The below statement will add the current field to the dependent fields if the current dc is a grid dc 
            //and it has dependents in other grid, then all the row values for the field should be sent in the input xml.
            if (isDcGrid)
                AxDepFields.Add(fld.name);
        }


        //If the field has non grid sql dependents, then send the parent values for that dep field also
        if (IsDcGrid(frameNo, tstStrObj))
        {
            //If the call is made from a parent grid, then all its subgriud and their respective rows for the given parent row 
            //will be sent in the given format: dcno~rowno1,rowno2¿dcno~rowno1,rowno2...
            if (subGridInfo != "")
            {
                if (subGridInfo.IndexOf("¿") != -1)
                {
                    string[] subgridDcs = subGridInfo.Split('¿');
                    for (int i = 0; i < subgridDcs.Length; i++)
                    {
                        string[] dcInfo = subgridDcs[i].ToString().Split('~');
                        IncludeDcRows.Add(dcInfo[0], dcInfo[1]);
                    }
                }
                else
                {
                    IncludeDcRows.Add(subGridInfo.Substring(0, subGridInfo.IndexOf("~")), subGridInfo.Substring(subGridInfo.IndexOf("~") + 1));
                }
            }

            //If the call is made from sub grid, then the parentinfo will contain the parent dc no and parent row no in the given format : dcno~rowno
            if (parentInfo != "")
            {
                IncludeDcRows.Add(parentInfo.Substring(0, parentInfo.IndexOf("~")), parentInfo.Substring(parentInfo.IndexOf("~") + 1));
            }


            //first update the list with the new fldArray.
            UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);

            DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);

            CreateFieldValueXmlPerf(frameNo, activeRow, AxDepFields, fld.fieldDepGridDcs, IncludeDcRows, "");
        }
        else
        {
            if (AxDepFields.Count > 0)
            {
                //if a non grid fields has dependent grid dc fields, then send that dc fields data also.            
                //first update the list with the new fldArray.
                UpdateDataList(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray);
                DeleteDefaultRowInPopDc(project, user, transid, sessionid, AxRole);
                CreateFieldValueXmlPerf(frameNo, activeRow, AxDepFields, fld.fieldDepGridDcs, IncludeDcRows, "");
            }
            else
            {
                //if a non grid fields has dependent grid Fill grid dc, then send that dc data also.            
                GetFieldValueXml(fldArray, fldDbRowNo, fldValueArray, fldDeletedArray, "-1", "GetDependents", "NG", fld.fieldDepFillDcs);
            }
        }
    }

    /// <summary>
    /// Function to parse the result of GetSearchResult service and construct the  result string and return to the client.
    /// </summary>
    /// <param name="result"></param>
    /// <returns></returns>
    private string ParsePickListJson(string result)
    {
        StringBuilder pickDataArray = new StringBuilder();
        JArray Data;
        try
        {
            result = result.Replace("\\", ";bkslh");
            JObject tstData = JObject.Parse(result);
            Data = (JArray)tstData["pickdata"];
        }
        catch (Exception ex)
        {
            throw ex;
        }

        if (Data != null)
        {
            string fName = string.Empty;
            string fValue = string.Empty;
            for (int m = 0; m < Data.Count; m++)
            {
                if (Data[m]["rcount"] != null)
                {
                    string rCount = Data[m]["rcount"].ToString();
                    rCount = rCount.Replace("\"", "");
                    if (rCount != "0")
                        pickDataArray.Append(rCount + "♣");
                }
                else if (Data[m]["fname"] != null)
                {
                    fName = (string)Data[m]["fname"].ToString();
                }
                else
                {
                    fValue = (string)Data[m]["fvalue"].ToString();
                    //Following Code was removing first and last character of fname and fvalue resulting in issues.. hence commented
                    //fName = fName.Remove(0, 1);
                    //fName = fName.Remove(fName.Length - 1, 1);
                    //fValue = fValue.Remove(0, 1);
                    //fValue = fValue.Remove(fValue.Length - 1, 1);
                    fValue = fValue.Replace("^^dq", "\"");
                    fValue = fValue.Replace(";bkslh", @"\");
                    string[] pickFldValues = fValue.Split('~');
                    for (int j = 0; j < pickFldValues.Length; j++)
                    {
                        if (j == 0)
                            pickDataArray.Append(pickFldValues[j].ToString());
                        else
                            pickDataArray.Append("¿" + pickFldValues[j].ToString());
                    }
                }
            }
        }
        return pickDataArray.ToString();
    }
    #endregion

    private void GetGlobalVars()
    {
        project = HttpContext.Current.Session["project"].ToString();
        user = HttpContext.Current.Session["user"].ToString();
        AxRole = HttpContext.Current.Session["AxRole"].ToString();
        sessionid = HttpContext.Current.Session["nsessionid"].ToString();
    }

    public string GetIncludeDcsForLoad()
    {
        string includeDcs = string.Empty;
        string depDcs = string.Empty;
        DataRow dr = DsGetRow("axp_mustloaddc", "001");
        if (dr != null)
            depDcs = dr["axp_mustloaddc"].ToString();
        return depDcs;
    }

    public void AddToFasDDl(string fName, string fJson)
    {
        if (fastDDL.ContainsKey(fName))
            fastDDL.Remove(fName);

        fastDDL.Add(fName, fJson);
    }

    #region New Indexing Methods

    /// <summary>
    /// Function loops through the dcs in the tstruct and for every dc adds the default fields into the field arrays.
    /// </summary>
    /// <param name="strObj"></param>
    private void CreateDefaultFArray(TStructDef strObj)
    {
        foreach (TStructDef.DcStruct dc in strObj.dcs)
            UpdateRowCount(dc.frameno.ToString(), "DC" + dc.frameno.ToString() + "~1");
    }

    /// <summary>
    /// Function loops through the dcs in the tstruct and for every dc adds the default fields into the Data Table.
    /// </summary>
    /// <param name="strObj"></param>
    private void CreateDataSets(TStructDef strObj)
    {
        DataSet ds = new DataSet("datacache");
        // TODO: needs proper comment - Create a DataSet and put both tables in it.
        foreach (TStructDef.DcStruct dc in strObj.dcs)
        {
            ds.Tables.Add(DSConstruct(dc.frameno, strObj));
            ds.Tables.Add(DSConstructOld(dc.frameno, strObj));
            ds.Tables.Add(DSSaveFalse(dc.frameno, strObj));
        }
        ds.Tables.Add(DSCreateDropDownTable());
        dsDataSet = ds;
    }

    private DataTable DSCreateDropDownTable()
    {
        DataTable dtDropDownValue = new DataTable();
        dtDropDownValue.TableName = "dsdropdown";

        DataColumn[] keys1 = new DataColumn[1];
        DataColumn column1 = dtDropDownValue.Columns.Add("dropdownkey");
        keys1[0] = column1;
        dtDropDownValue.PrimaryKey = keys1;

        dtDropDownValue.Columns.Add("fldname");
        dtDropDownValue.Columns.Add("axp__rowno");
        dtDropDownValue.Columns.Add("rowvals");
        dtDropDownValue.Columns.Add("dpmvalues");
        dtDropDownValue.Columns.Add("dp");
        dtDropDownValue.Columns.Add("mr");
        dtDropDownValue.Columns.Add("idcol");

        return dtDropDownValue;
    }

    private DataTable DSSaveFalse(int dcNo, TStructDef strObj)
    {
        TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[dcNo - 1];
        DataTable dtObj = new DataTable("dc_savefalse" + dcNo.ToString());
        DataColumn[] keys = new DataColumn[1];
        DataColumn column;
        string dcFldRange = strObj.GetDcFieldRange(dcNo.ToString());
        string[] fldRange = dcFldRange.Split(',');
        int startIndex = Convert.ToInt32(fldRange[0]);
        int endIndex = Convert.ToInt32(fldRange[1]);

        for (int j = startIndex; j <= endIndex; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)strObj.flds[j];

            if (fld.savevalue == false)
            {
                dtObj.Columns.Add(fld.name);
            }
        }

        column = dtObj.Columns.Add("axp__rowno");
        column.DataType = typeof(Int32);
        keys[0] = column;
        dtObj.PrimaryKey = keys;

        return dtObj;
    }

    private DataTable DSConstructOld(int dcNo, TStructDef strObj)
    {
        TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[dcNo - 1];
        DataTable dtOldObj = new DataTable("dc_old" + dcNo.ToString());
        DataColumn[] keys = new DataColumn[1];
        DataColumn column;

        string dcFldRange = strObj.GetDcFieldRange(dcNo.ToString());
        string[] fldRange = dcFldRange.Split(',');
        int startIndex = Convert.ToInt32(fldRange[0]);
        int endIndex = Convert.ToInt32(fldRange[1]);

        for (int j = startIndex; j <= endIndex; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)strObj.flds[j];

            dtOldObj.Columns.Add("old__" + fld.name);
            if (fld.savenormal)
                dtOldObj.Columns.Add("oldid__" + fld.name);
        }

        column = dtOldObj.Columns.Add("axp__rowno");
        column.DataType = typeof(Int32);
        keys[0] = column;
        dtOldObj.PrimaryKey = keys;

        return dtOldObj;
    }

    /// <summary>
    /// Function to add every field in given dc into the field array and index array.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <param name="strObj"></param>
    /// <param name="fldIdx"></param>
    private DataTable DSConstruct(int dcNo, TStructDef strObj)
    {
        TStructDef.DcStruct dc = (TStructDef.DcStruct)strObj.dcs[dcNo - 1];
        DataTable dtObj = new DataTable("dc" + dcNo.ToString());

        DataColumn[] keys = new DataColumn[1];
        DataColumn column;

        string dcFldRange = strObj.GetDcFieldRange(dcNo.ToString());
        string[] fldRange = dcFldRange.Split(',');
        int startIndex = Convert.ToInt32(fldRange[0]);
        int endIndex = Convert.ToInt32(fldRange[1]);

        for (int j = startIndex; j <= endIndex; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)strObj.flds[j];
            dtObj.Columns.Add(fld.name);
            //dtObj.Columns.Add("old__" + fld.name);

            if (fld.savenormal)
            {
                dtObj.Columns.Add("id__" + fld.name);
                //dtObj.Columns.Add("oldid__" + fld.name);
            }
        }
        //dtObj.Columns.Add("axp_recid" + dcNo);
        column = dtObj.Columns.Add("axp__rowno");
        column.DataType = typeof(Int32);
        keys[0] = column;
        dtObj.PrimaryKey = keys;
        dtObj.Columns.Add("axp__delrow");
        if (dc.isgrid)
            dtObj.Columns.Add(Constants.AXPISROWVALID + dcNo);

        return dtObj;
    }


    /// <summary>
    /// Function which loop though each dc till the given dc and appends the field count.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <param name="strObj"></param>
    /// <returns></returns>
    private int GetDcIndex(int dcNo)
    {
        int fldCnt = 0;
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            if (dc.frameno >= dcNo)
                break;

            fldCnt += dc.fieldCount;
        }
        return fldCnt;
    }

    /// <summary>
    /// Function to calculate the index of the field in the fieldIndexArray 
    /// and return the value from that item of the fieldIndexArray.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <param name="fieldOrder"></param>
    /// <param name="rowNo"></param>
    /// <returns></returns>
    public int GetFldIndex(int dcNo, string fldName, int rowNo)
    {
        int idx = 0;
        int index = 0;
        if (rowNo == 0) rowNo = 1;
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            if (dc.frameno >= dcNo)
                break;

            idx += GetDcRowCount(dc.frameno.ToString()) * dc.fieldCount;
        }

        TStructDef.DcStruct currentDC = (TStructDef.DcStruct)tstStrObj.dcs[dcNo - 1];
        int fieldOrder = GetFieldOrder(fldName, dcNo, currentDC);
        //Formula = idx + FieldCountInDC * (RowNo-1) + (FieldOrder - StartOrderInDC)
        idx += currentDC.fieldCount * (rowNo - 1) + (fieldOrder - GetDcIndex(dcNo));
        if (idx >= fieldIndexArray.Count) index = -1;
        else
            index = (Int32)fieldIndexArray[idx];
        return index;
    }

    /// <summary>
    /// Function to get the field order for the given field in the given dc.
    /// </summary>
    /// <param name="fldName"></param>
    /// <param name="dcNo"></param>
    /// <param name="dc"></param>
    /// <returns></returns>
    private int GetFieldOrder(string fldName, int dcNo, TStructDef.DcStruct dc)
    {
        int fldOrd = 0;
        string dcFldRange = tstStrObj.GetDcFieldRange(dcNo.ToString());
        string[] fldRange = dcFldRange.Split(',');
        int startIndex = Convert.ToInt32(fldRange[0]);
        int endIndex = Convert.ToInt32(fldRange[1]);

        for (int j = startIndex; j <= endIndex; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
            if (fld.name == fldName)
            {
                fldOrd = j;
                break;
            }
        }
        return fldOrd;
    }

    /// <summary>
    /// Function to add or update the field arrays.
    /// </summary>
    /// <param name="name"></param>
    /// <param name="fldId"></param>
    /// <param name="rowNo"></param>
    /// <param name="dcNo"></param>
    /// <param name="value"></param>
    /// <param name="oldValue"></param>
    /// <param name="idCol"></param>
    /// <param name="mr"></param>
    /// <param name="rowVals"></param>
    /// <param name="id"></param>
    /// <param name="oldId"></param>
    /// <param name="status"></param>
    /// <param name="index"></param>
    private void SubmitFieldInArrays(string value, string oldValue, string idCol, string mr, string rowVals, string id, string oldId, string dpmValues, string dp, int index)
    {
        fieldValue[index] = value;
        fieldOldValue[index] = value;
        fldIdCol[index] = idCol;
        fldMasterRow[index] = mr;
        fieldRowValues[index] = rowVals;
        fieldOldIdValue[index] = oldId;
        fieldIdValue[index] = id;
        fieldDPMVals[index] = dpmValues;
        fieldDPVals[index] = dp;
        //StringToFile("Replace Values - FieldName-" + fieldName[index].ToString() + " Rowno- " + fieldRowNo[index].ToString() + " Value- " + value + " Index- " + index);
    }

    private void DSSubmit(string fldName, int rowNo, string value, string idValue)
    {
        int dcNo = tstStrObj.GetFieldDc(fldName);
        if (dcNo == 0 && fldName.StartsWith(Constants.AXPISROWVALID))
        {
            dcNo = Convert.ToInt32(fldName.Substring(13));
        }
        if (rowNo == 0) rowNo = 1;
        DataTable dt = dsDataSet.Tables["dc" + dcNo];
        DataRow foundRow = dsDataSet.Tables["dc" + dcNo].Rows.Find(rowNo);
        if (foundRow == null)
        {
            foundRow = dt.NewRow();

            foundRow["axp__rowno"] = Convert.ToInt32(rowNo);
            foundRow["axp__delrow"] = 0;
            dt.Rows.Add(foundRow);
        }
        if (!fldName.StartsWith("axp_recid"))
            foundRow[fldName] = value;
        string axp_recId = foundRow["axp_recid" + dcNo].ToString();
        foundRow["axp_recid" + dcNo] = axp_recId == "" ? "0" : axp_recId;
        if (dt.Columns.Contains("id__" + fldName))
            foundRow["id__" + fldName] = idValue;

        dt.AcceptChanges();
    }

    private void DSSubmitDropDownValues(string fldName, int rowNo, string rowVals, string dpmValues, string dp, string mr, string idCol)
    {
        DataTable thisDataTable = dsDataSet.Tables["dsdropdown"];
        if (rowNo == 0) rowNo = 1;
        DataRow thisDataRow = thisDataTable.Rows.Find(fldName + "-" + rowNo);

        if (thisDataRow == null)
        {
            thisDataRow = thisDataTable.NewRow();
            thisDataRow["dropdownkey"] = fldName + "-" + rowNo;
            thisDataRow["fldname"] = fldName;
            thisDataRow["axp__rowno"] = rowNo;
            thisDataTable.Rows.Add(thisDataRow);
        }
        thisDataRow["rowvals"] = rowVals;
        thisDataRow["dpmvalues"] = dpmValues;
        thisDataRow["dp"] = dp;
        thisDataRow["mr"] = mr;
        thisDataRow["idcol"] = idCol;

        dsDataSet.AcceptChanges();
    }

    private void DSUpdateRowValues(string fldName, int rowNo, string rowVals, string dp, string masterRow, string idCol)
    {
        DataTable thisDataTable = dsDataSet.Tables["dsdropdown"];
        if (rowNo == 0) rowNo = 1;
        DataRow thisDataRow = thisDataTable.Rows.Find(fldName + "-" + rowNo);

        if (thisDataRow == null)
        {
            thisDataRow = thisDataTable.NewRow();
            thisDataRow["dropdownkey"] = fldName + "-" + rowNo;
            thisDataRow["fldname"] = fldName;
            thisDataRow["axp__rowno"] = rowNo;
            thisDataRow["idcol"] = idCol;
            thisDataTable.Rows.Add(thisDataRow);
        }
        thisDataRow["rowvals"] = rowVals;
        thisDataRow["dp"] = dp;
        thisDataRow["mr"] = masterRow;

        dsDataSet.AcceptChanges();
    }
    public DataRow DSGetDropdownRow(string fldName, string rowNo)
    {
        DataTable thisDataTable = dsDataSet.Tables["dsdropdown"];
        int rNo = Convert.ToInt32(rowNo);
        if (rNo == 0) rNo = 1;
        return thisDataTable.Rows.Find(fldName + "-" + rNo);
    }

    private void DSSubmitWithOld(string fldName, int rowNo, string value, string idValue, string oldIdValue)
    {
        int dcNo = tstStrObj.GetFieldDc(fldName);
        if (dcNo == 0) return;
        if (rowNo == 0) rowNo = 1;
        DataTable dt = dsDataSet.Tables["dc" + dcNo];
        DataRow foundRow = dsDataSet.Tables["dc" + dcNo].Rows.Find(rowNo);

        if (foundRow == null)
        {
            foundRow = dt.NewRow();

            foundRow["axp__rowno"] = rowNo;
            foundRow["axp__delrow"] = 0;
            dt.Rows.Add(foundRow);
        }
        foundRow[fldName] = value;

        if (dt.Columns.Contains("id__" + fldName))
            foundRow["id__" + fldName] = idValue;

        dt.AcceptChanges();

        DSSubmitOldValues(fldName, rowNo, value, idValue, oldIdValue);
    }

    private void DSSubmitOldValues(string fldName, int rowNo, string value, string idValue, string oldIdValue)
    {
        int dcNo = tstStrObj.GetFieldDc(fldName);
        if (rowNo == 0) rowNo = 1;

        DataTable dtOld = dsDataSet.Tables["dc_old" + dcNo];
        DataRow drOld = dtOld.Rows.Find(rowNo);
        if (drOld == null)
        {
            drOld = dtOld.NewRow();

            drOld["axp__rowno"] = rowNo;
            dtOld.Rows.Add(drOld);
        }
        drOld["old__" + fldName] = value;
        if (dtOld.Columns.Contains("oldid__" + fldName))
            drOld["oldid__" + fldName] = oldIdValue;

        dtOld.AcceptChanges();
    }

    private void DSInsertRow(int dcNo, int rowNo)
    {
        DataTable DCTable = dsDataSet.Tables["dc" + dcNo];
        for (int i = DCTable.Rows.Count - 1; i >= 0; i--)
        {
            DataRow thisrow = DCTable.Rows[i];
            int thisRowNo = Convert.ToInt32(thisrow["axp__rowno"]);
            if (thisRowNo < rowNo)
                break;
            thisrow["axp__rowno"] = thisRowNo + 1;
        }
        DataRow newRow = DCTable.NewRow();
        newRow["axp__rowno"] = rowNo;
        DCTable.Rows.Add(newRow);
        DCTable.AcceptChanges();
        dsDataSet.AcceptChanges();
    }

    /// <summary>
    /// Function to delete all the rows in the given dc from the field arrays.
    /// </summary>
    /// <param name="dcNo"></param>
    private void DeleteAllRowsInDc(string dcNo)
    {
        DSDeleteAllRows(dcNo);
    }

    private void DSDeleteAllRows(string dcNo)
    {
        int idx = AxDelDcNo.IndexOf("dc" + dcNo);
        if (idx == -1)
            AxDelDcNo.Add("dc" + dcNo);

        StringBuilder strDelIds = new StringBuilder();
        if (idx != -1)
            strDelIds.Append(AxDelRecIds[idx].ToString());
        DataTable DCTable = dsDataSet.Tables["dc" + dcNo];

        for (int j = DCTable.Rows.Count; j > 0; j--)
        {
            DataRow foundRow = DCTable.Rows.Find(j);
            if (foundRow != null)
            {
                if (strDelIds.ToString() == string.Empty)
                    strDelIds.Append(foundRow["axp_recid" + dcNo].ToString());
                else
                    strDelIds.Append("," + foundRow["axp_recid" + dcNo].ToString());
            }
            DeleteRowInFldArrays(dcNo, j.ToString());
        }

        if (idx == -1)
            AxDelRecIds.Add(strDelIds.ToString());
        else
            AxDelRecIds[idx] = strDelIds.ToString();

    }

    //Set the deleted rows from GetDependents, to the global array
    private void SetPopDeletedRows(string dcNo, string delRecIds)
    {
        int idx = AxDelDcNo.IndexOf("dc" + dcNo);
        if (idx == -1)
        {
            AxDelDcNo.Add("dc" + dcNo);
            AxDelRecIds.Add(delRecIds);
        }
        else
        {
            AxDelRecIds[idx] = delRecIds;
        }
    }

    public void DSDeleteRow(string dcNo, string rowNum)
    {
        DataTable DCTable = dsDataSet.Tables["dc" + dcNo];
        DataTable DCOldTable = dsDataSet.Tables["dc_old" + dcNo];

        int rNo = Convert.ToInt32(rowNum);
        if (rNo == 0) rNo = 1;
        DataRow foundRow = DCTable.Rows.Find(rNo);
        DataRow oldRow = DCOldTable.Rows.Find(rNo);

        DataTable DeletedRowsTable = dsDataSet.Tables["deldc" + dcNo];
        if (DeletedRowsTable == null)
        {
            DeletedRowsTable = DCTable.Clone();
            DeletedRowsTable.TableName = "deldc" + dcNo;
            dsDataSet.Tables.Add(DeletedRowsTable);
        }

        if (foundRow != null)
        {
            DeletedRowsTable.ImportRow(foundRow);
            DataRow DelTableRow = DeletedRowsTable.Rows.Find(rNo);
            DelTableRow["axp__delrow"] = DelTableRow["axp__rowno"];
            DelTableRow["axp__rowno"] = deletedCount--;

            //copying delete contents to xml for sending to web service.
            StringBuilder strDelRowFlds = new StringBuilder();
            string axpRecidVal = "0";
            string axpNode = string.Empty;
            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);
            for (int j = startIdx; j <= endIdx; j++)
            {
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
                if (recordid != "0")
                {
                    if (oldRow != null)
                    {
                        if (fld.name == "axp_recid" + dcNo)
                        {
                            axpNode = "<" + fld.name + ">" + CheckSpecialChars(oldRow["old__" + fld.name].ToString()) + "</" + fld.name + ">";
                            axpRecidVal = foundRow[fld.name].ToString();
                        }
                        else
                        {
                            strDelRowFlds.Append("<" + fld.name + ">" + CheckSpecialChars(oldRow["old__" + fld.name].ToString()) + "</" + fld.name + ">");
                        }
                    }
                }
            }
            DelRowFldsXml.Add(axpRecidVal + "♦" + axpNode + strDelRowFlds.ToString());

            foundRow.Delete();
            DCTable.AcceptChanges();
            DCTable.PrimaryKey = null;
            DCTable = DeleteRowFalse(DCTable, DeletedRowsTable, dcNo);
            int givenRow = Convert.ToInt32(rNo);
            foreach (DataRow thisrow in DCTable.Rows)
            {
                int thisRowNo = Convert.ToInt32(thisrow["axp__rowno"]);
                if (thisRowNo > givenRow)
                    thisrow["axp__rowno"] = thisRowNo - 1;
            }


            DCTable.PrimaryKey = new DataColumn[] { DCTable.Columns["axp__rowno"] };

            if (oldRow != null)
            {
                oldRow.Delete();
                DCOldTable.AcceptChanges();
            }

            DCOldTable.PrimaryKey = null;
            foreach (DataRow thisrow in DCOldTable.Rows)
            {
                int thisRowNo = Convert.ToInt32(thisrow["axp__rowno"]);
                if (thisRowNo > givenRow)
                    thisrow["axp__rowno"] = thisRowNo - 1;
            }
            DCOldTable.PrimaryKey = new DataColumn[] { DCOldTable.Columns["axp__rowno"] };
            DSDeleteDropDown(dcNo, rowNum);
        }
    }

    private void deleteRowOnSave()
    {
        try
        {
            for (int i = 0; i < deletedRowCount.Count; i++)
            {
                string dcNumber = deletedRowCount[i].ToString().Split('♦')[1];
                string delRowNumber = (int.Parse(deletedRowCount[i].ToString().Split('♦')[0]) + 1).ToString();
                DSDeleteRow(dcNumber, delRowNumber);
            }
        }
        catch (Exception ex)
        { }
    }

    private void UpdateGridDelRowVal(int dcNumner)
    {
        try
        {
            if (isDeletedRow)
            {
                int totRowCount = dsData.Tables["DC" + dcNumner].Rows.Count;
                dsData.Tables["DC" + dcNumner].Rows[totRowCount - 1]["axp__isGrdVld" + dcNumner] = "";
                dsData.Tables["DC" + dcNumner].AcceptChanges();

                if (deletedRowCount.Count == 0)
                {
                    deletedRowCount.Add(totRowCount + "♦" + dcNumner);
                }
                else
                {
                    string checkValue = string.Join(",", deletedRowCount.Select(x => x.ToString()).ToList());
                    if (checkValue.IndexOf("♦" + dcNumner) != -1)
                    {
                        var prevValue = deletedRowCount.AsEnumerable().Where(x => x.Contains("♦" + dcNumner)).ToList();
                        deletedRowCount.Remove(prevValue[0]);
                        deletedRowCount.Add(totRowCount + "♦" + dcNumner);
                    }
                    else
                    {
                        deletedRowCount.Add(totRowCount + "♦" + dcNumner);
                    }
                }
            }
        }
        catch (Exception ex)
        { }
    }

    private DataTable DeleteRowFalse(DataTable DCTable, DataTable DeletedRowsTable, string dcNo)
    {
        try
        {
            isDeletedRow = true;
            int delRowCount = DeletedRowsTable.Rows.Count;
            int OrgRows = DCTable.Rows.Count;
            if (delRowCount < OrgRows)
            {
                for (int i = 1; i <= delRowCount; i++)
                {
                    bool flagRemff = true;
                    foreach (DataColumn dc in DCTable.Columns)
                    {
                        if (dc.ColumnName == "axp__rowno")
                        {
                            break;
                        }
                        else if (DCTable.Rows[OrgRows - i][dc].ToString() != "" && DCTable.Rows[OrgRows - i][dc].ToString() != "0")
                        {
                            flagRemff = false;
                        }
                    }
                    if (flagRemff)
                    {
                        DCTable.Rows[OrgRows - i]["axp__isGrdVld" + dcNo] = "false";
                    }
                }
            }
            else
            {
                #region delete           
                int userValue = 0;
                int ofrows = DCTable.Rows.Count;
                for (int trc = 0; trc < DCTable.Rows.Count; trc++)
                {
                    int dbValue = int.Parse(DCTable.Rows[trc]["axp__rowno"].ToString());
                    if (dbValue >= userValue)
                    {
                        userValue = dbValue;
                        DeleteRowTopNo = trc;
                    }
                }
                bool flagRem = true;
                foreach (DataColumn dc in DCTable.Columns)
                {
                    if (dc.ColumnName.ToLower() == "axp__rowno")
                    {
                        break;
                    }
                    else if (DCTable.Rows[DeleteRowTopNo][dc].ToString() != "" && DCTable.Rows[DeleteRowTopNo][dc].ToString() != "0")
                    {
                        flagRem = false;
                    }
                }
                if (flagRem)
                {
                    int totRowCount = DCTable.Rows.Count;
                    if (totRowCount != 1 && totRowCount == ofrows)
                    {
                        DCTable.Rows[totRowCount - 1]["axp__isGrdVld" + dcNo] = "false";
                        DCTable.AcceptChanges();
                    }
                }
                #endregion
            }
            return DCTable;
        }
        catch (Exception ex)
        {
            return DCTable;
        }
    }

    //Function to delete all the sub grid rows after the get dep call.
    private void DeletePopRowsAfterDep()
    {
        //AxSubGridRows will have dcno~1,2,3 in every item
        for (int i = 0; i < AxSubGridRows.Count; i++)
        {
            string[] dcData = AxSubGridRows[i].ToString().Split('~');
            string dcNo = dcData[0].ToString();
            int delIdx = AxDelDcNo.IndexOf("dc" + dcNo);

            //This code will add the dr attribute recids sent from the getdep, and store the deleted row information for save.
            ArrayList delRecIds = new ArrayList();
            if (delIdx != -1)
            {
                string[] delIds = AxDelRecIds[delIdx].ToString().Split(',');
                for (int ind = 0; ind < delIds.Length; ind++)
                {
                    if (delIds[ind].ToString() != string.Empty)
                        delRecIds.Add(delIds[ind].ToString());
                }
            }

            string[] popRows = dcData[1].ToString().Split(',');
            //This loop is reversed as the array will be sorted in asc order. and while deleting it should always be in desc order.
            for (int j = popRows.Length - 1; j >= 0; j--)
            {
                if (popRows[j] != "")
                {
                    string rowNum = popRows[j].ToString();
                    DataTable DCTable = dsDataSet.Tables["dc" + dcNo];
                    DataTable DCOldTable = dsDataSet.Tables["dc_old" + dcNo];

                    int rNo = Convert.ToInt32(rowNum);
                    if (rNo == 0) rNo = 1;
                    DataRow foundRow = DCTable.Rows.Find(rNo);
                    DataRow oldRow = DCOldTable.Rows.Find(rNo);

                    if (foundRow != null)
                    {
                        StringBuilder strDelRowFlds = new StringBuilder();
                        string axpRecidVal = "0";
                        string axpNode = string.Empty;
                        string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
                        int startIdx = Convert.ToInt32(dcRange[0]);
                        int endIdx = Convert.ToInt32(dcRange[1]);
                        for (int k = startIdx; k <= endIdx; k++)
                        {
                            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[k];
                            if (recordid != "0")
                            {
                                if (oldRow != null)
                                {
                                    if (fld.name == "axp_recid" + dcNo)
                                    {
                                        axpNode = "<" + fld.name + ">" + CheckSpecialChars(oldRow["old__" + fld.name].ToString()) + "</" + fld.name + ">";
                                        axpRecidVal = foundRow[fld.name].ToString();
                                    }
                                    else
                                    {
                                        strDelRowFlds.Append("<" + fld.name + ">" + CheckSpecialChars(oldRow["old__" + fld.name].ToString()) + "</" + fld.name + ">");
                                    }
                                }
                            }
                        }
                        if (delRecIds.IndexOf(axpRecidVal) != -1)
                            DelRowFldsXml.Add(axpRecidVal + "♦" + axpNode + strDelRowFlds.ToString());


                        foundRow.Delete();
                        DCTable.AcceptChanges();
                        DCTable.PrimaryKey = null;
                        int givenRow = Convert.ToInt32(rNo);
                        foreach (DataRow thisrow in DCTable.Rows)
                        {
                            int thisRowNo = Convert.ToInt32(thisrow["axp__rowno"]);
                            if (thisRowNo > givenRow)
                                thisrow["axp__rowno"] = thisRowNo - 1;
                        }



                        DCTable.PrimaryKey = new DataColumn[] { DCTable.Columns["axp__rowno"] };

                        if (oldRow != null)
                        {
                            oldRow.Delete();
                            DCOldTable.AcceptChanges();
                        }

                        DCOldTable.PrimaryKey = null;
                        foreach (DataRow thisrow in DCOldTable.Rows)
                        {
                            int thisRowNo = Convert.ToInt32(thisrow["axp__rowno"]);
                            if (thisRowNo > givenRow)
                                thisrow["axp__rowno"] = thisRowNo - 1;
                        }
                        DCOldTable.PrimaryKey = new DataColumn[] { DCOldTable.Columns["axp__rowno"] };
                        //DSDeleteDropDown(dcNo, rowNum);
                    }
                }

            }
        }
    }

    private void DSDeleteDropDown(string dcNo, string rowNum)
    {
        DataTable dsDropDown = dsDataSet.Tables["dsdropdown"];
        if (dsDropDown == null) return;
        int rNo = Convert.ToInt32(rowNum);
        if (rNo == 0) rNo = 1;

        StringBuilder strDelRowFlds = new StringBuilder();
        string axpNode = string.Empty;
        string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
        int startIdx = Convert.ToInt32(dcRange[0]);
        int endIdx = Convert.ToInt32(dcRange[1]);
        for (int j = startIdx; j <= endIdx; j++)
        {
            TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
            DataRow dr = dsDropDown.Rows.Find(fld.name + "-" + Convert.ToString(rNo));
            if (dr != null)
            {
                bool Proceed = false;
                if (dr["mr"].ToString() == "0") Proceed = true;

                Proceed = Custom_CanDelRowInEsti(fld, dr["mr"].ToString(), dcNo, rowNum);
                if (Proceed)
                {
                    dr.Delete();
                    dsDropDown.AcceptChanges();
                    foreach (DataRow drRow in dsDropDown.Rows)
                    {
                        int rowNo = Convert.ToInt32(drRow["axp__rowno"]);
                        if (rowNo > rNo && fld.name == drRow["fldname"].ToString())
                        {
                            drRow["axp__rowno"] = rowNo - 1;
                            drRow["dropdownkey"] = fld.name + "-" + Convert.ToString(rowNo - 1);
                        }
                    }
                }
            }
        }
        dsDropDown.AcceptChanges();
    }

    private bool Custom_CanDelRowInEsti(TStructDef.FieldStruct fld, string mr, string dcNo, string rowNum)
    {
        bool Proceed = false;
        if (fld.name == "role") mr = "1";
        if (fld.name == "activity")
        {
            Proceed = true;
        }
        if (mr == "0") Proceed = true;
        return Proceed;


    }

    /// <summary>
    /// Function to delete all the fields in the given row and dc from the field arrays.
    /// </summary>
    /// <param name="frameNo"></param>
    /// <param name="rowNum"></param>
    private void DeleteRowInFldArrays(string frameNo, string rowNum)
    {
        DSDeleteRow(frameNo, rowNum);
    }

    /// <summary>
    /// Function to get the index of the given row and dc from the fieldindexarray.
    /// </summary>
    /// <param name="dcNo"></param>
    /// <param name="rowNo"></param>
    /// <returns></returns>
    private int GetRowIndex(int dcNo, int rowNo)
    {
        int idx = 0;
        if (rowNo == 0) rowNo = 1;
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            if (dc.frameno >= dcNo)
                break;

            idx += GetDcRowCount(dc.frameno.ToString()) * dc.fieldCount;
        }

        TStructDef.DcStruct currentDC = (TStructDef.DcStruct)tstStrObj.dcs[dcNo - 1];
        //Formula = idx + FieldCountInDC * (RowNo-1) + (FieldOrder - StartOrderInDC)
        idx += currentDC.fieldCount * (rowNo - 1);
        return idx;
    }


    private void RefInMemOnSave()
    {
        try
        {
            if (tstStrObj.axp_inmemTids != String.Empty && (HttpContext.Current.Session["RapidTsTruct"] != null && HttpContext.Current.Session["RapidTsTruct"].ToString() == "true") && (HttpContext.Current.Session["AxIsPerfCode"] != null && HttpContext.Current.Session["AxIsPerfCode"].ToString().ToLower() == "true"))
            {
                string[] inMemTids = tstStrObj.axp_inmemTids.Split(',');

                FDR fdrObj;
                if (HttpContext.Current.Session["FDR"] != null)
                    fdrObj = (FDR)HttpContext.Current.Session["FDR"];
                else
                    fdrObj = new FDR();

                FDW fdwObj = FDW.Instance;
                foreach (string Tid in inMemTids)
                {
                    ArrayList arrKeys = fdrObj.GetPrefixedKeys(project + "-" + Tid + "-");
                    foreach (string key in arrKeys)
                    {
                        fdwObj.ClearRedisServerDataByKey(key, String.Empty, true);
                    }
                }

            }
        }
        catch (Exception Ex)
        {

        }
    }

    #endregion

    #region Json creation Functions

    /// <summary>
    /// Function to create json from the data arrays in the stored draft.
    /// </summary>
    /// <returns></returns>
    public string CreateJsonForDraft()
    {
        StringBuilder draftJson = new StringBuilder();
        StringBuilder dcJson = new StringBuilder();
        draftJson.Append("{\"data\":[");
        string tmpStr = string.Empty;

        //loop for constructing the field value xml based on the frame no, row no and field order        
        foreach (TStructDef.DcStruct dc in tstStrObj.dcs)
        {
            string dcNo = Convert.ToString(dc.frameno);

            DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
            if (dc.isgrid)
            {
                errlog = logobj.CreateLog("CreateJsonForDraft", sessionid, "CreateJson-tstData", "new");
                try
                {
                    DataRow[] rows;
                    rows = thisDataTable.Select("axp__isGrdVld" + dcNo + " = 'false'"); // axp__isGrdVld is Column Name
                    foreach (DataRow r in rows)
                        thisDataTable.Rows.Remove(r);
                }
                catch (Exception ex)
                {
                    errlog = logobj.CreateLog(ex.Message + ex.StackTrace, sessionid, "CreateJson-tstData", "");
                }
            }
            string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');

            int startIdx = Convert.ToInt32(dcRange[0]);
            int endIdx = Convert.ToInt32(dcRange[1]);

            int rowCnt = 0;
            string cr = string.Empty;
            if (dc.isgrid)
            {
                rowCnt = thisDataTable.Rows.Count;
                cr = GetCrAttrJson(rowCnt);
            }
            tmpStr = "{\"n\":\"DC" + dcNo + "\",\"v\":\"" + rowCnt + "\", " + cr + " \"t\":\"dc\", \"hasdatarows\":\"" + (rowCnt > 0 && !string.IsNullOrEmpty(cr) ? "yes" : "no") + "\"}";
            //construct dc json tag
            //{"n":"DC1","v":"1","t":"dc"}
            if (dcJson.ToString() == string.Empty)
                dcJson.Append(tmpStr);
            else
                dcJson.Append("," + tmpStr);

            foreach (DataRow dr in thisDataTable.Rows)
            {
                int rowNo = Convert.ToInt32(dr["axp__rowno"]);
                for (int j = startIdx; j <= endIdx; j++)
                {
                    TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
                    dcJson.Append("," + GetFieldJson(rowNo.ToString(), dr, fld, thisDataTable));
                }
            }
            //close here
        }
        draftJson.Append(dcJson + "]}");

        return draftJson.ToString();
    }

    public string GetCurrTabStatus(string dcNo)
    {
        //DC1-1,DC2-2
        string isTabOpened = "no";
        dcNo = "DC" + dcNo;
        if (!string.IsNullOrEmpty(TabDcStatus))
        {
            string[] dcAndStatusArray = TabDcStatus.Split(',');
            foreach (string dcAndStatus in dcAndStatusArray)
            {
                string[] status = dcAndStatus.Split('-');
                if (status[0].ToLower() == dcNo.ToLower())
                {
                    if (status[1] == "1")
                        isTabOpened = "yes";
                    break;
                }
            }
        }
        return isTabOpened;
    }

    public string GetTabDCJson(string dcNo)
    {
        StringBuilder draftJson = new StringBuilder();
        StringBuilder dcJson = new StringBuilder();
        draftJson.Append("{\"data\":[");
        string tmpStr = string.Empty;
        bool isGrid = ((TStructDef.DcStruct)tstStrObj.dcs[int.Parse(dcNo) - 1]).isgrid;
        DataTable thisDataTable = dsDataSet.Tables["dc" + dcNo];
        if (isGrid)
        {
            errlog = logobj.CreateLog("CreateJsonForDraft-GetTabDCJson", sessionid, "GetTabDCJson-tstData", "new");
            try
            {
                DataRow[] rows;
                rows = thisDataTable.Select("axp__isGrdVld" + dcNo + " = 'false'"); // axp__isGrdVld is Column Name
                foreach (DataRow r in rows)
                    thisDataTable.Rows.Remove(r);
            }
            catch (Exception ex)
            {
                errlog = logobj.CreateLog(ex.Message + ex.StackTrace, sessionid, "GetTabDCJson-tstData", "");
            }
        }

        string[] dcRange = tstStrObj.GetDcFieldRange(dcNo).Split(',');
        int startIdx = Convert.ToInt32(dcRange[0]);
        int endIdx = Convert.ToInt32(dcRange[1]);
        int rowCnt = 0;
        string cr = string.Empty;
        if (isGrid)
        {
            rowCnt = thisDataTable.Rows.Count;
            cr = GetCrAttrJson(rowCnt);
        }

        tmpStr = "{\"n\":\"DC" + dcNo + "\",\"v\":\"" + rowCnt + "\", " + cr + " \"t\":\"dc\", \"hasdatarows\":\"" + (rowCnt > 0 && !string.IsNullOrEmpty(cr) ? "yes" : "no") + "\"}";

        if (dcJson.ToString() == string.Empty)
            dcJson.Append(tmpStr);
        else
            dcJson.Append("," + tmpStr);


        foreach (DataRow dr in thisDataTable.Rows)
        {
            int rowNo = Convert.ToInt32(dr["axp__rowno"]);
            for (int j = startIdx; j <= endIdx; j++)
            {
                TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[j];
                dcJson.Append("," + GetFieldJson(rowNo.ToString(), dr, fld, thisDataTable));
            }
        }

        draftJson.Append(dcJson + "]}");
        return draftJson.ToString();
    }


    /// <summary>
    /// Function to get the cr attribute for the dc based on the rowcount.
    /// </summary>
    /// <param name="rowCnt"></param>
    /// <returns></returns>
    private string GetCrAttrJson(int rowCnt)
    {
        StringBuilder strCr = new StringBuilder();
        for (int i = 1; i <= rowCnt; i++)
        {
            if (i == 1)
            {
                strCr.Append("\"cr\":");
                strCr.Append("\"i" + i);
            }
            else
                strCr.Append(",i" + i);
        }
        if (strCr.ToString() != string.Empty)
            strCr.Append("\",");
        return strCr.ToString();
    }

    /// <summary>
    /// Function to get the field json based on its type.
    /// </summary>
    /// <param name="fieldName"></param>
    /// <param name="rowNo"></param>
    /// <param name="fldIndex"></param>
    /// <param name="fld"></param>
    /// <returns></returns>
    private string GetFieldJson(string rowNo, DataRow dr, TStructDef.FieldStruct fld, DataTable dt)
    {
        string fieldName = fld.name;
        string type = string.Empty;
        string value = string.Empty;
        string idVal = string.Empty;
        string oldIdVal = string.Empty;
        string mr = string.Empty;
        string idCol = string.Empty;
        string fldJson = string.Empty;
        string strId = string.Empty;
        string strComboValues = string.Empty;
        string dpm = string.Empty;

        DataRow dsDataRow = DSGetDropdownRow(fieldName, rowNo);

        string fldRowVals = string.Empty;
        string dpVals = string.Empty;
        if (dsDataRow != null)
        {
            fldRowVals = dsDataRow["rowvals"].ToString();
            dpVals = dsDataRow["dp"].ToString();
            idCol = dsDataRow["idcol"].ToString();
            mr = dsDataRow["mr"].ToString();
            dpm = dsDataRow["dpmvalues"].ToString();
        }

        type = GetFieldType(fld);
        value = dr[fld.name].ToString();
        if (dt.Columns.Contains("id__" + fieldName))
            idVal = dr["id__" + fld.name].ToString();


        if (dt.Columns.Contains("oldid__" + fld.name))
            oldIdVal = dr["oldid__" + fld.name].ToString();


        if (rowNo == "1" && mr == "1" && AxMasterRowFlds.IndexOf(fieldName) == -1)
            AxMasterRowFlds.Add(fieldName);

        if (rowNo != "1" && AxMasterRowFlds.IndexOf(fieldName) != -1)
            mr = "1";

        if (mr != "1" && fld.fieldIsFrmList)
            mr = "1";

        if (mr != string.Empty)
            mr = "\"mr\":\"" + mr + "\",";

        if (idCol != string.Empty)
        {
            if (idCol == "0") idCol = "no";
            else idCol = "yes";
            idCol = "\"idcol\":\"" + idCol + "\",";
            if (type == "s")
                idCol = string.Empty;
        }

        if (type == "m")
            value = value.Replace("\n", "<br>");

        value = CheckSpecialCharsForClient(value);

        strId = "\"id\":\"" + idVal + "\", \"oldid\":\"" + oldIdVal + "\",";

        if (dpm != string.Empty)
            dpm = "\"dpm\":\"" + dpm + "\",";

        if (type == "c")
            strComboValues = GetComboItemsJson(fldRowVals, dpVals);

        //This is a dummy json example for dropdown
        //{"n":"sponsor","v":"abc","r":"0","idcol":"yes","id":"10032000001017","oldid":"0","mr":"0","dpm":"suffix,title","t":"c"},
        if (fld.savenormal)
            fldJson = "{\"n\":\"" + fld.name + "\",\"v\":\"" + value + "\",\"r\":\"" + rowNo + "\"," + idCol + mr + strId + dpm + " \"t\":\"" + type + "\"}";
        else
            fldJson = "{\"n\":\"" + fld.name + "\",\"v\":\"" + value + "\",\"r\":\"" + rowNo + "\"," + idCol + mr + dpm + "\"t\":\"" + type + "\"}";

        if (strComboValues != string.Empty)
            fldJson = fldJson + "," + strComboValues;
        return fldJson;
    }

    /// <summary>
    /// Function to get the json for the dv nodes for a given combo box.
    /// </summary>
    /// <param name="fldIndex"></param>
    /// <returns></returns>
    private string GetComboItemsJson(string fldRowValues, string fldDpValues)
    {
        StringBuilder strItems = new StringBuilder();
        //sample json for dropdown item
        //{"v":"15146000000000~EST-000274-Rev1","t":"dv","dp":"EST-000274~1~001~001~002"},
        string[] choices = fldRowValues.Split('♣');
        string[] dpValues = fldDpValues.Split('♣');
        string tmpStr = string.Empty;
        for (int i = 0; i < choices.Length; i++)
        {
            string strChoice = choices[i].ToString();
            strChoice = CheckSpecialCharsForClient(strChoice);
            if (strChoice != "" && i <= dpValues.Length)
            {
                tmpStr = "{\"v\":\"" + strChoice + "\", \"t\":\"dv\", \"dp\":\"" + dpValues[i].ToString() + "\"}";
                if (strItems.ToString() == string.Empty)
                    strItems.Append(tmpStr);
                else
                    strItems.Append("," + tmpStr);
            }
        }
        return strItems.ToString();
    }

    private string CheckSpecialCharsForClient(string value)
    {
        //single quote is handled in the tstruct.aspx.cs file before renddering the json to client.
        //Hence handling only double quote and backward slash.
        //fValue = fValue.Replace("^^dq", "\"");
        //fValue = fValue.Replace(";bkslh", "\\");
        value = value.Replace("\"", "^^dq");
        value = value.Replace("\\", ";bkslh");
        return value;
    }


    /// <summary>
    /// Function to get the field type of the given field and return the type attribute 't' in the json.
    /// </summary>
    /// <param name="fld"></param>
    /// <returns></returns>
    private string GetFieldType(TStructDef.FieldStruct fld)
    {
        string type = string.Empty;
        type = fld.ctype.ToUpper();
        string moe = string.Empty;

        if (fld.moe.ToLower() == "select")
        {
            if (fld.editcombo)
                return "s";
            else
                return "c";
        }
        else
        {
            switch (type)
            {
                case "CHECK LIST":
                    return "cl";
                case "MEMO":
                    return "m";
                case "IMAGE":
                    return "i";
                case "CHECK BOX":
                    return "s";
                default:
                    if (type.IndexOf("AXPBUTTON") != -1)
                        return "b";
                    else
                        return "s";

            }
        }
    }

    #endregion

    public string GetFieldSqlQuery(string fldName, string fldValues, string globalVar, string userVars, int activeRow, string parentFlds, string tblSourceParams = "")
    {
        int fldidx = tstStrObj.GetFieldIndex(fldName);
        TStructDef.FieldStruct fld = (TStructDef.FieldStruct)tstStrObj.flds[fldidx];
        string sqlQuery = fld.fieldSqlQuery;
        string sqlParamsXML = string.Empty, appVarTypes = string.Empty, parentFldVals = string.Empty;
        try
        {
            sqlQuery = "<sqltext>" + CheckSpecialChars(sqlQuery) + "</sqltext>";
            fldValues = "<fldXML>" + fldValues + "</fldXML>";
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(fldValues);
            sqlParamsXML += "<globalvars>";
            string[] tblSourceList = tblSourceParams.Split('♠');
            ArrayList tblParamExist = new ArrayList();
            // in cluase paramets for grid field {invioceno*} for non grid field {invioceno}
            if (Regex.Match(sqlQuery.ToLower(), @"{\b\w+\b}", RegexOptions.IgnoreCase).Success || Regex.Match(sqlQuery.ToLower(), @"{\b\w+\b\*}", RegexOptions.IgnoreCase).Success)
            {
                MatchCollection matchListSt = Regex.Matches(sqlQuery, @"{\b\w+\b\*}");
                var listSt = matchListSt.Cast<Match>().Select(match => match.Value).Distinct().ToList();
                MatchCollection matchList = Regex.Matches(sqlQuery, @"{\b\w+\b}");
                var list = matchList.Cast<Match>().Select(match => match.Value).Distinct().ToList();
                if (listSt.Count > 0)
                {
                    foreach (var lst in listSt)
                    {
                        string strFld = lst.Split('{')[1].Split('*')[0];
                        XmlNodeList slctNode = xmlDoc.SelectNodes("fldXML/" + strFld + "");
                        int ic = 0;
                        string stFldValue = string.Empty;
                        foreach (XmlElement strText in slctNode)
                        {
                            if (strText.InnerText != "")
                                stFldValue += strText.InnerText + "~";
                            if (ic == 0)
                            {
                                int fldidxs = tstStrObj.GetFieldIndex(strFld);
                                TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                                if (flds.datatype == "Character" || flds.datatype == "Text")
                                    appVarTypes += "c";
                                else if (flds.datatype == "Numeric")
                                    appVarTypes += "n";
                                else if (flds.datatype == "Date/Time")
                                    appVarTypes += "d";
                            }
                            ic++;
                        }
                        if (stFldValue != string.Empty)
                            stFldValue = stFldValue.Remove(stFldValue.Length - 1);
                        sqlParamsXML += "<" + strFld + ">" + stFldValue + "</" + strFld + ">";
                        parentFldVals += strFld + ":" + stFldValue + "~";
                    }
                }
                if (list.Count > 0)
                {
                    foreach (var lst in list)
                    {
                        string strFld = lst.Split('{')[1].Split('}')[0];
                        sqlParamsXML += xmlDoc.SelectSingleNode("fldXML/" + strFld + "").OuterXml;
                        parentFldVals += strFld + ":" + xmlDoc.SelectSingleNode("fldXML/" + strFld + "").InnerXml + "~";
                        int fldidxs = tstStrObj.GetFieldIndex(strFld);
                        TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                        if (flds.datatype == "Character" || flds.datatype == "Text")
                            appVarTypes += "c";
                        else if (flds.datatype == "Numeric")
                            appVarTypes += "n";
                        else if (flds.datatype == "Date/Time")
                            appVarTypes += "d";
                    }
                }
            }
            if (sqlQuery.Contains(":"))// to check any of tstruct fields & global Vars
            {
                if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", "recordid"), RegexOptions.IgnoreCase).Success)
                {
                    if (xmlDoc.InnerText != "")
                    {
                        //sqlParamsXML += xmlDoc.SelectSingleNode("fldXML/axp_recid1").OuterXml;
                        string StrRecId = xmlDoc.SelectSingleNode("fldXML/axp_recid1").OuterXml;
                        StrRecId = StrRecId.Replace("axp_recid1", "recordid");
                        sqlParamsXML += StrRecId;
                        parentFldVals += "recordid:" + xmlDoc.SelectSingleNode("fldXML/axp_recid1").InnerXml + "~";
                    }
                    else
                    {
                        sqlParamsXML += "recordid";
                        parentFldVals += "recordid:0~";
                    }
                    int fldidxs = tstStrObj.GetFieldIndex("axp_recid1");
                    TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                    if (flds.datatype == "Character" || flds.datatype == "Text")
                        appVarTypes += "c";
                    else if (flds.datatype == "Numeric")
                        appVarTypes += "n";
                    else if (flds.datatype == "Date/Time")
                        appVarTypes += "d";
                }
                if (tblSourceParams != "" && tblSourceList.Length > 0)
                {
                    try
                    {
                        foreach (var parms in tblSourceList)
                        {
                            string[] parmsVal = parms.Split(':');
                            if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", parmsVal[0]), RegexOptions.IgnoreCase).Success)
                            {
                                int fldidxs = tstStrObj.GetFieldIndex(parmsVal[0]);
                                TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                                sqlParamsXML += "<" + parmsVal[0] + " rowno=\"001\">" + parmsVal[1] + "</" + parmsVal[0] + ">";
                                parentFldVals += parms + "~";
                                if (flds.datatype == "Character" || flds.datatype == "Text")
                                    appVarTypes += "c";
                                else if (flds.datatype == "Numeric")
                                    appVarTypes += "n";
                                else if (flds.datatype == "Date/Time")
                                    appVarTypes += "d";
                                tblParamExist.Add(parmsVal[0]);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        logobj.CreateLog("GetFieldSqlQuery table source params - " + ex.Message, sessionid, "GetFieldSqlQuery-tblsourceparams" + transid, "new");
                    }
                }
                foreach (XmlNode parms in xmlDoc.ChildNodes[0].ChildNodes)
                {
                    if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", parms.Name.ToString()), RegexOptions.IgnoreCase).Success)
                    {
                        if (tblParamExist.IndexOf(parms.Name) > 0)
                            continue;
                        int fldidxs = tstStrObj.GetFieldIndex(parms.Name);
                        TStructDef.FieldStruct flds = (TStructDef.FieldStruct)tstStrObj.flds[fldidxs];
                        bool isDcGrid = false;
                        isDcGrid = IsDcGrid(flds.fldframeno.ToString(), tstStrObj);
                        if (isDcGrid == true && int.Parse(parms.Attributes["rowno"].Value) == activeRow)
                        {
                            sqlParamsXML += parms.OuterXml;
                            parentFldVals += parms.Name + ":" + parms.InnerXml + "~";
                            if (flds.datatype == "Character" || flds.datatype == "Text")
                                appVarTypes += "c";
                            else if (flds.datatype == "Numeric")
                                appVarTypes += "n";
                            else if (flds.datatype == "Date/Time")
                                appVarTypes += "d";
                        }
                        else if (isDcGrid == false)
                        {
                            sqlParamsXML += parms.OuterXml;
                            parentFldVals += parms.Name + ":" + parms.InnerXml + "~";
                            if (flds.datatype == "Character" || flds.datatype == "Text")
                                appVarTypes += "c";
                            else if (flds.datatype == "Numeric")
                                appVarTypes += "n";
                            else if (flds.datatype == "Date/Time")
                                appVarTypes += "d";
                        }
                    }
                }
                XmlDocument xmlDocgbl = new XmlDocument();
                xmlDocgbl.LoadXml(globalVar);
                string blgAppVar = string.Empty;
                if (xmlDocgbl.SelectSingleNode("globalvars/appvartypes") != null)
                    blgAppVar = xmlDocgbl.SelectSingleNode("globalvars/appvartypes").InnerXml;
                int gblIcnt = 1;
                foreach (XmlNode parms in xmlDocgbl.ChildNodes[0].ChildNodes)
                {
                    if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", parms.Name.ToString()), RegexOptions.IgnoreCase).Success && parms.Name != "appvartypes" && !Regex.Match(sqlParamsXML, System.String.Format(@"<\b{0}\b", parms.Name.ToString()), RegexOptions.IgnoreCase).Success)
                    {
                        sqlParamsXML += parms.OuterXml;
                        parentFldVals += parms.Name + ":" + parms.InnerXml + "~";
                        if (blgAppVar.Length >= gblIcnt)
                            appVarTypes += blgAppVar[gblIcnt - 1].ToString();
                        else if (blgAppVar.Length < gblIcnt)
                            appVarTypes += "c";
                    }
                    gblIcnt++;
                }

                XmlDocument xmlDocUv = new XmlDocument();
                xmlDocUv.LoadXml(userVars);
                foreach (XmlNode parms in xmlDocUv.ChildNodes[0].ChildNodes)
                {
                    if (Regex.Match(sqlQuery, String.Format(@":\b{0}\b", parms.Name.ToString()), RegexOptions.IgnoreCase).Success)
                    {
                        sqlParamsXML += parms.OuterXml;
                        parentFldVals += parms.Name + ":" + parms.InnerXml + "~";
                        appVarTypes += "c";
                    }
                }
            }
            if (sqlParamsXML != "<globalvars>")
                sqlParamsXML += "<appvartypes>" + appVarTypes + "</appvartypes>";
            sqlParamsXML += "</globalvars>";
            if (activeRow == 0 && tblSourceParams == "")
            {
                string SessAutKey = "autocomplete♦" + transid + "-" + fldName + "-" + parentFlds;
                HttpContext.Current.Session[SessAutKey] = sqlQuery + sqlParamsXML + "♠" + parentFldVals;
            }
        }
        catch (Exception ex)
        {
        }
        return sqlQuery + sqlParamsXML + "♠" + parentFldVals;
    }


    public string GetDBMemVarsXML(string _thisTid)
    {
        string dbmemvarsXML = string.Empty;
        try
        {
            //if (HttpContext.Current.Session["dbmemvars_" + _thisTid] != null && HttpContext.Current.Session["dbmemvars_" + _thisTid].ToString() != "")
            //    dbmemvarsXML = HttpContext.Current.Session["dbmemvars_" + _thisTid].ToString();
            dbmemvarsXML = util.GetDBMemVarsXML(_thisTid);
        }
        catch (Exception ex)
        {
            dbmemvarsXML = string.Empty;
            logobj.CreateLog("GetDBMemVariables XML  - " + ex.Message, sessionid, "GetDBMemVarsXML-" + _thisTid, "new");
        }
        return dbmemvarsXML;
    }

    public string GetAxRuleFlsXML(string axRulesFlds, string _thisTid, bool isOnSubmit = false)
    {
        string axrulefldXMl = string.Empty;
        try
        {
            if (axRulesFlds != "")
            {
                StringBuilder allowEmpty = new StringBuilder();
                StringBuilder axValidate = new StringBuilder();
                StringBuilder axDuplicate = new StringBuilder();
                StringBuilder axValidateOnsave = new StringBuilder();
                string[] listarflds = axRulesFlds.Split('♥');
                foreach (var _thisaxr in listarflds)
                {
                    string[] typelist = _thisaxr.Split('♦');
                    if (typelist[0] == "validate")
                        axValidate.Append("<" + typelist[1] + ">" + util.CheckSpecialChars(typelist[2]) + "</" + typelist[1] + ">");
                    else if (typelist[0] == "validate_onsave")
                        axValidateOnsave.Append("<" + typelist[1] + ">" + util.CheckSpecialChars(typelist[2]) + "</" + typelist[1] + ">");
                    else if (typelist[0] == "allowempty")
                        allowEmpty.Append("<" + typelist[1] + ">" + util.CheckSpecialChars(typelist[2]) + "</" + typelist[1] + ">");
                    else if (typelist[0] == "allowduplicate")
                        axDuplicate.Append("<" + typelist[1] + ">" + util.CheckSpecialChars(typelist[2]) + "</" + typelist[1] + ">");
                }
                axrulefldXMl = "<axrules>";
                if (axValidate.ToString() != "")
                    axrulefldXMl += "<validate>" + axValidate.ToString() + "</validate>";
                if (axValidateOnsave.ToString() != "")
                    axrulefldXMl += "<validate_onsave>" + axValidateOnsave.ToString() + "</validate_onsave>";
                if (allowEmpty.ToString() != "")
                    axrulefldXMl += "<allowempty>" + allowEmpty.ToString() + "</allowempty>";
                if (axDuplicate.ToString() != "")
                    axrulefldXMl += "<allowduplicate>" + axDuplicate.ToString() + "</allowduplicate>";
                if (isOnSubmit && HttpContext.Current.Session["AxRuleOnSubmit"] != null)
                    axrulefldXMl += HttpContext.Current.Session["AxRuleOnSubmit"].ToString();

                axrulefldXMl += "</axrules>";
            }
            else if (axRulesFlds == "" && isOnSubmit)
            {
                if (HttpContext.Current.Session["AxRuleOnSubmit"] != null)
                {
                    axrulefldXMl = "<axrules>";
                    axrulefldXMl += HttpContext.Current.Session["AxRuleOnSubmit"].ToString();
                    axrulefldXMl += "</axrules>";
                }
            }
        }
        catch (Exception ex)
        {
            axrulefldXMl = string.Empty;
            logobj.CreateLog("GetAxRuleFlsXML XML  - " + ex.Message, sessionid, "GetAxRuleFlsXML-" + _thisTid, "new");
        }
        return axrulefldXMl;
    }

    public string GetConfigDataVarsXML(string _thisTid)
    {
        string cdVarsXML = string.Empty;
        try
        {
            cdVarsXML = util.GetConfigDataVarsXML(_thisTid);
        }
        catch (Exception ex)
        {
            cdVarsXML = string.Empty;
            logobj.CreateLog("GetConfigDataVarsXML XML  - " + ex.Message, sessionid, "GetConfigDataVarsXML-" + _thisTid, "new");
        }
        return cdVarsXML;
    }

    private void ClearIviewDataKey()
    {
        try
        {
            if (HttpContext.Current.Session["openerIV"] != null && HttpContext.Current.Session["openerIV"].ToString() != "")
            {
                string openIvName = HttpContext.Current.Session["openerIV"].ToString();

                FDW fdwObj = FDW.Instance;
                FDR fObj = (FDR)HttpContext.Current.Session["FDR"];
                if (fObj == null)
                    fObj = new FDR();



                string[] ivlvKeys = openIvName.Split('~');
                if (ivlvKeys[1] == "IV")
                {
                    string keyPattern = fObj.MakeKeyName(Constants.RedisIvData, ivlvKeys[0], user, "*", -1);
                    ArrayList keyList = fObj.GetPrefixedKeys(keyPattern, true, string.Empty, false);
                    fdwObj.DeleteKeys(keyList);
                }
                else if (ivlvKeys[1] == "LV")
                {
                    string keyPattern = fObj.MakeKeyName(Constants.RedisLvData, ivlvKeys[0], user, "*", -1);
                    ArrayList keyList = fObj.GetPrefixedKeys(keyPattern, true, string.Empty, false);
                    fdwObj.DeleteKeys(keyList);
                }
            }
        }
        catch (Exception ex) { }
    }
}
#endregion
