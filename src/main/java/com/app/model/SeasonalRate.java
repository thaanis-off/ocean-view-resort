package com.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class SeasonalRate {
    private int id;
    private int roomTypeId;
    private String seasonName;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal pricePerNight;
    private BigDecimal discountPct;
    private boolean isActive;
    private LocalDateTime createdAt;
    private boolean currentlyActive;
    // Joined fields
    private String roomTypeName;

    // Constructors
    public SeasonalRate() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getSeasonName() { return seasonName; }
    public void setSeasonName(String seasonName) { this.seasonName = seasonName; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public BigDecimal getDiscountPct() { return discountPct; }
    public void setDiscountPct(BigDecimal discountPct) { this.discountPct = discountPct; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

   
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
    
    // Utility method to check if the rate is currently ongoing today
    public boolean isCurrentlyActive() {
        if (!isActive) return false;
        LocalDate today = LocalDate.now();
        return (today.isEqual(startDate) || today.isAfter(startDate)) && 
               (today.isEqual(endDate) || today.isBefore(endDate));
    }

    public void setCurrentlyActive(boolean currentlyActive) { 
        this.currentlyActive = currentlyActive; 
    }
}