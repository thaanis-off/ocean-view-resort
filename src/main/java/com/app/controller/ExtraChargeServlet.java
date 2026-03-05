package com.app.controller;

import com.app.model.ExtraCharge;
import com.app.model.Staff;
import com.app.service.ExtraChargeService;
import com.app.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/extraCharge")
public class ExtraChargeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ExtraChargeService extraChargeService;
    private ReservationService reservationService; 

    @Override
    public void init() {
        extraChargeService = new ExtraChargeService();
        reservationService = new ReservationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "new":
                    showAddForm(request, response);
                    break;
                case "delete":
                    deleteCharge(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/reservation?action=list");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "create":
                    createCharge(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/reservation?action=list");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ─── SHOW FORM ───────────────────────────────────────────────────────────
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        
        // Pass the reservation details to the JSP so we know who we are charging
        request.setAttribute("reservation", reservationService.getReservationById(reservationId));
        
        // Forward to the new JSP file we are going to create next
        request.getRequestDispatcher("/WEB-INF/views/app-views/extracharge-form.jsp").forward(request, response);
    }

    // ─── SAVE TO DATABASE ────────────────────────────────────────────────────
    private void createCharge(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        // Get the staff member who is logged in
        HttpSession session = request.getSession();
        Staff loggedInStaff = (Staff) session.getAttribute("loggedInStaff");

        // Grab form data
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));
        LocalDate chargeDate = LocalDate.parse(request.getParameter("chargeDate"));
        
        int addedBy = (loggedInStaff != null) ? loggedInStaff.getId() : 1; 

        ExtraCharge charge = new ExtraCharge(reservationId, description, category, amount, chargeDate, addedBy);

        boolean success = extraChargeService.addExtraCharge(charge);

        if (success) {
            // Send them straight back to the Reservation profile page so they can see the new charge!
            response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId + "&success=charge_added");
        } else {
            response.sendRedirect(request.getContextPath() + "/extraCharge?action=new&reservationId=" + reservationId + "&error=failed");
        }
    }

    // ─── DELETE CHARGE ───────────────────────────────────────────────────────
    private void deleteCharge(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        int reservationId = Integer.parseInt(request.getParameter("reservationId")); // We need this to redirect back!

        boolean success = extraChargeService.deleteExtraCharge(id);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId + "&success=charge_deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId + "&error=charge_delete_failed");
        }
    }
}