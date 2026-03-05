package com.app.controller;

import com.app.model.Room;
import com.app.model.RoomType;
import com.app.model.SeasonalRate;
import com.app.service.SeasonalRateService;
import com.app.service.RoomService;
import com.app.service.RoomTypeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/seasonalRates")
public class SeasonalRateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private SeasonalRateService seasonalRateService;
    private RoomService roomService; 
    private RoomTypeService roomTypeService;


    @Override
    public void init() {
        seasonalRateService = new SeasonalRateService();
        roomService = new RoomService();
        roomTypeService = new RoomTypeService();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list": listRates(request, response); break;
                case "new": showAddForm(request, response, null); break;
                case "edit": showEditForm(request, response);break;
                case "view": viewRate(request, response); break;
                case "filter": filterRates(request, response); break;
                case "search": searchRates(request, response); break;
                case "delete": deleteRate(request, response); break;
                default: listRates(request, response); break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action) || "update".equals(action)) {
                saveRate(request, response, action);
            } else {
                response.sendRedirect(request.getContextPath() + "/seasonalRates?action=list");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    private void listRates(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<SeasonalRate> rates = seasonalRateService.getAllRates();
        request.setAttribute("rates", rates);
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonalrate-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response, SeasonalRate rate)
            throws SQLException, ServletException, IOException {
        request.setAttribute("rate", rate);
        
        List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);

        
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonal-rate.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        SeasonalRate rate = seasonalRateService.getRateById(id);
        
        if (rate == null) {
            response.sendRedirect(request.getContextPath()
                    + "/room?action=list&error=notfound");
            return;
        }

        // Load room types for dropdown
        List<RoomType> roomTypes = roomTypeService.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rate", rate);        
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonal-rate.jsp").forward(request, response);    
 }
    
    // ─── VIEW single rate ─────────────────────────────────────────────────────
    private void viewRate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        SeasonalRate rate = seasonalRateService.getRateById(id);

        if (rate == null) {
            response.sendRedirect(request.getContextPath()
                    + "/seasonalRates?action=list&error=notfound");
            return;
        }

        request.setAttribute("rate", rate);
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonalrate-view.jsp")
               .forward(request, response);
    }

    private void saveRate(HttpServletRequest request, HttpServletResponse response, String action)
            throws SQLException, IOException {
        SeasonalRate rate = new SeasonalRate();
        rate.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
        rate.setSeasonName(request.getParameter("seasonName"));
        rate.setStartDate(LocalDate.parse(request.getParameter("startDate")));
        rate.setEndDate(LocalDate.parse(request.getParameter("endDate")));
        rate.setPricePerNight(new BigDecimal(request.getParameter("pricePerNight")));
        
        String discount = request.getParameter("discountPct");
        rate.setDiscountPct(discount != null && !discount.isEmpty() ? new BigDecimal(discount) : BigDecimal.ZERO);
        rate.setActive(request.getParameter("isActive") != null);

        if ("create".equals(action)) {
            seasonalRateService.addRate(rate);
            response.sendRedirect(request.getContextPath() + "/seasonalRates?action=list&success=added");
        } else {
            rate.setId(Integer.parseInt(request.getParameter("id")));
            seasonalRateService.updateRate(rate);
            response.sendRedirect(request.getContextPath() + "/seasonalRates?action=list&success=updated");
        }
    }
    
 // ─── SEARCH Seasonal Rates ──────────────────────────────────────────────
    private void searchRates(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String keyword = request.getParameter("keyword");
        
        // Use the service to get the filtered list of rates
        List<SeasonalRate> rates = seasonalRateService.searchRates(keyword);

        // Optional: Calculate status for each rate (Ongoing, Scheduled, etc.) 
        // if your JSP relies on the "currentlyActive" property.
        LocalDate today = LocalDate.now();
        for (SeasonalRate rate : rates) {
            rate.setCurrentlyActive(isCurrentlyActive(rate, today));
        }

        
        request.setAttribute("rates", rates); 
        request.setAttribute("keyword", keyword);
        
        
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonalrate-list.jsp")
               .forward(request, response);
    }
    
 // ─── FILTER rates ────────────────────────────────────────────────────────
    private void filterRates(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        
        List<SeasonalRate> rates = seasonalRateService.getAllRates();
        LocalDate today = LocalDate.now();
        
        // Set current status for each rate
        for (SeasonalRate rate : rates) {
            rate.setCurrentlyActive(isCurrentlyActive(rate, today));
        }
        
        // Apply filter based on status
        if ("status".equals(filterType) && filterValue != null && !filterValue.isEmpty()) {
            rates = rates.stream()
                .filter(rate -> matchesStatus(rate, filterValue, today))
                .collect(Collectors.toList());
        }
        
        request.setAttribute("rates", rates);
        request.setAttribute("filterType", filterType);
        request.setAttribute("filterValue", filterValue);
        request.getRequestDispatcher("/WEB-INF/views/app-views/seasonalrate-list.jsp")
               .forward(request, response);
    }

    

    // ─── HELPER: Check if rate is currently active ───────────────────────────
    private boolean isCurrentlyActive(SeasonalRate rate, LocalDate today) {
        if (!rate.isActive()) {
            return false; // If disabled, not currently active
        }
        
        LocalDate startDate = rate.getStartDate();
        LocalDate endDate = rate.getEndDate();
        
        // Check if today is within the date range
        return !today.isBefore(startDate) && !today.isAfter(endDate);
    }

    // ─── HELPER: Check if rate matches filter status ─────────────────────────
    private boolean matchesStatus(SeasonalRate rate, String filterValue, LocalDate today) {
        switch (filterValue) {
            case "Disabled":
                // isActive = 0 (false)
                return !rate.isActive();
                
            case "Ongoing":
                // isActive = 1 AND current date is within range
                return rate.isActive() && isCurrentlyActive(rate, today);
                
            case "Active":
                // isActive = 1 AND current date is NOT within range (scheduled for future)
                return rate.isActive() && !isCurrentlyActive(rate, today);
                
            default:
                return true; // Show all if no filter
        }
    }
 
    
    private void deleteRate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        seasonalRateService.deleteRate(id);
        response.sendRedirect(request.getContextPath() + "/seasonalRates?action=list&success=deleted");
    }
}