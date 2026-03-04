package com.app.controller;

import com.app.model.RoomType;
import com.app.service.RoomTypeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/roomtype")
public class RoomTypeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private RoomTypeService roomTypeService;

    @Override
    public void init() {
    	roomTypeService = new RoomTypeService();
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
                    listRoomTypes(request, response);
                    break;
                case "new":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewRoomType(request, response);
                    break;
                case "delete":
                    deleteRoomType(request, response);
                    break;
                case "search":
                    searchRoomTypes(request, response);
                    break;
                default:
                    listRoomTypes(request, response);
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
                    createRoomType(request, response);
                    break;
                case "update":
                    updateRoomType(request, response);
                    break;
                default:
                    listRoomTypes(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ─── LIST all room types ──────────────────────────────────────────────────
    private void listRoomTypes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<RoomType> roomTypeList = roomTypeService.getAllRoomTypes();
        request.setAttribute("roomTypeList", roomTypeList);
        request.setAttribute("totalRoomTypes", roomTypeList.size());
        request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype-list.jsp")
               .forward(request, response);
    }

    // ─── SHOW ADD FORM ────────────────────────────────────────────────────────
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype.jsp")
               .forward(request, response);
    }

    // ─── SHOW EDIT FORM ───────────────────────────────────────────────────────
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        RoomType roomType = roomTypeService.getRoomTypeById(id);

        if (roomType == null) {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&error=notfound");
            return;
        }

        request.setAttribute("roomType", roomType);
        request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype.jsp")
               .forward(request, response);
    }

    // ─── VIEW single room type ────────────────────────────────────────────────
    private void viewRoomType(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        RoomType roomType = roomTypeService.getRoomTypeById(id);

        if (roomType == null) {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&error=notfound");
            return;
        }

        // Get room count for this type
        int roomCount = roomTypeService.getRoomCountByType(id);
        request.setAttribute("roomCount", roomCount);
        request.setAttribute("roomType", roomType);
        request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype-view.jsp")
               .forward(request, response);
    }

    // ─── CREATE room type ─────────────────────────────────────────────────────
    private void createRoomType(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        RoomType roomType = buildRoomTypeFromRequest(request);

        // Check duplicate type name
        if (roomTypeService.typeNameExists(roomType.getTypeName())) {
            request.setAttribute("errorMessage",
                    "A room type with this name already exists.");
            request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype.jsp")
                   .forward(request, response);
            return;
        }

        boolean success = roomTypeService.addRoomType(roomType);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&success=added");
        } else {
            request.setAttribute("errorMessage",
                    "Failed to add room type. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype.jsp")
                   .forward(request, response);
        }
    }

    // ─── UPDATE room type ─────────────────────────────────────────────────────
    private void updateRoomType(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        RoomType roomType = buildRoomTypeFromRequest(request);
        roomType.setId(Integer.parseInt(request.getParameter("id")));

        boolean success = roomTypeService.updateRoomType(roomType);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&success=updated");
        } else {
            request.setAttribute("errorMessage",
                    "Failed to update room type. Type name may already be in use.");
            request.setAttribute("roomType", roomType);
            request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype.jsp")
                   .forward(request, response);
        }
    }

    // ─── DELETE room type ─────────────────────────────────────────────────────
    private void deleteRoomType(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = roomTypeService.deleteRoomType(id);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/roomtype?action=list&error=cannotdelete");
        }
    }

    // ─── SEARCH room types ────────────────────────────────────────────────────
    private void searchRoomTypes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<RoomType> roomTypeList = roomTypeService.searchRoomTypes(keyword);

        request.setAttribute("roomTypeList", roomTypeList);
        request.setAttribute("totalRoomTypes", roomTypeList.size());
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/app-views/roomtype-list.jsp")
               .forward(request, response);
    }

    // ─── BUILD RoomType from request ──────────────────────────────────────────
    private RoomType buildRoomTypeFromRequest(HttpServletRequest request) {
        RoomType rt = new RoomType();

        rt.setTypeName(request.getParameter("typeName"));
        rt.setDescription(request.getParameter("description"));

        // Parse BigDecimal for base price
        String priceStr = request.getParameter("basePrice");
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            rt.setBasePrice(new BigDecimal(priceStr));
        }

        // Parse int for max occupancy
        String occupancyStr = request.getParameter("maxOccupancy");
        if (occupancyStr != null && !occupancyStr.trim().isEmpty()) {
            rt.setMaxOccupancy(Integer.parseInt(occupancyStr));
        }

        rt.setAmenities(request.getParameter("amenities"));

        return rt;
    }
}