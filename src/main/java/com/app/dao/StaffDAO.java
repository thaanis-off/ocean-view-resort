package com.app.dao;
import java.util.ArrayList;
import java.util.List;
import com.app.model.Staff;
import com.app.util.DBConnection;
import java.sql.*;

public class StaffDAO {

    // ─── INSERT new staff ─────────────────────────────────────────────────────
    public boolean registerStaff(Staff staff) {
        String sql = "INSERT INTO staffs (staff_code, full_name, username, email, password_hash, role) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, generateStaffCode());       // STF-001
            ps.setString(2, staff.getFullName());       // full_name
            ps.setString(3, staff.getUsername());       // username  ✅ fixed typo
            ps.setString(4, staff.getEmail());          // email     ✅ fixed index
            ps.setString(5, staff.getPasswordHash());   // password_hash ✅ fixed index
            ps.setString(6, staff.getRole());           // role      ✅ fixed index

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── FIND by username OR email (for flexible login) ───────────────────────
    public Staff findByUsernameOrEmail(String input) {
        String sql = "SELECT * FROM staffs WHERE (username = ? OR email = ?) AND is_active = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, input); // check as username
            ps.setString(2, input); // check as email
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── CHECK if username exists ─────────────────────────────────────────────
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM staffs WHERE username = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── CHECK if email exists ────────────────────────────────────────────────
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM staffs WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

 // ─── SELECT ALL STAFF ─────────────────────────────────────────────────────
    public List<Staff> getAllStaff() throws SQLException {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM staffs WHERE is_active = 1 ORDER BY full_name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }
    // ─── UPDATE last login time ───────────────────────────────────────────────
    public void updateLastLogin(int id) {
        String sql = "UPDATE staffs SET last_login = NOW() WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ─── MAP row to Staff object ──────────────────────────────────────────────
    private Staff mapRow(ResultSet rs) throws SQLException {
        Staff s = new Staff();
        s.setId(rs.getInt("id"));
        s.setStaffCode(rs.getString("staff_code"));
        s.setFullName(rs.getString("full_name"));
        s.setUsername(rs.getString("username"));
        s.setEmail(rs.getString("email"));
        s.setPasswordHash(rs.getString("password_hash"));
        s.setRole(rs.getString("role"));
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }

    // ─── GENERATE staff code ──────────────────────────────────────────────────
    private String generateStaffCode() throws SQLException {
        String sql = "SELECT COALESCE(MAX(id), 0) + 1 FROM staffs";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            rs.next();
            return String.format("STF-%03d", rs.getInt(1));
        }
    }
}