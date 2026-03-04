package com.app.controller;

import com.app.model.Room;
import com.app.model.RoomType;
import com.app.service.RoomService;
import com.app.service.RoomTypeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/room")
public class RoomServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private RoomService roomService;
    private RoomTypeService roomTypeService;

    @Override
    public void init() {
        roomService = new RoomService();
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
                    listRooms(request, response);
                    break;
                case "new":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewRoom(request, response);
                    break;
                case "delete":
                    deleteRoom(request, response);
                    break;
                case "search":
                    searchRooms(request, response);
                    break;
                case "filter":
                    filterRooms(request, response);
                    break;
                case "updateStatus":
                    updateRoomStatus(request, response);
                    break;
                default:
                    listRooms(request, response);
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
                    createRoom(request, response);
                    break;
                case "update":
                    updateRoom(request, response);
                    break;
                default:
                    listRooms(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    // ─── LIST all rooms ───────────────────────────────────────────────────────
    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Room> roomList = roomService.getAllRooms();
        
        // Get statistics
        int totalRooms = roomList.size();
        int availableCount = roomService.getRoomCountByStatus("Available");
        int occupiedCount = roomService.getRoomCountByStatus("Occupied");
        int maintenanceCount = roomService.getRoomCountByStatus("Maintenance");
        int reservedCount = roomService.getRoomCountByStatus("Reserved");

        request.setAttribute("roomList", roomList);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableCount", availableCount);
        request.setAttribute("occupiedCount", occupiedCount);
        request.setAttribute("maintenanceCount", maintenanceCount);
        request.setAttribute("reservedCount", reservedCount);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/room-list.jsp")
               .forward(request, response);
    }

    // ─── SHOW ADD FORM ────────────────────────────────────────────────────────
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Load room types for dropdown
        List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/room.jsp")
               .forward(request, response);
    }

    // ─── SHOW EDIT FORM ───────────────────────────────────────────────────────
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Room room = roomService.getRoomById(id);

        if (room == null) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&error=notfound");
            return;
        }

        // Load room types for dropdown
        List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("room", room);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/room.jsp")
               .forward(request, response);
    }

    // ─── VIEW single room ─────────────────────────────────────────────────────
    private void viewRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Room room = roomService.getRoomById(id);

        if (room == null) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&error=notfound");
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/WEB-INF/views/app-views/room-view.jsp")
               .forward(request, response);
    }

    // ─── CREATE room ──────────────────────────────────────────────────────────
    private void createRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Room room = buildRoomFromRequest(request);

        // Check duplicate room number
        if (roomService.roomNumberExists(room.getRoomNumber())) {
            List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("errorMessage",
                    "A room with this number already exists.");
            request.getRequestDispatcher("/WEB-INF/views/app-views/room.jsp")
                   .forward(request, response);
            return;
        }

        boolean success = roomService.addRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&success=added");
        } else {
            List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("errorMessage",
                    "Failed to add room. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/app-views/room.jsp")
                   .forward(request, response);
        }
    }

    // ─── UPDATE room ──────────────────────────────────────────────────────────
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Room room = buildRoomFromRequest(request);
        room.setId(Integer.parseInt(request.getParameter("id")));

        boolean success = roomService.updateRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&success=updated");
        } else {
            List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("errorMessage",
                    "Failed to update room. Room number may already be in use.");
            request.setAttribute("room", room);
            request.getRequestDispatcher("/WEB-INF/views/app-views/room.jsp")
                   .forward(request, response);
        }
    }

    // ─── DELETE room ──────────────────────────────────────────────────────────
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = roomService.deleteRoom(id);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&error=cannotdelete");
        }
    }

    // ─── SEARCH rooms ─────────────────────────────────────────────────────────
    private void searchRooms(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Room> roomList = roomService.searchRooms(keyword);

        // Get statistics
        int totalRooms = roomList.size();
        int availableCount = roomService.getRoomCountByStatus("Available");
        int occupiedCount = roomService.getRoomCountByStatus("Occupied");
        int maintenanceCount = roomService.getRoomCountByStatus("Maintenance");
        int reservedCount = roomService.getRoomCountByStatus("Reserved");

        request.setAttribute("roomList", roomList);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableCount", availableCount);
        request.setAttribute("occupiedCount", occupiedCount);
        request.setAttribute("maintenanceCount", maintenanceCount);
        request.setAttribute("reservedCount", reservedCount);
        request.setAttribute("keyword", keyword);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/room-list.jsp")
               .forward(request, response);
    }

    // ─── FILTER rooms ─────────────────────────────────────────────────────────
    private void filterRooms(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        
        List<Room> roomList;
        
        if ("status".equals(filterType)) {
            roomList = roomService.getRoomsByStatus(filterValue);
        } else if ("floor".equals(filterType)) {
            roomList = roomService.getRoomsByFloor(Integer.parseInt(filterValue));
        } else if ("type".equals(filterType)) {
            roomList = roomService.getRoomsByType(Integer.parseInt(filterValue));
        } else {
            roomList = roomService.getAllRooms();
        }

        // Get statistics
        int totalRooms = roomList.size();
        int availableCount = roomService.getRoomCountByStatus("Available");
        int occupiedCount = roomService.getRoomCountByStatus("Occupied");
        int maintenanceCount = roomService.getRoomCountByStatus("Maintenance");
        int reservedCount = roomService.getRoomCountByStatus("Reserved");

        request.setAttribute("roomList", roomList);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableCount", availableCount);
        request.setAttribute("occupiedCount", occupiedCount);
        request.setAttribute("maintenanceCount", maintenanceCount);
        request.setAttribute("reservedCount", reservedCount);
        request.setAttribute("filterType", filterType);
        request.setAttribute("filterValue", filterValue);
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/room-list.jsp")
               .forward(request, response);
    }

    // ─── UPDATE room status ───────────────────────────────────────────────────
    private void updateRoomStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        
        roomService.updateRoomStatus(id, status);
        response.sendRedirect(request.getContextPath()
                + "/room?action=view&id=" + id + "&success=statusupdated");
    }

    // ─── BUILD Room from request ──────────────────────────────────────────────
    private Room buildRoomFromRequest(HttpServletRequest request) {
        Room room = new Room();

        room.setRoomNumber(request.getParameter("roomNumber"));
        
        // Parse room type ID
        String roomTypeIdStr = request.getParameter("roomTypeId");
        if (roomTypeIdStr != null && !roomTypeIdStr.trim().isEmpty()) {
            room.setRoomTypeId(Integer.parseInt(roomTypeIdStr));
        }

        // Parse floor number
        String floorStr = request.getParameter("floorNumber");
        if (floorStr != null && !floorStr.trim().isEmpty()) {
            room.setFloorNumber(Integer.parseInt(floorStr));
        }

        room.setViewType(request.getParameter("viewType"));
        room.setStatus(request.getParameter("status"));

        // Parse price per night
        String priceStr = request.getParameter("pricePerNight");
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            room.setPricePerNight(new BigDecimal(priceStr));
        }

        // Active checkbox
        room.setActive("on".equals(request.getParameter("isActive")));

        return room;
    }
}