package com.app.model;

import java.math.BigDecimal;

public class Room {
    private int id;
    private String roomNumber;
    private int roomTypeId;
    private String roomTypeName; // For displaying room type name
    private int floorNumber;
    private String viewType;
    private String status; // Available, Occupied, Maintenance, Reserved
    private BigDecimal pricePerNight;
    private boolean active;

    // Constructors
    public Room() {}

    public Room(String roomNumber, int roomTypeId, int floorNumber) {
        this.roomNumber = roomNumber;
        this.roomTypeId = roomTypeId;
        this.floorNumber = floorNumber;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public int getFloorNumber() { return floorNumber; }
    public void setFloorNumber(int floorNumber) { this.floorNumber = floorNumber; }

    public String getViewType() { return viewType; }
    public void setViewType(String viewType) { this.viewType = viewType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    // Utility methods
    public boolean isAvailable() {
        return "Available".equalsIgnoreCase(this.status);
    }

    public boolean isOccupied() {
        return "Occupied".equalsIgnoreCase(this.status);
    }

    public boolean isUnderMaintenance() {
        return "Maintenance".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "Room{" +
                "id=" + id +
                ", roomNumber='" + roomNumber + '\'' +
                ", roomTypeId=" + roomTypeId +
                ", floorNumber=" + floorNumber +
                ", status='" + status + '\'' +
                '}';
    }
}