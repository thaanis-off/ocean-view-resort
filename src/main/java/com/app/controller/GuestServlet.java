package com.app.controller;

import com.app.model.Guest;
import com.app.service.GuestService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/guest")
public class GuestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private GuestService guestService;

    @Override
    public void init() {
        guestService = new GuestService();
    }

    // ─── doGet ────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listGuests(request, response);
                    break;
                case "new":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewGuest(request, response);
                    break;
                case "delete":
                    deleteGuest(request, response);
                    break;
                case "search":
                    searchGuests(request, response);
                    break;
                case "toggleBlacklist":
                    toggleBlacklist(request, response);
                    break;
                default:
                    listGuests(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ─── doPost ───────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "create":
                    createGuest(request, response);
                    break;
                case "update":
                    updateGuest(request, response);
                    break;
                default:
                    listGuests(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ─── LIST all guests ──────────────────────────────────────────────────────
    private void listGuests(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Guest> guestList = guestService.getAllGuests();
        request.setAttribute("guestList", guestList);
        request.setAttribute("totalGuests", guestList.size());
        request.getRequestDispatcher("/WEB-INF/views/app-views/guest-list.jsp")
               .forward(request, response);
    }

    // ─── SHOW ADD FORM ────────────────────────────────────────────────────────
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
               .forward(request, response);
    }

    // ─── SHOW EDIT FORM ───────────────────────────────────────────────────────
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Guest guest = guestService.getGuestById(id);

        if (guest == null) {
            response.sendRedirect(request.getContextPath()
                    + "/guest?action=list&error=notfound");
            return;
        }

        request.setAttribute("guest", guest);
        request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
               .forward(request, response);
    }

    // ─── VIEW single guest ────────────────────────────────────────────────────
    private void viewGuest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Guest guest = guestService.getGuestById(id);

        if (guest == null) {
            response.sendRedirect(request.getContextPath()
                    + "/guest?action=list&error=notfound");
            return;
        }

        request.setAttribute("guest", guest);
        request.getRequestDispatcher("/WEB-INF/views/app-views/guest-view.jsp")
               .forward(request, response);
    }

    // ─── CREATE guest ─────────────────────────────────────────────────────────
    private void createGuest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Guest guest = buildGuestFromRequest(request);

        // Check duplicate email
        if (guestService.emailExists(guest.getEmail())) {
            request.setAttribute("errorMessage",
                    "A guest with this email already exists.");
           // request.setAttribute("guest", guest);
            request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
                   .forward(request, response);
            return;
        }
        
        if (guest.getNicPassport() != null && !guest.getNicPassport().trim().isEmpty()) {
            if (guestService.nicPassportExists(guest.getNicPassport())) {
                request.setAttribute("errorMessage",
                        "A guest with this NIC/Passport already exists.");
                // DON'T set guest attribute - just forward with the form parameters
                request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
                       .forward(request, response);
                return;
            }
        }

        boolean success = guestService.addGuest(guest);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/guest?action=list&success=added");
        } else {
            request.setAttribute("errorMessage",
                    "Failed to add guest. Please try again.");
           // request.setAttribute("guest", guest);
            request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
                   .forward(request, response);
        }
    }

    // ─── UPDATE guest ─────────────────────────────────────────────────────────
    private void updateGuest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Guest guest = buildGuestFromRequest(request);
        guest.setId(Integer.parseInt(request.getParameter("id")));

        boolean success = guestService.updateGuest(guest);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/guest?action=list&success=updated");
        } else {
            request.setAttribute("errorMessage",
                    "Failed to update guest. Please try again.");
            request.setAttribute("guest", guest);
            request.getRequestDispatcher("/WEB-INF/views/app-views/guest.jsp")
                   .forward(request, response);
        }
    }

    // ─── DELETE guest ─────────────────────────────────────────────────────────
    private void deleteGuest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        guestService.deleteGuest(id);
        response.sendRedirect(request.getContextPath()
                + "/guest?action=list&success=deleted");
    }

    // ─── SEARCH guests ────────────────────────────────────────────────────────
    private void searchGuests(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Guest> guestList = guestService.searchGuests(keyword);

        request.setAttribute("guestList", guestList);
        request.setAttribute("totalGuests", guestList.size());
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/app-views/guest-list.jsp")
               .forward(request, response);
    }

    // ─── TOGGLE blacklist ─────────────────────────────────────────────────────
    private void toggleBlacklist(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        boolean blacklisted = Boolean.parseBoolean(request.getParameter("blacklisted"));
        guestService.toggleBlacklist(id, blacklisted);

        response.sendRedirect(request.getContextPath()
                + "/guest?action=view&id=" + id);
    }

    // ─── BUILD Guest from request ─────────────────────────────────────────────
    private Guest buildGuestFromRequest(HttpServletRequest request) {
        Guest g = new Guest();

        g.setFirstName(request.getParameter("firstName"));
        g.setLastName(request.getParameter("lastName"));
        g.setEmail(request.getParameter("email"));
        g.setPhone(request.getParameter("phone"));
        g.setNicPassport(request.getParameter("nicPassport"));
        g.setNationality(request.getParameter("nationality"));
        g.setAddress(request.getParameter("address"));
        g.setGender(request.getParameter("gender"));
        g.setGuestType(request.getParameter("guestType"));

        // dateOfBirth is optional
        String dob = request.getParameter("dateOfBirth");
        if (dob != null && !dob.trim().isEmpty()) {
            g.setDateOfBirth(LocalDate.parse(dob));
        }

        // checkboxes return "on" when checked, null when not
        g.setVip("on".equals(request.getParameter("isVip")));
        g.setBlacklisted("on".equals(request.getParameter("blacklisted")));

        return g;
    }
}