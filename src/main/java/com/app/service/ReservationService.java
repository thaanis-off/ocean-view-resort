package com.app.service;

import com.app.dao.ReservationDAO;
import com.app.dao.RoomDAO;
import com.app.dao.RoomTypeDAO;
import com.app.dao.SeasonalRateDAO;
import com.app.model.Reservation;
import com.app.model.Room;
import com.app.model.RoomType;
import com.app.model.SeasonalRate;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class ReservationService {

    private ReservationDAO reservationDAO = new ReservationDAO();
    private RoomDAO roomDAO = new RoomDAO();
    private RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private 	SeasonalRateDAO	seasonalRateDAO = new SeasonalRateDAO();

    // ─── ADD new reservation ──────────────────────────────────────────────────
    public boolean addReservation(Reservation reservation) throws SQLException {
    	 // Validation 1: Check occupancy limit
        Room room = roomDAO.getRoomById(reservation.getRoomId());
        RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
        
        int totalGuests = reservation.getNumAdults() + reservation.getNumChildren();
        if (totalGuests > roomType.getMaxOccupancy()) {
            throw new IllegalArgumentException(
                "Total guests (" + totalGuests + ") exceeds max occupancy (" 
                + roomType.getMaxOccupancy() + ") for this room type."
            );
        }
        
        // Business rule: Check if room is available for the dates
        if (!reservationDAO.isRoomAvailable(
                reservation.getRoomId(),
                reservation.getCheckInDate(),
                reservation.getCheckOutDate())) {
        	throw new IllegalArgumentException(
                    "Room is not available for the selected dates."
                );
        }
        
        return reservationDAO.addReservation(reservation);
    }

    // ─── GET reservation by ID ────────────────────────────────────────────────
    public Reservation getReservationById(int id) throws SQLException {
        return reservationDAO.getReservationById(id);
    }

    // ─── GET reservation by number ────────────────────────────────────────────
    public Reservation getReservationByNumber(String reservationNumber) throws SQLException {
        return reservationDAO.getReservationByNumber(reservationNumber);
    }

    // ─── GET all reservations ─────────────────────────────────────────────────
    public List<Reservation> getAllReservations() throws SQLException {
        return reservationDAO.getAllReservations();
    }

    // ─── GET reservations by status ───────────────────────────────────────────
    public List<Reservation> getReservationsByStatus(String status) throws SQLException {
        return reservationDAO.getReservationsByStatus(status);
    }

    // ─── GET reservations by guest ────────────────────────────────────────────
    public List<Reservation> getReservationsByGuest(int guestId) throws SQLException {
        return reservationDAO.getReservationsByGuest(guestId);
    }

    // ─── GET reservations by date range ───────────────────────────────────────
    public List<Reservation> getReservationsByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        return reservationDAO.getReservationsByDateRange(startDate, endDate);
    }

    // ─── GET upcoming check-ins ───────────────────────────────────────────────
    public List<Reservation> getUpcomingCheckIns(int days) throws SQLException {
        return reservationDAO.getUpcomingCheckIns(days);
    }

    // ─── GET today's check-ins ────────────────────────────────────────────────
    public List<Reservation> getTodayCheckIns() throws SQLException {
        return reservationDAO.getTodayCheckIns();
    }

    // ─── GET today's check-outs ───────────────────────────────────────────────
    public List<Reservation> getTodayCheckOuts() throws SQLException {
        return reservationDAO.getTodayCheckOuts();
    }

    // ─── SEARCH reservations ──────────────────────────────────────────────────
    public List<Reservation> searchReservations(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return reservationDAO.getAllReservations();
        }
        return reservationDAO.searchReservations(keyword.trim());
    }

    // ─── UPDATE reservation ───────────────────────────────────────────────────
    public boolean updateReservation(Reservation reservation) throws SQLException {
        // Get original reservation to check if room/dates changed
        Reservation original = reservationDAO.getReservationById(reservation.getId());
        
        // If room or dates changed, check availability (excluding current reservation)
        if (original != null && 
            (original.getRoomId() != reservation.getRoomId() ||
             !original.getCheckInDate().equals(reservation.getCheckInDate()) ||
             !original.getCheckOutDate().equals(reservation.getCheckOutDate()))) {
            
            // Check if new room/dates are available
            if (!isRoomAvailableForUpdate(
                    reservation.getRoomId(),
                    reservation.getCheckInDate(),
                    reservation.getCheckOutDate(),
                    reservation.getId())) {
                return false;
            }
        }
        
        return reservationDAO.updateReservation(reservation);
    }

    // ─── UPDATE status ────────────────────────────────────────────────────────
    public boolean updateStatus(int id, String status) throws SQLException {
        return reservationDAO.updateStatus(id, status);
    }

    // ─── CHECK-IN ─────────────────────────────────────────────────────────────
    public boolean checkIn(int id) throws SQLException {
        boolean success = reservationDAO.checkIn(id);
        if (success) {
            // Update room status to occupied
            Reservation reservation = reservationDAO.getReservationById(id);
            if (reservation != null) {
                roomDAO.updateRoomStatus(reservation.getRoomId(), "Occupied");
            }
        }
        return success;
    }

    // ─── CHECK-OUT ────────────────────────────────────────────────────────────
    public boolean checkOut(int id) throws SQLException {
        boolean success = reservationDAO.checkOut(id);
        if (success) {
            // Update room status to available
            Reservation reservation = reservationDAO.getReservationById(id);
            if (reservation != null) {
                roomDAO.updateRoomStatus(reservation.getRoomId(), "Available");
            }
        }
        return success;
    }

    // ─── CANCEL reservation ───────────────────────────────────────────────────
    public boolean cancelReservation(int id) throws SQLException {
        boolean success = reservationDAO.updateStatus(id, "Cancelled");
        if (success) {
            // Update room status to available if it was reserved
            Reservation reservation = reservationDAO.getReservationById(id);
            if (reservation != null && "Reserved".equals(reservation.getStatus())) {
                roomDAO.updateRoomStatus(reservation.getRoomId(), "Available");
            }
        }
        return success;
    }

    // ─── CONFIRM reservation ──────────────────────────────────────────────────
    public boolean confirmReservation(int id) throws SQLException {
        boolean success = reservationDAO.updateStatus(id, "Confirmed");
        if (success) {
            // Update room status to reserved
            Reservation reservation = reservationDAO.getReservationById(id);
            if (reservation != null) {
                roomDAO.updateRoomStatus(reservation.getRoomId(), "Reserved");
            }
        }
        return success;
    }

    // ─── DELETE reservation ───────────────────────────────────────────────────
    public boolean deleteReservation(int id) throws SQLException {
        // Business rule: Only delete cancelled reservations or pending ones
        Reservation reservation = reservationDAO.getReservationById(id);
        if (reservation != null && 
            !reservation.isCancelled() && 
            !reservation.isPending()) {
            return false; // Cannot delete active/confirmed reservations
        }
        return reservationDAO.deleteReservation(id);
    }

    // ─── CHECK room availability ──────────────────────────────────────────────
    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) throws SQLException {
        return reservationDAO.isRoomAvailable(roomId, checkIn, checkOut);
    }

    // ─── CHECK room availability for update ───────────────────────────────────
    private boolean isRoomAvailableForUpdate(int roomId, LocalDate checkIn, 
                                              LocalDate checkOut, int excludeReservationId) throws SQLException {
        // This would need a modified query in DAO to exclude the current reservation
        // For now, using basic check (can be enhanced)
        return reservationDAO.isRoomAvailable(roomId, checkIn, checkOut);
    }

    // ─── GET reservation count by status ──────────────────────────────────────
    public int getReservationCountByStatus(String status) throws SQLException {
        return reservationDAO.getReservationCountByStatus(status);
    }
    
    public BigDecimal calculateReservationTotal(int roomId, LocalDate checkInDate, LocalDate checkOutDate) throws SQLException {
        // 1. Fetch Room and Room Type to get the Base Price
        Room room = roomDAO.getRoomById(roomId);
        if (room == null) return BigDecimal.ZERO;
        
        RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
        if (roomType == null) return BigDecimal.ZERO;
        
        BigDecimal basePrice = roomType.getBasePrice(); 

        // 2. Fetch all ACTIVE seasonal rates for this Room Type
        List<SeasonalRate> activeRates = seasonalRateDAO.getActiveRatesForRoomType(roomType.getId());

        BigDecimal grandTotal = BigDecimal.ZERO;
        LocalDate currentDate = checkInDate;

        // 3. Loop day-by-day until the checkout date (exclusive)
        while (currentDate.isBefore(checkOutDate)) {
            
            // Start by assuming standard price for tonight
            BigDecimal priceForTonight = basePrice; 

            // Check if tonight falls into any active seasonal rate
            for (SeasonalRate rate : activeRates) {
                boolean isAfterOrOnStart = currentDate.isEqual(rate.getStartDate()) || currentDate.isAfter(rate.getStartDate());
                boolean isBeforeOrOnEnd = currentDate.isEqual(rate.getEndDate()) || currentDate.isBefore(rate.getEndDate());

                if (isAfterOrOnStart && isBeforeOrOnEnd) {
                    // We found a matching season! Let's calculate the exact price.
                    BigDecimal discountPct = rate.getDiscountPct();
                    
                    // Priority 1: If they set a % discount
                    if (discountPct != null && discountPct.compareTo(BigDecimal.ZERO) > 0) {
                        BigDecimal discountMultiplier = discountPct.divide(new BigDecimal("100"));
                        BigDecimal discountAmount = basePrice.multiply(discountMultiplier);
                        priceForTonight = basePrice.subtract(discountAmount);
                    } 
                    // Priority 2: If they set a flat price override
                    else if (rate.getPricePerNight() != null && rate.getPricePerNight().compareTo(BigDecimal.ZERO) > 0) {
                        priceForTonight = rate.getPricePerNight();
                    }
                    
                    // Rate applied, no need to check other seasons for this specific night
                    break; 
                }
            }

            // Add tonight's final price to the grand total
            grandTotal = grandTotal.add(priceForTonight);
            
            // Move to the next night
            currentDate = currentDate.plusDays(1);
        }

        // Return safely rounded to 2 decimal places
        return grandTotal.setScale(2, RoundingMode.HALF_UP);
    }
}