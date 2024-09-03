package f2;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/restaurantmanagementsystemdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "tiger";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body><h1>JDBC Driver not found.</h1></body></html>");
            return;
        }

        String orderDataJson = request.getParameter("orderData");
        String totalAmountStr = request.getParameter("totalAmount");
        String orderMode = request.getParameter("orderMode");  // Get the order mode

        JSONObject orderData = new JSONObject(orderDataJson);
        double totalAmount = Double.parseDouble(totalAmountStr);
        JSONArray itemsArray = new JSONArray();

        JSONObject quantities = orderData.getJSONObject("quantities");
        quantities.keys().forEachRemaining(key -> {
            JSONObject item = quantities.getJSONObject(key);
            JSONObject formattedItem = new JSONObject();
            formattedItem.put("name", item.getString("name"));
            formattedItem.put("quantity", item.getInt("quantity"));
            formattedItem.put("price", item.getDouble("price"));
            itemsArray.put(formattedItem);
        });

        Connection conn = null;
        PreparedStatement pstmtOrder = null;
        PreparedStatement pstmtItem = null;
        ResultSet generatedKeys = null;

        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false);

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("customerId") == null) {
                response.sendRedirect("index.jsp?error=Please login first");
                return;
            }
            int customerId = (Integer) session.getAttribute("customerId");

            String sqlOrder = "INSERT INTO orders (customer_id, total_amount, order_mode, timestamp) VALUES (?, ?, ?, NOW())";
            pstmtOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            pstmtOrder.setInt(1, customerId);
            pstmtOrder.setDouble(2, totalAmount);
            pstmtOrder.setString(3, orderMode);  // Save the order mode
            pstmtOrder.executeUpdate();

            generatedKeys = pstmtOrder.getGeneratedKeys();
            if (generatedKeys.next()) {
                long orderId = generatedKeys.getLong(1);

                String sqlItem = "INSERT INTO order_items (order_id, name, quantity, single_item_price) VALUES (?, ?, ?, ?)";
                pstmtItem = conn.prepareStatement(sqlItem);

                for (int i = 0; i < itemsArray.length(); i++) {
                    JSONObject item = itemsArray.getJSONObject(i);
                    pstmtItem.setLong(1, orderId);
                    pstmtItem.setString(2, item.getString("name"));
                    pstmtItem.setInt(3, item.getInt("quantity"));
                    pstmtItem.setDouble(4, item.getDouble("price"));
                    pstmtItem.addBatch();
                }
                pstmtItem.executeBatch();
                conn.commit();

                // Redirect to feedback form with appropriate action based on orderMode
                String feedbackFormAction = orderMode.equals("Eat In") ? "booktable.jsp" : "wait.html";

                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("    <style>");
                out.println("        body {");
                out.println("            background-color: #333;");
                out.println("            text-align: center;");
                out.println("            font-family: Arial, sans-serif;");
                out.println("            color: #333;");
                out.println("            margin: 0;");
                out.println("            padding: 0;");
                out.println("        }");
                out.println("        .container {");
                out.println("            max-width: 650px;");
                out.println("            margin: auto;");
                out.println("            padding: 20px;");
                out.println("        }");
                out.println("        .message {");
                out.println("            margin-top: 20%;");
                out.println("            font-size: 50px;");
                out.println("            font-weight: bold;");
                out.println("            color: rgb(238, 235, 74);");
                out.println("        }");
                out.println("        .feedback-form {");
                out.println("            margin-top: 40px;");
                out.println("            background: rgb(90, 244, 90);");
                out.println("            border-radius: 8px;");
                out.println("            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);");
                out.println("            padding: 20px;");
                out.println("            text-align: left;");
                out.println("        }");
                out.println("        .feedback-form h2 {");
                out.println("            font-size: 20px;");
                out.println("            margin-bottom: 20px;");
                out.println("            color: #333;");
                out.println("        }");
                out.println("        .feedback-form label {");
                out.println("            display: block;");
                out.println("            margin-bottom: 8px;");
                out.println("            font-weight: bold;");
                out.println("        }");
                out.println("        .feedback-form textarea {");
                out.println("            width: 100%;");
                out.println("            padding: 10px;");
                out.println("            margin-bottom: 20px;");
                out.println("            border: 1px solid #ddd;");
                out.println("            border-radius: 4px;");
                out.println("        }");
                out.println("        .feedback-form button {");
                out.println("            background-color: #007bff;");
                out.println("            color: #fff;");
                out.println("            border: none;");
                out.println("            padding: 10px 20px;");
                out.println("            border-radius: 4px;");
                out.println("            cursor: pointer;");
                out.println("            font-size: 16px;");
                out.println("        }");
                out.println("        .feedback-form button:hover {");
                out.println("            background-color: #0056b3;");
                out.println("        }");
                out.println("        .star-rating {");
                out.println("            direction: rtl;");
                out.println("            display: inline-block;");
                out.println("            font-size: 0;");
                out.println("            position: relative;");
                out.println("            unicode-bidi: bidi-override;");
                out.println("        }");
                out.println("        .star-rating input {");
                out.println("            position: absolute;");
                out.println("            opacity: 0;");
                out.println("        }");
                out.println("        .star-rating label {");
                out.println("            display: inline-block;");
                out.println("            font-size: 30px;");
                out.println("            color: #ddd;");
                out.println("            cursor: pointer;");
                out.println("            padding: 0;");
                out.println("            margin: 0;");
                out.println("        }");
                out.println("        .star-rating input:checked ~ label,");
                out.println("        .star-rating input:checked ~ label ~ label {");
                out.println("            color: #f39c12;");
                out.println("        }");
                out.println("        .star-rating input:focus:not(:checked) ~ label:hover,");
                out.println("        .star-rating input:focus:not(:checked) ~ label:hover ~ label {");
                out.println("            color: #f1c40f;");
                out.println("        }");
                out.println("    </style>");
                out.println("</head>");
                out.println("<body>");
                out.println("    <div class=\"container\">");
                out.println("        <div class=\"message\">Order placed successfully!</div>");
                out.println("        <div class=\"feedback-form\">");
                out.println("            <h2>We Value Your Feedback</h2>");
                out.println("            <form action=\"FeedbackServlet\" method=\"post\">");
                out.println("                <input type=\"hidden\" name=\"orderMode\" value=\"" + orderMode + "\">");
                out.println("                <label>Rating:</label>");
                out.println("    <div class=\"star-rating\">");
                out.println("        <input type=\"radio\" id=\"star5\" name=\"rating\" value=\"5\" required><label for=\"star5\">&#9733;</label>");
                out.println("        <input type=\"radio\" id=\"star4\" name=\"rating\" value=\"4\"><label for=\"star4\">&#9733;</label>");
                out.println("        <input type=\"radio\" id=\"star3\" name=\"rating\" value=\"3\"><label for=\"star3\">&#9733;</label>");
                out.println("        <input type=\"radio\" id=\"star2\" name=\"rating\" value=\"2\"><label for=\"star2\">&#9733;</label>");
                out.println("        <input type=\"radio\" id=\"star1\" name=\"rating\" value=\"1\"><label for=\"star1\">&#9733;</label>");
                out.println("    </div>");

                out.println("                <label for=\"feedback\">Feedback:</label>");
                out.println("                <textarea id=\"feedback\" name=\"feedback\" rows=\"5\" required></textarea>");
                out.println("                <button type=\"submit\">Submit Feedback</button>");
                out.println("                <a href=\"" + feedbackFormAction + "\"><button type=\"button\" style=\"background-color: #6c757d; margin-left: 10px;\">Skip</button></a>");
                out.println("            </form>");
                out.println("        </div>");
                out.println("    </div>");
                out.println("</body>");
                out.println("</html>");
            } else {
                conn.rollback();
                out.println("<html><body><h1>Order creation failed, please try again.</h1></body></html>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<html><body><h1>Database error: " + e.getMessage() + "</h1></body></html>");
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        } finally {
            try {
                if (pstmtOrder != null) pstmtOrder.close();
                if (pstmtItem != null) pstmtItem.close();
                if (conn != null) conn.close();
                if (generatedKeys != null) generatedKeys.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.flush();
    }
}
