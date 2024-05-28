<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Homepagenew.aspx.cs" Inherits="aspx_Homepagenew" %>

  <!DOCTYPE html>
  <html lang="en">

  <head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/x-icon" href="https://i.ibb.co/swDXbHy/channels4-profile-removebg-preview.png" />
    <title>Khatushyam</title>

    <!-- CSS -->
    <link href="../Css/Homepagenew.css" rel="stylesheet" />
    <link href="../Css/thirdparty/bootstrap/5.3/bootstrap-5.3.0.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <!-- JS -->
    <script src="../Js/thirdparty/bootstrap/5.3/bootstrap_bundle-5.3.0.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="../js/thirdparty/jquery/3.6.0/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script type="text/javascript" src="../Js/Homepagenew.js"></script>

  </head>

  <body>
    <form id="form1" runat="server">

      <!-- <asp:ScriptManager runat="server">
        <Scripts>
          <asp:ScriptReference Path="../Js/Homepagenew.js" />
        </Scripts>
      </asp:ScriptManager> -->

      <div class="top">
        <div class="logo">
          <a href="#Home/"><img title="Khatushyam" src="https://i.ibb.co/swDXbHy/channels4-profile-removebg-preview.png"
              alt="Khatushyam" />
          </a>
        </div>

        <div class="header fixed lg-3 md-4 sm-2">
          <p title="Khatushyam" id="Home">
            <p1>Shree Shyam Mandir, Khatushyamji</p1>
            <p3>|| जय श्री मोरवीनंदन जय श्री खाटूश्यामजी ||</p3>
          </p>
        </div>

        <div class="navbar fixed navbar-expand-lg justify-content-center">
          <ul class="navbar-nav lg-3 md-4 sm-4">
            <li class="nav-item active">
              <a title="Home" href="#Home">Home</a>
            </li>
            <li class="nav-item active">
              <a title="Gallary" href="#Home">Gallary</a>
            </li>
            <li class="nav-item active">
              <a title="News" href="#Home">News</a>
            </li>
            <li class="nav-item active">
              <a title="Downloads" href="#Home">Downloads</a>
            </li>
            <li class="nav-item active">
              <a title="Sign In" href="#" onclick="openRegistrationModal()">Darshan Booking</a>
            </li>
            <li class="nav-item active">
              <a title="Admin Login" href="http://172.22.33.245/axpertDeveloper/aspx/mainnew.aspx" target="_blank">Admin
                Login</a>
            </li>
          </ul>
        </div>
      </div>

      <!-- Bootstrap Modal -->
      <div class="modal fade" id="registration" tabindex="-1" role="dialog" aria-labelledby="registrationLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="registrationLabel">
                User Registration
              </h5>
              <button type="button" class="btn-close" aria-label="Close" onclick="closeRegistrationModal()">
                <!-- <span aria-hidden="true">&times;</span> -->
              </button>
            </div>
            <div class="modal-body">
              <div class="registration">
                <div class="myform">
                  <div class="form-group">
                    <label for="ssoid">SSO ID(User ID) *</label>
                    <asp:TextBox runat="server" ID="ssoid" CssClass="form-control mb-2" placeholder="Enter SSO ID"
                      autocomplete="off" required>
                    </asp:TextBox>
                  </div>

                  <div>
                    <label for="Category">Category: *</label>
                    <asp:DropDownList runat="server" ID="category" CssClass="form-select form-select-lg-1"
                      autocomplete="off" required>
                      <asp:ListItem Text="Select Category" Disabled="true" Selected="true"></asp:ListItem>
                      <asp:ListItem Text="General Public"></asp:ListItem>
                      <asp:ListItem Text="Senior Citizen"></asp:ListItem>
                      <asp:ListItem Text="Disability Person"></asp:ListItem>
                    </asp:DropDownList>
                  </div>

                  <div class="form-group">
                    <label for="name">Name: *</label>
                    <asp:TextBox runat="server" ID="name" CssClass="form-control mb-2" placeholder="Enter Name"
                      autocomplete="off" required>
                    </asp:TextBox>
                  </div>

                  <div class="form-group">
                    <label for="number">Mobile Number: *</label>
                    <asp:TextBox runat="server" ID="mob" CssClass="form-control mb-2"
                      onblur="validateMobileNumber(this)" placeholder="Enter Mobile Number" autocomplete="off" required>
                    </asp:TextBox>
                    <span id="mobileNumberError" runat="server" style="color: red"></span>
                  </div>

                  <div class="form-group">
                    <label for="Email">Email address</label>
                    <asp:TextBox runat="server" ID="email" CssClass="form-control mb-2" aria-describedby="emailHelp"
                      onblur="validateEmail(this)" placeholder="Enter email" autocomplete="off">
                    </asp:TextBox>
                    <span id="emailError" runat="server" style="color: red"></span>
                  </div>

                  <div class="form-group">
                    <label for="gender">Gender: *</label>
                    <div>
                      <input type="radio" runat="server" GroupName="btnradio" ID="btnradio1" class="btn-check"
                        name="gender" value="Male" autocomplete="off" />
                      <label class="btn btn-outline-primary" for="btnradio1">Male</label>

                      <input type="radio" runat="server" GroupName="btnradio" ID="btnradio2" class="btn-check"
                        name="gender" value="Female" autocomplete="off" />
                      <label class="btn btn-outline-primary" for="btnradio2">Female</label>

                      <input type="radio" runat="server" GroupName="btnradio" ID="btnradio3" class="btn-check"
                        name="gender" value="Others" autocomplete="off" />
                      <label class="btn btn-outline-primary" for="btnradio3">Others</label>
                    </div>
                  </div>

                  <div class="form-group">
                    <label for="dateofbirth">Date Of Birth: *</label>
                    <asp:TextBox runat="server" ID="dob" CssClass="form-control mb-2" onchange="findage()"
                      autocomplete="off" required>
                    </asp:TextBox>
                  </div>

                  <div class="form-group">
                    <label for="Age">Age:</label>
                    <asp:TextBox runat="server" ID="age" CssClass="form-control" pattern="^\D{0,100}$" ReadOnly="true">
                    </asp:TextBox>
                  </div>

                  <!-- Modal Code -->
                  <div class="modal fade" runat="server" id="registrationModal" tabindex="-1" role="dialog"
                    aria-labelledby="registrationModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                      <div class="modal-content">
                        <div class="modal-header">
                          <h5 class="modal-title" runat="server" id="registrationModalLabel">
                            Modal Title
                          </h5>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" runat="server" id="registrationModalBody">
                          Modal Body
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Close
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="container-fluid">

                <asp:Button class="btn btn btn-info shadow" runat="server" Text="Register" title="Register" TabIndex="6"
                  ID="save" OnClientClick="return false;" />

                <!-- Add the loading animation here -->
                <div id="loadingAnimation" class="loading-animation">
                  <!-- Add your loading animation here, e.g., a spinner or any other animated content -->
                </div>
                
                <p class="signin">
                  Already have an account? <a href="../aspx/Signin.aspx">Click here</a> to Sign In
              </div>

            </div>
          </div>
        </div>
      </div>


      <div class="bg fixed">
        <img
          src="https://khatushyamtemple.in/wp-content/uploads/2022/12/Khatu-Shyam-Wallpaper-HD-Desktop-High-Quality.jpg" />
      </div>

      <div>
        <button onclick="topFunction()" id="myBtn" title="Back To Top">
          <img src="https://www.linkpicture.com/q/Up-Arrow.png" height="40px" width="40px" />
        </button>
      </div>
    </form>
  </body>

  </html>