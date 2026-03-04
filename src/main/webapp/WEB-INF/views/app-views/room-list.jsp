<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms — Ocean View Resort</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                    },
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
</head>
<body class="bg-gray-950 text-gray-100 relative">
    <div class="flex h-screen overflow-hidden">
        
        <aside class="w-64 bg-gray-900 border-r border-gray-800 flex flex-col">
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
            <nav class="flex-1 px-4 py-6 space-y-1 overflow-y-auto">
                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Main</div>
                <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                    Dashboard
                </a>

                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">Management</div>
                <a href="${pageContext.request.contextPath}/guest?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                    Guests
                </a>
                
                <a href="${pageContext.request.contextPath}/room?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-white bg-gray-800 rounded-lg">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                    Rooms
                </a>
                
                <a href="${pageContext.request.contextPath}/roomtype?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                    Room Types
                </a>
                <a href="${pageContext.request.contextPath}/reservation?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                    Reservations
                </a>
                <a href="${pageContext.request.contextPath}/payment?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                    Payments
                </a>

                <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 mt-6">System</div>
                <a href="${pageContext.request.contextPath}/staff?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                    Staff
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                    Logout
                </a>
            </nav>
        </aside>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-white">Room Management</h1>
                        <p class="text-sm text-gray-400 mt-1">Manage hotel rooms, statuses, and pricing</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                        <a href="${pageContext.request.contextPath}/room?action=new" class="inline-flex items-center justify-center space-x-2 px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300 w-auto">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            <span>Add New Room</span>
                        </a>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <div class="grid grid-cols-2 md:grid-cols-5 gap-4 md:gap-6 mb-8">
                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary-600 to-blue-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Total Rooms</p>
                        <h3 class="text-2xl font-bold text-white mt-1">${totalRooms}</h3>
                    </div>

                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-green-600 to-green-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Available</p>
                        <h3 class="text-2xl font-bold text-green-500 mt-1">${availableCount}</h3>
                    </div>

                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-red-600 to-red-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Occupied</p>
                        <h3 class="text-2xl font-bold text-red-500 mt-1">${occupiedCount}</h3>
                    </div>

                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-yellow-600 to-yellow-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Maintenance</p>
                        <h3 class="text-2xl font-bold text-yellow-500 mt-1">${maintenanceCount}</h3>
                    </div>

                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-blue-600 to-blue-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Reserved</p>
                        <h3 class="text-2xl font-bold text-blue-500 mt-1">${reservedCount}</h3>
                    </div>
                </div>

                <div class="bg-gray-900 border border-gray-800 p-4 rounded-xl mb-6 flex flex-col md:flex-row gap-4 items-center">
                    <div class="flex-1 relative w-full">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </div>
                        <input type="text" id="searchInput" placeholder="Search rooms by number, type, or view..." value="${keyword}" onkeyup="liveSearch()" 
                            class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                    </div>
                    
                    <div class="w-full md:w-auto">
                        <select onchange="filterRooms(this.value)" class="w-full md:w-48 bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                            <option value="" class="bg-gray-900">All Statuses</option>
                            <option value="Available" ${filterValue == 'Available' ? 'selected' : ''} class="bg-gray-900">Available</option>
                            <option value="Occupied" ${filterValue == 'Occupied' ? 'selected' : ''} class="bg-gray-900">Occupied</option>
                            <option value="Maintenance" ${filterValue == 'Maintenance' ? 'selected' : ''} class="bg-gray-900">Maintenance</option>
                            <option value="Reserved" ${filterValue == 'Reserved' ? 'selected' : ''} class="bg-gray-900">Reserved</option>
                        </select>
                    </div>

                    <div class="flex space-x-3 w-full md:w-auto">
                        <button onclick="window.location='${pageContext.request.contextPath}/room?action=search&keyword='+document.getElementById('searchInput').value" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300 text-center">
                            Search
                        </button>
                        <a href="${pageContext.request.contextPath}/room?action=list" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors text-center">
                            Clear
                        </a>
                    </div>
                </div>

                <c:if test="${not empty filterType}">
                    <div class="mb-4 inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-500/20 text-primary-300 border border-primary-500/30">
                        Filtered by Status: ${filterValue}
                        <a href="${pageContext.request.contextPath}/room?action=list" class="ml-2 hover:text-white">✕</a>
                    </div>
                </c:if>

                <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden shadow-lg">
                    <c:choose>
                        <c:when test="${empty roomList}">
                            <div class="text-center py-16">
                                <svg class="mx-auto h-12 w-12 text-gray-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                                <h3 class="text-lg font-medium text-gray-300">No rooms found</h3>
                                <p class="mt-1 text-sm text-gray-500">Add your first room to get started.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto">
                                <table id="roomTable" class="w-full text-left">
                                    <thead>
                                        <tr class="bg-gray-900 border-b border-gray-800 text-xs font-medium text-gray-400 uppercase tracking-wider">
                                            <th class="px-6 py-4">Room No</th>
                                            <th class="px-6 py-4">Type</th>
                                            <th class="px-6 py-4">Floor</th>
                                            <th class="px-6 py-4">View</th>
                                            <th class="px-6 py-4">Price/Night</th>
                                            <th class="px-6 py-4">Status</th>
                                            <th class="px-6 py-4 text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-gray-800 bg-gray-900">
                                        <c:forEach var="room" items="${roomList}">
                                            <tr class="hover:bg-gray-800/50 transition-colors">
                                                <td class="px-6 py-4 whitespace-nowrap text-lg font-bold text-white">${room.roomNumber}</td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${room.roomTypeName}</td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-800 text-gray-300 border border-gray-700">Floor ${room.floorNumber}</span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${room.viewType}</td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-md text-sm font-semibold bg-primary-500/10 text-primary-400 border border-primary-500/20">
                                                        $<fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0.00"/>
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${room.status == 'Available'}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-500/10 text-green-400 border border-green-500/20">✓ Available</span>
                                                        </c:when>
                                                        <c:when test="${room.status == 'Occupied'}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-500/10 text-red-400 border border-red-500/20">● Occupied</span>
                                                        </c:when>
                                                        <c:when test="${room.status == 'Maintenance'}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-500/10 text-yellow-400 border border-yellow-500/20">⚠ Maintenance</span>
                                                        </c:when>
                                                        <c:when test="${room.status == 'Reserved'}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-500/10 text-blue-400 border border-blue-500/20">◆ Reserved</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                    <div class="flex justify-end space-x-3">
                                                        <a href="${pageContext.request.contextPath}/room?action=view&id=${room.id}" class="text-blue-400 hover:text-blue-300 transition-colors">View</a>
                                                        <a href="${pageContext.request.contextPath}/room?action=edit&id=${room.id}" class="text-yellow-500 hover:text-yellow-400 transition-colors">Edit</a>
                                                        <button onclick="confirmDelete(${room.id}, '${room.roomNumber}', '${room.status}')" class="text-red-500 hover:text-red-400 transition-colors">Delete</button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </main>
        </div>
    </div>

    <div id="custom-toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
        <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
            <div class="flex flex-col">
                <span id="toast-title" class="text-white font-semibold text-[15px] tracking-wide">Event has been created</span>
                <span id="toast-subtitle" class="text-primary-100 opacity-80 text-[13px] mt-0.5">Sunday, December 03, 2023 at 9:00 AM</span>
            </div>
            <button onclick="hideToast()" class="bg-white hover:bg-gray-100 text-primary-700 text-[14px] font-semibold px-4 py-1.5 rounded-lg transition-colors focus:outline-none shadow-sm">
                Dismiss
            </button>
        </div>
    </div>

    <script>
        // Live search filter
        function liveSearch() {
            const input  = document.getElementById('searchInput').value.toLowerCase();
            const rows   = document.querySelectorAll('#roomTable tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(input) ? '' : 'none';
            });
        }

        // Filter Dropdown action
        function filterRooms(status) {
            window.location = '${pageContext.request.contextPath}/room?action=filter&filterType=status&filterValue=' + status;
        }

        // Delete confirmation
        function confirmDelete(id, roomNumber, status) {
            if (status === 'Occupied') {
                showToast("Cannot delete Room " + roomNumber + ". It is currently occupied.");
                return;
            }
            
            if (confirm('Are you sure you want to delete Room ' + roomNumber + '?\n\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/room?action=delete&id=' + id;
            }
        }

        // --- Custom iOS/Mac Style Toast Logic ---
        let toastTimeout;
        
        function showToast(title) {
            const toast = document.getElementById('custom-toast');
            document.getElementById('toast-title').textContent = title;
            
            const now = new Date();
            const formattedDate = new Intl.DateTimeFormat('en-US', {
                weekday: 'long', month: 'long', day: '2-digit', year: 'numeric', 
                hour: 'numeric', minute: '2-digit', hour12: true
            }).format(now).replace(' at ', ' at '); 
            
            document.getElementById('toast-subtitle').textContent = formattedDate;

            toast.classList.remove('translate-y-8', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');

            clearTimeout(toastTimeout);
            toastTimeout = setTimeout(() => {
                hideToast();
            }, 4500);
        }

        function hideToast() {
            const toast = document.getElementById('custom-toast');
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-8', 'opacity-0');
        }

        document.addEventListener("DOMContentLoaded", function() {
            <c:if test="${param.success == 'added'}">showToast("New room added successfully");</c:if>
            <c:if test="${param.success == 'updated'}">showToast("Room details updated successfully");</c:if>
            <c:if test="${param.success == 'deleted'}">showToast("Room removed from the system");</c:if>
            <c:if test="${param.error == 'notfound'}">showToast("Warning: Room not found");</c:if>
            <c:if test="${param.error == 'cannotdelete'}">showToast("Cannot delete room. It is currently occupied.");</c:if>
        });
    </script>
</body>
</html>