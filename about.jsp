<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Foodie</title>
      <!-- Include CSS based on the mode -->
    <%
        // Get the theme from session, default to light
        String theme = (String) session.getAttribute("theme");
        if (theme == null) {
            theme = "light"; // Default theme
        }
    %>
    <link rel="stylesheet" href="<%= theme %>about.css">
</head>
<body>
    <!-- Desktop Navbar -->
    <div class="navbar desktop-navbar">
        <ul>
            <li><a href="home.jsp">Foodie</a></li>
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="booktable.jsp">BookTable</a></li>
            <li><a href="about.jsp">About</a></li>
          
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
    <div class="mobile-foodie" style="display:inline;text-align:center; "> <a href="home.jsp" style="text-decoration:none;font-size:30px;font-family: 'Dancing Script', cursive;">Foodie</a>  </div>
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
    <div id="mobileAccountMenu" class="account-menu">
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

    <!-- Popup Modal -->
    <div id="loginPopup" class="popup-modal">
        <div class="popup-content">
            <span class="close-btn">&times;</span>
            <p>Please log in to continue.</p>
            <a href="index.jsp" class="login-link">Login</a>
        </div>
    </div>
 <!-- Main content -->
    <main class="about-content">
        <section class="hero">
            <div class="hero-text">
                <h1>Welcome to Foodie</h1>
                <p>Your culinary journey begins here!</p>
            </div>
        </section>

        <section class="about-section">
            <div class="container">
                <h2>Our Story</h2>
                <p>
                    Established in 1998, Foodie has been a cornerstone of our community, offering exceptional dining experiences and unforgettable memories. Our commitment to quality and passion for creating delicious dishes has earned us a place in the hearts of food enthusiasts across the region.
                </p>
                <h2>Our Mission</h2>
                <p>
                    At Foodie, we believe in serving fresh, locally-sourced ingredients to bring the best flavors to your table. Our chefs craft each dish with love and dedication, ensuring that every meal is an experience to remember.
                </p>
                <h2>Meet Our Team</h2>
                <div class="team">
                    <div class="team-member">
                        <img src="owner.jpg" alt="Head Chef">
                        <h3>KOIGURA SRINIVAS</h3>
                        <p>Founder</p>
                    </div>
                    <div class="team-member">
                        <img src="https://images.pexels.com/photos/2887541/pexels-photo-2887541.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" alt="Restaurant Manager">
                        <h3>EDLA SANTOSH REDDY</h3>
                        <p>Restaurant Manager</p>
                    </div>
                    <div class="team-member">
                        <img src="https://images.pexels.com/photos/3893753/pexels-photo-3893753.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" alt="Staff Member">
                        <h3>TUNGATURTHI ANUSHA</h3>
                        <p>Senior Staff</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="about-image">
            <img src="https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg" alt="Restaurant">
        </section>
    </main>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-section">
            <h2>Contact Us</h2>
            <p>Location</p>
            <p>Call +01 1234567890</p>
            <p>demo@gmail.com</p>
        </div>
        <div class="footer-section">
            <h2>Foodie</h2>
            <p>Necessary, making this the first true generator on the Internet.</p>
        </div>
        <div class="footer-section">
            <h2>Opening Hours</h2>
            <p>Everyday 10.00 AM - 10.00 PM</p>
        </div>
    </div>
    
    
    <script >
    
    
   
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
 // Function for mobile navbar
function toggleMobileAccountMenu() {
    const mobileAccountMenu = document.getElementById("mobileAccountMenu");
    mobileAccountMenu.classList.toggle('show');
}

 
 
// Function to check if the user is logged in
function checkLoginStatus() {
    // Example: Check if a specific session attribute exists
    var loggedIn = '<%= session.getAttribute("userId") != null %>';
    return loggedIn === 'true'; // Adjust based on actual session attribute check
}

// Function to show the popup
function showPopup() {
    document.getElementById('loginPopup').style.display = 'flex';
}

// Function to hide the popup
function hidePopup() {
    document.getElementById('loginPopup').style.display = 'none';
}

// Event listener for the close button
document.querySelector('.popup-modal .close-btn').addEventListener('click', hidePopup);

// Periodically check the login status
setInterval(function() {
    if (!checkLoginStatus()) {
        showPopup();
    }
}, 120000); // Check every 2 minutes (120000 ms)


// Check sessionStorage for current theme
const currentMode = sessionStorage.getItem('theme') || '<%= theme %>';

// Apply theme stored in sessionStorage on page load
document.querySelector('link[rel="stylesheet"]').setAttribute('href', currentMode + 'about.css');

// Toggle between light and dark mode
document.getElementById('toggleModeButton').addEventListener('click', function() {
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



    </script>
</body>
</html>
