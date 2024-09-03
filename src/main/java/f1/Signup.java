package f1;

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

/**
 * Servlet implementation class Signup
 */
@WebServlet("/Signup")
public class Signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Signup() {
        super();
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter pw = response.getWriter();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/restaurantmanagementsystemdb", "root", "tiger");

            String fname = request.getParameter("sfname");
            String lname = request.getParameter("slname");
            String email = request.getParameter("email");
            String username = request.getParameter("susername");
            String password = request.getParameter("spassword");
            String confirmPassword = request.getParameter("confirmPassword");
            String phonenumber = request.getParameter("phonenumber");

            if (password.equals(confirmPassword)) {
                String sql = "INSERT INTO signuptable (email, username, password, firstname, lastname, phonenumber) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, username);
                pstmt.setString(3, password);
                pstmt.setString(4, fname);
                pstmt.setString(5, lname);
                pstmt.setString(6, phonenumber);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    pw.println("""
                            <html>
                            <head>
                            <style>
                            body{
                            background-color:yellow;
                            text-align:center;
                            }
                            </style>
                            </head>
                                <body>
                                    <h1>Account created successfully!</h1>
                                    <form action='index.jsp'>
                                        <input type='submit' value='Login'>
                                    </form>
                                </body>
                            </html>
                        """);
                } else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
