package com.app.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/help")
public class HelpServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInStaff") == null) {
            response.sendRedirect(request.getContextPath() + "/login?status=sessionExpired");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "view";
        
        try {
            switch (action) {
                case "view":
                    showHelpPage(request, response);
                    break;
                default:
                    showHelpPage(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error loading help page: " + e.getMessage(), e);
        }
    }
    
    private void showHelpPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Forward to help JSP
        request.getRequestDispatcher("/WEB-INF/views/app-views/help.jsp")
               .forward(request, response);
    }
}