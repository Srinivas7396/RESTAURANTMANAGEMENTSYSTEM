<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Database connection parameters
    String dbUrl = "jdbc:mysql://localhost:3306/restaurantmanagementsystemdb";
    String dbUser = "root";
    String dbPassword = "tiger";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Map to store items for each category
    Map<String, List<Map<String, Object>>> categoryItems = new HashMap<>();

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish database connection
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Query for distinct categories
        String categoryQuery = "SELECT DISTINCT category FROM FoodItems";
        pstmt = conn.prepareStatement(categoryQuery);
        rs = pstmt.executeQuery();

        List<String> categories = new ArrayList<>();
        while (rs.next()) {
            categories.add(rs.getString("category"));
        }
        
        rs.close();
        pstmt.close();

        // Fetch and store items for each category
        for (String category : categories) {
            String query = "SELECT * FROM FoodItems WHERE category = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();

            List<Map<String, Object>> items = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getString("id"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getDouble("price"));
                item.put("image_url", rs.getString("image_url"));
                items.add(item);
            }

            categoryItems.put(category, items);

            rs.close();
            pstmt.close();
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close connection
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Menu Page</title>
    <%
        String theme = (String) session.getAttribute("theme");
        if (theme == null) {
            theme = "light"; // Default theme if not set
        }
    %>
    <link rel="stylesheet" href="<%= theme %>menu.css">
   
</head>
<body>
    <!-- Popup Modal -->
    <div id="loginPopup" class="popup-modal">
        <div class="popup-content">
            <span class="close-btn">&times;</span>
            <p>Please log in to continue.</p>
            <a href="index.jsp" class="login-link">Login</a>
        </div>
    </div>

<div class="navbar">
    <ul >
   
        <li class="hamburger-menu" >
           <a href="#" class="hamburger1" onclick="openNav()">&#9776;</a>
        </li>
          <li class=" mba" >
            <a href="#" class="hamburger2"  onclick="openNav2()">&#9776;</a>
        </li>
        <li class="brand"><a href="home.jsp">Foodie</a></li>
        <li class="nav-item hide"><a href="menu.jsp">Menu</a></li>
        <li class="nav-item  hide"><a href="booktable.jsp">BookTable</a></li>
        <li class="nav-item  hide"><a href="about.jsp">About</a></li>
        <li class="search-bar-container">
            <img src="searchbar.png" class="search-icon" onclick="searchItems()" alt="Search">
            <input type="text" id="searchBar" placeholder="Search for items..." onkeyup="searchItems()">
        </li>
          
        <li class="nav-item cart">
            <span class="spaced-element" onclick="displayQuantities()">
                <img class="cart-icon" src="foodwithcutlery.png" alt="food with cutlery" />
                <b><span id="cartCount" ></span></b>
            </span>
        </li>
<li class="nav-item">
    <div class="account-icon" onclick="toggleAccountMenu()">
        <!-- Account Icon with Initials -->
        <span id="accountInitials1">
            <% 
                String userId = (String) session.getAttribute("userId");
                if (userId != null && userId.length() >= 3) {
                    out.print(userId.substring(0, 3).toUpperCase());
                } else {
                    out.print("???");
                } 
            %>
       </span>
       </div> 
</li>

    </ul>
    
    
    <!-- Account Menu -->
        <div id="accountMenu" class="account-menu">
            <% 
                String userName = (String) session.getAttribute("userName");
                String userId1 = (String) session.getAttribute("userId");
                if (userName != null && userId1 != null) {
            %>
                <p id="accountName"><%= userName %></p>
                <p id="accountEmail"><%= userId1 %></p>
                <form action="Logout" method="get" style="text-align:center; display:inline;">
                    <button class="listlogout" type="submit">Logout</button>
                </form>
            <% 
                } else { 
            %>
                <p>Please log in</p>
                <form action="SessionCheckServlet" method="post" style="text-align:center;display:block;">
                    <button type="submit" class="listlogout">Login</button>
                </form>
            <% 
                } 
            %>
        </div>
    </div>

<!-- Side Navigation -->
<div id="sideNav" class="side-nav">
    <span class="closebtn" onclick="closeNav()">&times;</span>
    
    <%
        // Database connection details
        String dbURL1 = "jdbc:mysql://localhost:3306/restaurantmanagementsystemdb";
        String dbUser1 = "root";
        String dbPassword1 = "tiger";

        Connection conn1 = null;
        Statement stmt1 = null;
        ResultSet rs1 = null;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Open a connection
            conn1 = DriverManager.getConnection(dbURL1, dbUser1, dbPassword1);

            // Execute a query
            stmt1 = conn1.createStatement();
            String sql1 = "SELECT DISTINCT category FROM FoodItems";
            rs1 = stmt1.executeQuery(sql1);

            // Process the result set
            while (rs1.next()) {
                String category1 = rs1.getString("category");
    %>
                <a href="#<%= category1 %>" onclick="setActive(this)"><%= category1 %></a>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p>Error retrieving categories.</p>
    <%
        } finally {
            // Clean up environment
            try {
                if (rs1 != null) rs1.close();
                if (stmt1 != null) stmt1.close();
                if (conn1 != null) conn1.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    %>
</div>
<div id="sideNav2" class="side-nav">
    <a href="javascript:void(0)" class="closebtn" onclick="closeNav2()">&times;</a>
    <a href="menu.jsp">Menu</a>
    <a href="booktable.jsp">BookTable</a>
    <a href="about.jsp">About</a>
</div>





<div class="all">
      <% for (Map.Entry<String, List<Map<String, Object>>> categoryEntry : categoryItems.entrySet()) { %>
       <br> <div id="<%= categoryEntry.getKey() %>">
            <br>
            <br>
            <h2><%= categoryEntry.getKey() %></h2>
            <div class="row">
                <% for (Map<String, Object> item : categoryEntry.getValue()) { %>
                    <div class="card">
                        <img src="<%= item.get("image_url") %>" alt="<%= item.get("name") %>">
                        <div class="container">
                            <h4><%= item.get("name") %></h4>
                            <p class="item-price">₹<%= item.get("price") %></p>
                            <div class="quantity-controls">           
                                <button class="minus" onclick="changeQuantity('<%= item.get("id") %>', -1)">-</button>
                                <input type="number" class="quantity-input" id="<%= item.get("id") %>" name="quantity" min="0" value="0" readonly>
                                <button class="plus" onclick="changeQuantity('<%= item.get("id") %>', 1)">+</button>
                            </div> 
                            <button class="add" onclick="addToOrders('<%= item.get("id") %>', '<%= item.get("name") %>', <%= item.get("price") %>)">&nbsp;&nbsp;Add&nbsp;&nbsp;</button>
                            <button class="cancel" onclick="cancelItem('<%= item.get("id") %>')">Cancel</button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    <% } %>
   </div> 
  <!-- Modal for order summary -->
  <div id="popupModal" class="modal">
      <div class="modal-content">
          <span class="close" onclick="closeModal()" style="font-size:25px;">&times;</span>
          <h2>Finalize your order and continue to payment?</h2>
   
        
          <button id="continueButton" class="btn" onclick="continueAction()">Continue</button>
      </div>
  </div>

  <audio id="button-sound" src="buttonsound.mp3" preload="auto"></audio>
  <audio id="kichiksound" src="kichiksound.mp3" preload="auto"></audio>
   
   
    <!-- Floating Back to Top Button with Icon Image -->
  <!-- Floating Back to Top Button with Icon Image -->
<div class="back-to-top" id="backToTop">
    <!-- No need for an img tag since we'll use background-image in CSS -->
</div>

    
    <!--  javascript code -->
 
    <script type="text/javascript">
    // Dictionary to store quantities dynamically
    let quantities = {};
    let cartCount = 0;

    // Function to change quantity
    function changeQuantity(inputId, delta) {
        playPlusMinusSound();
        let quantityInput = document.getElementById(inputId);
        let currentQuantity = parseInt(quantityInput.value);
        let newQuantity = currentQuantity + delta;

        if (newQuantity < 0) newQuantity = 0;
        if (newQuantity > 10) newQuantity = 10; // Optional: max limit

        quantityInput.value = newQuantity;

        // Optional alert for max limit
        if (newQuantity === 10) {
            alert("Maximum quantity reached!");
        }
    }

    function addToOrders(inputId, itemName, itemPrice) {
  	    playSound(); // Play sound when button is pressed
  	    let quantityInput = document.getElementById(inputId);
  	    let currentQuantity = parseInt(quantityInput.value);

  	    if (!quantities[inputId]) {
  	        quantities[inputId] = { name: itemName, price: itemPrice, quantity: 0 };
  	    }

  	    quantities[inputId].quantity += currentQuantity; // Update quantity in dictionary

  	    // Store updated quantities in local storage
  	    localStorage.setItem('quantities', JSON.stringify(quantities));

  	    // Update cart count
  	    cartCount += currentQuantity;
  	    document.getElementById('cartCount').innerText = cartCount;

  	    // Make cart icon rotate
  	    let cartIcon = document.querySelector('.cart-icon');
  	    cartIcon.classList.add('rotate');
  	    setTimeout(() => {
  	        cartIcon.classList.remove('rotate');
  	    }, 1000); // Remove rotate class after 1 second

  
  	}

    // Function to cancel an item
    function cancelItem(inputId) {
        if (quantities[inputId]) {
            // Update cart count
            cartCount -= quantities[inputId].quantity;

            // Remove the item from quantities
            delete quantities[inputId];

            // Update local storage
            localStorage.setItem('quantities', JSON.stringify(quantities));

            // Update cart count in UI
            document.getElementById('cartCount').innerText = cartCount;

            // Reset the input field to 0 after cancellation
            document.getElementById(inputId).value = 0;

            // Debug: confirm item removal
            console.log(`Removed ${inputId}. Updated Quantities:`, quantities);
        }
    }

    // Preload the audio on page load
    window.addEventListener('load', () => {
        const buttonSound = document.getElementById('button-sound');
        buttonSound.load();

        const plusMinusSound = document.getElementById('kichiksound');
        plusMinusSound.load();

        // Clear local storage when the page loads
        localStorage.removeItem('quantities');
        localStorage.removeItem('totalAmount');
    });

    // Function to play sound
    function playSound() {
        const sound = document.getElementById('button-sound');
        sound.play();
    }

    function playPlusMinusSound() {
        const sound = document.getElementById('kichiksound');
        sound.play();
    }

    // Function to open the modal
    function openModal() {
        const modal = document.getElementById('popupModal');
        modal.style.display = 'flex'; // Use 'flex' to match the CSS for centering
    }

    // Function to close the modal
    function closeModal() {
        const modal = document.getElementById('popupModal');
        modal.style.display = 'none';
    }


    function displayQuantities() {
  
  	    openModal(); // Open the modal after setting the content
  	}


    // Close the modal when clicking outside the modal-content
    window.onclick = function(event) {
        const modal = document.getElementById('popupModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // Listen for Escape key to close modal
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });

    // Function to continue to the next page
    function continueAction() {
        // Retrieve the quantities from local storage
        const quantities = JSON.parse(localStorage.getItem('quantities')) || {};

        // Check if the quantities object is empty
        if (Object.keys(quantities).length === 0) {
            alert("Please select your meal before continuing.");
            return; // Stop further execution
        }

        // Calculate total amount
        let totalAmount = 0;
        for (const key in quantities) {
            if (quantities.hasOwnProperty(key)) {
                const item = quantities[key];
                totalAmount += item.quantity * item.price;
            }
        }

        // Store the total amount in local storage
        localStorage.setItem('totalAmount', totalAmount);

        // Debug: Log the total amount
        console.log('Total Amount:', totalAmount);

        // Redirect to the next page
        window.location.href = 'next1.html';
    }
    
 // JavaScript for controlling sideNav with hamburger1
function openNav() {
    const sideNav = document.getElementById("sideNav");
    sideNav.style.width = window.innerWidth <= 768 ? '180px' : '300px'; // Adjust width based on screen size
    sideNav.classList.add("open");
}

function closeNav() {
    const sideNav = document.getElementById("sideNav");
    sideNav.style.width = "0"; // Reset the width when closing
    sideNav.classList.remove("open");
}
    function setActive(element) {
        var items = document.querySelectorAll('.side-nav a');
        items.forEach(function(item) {
            item.classList.remove('active');
        });
        element.classList.add('active');
    }

  

    // JavaScript for controlling sideNav2 with hamburger2
function openNav2() {
  const width = window.innerWidth <= 768 ? '180px' : '300px'; // Adjust width based on screen size
  document.getElementById("sideNav2").style.width = width;
  document.addEventListener('click', closeNav2OnClickOutside);
}

function closeNav2() {
  document.getElementById("sideNav2").style.width = "0";
  document.removeEventListener('click', closeNav2OnClickOutside);
}

    function closeNav2OnClickOutside(event) {
        const sideNav2 = document.getElementById("sideNav2");
        const hamburger2 = document.querySelector('.hamburger2');
        
        if (!sideNav2.contains(event.target) && !hamburger2.contains(event.target)) {
            closeNav2();
        }
    }


  	
 // Search functionality
// Search functionality
function searchItems() {
    const input = document.getElementById('searchBar').value.toLowerCase();
    const items = document.querySelectorAll('.card');
    let firstMatchFound = false;

    items.forEach(item => {
        const title = item.querySelector('h4').textContent.toLowerCase();
        if (title.includes(input)) {
            if (!firstMatchFound) {
                // Scroll the first match into view and center it
                item.scrollIntoView({ behavior: 'smooth', block: 'center' });

                // Wait for the scroll to finish before starting the swirl animation
                setTimeout(() => {
                    // Add the vertical swirl animation class
                    item.classList.add('vertical-swirl');

                    // Remove the swirl animation class after it completes
                    setTimeout(() => {
                        item.classList.remove('vertical-swirl');
                    }, 2000); // Swirl animation duration (1 second)

                }, 500); // Adjust this delay to match the scroll behavior time
                firstMatchFound = true; // Set the flag to true after processing the first match
            }
        }
    });
}

  	
  	function toggleAccountMenu() {
  	    const accountMenu = document.getElementById("accountMenu");

  	    // Toggle the display of the account menu
  	    if (accountMenu.classList.contains('show')) {
  	        accountMenu.classList.remove('show');
  	    } else {
  	        accountMenu.classList.add('show');
  	    }
  	}

  	
  	document.addEventListener('click', function(event) {
  	    const accountIcon = document.querySelector('.account-icon');
  	    const accountMenu = document.getElementById('accountMenu');

  	    // Check if the click was outside the account menu and the account icon
  	    if (!accountIcon.contains(event.target) && !accountMenu.contains(event.target)) {
  	        accountMenu.classList.remove('show');
  	    }
  	});

  	 
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
     
     
     
     // Get the button
     var backToTopButton = document.getElementById("backToTop");

     // Show the button when the user scrolls down 100px from the top
     window.onscroll = function() {
         if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
             backToTopButton.style.display = "block";
         } else {
             backToTopButton.style.display = "none";
         }
     };

     // Scroll to the top when the button is clicked
     backToTopButton.onclick = function() {
         window.scrollTo({
             top: 0,
             behavior: 'smooth' // Smooth scrolling
         });
     };
     
     

  // Check sessionStorage for current theme
  const currentMode = sessionStorage.getItem('theme') || '<%= theme %>';

  // Apply theme stored in sessionStorage on page load
  document.querySelector('link[rel="stylesheet"]').setAttribute('href', currentMode + 'menu.css');

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