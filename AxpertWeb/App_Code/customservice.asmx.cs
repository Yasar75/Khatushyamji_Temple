using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net.Configuration;
using System.Configuration;
using System.Net;
using Newtonsoft.Json;
using System.Data;
using System.Web.Script.Serialization;
using System.Net.Http;
using System.Net.Http.Headers;



public class UserData
{
    public string uemail { get; set; }
    public string dob { get; set; }
    public string category { get; set; }
    public string ugender { get; set; }
    public string ssoid { get; set; }
    public string mob { get; set; }
    public string ename { get; set; }
}

public class RowData
{
    public string rowno { get; set; }
    public string text { get; set; }
    public UserData columns { get; set; }
}

public class SaveData
{
    public string axpapp { get; set; }
    public string username { get; set; }
    public string password { get; set; }
    public string transid { get; set; }
    public string s { get; set; }
    public string trace { get; set; }
    public string recordid { get; set; }
    public RowData[] recdata { get; set; }
}




