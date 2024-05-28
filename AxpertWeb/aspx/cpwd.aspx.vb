Imports System.Xml
Imports System.Collections.Generic
Imports System.Xml.Linq
Imports System.Threading

Partial Class cpwd
    Inherits System.Web.UI.Page
    Dim logobj As LogFile.Log = New LogFile.Log()
    Dim util As Util.Util = New Util.Util()
    Public filename As String = "ChangePassword"
    Public appName As String
    Public logoutPath As String
    Public direction As String = "ltr"
    Public enableBackForwButton As String = ""
    Public EnableOldTheme As String
    Public isCloud As Boolean = False
    Public isCloudApp As Boolean = False
    Public signOutPath As String = ""
    Public remark As String = ""
    Public langType As String = "en"
    Public strFileinfo As String = String.Empty
    Public PasswordprotectKEY As String = ""
    Public CpFirstMsg As String = "Existing Password needs to be changed for first time login"
    Public CpErrormsg As String = "Please enter a valid password"

    Protected Overrides Sub InitializeCulture()
        If Session("language") IsNot Nothing Then
            util = New Util.Util()
            Dim dirLang As String = String.Empty
            dirLang = util.SetCulture(Session("language").ToString().ToUpper())
            If Not String.IsNullOrEmpty(dirLang) Then
                direction = dirLang.Split("-")(0)
                langType = dirLang.Split("-")(1)
            End If
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (ConfigurationManager.AppSettings("isCloudApp") <> Nothing) Then
            isCloudApp = Convert.ToBoolean(ConfigurationManager.AppSettings("isCloudApp").ToString())
        End If
        If (Request.QueryString("remark") <> Nothing) Then
            remark = Request.QueryString("remark")
            If (remark <> Nothing And remark = "1" And Session("cpwdErr") = Nothing And hdncheckMsg.Value <> "true") Then
                Page.ClientScript.RegisterStartupScript([GetType](), "myrest", "<script>setTimeout(function () {showAlertDialog('info','" + CpFirstMsg + "',undefined,undefined,undefined,true);},10);</script>")
            End If
        End If
            'util.IsValidAxpertSession()
            If Request.UrlReferrer IsNot Nothing Then
            If Not (Request.UrlReferrer.AbsolutePath.ToLower().Contains("main.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("mainnew.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("cpwd.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("signin.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("login1.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("logininter.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("tstruct.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("iview.aspx") Or Request.UrlReferrer.AbsolutePath.ToLower().Contains("ParamsTstruct.aspx")) Then
                Response.Redirect("../CusError/AxCustomError.aspx")
            End If
        End If

        Try
            If util.CheckCrossScriptingInString(remark) Then
                Try
                    Response.Redirect(Constants.LOGINPAGE, True)
                Catch ex As ThreadAbortException
                    Thread.ResetAbort()
                End Try
            End If
        Catch ex As Exception
        End Try

        If Session("AxEnableOldTheme") IsNot Nothing Then
            EnableOldTheme = Session("AxEnableOldTheme").ToString().ToLower()
        End If
        'To Reset the Sessiontime in client side
        ResetSessionTime()
        If util.IsValidQueryString(Request.RawUrl) = False Then
            Response.Redirect(util.ERRPATH + Constants.INVALIDURL)
        End If

        PasswordprotectKEY = util.GetAdvConfigs("Enforced Strong Password Policy").ToString().ToLower()
        'To display version info in first time Change Password page
        'Dim axpertVersion As String = ""
        'If Not ConfigurationManager.AppSettings("axpertVersion") Is Nothing Then
        '    If ConfigurationManager.AppSettings("axpertVersion").ToString() <> String.Empty Then
        '        axpertVersion = "Version " + ConfigurationManager.AppSettings("axpertVersion").ToString()
        '    End If
        'End If

        'axpertVer.InnerText = axpertVersion

        If Session("project") = "" Then
            Dim url As String
            'url = util.SESSEXPIRYPATH
            Response.Write("<script>" & vbCrLf)
            'Response.Write("if(window.opener && !window.opener.closed){window.opener.parent.location.href='" + url + "';window.close();}else {parent.parent.location.href='" + url + "';}")
            Response.Write(vbCrLf & "</script>")
        Else
            'If Not util.licencedValidSessionCheck() Then
            '    HttpContext.Current.Response.Redirect(util.ERRPATH + Constants.SESSIONEXPMSG, False)
            '    Return
            'End If

            If Not Session("projTitle") Is Nothing Then
                appName = Session("projTitle").ToString()
            Else
                appName = Session("AxAppTitle").ToString()
            End If

            logoutPath = util.SIGNOUTPATH
            If Session("language").ToString() = "ARABIC" Then
                direction = "rtl"
            End If
            If (Session("cpwdErr") <> Nothing And Session("cpwdErr") <> String.Empty) Then
                Page.ClientScript.RegisterStartupScript([GetType](), "myrest", "<script>showAlertDialog('warning','" & Session("cpwdErr").ToString() & "');displayAlertMsgOnParent()</script>")
                Session("cpwdErr") = String.Empty
            End If


            'If (Session("changeSuccess") <> Nothing And Session("changeSuccess") <> String.Empty) Then
            '    Page.ClientScript.RegisterStartupScript([GetType](), "myrest", "<script>showAlertDialog('success','" & Session("changeSuccess").ToString() & "');</script>")
            '    Session("changeSuccess") = String.Empty
            'End If

            If (Session("minPwdChars") <> Nothing) Then
                pwdlength.Value = Session("minPwdChars").ToString()
            Else
                pwdlength.Value = "0"
            End If

            Dim isPwdAlphaNumeric As Boolean = False
            If (Session("IsPwdAlphaNumeric") <> Nothing) Then
                If (Session("IsPwdAlphaNumeric").ToString().ToLower() = "t") Then
                    isPwdAlphaNumeric = True
                End If
            End If
            Page.ClientScript.RegisterStartupScript([GetType](), "myrest", "<script>isPwdAlphaNumeric=" & isPwdAlphaNumeric.ToString().ToLower() & ";PasswordprotectKEY=" & PasswordprotectKEY.ToString().ToLower() & "</script>")
        End If

        'Backward option is not required for Change Password window since we are displaying it in the modal dialog
        'If Session("backForwBtnPressed") IsNot Nothing AndAlso Not Convert.ToBoolean(Session("backForwBtnPressed")) Then
        '    util.UpdateNavigateUrl(HttpContext.Current.Request.Url.AbsoluteUri)
        'End If
        'Session("backForwBtnPressed") = False
        'enableBackForwButton = "<script language=""javascript"" type=""text/javascript"" > enableBackButton=""" & Convert.ToBoolean(Session("enableBackButton")) & """; enableForwardButton=""" & Convert.ToBoolean(Session("enableForwardButton")) & """;</script>"

        If (Session("AxAxCLOUD") IsNot Nothing) Then
            isCloud = Convert.ToBoolean(Session("AxAxCLOUD").ToString())

        End If
        If (isCloud) Then
            signOutPath = "../" + Session("domainName")
        Else
            signOutPath = util.SIGNOUTPATH
        End If
        Dim folderPath As String = Server.MapPath("~/images/Custom")
        Dim di As New IO.DirectoryInfo(folderPath)
        Dim diFileinfo As IO.FileInfo() = di.GetFiles()
        Dim drfile As IO.FileInfo
        Dim custommoblogoexist = "False"
        Dim customlogoexist = "False"
        Dim Ismobile = Request.Browser.IsMobileDevice
        If Not remark = "chpwd" Then
            For Each drfile In diFileinfo
                If drfile.Length > 0 AndAlso drfile.Name.Contains("homelogo_mob") Then
                    strFileinfo = drfile.Name
                    Exit For
                End If
            Next
            'If Ismobile Then
            '    For Each drfile In diFileinfo
            '        '  Dim filename As String = drfile.ToString
            '        If drfile.Length > 0 AndAlso drfile.Name.Contains("homelogo") Then
            '            main_body.Attributes.CssStyle.Add("background", "url(./../images/Custom/homelogo_mob.jpg?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + ") center center no-repeat fixed !important")
            '            main_body.Attributes.CssStyle.Add("background-size", "cover !important")
            '            custommoblogoexist = "True"
            '            Exit For
            '        End If
            '    Next
            '    If custommoblogoexist = "False" AndAlso Ismobile Then
            '        main_body.Attributes.CssStyle.Add("background", "url(./../AxpImages/homelogo_mob.jpg) center center no-repeat fixed !important")
            '        main_body.Attributes.CssStyle.Add("background-size", "cover !important")
            '    End If
            'Else
            For Each drfile In diFileinfo
                '  Dim filename As String = drfile.ToString
                If drfile.Length > 0 AndAlso drfile.Name.Contains("homelogo") Then
                    If drfile.Name.Contains("mp4") Then
                        bgvid.Attributes.CssStyle.Add("display", "block")
                        bgvidsource.Attributes.Add("src", "./../images/Custom/homelogo.mp4?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + "")
                        customlogoexist = "True"
                    Else
                        main_body.Attributes.CssStyle.Add("background", "url(./../images/Custom/homelogo.jpg?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + ") center center no-repeat fixed !important")
                        main_body.Attributes.CssStyle.Add("background-size", "cover !important")
                        customlogoexist = "True"
                    End If
                End If
            Next
            If customlogoexist = "False" Then
                'main_body.Attributes.CssStyle.Add("background", "url(./../AxpImages/homelogo.jpg) center center no-repeat fixed !important")
                'main_body.Attributes.CssStyle.Add("background-size", "cover !important")
                main_body.Attributes.CssStyle.Add("background", "url(./../AxpImages/login-img.png)")
                main_body.Attributes.CssStyle.Add("background-repeat", "no-repeat")
                main_body.Attributes.CssStyle.Add("background-attachment", "fixed")
                main_body.Attributes.CssStyle.Add("background-position", "bottom")
                main_body.Attributes.CssStyle.Add("background-size", "cover !important")
            End If
            'End If
        End If



    End Sub
    'To Reset the Session time in clientside
    Private Sub ResetSessionTime()
        If Session("AxSessionExtend") IsNot Nothing AndAlso Session("AxSessionExtend").ToString() = "true" Then
            HttpContext.Current.Session("LastUpdatedSess") = DateTime.Now.ToString()
            ClientScript.RegisterStartupScript(Me.[GetType](), "SessionAlert", "eval(callParent('ResetSession()', 'function'));", True)
        End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim ePwd As String = util.CheckSpecialChars(swee000F0.Value)
        Dim md5pwd As String = util.CheckSpecialChars(swc000F0.Value)

        Dim npwdString As String = npwdHidden.Value

        Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()
        Dim errorLog As String
        errorLog = logobj.CreateLog("Call to Change password web service", Session("nsessionid").ToString(), "ChangePwd", "new")
        Dim result As String = String.Empty
        Dim aesPwd As String = String.Empty
        If (md5pwd = "") Then
            md5pwd = npwdHiddenMd5.Value
        End If
        Try

            aesPwd = objWebServiceExt.GetEncryptedValue(npwdString)

        Catch ex As Exception
        End Try
        Try
            If (md5pwd = "" Or aesPwd = "") Then
                Page.ClientScript.RegisterStartupScript([GetType](), "closepopup", "<script>parent.showAlertDialog('warning','" + CpErrormsg + "');</script>")
                Return

            End If
        Catch ex As Exception
        End Try
        Dim changeByAdmin As String = "no"
        Dim ixml As String = "<root axpapp='" & Session("project").ToString() & "' loginuser='" & Session("user").ToString() & "' sessionid='" & Session("nsessionid").ToString() & "' appsessionkey=" & Chr(34) & Session("AppSessionKey").ToString() & Chr(34) & " username=" & Chr(34) & Session("username").ToString() & Chr(34) & " trace='" & errorLog & "' user='" & Session("user").ToString() & "' action=''>"
        ixml &= "<pwd>" & aesPwd & "</pwd><md5pwd>" & md5pwd & "</md5pwd><oldpwd>" & ePwd & "</oldpwd><changebyadmin>" & changeByAdmin & "</changebyadmin>"
        ixml &= Session("axApps").ToString() & Application("axProps").ToString() & Session("axGlobalVars").ToString() & Session("axUserVars").ToString() & "</root>"


        Try
            result = objWebServiceExt.CallChangePassword(ixml)
            If result = "<error> Incorrect old password.</error>" Then
                result = "<error> Incorrect existing password.</error>"
            End If
        Catch ex As Exception

        End Try

        Dim errMsg As String = String.Empty
        errMsg = util.ParseXmlErrorNode(result)

        If errMsg <> String.Empty Then
            If errMsg.Contains(Constants.SESSIONERROR) Or errMsg.Contains(Constants.SESSIONEXPMSG) Then
                Session.RemoveAll()
                Session.Abandon()
                Dim url1 As String
                'url1 = util.SESSEXPIRYPATH
                Response.Write("<script>" & vbCrLf)
                'Response.Write("parent.parent.location.href='" & url1 & "';")
                Response.Write(vbCrLf & "</script>")
            Else
                Session("cpwdErr") = errMsg
                Response.Redirect("cpwd.aspx?remark=" & Request.QueryString("remark"))
                'Page.ClientScript.RegisterStartupScript([GetType](), "myrest", "<script>showAlertDialog('error','" + errMsg + "');</script>")
            End If
        End If


        If (result.ToLower() = "done" Or result.Contains("<success>")) Then
            If (Request.QueryString("remark") = "1") Or (Request.QueryString("remark") = "2") Or (Request.QueryString("remark") = "3") Then
                Session("validated") = "True"

                Dim sessionStateSection As System.Web.Configuration.SessionStateSection = CType(ConfigurationManager.GetSection("system.web/sessionState"), System.Web.Configuration.SessionStateSection)
                Dim cookieName As String = sessionStateSection.CookieName
                Dim mycookie As HttpCookie = New HttpCookie(cookieName)
                mycookie.Expires = DateTime.Now.AddDays(-1)
                HttpContext.Current.Response.Cookies.Add(mycookie)
                System.Web.HttpContext.Current.Session.Abandon()
                Dim manager As SessionIDManager = New SessionIDManager()
                manager.RemoveSessionID(System.Web.HttpContext.Current)

                Page.ClientScript.RegisterStartupScript([GetType](), "closepopup", "<script>parent.showAlertDialog('success','" + result + "'); setInterval(function(){window.location.href= '" + Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath + "/aspx/SignIn.aspx';},1000)</script>")
            Else
                dvMainPwd.Style.Add("display", "none")
                ' dvPwdResult.Style.Add("display", "block")
                tabbody1.Style.Add("display", "none")

                Session("changeSuccess") = result
                Page.ClientScript.RegisterStartupScript([GetType](), "closepopup", "<script>closeDialog('" + result + "','" + Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath + "/aspx/SignIn.aspx')</script>")
            End If
        Else
            'dvMainPwd.Style.Add("display", "block")
            '' dvPwdResult.Style.Add("display", "none")
            'tabbody1.Style.Add("display", "block")
            Session("cpwdErr") = errMsg
            Response.Redirect("cpwd.aspx?remark=" & Request.QueryString("remark"))
        End If

    End Sub


    Private Function TryParseXml(ByVal xml As String) As Boolean
        Try
            XDocument.Parse(xml)
            Return True
        Catch e As XmlException
            Return False
        End Try

    End Function


    Private Function ConvertFromBase64System(ByVal password As String) As String

        Dim newPassword As String = String.Empty
        Try
            Dim ba() As Byte = Convert.FromBase64String(password)
            password = Encoding.UTF8.GetString(ba)
            Dim xor_key As Byte = password.Substring(0, 1)
            password = password.Substring(1)
            Dim sb As New StringBuilder()
            Dim count As Integer = 0
            For count = 1 To ba.Length - 1
                sb.Append(Chr(ba(count) Xor xor_key))
            Next

            newPassword = sb.ToString()
        Catch ex As Exception

        End Try

        Return newPassword
    End Function

    Private Function CallGetChoiceService(ByVal inputParam As String) As String

        Dim result As String = String.Empty
        Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()

        'Call service
        result = objWebServiceExt.CallGetChoiceWS("cbwd", inputParam)
        If result.Contains(Constants.SESSIONEXPMSG) Then
            Response.Redirect(util.ERRPATH + Constants.SESSIONEXPMSG)
        End If
        Return result
    End Function
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        If HttpContext.Current.Session("allUrls") IsNot Nothing Then
            Dim allurls1 As New List(Of String)
            allurls1 = Session("allurls")
            Dim path1 As String = allurls1(allurls1.Count - 1)
            path1 = path1.Substring(path1.LastIndexOf("/aspx/") + 5)

            Response.Redirect("../aspx" & path1)

        End If


    End Sub



End Class
