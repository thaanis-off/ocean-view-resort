package com.app.controller;

import com.app.model.Payment;
import com.app.model.Reservation;
import com.app.model.Staff;
import com.app.service.PaymentService;
import com.app.service.ReservationService;
import com.app.service.StaffService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private PaymentService paymentService;
    private ReservationService reservationService;
    private StaffService staffService;

    @Override
    public void init() {
        paymentService = new PaymentService();
        reservationService = new ReservationService();
        staffService = new StaffService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list": listPayments(request, response); break;
                case "new": showAddForm(request, response); break;
                case "edit": showEditForm(request, response); break;
                case "view": viewPayment(request, response); break;
                case "delete": deletePayment(request, response); break;
                case "search": searchPayments(request, response); break;
                case "filter": filterPayments(request, response); break;
                case "byReservation": paymentsByReservation(request, response); break;
                default: listPayments(request, response); break;
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
                case "create": createPayment(request, response); break;
                case "update": updatePayment(request, response); break;
                default: listPayments(request, response); break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Payment> paymentList = paymentService.getAllPayments();
        Map<String, BigDecimal> stats = paymentService.getPaymentStatistics();
        
        request.setAttribute("paymentList", paymentList);
        request.setAttribute("totalPayments", paymentList.size());
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Reservation> reservations = reservationService.getAllReservations();
       
        
        // If reservation ID is provided, pre-select it
        String reservationIdParam = request.getParameter("reservationId");
        if (reservationIdParam != null) {
            int reservationId = Integer.parseInt(reservationIdParam);
            Reservation reservation = reservationService.getReservationById(reservationId);
            request.setAttribute("selectedReservation", reservation);
            
            // Calculate balance due
            BigDecimal totalPaid = paymentService.getTotalPaidForReservation(reservationId);
            BigDecimal balanceDue = reservation.getTotalAmount().subtract(totalPaid);
            request.setAttribute("totalPaid", totalPaid);
            request.setAttribute("balanceDue", balanceDue);
        }
        
        request.setAttribute("reservations", reservations);
       
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Payment payment = paymentService.getPaymentById(id);
        if (payment == null) {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&error=notfound");
            return;
        }
        
        List<Reservation> reservations = reservationService.getAllReservations();
    
        
        request.setAttribute("reservations", reservations);
     
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment.jsp").forward(request, response);
    }

    private void viewPayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Payment payment = paymentService.getPaymentById(id);
        if (payment == null) {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&error=notfound");
            return;
        }
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment-view.jsp").forward(request, response);
    }

    private void createPayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        Payment payment = buildPaymentFromRequest(request);
        boolean success = paymentService.addPayment(payment);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&success=added");
        } else {
            List<Reservation> reservations = reservationService.getAllReservations();
           
            request.setAttribute("reservations", reservations);
          
            request.setAttribute("errorMessage", "Failed to add payment. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/app-views/payment.jsp").forward(request, response);
        }
    }

    private void updatePayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        Payment payment = buildPaymentFromRequest(request);
        payment.setId(Integer.parseInt(request.getParameter("id")));
        boolean success = paymentService.updatePayment(payment);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&success=updated");
        } else {
            List<Reservation> reservations = reservationService.getAllReservations();
           
            request.setAttribute("reservations", reservations);
        
            request.setAttribute("errorMessage", "Failed to update payment.");
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/WEB-INF/views/app-views/payment.jsp").forward(request, response);
        }
    }

    private void deletePayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = paymentService.deletePayment(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/payment?action=list&error=cannotdelete");
        }
    }

    private void searchPayments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Payment> paymentList = paymentService.searchPayments(keyword);
        Map<String, BigDecimal> stats = paymentService.getPaymentStatistics();
        
        request.setAttribute("paymentList", paymentList);
        request.setAttribute("totalPayments", paymentList.size());
        request.setAttribute("keyword", keyword);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment-list.jsp").forward(request, response);
    }

    private void filterPayments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        
        List<Payment> paymentList;
        if ("method".equals(filterType)) {
            paymentList = paymentService.getPaymentsByMethod(filterValue);
        } else if ("type".equals(filterType)) {
            paymentList = paymentService.getPaymentsByType(filterValue);
        } else {
            paymentList = paymentService.getAllPayments();
        }
        
        Map<String, BigDecimal> stats = paymentService.getPaymentStatistics();
        request.setAttribute("paymentList", paymentList);
        request.setAttribute("totalPayments", paymentList.size());
        request.setAttribute("filterType", filterType);
        request.setAttribute("filterValue", filterValue);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment-list.jsp").forward(request, response);
    }

    private void paymentsByReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        List<Payment> paymentList = paymentService.getPaymentsByReservation(reservationId);
        Reservation reservation = reservationService.getReservationById(reservationId);
        
        BigDecimal totalPaid = paymentService.getTotalPaidForReservation(reservationId);
        BigDecimal totalRefunded = paymentService.getTotalRefundedForReservation(reservationId);
        BigDecimal balanceDue = reservation.getTotalAmount().subtract(totalPaid).add(totalRefunded);
        
        request.setAttribute("paymentList", paymentList);
        request.setAttribute("reservation", reservation);
        request.setAttribute("totalPaid", totalPaid);
        request.setAttribute("totalRefunded", totalRefunded);
        request.setAttribute("balanceDue", balanceDue);
        request.getRequestDispatcher("/WEB-INF/views/app-views/payment-by-reservation.jsp").forward(request, response);
    }

    private Payment buildPaymentFromRequest(HttpServletRequest request) {
        Payment p = new Payment();
        p.setReservationId(Integer.parseInt(request.getParameter("reservationId")));
        p.setAmount(new BigDecimal(request.getParameter("amount")));
        p.setPaymentMethod(request.getParameter("paymentMethod"));
        p.setPaymentType(request.getParameter("paymentType"));
        p.setReferenceNumber(request.getParameter("referenceNumber"));
        
        HttpSession session = request.getSession();
        Staff loggedInStaff = (Staff) session.getAttribute("loggedInStaff");
        p.setReceivedBy(loggedInStaff != null ? loggedInStaff.getId() : null);
        
        p.setNotes(request.getParameter("notes"));
        return p;
    }
}