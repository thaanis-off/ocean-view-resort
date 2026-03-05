package com.app.dao;

import com.app.model.ExtraCharge;
import com.app.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ExtraChargeDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────
    public boolean addExtraCharge(ExtraCharge charge) throws SQLException {
        String sql = "INSERT INTO extra_charges (reservation_id, description, category, amount, charge_date, added_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, charge.getReservationId());
            ps.setString(2, charge.getDescription());
            ps.setString(3, charge.getCategory());
            ps.setBigDecimal(4, charge.getAmount());
            ps.setDate(5, Date.valueOf(charge.getChargeDate()));
            ps.setInt(6, charge.getAddedBy());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY RESERVATION ───────────────────────────────────────────────
    // This is the main query we'll use to list the charges on the reservation-view page
    public List<ExtraCharge> getChargesByReservation(int reservationId) throws SQLException {
        List<ExtraCharge> list = new ArrayList<>();
        String sql = "SELECT e.*, r.reservation_number, s.full_name as added_by_name " +
                     "FROM extra_charges e " +
                     "LEFT JOIN reservations r ON e.reservation_id = r.id " +
                     "LEFT JOIN staffs s ON e.added_by = s.id " +
                     "WHERE e.reservation_id = ? " +
                     "ORDER BY e.charge_date DESC, e.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ─── GET TOTAL CHARGES FOR RESERVATION ───────────────────────────────────
    // This is super useful for calculating the final bill when the guest checks out
    public BigDecimal getTotalChargesForReservation(int reservationId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM extra_charges WHERE reservation_id = ?";

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

    // ─── DELETE ──────────────────────────────────────────────────────────────
    public boolean deleteExtraCharge(int id) throws SQLException {
        String sql = "DELETE FROM extra_charges WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── MAP ROW HELPER ──────────────────────────────────────────────────────
    private ExtraCharge mapRow(ResultSet rs) throws SQLException {
        ExtraCharge charge = new ExtraCharge();
        charge.setId(rs.getInt("id"));
        charge.setReservationId(rs.getInt("reservation_id"));
        charge.setDescription(rs.getString("description"));
        charge.setCategory(rs.getString("category"));
        charge.setAmount(rs.getBigDecimal("amount"));
        
        Date chargeDate = rs.getDate("charge_date");
        charge.setChargeDate(chargeDate != null ? chargeDate.toLocalDate() : null);
        
        charge.setAddedBy(rs.getInt("added_by"));
        
        // Joined fields
        charge.setReservationNumber(rs.getString("reservation_number"));
        charge.setAddedByName(rs.getString("added_by_name"));
        
        return charge;
    }
}