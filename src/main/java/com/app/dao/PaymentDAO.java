package com.app.dao;

import com.app.model.Payment;
import com.app.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean addPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payments (reservation_id, amount, payment_method, " +
                     "payment_type, reference_number, received_by, notes) " +
                     "VALUES (?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payment.getReservationId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentType());
            ps.setString(5, payment.getReferenceNumber());
            ps.setInt(6, payment.getReceivedBy());
            ps.setString(7, payment.getNotes());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public Payment getPaymentById(int id) throws SQLException {
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE p.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY RESERVATION ───────────────────────────────────────────────

    public List<Payment> getPaymentsByReservation(int reservationId) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE p.reservation_id = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY PAYMENT METHOD ────────────────────────────────────────────

    public List<Payment> getPaymentsByMethod(String paymentMethod) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE p.payment_method = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, paymentMethod);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY PAYMENT TYPE ──────────────────────────────────────────────

    public List<Payment> getPaymentsByType(String paymentType) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE p.payment_type = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, paymentType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY DATE RANGE ────────────────────────────────────────────────

    public List<Payment> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE p.payment_date BETWEEN ? AND ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(startDate));
            ps.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── GET TODAY'S PAYMENTS ────────────────────────────────────────────────

    public List<Payment> getTodayPayments() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE DATE(p.payment_date) = CURDATE() " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SEARCH PAYMENTS ─────────────────────────────────────────────────────

    public List<Payment> searchPayments(String keyword) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "r.reservation_number, " +
                     "CONCAT(g.first_name, ' ', g.last_name) as guest_name, " +
                     "rm.room_number, " +
                     "s.full_name as received_by_name " +
                     "FROM payments p " +
                     "LEFT JOIN reservations r ON p.reservation_id = r.id " +
                     "LEFT JOIN guests g ON r.guest_id = g.id " +
                     "LEFT JOIN rooms rm ON r.room_id = rm.id " +
                     "LEFT JOIN staffs s ON p.received_by = s.id " +
                     "WHERE r.reservation_number LIKE ? " +
                     "OR g.first_name LIKE ? OR g.last_name LIKE ? " +
                     "OR p.reference_number LIKE ? " +
                     "ORDER BY p.payment_date DESC";

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

    public boolean updatePayment(Payment payment) throws SQLException {
        String sql = "UPDATE payments SET reservation_id=?, amount=?, payment_method=?, " +
                     "payment_type=?, reference_number=?, received_by=?, notes=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payment.getReservationId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentType());
            ps.setString(5, payment.getReferenceNumber());
            
            ps.setInt(6, payment.getReceivedBy());
            
            ps.setString(7, payment.getNotes());
            ps.setInt(8, payment.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

    public boolean deletePayment(int id) throws SQLException {
        String sql = "DELETE FROM payments WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── GET TOTAL PAID FOR RESERVATION ──────────────────────────────────────

    public BigDecimal getTotalPaidForReservation(int reservationId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments " +
                     "WHERE reservation_id = ? AND payment_type != 'Refund'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    // ─── GET TOTAL REFUNDED FOR RESERVATION ──────────────────────────────────

    public BigDecimal getTotalRefundedForReservation(int reservationId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments " +
                     "WHERE reservation_id = ? AND payment_type = 'Refund'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    // ─── GET PAYMENT STATISTICS ──────────────────────────────────────────────

    public Map<String, BigDecimal> getPaymentStatistics() throws SQLException {
        Map<String, BigDecimal> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COALESCE(SUM(CASE WHEN payment_type != 'Refund' THEN amount ELSE 0 END), 0) as total_received, " +
                     "COALESCE(SUM(CASE WHEN payment_type = 'Refund' THEN amount ELSE 0 END), 0) as total_refunded, " +
                     "COALESCE(SUM(CASE WHEN payment_method = 'Cash' THEN amount ELSE 0 END), 0) as cash_payments, " +
                     "COALESCE(SUM(CASE WHEN payment_method IN ('Credit Card', 'Debit Card') THEN amount ELSE 0 END), 0) as card_payments " +
                     "FROM payments " +
                     "WHERE DATE(payment_date) = CURDATE()";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                stats.put("totalReceived", rs.getBigDecimal("total_received"));
                stats.put("totalRefunded", rs.getBigDecimal("total_refunded"));
                stats.put("cashPayments", rs.getBigDecimal("cash_payments"));
                stats.put("cardPayments", rs.getBigDecimal("card_payments"));
            }
        }
        return stats;
    }

    // ─── MAP ROW ─────────────────────────────────────────────────────────────

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setReservationId(rs.getInt("reservation_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        
        Timestamp paymentDate = rs.getTimestamp("payment_date");
        p.setPaymentDate(paymentDate != null ? paymentDate.toLocalDateTime() : null);
        
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentType(rs.getString("payment_type"));
        p.setReferenceNumber(rs.getString("reference_number"));
        
        int receivedBy = rs.getInt("received_by");
        p.setReceivedBy(rs.wasNull() ? null : receivedBy);
        
        p.setNotes(rs.getString("notes"));
        
        // Joined fields
        p.setReservationNumber(rs.getString("reservation_number"));
        p.setGuestName(rs.getString("guest_name"));
        p.setRoomNumber(rs.getString("room_number"));
        p.setReceivedByName(rs.getString("received_by_name"));
        
        return p;
    }
}