package com.app.controller;

import com.app.model.Staff;
import com.app.service.StaffService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private StaffService staffService = new StaffService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInStaff") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth-views/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // One field accepts both username and email
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password        = request.getParameter("password");

        Staff staff = staffService.login(usernameOrEmail, password);

        if (staff != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInStaff", staff);
            session.setAttribute("staffRole",     staff.getRole());
            session.setAttribute("staffName",     staff.getFullName());
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("login?status=error");
        }
    }
}