package com.app.service;

import com.app.dao.PaymentDAO;
import com.app.model.Payment;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class PaymentService {

    private PaymentDAO paymentDAO = new PaymentDAO();

    // ─── ADD new payment ──────────────────────────────────────────────────────
    public boolean addPayment(Payment payment) throws SQLException {
        return paymentDAO.addPayment(payment);
    }

    // ─── GET payment by ID ────────────────────────────────────────────────────
    public Payment getPaymentById(int id) throws SQLException {
        return paymentDAO.getPaymentById(id);
    }

    // ─── GET all payments ─────────────────────────────────────────────────────
    public List<Payment> getAllPayments() throws SQLException {
        return paymentDAO.getAllPayments();
    }

    // ─── GET payments by reservation ──────────────────────────────────────────
    public List<Payment> getPaymentsByReservation(int reservationId) throws SQLException {
        return paymentDAO.getPaymentsByReservation(reservationId);
    }

    // ─── GET payments by method ───────────────────────────────────────────────
    public List<Payment> getPaymentsByMethod(String paymentMethod) throws SQLException {
        return paymentDAO.getPaymentsByMethod(paymentMethod);
    }

    // ─── GET payments by type ─────────────────────────────────────────────────
    public List<Payment> getPaymentsByType(String paymentType) throws SQLException {
        return paymentDAO.getPaymentsByType(paymentType);
    }

    // ─── GET payments by date range ───────────────────────────────────────────
    public List<Payment> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        return paymentDAO.getPaymentsByDateRange(startDate, endDate);
    }

    // ─── GET today's payments ─────────────────────────────────────────────────
    public List<Payment> getTodayPayments() throws SQLException {
        return paymentDAO.getTodayPayments();
    }

    // ─── SEARCH payments ──────────────────────────────────────────────────────
    public List<Payment> searchPayments(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return paymentDAO.getAllPayments();
        }
        return paymentDAO.searchPayments(keyword.trim());
    }

    // ─── UPDATE payment ───────────────────────────────────────────────────────
    public boolean updatePayment(Payment payment) throws SQLException {
        return paymentDAO.updatePayment(payment);
    }

    // ─── DELETE payment ───────────────────────────────────────────────────────
    public boolean deletePayment(int id) throws SQLException {
        // Business rule: Consider if payment should be deletable
        // Some systems might prefer to use Refund instead of deleting
        return paymentDAO.deletePayment(id);
    }

    // ─── GET total paid for reservation ───────────────────────────────────────
    public BigDecimal getTotalPaidForReservation(int reservationId) throws SQLException {
        return paymentDAO.getTotalPaidForReservation(reservationId);
    }

    // ─── GET total refunded for reservation ───────────────────────────────────
    public BigDecimal getTotalRefundedForReservation(int reservationId) throws SQLException {
        return paymentDAO.getTotalRefundedForReservation(reservationId);
    }

    // ─── GET net payment for reservation ──────────────────────────────────────
    public BigDecimal getNetPaymentForReservation(int reservationId) throws SQLException {
        BigDecimal totalPaid = paymentDAO.getTotalPaidForReservation(reservationId);
        BigDecimal totalRefunded = paymentDAO.getTotalRefundedForReservation(reservationId);
        return totalPaid.subtract(totalRefunded);
    }

    // ─── GET payment statistics ───────────────────────────────────────────────
    public Map<String, BigDecimal> getPaymentStatistics() throws SQLException {
        return paymentDAO.getPaymentStatistics();
    }

    // ─── CALCULATE balance due ────────────────────────────────────────────────
    public BigDecimal calculateBalanceDue(int reservationId, BigDecimal totalAmount) throws SQLException {
        BigDecimal netPayment = getNetPaymentForReservation(reservationId);
        return totalAmount.subtract(netPayment);
    }

    // ─── CHECK if fully paid ──────────────────────────────────────────────────
    public boolean isFullyPaid(int reservationId, BigDecimal totalAmount) throws SQLException {
        BigDecimal netPayment = getNetPaymentForReservation(reservationId);
        return netPayment.compareTo(totalAmount) >= 0;
    }
}