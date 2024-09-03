<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <!-- Include CSS based on the mode -->
    <%
        // Get the theme from session, default to light
        String theme = (String) session.getAttribute("theme");
        if (theme == null) {
            theme = "light"; // Default theme
        }
    %>
    <link rel="stylesheet" href="<%= theme %>index.css">
</head>

<body>
    <!-- Desktop Navbar -->
    <div class="navbar desktop-navbar">
        <ul>
            <li><a href="home.jsp">Foodie</a></li>
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="booktable.jsp">BookTable</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><img class="toggle-mode-button" src="modeicon.png"/></li>
            <li class="account">
                <div class="account-icon" onclick="toggleDesktopAccountMenu()">
                    <!-- Account Icon with the first three letters of the email -->
                    <span id="accountInitials1">
                        <%
                            String userId = (String) session.getAttribute("userId");
                            if (userId != null && userId.length() >= 3) {
                                out.print(userId.substring(0, 3).toUpperCase());
                            } else {
                                out.print("???"); // Default or placeholder text
                            }
                        %>
                    </span>
                </div>
            </li>
        </ul>
        <div id="desktopAccountMenu" class="account-menu">
      
    <% 
        String userName = (String) session.getAttribute("userName");
        String userId3 = (String) session.getAttribute("userId");
        if (userName != null && userId3 != null) {
    %>
        <p id="accountName"><%= userName %></p>
        <p id="accountEmail"><%= userId3 %></p>
        <form action="Logout" method="get" style="text-align:center;">
            <button class="listlogout" type="submit">Logout</button>
        </form>
 
    <% 
        } else {
    %>
        <p>Please log in</p>
        <form action="SessionCheckServlet" method="post" style="text-align:center;">
            <button type="submit" class="listlogout">Login</button>
        </form>
    <% 
        } 
    %>
</div>

    </div>


<!-- Mobile Navbar -->
<div class="navbar mobile-navbar">
     <button class="hamburger" onclick="toggleMenu()" style=" font-size: 25px;">☰</button>
    <div  class="mobile-foodie" style="display:inline;text-align:center; "> <a class="mobile-foodie" href="home.jsp" style="text-decoration:none;font-size:30px;font-family: 'Dancing Script', cursive;">Foodie</a>  </div>
    
     <div style="display:inline;margin-top:25px; margin-left:230px;"><img  class="toggle-mode-button" src="modeicon.png"/></div>
    <div style="display:inline;float:right; margin-top:-15px;"> <!-- Account Icon and Dropdown -->
        <div class="account">
            <div class="account-icon" onclick="toggleMobileAccountMenu()">
                <span id="accountInitials2">
                    <%
                        String userId1 = (String) session.getAttribute("userId");
                        if (userId1 != null && userId1.length() >= 3) {
                            out.print(userId1.substring(0, 3).toUpperCase());
                        } else {
                            out.print("???"); // Default or placeholder text
                        }
                    %>
                </span>
            </div>
            
        </div>
    <div class="dropdown-menu" id="dropdownMenu">
      
        <a href="menu.jsp">Menu</a>
        <a href="booktable.jsp">BookTable</a>
        <a href="about.jsp">About</a>
    </div>
    
    </div>
    <div id="mobileAccountMenu" class="account-menu" style="width:auto;">
    <% 
        String userName2 = (String) session.getAttribute("userName");
        String userId2 = (String) session.getAttribute("userId");
        if (userName2 != null && userId2 != null) {
    %>
        <p id="accountName"><%= userName2 %></p>
        <p id="accountEmail"><%= userId2 %></p>
        <form action="Logout" method="get" style="text-align:center;">
            <button class="listlogout" type="submit">Logout</button>
        </form>
  
    <% 
        } else {
    %>
        <p>Please log in</p>
        <form action="SessionCheckServlet" method="post" style="text-align:center;">
            <button type="submit" class="listlogout">Login</button>
        </form>
    <% 
        } 
    %>
</div>

</div>


<div class="login" id="loginForm" id="draggable" style="margin-top:130px;">
<form action="login" method="post">
<input type="text" name="lusername" placeholder="username" autocomplete="off" required><br><br>
<input type="text" name="lpassword" placeholder="password" autocomplete="off" required><br><br>
<input type="submit" value="login">
<br><br>
<button type="button" onclick="showSignupForm()" >Create Account</button>
</form>
</div>

<div class="signup1" id="signupForm" style="display: none;">
    <form action="Signup" method="post">
        <div class="whole">
            <div class="login">
                <input type="text" name="sfname" placeholder="First Name" autocomplete="off" required><br><br>
                <input type="text" name="slname" placeholder="Last Name" autocomplete="off"><br><br>
                <input type="email" name="email" placeholder="Email" autocomplete="off" required><br><br>
                <input type="text" name="susername" placeholder="Username" autocomplete="off" required><br><br>
            </div>
            <div class="login">
                <input type="password" name="spassword" placeholder="Password" autocomplete="off" required><br><br>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" autocomplete="off" required><br><br>
                <input type="text" name="phonenumber" placeholder="Phone Number" autocomplete="off" required><br><br>
                <input type="submit" value="Sign Up"><br><br>
            </div>
           
        </div>
    </form>
</div>
 <div class="login" id="backtologinbutton" style="display:none;" >
                <button type="button" onclick="showLoginForm()">Back to Login</button>
            </div>



  <script>
  function showSignupForm() {
      const signupForm = document.getElementById("signupForm");
      const loginForm = document.getElementById("loginForm");
      const backtologinbutton = document.getElementById("backtologinbutton")
      signupForm.style.display = "block";
      loginForm.style.display = "none";
      backtologinbutton.style.display="block";
  }

  function showLoginForm() {
      const signupForm = document.getElementById("signupForm");
      const loginForm = document.getElementById("loginForm");
      signupForm.style.display = "none";
      loginForm.style.display = "block";
      backtologinbutton.style.display="none";
  }
  
  
  function toggleMenu() {
      const menu = document.getElementById('dropdownMenu');
      if (menu.style.display === 'block') {
          menu.style.display = 'none';
      } else {
          menu.style.display = 'block';
      }
  }
  
  // Function for desktop navbar
  function toggleDesktopAccountMenu() {
      const desktopAccountMenu = document.getElementById("desktopAccountMenu");
      desktopAccountMenu.classList.toggle('show');
  }
//Function for mobile navbar
function toggleMobileAccountMenu() {
    const mobileAccountMenu = document.getElementById("mobileAccountMenu");
    mobileAccountMenu.classList.toggle('show');
}



//Check sessionStorage for current theme
const currentMode = sessionStorage.getItem('theme') || '<%= theme %>';

// Apply theme stored in sessionStorage on page load
document.querySelector('link[rel="stylesheet"]').setAttribute('href', currentMode + 'index.css');

// Toggle between light and dark mode
document.querySelectorAll('.toggle-mode-button').forEach(button => {
    button.addEventListener('click', function() {
        const newMode = currentMode === 'light' ? 'dark' : 'light';

        // Update the mode in session storage
        sessionStorage.setItem('theme', newMode);

        // Update the session attribute using AJAX call
        const xhr = new XMLHttpRequest();
        xhr.open('GET', `setTheme.jsp?theme=${newMode}`, true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                // Reload the page to apply the new theme
                location.reload();
            }
        };
        xhr.send();
    });
});



    </script>

</body>
</html>