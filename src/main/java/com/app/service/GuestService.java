package com.app.service;

import com.app.dao.GuestDAO;
import com.app.model.Guest;
import java.sql.SQLException;
import java.util.List;

public class GuestService {

    private GuestDAO guestDAO = new GuestDAO();

    // ─── ADD new guest ────────────────────────────────────────────────────────
    public boolean addGuest(Guest guest) throws SQLException {
        // Business rule: email must be unique
        if (guestDAO.emailExists(guest.getEmail())) {
            return false;
        }
        
     // Business rule: NIC/Passport must be unique (if provided)
        if (guest.getNicPassport() != null && !guest.getNicPassport().trim().isEmpty()) {
            if (guestDAO.nicPassportExists(guest.getNicPassport())) {
                return false;
            }
        }
        
        return guestDAO.addGuest(guest);
    }

    // ─── GET guest by ID ──────────────────────────────────────────────────────
    public Guest getGuestById(int id) throws SQLException {
        return guestDAO.getGuestById(id);
    }

    // ─── GET guest by code ────────────────────────────────────────────────────
    public Guest getGuestByCode(String guestCode) throws SQLException {
        return guestDAO.getGuestByCode(guestCode);
    }

    // ─── GET guest by email ───────────────────────────────────────────────────
    public Guest getGuestByEmail(String email) throws SQLException {
        return guestDAO.getGuestByEmail(email);
    }

    // ─── GET all guests ───────────────────────────────────────────────────────
    public List<Guest> getAllGuests() throws SQLException {
        return guestDAO.getAllGuests();
    }

    // ─── SEARCH guests ────────────────────────────────────────────────────────
    public List<Guest> searchGuests(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return guestDAO.getAllGuests();
        }
        return guestDAO.searchGuests(keyword.trim());
    }

    // ─── UPDATE guest ─────────────────────────────────────────────────────────
    public boolean updateGuest(Guest guest) throws SQLException {

	    	if (guest.getNicPassport() != null && !guest.getNicPassport().trim().isEmpty()) {
	            if (guestDAO.nicPassportExistsExcludingId(guest.getNicPassport(), guest.getId())) {
	                return false;
	          }
        }

        return guestDAO.updateGuest(guest);
    }

    // ─── DELETE guest (soft) ──────────────────────────────────────────────────
    public boolean deleteGuest(int id) throws SQLException {
        return guestDAO.deleteGuest(id);
    }

    // ─── TOGGLE blacklist ─────────────────────────────────────────────────────
    public boolean toggleBlacklist(int id, boolean blacklisted) throws SQLException {
        return guestDAO.toggleBlacklist(id, blacklisted);
    }

    // ─── INCREMENT stay count ─────────────────────────────────────────────────
    public boolean incrementTotalStays(int id) throws SQLException {
        // Auto promote to VIP after 5 stays
        Guest guest = guestDAO.getGuestById(id);
        if (guest != null && guest.isEligibleForVip() && !guest.isVip()) {
            guest.setVip(true);
            guestDAO.updateGuest(guest);
        }
        return guestDAO.incrementTotalStays(id);
    }

    // ─── CHECK email exists ───────────────────────────────────────────────────
    public boolean emailExists(String email) throws SQLException {
        return guestDAO.emailExists(email);
    }
    
    public boolean nicPassportExists(String nicPassport) throws SQLException {
        return guestDAO.nicPassportExists(nicPassport);
    }

}