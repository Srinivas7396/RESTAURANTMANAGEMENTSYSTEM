package f2;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/restaurantmanagementsystemdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "tiger";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Register JDBC driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("{\"status\":\"error\",\"message\":\"JDBC Driver not found.\"}");
            out.flush();
            return;
        }

        // Retrieve feedback data
        int rating = Integer.parseInt(request.getParameter("rating"));
        String feedbackText = request.getParameter("feedback");
        String orderMode = request.getParameter("orderMode");  // Retrieve the order mode

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Retrieve the customer ID from the session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("customerId") == null) {
                response.sendRedirect("index.jsp?error=Please login first");
                return;
            }
            int customerId = (Integer) session.getAttribute("customerId");

            // Insert into feedback table
            String sql = "INSERT INTO feedback (customer_id, rating, feedback_text) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId); // Set customer_id
            pstmt.setInt(2, rating);
            pstmt.setString(3, feedbackText);
            pstmt.executeUpdate();

            // Redirect based on orderMode
            if ("Eat In".equals(orderMode)) {
                response.sendRedirect("booktable.jsp");
            } else {
                response.sendRedirect("wait.html");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle database errors
            out.println("{\"status\":\"error\",\"message\":\"Database error: " + e.getMessage() + "\"}");
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.flush();
    }
}
