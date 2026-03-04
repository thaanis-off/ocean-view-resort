package com.app.controller;

import com.app.model.Staff;
import com.app.service.StaffService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private StaffService staffService = new StaffService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth-views/register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read exactly what the JSP form sends
        String fullName  = request.getParameter("fullName");
        String email     = request.getParameter("email");
        String username  = request.getParameter("userName");
        String password  = request.getParameter("password");
        String role      = request.getParameter("role");

        // Basic validation
        if (password == null || password.length() < 8) {
            response.sendRedirect("register?status=invalid");
            return;
        }

        // Build Staff object
        // password field holds plain text here — Service layer will hash it
        Staff staff = new Staff();
        staff.setFullName(fullName);
        staff.setEmail(email);
        staff.setUsername(username);
        staff.setPasswordHash(password); // plain text — gets hashed in UserService
        staff.setRole(role);

        if (staffService.register(staff)) {
            response.sendRedirect("login?status=registered");
        } else {
            response.sendRedirect("register?status=error");
        }
    }
}