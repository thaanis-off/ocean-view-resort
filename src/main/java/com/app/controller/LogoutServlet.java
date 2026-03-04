package com.app.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session and destroy it
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // ← destroys all session attributes
        }

        // Now redirect to login
        response.sendRedirect(request.getContextPath() + "/login?status=loggedout");
    }
}