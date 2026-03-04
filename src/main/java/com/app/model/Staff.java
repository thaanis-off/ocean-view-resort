package com.app.model;

public class Staff {

    private int id;
    private String staffCode;     
    private String fullName;
    private String username;
    private String email;
    private String passwordHash;
    private String role;
    private String phone;
    private boolean isActive;

    // ─── Constructors ─────────────────────────────────────────────────────────
    public Staff() {}

    public Staff(String username, String passwordHash, String fullName,
                 String email, String role) {
        this.username     = username;
        this.passwordHash = passwordHash;
        this.fullName     = fullName;
        this.email        = email;
        this.role         = role;
        this.isActive     = true;
    }

    // ─── Getters & Setters ────────────────────────────────────────────────────
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    // ─── Utility ──────────────────────────────────────────────────────────────
    @Override
    public String toString() {
        return "Staff{id=" + id + ", staffCode='" + staffCode +
               "', fullName='" + fullName + "', role='" + role + "'}";
    }
}