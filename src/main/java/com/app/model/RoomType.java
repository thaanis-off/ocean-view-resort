package com.app.model;

import java.math.BigDecimal;

public class RoomType {
    private int id;
    private String typeName;
    private String description;
    private BigDecimal basePrice;
    private int maxOccupancy;
    private String amenities; // Simple String for now

    // Constructors
    public RoomType() {}
    public RoomType(String typeName, BigDecimal basePrice, int maxOccupancy) {
        this.typeName = typeName;
        this.basePrice = basePrice;
        this.maxOccupancy = maxOccupancy;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    public int getMaxOccupancy() { return maxOccupancy; }
    public void setMaxOccupancy(int maxOccupancy) { this.maxOccupancy = maxOccupancy; }
    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }
}