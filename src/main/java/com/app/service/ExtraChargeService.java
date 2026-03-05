package com.app.service;

import com.app.dao.ExtraChargeDAO;
import com.app.model.ExtraCharge;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class ExtraChargeService {
    
    private ExtraChargeDAO extraChargeDAO = new ExtraChargeDAO();

    // ─── ADD new extra charge ─────────────────────────────────────────────────
    public boolean addExtraCharge(ExtraCharge charge) throws SQLException {
        return extraChargeDAO.addExtraCharge(charge);
    }

    // ─── GET extra charges by reservation ─────────────────────────────────────
    public List<ExtraCharge> getChargesByReservation(int reservationId) throws SQLException {
        return extraChargeDAO.getChargesByReservation(reservationId);
    }

    // ─── GET total extra charges for reservation ──────────────────────────────
    public BigDecimal getTotalChargesForReservation(int reservationId) throws SQLException {
        return extraChargeDAO.getTotalChargesForReservation(reservationId);
    }

    // ─── DELETE extra charge ──────────────────────────────────────────────────
    public boolean deleteExtraCharge(int id) throws SQLException {
        return extraChargeDAO.deleteExtraCharge(id);
    }
}