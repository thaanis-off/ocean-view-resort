package com.app.service;

import java.sql.SQLException;

import java.util.List;

import com.app.dao.StaffDAO;
import com.app.model.Staff;
import org.mindrot.jbcrypt.BCrypt;

public class StaffService {

    private StaffDAO staffDAO = new StaffDAO();

    // ─── REGISTER ─────────────────────────────────────────────────────────────
    public boolean register(Staff staff) {
        // Check both username AND email must be unique
        if (staffDAO.usernameExists(staff.getUsername())) {
            return false;
        }
        if (staffDAO.emailExists(staff.getEmail())) {
            return false;
        }

        // Hash password before saving
        String hashed = BCrypt.hashpw(staff.getPasswordHash(), BCrypt.gensalt());
        staff.setPasswordHash(hashed);

        return staffDAO.registerStaff(staff);
    }

    // ─── LOGIN with username OR email ─────────────────────────────────────────
    public Staff login(String usernameOrEmail, String password) {
        // Single query checks both username and email
        Staff staff = staffDAO.findByUsernameOrEmail(usernameOrEmail);

        if (staff != null && BCrypt.checkpw(password, staff.getPasswordHash())) {
            staffDAO.updateLastLogin(staff.getId());
            return staff;
        }

        return null;
    }
    
 // ─── GET ALL STAFF ────────────────────────────────────────────────────────
    public List<Staff> getAllStaff() throws SQLException {
        return staffDAO.getAllStaff();
    }
}