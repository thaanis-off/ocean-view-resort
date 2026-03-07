package com.app.controller;

import com.app.model.Reservation;
import com.app.model.ExtraCharge;
import com.app.model.Guest;
import com.app.model.Room;
import com.app.model.Staff;
import com.app.service.ReservationService;
import com.app.service.StaffService;
import com.app.service.ExtraChargeService;
import com.app.service.GuestService;
import com.app.service.RoomService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ReservationService reservationService;
    private GuestService guestService;
    private RoomService roomService;
    private ExtraChargeService extraChargeService;


    @Override
    public void init() {
        reservationService = new ReservationService();
        guestService = new GuestService();
        roomService = new RoomService();
        extraChargeService = new ExtraChargeService();
        
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list": listReservations(request, response); break;
                case "new": showAddForm(request, response); break;
                case "edit": showEditForm(request, response); break;
                case "view": viewReservation(request, response); break;
                case "delete": deleteReservation(request, response); break;
                case "search": searchReservations(request, response); break;
                case "filter": filterReservations(request, response); break;
                case "checkIn": checkIn(request, response); break;
                case "checkOut": checkOut(request, response); break;
                case "cancel": cancelReservation(request, response); break;
                case "confirm": confirmReservation(request, response); break;
                default: listReservations(request, response); break;
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
                case "create": createReservation(request, response); break;
                case "update": updateReservation(request, response); break;
                default: listReservations(request, response); break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Reservation> reservationList = reservationService.getAllReservations();
        request.setAttribute("reservationList", reservationList);
        request.setAttribute("totalReservations", reservationList.size());
        request.setAttribute("pendingCount", reservationService.getReservationCountByStatus("Pending"));
        request.setAttribute("confirmedCount", reservationService.getReservationCountByStatus("Confirmed"));
        request.setAttribute("checkedInCount", reservationService.getReservationCountByStatus("CheckedIn"));
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("guests", guestService.getAllGuests());
        request.setAttribute("rooms", roomService.getAvailableRooms());
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Reservation reservation = reservationService.getReservationById(id);
        if (reservation == null) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&error=notfound");
            return;
        }
        request.setAttribute("guests", guestService.getAllGuests());
        request.setAttribute("rooms", roomService.getAllRooms());
        request.setAttribute("reservation", reservation);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation.jsp").forward(request, response);
    }

    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Reservation reservation = reservationService.getReservationById(id);
        if (reservation == null) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&error=notfound");
            return;
        }
        
     // --- NEW: Fetch Extra Charges for this specific reservation ---
        List<ExtraCharge> extraCharges = extraChargeService.getChargesByReservation(id);
        BigDecimal totalExtraCharges = extraChargeService.getTotalChargesForReservation(id);
        
        request.setAttribute("reservation", reservation);
        request.setAttribute("extraCharges", extraCharges);
        request.setAttribute("totalExtraCharges", totalExtraCharges);
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation-view.jsp").forward(request, response);
    }

    private void createReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            Reservation reservation = buildReservationFromRequest(request);
            
            BigDecimal calculatedTotal = reservationService.calculateReservationTotal(
                    reservation.getRoomId(),
                    reservation.getCheckInDate(),
                    reservation.getCheckOutDate()
            );
            reservation.setTotalAmount(calculatedTotal);
            
            reservationService.addReservation(reservation);
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&success=added");

        } catch (IllegalArgumentException e) {
            request.setAttribute("guests", guestService.getAllGuests());
            request.setAttribute("rooms", roomService.getAvailableRooms());
            request.setAttribute("errorMessage", e.getMessage()); // exact reason shown
            request.getRequestDispatcher("/WEB-INF/views/app-views/reservation.jsp").forward(request, response);
        }
    }

    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        Reservation reservation = buildReservationFromRequest(request);
        reservation.setId(Integer.parseInt(request.getParameter("id")));
        
        BigDecimal calculatedTotal = reservationService.calculateReservationTotal(
                reservation.getRoomId(), 
                reservation.getCheckInDate(), 
                reservation.getCheckOutDate()
        );
        reservation.setTotalAmount(calculatedTotal);
        
        boolean success = reservationService.updateReservation(reservation);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&success=updated");
        } else {
            request.setAttribute("guests", guestService.getAllGuests());
            request.setAttribute("rooms", roomService.getAllRooms());
            request.setAttribute("errorMessage", "Failed to update reservation.");
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/app-views/reservation.jsp").forward(request, response);
        }
    }

    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = reservationService.deleteReservation(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/reservation?action=list&error=cannotdelete");
        }
    }

    private void searchReservations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Reservation> reservationList = reservationService.searchReservations(keyword);
        request.setAttribute("reservationList", reservationList);
        request.setAttribute("totalReservations", reservationList.size());
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation-list.jsp").forward(request, response);
    }

    private void filterReservations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String status = request.getParameter("status");
        List<Reservation> reservationList = reservationService.getReservationsByStatus(status);
        request.setAttribute("reservationList", reservationList);
        request.setAttribute("totalReservations", reservationList.size());
        request.setAttribute("filterStatus", status);
        request.getRequestDispatcher("/WEB-INF/views/app-views/reservation-list.jsp").forward(request, response);
    }

    private void checkIn(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        reservationService.checkIn(id);
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + id + "&success=checkedin");
    }

    private void checkOut(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        reservationService.checkOut(id);
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + id + "&success=checkedout");
    }

    private void cancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        reservationService.cancelReservation(id);
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + id + "&success=cancelled");
    }

    private void confirmReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        reservationService.confirmReservation(id);
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + id + "&success=confirmed");
    }

    private Reservation buildReservationFromRequest(HttpServletRequest request) {
        Reservation r = new Reservation();
        r.setGuestId(Integer.parseInt(request.getParameter("guestId")));
        r.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        r.setCheckInDate(LocalDate.parse(request.getParameter("checkInDate")));
        r.setCheckOutDate(LocalDate.parse(request.getParameter("checkOutDate")));
        r.setNumAdults(Integer.parseInt(request.getParameter("numAdults")));
        r.setNumChildren(Integer.parseInt(request.getParameter("numChildren")));
        r.setStatus(request.getParameter("status"));
        r.setTotalAmount(new BigDecimal(request.getParameter("totalAmount")));
        r.setSpecialRequests(request.getParameter("specialRequests"));
        r.setSource(request.getParameter("source"));
        
        HttpSession session = request.getSession();
        Staff loggedInStaff = (Staff) session.getAttribute("loggedInStaff");
        r.setBookedBy(loggedInStaff != null ? loggedInStaff.getId() : null);

        return r;
    }
}