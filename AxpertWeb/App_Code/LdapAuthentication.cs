﻿using System.Text;
using System.Collections;
using System.DirectoryServices;
using System;
using System.Web;

public class LdapAuthentication
{
    private string _path;
    private string _filterAttribute;
    public string _guid = string.Empty;
    public LdapAuthentication(string path)
    {
        _path = path;
    }

    public bool IsAuthenticated(string domain, string username, string pwd)
    {
        string domainAndUsername = domain + @"\" + username;
        DirectoryEntry entry = new DirectoryEntry(_path, domainAndUsername, pwd);
        try
        {
            // Bind to the native AdsObject to force authentication.
            Object obj = entry.NativeObject;
            DirectorySearcher search = new DirectorySearcher(entry);
            _guid = entry.NativeGuid;
            search.Filter = "(SAMAccountName=" + username + ")";
            search.PropertiesToLoad.Add("cn");
            SearchResult result = search.FindOne();
            if (null == result)
            {
                return false;
            }
            // Update the new path to the user in the directory
            _path = result.Path;
            _filterAttribute = (String)result.Properties["cn"][0];
        }
        catch (Exception ex)
        {
            LogFile.Log logobj = new LogFile.Log();
            logobj.CreateLog("IsAuthenticated: _path: " + _path + " domainAndUsername: " + domainAndUsername + " Exception:" + ex.Message, HttpContext.Current.Session.SessionID, "AD_SSO_Authenticate_Error", "new", "true");
            throw new Exception("Error authenticating user. " + ex.Message);
        }
        return true;
    }

    public string GetGroups()
    {
        DirectorySearcher search = new DirectorySearcher(_path);
        search.Filter = "(cn=" + _filterAttribute + ")";
        search.PropertiesToLoad.Add("memberOf");
        StringBuilder groupNames = new StringBuilder();
        try
        {
            SearchResult result = search.FindOne();
            int propertyCount = result.Properties["memberOf"].Count;
            String dn;
            int equalsIndex, commaIndex;

            for (int propertyCounter = 0; propertyCounter < propertyCount;
                 propertyCounter++)
            {
                dn = (String)result.Properties["memberOf"][propertyCounter];

                equalsIndex = dn.IndexOf("=", 1);
                commaIndex = dn.IndexOf(",", 1);
                if (-1 == equalsIndex)
                {
                    return null;
                }
                groupNames.Append(dn.Substring((equalsIndex + 1),
                                  (commaIndex - equalsIndex) - 1));
                groupNames.Append("|");
            }
        }
        catch (Exception ex)
        {
            LogFile.Log logobj = new LogFile.Log();
            logobj.CreateLog("GetGroups: _path: " + _path + " Exception:" + ex.Message, HttpContext.Current.Session.SessionID, "AD_SSO_GetGroups_Error", "new", "true");
            throw new Exception("Error obtaining group names. " +
              ex.Message);
        }
        return groupNames.ToString();
    }
}
