package com.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ExtraCharge {
    private int id;
    private int reservationId;
    private String description;
    private String category; // Food, Spa, Laundry, Excursion, Other
    private BigDecimal amount;
    private LocalDate chargeDate;
    private int addedBy; // staff_id

    // Joined fields from other tables
    private String reservationNumber;
    private String addedByName;

    // Constructors
    public ExtraCharge() {}

    public ExtraCharge(int reservationId, String description, String category, BigDecimal amount, LocalDate chargeDate, int addedBy) {
        this.reservationId = reservationId;
        this.description = description;
        this.category = category;
        this.amount = amount;
        this.chargeDate = chargeDate;
        this.addedBy = addedBy;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public LocalDate getChargeDate() { return chargeDate; }
    public void setChargeDate(LocalDate chargeDate) { this.chargeDate = chargeDate; }

    public int getAddedBy() { return addedBy; }
    public void setAddedBy(int addedBy) { this.addedBy = addedBy; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public String getAddedByName() { return addedByName; }
    public void setAddedByName(String addedByName) { this.addedByName = addedByName; }
}