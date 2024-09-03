package f1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Login() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/restaurantmanagementsystemdb", "root", "tiger");

            // Get the username and password from the request
            String username = request.getParameter("lusername");
            String password = request.getParameter("lpassword");

            // SQL query to retrieve customer_id, email, and username based on username and password
            String sql = "SELECT customer_id, email, username FROM signuptable WHERE username = ? AND password = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Retrieve customer_id, email, and username
                int customerId = rs.getInt("customer_id");
                String userId = rs.getString("email");
                String userName = rs.getString("username");
              

                // Create a session and store the user ID, customer ID, and userName
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("customerId", customerId);
                session.setAttribute("userName", userName);
              
                
               

                // Set session timeout to 5 hours (5 hours * 60 minutes/hour * 60 seconds/minute)
                session.setMaxInactiveInterval(5 * 60 * 60);

                // Redirect to a welcome page or home page
                response.sendRedirect("home.jsp"); // Example redirection
            } else {
                // Redirect to login page with an error message
                response.sendRedirect("index.jsp?error=Invalid credentials");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=Database error");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=Driver not found");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
