Imports System.IO
Partial Class sess
    Inherits System.Web.UI.Page
    Public appName As String
    Public appTitle As String
    Public loginStr As String
    Public EnableOldTheme As String
    Dim util As Util.Util = New Util.Util()
    Public direction As String = "ltr"
    Public langType As String = "en"
    Public strFileinfo As String = String.Empty
    Public showAlertMsgText As String = String.Empty

    Protected Overrides Sub InitializeCulture()
        If Session("language") IsNot Nothing Or Application("LangSess") IsNot Nothing Then
            Dim langProj As String = If(Session("language") Is Nothing, Application("LangSess").ToString(), Session("language"))
            Dim dirLang As String = String.Empty
            dirLang = util.SetCulture(langProj.ToUpper())
            If Not String.IsNullOrEmpty(dirLang) Then
                direction = dirLang.Split("-")(0)
                langType = dirLang.Split("-")(1)
            End If
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            main_body.Attributes.Add("class", direction + " signout_cls")
            If Not IsPostBack Then
                If Session("AxEnableOldTheme") IsNot Nothing Then
                    EnableOldTheme = Session("AxEnableOldTheme").ToString().ToLower()
                End If
                Dim AxCloudDB As String
                If Session("AxCloudDB") IsNot Nothing Then
                    AxCloudDB = Session("AxCloudDB").ToString()
                End If
                If Application("AxCloudDB") IsNot Nothing And AxCloudDB Is Nothing Then
                    AxCloudDB = Application("AxCloudDB").ToString()
                    Application("AxCloudDB") = ""
                End If
                If AxCloudDB IsNot Nothing Then
                    loginStr = ConfigurationManager.AppSettings("CloudHomeUrl")
                End If
                loginStr = Application("LoginPath").ToString()
                If Not (Request.QueryString("hybridGUID") = "") Then
                    Dim hybridGUID = Request.QueryString("hybridGUID")
                    loginStr += "?hybridGUID=" + hybridGUID
                    If Not (Request.QueryString("deviceid") = "") Then
                        Dim deviceid = Request.QueryString("deviceid")
                        loginStr += "&deviceid=" + deviceid
                    End If
                    If Not (Request.QueryString("projname") = "") Then
                        Dim projname = Request.QueryString("projname")
                        loginStr += "&projname=" + projname
                    End If
                End If

                If Not Application("projTitle") Is Nothing Then
                    appTitle = Application("projTitle").ToString()
                ElseIf Session("AxAppTitle") IsNot Nothing Then
                    appTitle = Session("AxAppTitle").ToString()
                End If

                If Not (Request.QueryString("showmsg") = "") Then
                    showAlertMsgText = Request.QueryString("showmsg")
                End If

                appName = appTitle
            End If
            Dim _xmlString As String =
          "<?xml version=""1.0"" encoding=""utf-8"" ?>"
            If Session("project") = "" Then
                'do nothing
            Else
                Dim sXml As String
                Dim user As String
                Dim sid As String
                Dim proj As String
                Dim Svrlic_redis As String
                sXml = ""
                user = Session("user")
                sid = Session("nsessionid")
                If sid IsNot Nothing Then
                    If Session("Svrlic_redis") IsNot Nothing Then
                        Svrlic_redis = Session("Svrlic_redis").ToString()
                    Else
                        Svrlic_redis = ""
                    End If
                    proj = Session("project")
                    sXml = sXml & "<root axpapp=" & Chr(34) & proj & Chr(34) & " " & Svrlic_redis & " sessionid= " & Chr(34) & sid & Chr(34) & " trace=" & Chr(34) & Session("trace") & Chr(34) & " >"
                    sXml &= Session("axApps").ToString() & Application("axProps").ToString() & "</root>"
                    util.DeleteKeepAliveWebKey()
                    util.SaveExecutionText()
                    util.DeleteUnwantedKeys()
                    util.TempAttaServerFiles()
                    util.ClearUserIviewData()
                    Dim res As String
                    Dim objWebServiceExt As ASBExt.WebServiceExt = New ASBExt.WebServiceExt()
                    'Call service
                    util.RemoveLoggedUserDetails(proj, sid)
                    res = objWebServiceExt.CallLogoutWS("sess", sXml)
                    Dim scriptsPath As String = HttpContext.Current.Application("ScriptsPath").ToString()
                    scriptsPath = scriptsPath + "Axpert\\" + sid
                    If Directory.Exists(scriptsPath) And sid IsNot Nothing Then
                        Try
                            Directory.Delete(scriptsPath, True)
                        Catch
                            'Do Nothing
                        End Try
                    End If

                    Dim keys As New ArrayList
                    Dim firstCac As String = sid & "order"
                    keys.Add(firstCac)

                    Dim k As Integer
                    For k = 0 To k < keys.Count - 1
                        Cache.Remove(keys(k))
                    Next
                End If
            End If
            If ConfigurationManager.AppSettings("HomeSessExpriesUrl") IsNot Nothing And ConfigurationManager.AppSettings("HomeSessExpriesUrl").ToString() <> "" Then
                Dim url As String
                url = ConfigurationManager.AppSettings("HomeSessExpriesUrl")
                Response.Redirect(url)
            End If
            Dim folderPath As String = Server.MapPath("~/images/Custom")
            Dim di As New IO.DirectoryInfo(folderPath)
            Dim diFileinfo As IO.FileInfo() = di.GetFiles()
            Dim drfile As IO.FileInfo
            Dim custommoblogoexist = "False"
            Dim customlogoexist = "False"
            Dim Ismobile = Request.Browser.IsMobileDevice
            'For Each drfile In diFileinfo
            '    If drfile.Length > 0 AndAlso drfile.Name.Contains("homelogo_mob") Then
            '        strFileinfo = drfile.Name
            '        Exit For
            '    End If
            'Next
            'For Each drfile In diFileinfo
            '    If drfile.Length > 0 AndAlso drfile.Name.Contains("homelogo") Then
            '        If drfile.Name.Contains("mp4") Then
            '            main_body.Attributes.CssStyle.Add("background", "")
            '            bgvid.Attributes.CssStyle.Add("display", "block")
            '            bgvidsource.Attributes.Add("src", "./../images/Custom/homelogo.mp4?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + "")
            '            customlogoexist = "True"
            '            Exit For
            '        Else
            '            main_body.Attributes.CssStyle.Add("background", "url(./../images/Custom/" + drfile.Name + "?v=" + DateTime.Now.ToString("yyyyMMddHHmmss") + ") no-repeat center center fixed !important ")
            '            main_body.Attributes.CssStyle.Add("background-size", "cover !important")
            '            main_body.Attributes.CssStyle.Add("height", "100vh !important")
            '            customlogoexist = "True"
            '            Exit For
            '        End If
            '    End If
            'Next
            If customlogoexist = "False" Then
                main_body.Attributes.CssStyle.Add("background", "url(./../AxpImages/login-img.png)")
                main_body.Attributes.CssStyle.Add("background-repeat", "no-repeat")
                main_body.Attributes.CssStyle.Add("background-attachment", "fixed")
                main_body.Attributes.CssStyle.Add("background-position", "bottom")
                main_body.Attributes.CssStyle.Add("background-size", "cover !important")
            End If
            util.KillSession() 'Kill this page's session after load
        Catch ex As Exception
            Try
                util.KillSession() 'Kill this page's session after load
            Catch exe As Exception
                Dim sessionStateSection As System.Web.Configuration.SessionStateSection = CType(ConfigurationManager.GetSection("system.web/sessionState"), System.Web.Configuration.SessionStateSection)
                Dim cookieName As String = sessionStateSection.CookieName
                Dim mycookie As HttpCookie = New HttpCookie(cookieName)
                mycookie.Expires = DateTime.Now.AddDays(-1)
                HttpContext.Current.Response.Cookies.Add(mycookie)
                HttpContext.Current.Session.Abandon()
            End Try
        End Try
    End Sub

    <System.Web.Services.WebMethod()>
    Public Shared Sub ClearSessExpiry(ByVal duplicateUser As String)
        If duplicateUser <> String.Empty Then
            Dim Proj As String = duplicateUser.Split("-")(0)
            Dim Sid As String = duplicateUser.Split("-")(1)
            Dim util As Util.Util = New Util.Util()
            util.RemoveLoggedUserDetails(Proj, Sid)
        End If
    End Sub
End Class
