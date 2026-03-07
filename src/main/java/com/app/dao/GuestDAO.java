package com.app.dao;

import com.app.model.Guest;
import com.app.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import java.sql.Date;  

public class GuestDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean addGuest(Guest g) throws SQLException {
        String sql = "INSERT INTO guests (guest_code, first_name, last_name, email, phone, " +
                     "nic_passport, nationality, address, gender, date_of_birth, " +
                     "guest_type, is_vip, blacklisted) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, generateGuestCode());
            ps.setString(2, g.getFirstName());
            ps.setString(3, g.getLastName());
            ps.setString(4, g.getEmail());
            ps.setString(5, g.getPhone());
            ps.setString(6, g.getNicPassport());
            ps.setString(7, g.getNationality());
            ps.setString(8, g.getAddress());
            ps.setString(9, g.getGender());
            // dateOfBirth can be null
            ps.setDate(10, g.getDateOfBirth() != null ?
                    Date.valueOf(g.getDateOfBirth()) : null);
            ps.setString(11, g.getGuestType());
            ps.setBoolean(12, g.isVip());
            ps.setBoolean(13, g.isBlacklisted());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public Guest getGuestById(int id) throws SQLException {
        String sql = "SELECT * FROM guests WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT BY GUEST CODE ────────────────────────────────────────────────

    public Guest getGuestByCode(String guestCode) throws SQLException {
        String sql = "SELECT * FROM guests WHERE guest_code = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, guestCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT BY EMAIL ─────────────────────────────────────────────────────

    public Guest getGuestByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM guests WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<Guest> getAllGuests() throws SQLException {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests WHERE is_active = 1 ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── SEARCH GUESTS ───────────────────────────────────────────────────────

    public List<Guest> searchGuests(String keyword) throws SQLException {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests WHERE is_active = 1 AND (" +
                     "first_name LIKE ? OR last_name LIKE ? OR " +
                     "email LIKE ? OR phone LIKE ? OR guest_code LIKE ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            ps.setString(5, kw);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    public boolean updateGuest(Guest g) throws SQLException {
        String sql = "UPDATE guests SET first_name=?, last_name=?, email=?, phone=?, " +
                     "nic_passport=?, nationality=?, address=?, gender=?, " +
                     "date_of_birth=?, guest_type=?, is_vip=?, blacklisted=? " +
                     "WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, g.getFirstName());
            ps.setString(2, g.getLastName());
            ps.setString(3, g.getEmail());
            ps.setString(4, g.getPhone());
            ps.setString(5, g.getNicPassport());
            ps.setString(6, g.getNationality());
            ps.setString(7, g.getAddress());
            ps.setString(8, g.getGender());
            ps.setDate(9, g.getDateOfBirth() != null ?
                    Date.valueOf(g.getDateOfBirth()) : null);
            ps.setString(10, g.getGuestType());
            ps.setBoolean(11, g.isVip());
            ps.setBoolean(12, g.isBlacklisted());
            ps.setInt(13, g.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── SOFT DELETE ─────────────────────────────────────────────────────────

    public boolean deleteGuest(int id) throws SQLException {
        String sql = "UPDATE guests SET is_active = 0 WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── BLACKLIST TOGGLE ────────────────────────────────────────────────────

    public boolean toggleBlacklist(int id, boolean blacklisted) throws SQLException {
        String sql = "UPDATE guests SET blacklisted = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBoolean(1, blacklisted);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── INCREMENT STAY COUNT ────────────────────────────────────────────────

//    public boolean incrementTotalStays(int id) throws SQLException {
//        String sql = "UPDATE guests SET total_stays = total_stays + 1 WHERE id = ?";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//        }
//    }

    // ─── CHECK IF EMAIL EXISTS ───────────────────────────────────────────────

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM guests WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    public boolean nicPassportExists(String nicPassport) throws SQLException {
        if (nicPassport == null || nicPassport.trim().isEmpty()) {
            return false; // Don't check if it's empty
        }
        
        String sql = "SELECT COUNT(*) FROM guests WHERE nic_passport = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nicPassport);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── CHECK IF EMAIL EXISTS (EXCLUDING SPECIFIC ID) ───────────────────────

    public boolean emailExistsExcludingId(String email, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM guests WHERE email = ? AND id != ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── CHECK IF NIC/PASSPORT EXISTS (EXCLUDING SPECIFIC ID) ────────────────

    public boolean nicPassportExistsExcludingId(String nicPassport, int excludeId) throws SQLException {
        if (nicPassport == null || nicPassport.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM guests WHERE nic_passport = ? AND id != ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nicPassport);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ─── MAP ROW ─────────────────────────────────────────────────────────────

    private Guest mapRow(ResultSet rs) throws SQLException {
        Guest g = new Guest();
        g.setId(rs.getInt("id"));
        g.setGuestCode(rs.getString("guest_code"));
        g.setFirstName(rs.getString("first_name"));
        g.setLastName(rs.getString("last_name"));
        g.setEmail(rs.getString("email"));
        g.setPhone(rs.getString("phone"));
        g.setNicPassport(rs.getString("nic_passport"));
        g.setNationality(rs.getString("nationality"));
        g.setAddress(rs.getString("address"));
        g.setGender(rs.getString("gender"));

        // safely map date — can be null
        Date dob = rs.getDate("date_of_birth");
        g.setDateOfBirth(dob != null ? dob.toLocalDate() : null);

        g.setGuestType(rs.getString("guest_type"));
        g.setActive(rs.getBoolean("is_active"));
        g.setVip(rs.getBoolean("is_vip"));
        g.setBlacklisted(rs.getBoolean("blacklisted"));

        // safely map timestamp — can be null
        Timestamp createdAt = rs.getTimestamp("created_at");
        g.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);

        return g;
    }

    // ─── GENERATE GUEST CODE ─────────────────────────────────────────────────

    private String generateGuestCode() throws SQLException {
        // Uses MAX id instead of COUNT to avoid gaps from deleted records
        String sql = "SELECT COALESCE(MAX(id), 0) + 1 FROM guests";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            rs.next();
            return String.format("GST-%04d", rs.getInt(1));
        }
    }
}