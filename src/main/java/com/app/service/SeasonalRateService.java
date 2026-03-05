package com.app.service;

import com.app.dao.SeasonalRateDAO;
import com.app.model.Room;
import com.app.model.SeasonalRate;
import java.sql.SQLException;
import java.util.List;

public class SeasonalRateService {
    
    private SeasonalRateDAO seasonalRateDAO = new SeasonalRateDAO();

    // ─── ADD new seasonal rate ────────────────────────────────────────────────
    public boolean addRate(SeasonalRate rate) throws SQLException {
        return seasonalRateDAO.addRate(rate);
    }

    // ─── GET seasonal rate by ID ──────────────────────────────────────────────
    public SeasonalRate getRateById(int id) throws SQLException {
        return seasonalRateDAO.getRateById(id);
    }

    // ─── GET all seasonal rates ───────────────────────────────────────────────
    public List<SeasonalRate> getAllRates() throws SQLException {
        return seasonalRateDAO.getAllRates();
    }
    
    // ─── SEARCH rooms ─────────────────────────────────────────────────────────
    public List<SeasonalRate> searchRates(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return seasonalRateDAO.getAllRates();
        }
        return seasonalRateDAO.searchRates(keyword.trim());
    }
    
    // ─── UPDATE seasonal rate ─────────────────────────────────────────────────
    public boolean updateRate(SeasonalRate rate) throws SQLException {
        return seasonalRateDAO.updateRate(rate);
    }

    // ─── DELETE seasonal rate ─────────────────────────────────────────────────
    public boolean deleteRate(int id) throws SQLException {
        return seasonalRateDAO.deleteRate(id);
    }
}