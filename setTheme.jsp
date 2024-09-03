<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Set Theme</title>
</head>
<body>

<%
    // Get the 'theme' parameter from the request
    String theme = request.getParameter("theme");

    // Check if the theme parameter is not null
    if (theme != null) {
        String cssFile;
        if ("dark".equals(theme)) {
            cssFile = "dark";
        } else {
            cssFile = "light";
        }

        // Store the theme in the session using the existing session object
        session.setAttribute("theme", cssFile);

        // Send a response back confirming the change
        response.getWriter().write("Theme set to: " + cssFile);
    } else {
        // If no theme is provided, default to light
        session.setAttribute("theme", "light");
        response.getWriter().write("Theme set to default (light)");
    }
%>

</body>
</html>
