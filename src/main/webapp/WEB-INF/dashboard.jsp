<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#f0f4ff',
                            100: '#e8f0fb',
                            500: '#1B4F8A',
                            600: '#163d6e',
                            700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
    <style>
        .gradient-card {
            background: linear-gradient(135deg, rgba(27, 79, 138, 0.1) 0%, rgba(27, 79, 138, 0.05) 100%);
        }
    </style>
</head>
<body class="bg-gray-950 text-gray-100">
    <div class="flex h-screen overflow-hidden">
        
        <!-- Sidebar -->
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
                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Main</div>
                
                <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center px-4 py-3 text-sm font-medium text-white bg-gray-800 rounded-lg">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                    Dashboard
                </a>

                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">Management</div>
                
                <a href="${pageContext.request.contextPath}/guest?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                    Guests
                </a>

                <a href="${pageContext.request.contextPath}/room?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                    Rooms
                </a>

                <a href="${pageContext.request.contextPath}/roomtype?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                    </svg>
                    Room Types
                </a>

                <a href="${pageContext.request.contextPath}/reservation?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                    Reservations
                </a>

                <a href="${pageContext.request.contextPath}/payment?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                    </svg>
                    Payments
                </a>

                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">System</div>

                <a href="${pageContext.request.contextPath}/staff?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    Staff
                </a>

                <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                    </svg>
                    Logout
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            
            <!-- Top Bar -->
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-white">Dashboard</h1>
                        <p class="text-sm text-gray-400 mt-1">Welcome back! Here's what's happening today.</p>
                    </div>
                    <button class="flex items-center space-x-2 px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-lg transition-colors">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        <span class="font-medium">Quick Create</span>
                    </button>
                </div>
            </header>

            <!-- Dashboard Content -->
            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    
                    <!-- Total Revenue -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 hover:border-primary-500 transition-colors">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <p class="text-sm text-gray-400 font-medium">Today's Revenue</p>
                                <h3 class="text-3xl font-bold text-white mt-2">
                                    $<fmt:formatNumber value="${stats.todayRevenue}" pattern="#,##0.00"/>
                                </h3>
                            </div>
                            <div class="flex items-center space-x-1 text-green-500 text-sm">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                                </svg>
                                <span class="font-medium">+12.5%</span>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-gray-400">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                            </svg>
                            <span>Trending up this month</span>
                        </div>
                    </div>

                    <!-- Occupancy Rate -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 hover:border-primary-500 transition-colors">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <p class="text-sm text-gray-400 font-medium">Occupancy Rate</p>
                                <h3 class="text-3xl font-bold text-white mt-2">${stats.occupancyRate}%</h3>
                            </div>
                            <div class="flex items-center space-x-1 text-green-500 text-sm">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                                </svg>
                                <span class="font-medium">+8.2%</span>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-gray-400">
                            <span>${stats.occupiedRooms} of ${stats.totalRooms} rooms occupied</span>
                        </div>
                    </div>

                    <!-- Active Reservations -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 hover:border-primary-500 transition-colors">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <p class="text-sm text-gray-400 font-medium">Active Reservations</p>
                                <h3 class="text-3xl font-bold text-white mt-2">${stats.checkedInReservations}</h3>
                            </div>
                            <div class="flex items-center space-x-1 text-green-500 text-sm">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                                </svg>
                                <span class="font-medium">+15.3%</span>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-gray-400">
                            <span>${stats.confirmedReservations} confirmed upcoming</span>
                        </div>
                    </div>

                    <!-- Total Guests -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 hover:border-primary-500 transition-colors">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <p class="text-sm text-gray-400 font-medium">Total Guests</p>
                                <h3 class="text-3xl font-bold text-white mt-2">${stats.totalGuests}</h3>
                            </div>
                            <div class="flex items-center space-x-1 text-green-500 text-sm">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                                </svg>
                                <span class="font-medium">+4.5%</span>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-gray-400">
                            <span>Registered in system</span>
                        </div>
                    </div>
                </div>

                <!-- Today's Activity & Recent Reservations -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    
                    <!-- Today's Check-ins/Check-outs -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-white mb-4">Today's Activity</h3>
                        <div class="space-y-4">
                            <div class="flex items-center justify-between p-4 bg-gray-800 rounded-lg">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-green-500/10 rounded-lg flex items-center justify-center">
                                        <svg class="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-white">Check-ins Today</p>
                                        <p class="text-xs text-gray-400">${stats.todayCheckIns} guests arriving</p>
                                    </div>
                                </div>
                                <span class="text-2xl font-bold text-white">${stats.todayCheckIns}</span>
                            </div>
                            
                            <div class="flex items-center justify-between p-4 bg-gray-800 rounded-lg">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-blue-500/10 rounded-lg flex items-center justify-center">
                                        <svg class="w-5 h-5 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-white">Check-outs Today</p>
                                        <p class="text-xs text-gray-400">${stats.todayCheckOuts} guests departing</p>
                                    </div>
                                </div>
                                <span class="text-2xl font-bold text-white">${stats.todayCheckOuts}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Room Status -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-white mb-4">Room Status</h3>
                        <div class="space-y-3">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                                    <span class="text-sm text-gray-300">Available</span>
                                </div>
                                <span class="text-sm font-medium text-white">${stats.availableRooms}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                                    <span class="text-sm text-gray-300">Occupied</span>
                                </div>
                                <span class="text-sm font-medium text-white">${stats.occupiedRooms}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-yellow-500 rounded-full"></div>
                                    <span class="text-sm text-gray-300">Maintenance</span>
                                </div>
                                <span class="text-sm font-medium text-white">${stats.maintenanceRooms}</span>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-blue-500 rounded-full"></div>
                                    <span class="text-sm text-gray-300">Reserved</span>
                                </div>
                                <span class="text-sm font-medium text-white">${stats.reservedRooms}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Reservations -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-white">Recent Reservations</h3>
                        <a href="${pageContext.request.contextPath}/reservation?action=list" class="text-sm text-primary-400 hover:text-primary-300">View all →</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="text-left text-xs font-medium text-gray-400 uppercase tracking-wider border-b border-gray-800">
                                    <th class="pb-3">Reservation</th>
                                    <th class="pb-3">Guest</th>
                                    <th class="pb-3">Room</th>
                                    <th class="pb-3">Check-in</th>
                                    <th class="pb-3">Status</th>
                                    <th class="pb-3 text-right">Amount</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-800">
                                <c:forEach var="res" items="${stats.recentReservations}">
                                <tr class="text-sm">
                                    <td class="py-4 font-medium text-white">${res.reservationNumber}</td>
                                    <td class="py-4 text-gray-300">${res.guestName}</td>
                                    <td class="py-4 text-gray-300">${res.roomNumber}</td>
                                    <td class="py-4 text-gray-300">${res.checkInDate}</td>
                                    <td class="py-4">
                                        <span class="px-2 py-1 text-xs font-medium rounded-full
                                            ${res.status == 'Confirmed' ? 'bg-blue-500/10 text-blue-400' : ''}
                                            ${res.status == 'Pending' ? 'bg-yellow-500/10 text-yellow-400' : ''}
                                            ${res.status == 'CheckedIn' ? 'bg-green-500/10 text-green-400' : ''}">
                                            ${res.status}
                                        </span>
                                    </td>
                                    <td class="py-4 text-right font-medium text-white">$<fmt:formatNumber value="${res.totalAmount}" pattern="#,##0.00"/></td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>
    </div>
</body>
</html>