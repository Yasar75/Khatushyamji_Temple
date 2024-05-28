using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Xml;
using System.Text;
using System.IO;
using System.Configuration;
using System.Security.Principal;
using System.Web.UI.WebControls;
using System.Web;
using Axpert_Object;
using System.Web.UI;
using System.Linq;
using System.Web.Services;
using System.Web.Configuration;
using System.Security.Cryptography;
using System.Globalization;
using System.Net;
using System.Threading;
using System.Web.Script.Serialization;
using RestSharp;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Script.Services;
using Twilio;
using Twilio.Rest.Api.V2010.Account;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]

public partial class aspx_Homepagenew : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

    }
 
       // Function to send an SMS message using Twilio .NET SDK
        protected void SendSMS(string mobileNumber, string message)
    {
        const string accountSid = "ACba304351c0f0efaf467af2de8c99e375";
        const string authToken = "eca50f52cf604c2b7097fa3155b38a88";
        const string twilioPhoneNumber = "+12177037667";

        TwilioClient.Init(accountSid, authToken);

        try
        {
            var messageResource = MessageResource.Create(
                body: message,
                from: new Twilio.Types.PhoneNumber(twilioPhoneNumber),
                to: new Twilio.Types.PhoneNumber(mobileNumber)
            );

            // Message SID can be used to track the status of the sent message.
            Console.WriteLine("SMS sent successfully. Message SID: " + messageResource.Sid);
        }
        catch (Exception ex)
        {
            // Handle any exceptions that might occur during the SMS sending process.
            Console.WriteLine("Error sending SMS: " + ex.Message);
        }
     }

        // [WebMethod]
        // public static void SendSMS(string mobileNumber, string message)
        // {
        //     // Call the C# function to send SMS
        //     var page = new Default();
        //     page.SendSMS(mobileNumber, message);
        // }
}




