package com.app.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private int id;
    private int reservationId;
    private BigDecimal amount;
    private LocalDateTime paymentDate;
    private String paymentMethod; // Cash, Credit Card, Debit Card, Bank Transfer, Online
    private String paymentType; // Deposit, Full Payment, Balance, Refund
    private String referenceNumber;
    private int receivedBy; // staff_id
    private String notes;

    // Joined fields from other tables
    private String reservationNumber;
    private String guestName;
    private String roomNumber;
    private String receivedByName;

    // Constructors
    public Payment() {}

    public Payment(int reservationId, BigDecimal amount, String paymentMethod, String paymentType) {
        this.reservationId = reservationId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentType = paymentType;
    }

    public String getFormattedPaymentDate() {
        if (this.paymentDate == null) {
            return "—";
        }
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return this.paymentDate.format(formatter);
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public LocalDateTime getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate) { this.paymentDate = paymentDate; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType; }

    public String getReferenceNumber() { return referenceNumber; }
    public void setReferenceNumber(String referenceNumber) { this.referenceNumber = referenceNumber; }

    public int getReceivedBy() { return receivedBy; }
    public void setReceivedBy(int receivedBy) { this.receivedBy = receivedBy; }

    public String getReceivedByName() { return receivedByName; }
    public void setReceivedByName(String receivedByName) { this.receivedByName = receivedByName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    // Joined fields
    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }


    // Utility methods
    public boolean isDeposit() {
        return "Deposit".equalsIgnoreCase(this.paymentType);
    }

    public boolean isFullPayment() {
        return "Full Payment".equalsIgnoreCase(this.paymentType);
    }

    public boolean isBalance() {
        return "Balance".equalsIgnoreCase(this.paymentType);
    }

    public boolean isRefund() {
        return "Refund".equalsIgnoreCase(this.paymentType);
    }

    public boolean isCash() {
        return "Cash".equalsIgnoreCase(this.paymentMethod);
    }

    public boolean isCard() {
        return "Credit Card".equalsIgnoreCase(this.paymentMethod) || 
               "Debit Card".equalsIgnoreCase(this.paymentMethod);
    }

    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", reservationId=" + reservationId +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentType='" + paymentType + '\'' +
                '}';
    }
}