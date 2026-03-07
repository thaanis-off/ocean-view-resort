package com.app.dao;

import com.app.model.Room;
import com.app.model.SeasonalRate;
import com.app.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SeasonalRateDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────
    public boolean addRate(SeasonalRate rate) throws SQLException {
        String sql = "INSERT INTO seasonal_rates (room_type_id, season_name, start_date, " +
                     "end_date, price_per_night, discount_pct, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, rate.getRoomTypeId());
            ps.setString(2, rate.getSeasonName());
            ps.setDate(3, Date.valueOf(rate.getStartDate()));
            ps.setDate(4, Date.valueOf(rate.getEndDate()));
            ps.setBigDecimal(5, rate.getPricePerNight());
            ps.setBigDecimal(6, rate.getDiscountPct() != null ? rate.getDiscountPct() : BigDecimal.ZERO);
            ps.setBoolean(7, rate.isActive());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────
    public SeasonalRate getRateById(int id) throws SQLException {
        String sql = "SELECT sr.*, rt.type_name as room_type_name " +
                     "FROM seasonal_rates sr " +
                     "LEFT JOIN room_types rt ON sr.room_type_id = rt.id " +
                     "WHERE sr.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────
    public List<SeasonalRate> getAllRates() throws SQLException {
        List<SeasonalRate> list = new ArrayList<>();
        String sql = "SELECT sr.*, rt.type_name as room_type_name " +
                     "FROM seasonal_rates sr " +
                     "LEFT JOIN room_types rt ON sr.room_type_id = rt.id " +
                     "ORDER BY sr.start_date DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────
    public boolean updateRate(SeasonalRate rate) throws SQLException {
        String sql = "UPDATE seasonal_rates SET room_type_id=?, season_name=?, start_date=?, " +
                     "end_date=?, price_per_night=?, discount_pct=?, is_active=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, rate.getRoomTypeId());
            ps.setString(2, rate.getSeasonName());
            ps.setDate(3, Date.valueOf(rate.getStartDate()));
            ps.setDate(4, Date.valueOf(rate.getEndDate()));
            ps.setBigDecimal(5, rate.getPricePerNight());
            ps.setBigDecimal(6, rate.getDiscountPct());
            ps.setBoolean(7, rate.isActive());
            ps.setInt(8, rate.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────
    public boolean deleteRate(int id) throws SQLException {
        String sql = "DELETE FROM seasonal_rates WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

 // ─── GET ACTIVE RATES BY ROOM TYPE ────────────────────────────────────────
    public List<SeasonalRate> getActiveRatesForRoomType(int roomTypeId) throws SQLException {
        List<SeasonalRate> list = new ArrayList<>();
        String sql = "SELECT sr.*, rt.type_name as room_type_name " +
                     "FROM seasonal_rates sr " +
                     "LEFT JOIN room_types rt ON sr.room_type_id = rt.id " +
                     "WHERE sr.room_type_id = ? AND sr.is_active = 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapRow(rs)); // Uses your existing mapRow helper
            }
        }
        return list;
    }
    
   
 // ─── SEARCH RATES ────────────────────────────────────────────────────────
    public List<SeasonalRate> searchRates(String keyword) throws SQLException {
        List<SeasonalRate> list = new ArrayList<>();
        // Search by Season Name or Room Type Name
        String sql = "SELECT sr.*, rt.type_name as room_type_name " +
                     "FROM seasonal_rates sr " +
                     "LEFT JOIN room_types rt ON sr.room_type_id = rt.id " +
                     "WHERE sr.is_active = 1 AND (" +
                     "sr.season_name LIKE ? OR rt.type_name LIKE ? OR " +
                     "CAST(sr.price_per_night AS CHAR) LIKE ?) " +
                     "ORDER BY sr.start_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }    
    // ─── MAP ROW HELPER ──────────────────────────────────────────────────────
    private SeasonalRate mapRow(ResultSet rs) throws SQLException {
        SeasonalRate sr = new SeasonalRate();
        sr.setId(rs.getInt("id"));
        sr.setRoomTypeId(rs.getInt("room_type_id"));
        sr.setSeasonName(rs.getString("season_name"));
        
        Date startDate = rs.getDate("start_date");
        sr.setStartDate(startDate != null ? startDate.toLocalDate() : null);
        
        Date endDate = rs.getDate("end_date");
        sr.setEndDate(endDate != null ? endDate.toLocalDate() : null);
        
        sr.setPricePerNight(rs.getBigDecimal("price_per_night"));
        sr.setDiscountPct(rs.getBigDecimal("discount_pct"));
        sr.setActive(rs.getBoolean("is_active"));
        
        Timestamp created = rs.getTimestamp("created_at");
        sr.setCreatedAt(created != null ? created.toLocalDateTime() : null);
        
        // Joined field
        sr.setRoomTypeName(rs.getString("room_type_name"));
        
        return sr;
    }
}