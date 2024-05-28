Imports System
Imports System.IO
Imports iTextSharp.text.Table
Imports iTextSharp.text.pdf
Imports iTextSharp.text
Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.ComponentModel
Imports System.Collections
Imports System.Xml

Partial Class pdfiview
    Inherits System.Web.UI.Page

    Dim _xmlString As String =
                   "<?xml version=""1.0"" encoding=""utf-8"" ?>"
    Dim logobj As LogFile.Log = New LogFile.Log()
    Dim util As Util.Util = New Util.Util()
    Dim colHide As New ArrayList()
    Dim colFld As New ArrayList()
    Dim colWidth As New ArrayList()
    Dim colHead As New ArrayList()
    Dim ivhead As New ArrayList()
    Dim arrLstParams As New ArrayList
    Dim arrLstParamVal As New ArrayList
    Dim iname As String
    Dim user As String
    Dim sid As String
    Dim ivtype As String
    Dim isFromHome As Boolean = False
    Dim proj As String
    Dim paramVal As String
    Dim iViewCap As String
    Dim paramXml As String = ""
    Dim pivotGroupHeaderNames As New ArrayList()
    Dim pivotStartCol As New ArrayList()
    Dim pivotEndCol As New ArrayList()
    Dim htmlColumns As New ArrayList()
    Dim objIview
    Public sb As StringBuilder = New StringBuilder()
    Dim listres As String = String.Empty
    Dim isperf As String = "false"
    Dim caption As String = ""
    Dim isPrint As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("project") = "" Then
            sess_expires()
        Else
            If Request.UrlReferrer IsNot Nothing Then
                'If Not (Request.UrlReferrer.AbsolutePath.ToLower().Contains("iview.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("listiview.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("saveas.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("pdfiview.aspx")) Then
                '    Response.Redirect("../CusError/AxCustomError.aspx")
                'End If
            End If
            Dim Ikey As String = String.Empty

            If Session("ivKey") <> Nothing Then
                Ikey = Session("ivKey").ToString()

            Else
                If Not Request.QueryString("ivKey") Is Nothing Then
                    Ikey = Request.QueryString("ivKey")

                End If
            End If
            If Not IsPostBack Then
                iname = Request.QueryString("ivname")

                If Not iname Is Nothing Then
                    If Not util.IsValidIvName(iname) Then
                        Response.Redirect(Constants.PARAMERR)
                    End If
                End If
                If Not Request.QueryString("AxFromhome") Is Nothing Then
                    isFromHome = Request.QueryString("AxFromhome")
                End If
                user = Session("user")
                sid = Session("nsessionid")
                ivtype = Request.QueryString("ivtype")

                If Not ivtype Is Nothing Then
                    If Not ivtype Is Nothing And Not util.IsChar(ivtype) Then
                        Response.Redirect(Constants.PARAMERR)
                    End If
                End If

                If Not Request.QueryString("axpCache") Is Nothing Then
                    paramVal = Session("AxIvExportParams-" + iname).ToString()
                    Session("AxIvExportParams-" + iname) = ""
                Else
                    paramVal = Request.QueryString("params")
                End If

                If iname = Nothing And Session("ivname") <> Nothing Then
                    iname = Session("ivname").ToString()
                End If
                If paramVal = Nothing And Session("params") <> Nothing Then
                    paramVal = Session("params").ToString()
                End If
                If ivtype = Nothing And Session("ivtype") <> Nothing Then
                    ivtype = Session("ivtype").ToString()
                End If


                ' If ivtype = "listview" Or ivtype = "lview" Then
                '     objIview = New ListviewData()
                '     objIview = CType(Session(Ikey), ListviewData)
                ' Else
                objIview = New IviewData()
                objIview = CType(Session(Ikey), IviewData)
                ' End If
                If isFromHome Then
                    objIview = New IviewData()
                    'GetPDF()
                    'objIview = CType(Session(Ikey), IviewData)


                    objIview.colFld = New ArrayList
                    objIview.ColNoPrint = New ArrayList
                    objIview.ReportHdrs = New ArrayList
                    objIview.ReportFtrs = New ArrayList
                    objIview.ColHide = New ArrayList
                    objIview.ColFld = New ArrayList
                    objIview.ColAlign = New ArrayList
                    objIview.IviewCaption = ""
                    objIview.IsDirectDBcall = False

                End If
                objIview.FilterXml = ""
                ViewState("ivtype") = ivtype
                ViewState("params") = paramVal
                proj = Session("project")
                ViewState("iname") = iname
                ViewState("ivtype") = ivtype
                ViewState("proj") = proj
                ViewState("user") = user
                ViewState("sid") = sid
            Else
                user = ViewState("user")
                iname = ViewState("iname")
                ivtype = ViewState("ivtype")
                proj = ViewState("proj")
                sid = ViewState("sid")
                paramVal = ViewState("params")
                ivtype = ViewState("ivtype")
            End If

            Dim printUlr As String = String.Empty
            Dim pdfHtmlToPdfExePath As String = String.Empty
            If HttpContext.Current.Session("AxHtmlPath") IsNot Nothing Then
                printUlr = HttpContext.Current.Session("AxHtmlPath").ToString()
            End If

            If HttpContext.Current.Session("AxPrintExePath") IsNot Nothing Then
                pdfHtmlToPdfExePath = HttpContext.Current.Session("AxPrintExePath").ToString()
            End If

            If pdfHtmlToPdfExePath <> "" Then
                Dim ststext As String
                ststext = GetHtml()
                If printUlr Is Nothing Or printUlr = "" Then
                    printUlr = HttpContext.Current.Application("ScriptsPath").ToString()
                    printUlr = printUlr & "Axpert\PrintPDF"
                    If Not Directory.Exists(printUlr) Then
                        Directory.CreateDirectory(printUlr)
                    End If
                End If
                Dim tempHtmlfile As String = printUlr + "\iview_" + DateTime.Now.ToString("yyyy-MM-dd-hh-mm-ss-fff") + ".html"
                Dim fs As New FileStream(tempHtmlfile, FileMode.Create)
                Dim swXLS As New StreamWriter(fs, Encoding.UTF8)
                swXLS.WriteLine(ststext.ToString())
                swXLS.Close()
                Dim pdfUlr As String
                pdfUlr = HttpContext.Current.Application("ScriptsPath").ToString()
                pdfUlr = pdfUlr & "Axpert\" & sid & "\"
                If Not Directory.Exists(pdfUlr) Then
                    Directory.CreateDirectory(pdfUlr)
                End If
                Dim fileName = Wkhtmltopdf.PdfGenerator.HtmlToPdf(pdfUlr, "view", tempHtmlfile, "iview")
                Response.Buffer = True
                Response.Clear()
                Response.ClearContent()
                Response.ClearHeaders()
                Response.AddHeader("Content-disposition", "attachment;filename=" & fileName)
                Response.ContentType = "application/pdf"
                Response.WriteFile(pdfUlr + fileName)
                If Not String.IsNullOrEmpty(fileName) Then
                    If fileName <> "EXE path Not defined" Then
                        If File.Exists(tempHtmlfile) Then
                            File.Delete(tempHtmlfile)
                        End If
                    End If
                End If
                Response.End()
            Else
                Dim str As String = GetPDF()
                Response.Buffer = True
                Response.Clear()
                Response.ClearContent()
                Response.ClearHeaders()
                Dim files As System.IO.FileInfo = New System.IO.FileInfo(str)
                Response.AddHeader("Content-disposition", "attachment;filename=" & files.Name)
                Response.ContentType = "application/pdf"
                Response.WriteFile(files.FullName)
                Response.End()
            End If
        End If
    End Sub

    Private Function AlignCell(cellAttr As Cell, AlignStr As String) As Cell

        If AlignStr = "" Or AlignStr = "Left" Then
            cellAttr.HorizontalAlignment = Element.ALIGN_LEFT
        ElseIf AlignStr = "Right" Then
            cellAttr.HorizontalAlignment = Element.ALIGN_RIGHT
        ElseIf AlignStr = "Center" Then
            cellAttr.HorizontalAlignment = Element.ALIGN_CENTER
        End If

        Return cellAttr

    End Function
    Private Sub GetParam(ByVal param As String)
        Dim k As Integer

        Dim tem1 As String
        Dim arrParams As Array
        Dim arrNoOfParams As Array
        Dim params As String

        If Not paramVal Is Nothing Then
            If paramVal.Contains("~") Then
                arrNoOfParams = paramVal.Split("~")
                Dim i As Integer
                For i = 0 To arrNoOfParams.Length - 1
                    arrParams = arrNoOfParams(i).ToString().Split("♠")
                    arrLstParams.Insert(i, arrParams(0))
                    If arrParams(1).Contains("`") = True Then
                        arrParams(1) = arrParams(1).Replace("`", "~")
                        'arrParams(1) = arrParams(1).Replace("`", ",")
                    End If

                    arrLstParamVal.Insert(i, arrParams(1))
                Next
            Else
                arrParams = paramVal.Split("♠")
                For k = 0 To arrParams.Length - 1
                    If arrParams.Length > k + 1 Then
                        arrLstParams.Insert(k, arrParams(0))
                        If arrParams(1).Contains("`") = True Then
                            arrParams(1) = arrParams(1).Replace("`", ",")
                        End If

                        arrLstParamVal.Insert(k, arrParams(1))
                    End If
                Next
            End If
        End If

        Dim j As Integer
        For j = 0 To arrLstParams.Count - 1
            If arrLstParams.Count > 0 Then
                tem1 = arrLstParams(j).ToString()
                If arrLstParams.Count > 0 Then
                    paramVal = arrLstParamVal(j).ToString().Replace("&grave;", "~")
                    paramVal = arrLstParamVal(j).ToString().Replace("&amp;", "&")
                Else
                    paramVal = ""
                End If
            End If

            If param <> "" Then
                paramXml = paramXml & "<" & tem1 & ">"
                paramXml = paramXml & util.CheckSpecialCharsSaveAs(util.ReplaceUrlSpecialChars(paramVal))
                paramXml = paramXml & "</" & tem1 & ">"

                params = params & "&" & tem1 & "="
                params = params & paramVal
            Else
                paramXml = "<params>"
            End If

        Next
    End Sub

    ''' <summary>
    ''' function for handling session timeout.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub sess_expires()
        Dim url As String = util.SESSEXPIRYPATH
        Response.Write("<script language=""javascript"">" & vbCrLf)
        Response.Write("parent.parent.location.href='" & url & "';")
        Response.Write(vbCrLf & "</script>")
    End Sub
    'By using this method we can convert datatable to xml
    Public Function ConvertDatatableToXML(ByVal dt As System.Data.DataTable) As String
        Dim str As New MemoryStream()
        dt.TableName = "row"
        dt.WriteXml(str, True)
        str.Seek(0, SeekOrigin.Begin)
        Dim sr As New StreamReader(str)
        Dim xmlstr As String
        xmlstr = sr.ReadToEnd().Replace("DocumentElement", "data")
        Return (xmlstr)
    End Function



    Private Function GetPDF() As String
        Dim isList As String
        If ivtype = "listview" Or ivtype = "lview" Then
            isList = "true"
        Else
            isList = "false"
        End If

        GetParam(paramVal)

        Dim sortCol As String = String.Empty
        Dim sortOrd As String = String.Empty
        Dim filterCol As String = String.Empty
        Dim filterColVal As String = String.Empty
        Dim filterValue1 As String = String.Empty
        Dim filterOpr As String = String.Empty

        If Session("sOrder") <> Nothing Then
            If Session("sOrder").ToString() <> "" Then
                sortOrd = Session("sOrder").ToString()
            End If
        End If

        If Session("sColumn") <> Nothing Then
            If Session("sColumn").ToString() <> "" Then
                sortCol = Session("sColumn").ToString()
            End If
        End If

        If Session("fcolopr") <> Nothing Then
            If Session("fcolopr").ToString() <> "" Then
                filterOpr = Session("fcolopr").ToString()
            End If
        End If

        If Session("fCol") <> Nothing Then
            If Session("fCol").ToString() <> "" Then
                filterCol = Session("fCol").ToString()
            End If
        End If

        If Session("fColVal") <> Nothing Then
            If Session("fColVal").ToString() <> "" Then
                filterColVal = Session("fColVal").ToString()
            End If
        End If

        If Session("fColVal2") <> Nothing Then
            If Session("fColVal2").ToString() <> "" Then
                filterValue1 = Session("fColVal2").ToString()
            End If
        End If

        Dim isperf As String = ""
        Dim fileName As String = "GetLView" + iname
        Dim errorLog As String = logobj.CreateLog("GetLView.", sid, fileName, "new")

        Dim custXML As String = ""
        If isList = "true" Then
            'if custom view is selected then passing custom view name in the input xml
            Try
                If Not objIview.CustomView Is String.Empty Then
                    custXML = " custviewname =""" & objIview.CustomView & """"
                    'custviewname="testing1"
                End If
            Catch ex As Exception
            End Try
        End If

        Dim iXml As String
        iXml = "<root name =""" & iname & """" & custXML & " axpapp =""" & Session("project") & """ appsessionkey=" & Chr(34) & Session("AppSessionKey").ToString() & Chr(34) & " username=" & Chr(34) & Session("username").ToString() & Chr(34) & " sessionid = """ & sid & """  trace =" & Chr(34) & errorLog & Chr(34) & " pageno=""0"" firsttime=""yes"" sorder=""" & sortOrd & """ scol=""" & sortCol & """ fcolopr=""" + filterOpr + """ fcolnm=""" & filterCol & """ fcolval1=""" + filterColVal + """ fcolval2=""" + filterValue1 + """ pforms=""true""><params> "
        iXml = iXml & paramXml
        iXml = iXml & "</params>"
        iXml &= Session("axApps").ToString() + Application("axProps").ToString() + Session("axGlobalVars").ToString() + Session("axUserVars").ToString() & "</root>"
        Dim ires As String = String.Empty

        If objIview.IsDirectDBcall = True Then
            Dim ds As DataSet = New DataSet()
            Dim objdb As DBContext = New DBContext()
            ds = objdb.GetIviewDataDB(objIview.SqlQuery, 0, 0, objIview.IsGrandTotal)
            Dim gridPageSize As Integer
            If ds.Tables.Count > 0 And ds.Tables(0).Rows.Count > 0 Then
                gridPageSize = ds.Tables(0).Rows.Count
            End If
            ds = objIview.ApplySubTotal(ds, True, gridPageSize)
            Return DataTable2String(ds.Tables(0))

        Else
            'Call service
            Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()
            If ivtype = "listview" Or ivtype = "lview" Then
                If objIview.FilterXml Is String.Empty Then                 'Checking for filtering in listview
                    ires = objWebServiceExt.CallGetLViewWS(iname, iXml, objIview.WebServiceTimeout)
                Else
                    Dim listres As String = objIview.Listres
                    ires = objIview.FilterXml.ToString()
                    Dim index As Integer = -1
                    index = ires.IndexOf(">")
                    ires = ires.Insert(index + 1, listres)
                End If
            Else
                If Session("FilteredData") Is Nothing Then
                    objIview.requestJSON = False
                    ires = objWebServiceExt.CallGetIViewWS(iname, iXml, "", objIview)
                    If ires IsNot Nothing Then
                        ires = ires.Split("♠")(1)
                    End If
                    Dim xmlDoc As New XmlDocument
                    Dim compCheckPerf As XmlNode

                    xmlDoc.LoadXml(ires)

                    compCheckPerf = xmlDoc.SelectSingleNode("//data")
                    If Not compCheckPerf.Attributes("perfxml") Is Nothing Then
                        isperf = compCheckPerf.Attributes("perfxml").Value()
                    End If

                Else

                    Dim dt As System.Data.DataTable = New System.Data.DataTable()
                    dt = CType(Session("FilteredData"), System.Data.DataTable)
                    Dim res As String = Session("res")
                    ires = ConvertDatatableToXML(dt)
                    ires = ires.Insert(7, res)

                End If
            End If
        End If


        ViewState("ivxml") = ires
        Dim ivxml As String = ""
        ivxml = ViewState("ivxml")

        Dim strErrMsg As String = String.Empty
        strErrMsg = util.ParseXmlErrorNode(ires)


        If strErrMsg <> String.Empty Then
            strErrMsg = strErrMsg.Replace(vbCr, "").Replace(vbLf, "")
            If strErrMsg = Constants.SESSIONERROR Then
                Session.RemoveAll()
                Session.Abandon()
                Dim url1 As String
                url1 = util.SESSEXPIRYPATH
                Response.Write("<script>" & vbCrLf)
                Response.Write("parent.parent.location.href='" & url1 & "';")
                Response.Write(vbCrLf & "</script>")
            Else
                Response.Redirect(util.ERRPATH + strErrMsg)
            End If
        Else

            ires = _xmlString & ires
            Dim xmlDoc As New XmlDocument
            xmlDoc.LoadXml(ires)

            pivotGroupHeaderNames.Clear()
            pivotStartCol.Clear()
            pivotEndCol.Clear()

            'If isperf = "true" Then
            '    Dim dummyRowNodes As XmlNodeList
            '    dummyRowNodes = xmlDoc.SelectNodes("//row")
            '    dummyRowNodes(0).ParentNode.RemoveChild(dummyRowNodes(0))
            'End If


            Dim productNodes As XmlNodeList
            Dim productNode As XmlNode
            Dim baseDataNodes As XmlNodeList
            productNodes = xmlDoc.SelectNodes("//headrow")
            Dim hcolNos As Integer
            hcolNos = 0

            For Each productNode In productNodes
                baseDataNodes = productNode.ChildNodes
                Dim iCount As Integer = -1
                For Each baseDataNode As XmlNode In baseDataNodes
                    iCount += 1
                    colFld.Add(baseDataNode.Name)
                    colHead.Add(baseDataNode.InnerText)
                    If baseDataNode.Attributes("width") IsNot Nothing Then
                        colWidth.Add(baseDataNode.Attributes("width").Value)
                    Else
                        colWidth.Add("0")
                    End If

                    'teat = teat & baseDataNode.Name & "......" & baseDataNode.InnerText & "..."
                    If baseDataNode.Name = "rowno" Then
                        If ivtype = "listview" Or ivtype = "lview" Then
                            colHide.Add("false")
                        Else
                            colHide.Add("true")
                        End If

                    Else
                        If baseDataNode.Name.StartsWith("html_") Then
                            htmlColumns.Add(baseDataNode.Name)
                        End If

                        If Not baseDataNode.Attributes("hide") Is Nothing Then
                            If baseDataNode.Name.StartsWith("hide_") Then
                                colHide.Add("true")
                            ElseIf ivtype <> "listview" And ivtype <> "lview" Then
                                If Not objIview.ColNoPrint Is Nothing Then
                                    If objIview.ColNoPrint.Count > iCount Then
                                        If objIview.ColNoPrint(iCount) = True Then
                                            colHide.Add("true")
                                        Else
                                            colHide.Add(baseDataNode.Attributes("hide").Value)
                                        End If
                                    Else
                                        colHide.Add(baseDataNode.Attributes("hide").Value)

                                    End If
                                Else
                                    colHide.Add(baseDataNode.Attributes("hide").Value)
                                End If
                            Else
                                colHide.Add(baseDataNode.Attributes("hide").Value)
                            End If
                        End If
                        If baseDataNode.Name = "pivotghead" Then
                            Dim finalNodelist As XmlNodeList
                            For Each base2node As XmlNode In baseDataNode
                                finalNodelist = base2node.ChildNodes
                                For Each finalNode As XmlNode In finalNodelist
                                    If finalNode.Name = "sn" Then
                                        pivotStartCol.Add(finalNode.InnerText)
                                    ElseIf finalNode.Name = "ghead" Then
                                        pivotGroupHeaderNames.Add(finalNode.InnerText)
                                    ElseIf finalNode.Name = "en" Then
                                        pivotEndCol.Add(finalNode.InnerText)
                                    End If
                                Next
                            Next
                            colHide.Add("true")
                        End If

                        hcolNos = hcolNos + 1
                    End If
                Next
            Next

            Dim htIdx = 0
            Dim cIdx = 0
            For htIdx = 0 To htmlColumns.Count - 1
                For cIdx = 0 To colFld.Count - 1
                    Dim htmlColName As String = htmlColumns(htIdx)
                    If colFld(cIdx) = htmlColName Then
                        colHide(cIdx) = "false"
                    ElseIf colFld(cIdx) = htmlColName.Replace("html_", "") Then
                        colHide(cIdx) = "true"
                    End If

                Next
            Next

            'to remove attributes from headrow
            Dim productNodes2 As XmlNodeList
            Dim productNode2 As XmlNode
            Dim baseDataNodes2 As XmlNodeList
            productNodes2 = xmlDoc.SelectNodes("//headrow")

            For Each productNode2 In productNodes2
                baseDataNodes2 = productNode2.ChildNodes
                For Each baseDataNode2 As XmlNode In baseDataNodes2
                    baseDataNode2.Attributes.RemoveAll()
                Next
            Next

            Dim compNodes As XmlNodeList
            Dim compNode As XmlNode
            Dim cbaseDataNodes As XmlNodeList
            compNodes = xmlDoc.SelectNodes("//data/comps")
            For Each compNode In compNodes
                cbaseDataNodes = compNode.ChildNodes
                Dim cnt1 As Integer
                cnt1 = 0
                Dim compNodeCnt As Integer = 0
                Dim ToolbarBtnCnt As Integer

                ToolbarBtnCnt = cbaseDataNodes.Count - 1

                For compNodeCnt = ToolbarBtnCnt To 0 Step -1

                    If Mid(cbaseDataNodes(compNodeCnt).Name, 1, 7) = "x__head" Then

                        iViewCap = (cbaseDataNodes(compNodeCnt).Attributes("caption").Value)
                        Exit For
                    End If
                Next
            Next

            'Remove Comps
            Dim cNode As XmlNode
            cNode = xmlDoc.SelectSingleNode("//comps")
            cNode.ParentNode.RemoveChild(cNode)

            'remove hidden fields in headrow
            Dim hrep As Integer
            'change  later try new code to remove this for
            For hrep = 1 To hcolNos

                Dim productNodes3 As XmlNodeList
                Dim productNode3 As XmlNode
                Dim baseDataNodes3 As XmlNodeList
                productNodes3 = xmlDoc.SelectNodes("//headrow")

                Dim hidx As Integer

                For Each productNode3 In productNodes3
                    baseDataNodes3 = productNode3.ChildNodes
                    For Each baseDataNode3 As XmlNode In baseDataNodes3
                        'Response.Write(baseDataNode1.Name & "<br>")
                        For hidx = 0 To colFld.Count - 1
                            If colFld(hidx) = baseDataNode3.Name Then
                                Try
                                    If colHide(hidx) = "true" Then
                                        baseDataNode3.ParentNode.RemoveChild(baseDataNode3)
                                    End If
                                Catch ex As Exception
                                End Try

                            End If
                        Next
                    Next
                Next
            Next

            'remove hidden fields
            Dim rep As Integer
            'change  later try new code to remove this for
            For rep = 1 To hcolNos
                Dim productNodes1 As XmlNodeList
                Dim productNode1 As XmlNode
                Dim baseDataNodes1 As XmlNodeList
                productNodes1 = xmlDoc.SelectNodes("//row")

                Dim idx As Integer
                For Each productNode1 In productNodes1
                    baseDataNodes1 = productNode1.ChildNodes
                    For Each baseDataNode1 As XmlNode In baseDataNodes1
                        'Response.Write(baseDataNode1.Name & "<br>")
                        For idx = 0 To colFld.Count - 1
                            Try
                                If colFld(idx).ToString().ToLower() = baseDataNode1.Name.ToLower() Then
                                    If colHide(idx) = "true" Then
                                        baseDataNode1.ParentNode.RemoveChild(baseDataNode1)
                                    End If
                                End If
                            Catch ex As Exception

                            End Try


                        Next
                    Next
                Next
            Next

            'PDF creation starts
            'find no of visible columns

            Dim viscols As Integer
            viscols = 0
            Dim g As Integer
            If ivtype = "listview" Or ivtype = "lview" Or (isperf = "true" And ivtype.ToLower() = "iview") Then
                For g = 0 To colHide.Count - 1
                    If colHide(g) = "false" Then
                        viscols = viscols + 1
                    End If
                Next
            Else
                For g = 1 To colHide.Count - 1
                    If colHide(g) = "false" Then
                        viscols = viscols + 1
                    End If
                Next
            End If


            'Dim viscolsCount = viscols - 1
            'If isperf = "true" And ivtype.ToLower() = "iview" Then
            '    viscolsCount = viscolsCount + 1
            'End If
            'Dim widthscell(viscolsCount - 1) As Integer
            Dim widthscell(viscols - 1) As Integer
            Dim clcont As Integer
            If ivtype = "listview" Or ivtype = "lview" Or (isperf = "true" And ivtype.ToLower() = "iview") Then
                For g = 0 To colHide.Count - 1
                    If colHide(g) = "false" Then
                        If objIview.colFld.Count > 0 Then
                            If objIview.colFld(g) = "rowno" Then
                                widthscell(clcont) = "50"
                                clcont = clcont + 1
                            Else
                                'widthscell(clcont) = objIview.ColWidth(g)
                                If Not objIview.ColWidth Is Nothing Then
                                    widthscell(clcont) = objIview.ColWidth(objIview.colFld.IndexOf(colFld(g)))
                                Else
                                    widthscell(clcont) = colWidth(g)
                                End If
                                clcont = clcont + 1
                            End If
                        ElseIf colWidth.Count > 0 Then
                            If colFld(g) = "rowno" Then
                                widthscell(clcont) = "50"
                                clcont = clcont + 1
                            Else
                                widthscell(clcont) = colWidth(g)
                                clcont = clcont + 1
                            End If

                        End If
                    End If
                Next
            Else
                For g = 1 To colHide.Count - 1
                    If colHide(g) = "false" Then
                        If Not objIview.ColWidth Is Nothing Then
                            'widthscell(clcont) = objIview.ColWidth(g)
                            widthscell(clcont) = objIview.ColWidth(objIview.colFld.IndexOf(colFld(g)))
                        Else
                            widthscell(clcont) = colWidth(g)
                        End If
                        clcont = clcont + 1
                    End If
                Next
            End If

            'Response.Write(viscols & "..")
            Dim htab As iTextSharp.text.Table
            'If Not isFromHome Then
            'htab = New iTextSharp.text.Table(viscolsCount)
            htab = New iTextSharp.text.Table(viscols)
            htab.WidthPercentage = 100
            htab.Border = 1
            htab.Cellspacing = 1
            htab.Cellpadding = 1
            htab.SetWidths(widthscell)
            'End If



            'start
            'create pivot headers
            Dim inc As Integer
            Dim colSpan As Integer
            Dim totColSpan As Integer = 0
            For inc = 0 To pivotGroupHeaderNames.Count - 1
                Dim hn As String
                colSpan = CInt(pivotEndCol(inc).ToString) - CInt(pivotStartCol(inc).ToString)
                hn = pivotGroupHeaderNames(inc).ToString()
                Dim cellAttribute As Cell = New Cell(New Phrase(hn, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                cellAttribute.Colspan = colSpan
                cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                htab.AddCell(cellAttribute)
                totColSpan += colSpan
            Next
            For inc = 1 To (htab.Columns) - totColSpan
                Dim cellAttributes As Cell = New Cell(New Phrase("", FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                htab.AddCell(cellAttributes)
            Next






            'End pivaot heading 


            'PDF creation starts
            'find no of visible columns


            Dim hproductNodes As XmlNodeList
            Dim hproductNode As XmlNode
            Dim hbaseDataNodes As XmlNodeList
            Dim tmpColCount As Integer = 0
            hproductNodes = xmlDoc.SelectNodes("/data/headrow")
            For Each hproductNode In hproductNodes
                hbaseDataNodes = hproductNode.ChildNodes
                tmpColCount = hbaseDataNodes.Count
                Response.Write(hbaseDataNodes.Count)
                For Each hbaseDataNode As XmlNode In hbaseDataNodes
                    Dim hn As String
                    If hbaseDataNode.Name = "rowno" Then
                        If ivtype = "listview" Or ivtype = "lview" Then
                            hn = "Sr. No."
                            Dim cellAttribute As Cell = New Cell(New Phrase(hn, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                            cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                            htab.AddCell(cellAttribute)
                        End If
                    Else
                        hn = hbaseDataNode.InnerText
                        If hn = "axp_slno" Then
                            hn = "Sr. No."
                        End If
                        If (hn.IndexOf("~") <> "-1") Then
                            hn = hn.Replace("~", Chr(10))
                        End If
                        Dim cellAttribute As Cell = New Cell(New Phrase(hn, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                        cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                        If Not htab Is Nothing Then
                            htab.AddCell(cellAttribute)
                        End If
                    End If
                Next
            Next

            ' Get Data
            Dim dproductNodes As XmlNodeList
            Dim dproductNode As XmlNode
            Dim dbaseDataNodes As XmlNodeList
            Dim AlignStr As String = String.Empty
            dproductNodes = xmlDoc.SelectNodes("/data/row")
            For Each dproductNode In dproductNodes
                dbaseDataNodes = dproductNode.ChildNodes
                Dim i As Integer = 1

                For Each dbaseDataNode As XmlNode In dbaseDataNodes
                    If Not objIview.ColFld Is Nothing Then
                        Dim indx = objIview.ColFld.IndexOf(dbaseDataNode.Name)
                        If indx > -1 Then
                            AlignStr = objIview.ColAlign(indx).ToString()
                        End If
                    End If
                    Dim strCellText As String = String.Empty
                    If dbaseDataNode.Name = "rowno" Then
                        If ivtype = "listview" Or ivtype = "lview" Then
                            strCellText = dbaseDataNode.InnerText.ToString()
                            strCellText = util.ReplaceTextAreaChars(strCellText, "pdf")
                            Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(strCellText, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                            cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                            If Not htab Is Nothing Then
                                htab.AddCell(cellAttribute)
                            End If
                        Else
                            Continue For
                        End If

                    Else
                        strCellText = dbaseDataNode.InnerText.ToString()
                        strCellText = util.ReplaceTextAreaChars(strCellText, "pdf")
                        Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(strCellText, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                        AlignCell(cellAttribute, AlignStr)
                        If Not htab Is Nothing Then
                            htab.AddCell(cellAttribute)
                        End If
                    End If
                    i = i + 1
                Next
                For i = i To tmpColCount
                    If Not htab Is Nothing Then
                        htab.AddCell(New iTextSharp.text.Cell(New Paragraph("", FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F)))))
                    End If
                Next
            Next

            Dim arrParamCaption As New ArrayList
            Dim arrParamIsHidden As New ArrayList
            If Session("paramDetails") <> Nothing Then
                Dim strParamdetails = Session("paramDetails").ToString()
                Dim arrParamDet As Array
                arrParamDet = strParamdetails.Split("~")
                Dim arrTemp As Array
                Dim i As Integer
                For i = 0 To arrParamDet.Length - 1
                    If (arrParamDet(i).ToString() <> String.Empty) Then
                        arrTemp = arrParamDet(i).ToString().Split(",")
                        arrParamCaption.Insert(i, arrTemp(0).ToString())
                        arrParamIsHidden.Insert(i, arrTemp(1).ToString())
                    ElseIf (arrParamDet(i).ToString() = String.Empty) Then
                        arrParamCaption.Insert(i, "")
                        arrParamIsHidden.Insert(i, "")
                    End If
                Next
            End If


            'for adding the header in the PDF
            Dim Hdrtab As iTextSharp.text.Table
            Hdrtab = New iTextSharp.text.Table(1)
            Hdrtab.WidthPercentage = 100
            Hdrtab.TableFitsPage = True
            Hdrtab.Border = 0
            Hdrtab.Cellspacing = 1
            Hdrtab.Cellpadding = 1

            If Session("AxShowAppTitle") <> Nothing And Session("AxShowAppTitle").ToString().ToLower() = "true" Then
                Dim headerText As String = ""
                If Session("AxAppTitle") <> Nothing AndAlso Session("AxAppTitle") <> String.Empty Then
                    headerText = Session("AxAppTitle").ToString()
                ElseIf Session("projTitle") <> Nothing Then
                    headerText = Session("projTitle").ToString()
                End If

                If headerText <> String.Empty Then
                    Dim cellCapAttribute As Cell = New Cell(New Paragraph(headerText, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                    cellCapAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                    Hdrtab.AddCell(cellCapAttribute)
                End If
            End If

            'If Not iViewCap Is Nothing And iViewCap <> String.Empty Then
            '    Dim cellCapAttribute As Cell = New Cell(New Paragraph(iViewCap, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
            '    cellCapAttribute.HorizontalAlignment = Element.ALIGN_CENTER
            '    Hdrtab.AddCell(cellCapAttribute)
            'End If

            If objIview.ReportHdrs.Count > 0 Then
                Dim iv As Integer
                For iv = 0 To objIview.ReportHdrs.Count - 1 Step 1
                    Dim cellAttribute As Cell = New Cell(New Phrase(objIview.ReportHdrs(iv).ToString(), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                    cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                    Hdrtab.AddCell(cellAttribute)
                Next
            ElseIf Not iViewCap Is Nothing And iViewCap <> String.Empty Then
                Dim cellCapAttribute As Cell = New Cell(New Paragraph(iViewCap, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                cellCapAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                Hdrtab.AddCell(cellCapAttribute)
            End If

            'Add the parameters after the header

            Dim j As Integer
            Dim cnt As Integer = 0
            Dim paramStr As String = String.Empty
            For j = 0 To arrLstParams.Count - 1
                If (arrParamIsHidden(j) = "false") Then
                    paramStr &= arrParamCaption(j) & " - " & arrLstParamVal(j) + "    "
                    cnt = cnt + 1
                End If
                If (cnt = 2) Or j = arrLstParams.Count Then
                    Dim cellAttribute As Cell = New Cell(New Paragraph(paramStr, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                    cellAttribute.HorizontalAlignment = Element.ALIGN_LEFT
                    Hdrtab.AddCell(cellAttribute)
                    cnt = 0
                    paramStr = ""
                End If
                Dim lastRow As Integer = arrLstParams.Count
                If lastRow = j + 1 Then
                    If lastRow Mod 2 <> 0 Then
                        Dim cellAttribute As Cell = New Cell(New Paragraph(paramStr, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                        cellAttribute.HorizontalAlignment = Element.ALIGN_LEFT
                        Hdrtab.AddCell(cellAttribute)
                    End If
                End If
            Next
            If Not htab Is Nothing Then
                Hdrtab.InsertTable(htab)
            End If
            If objIview.ReportFtrs.Count > 0 Then
                Dim iv As Integer
                For iv = 0 To objIview.ReportFtrs.Count - 1 Step 1
                    Dim cellAttribute As Cell = New Cell(New Phrase(objIview.ReportFtrs(iv).ToString(), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                    cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                    Hdrtab.AddCell(cellAttribute)
                Next
            End If

            Dim ScriptsPath As String = HttpContext.Current.Application("ScriptsPath")
            'Create a Folder
            ScriptsPath += "Axpert\"
            Dim di As DirectoryInfo = New DirectoryInfo(ScriptsPath & sid)
            '' Determine whether the directory exists.
            If di.Exists Then

            Else
                ' create the directory.
                di.Create()
            End If

            Dim strPath As String
            Dim mydocument As iTextSharp.text.Document
            mydocument = New iTextSharp.text.Document
            strPath = HttpContext.Current.Application("ScriptsPath").ToString()
            strPath = strPath & "Axpert\" & sid & "\view.pdf"
            PdfWriter.GetInstance(mydocument, New FileStream(strPath, FileMode.Create))
            mydocument.Open()
            mydocument.Add(Hdrtab)
            mydocument.Close()
            Return strPath
        End If
        Return ""
    End Function


    Private Function GetHtml() As String
        Dim isGrandTotal As Boolean = False
        Dim isList As String
        If ivtype = "listview" Or ivtype = "lview" Then
            isList = "true"
        Else
            isList = "false"
        End If
        GetParam(paramVal)
        Dim fileName As String = "GetLView" & iname
        Dim errorLog As String = logobj.CreateLog("GetLView.", sid, fileName, "new")

        Dim sortCol As String = String.Empty
        Dim sortOrd As String = String.Empty
        Dim filterCol As String = String.Empty
        Dim filterColVal As String = String.Empty
        Dim filterValue1 As String = String.Empty
        Dim filterOpr As String = String.Empty

        If Session("sOrder") <> Nothing Then
            If Session("sOrder").ToString() <> "" Then
                sortOrd = Session("sOrder").ToString()
            End If
        End If

        If Session("sColumn") <> Nothing Then
            If Session("sColumn").ToString() <> "" Then
                sortCol = Session("sColumn").ToString()
            End If
        End If

        If Session("fcolopr") <> Nothing Then
            If Session("fcolopr").ToString() <> "" Then
                filterOpr = Session("fcolopr").ToString()
            End If
        End If

        If Session("fCol") <> Nothing Then
            If Session("fCol").ToString() <> "" Then
                filterCol = Session("fCol").ToString()
            End If
        End If

        If Session("fColVal") <> Nothing Then
            If Session("fColVal").ToString() <> "" Then
                filterColVal = Session("fColVal").ToString()
            End If
        End If

        If Session("fColVal2") <> Nothing Then
            If Session("fColVal2").ToString() <> "" Then
                filterValue1 = Session("fColVal2").ToString()
            End If
        End If

        Dim custXML As String = ""
        If isList = "true" Then
            'if custom view is selected then passing custom view name in the input xml
            Try
                If Not objIview.CustomView Is String.Empty Then
                    custXML = " custviewname =""" & objIview.CustomView & """"
                    'custviewname="testing1"
                End If
            Catch ex As Exception
            End Try
        End If

        Dim iXml As String = String.Empty
        iXml = "<root name =""" & iname & """" & custXML & " axpapp=""" & proj & """ sessionid= """ & sid & """ appsessionkey=" & Chr(34) & Session("AppSessionKey").ToString() & Chr(34) & " username=" & Chr(34) & Session("username").ToString() & Chr(34) & " trace=" & Chr(34) & errorLog & Chr(34) & " pageno=""0"" firsttime=""yes"" sorder=""" & sortOrd & """ scol=""" & sortCol & """ fcolopr=""" + filterOpr + """ fcolnm=""" & filterCol & """ fcolval1=""" + filterColVal + """ fcolval2=""" + filterValue1 + """  pforms=""true""><params> "
        iXml = iXml & paramXml
        iXml = iXml & "</params>"
        iXml &= Session("axApps").ToString() + Application("axProps").ToString() + Session("axGlobalVars").ToString() + Session("axUserVars").ToString() & "</root>"
        Dim ires As String = String.Empty
        If isFromHome Then
            objIview = New IviewData()
            objIview.IsDirectDBcall = False
            objIview.FilterXml = ""
            objIview.colFld = New ArrayList
            objIview.ColNoPrint = New ArrayList
            objIview.HiddenCols = New ArrayList
            objIview.ShowHiddengridCols = New ArrayList
            objIview.ReportHdrs = New ArrayList
            objIview.ReportFtrs = New ArrayList
            objIview.ColHide = New ArrayList
            objIview.HeadName = New ArrayList
        End If
        objIview.FilterXml = ""
        If objIview.IsDirectDBcall = True Then
            Dim ds As DataSet = New DataSet()
            Dim objdb As DBContext = New DBContext()
            ds = objdb.GetIviewDataDB(objIview.SqlQuery, 0, 0, objIview.IsGrandTotal)
            Dim gridPageSize As Integer
            If ds.Tables.Count > 0 And ds.Tables(0).Rows.Count > 0 Then
                gridPageSize = ds.Tables(0).Rows.Count
            End If
            ds = objIview.ApplySubTotal(ds, True, gridPageSize)
            Return DataTable2StringHTML(ds.Tables(0))
        Else
            'Call service
            Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()
            Dim resultTable As System.Data.DataTable = New System.Data.DataTable()
            If ivtype = "listview" Or ivtype = "lview" Then
                If objIview.FilterXml Is String.Empty Then                 'Checking for filtering in listview

                    ires = objWebServiceExt.CallGetLViewWS(iname, iXml, objIview.WebServiceTimeout)
                Else
                    If objIview.Listres IsNot Nothing Then
                        listres = objIview.Listres
                    End If
                    ires = objIview.FilterXml.ToString()
                    Dim index As Integer = -1
                    index = ires.IndexOf(">")
                    ires = ires.Insert(index + 1, listres)
                End If
            Else
                If Session("FilteredData") Is Nothing Then
                    objIview.requestJSON = False
                    ires = objWebServiceExt.CallGetIViewWS(iname, iXml, "", objIview)
                    If ires IsNot Nothing Then
                        ires = ires.Split("♠")(1)
                    End If
                    Dim xmlDoc As New XmlDocument
                    Dim compCheckPerf As XmlNode
                    xmlDoc.LoadXml(ires)
                    compCheckPerf = xmlDoc.SelectSingleNode("//data")
                    If Not compCheckPerf.Attributes("perfxml") Is Nothing Then
                    End If

                Else
                    Dim dt As System.Data.DataTable = New System.Data.DataTable()
                    dt = CType(Session("FilteredData"), System.Data.DataTable)

                    Dim res As String = Session("res")
                    ires = ConvertDatatableToXML(dt)
                    Dim index As Integer = -1
                    index = ires.IndexOf(">")
                    ires = ires.Insert(index + 1, res)

                End If

            End If
        End If

        If Mid(ires, 1, 7) <> Constants.ERROR Then
            ires = _xmlString & ires
            Dim xmlDoc As New XmlDocument
            xmlDoc.LoadXml(ires)
            Dim compNodes As XmlNodeList
            Dim compNode As XmlNode
            Dim cbaseDataNodes As XmlNodeList
            compNodes = xmlDoc.SelectNodes("//data/comps")
            For Each compNode In compNodes
                cbaseDataNodes = compNode.ChildNodes
                Dim cnt1 As Integer
                cnt1 = 0
                Dim compNodeCnt As Integer = 0
                Dim ToolbarBtnCnt As Integer
                ToolbarBtnCnt = cbaseDataNodes.Count - 1
                For compNodeCnt = ToolbarBtnCnt To 0 Step -1
                    If Mid(cbaseDataNodes(compNodeCnt).Name, 1, 7) = "x__head" Then
                        caption = (cbaseDataNodes(compNodeCnt).Attributes("caption").Value)
                        Exit For
                    ElseIf Mid(cbaseDataNodes(compNodeCnt).Name, 1, 3) = "lbl" Then
                        ivhead.Add(cbaseDataNodes(compNodeCnt).Attributes("caption").Value)
                    End If
                Next
            Next
            pivotGroupHeaderNames.Clear()
            pivotStartCol.Clear()
            pivotEndCol.Clear()

            Dim productNodes As XmlNodeList
            Dim productNode As XmlNode
            Dim baseDataNodes As XmlNodeList
            productNodes = xmlDoc.SelectNodes("//headrow")
            Dim hcolNos As Integer
            hcolNos = 0
            Dim arrNumericFld As New ArrayList
            Dim checkRownofld As Boolean = False
            If objIview.colFld.Count > 0 Then
                If objIview.colFld(0) = "rowno" And isperf = "true" Then
                    colHide.Add("false")
                    checkRownofld = True
                    colFld.Add("rowno")
                End If
            End If
            For Each productNode In productNodes
                baseDataNodes = productNode.ChildNodes
                Dim iCount As Integer = -1
                For Each baseDataNode As XmlNode In baseDataNodes
                    iCount += 1
                    If baseDataNode.Name <> "rowno" Then
                        colFld.Add(baseDataNode.Name)
                        colHead.Add(baseDataNode.InnerText)
                    End If
                    If baseDataNode.Name = "rowno" Then
                        'colHide.Add("false")
                        'checkRownofld = True
                    Else
                        If baseDataNode.Name.StartsWith("html_") Then
                            htmlColumns.Add(baseDataNode.Name)
                        End If
                        If Not baseDataNode.Attributes("type") Is Nothing Then
                            If baseDataNode.Attributes("type").Value = "n" Then
                                arrNumericFld.Add(baseDataNode.Name)
                            End If
                        End If
                        If Not baseDataNode.Attributes("hide") Is Nothing Then
                            If baseDataNode.Name.StartsWith("hide_") Then
                                colHide.Add("true")
                            ElseIf ivtype <> "listview" And ivtype <> "lview" Then
                                If objIview.ColNoPrint.Count > iCount Then
                                    If objIview.ColNoPrint(iCount) = True Then
                                        colHide.Add("true")
                                    Else
                                        colHide.Add(baseDataNode.Attributes("hide").Value)
                                    End If
                                Else
                                    colHide.Add(baseDataNode.Attributes("hide").Value)
                                End If
                            ElseIf (objIview.HiddenCols.IndexOf(baseDataNode.Name) > -1) Then
                                colHide.Add("true")
                            ElseIf (objIview.ShowHiddengridCols) IsNot Nothing Then
                                If (objIview.ShowHiddengridCols.IndexOf(baseDataNode.Name) > -1) Then
                                    colHide.Add("false")
                                Else
                                    colHide.Add(baseDataNode.Attributes("hide").Value)
                                End If
                            Else
                                colHide.Add(baseDataNode.Attributes("hide").Value)
                            End If
                        End If
                        If baseDataNode.Name = "pivotghead" Then
                            Dim finalNodelist As XmlNodeList
                            For Each base2node As XmlNode In baseDataNode
                                finalNodelist = base2node.ChildNodes
                                For Each finalNode As XmlNode In finalNodelist
                                    If finalNode.Name = "sn" Then
                                        pivotStartCol.Add(finalNode.InnerText)
                                    ElseIf finalNode.Name = "ghead" Then
                                        pivotGroupHeaderNames.Add(finalNode.InnerText)
                                    ElseIf finalNode.Name = "en" Then
                                        pivotEndCol.Add(finalNode.InnerText)
                                    End If
                                Next
                            Next
                            colHide.Add("true")
                        End If
                        hcolNos = hcolNos + 1
                    End If
                Next
            Next

            Dim htIdx = 0
            Dim cIdx = 0
            For htIdx = 0 To htmlColumns.Count - 1
                For cIdx = 0 To colFld.Count - 1
                    Dim htmlColName As String = htmlColumns(htIdx)
                    If colFld(cIdx) = htmlColName Then
                        colHide(cIdx) = "false"
                    ElseIf colFld(cIdx) = htmlColName.Replace("html_", "") Then
                        colHide(cIdx) = "true"
                    End If
                Next
            Next
            'to hide column if col is hidden and to hide html_col and if html_col is hidden to hide col.
            If (objIview.HiddenCols.Count > 0) Then
                Dim hdncol = 0
                Dim hdnColumnName As String
                For hdncol = 0 To objIview.HiddenCols.Count - 1
                    hdnColumnName = objIview.HiddenCols(hdncol)
                    ''to hide the column which are hidden in hide columns
                    If (colFld.IndexOf(hdnColumnName) > -1) Then
                        colHide(colFld.IndexOf(hdnColumnName)) = "true"
                    End If
                    If (hdnColumnName.StartsWith("html_")) Then
                        hdnColumnName = hdnColumnName.Replace("html_", "")
                    Else
                        hdnColumnName = "html_" + hdnColumnName
                    End If
                    ''to hide the column after changing the column name 
                    If (colFld.IndexOf(hdnColumnName) > -1) Then
                        colHide(colFld.IndexOf(hdnColumnName)) = "true"
                    End If
                Next
            End If

            'to remove attributes from headrow
            Dim productNodes2 As XmlNodeList
            Dim productNode2 As XmlNode
            Dim baseDataNodes2 As XmlNodeList
            productNodes2 = xmlDoc.SelectNodes("//headrow")
            For Each productNode2 In productNodes2
                baseDataNodes2 = productNode2.ChildNodes
                For Each baseDataNode2 As XmlNode In baseDataNodes2
                    baseDataNode2.Attributes.RemoveAll()
                Next
            Next

            'Remove Comps
            Dim cNode As XmlNode
            cNode = xmlDoc.SelectSingleNode("//comps")
            cNode.ParentNode.RemoveChild(cNode)

            'add Header to xmldoc
            'remove hidden fields in headrow
            Dim hrep As Integer
            'change  later try new code to remove this for
            For hrep = 1 To hcolNos
                Dim productNodes3 As XmlNodeList
                Dim productNode3 As XmlNode
                Dim baseDataNodes3 As XmlNodeList
                productNodes3 = xmlDoc.SelectNodes("//headrow")
                Dim hidx As Integer
                For Each productNode3 In productNodes3
                    baseDataNodes3 = productNode3.ChildNodes
                    For Each baseDataNode3 As XmlNode In baseDataNodes3
                        For hidx = 0 To colFld.Count - 1
                            If colFld(hidx).ToString().ToLower() = baseDataNode3.Name.ToLower() Then
                                If colHide(hidx) = "true" Then
                                    baseDataNode3.ParentNode.RemoveChild(baseDataNode3)
                                End If
                            End If
                        Next
                    Next
                Next
            Next

            'remove hidden fields
            Dim rep As Integer
            'change  later try new code to remove this for
            For rep = 1 To hcolNos

                Dim productNodes1 As XmlNodeList
                Dim productNode1 As XmlNode
                Dim baseDataNodes1 As XmlNodeList
                productNodes1 = xmlDoc.SelectNodes("//row")
                Dim idx As Integer
                For Each productNode1 In productNodes1
                    baseDataNodes1 = productNode1.ChildNodes
                    For Each baseDataNode1 As XmlNode In baseDataNodes1
                        For idx = 0 To colFld.Count - 1
                            If colFld(idx).ToString().ToLower() = baseDataNode1.Name.ToLower() Then
                                If colHide(idx) = "true" And colFld(idx) <> "axrowtype" Then
                                    baseDataNode1.ParentNode.RemoveChild(baseDataNode1)
                                End If
                            End If
                        Next
                    Next
                Next
            Next

            sb.Append("<html>")
            sb.Append("<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>")
            If isPrint = "true" Then
                'sb.Append("<head><title>" & caption & "</title>")
                sb.Append("<head><title>&nbsp;</title>")
            Else
                'sb.Append("<head><title>HTML</title>")
                sb.Append("<head><title>&nbsp;</title>")
            End If

            sb.Append("<link href='../Css/htmlfont.css' rel='stylesheet' type='text/css' /></head>")
            Dim direction As String = "ltr"
            If (Session("language").ToString().ToUpper() = "ARABIC") Then
                direction = "rtl"
            End If

            sb.Append("<body dir=" + direction + ">")
            If Session("AxShowAppTitle") <> Nothing And Session("AxShowAppTitle").ToString().ToLower() = "true" Then
                'Create Heading/Title of the page
                sb.Append("<div style='width:100%;align:left;border:solid 0px #497D9E;' class='container3'>")
                sb.Append("<b class='rtop3'><b class='r1'></b><b class='r2'></b><b class='r3'></b><b class='r4'></b></b>")
                sb.Append("<table width='100%' class='tblhead'>")

                If Session("AxAppTitle") <> Nothing AndAlso Session("AxAppTitle") <> String.Empty Then
                    sb.Append("<tr><td class='tdarrow'><center><font style='font-size : 16px;'>" & Session("AxAppTitle").ToString() & "</font></center></td></tr>")
                ElseIf Session("projTitle") <> Nothing Then
                    sb.Append("<tr><td class='tdarrow'><center><font style='font-size : 16px;'>" & Session("projTitle").ToString() & "</font></center></td></tr>")
                End If

                sb.Append("</table></div>")
            End If
            sb.Append("<table width='100%' class='tblhead'>")
            'HEADERS
            If objIview.ReportHdrs.count > 0 Then
                Dim indx As Integer = 0
                For indx = 0 To objIview.ReportHdrs.Count - 1 Step 1
                    sb.Append("<tr><td class='tdarrow'><center><font style= " & objIview.ReportHdrStyles(indx).ToString() & ">" & objIview.ReportHdrs(indx).ToString() & "</font></center></td></tr></table></div>")
                Next
            End If
            'Else
            'create paramaters
            Dim arrParamCaption As New ArrayList
            Dim arrParamIsHidden As New ArrayList
            If Session("paramDetails") <> Nothing Then
                Dim strParamdetails = Session("paramDetails").ToString()
                Dim arrParamDet As Array
                arrParamDet = strParamdetails.Split("~")
                Dim arrTemp As Array
                Dim i As Integer
                For i = 0 To arrParamDet.Length - 1
                    If (arrParamDet(i).ToString() <> String.Empty) Then
                        arrTemp = arrParamDet(i).ToString().Split(",")
                        arrParamCaption.Insert(i, arrTemp(0).ToString())
                        arrParamIsHidden.Insert(i, arrTemp(1).ToString())
                    ElseIf (arrParamDet(i).ToString() = String.Empty) Then
                        arrParamCaption.Insert(i, "")
                        arrParamIsHidden.Insert(i, "")
                    End If
                Next
            End If

            Dim paramCnt As Integer
            Dim cnt As Integer = 0
            Dim paramStr As String = String.Empty
            For paramCnt = 0 To arrLstParams.Count - 1
                If (arrParamIsHidden(paramCnt) = "false") Then
                    paramStr &= arrParamCaption(paramCnt) & " - " & arrLstParamVal(paramCnt) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                    cnt = cnt + 1
                End If
                If (cnt = 2) Or paramCnt = arrLstParams.Count Then
                    sb.Append("<div style='width:100%;align:left;border:solid 0px #497D9E;'>")
                    sb.Append("<font style='font-size : 16px; FONT-weight:normal;COLOR:#2F3E53'>" & paramStr & "</font></div>")
                    cnt = 0
                    paramStr = ""
                End If
                Dim lastRow As Integer = arrLstParams.Count
                If lastRow = paramCnt + 1 Then
                    If lastRow Mod 2 <> 0 Then
                        sb.Append("<div style='width:100%;align:left;border:solid 0px #497D9E;'>")
                        sb.Append("<font style='font-size : 16px; FONT-weight:normal;COLOR:#2F3E53'>" & paramStr & "</font></div>")
                    End If
                End If
            Next

            'Adding Filter string
            If objIview.FilterText <> String.Empty Then
                sb.Append("<div style='width:100%;align:center;'>")
                sb.Append("<center><font style='font-size : 12px; FONT-weight:normal;COLOR:#808080'> " & objIview.FilterText & "</font></center></div>")
            End If

            sb.Append("<br/>")
            'create pivot headers
            Dim pivotRow As String = String.Empty
            If pivotGroupHeaderNames.Count > 1 Then
                pivotRow = "<tr bgcolor=#ffffff>"
            End If

            Dim inc As Integer
            Dim val As String
            Dim colSpan As Integer
            For inc = 0 To pivotGroupHeaderNames.Count - 1
                colSpan = CInt(pivotEndCol(inc).ToString) - CInt(pivotStartCol(inc).ToString)
                val = pivotGroupHeaderNames(inc).ToString() & "," & colSpan & "," & 1
                pivotRow += "<td colspan=""" & colSpan & """><center><font color=black ><b>" & pivotGroupHeaderNames(inc).ToString() & "</b></font></center></td>"
            Next
            If pivotRow <> "" Then
                pivotRow += "</tr>"
            End If
            ' Create Table and Column Headers 
            sb.Append("<table id='tblhtmlPrint'cellpadding=0 cellspacing=0 border='1px solid #c4c4c4' width=90% style=""font-size: 14px;border-color: #f0f0f0;"">")
            sb.Append(pivotRow)
            sb.Append("<tr bgcolor=#ffffff>")
            Dim hproductNodes As XmlNodeList
            Dim hproductNode As XmlNode
            Dim hbaseDataNodes As XmlNodeList
            Dim tmpColCount As Integer = 0
            Dim hn As String = ""
            Dim slnoIndex As Integer = -1
            Dim AlignStr As String = String.Empty
            hproductNodes = xmlDoc.SelectNodes("/data/headrow")
            For Each hproductNode In hproductNodes
                hbaseDataNodes = hproductNode.ChildNodes
                tmpColCount = hbaseDataNodes.Count
                For Each hbaseDataNode As XmlNode In hbaseDataNodes

                    If hbaseDataNode.InnerText = "axp_slno" Then
                        hn = "Sr. No."
                        slnoIndex = 1
                    Else
                        hn = hbaseDataNode.InnerText
                    End If

                    If (hn.IndexOf("~") <> "-1") Then
                        hn = hn.Replace("~", "<br/>")
                    End If

                    If hbaseDataNode.Name <> "rowno" Then
                        sb.Append("<td><center><font color=black ><b>")
                        sb.Append(hn)
                        sb.Append("</b></font></center></td>")
                    Else
                        If ivtype = "listview" Or ivtype = "lview" Then
                            sb.Append("<td><center><font color=black ><b>")
                            sb.Append("Sr. No.")
                            sb.Append("</b></font></center></td>")
                        End If
                    End If

                Next
            Next
            sb.Append("</tr>")

            Dim oddrowclr As String
            Dim evenrowclr As String
            oddrowclr = "white"
            evenrowclr = "white"
            Dim rowno As Integer
            rowno = 1
            If checkRownofld = True Then
                tmpColCount = tmpColCount - 1
            End If
            ' Get Data
            Dim dproductNodes As XmlNodeList
            Dim dproductNode As XmlNode
            Dim dbaseDataNodes As XmlNodeList

            dproductNodes = xmlDoc.SelectNodes("/data/row")
            Dim addGrandTotal As Boolean = False
            For Each dproductNode In dproductNodes
                dbaseDataNodes = dproductNode.ChildNodes
                Dim i As Integer
                Dim trColor As String = ""

                For i = 0 To dbaseDataNodes.Count - 1
                    If dbaseDataNodes(1) IsNot Nothing Then
                        If dbaseDataNodes(1).InnerText = "subhead" Then
                            trColor = "color:DarkRed;font-weight:bold;"
                            dbaseDataNodes(1).ParentNode.RemoveChild(dbaseDataNodes(1))
                            Exit For
                        ElseIf dbaseDataNodes(1).InnerText = "gtot" Then
                            trColor = "color:DarkGreen;font-weight:bold;"
                            dbaseDataNodes(1).ParentNode.RemoveChild(dbaseDataNodes(1))
                            Exit For
                        ElseIf dbaseDataNodes(1).InnerText = "stot" Then
                            trColor = "color:DarkRed;font-weight:bold;"
                            dbaseDataNodes(1).ParentNode.RemoveChild(dbaseDataNodes(1))
                            Exit For
                        Else
                            If objIview.IsPerfXml IsNot Nothing Then
                                If (Not objIview.IsPerfXml) Then
                                    dbaseDataNodes(1).ParentNode.RemoveChild(dbaseDataNodes(1))
                                    Exit For
                                End If
                            End If
                        End If
                    End If

                Next
                If rowno Mod 2 = 0 Then
                    sb.Append("<tr bgcolor=" & evenrowclr & " style=""" & trColor & " border-color: #f0f0f0;"">")
                Else
                    sb.Append("<tr bgcolor=" & oddrowclr & " style=""" & trColor & " border-color: #f0f0f0;"">")
                End If
                Dim k As Integer = 1
                Dim isFirstCol As Integer = 0

                For Each dbaseDataNode As XmlNode In dbaseDataNodes
                    Dim indxLoc = objIview.ColFld.IndexOf(dbaseDataNode.Name.ToLower())
                    If indxLoc > -1 Then
                        AlignStr = objIview.ColAlign(indxLoc).ToString()
                        If AlignStr = "" Then
                            AlignStr = "left"
                        End If
                        If (Session("language").ToString().ToUpper() = "ARABIC") Then
                            AlignStr = "right"
                        End If
                    End If
                    If dbaseDataNode.Name = "rowno" Then
                        If ivtype = "listview" Or ivtype = "lview" Then
                            sb.Append("<td style=""text-align:center; vertical-align :top"">")
                            sb.Append(dbaseDataNode.InnerText)
                            sb.Append("</td>")
                        Else
                            Continue For
                        End If
                    Else
                        If addGrandTotal And dbaseDataNode.InnerText = "" And isFirstCol <> 0 And slnoIndex <> -1 Then
                            dbaseDataNode.InnerText = "Grand Total"
                        End If

                        If isFirstCol = 0 And slnoIndex <> -1 Then
                            sb.Append("<td style=""vertical-align:top; text-align:" & AlignStr & """>")
                        Else
                            sb.Append("<td style=""vertical-align:top; text-align:" & AlignStr & """>")
                        End If
                        If dbaseDataNode.InnerText = "Grand Total" And slnoIndex <> -1 Then
                            addGrandTotal = True
                            dbaseDataNode.InnerText = ""
                        Else
                            sb.Append(dbaseDataNode.InnerText)
                            sb.Append("</td>")
                        End If

                    End If
                    k = k + 1
                    isFirstCol = isFirstCol + 1
                    ' End If
                Next
                sb.Append("</tr>")
                rowno = rowno + 1
            Next
            'Commenting rowMerge since it was causing uneasy UI
            'sb.Append("</table><script>rowMerge();</script>")
            sb.Append("</table>")


            'FOOTERS
            If objIview.ReportFtrs.Count > 0 Then
                Dim indx As Integer
                For indx = 0 To objIview.ReportFtrs.Count - 1 Step 1
                    sb.Append("<div style='width:100%;align:center;'>")
                    sb.Append("<center><font " & objIview.ReportFtrStyles(indx).ToString() & ">" & objIview.ReportFtrs(indx).ToString() & "</font></center></div>")
                Next
            End If

            sb.Append("</body>")
            sb.Append("</html>")
            Return sb.ToString()
        Else
            Return "IView Result Error"
        End If
    End Function


    Public Function DataTable2StringHTML(dataTable As System.Data.DataTable) As String
        Dim sb As New StringBuilder()
        If dataTable IsNot Nothing Then

            sb.Append("<meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>")
            sb.Append("<html>")
            If isPrint = "true" Then
                'sb.Append("<head><title>" & objIview.IviewCaption & "</title>")
                sb.Append("<head><title>&nbsp;</title>")
            Else
                'sb.Append("<head><title>HTML</title>")
                sb.Append("<head><title>&nbsp;</title>")
            End If

            If isPrint = "true" Then
                sb.Append("<script type='text/javascript' language='javascript'>")
                sb.Append("window.onload=function(){ setTimeout('printIt()',1000); };")
                sb.Append("function printIt(){window.print();}")
                sb.Append("</script>")
            End If

            sb.Append("<script src=""../Js/thirdparty/jquery/3.1.1/jquery.min.js""></script><script src='../Js/HtmlPrint.js'></script></head>")
            Dim direction As String = "ltr"
            If (Session("language").ToString().ToUpper() = "ARABIC") Then
                direction = "rtl"
            End If
            sb.Append("<body dir=" + direction + ">")
            'Create Heading/Title of the page
            sb.Append("<div style='width:100%;align:left;border:solid 0px #497D9E;' class='container3'>")
            sb.Append("<b class='rtop3'><b class='r1'></b><b class='r2'></b><b class='r3'></b><b class='r4'></b></b>")
            sb.Append("<table width='100%' class='tblhead'>")
            If Session("projtitle") IsNot Nothing Then
                sb.Append("<tr><td class='tdarrow'><center><font style='font-size : 22.5px; FONT-weight:normal;COLOR:#808080'>" & Session("projtitle").ToString() & "</font></center></td></tr></table></div>")
            End If
            sb.Append("<tr><td class='tdarrow'><center><font style='font-size : 22.5px; FONT-weight:normal;COLOR:#808080'>" & objIview.IviewCaption & "</font></center></td></tr></table></div>")

            sb.Append("<table width='100%' class='tblhead'>")
            If objIview.ReportHdrs.count > 0 Then
                Dim indx As Integer = 0
                For indx = 0 To objIview.ReportHdrs.Count - 1 Step 1
                    sb.Append("<tr><td class='tdarrow'><center><font style= " & objIview.ReportHdrStyles(indx).ToString() & ">" & objIview.ReportHdrs(indx).ToString() & "</font></center></td></tr>")
                Next
            End If
            sb.Append("</table>")

            sb.Append("<table id='tblhtmlPrint'cellpadding=0 cellspacing=0 border='1px solid #c4c4c4' width=90% style=""font-size: 12px;border-color: #f0f0f0;"">")
            sb.Append("<tr bgcolor=#ffffff>")
            For Each col As DataColumn In dataTable.Columns
                If objIview.ColHide(col.Ordinal) = False And objIview.ColNoPrint(col.Ordinal) = False Then
                    sb.Append("<th>")
                    sb.Append(objIview.HeadName(col.Ordinal))
                    'sb.Append(col.ColumnName)
                    sb.Append("</th>")
                End If
            Next
            sb.Append("</tr>")

            For Each row As DataRow In dataTable.Rows
                sb.Append("<tr>")
                For Each column As DataColumn In dataTable.Columns
                    If objIview.ColHide(column.Ordinal) = False And objIview.ColNoPrint(column.Ordinal) = False Then
                        sb.Append("<td>")
                        sb.Append(row(column.ColumnName))
                        sb.Append("</td>")
                    End If
                Next
                sb.Append("</tr>")
            Next
            sb.Append("</table>")

            sb.Append("</table><script>rowMerge();</script>")

            'FOOTERS
            If objIview.ReportFtrs.Count > 0 Then
                Dim indx As Integer
                For indx = 0 To objIview.ReportFtrs.Count - 1 Step 1
                    sb.Append("<div style='width:100%;align:center;'>")
                    sb.Append("<center><font " & objIview.ReportFtrStyles(indx).ToString() & ">" & objIview.ReportFtrs(indx).ToString() & "</font></center></div>")
                Next
            End If

            sb.Append("</body>")
            sb.Append("</html>")
        Else
            Return "IView Result Error"
        End If
        Return sb.ToString()
    End Function


    Public Function DataTable2String(dataTable As System.Data.DataTable) As String


        Dim viscols As Integer
        viscols = 0
        Dim g As Integer
        If ivtype = "listview" Or ivtype = "lview" Then
            For g = 0 To objIview.ColHide.Count - 1
                If objIview.ColHide(g) = "false" And objIview.ColNoPrint(g) = "false" Then
                    viscols = viscols + 1
                End If
            Next
        Else
            For g = 1 To objIview.ColHide.Count - 1
                If objIview.ColHide(g) = "false" And objIview.ColNoPrint(g) = "false" Then
                    viscols = viscols + 1
                End If
            Next
        End If
        Dim htab As iTextSharp.text.Table
        htab = New iTextSharp.text.Table(viscols)
        htab.WidthPercentage = 100
        htab.Border = 1
        htab.Cellspacing = 1
        htab.Cellpadding = 1

        Dim AlignStr As String = String.Empty
        For Each column As DataColumn In dataTable.Columns
            If objIview.ColHide(column.Ordinal) = False And objIview.ColNoPrint(column.Ordinal) = False Then
                Dim indx = objIview.ColFld.IndexOf(column.ColumnName.ToLower())
                If indx > -1 Then
                    AlignStr = objIview.ColAlign(indx).ToString()
                End If
                If column.ColumnName.ToLower = "rowno" Then
                    If ivtype = "listview" Or ivtype = "lview" Then
                        Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(column.ColumnName, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                        AlignCell(cellAttribute, AlignStr)
                        htab.AddCell(cellAttribute)
                    Else
                        Continue For
                    End If
                Else
                    Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(column.ColumnName, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                    AlignCell(cellAttribute, AlignStr)
                    htab.AddCell(cellAttribute)
                End If
            End If
        Next

        For Each row As DataRow In dataTable.Rows
            For Each column As DataColumn In dataTable.Columns
                If objIview.ColHide(column.Ordinal) = False And objIview.ColNoPrint(column.Ordinal) = False Then
                    Dim indx = objIview.ColFld.IndexOf(column.ColumnName.ToLower())
                    If indx > -1 Then
                        AlignStr = objIview.ColAlign(indx).ToString()
                    End If
                    If column.ColumnName.ToLower = "rowno" Then
                        If ivtype = "listview" Or ivtype = "lview" Then
                            If row(column).ToString() <> "" Then
                                Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(row(column), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                                AlignCell(cellAttribute, AlignStr)
                                htab.AddCell(cellAttribute)
                            Else
                                Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph("", FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                                AlignCell(cellAttribute, AlignStr)
                                htab.AddCell(cellAttribute)
                            End If
                        Else
                            Continue For
                        End If
                    Else
                        If row(column).ToString() <> "" Then
                            Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph(row(column), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                            AlignCell(cellAttribute, AlignStr)
                            htab.AddCell(cellAttribute)
                        Else
                            Dim cellAttribute As Cell = New iTextSharp.text.Cell(New Paragraph("", FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.NORMAL, New GrayColor(0.1F))))
                            AlignCell(cellAttribute, AlignStr)
                            htab.AddCell(cellAttribute)
                        End If
                    End If
                End If
            Next
        Next

        Dim Hdrtab As iTextSharp.text.Table
        Hdrtab = New iTextSharp.text.Table(1)
        Hdrtab.WidthPercentage = 100
        Hdrtab.TableFitsPage = True
        Hdrtab.Border = 0
        Hdrtab.Cellspacing = 1
        Hdrtab.Cellpadding = 1

        If Session("AxShowAppTitle") <> Nothing And Session("AxShowAppTitle").ToString().ToLower() = "true" Then
            Dim headerText As String = ""
            If Session("AxAppTitle") <> Nothing AndAlso Session("AxAppTitle") <> String.Empty Then
                headerText = Session("AxAppTitle").ToString()
            ElseIf Session("projTitle") <> Nothing Then
                headerText = Session("projTitle").ToString()
            End If

            If headerText <> String.Empty Then
                Dim cellCapAttribute As Cell = New Cell(New Paragraph(headerText, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                cellCapAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                Hdrtab.AddCell(cellCapAttribute)
            End If
        End If

        If Not objIview.IviewCaption Is Nothing And objIview.IviewCaption <> String.Empty Then
            Dim cellCapAttribute As Cell = New Cell(New Paragraph(objIview.IviewCaption, FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
            cellCapAttribute.HorizontalAlignment = Element.ALIGN_CENTER
            Hdrtab.AddCell(cellCapAttribute)
        End If

        If Not objIview.ReportHdrs Is Nothing And objIview.ReportHdrs.Count > 0 Then
            Dim iv As Integer
            For iv = 0 To objIview.ReportHdrs.Count - 1 Step 1
                Dim cellAttribute As Cell = New Cell(New Phrase(objIview.ReportHdrs(iv).ToString(), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                Hdrtab.AddCell(cellAttribute)
            Next
        End If

        Hdrtab.InsertTable(htab)

        If Not objIview.ReportFtrs Is Nothing And objIview.ReportFtrs.Count > 0 Then
            Dim iv As Integer
            For iv = 0 To objIview.ReportFtrs.Count - 1 Step 1
                Dim cellAttribute As Cell = New Cell(New Phrase(objIview.ReportFtrs(iv).ToString(), FontFactory.GetFont(FontFactory.TIMES_ROMAN, 8, iTextSharp.text.Font.BOLD, New GrayColor(0.1F))))
                cellAttribute.HorizontalAlignment = Element.ALIGN_CENTER
                Hdrtab.AddCell(cellAttribute)
            Next
        End If

        Dim ScriptsPath As String = HttpContext.Current.Application("ScriptsPath")
        ScriptsPath += "Axpert\"
        Dim di As DirectoryInfo = New DirectoryInfo(ScriptsPath & sid)
        If di.Exists Then
        Else
            di.Create()
        End If

        Dim strPath As String
        Dim mydocument As iTextSharp.text.Document
        mydocument = New iTextSharp.text.Document
        strPath = HttpContext.Current.Application("ScriptsPath").ToString()
        strPath = strPath & "Axpert\" & sid & "\view.pdf"
        PdfWriter.GetInstance(mydocument, New FileStream(strPath, FileMode.Create))
        mydocument.Open()
        mydocument.Add(Hdrtab)
        mydocument.Close()
        Return strPath
    End Function
End Class
