package com.app.dao;

import com.app.model.RoomType;
import com.app.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class RoomTypeDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean addRoomType(RoomType rt) throws SQLException {
        String sql = "INSERT INTO room_types (type_name, description, base_price_per_night, " +
                     "max_occupancy, amenities) VALUES (?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rt.getTypeName());
            ps.setString(2, rt.getDescription());
            ps.setBigDecimal(3, rt.getBasePrice());
            ps.setInt(4, rt.getMaxOccupancy());
            ps.setString(5, rt.getAmenities());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public RoomType getRoomTypeById(int id) throws SQLException {
        String sql = "SELECT * FROM room_types WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT BY TYPE NAME ─────────────────────────────────────────────────

    public RoomType getRoomTypeByName(String typeName) throws SQLException {
        String sql = "SELECT * FROM room_types WHERE type_name = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, typeName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY type_name ASC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SEARCH ROOM TYPES ───────────────────────────────────────────────────

    public List<RoomType> searchRoomTypes(String keyword) throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types WHERE " +
                     "type_name LIKE ? OR description LIKE ? OR amenities LIKE ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    public boolean updateRoomType(RoomType rt) throws SQLException {
        String sql = "UPDATE room_types SET type_name=?, description=?, " +
                     "base_price_per_night=?, max_occupancy=?, amenities=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rt.getTypeName());
            ps.setString(2, rt.getDescription());
            ps.setBigDecimal(3, rt.getBasePrice());
            ps.setInt(4, rt.getMaxOccupancy());
            ps.setString(5, rt.getAmenities());
            ps.setInt(6, rt.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

    public boolean deleteRoomType(int id) throws SQLException {
        String sql = "DELETE FROM room_types WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── CHECK IF TYPE NAME EXISTS ───────────────────────────────────────────

    public boolean typeNameExists(String typeName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM room_types WHERE type_name = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, typeName);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── CHECK IF TYPE NAME EXISTS (EXCLUDING ID) ────────────────────────────

    public boolean typeNameExistsExcludingId(String typeName, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM room_types WHERE type_name = ? AND id != ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, typeName);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── GET ROOM COUNT BY TYPE ──────────────────────────────────────────────

    public int getRoomCountByType(int roomTypeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_type_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    // ─── MAP ROW ─────────────────────────────────────────────────────────────

    private RoomType mapRow(ResultSet rs) throws SQLException {
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("id"));
        rt.setTypeName(rs.getString("type_name"));
        rt.setDescription(rs.getString("description"));
        rt.setBasePrice(rs.getBigDecimal("base_price_per_night"));
        rt.setMaxOccupancy(rs.getInt("max_occupancy"));
        rt.setAmenities(rs.getString("amenities"));
        return rt;
    }
}