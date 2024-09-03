package f2;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SessionCheckServlet
 */
@WebServlet("/SessionCheckServlet")
public class SessionCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SessionCheckServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current session, but don't create a new one if it doesn't exist
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("userId") != null) {
            // Session exists, redirect to the current page
            String currentPage = request.getHeader("Referer"); // Get the referring page URL
            if (currentPage != null) {
                response.sendRedirect(currentPage);
            } else {
                response.sendRedirect("home.jsp"); // Fallback to a default page if referer is not available
            }
        } else {
            // Session does not exist, redirect to login page
            response.sendRedirect("index.jsp");
        }
    }
}
