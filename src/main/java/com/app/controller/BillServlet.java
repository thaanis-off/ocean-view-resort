package com.app.controller;

import com.app.model.Bill;
import com.app.model.Staff;
import com.app.service.BillService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private BillService billService;
    
    @Override
    public void init() {
        billService = new BillService();
    }
    
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
        if (action == null) action = "generate";
        
        try {
            switch (action) {
                case "generate":
                case "view":
                    viewBill(request, response);
                    break;
                case "print":
                    printBill(request, response);
                    break;
                default:
                    viewBill(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
    
    private void viewBill(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        Bill bill = billService.generateBill(reservationId);
        
        if (bill == null) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&error=notfound");
            return;
        }
        
        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/WEB-INF/views/app-views/bill-view.jsp")
               .forward(request, response);
    }
    
    private void printBill(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        Bill bill = billService.generateBill(reservationId);
        
        if (bill == null) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&error=notfound");
            return;
        }
        
        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/WEB-INF/views/app-views/bill-print.jsp")
               .forward(request, response);
    }
}