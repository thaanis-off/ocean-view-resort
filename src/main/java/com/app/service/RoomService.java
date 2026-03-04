package com.app.service;

import com.app.dao.RoomDAO;
import com.app.model.Room;
import java.sql.SQLException;
import java.util.List;

public class RoomService {

    private RoomDAO roomDAO = new RoomDAO();

    // ─── ADD new room ─────────────────────────────────────────────────────────
    public boolean addRoom(Room room) throws SQLException {
        // Business rule: room number must be unique
        if (roomDAO.roomNumberExists(room.getRoomNumber())) {
            return false;
        }
        return roomDAO.addRoom(room);
    }

    // ─── GET room by ID ───────────────────────────────────────────────────────
    public Room getRoomById(int id) throws SQLException {
        return roomDAO.getRoomById(id);
    }

    // ─── GET room by number ───────────────────────────────────────────────────
    public Room getRoomByNumber(String roomNumber) throws SQLException {
        return roomDAO.getRoomByNumber(roomNumber);
    }

    // ─── GET all rooms ────────────────────────────────────────────────────────
    public List<Room> getAllRooms() throws SQLException {
        return roomDAO.getAllRooms();
    }

    // ─── GET rooms by status ──────────────────────────────────────────────────
    public List<Room> getRoomsByStatus(String status) throws SQLException {
        return roomDAO.getRoomsByStatus(status);
    }

    // ─── GET rooms by floor ───────────────────────────────────────────────────
    public List<Room> getRoomsByFloor(int floorNumber) throws SQLException {
        return roomDAO.getRoomsByFloor(floorNumber);
    }

    // ─── GET rooms by type ────────────────────────────────────────────────────
    public List<Room> getRoomsByType(int roomTypeId) throws SQLException {
        return roomDAO.getRoomsByType(roomTypeId);
    }

    // ─── SEARCH rooms ─────────────────────────────────────────────────────────
    public List<Room> searchRooms(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return roomDAO.getAllRooms();
        }
        return roomDAO.searchRooms(keyword.trim());
    }

    // ─── UPDATE room ──────────────────────────────────────────────────────────
    public boolean updateRoom(Room room) throws SQLException {
        // Check if room number is taken by another room
        if (roomDAO.roomNumberExistsExcludingId(room.getRoomNumber(), room.getId())) {
            return false;
        }
        return roomDAO.updateRoom(room);
    }

    // ─── UPDATE room status ───────────────────────────────────────────────────
    public boolean updateRoomStatus(int id, String status) throws SQLException {
        return roomDAO.updateRoomStatus(id, status);
    }

    // ─── DELETE room (soft) ───────────────────────────────────────────────────
    public boolean deleteRoom(int id) throws SQLException {
        // Business rule: Can only delete rooms that are Available or Maintenance
        Room room = roomDAO.getRoomById(id);
        if (room != null && room.isOccupied()) {
            return false; // Cannot delete occupied room
        }
        return roomDAO.deleteRoom(id);
    }

    // ─── CHECK room number exists ─────────────────────────────────────────────
    public boolean roomNumberExists(String roomNumber) throws SQLException {
        return roomDAO.roomNumberExists(roomNumber);
    }

    // ─── GET available rooms ──────────────────────────────────────────────────
    public List<Room> getAvailableRooms() throws SQLException {
        return roomDAO.getAvailableRooms();
    }

    // ─── GET room count by status ─────────────────────────────────────────────
    public int getRoomCountByStatus(String status) throws SQLException {
        return roomDAO.getRoomCountByStatus(status);
    }

    // ─── MARK room as available ───────────────────────────────────────────────
    public boolean markAsAvailable(int id) throws SQLException {
        return roomDAO.updateRoomStatus(id, "Available");
    }

    // ─── MARK room as occupied ────────────────────────────────────────────────
    public boolean markAsOccupied(int id) throws SQLException {
        return roomDAO.updateRoomStatus(id, "Occupied");
    }

    // ─── MARK room as maintenance ─────────────────────────────────────────────
    public boolean markAsMaintenance(int id) throws SQLException {
        return roomDAO.updateRoomStatus(id, "Maintenance");
    }

    // ─── MARK room as reserved ────────────────────────────────────────────────
    public boolean markAsReserved(int id) throws SQLException {
        return roomDAO.updateRoomStatus(id, "Reserved");
    }
}