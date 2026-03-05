<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar Component -->
<aside class="w-64 bg-gray-900 border-r border-gray-800 flex flex-col">
    <!-- Logo -->
    <div class="p-6 border-b border-gray-800">
        <div class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-primary-500 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
            </div>
            <span class="text-lg font-semibold text-white">Ocean View Resort</span>
        </div>
    </div>
    
    <!-- Navigation -->
    <nav class="flex-1 px-4 py-6 space-y-1 overflow-y-auto">
        <!-- Main Section -->
        <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Main</div>
        <a href="${pageContext.request.contextPath}/dashboard" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'dashboard' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
            </svg>
            Dashboard
        </a>

        <!-- Management Section -->
        <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">Management</div>
        
        <a href="${pageContext.request.contextPath}/guest?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'guests' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
            </svg>
            Guests
        </a>
        
        <a href="${pageContext.request.contextPath}/room?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'rooms' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
            </svg>
            Rooms
        </a>
        
        <a href="${pageContext.request.contextPath}/roomtype?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'roomtypes' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
            </svg>
            Room Types
        </a>
        
        <a href="${pageContext.request.contextPath}/reservation?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'reservations' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
            </svg>
            Reservations
        </a>
        
        <a href="${pageContext.request.contextPath}/payment?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'payments' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
            </svg>
            Payments
        </a>

        <a href="${pageContext.request.contextPath}/seasonalRates?action=list" 
           class="flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${param.activePage == 'seasonalrates' ? 'text-white bg-gray-800' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Seasonal Rates
        </a>

        <!-- System Section -->
        <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">System</div>
        
        <a href="${pageContext.request.contextPath}/logout" 
           class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            Logout
        </a>
    </nav>
</aside>