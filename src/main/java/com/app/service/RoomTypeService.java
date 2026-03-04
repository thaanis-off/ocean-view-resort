package com.app.service;

import com.app.dao.RoomTypeDAO;
import com.app.model.RoomType;
import java.sql.SQLException;
import java.util.List;

public class RoomTypeService {

    private RoomTypeDAO roomTypesDAO = new RoomTypeDAO();

    // ─── ADD new room type ────────────────────────────────────────────────────
    public boolean addRoomType(RoomType roomType) throws SQLException {
        // Business rule: type name must be unique
        if (roomTypesDAO.typeNameExists(roomType.getTypeName())) {
            return false;
        }
        return roomTypesDAO.addRoomType(roomType);
    }

    // ─── GET room type by ID ──────────────────────────────────────────────────
    public RoomType getRoomTypeById(int id) throws SQLException {
        return roomTypesDAO.getRoomTypeById(id);
    }

    // ─── GET room type by name ────────────────────────────────────────────────
    public RoomType getRoomTypeByName(String typeName) throws SQLException {
        return roomTypesDAO.getRoomTypeByName(typeName);
    }

    // ─── GET all room types ───────────────────────────────────────────────────
    public List<RoomType> getAllRoomTypes() throws SQLException {
        return roomTypesDAO.getAllRoomTypes();
    }

    // ─── SEARCH room types ────────────────────────────────────────────────────
    public List<RoomType> searchRoomTypes(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return roomTypesDAO.getAllRoomTypes();
        }
        return roomTypesDAO.searchRoomTypes(keyword.trim());
    }

    // ─── UPDATE room type ─────────────────────────────────────────────────────
    public boolean updateRoomType(RoomType roomType) throws SQLException {
        // Check if type name is taken by another room type
        if (roomTypesDAO.typeNameExistsExcludingId(roomType.getTypeName(), roomType.getId())) {
            return false;
        }
        return roomTypesDAO.updateRoomType(roomType);
    }

    // ─── DELETE room type ─────────────────────────────────────────────────────
    public boolean deleteRoomType(int id) throws SQLException {
        // Business rule: Cannot delete if rooms are using this type
        int roomCount = roomTypesDAO.getRoomCountByType(id);
        if (roomCount > 0) {
            return false; // Cannot delete room type with existing rooms
        }
        return roomTypesDAO.deleteRoomType(id);
    }

    // ─── CHECK type name exists ───────────────────────────────────────────────
    public boolean typeNameExists(String typeName) throws SQLException {
        return roomTypesDAO.typeNameExists(typeName);
    }

    // ─── GET room count by type ───────────────────────────────────────────────
    public int getRoomCountByType(int roomTypeId) throws SQLException {
        return roomTypesDAO.getRoomCountByType(roomTypeId);
    }
}