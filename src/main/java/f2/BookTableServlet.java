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

@WebServlet("/BookTableServlet")
public class BookTableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/restaurantmanagementsystemdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "tiger";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String tableSizeStr = request.getParameter("tableSize");
        int tableSize = Integer.parseInt(tableSizeStr);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("customerId") == null) {
                response.sendRedirect("index.jsp?error=Please login first");
                return;
            }
            int customerId = (Integer) session.getAttribute("customerId");

            String sql = "INSERT INTO table_booking (customer_id, table_size) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            pstmt.setInt(2, tableSize);
            pstmt.executeUpdate();

            out.println("<html><body><h1>Table booked successfully!</h1></body></html>");
            response.sendRedirect("wait.html");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        } finally {
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
