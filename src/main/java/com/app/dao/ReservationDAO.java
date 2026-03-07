package com.app.dao;

import com.app.model.Reservation;
import com.app.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

public class ReservationDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean addReservation(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (reservation_number, guest_id, room_id, " +
                     "check_in_date, check_out_date, num_adults, num_children, " +
                     "status, total_amount, special_requests, booked_by, source) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, generateReservationNumber());
            ps.setInt(2, reservation.getGuestId());
            ps.setInt(3, reservation.getRoomId());
            ps.setDate(4, Date.valueOf(reservation.getCheckInDate()));
            ps.setDate(5, Date.valueOf(reservation.getCheckOutDate()));
            ps.setInt(6, reservation.getNumAdults());
            ps.setInt(7, reservation.getNumChildren());
            ps.setString(8, reservation.getStatus());
            ps.setBigDecimal(9, reservation.getTotalAmount());
            ps.setString(10, reservation.getSpecialRequests());
            ps.setInt(11, reservation.getBookedBy());
            ps.setString(12, reservation.getSource());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public Reservation getReservationById(int id) throws SQLException {
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "WHERE r.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT BY RESERVATION NUMBER ────────────────────────────────────────

    public Reservation getReservationByNumber(String reservationNumber) throws SQLException {
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "WHERE r.reservation_number = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reservationNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "ORDER BY r.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY STATUS ────────────────────────────────────────────────────

    public List<Reservation> getReservationsByStatus(String status) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.status = ? " +
                     "ORDER BY r.check_in_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY GUEST ─────────────────────────────────────────────────────

    public List<Reservation> getReservationsByGuest(int guestId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.guest_id = ? " +
                     "ORDER BY r.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, guestId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY DATE RANGE ────────────────────────────────────────────────

    public List<Reservation> getReservationsByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.check_in_date >= ? AND r.check_out_date <= ? " +
                     "ORDER BY r.check_in_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── GET UPCOMING CHECK-INS ──────────────────────────────────────────────

    public List<Reservation> getUpcomingCheckIns(int days) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.check_in_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL ? DAY) " +
                     "AND r.status IN ('Confirmed', 'Pending') " +
                     "ORDER BY r.check_in_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, days);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── GET CURRENT CHECK-INS (Today) ───────────────────────────────────────

    public List<Reservation> getTodayCheckIns() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.check_in_date = CURDATE() " +
                     "AND r.status = 'Confirmed' " +
                     "ORDER BY r.created_at ASC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── GET CURRENT CHECK-OUTS (Today) ──────────────────────────────────────

    public List<Reservation> getTodayCheckOuts() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.check_out_date = CURDATE() " +
                     "AND r.status = 'CheckedIn' " +
                     "ORDER BY r.created_at ASC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SEARCH RESERVATIONS ─────────────────────────────────────────────────

    public List<Reservation> searchReservations(String keyword) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "g.email as guest_email, g.phone as guest_phone, " +
                     "rm.room_number, rt.type_name as room_type_name, " +
                     "s.full_name as booked_by_name " +
                     "FROM reservations r " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON r.booked_by = s.id " +
                     "LEFT JOIN room_types rt ON rm.room_type_id = rt.id " +
                     "WHERE r.reservation_number LIKE ? " +
                     "OR g.first_name LIKE ? OR g.last_name LIKE ? " +
                     "OR rm.room_number LIKE ? " +
                     "ORDER BY r.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    public boolean updateReservation(Reservation reservation) throws SQLException {
        String sql = "UPDATE reservations SET guest_id=?, room_id=?, " +
                     "check_in_date=?, check_out_date=?, num_adults=?, num_children=?, " +
                     "status=?, total_amount=?, special_requests=?, booked_by=?, source=? " +
                     "WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservation.getGuestId());
            ps.setInt(2, reservation.getRoomId());
            ps.setDate(3, Date.valueOf(reservation.getCheckInDate()));
            ps.setDate(4, Date.valueOf(reservation.getCheckOutDate()));
            ps.setInt(5, reservation.getNumAdults());
            ps.setInt(6, reservation.getNumChildren());
            ps.setString(7, reservation.getStatus());
            ps.setBigDecimal(8, reservation.getTotalAmount());
            ps.setString(9, reservation.getSpecialRequests());
            ps.setInt(10, reservation.getBookedBy());
            ps.setString(11, reservation.getSource());
            ps.setInt(12, reservation.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── UPDATE STATUS ───────────────────────────────────────────────────────

    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── CHECK-IN ────────────────────────────────────────────────────────────

    public boolean checkIn(int id) throws SQLException {
        String sql = "UPDATE reservations SET status = 'CheckedIn', " +
                     "actual_check_in = NOW() WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── CHECK-OUT ───────────────────────────────────────────────────────────

    public boolean checkOut(int id) throws SQLException {
        String sql = "UPDATE reservations SET status = 'CheckedOut', " +
                     "actual_check_out = NOW() WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

 // ─── DELETE RESERVATION (with CASCADE delete of related records) ─────────
    public boolean deleteReservation(int id) throws SQLException {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            // Step 1: Delete related extra_charges first
            String deleteExtraCharges = "DELETE FROM extra_charges WHERE reservation_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteExtraCharges)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
            
            // Step 2: Delete related payments
            String deletePayments = "DELETE FROM payments WHERE reservation_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deletePayments)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
            
            // Step 3: Now delete the reservation
            String deleteReservation = "DELETE FROM reservations WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteReservation)) {
                ps.setInt(1, id);
                int result = ps.executeUpdate();
                
                con.commit(); // Commit transaction
                return result > 0;
            }
            
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // Reset auto-commit
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    // ─── GET RESERVATION COUNT BY STATUS ─────────────────────────────────────

    public int getReservationCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    // ─── CHECK ROOM AVAILABILITY ─────────────────────────────────────────────

    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations " +
                     "WHERE room_id = ? " +
                     "AND status NOT IN ('Cancelled', 'CheckedOut') " +
                     "AND ((check_in_date <= ? AND check_out_date > ?) " +
                     "OR (check_in_date < ? AND check_out_date >= ?) " +
                     "OR (check_in_date >= ? AND check_out_date <= ?))";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkIn));
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));
            ps.setDate(5, Date.valueOf(checkOut));
            ps.setDate(6, Date.valueOf(checkIn));
            ps.setDate(7, Date.valueOf(checkOut));

            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) == 0; // Available if count is 0
        }
    }

    // ─── MAP ROW ─────────────────────────────────────────────────────────────

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setRoomId(rs.getInt("room_id"));
        
        // Map dates
        Date checkIn = rs.getDate("check_in_date");
        r.setCheckInDate(checkIn != null ? checkIn.toLocalDate() : null);
        
        Date checkOut = rs.getDate("check_out_date");
        r.setCheckOutDate(checkOut != null ? checkOut.toLocalDate() : null);
        
        Timestamp actualCheckIn = rs.getTimestamp("actual_check_in");
        r.setActualCheckIn(actualCheckIn != null ? actualCheckIn.toLocalDateTime() : null);
        
        Timestamp actualCheckOut = rs.getTimestamp("actual_check_out");
        r.setActualCheckOut(actualCheckOut != null ? actualCheckOut.toLocalDateTime() : null);
        
        r.setNumAdults(rs.getInt("num_adults"));
        r.setNumChildren(rs.getInt("num_children"));
        r.setStatus(rs.getString("status"));
        r.setTotalAmount(rs.getBigDecimal("total_amount"));
        r.setSpecialRequests(rs.getString("special_requests"));
        r.setBookedBy(rs.getInt("booked_by"));
        r.setSource(rs.getString("source"));
        
        Timestamp created = rs.getTimestamp("created_at");
        r.setCreatedAt(created != null ? created.toLocalDateTime() : null);
        
        // Joined fields
        r.setGuestName(rs.getString("guest_name"));
        r.setGuestEmail(rs.getString("guest_email"));
        r.setGuestPhone(rs.getString("guest_phone"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomTypeName(rs.getString("room_type_name"));
        r.setBookedByName(rs.getString("booked_by_name"));
        
        return r;
    }

    // ─── GENERATE RESERVATION NUMBER ─────────────────────────────────────────

    private String generateReservationNumber() throws SQLException {
        String sql = "SELECT COALESCE(MAX(id), 0) + 1 FROM reservations";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            rs.next();
            int nextId = rs.getInt(1);
            return String.format("RES-%06d", nextId);
        }
    }
}