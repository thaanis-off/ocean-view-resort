package com.app.controller;

import com.app.service.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private GuestService guestService;
    private RoomService roomService;
    private RoomTypeService roomTypeService;
    private ReservationService reservationService;
    private PaymentService paymentService;
    private StaffService staffService;

    @Override
    public void init() {
        guestService = new GuestService();
        roomService = new RoomService();
        roomTypeService = new RoomTypeService();
        reservationService = new ReservationService();
        paymentService = new PaymentService();
        staffService = new StaffService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all statistics
            Map<String, Object> stats = new HashMap<>();
            
            // Guest Statistics
            stats.put("totalGuests", guestService.getAllGuests().size());
            
            // Room Statistics
            stats.put("totalRooms", roomService.getAllRooms().size());
            stats.put("availableRooms", roomService.getRoomCountByStatus("Available"));
            stats.put("occupiedRooms", roomService.getRoomCountByStatus("Occupied"));
            stats.put("maintenanceRooms", roomService.getRoomCountByStatus("Maintenance"));
            stats.put("reservedRooms", roomService.getRoomCountByStatus("Reserved"));
            
            // Calculate occupancy rate
            int totalActiveRooms = roomService.getAllRooms().size();
            int occupiedCount = roomService.getRoomCountByStatus("Occupied");
            double occupancyRate = totalActiveRooms > 0 ? 
                ((double) occupiedCount / totalActiveRooms) * 100 : 0;
            stats.put("occupancyRate", String.format("%.1f", occupancyRate));
            
            // Reservation Statistics
            stats.put("totalReservations", reservationService.getAllReservations().size());
            stats.put("pendingReservations", reservationService.getReservationCountByStatus("Pending"));
            stats.put("confirmedReservations", reservationService.getReservationCountByStatus("Confirmed"));
            stats.put("checkedInReservations", reservationService.getReservationCountByStatus("CheckedIn"));
            
            // Today's activities
            stats.put("todayCheckIns", reservationService.getTodayCheckIns().size());
            stats.put("todayCheckOuts", reservationService.getTodayCheckOuts().size());
            
            // Payment Statistics
            Map<String, BigDecimal> paymentStats = paymentService.getPaymentStatistics();
            stats.put("todayRevenue", paymentStats.get("totalReceived"));
            stats.put("todayCash", paymentStats.get("cashPayments"));
            stats.put("todayCard", paymentStats.get("cardPayments"));
            
            // Recent activities
            stats.put("recentReservations", reservationService.getAllReservations().stream().limit(5).toList());
            stats.put("recentPayments", paymentService.getAllPayments().stream().limit(5).toList());
            stats.put("todayCheckInsList", reservationService.getTodayCheckIns());
            stats.put("todayCheckOutsList", reservationService.getTodayCheckOuts());
            
            // Staff Statistics
           // stats.put("totalStaff", staffService.getAllStaffs().size());
            
            //request.setAttribute("stats", stats);
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}