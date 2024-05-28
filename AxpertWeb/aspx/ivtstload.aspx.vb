Imports System.Xml

Partial Class ivtstload
    Inherits System.Web.UI.Page

    Dim util As New Util.Util()
    Public direction As String = "ltr"
    Public axp_RefreshParent As String
    Dim requestProcess_logtime As String = String.Empty
    Dim ObjExecTr As ExecTrace = ExecTrace.Instance
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim _xmlString As String =
      "<?xml version=""1.0"" encoding=""utf-8"" ?>"
        Dim logobj As LogFile.Log = New LogFile.Log()
        Dim recordid As String = String.Empty
        Dim tid As String = String.Empty
        tid = Request.QueryString("tstname")
        Dim viewNavigationData As String = String.Empty

        If Not (Request.QueryString("hdnbElapsTime") = "") Then
            Dim browserElapsTime = Request.QueryString("hdnbElapsTime")
            requestProcess_logtime += ObjExecTr.WireElapsTime(browserElapsTime)
        End If

        If Not util.IsTransIdValid(tid) Then
            Response.Redirect(Constants.PARAMERR)
        End If

        If Session("project") = "" Then
            Dim url As String
            url = util.SESSEXPIRYPATH
            Response.Write("<script>" & vbCrLf)
            Response.Write("parent.parent.location.href='" & url & "';")
            Response.Write(vbCrLf & "</script>")
        Else
            Dim pNames As New ArrayList()
            Dim pValues As New ArrayList()
            If util.IsValidQueryString(Request.RawUrl, True) = False Then
                Response.Redirect(util.ERRPATH + Constants.INVALIDURL)
            End If
            If Session("language") IsNot Nothing Then
                If Session("language").ToString() = "ARABIC" Then
                    direction = "rtl"
                End If
            End If
            Dim axPop As String = String.Empty
            Dim axSplit As String = String.Empty

            Dim qn As Integer
            Dim openTstAdditionalInfo As String = String.Empty
            For qn = 1 To Request.QueryString.Count - 1 ' eliminate Name fro querystring

                If (Request.QueryString.Keys(qn).ToLower = "refreshparentonclose") Then
                    'ClientScript.RegisterStartupScript([GetType](), "hwa", "eval(callParent('isRefreshParentOnClose') = '" & Request.QueryString.Keys(qn).ToLower & "');", True)
                    ClientScript.RegisterClientScriptBlock([GetType](), "hwa", "setRefreshParent(true);", True)
                End If


                If (Request.QueryString.Keys(qn).ToLower = "axp_refresh") Then
                    axp_RefreshParent = Request.QueryString.Item(qn)

                Else

                    If (Request.QueryString.Keys(qn).ToLower = "recordid") Then
                        recordid = Request.QueryString.Item(qn)
                    ElseIf Request.QueryString.Keys(qn).ToLower = "axpop" Or Request.QueryString.Keys(qn).ToLower = "axsplit" Or Request.QueryString.Keys(qn).ToLower = "recpos" Or Request.QueryString.Keys(qn).ToLower = "pagetype" Or Request.QueryString.Keys(qn).ToLower = "curpage" Or Request.QueryString.Keys(qn).ToLower = "openeriv" Or Request.QueryString.Keys(qn).ToLower = "isiv" Or Request.QueryString.Keys(qn).ToLower = "hdnbelapstime" Then

                        If (Request.QueryString.Keys(qn).ToLower = "axpop" And Request.QueryString.Item(qn) = "true") Then
                            axPop = "&AxPop=true"
                        ElseIf (Request.QueryString.Keys(qn).ToLower = "axsplit" And Request.QueryString.Item(qn) = "true") Then
                            axSplit = "&AxSplit=true"
                        ElseIf (Request.QueryString.Keys(qn).ToLower = "hdnbelapstime") Then
                            Dim hdnbelapstime = Request.QueryString.Keys(qn).ToLower
                        Else
                            viewNavigationData += "&" & Request.QueryString.Keys(qn).ToLower & "=" & Request.QueryString.Item(qn)
                        End If

                        If (Request.QueryString.Keys(qn).ToLower = "openeriv") Then
                            openTstAdditionalInfo += "&" & Request.QueryString.Keys(qn).ToLower & "=" & Request.QueryString.Item(qn)
                        ElseIf (Request.QueryString.Keys(qn).ToLower = "isiv") Then
                            openTstAdditionalInfo += "&" & Request.QueryString.Keys(qn).ToLower & "=" & Request.QueryString.Item(qn)
                        End If


                        Continue For

                    End If


                    pNames.Add(Request.QueryString.Keys(qn))
                    Dim qs = Request.QueryString.Item(qn)
                    If qs.Contains("l%3tC;") Then
                        qs = qs.Replace("l%3tC;", "<")
                    End If
                    pValues.Add(qs)


                End If


            Next

            If Session("project") = "" Then
                Dim url As String
                url = util.SESSEXPIRYPATH
                Response.Write("<script>" & vbCrLf)
                Response.Write("parent.parent.location.href='" & url & "';")
                Response.Write(vbCrLf & "</script>")
            Else
                Dim sXml As String
                Dim user As String
                Dim sid As String

                sXml = ""
                user = Session("user")

                Dim fltype As String = ""
                fltype = pValues(pNames.Count - 2).ToString()

                sid = Session("nsessionid")
                Dim fileName As String = "GetRecordId" & tid
                Dim errorLog As String = logobj.CreateLog("GetRecordId.", sid, fileName, "new")
                Dim getRecXml As String = ""
                Dim paramstring As String = ""
                getRecXml = "<root axpapp=" & Chr(34) & Session("project") & Chr(34) & " sessionid= " & Chr(34) & sid & Chr(34) & " trace=" & Chr(34) & errorLog & Chr(34) & " transid=" & Chr(34) & tid & Chr(34) & " appsessionkey=" & Chr(34) & Session("AppSessionKey").ToString() & Chr(34) & " username=" & Chr(34) & Session("username").ToString() & Chr(34) & "><values>"
                Dim g As Integer
                'TODO: Checkspecialchar is called for parameter name also, needs to be verified if the =is is required or not.
                If fltype = "open" Then
                    If (pNames.Count = 3) Then
                        For g = 0 To pNames.Count - 3
                            pNames(g) = util.CheckUrlSpecialChars(pNames(g).ToString())
                            pValues(g) = util.CheckUrlSpecialChars(pValues(g).ToString())
                            getRecXml = getRecXml & "<" & pNames(g) & ">" & pValues(g) & "</" & pNames(g) & ">"
                            paramstring = paramstring & "&" & pNames(g) & "=" & pValues(g)
                        Next
                        getRecXml = getRecXml & "</values>"
                    Else
                        For g = 0 To pNames.Count - 3
                            pNames(g) = util.CheckUrlSpecialChars(pNames(g).ToString())
                            pValues(g) = util.CheckUrlSpecialChars(pValues(g).ToString())
                            getRecXml = getRecXml & "<" & pNames(g) & ">" & pValues(g) & "</" & pNames(g) & ">"
                            paramstring = paramstring & "&" & pNames(g) & "=" & pValues(g)
                        Next
                        getRecXml = getRecXml & "</values>"
                    End If
                    Session("AxFromHypLink") = "true"
                    If axp_RefreshParent Is Nothing Then
                        Response.Redirect("./tstruct.aspx?act=open&transid=" & tid & paramstring & axPop & axSplit & openTstAdditionalInfo & "&reqProc_logtime=" & requestProcess_logtime)
                    Else
                        Response.Redirect("./tstruct.aspx?act=open&transid=" & tid & paramstring & "&axp_refresh=" & axp_RefreshParent & axPop & axSplit & openTstAdditionalInfo & "&reqProc_logtime=" & requestProcess_logtime)
                    End If
                Else
                    Session("AxFromHypLink") = "true"
                    If (pNames.Count = 3) Then
                        For g = 0 To pNames.Count - 3
                            pNames(g) = util.CheckSpecialChars(pNames(g).ToString())
                            pValues(g) = util.CheckSpecialChars(pValues(g).ToString())
                            getRecXml = getRecXml & "<" & pNames(g) & ">" & pValues(g) & "</" & pNames(g) & ">"
                            paramstring = paramstring & "&" & pNames(g) & "=" & pValues(g)
                        Next
                        getRecXml = getRecXml & "</values>"
                    Else
                        For g = 0 To pNames.Count - 3
                            pNames(g) = util.CheckSpecialChars(pNames(g).ToString())
                            pValues(g) = util.CheckSpecialChars(pValues(g).ToString())
                            getRecXml = getRecXml & "<" & pNames(g) & ">" & pValues(g) & "</" & pNames(g) & ">"
                            paramstring = paramstring & "&" & pNames(g) & "=" & pValues(g)
                        Next
                        getRecXml = getRecXml & "</values>"
                    End If
                    getRecXml = getRecXml & Session("axApps").ToString() & Application("axProps").ToString() & Session("axGlobalVars").ToString() & Session("axUserVars").ToString() & "</root>"
                    Dim torecid As String = ""
                    torecid = pValues(pNames.Count - 1).ToString()
                    Dim recid As String
                    recid = ""
                    If torecid = "false" Then
                        If recordid <> "" Then
                            recid = recordid
                        Else
                            Dim gRecIdres As String = String.Empty
                            Dim fObj As FDR = HttpContext.Current.Session("FDR")
                            Dim transIds As String = tid
                            Dim AxRoles As String = HttpContext.Current.Session("AxRole").ToString()
                            Dim lang As String = HttpContext.Current.Session("language").ToString().Substring(0, 3)
                            Dim fdKeydcTable As String = Constants.REDISTSTRUCTTABLE
                            Dim strDcTable As String = fObj.StringFromRedis(util.GetRedisServerkey(fdKeydcTable, transIds))
                            If (getRecXml.ToLower.Contains("<" + strDcTable.ToLower + "id" + ">")) Then
                                Dim xmlDoc As New XmlDocument
                                xmlDoc.LoadXml(getRecXml)
                                Dim customDetailsXML As XmlNodeList = xmlDoc.GetElementsByTagName("values")
                                recid = customDetailsXML(0).InnerText
                            Else
                                'Call service
                                Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()
                                gRecIdres = objWebServiceExt.CallGetRecordIdWS(tid, getRecXml)
                                requestProcess_logtime += gRecIdres.Split("♠")(0)
                                gRecIdres = gRecIdres.Split("♠")(1)

                                Dim errMsg As String = String.Empty
                                errMsg = util.ParseXmlErrorNode(gRecIdres)

                                If errMsg <> String.Empty Then
                                    If errMsg = Constants.SESSIONERROR Then
                                        Session.RemoveAll()
                                        Session.Abandon()
                                        Dim url1 As String
                                        url1 = util.SESSEXPIRYPATH
                                        Response.Write("<script>" & vbCrLf)
                                        Response.Write("parent.parent.location.href='" & url1 & "';")
                                        Response.Write(vbCrLf & "</script>")
                                    Else
                                        Response.Redirect(util.ERRPATH + errMsg)
                                    End If
                                Else
                                    gRecIdres = _xmlString & gRecIdres

                                    Dim xmlDoc2 As New XmlDocument
                                    xmlDoc2.LoadXml(gRecIdres)

                                    Dim pRecidNodes As XmlNodeList
                                    Dim precIdNode As XmlNode

                                    pRecidNodes = xmlDoc2.SelectNodes("/root/recordid")
                                    For Each precIdNode In pRecidNodes
                                        recid = precIdNode.InnerText
                                    Next
                                End If
                            End If
                        End If
                    Else
                        recid = fltype
                    End If


                    If (recid = "0") Then
                        Response.Redirect("./tstruct.aspx?act=open&transid=" & tid & viewNavigationData & axPop & axSplit & "&reqProc_logtime=" & requestProcess_logtime)
                    Else
                        If axp_RefreshParent Is Nothing Then
                            Response.Redirect("./tstruct.aspx?act=load&transid=" & tid & "&recordid=" & recid & viewNavigationData & axPop & axSplit & "&reqProc_logtime=" & requestProcess_logtime)
                        Else
                            Response.Redirect("./tstruct.aspx?act=load&transid=" & tid & "&recordid=" & recid & "&axp_refresh=" & axp_RefreshParent & viewNavigationData & axPop & axSplit & "&reqProc_logtime=" & requestProcess_logtime)
                        End If
                    End If
                End If
            End If
            If Session("backForwBtnPressed") IsNot Nothing AndAlso Not Convert.ToBoolean(Session("backForwBtnPressed")) Then
                util.UpdateNavigateUrl(HttpContext.Current.Request.Url.AbsoluteUri)
                Session("backForwBtnPressed") = True
                Session("AxFromHypLink") = True
            End If
        End If

    End Sub
End Class
