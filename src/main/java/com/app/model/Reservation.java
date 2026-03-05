package com.app.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class Reservation {
    private int id;
    private String reservationNumber;
    private int guestId;
    private int roomId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private LocalDateTime actualCheckIn;
    private LocalDateTime actualCheckOut;
    private int numAdults;
    private int numChildren;
    private String status; // Pending, Confirmed, CheckedIn, CheckedOut, Cancelled
    private BigDecimal totalAmount;
    private String specialRequests;
    private int bookedBy;
    private String bookedByName;
    private String source; // Website, Phone, Walk-in, Email, Agent
    private LocalDateTime createdAt;

    // Joined fields from other tables
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private String roomNumber;
    private String roomTypeName;

    // Constructors
    public Reservation() {}

    public Reservation(int guestId, int roomId, LocalDate checkInDate, LocalDate checkOutDate) {
        this.guestId = guestId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public LocalDate getCheckInDate() { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }

    public LocalDate getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }

    public LocalDateTime getActualCheckIn() { return actualCheckIn; }
    public void setActualCheckIn(LocalDateTime actualCheckIn) { this.actualCheckIn = actualCheckIn; }

    public LocalDateTime getActualCheckOut() { return actualCheckOut; }
    public void setActualCheckOut(LocalDateTime actualCheckOut) { this.actualCheckOut = actualCheckOut; }

    public int getNumAdults() { return numAdults; }
    public void setNumAdults(int numAdults) { this.numAdults = numAdults; }

    public int getNumChildren() { return numChildren; }
    public void setNumChildren(int numChildren) { this.numChildren = numChildren; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }

    public int getBookedBy() { return bookedBy; }
    public void setBookedBy(int bookedBy) { this.bookedBy = bookedBy; }

    public String getBookedByName() { return bookedByName; }
    public void setBookedByName(String bookedByName) { this.bookedByName = bookedByName; }

    
    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // Joined fields
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }

    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    // Utility methods
    public long getNumNights() {
        if (checkInDate != null && checkOutDate != null) {
            return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
        }
        return 0;
    }

    public int getTotalGuests() {
        return numAdults + numChildren;
    }

    public boolean isPending() {
        return "Pending".equalsIgnoreCase(this.status);
    }

    public boolean isConfirmed() {
        return "Confirmed".equalsIgnoreCase(this.status);
    }

    public boolean isCheckedIn() {
        return "CheckedIn".equalsIgnoreCase(this.status);
    }

    public boolean isCheckedOut() {
        return "CheckedOut".equalsIgnoreCase(this.status);
    }

    public boolean isCancelled() {
        return "Cancelled".equalsIgnoreCase(this.status);
    }

    public boolean isActive() {
        return !isCancelled() && !isCheckedOut();
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "id=" + id +
                ", reservationNumber='" + reservationNumber + '\'' +
                ", guestId=" + guestId +
                ", roomId=" + roomId +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", status='" + status + '\'' +
                '}';
    }
}