package com.app.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Guest {
	private int id;
    private String guestCode;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String nicPassport;
    private String nationality;
    private String address;
    private String gender;          // Male, Female, Other
    private LocalDate dateOfBirth;
    private String guestType;       // Regular, VIP, Corporate
    private int totalStays;
    private LocalDateTime createdAt;
    private boolean isActive;
    private boolean isVip;
    private boolean blacklisted;
 
    public Guest() {}

    public Guest(String firstName, String lastName, String email,
                 String phone, String address) {
        this.firstName = firstName;
        this.lastName  = lastName;
        this.email     = email;
        this.phone     = phone;
        this.address   = address;
        this.isActive  = true;
        this.isVip     = false;
        this.blacklisted = false;
        this.guestType = "Regular";
        this.totalStays = 0;
    }

    // ─── GETTERS & SETTERS ───────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getGuestCode() { return guestCode; }
    public void setGuestCode(String guestCode) { this.guestCode = guestCode; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getNicPassport() { return nicPassport; }
    public void setNicPassport(String nicPassport) { this.nicPassport = nicPassport; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGuestType() { return guestType; }
    public void setGuestType(String guestType) { this.guestType = guestType; }

    public int getTotalStays() { return totalStays; }
    public void setTotalStays(int totalStays) { this.totalStays = totalStays; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    public boolean isVip() { return isVip; }
    public void setVip(boolean isVip) { this.isVip = isVip; }

    public boolean isBlacklisted() { return blacklisted; }
    public void setBlacklisted(boolean blacklisted) { this.blacklisted = blacklisted; }

 // ─── UTILITY METHODS ─────────────────────────────────────────────────────

    public String getFullName() {
        return firstName + " " + lastName;
    }

    public String getDisplayCode() {
        return guestCode != null ? guestCode : "N/A";
    }

    public boolean isEligibleForVip() {
        return totalStays >= 5;
    }

    @Override
    public String toString() {
        return "Guest{" +
                "id=" + id +
                ", guestCode='" + guestCode + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", email='" + email + '\'' +
                ", guestType='" + guestType + '\'' +
                ", totalStays=" + totalStays +
                ", isVip=" + isVip +
                ", blacklisted=" + blacklisted +
                '}';
    }

}


