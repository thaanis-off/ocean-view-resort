package com.app.service;

import com.app.dao.*;
import com.app.model.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class BillService {
    
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ExtraChargeDAO extraChargeDAO = new ExtraChargeDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    
    // Tax rate (12% for Sri Lanka VAT)
    private static final BigDecimal TAX_RATE = new BigDecimal("12.00");
    
    /**
     * Generate complete bill for a reservation
     */
    public Bill generateBill(int reservationId) throws SQLException {
        Bill bill = new Bill();
        
        // Get reservation details
        Reservation reservation = reservationDAO.getReservationById(reservationId);
        if (reservation == null) {
            throw new SQLException("Reservation not found");
        }
        
        // Set basic reservation info
        bill.setReservationId(reservationId);
        bill.setReservationNumber(reservation.getReservationNumber());
        bill.setGuestName(reservation.getGuestName());
        bill.setGuestEmail(reservation.getGuestEmail());
        bill.setGuestPhone(reservation.getGuestPhone());
        bill.setRoomNumber(reservation.getRoomNumber());
        bill.setRoomTypeName(reservation.getRoomTypeName());
        bill.setCheckInDate(reservation.getCheckInDate());
        bill.setCheckOutDate(reservation.getCheckOutDate());
        bill.setNumAdults(reservation.getNumAdults());
        bill.setNumChildren(reservation.getNumChildren());
        
        // Calculate number of nights
        long numNights = ChronoUnit.DAYS.between(
            reservation.getCheckInDate(), 
            reservation.getCheckOutDate()
        );
        bill.setNumNights((int) numNights);
        
        // Calculate room charges
        BigDecimal pricePerNight = reservation.getTotalAmount().divide(
            new BigDecimal(numNights), 2, RoundingMode.HALF_UP
        );
        bill.setPricePerNight(pricePerNight);
        bill.setRoomCharges(reservation.getTotalAmount());
        
        // Get extra charges
        List<ExtraCharge> extraCharges = extraChargeDAO.getChargesByReservation(reservationId);
        bill.setExtraChargesList(extraCharges);
        
        BigDecimal totalExtraCharges = BigDecimal.ZERO;
        for (ExtraCharge ec : extraCharges) {
            totalExtraCharges = totalExtraCharges.add(ec.getAmount());
        }
        bill.setExtraCharges(totalExtraCharges);
        
        // Calculate subtotal (room + extras)
        BigDecimal subtotal = bill.getRoomCharges().add(totalExtraCharges);
        bill.setSubtotal(subtotal);
        
        // Calculate tax (12% VAT)
        bill.setTaxRate(TAX_RATE);
        BigDecimal taxAmount = subtotal.multiply(TAX_RATE)
            .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        bill.setTaxAmount(taxAmount);
        
        // Calculate total amount (subtotal + tax)
        BigDecimal totalAmount = subtotal.add(taxAmount);
        bill.setTotalAmount(totalAmount);
        
        // Get payments made
        List<Payment> payments = paymentDAO.getPaymentsByReservation(reservationId);
        bill.setPaymentsList(payments);
        
        BigDecimal paidAmount = BigDecimal.ZERO;
        for (Payment p : payments) {
            paidAmount = paidAmount.add(p.getAmount());
        }
        bill.setPaidAmount(paidAmount);
        
        // Calculate balance due
        BigDecimal balanceDue = totalAmount.subtract(paidAmount);
        bill.setBalanceDue(balanceDue);
        
        // Determine payment status
        if (balanceDue.compareTo(BigDecimal.ZERO) <= 0) {
            bill.setStatus("Paid");
        } else if (paidAmount.compareTo(BigDecimal.ZERO) > 0) {
            bill.setStatus("Partial");
        } else {
            bill.setStatus("Unpaid");
        }
        
        return bill;
    }
}