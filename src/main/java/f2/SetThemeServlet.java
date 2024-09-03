package f2;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SetThemeServlet
 */
@WebServlet("/setTheme")
public class SetThemeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public SetThemeServlet() {
        super();
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the theme parameter from the request
        String theme = request.getParameter("theme");
        
        if (theme == null || (!theme.equals("light") && !theme.equals("dark"))) {
            // Default to light theme if invalid theme parameter is provided
            theme = "light";
        }

        // Get the current session, or create a new one if it does not exist
        HttpSession session = request.getSession();
        
        // Set the theme attribute in the session
        session.setAttribute("theme", theme);
        
        // Redirect back to the home page or any other page where the theme change should be reflected
        response.sendRedirect("home.jsp");
    }
}
