package com.app.dao;

import com.app.model.Room;
import com.app.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class RoomDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean addRoom(Room room) throws SQLException {
        String sql = "INSERT INTO rooms (room_number, room_type_id, floor_number, " +
                     "view_type, status, is_active) " +
                     "VALUES (?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setInt(3, room.getFloorNumber());
            ps.setString(4, room.getViewType());
            ps.setString(5, room.getStatus());
            ps.setBoolean(6, room.isActive());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public Room getRoomById(int id) throws SQLException {
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.id = ? AND is_active = 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT BY ROOM NUMBER ───────────────────────────────────────────────

    public Room getRoomByNumber(String roomNumber) throws SQLException {
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.room_number = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<Room> getAllRooms() throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.is_active = 1 " +
                     "ORDER BY r.floor_number ASC, r.room_number ASC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY STATUS ────────────────────────────────────────────────────

    public List<Room> getRoomsByStatus(String status) throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.is_active = 1 AND r.status = ? " +
                     "ORDER BY r.floor_number ASC, r.room_number ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY FLOOR ─────────────────────────────────────────────────────

    public List<Room> getRoomsByFloor(int floorNumber) throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.is_active = 1 AND r.floor_number = ? " +
                     "ORDER BY r.room_number ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, floorNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SELECT BY ROOM TYPE ─────────────────────────────────────────────────

    public List<Room> getRoomsByType(int roomTypeId) throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.is_active = 1 AND r.room_type_id = ? " +
                     "ORDER BY r.floor_number ASC, r.room_number ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SEARCH ROOMS ────────────────────────────────────────────────────────

    public List<Room> searchRooms(String keyword) throws SQLException {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name as room_type_name " +
                     "FROM rooms r " +
                     "LEFT JOIN room_types rt ON r.room_type_id = rt.id " +
                     "WHERE r.is_active = 1 AND (" +
                     "r.room_number LIKE ? OR rt.type_name LIKE ? OR " +
                     "r.view_type LIKE ? OR r.status LIKE ?) " +
                     "ORDER BY r.floor_number ASC, r.room_number ASC";

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

    public boolean updateRoom(Room room) throws SQLException {
        String sql = "UPDATE rooms SET room_number=?, room_type_id=?, floor_number=?, " +
                     "view_type=?, status=?, is_active=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeId());
            ps.setInt(3, room.getFloorNumber());
            ps.setString(4, room.getViewType());
            ps.setString(5, room.getStatus());
            ps.setBoolean(6, room.isActive());
            ps.setInt(7, room.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── UPDATE STATUS ───────────────────────────────────────────────────────

    public boolean updateRoomStatus(int id, String status) throws SQLException {
        String sql = "UPDATE rooms SET status = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── SOFT DELETE ─────────────────────────────────────────────────────────

    public boolean deleteRoom(int id) throws SQLException {
        String sql = "UPDATE rooms SET is_active = 0 WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── CHECK IF ROOM NUMBER EXISTS ─────────────────────────────────────────

    public boolean roomNumberExists(String roomNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_number = ? AND is_active = 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── CHECK IF ROOM NUMBER EXISTS (EXCLUDING ID) ──────────────────────────

    public boolean roomNumberExistsExcludingId(String roomNumber, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_number = ? AND id != ? AND is_active = 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── GET ROOM COUNT BY STATUS ────────────────────────────────────────────

    public int getRoomCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = ? AND is_active = 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    // ─── GET AVAILABLE ROOMS ─────────────────────────────────────────────────

    public List<Room> getAvailableRooms() throws SQLException {
        return getRoomsByStatus("Available");
    }

    // ─── MAP ROW ─────────────────────────────────────────────────────────────

    private Room mapRow(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setRoomTypeName(rs.getString("room_type_name"));
        room.setFloorNumber(rs.getInt("floor_number"));
        room.setViewType(rs.getString("view_type"));
        room.setStatus(rs.getString("status"));
        room.setActive(rs.getBoolean("is_active"));
        return room;
    }
}