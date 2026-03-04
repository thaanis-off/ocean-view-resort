<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${room != null ? 'Edit' : 'Add'} Room — Ocean View Resort</title>
    
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
                
                <a href="${pageContext.request.contextPath}/room?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-white bg-gray-800 rounded-lg transition-colors">
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
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/room?action=list" class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white flex items-center">
                                ${room != null ? 'Edit Room' : 'Add New Room'}
                                <span class="ml-3 px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-500/20 text-primary-400 border border-primary-500/30">
                                    ${room != null ? 'Update Record' : 'New Room'}
                                </span>
                            </h1>
                            <p class="text-sm text-gray-400 mt-1">Fill in the room details below. Fields marked <span class="text-red-500">*</span> are required.</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <div class="max-w-4xl mx-auto">
                    
                    <div class="bg-gray-900 border border-gray-800 rounded-xl shadow-lg p-8">
                        <form action="${pageContext.request.contextPath}/room" method="post" class="space-y-8">
                            <input type="hidden" name="action" value="${room != null ? 'update' : 'create'}">
                            <c:if test="${room != null}">
                                <input type="hidden" name="id" value="${room.id}">
                            </c:if>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Basic Information</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Room Number <span class="text-red-500">*</span></label>
                                        <input type="text" name="roomNumber" value="${room != null ? room.roomNumber : param.roomNumber}" placeholder="e.g. 101" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                        <p class="text-xs text-gray-500 mt-1.5">Unique room identifier</p>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Room Type <span class="text-red-500">*</span></label>
                                        <select name="roomTypeId" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="" class="bg-gray-900">-- Select Room Type --</option>
                                            <c:forEach var="type" items="${roomTypes}">
                                                <option value="${type.id}" ${(room != null && room.roomTypeId == type.id) || param.roomTypeId == type.id ? 'selected' : ''} class="bg-gray-900">
                                                    ${type.typeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <p class="text-xs text-gray-500 mt-1.5">Select the room category</p>
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Floor Number <span class="text-red-500">*</span></label>
                                        <input type="number" name="floorNumber" min="0" max="50" value="${room != null ? room.floorNumber : param.floorNumber}" placeholder="e.g. 1" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                        <p class="text-xs text-gray-500 mt-1.5">Floor where room is located</p>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">View Type</label>
                                        <select name="viewType" class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="" class="bg-gray-900">-- Select View --</option>
                                            <option value="Sea View" ${(room != null && room.viewType == 'Sea View') || param.viewType == 'Sea View' ? 'selected' : ''} class="bg-gray-900">Sea View</option>
                                            <option value="Garden View" ${(room != null && room.viewType == 'Garden View') || param.viewType == 'Garden View' ? 'selected' : ''} class="bg-gray-900">Garden View</option>
                                            <option value="City View" ${(room != null && room.viewType == 'City View') || param.viewType == 'City View' ? 'selected' : ''} class="bg-gray-900">City View</option>
                                            <option value="Pool View" ${(room != null && room.viewType == 'Pool View') || param.viewType == 'Pool View' ? 'selected' : ''} class="bg-gray-900">Pool View</option>
                                            <option value="No View" ${(room != null && room.viewType == 'No View') || param.viewType == 'No View' ? 'selected' : ''} class="bg-gray-900">No View</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Pricing & Status</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Price Per Night ($) <span class="text-red-500">*</span></label>
                                        <input type="number" name="pricePerNight" step="0.01" min="0" value="${room != null ? room.pricePerNight : param.pricePerNight}" placeholder="e.g. 150.00" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                        <p class="text-xs text-gray-500 mt-1.5">Nightly rate for this room</p>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Status <span class="text-red-500">*</span></label>
                                        <select name="status" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="Available" ${(room == null || room.status == 'Available') || param.status == 'Available' ? 'selected' : ''} class="bg-gray-900">Available</option>
                                            <option value="Occupied" ${(room != null && room.status == 'Occupied') || param.status == 'Occupied' ? 'selected' : ''} class="bg-gray-900">Occupied</option>
                                            <option value="Maintenance" ${(room != null && room.status == 'Maintenance') || param.status == 'Maintenance' ? 'selected' : ''} class="bg-gray-900">Maintenance</option>
                                            <option value="Reserved" ${(room != null && room.status == 'Reserved') || param.status == 'Reserved' ? 'selected' : ''} class="bg-gray-900">Reserved</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label class="flex items-center cursor-pointer group w-max">
                                        <div class="relative flex items-center">
                                            <input type="checkbox" name="isActive" id="isActive" ${(room == null || room.active) || param.isActive == 'on' ? 'checked' : ''}
                                                class="peer w-5 h-5 cursor-pointer appearance-none rounded border border-gray-600 bg-gray-950 checked:bg-green-500 checked:border-green-500 transition-all">
                                            <svg class="absolute w-5 h-5 p-0.5 text-white opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                                        </div>
                                        <span class="ml-3 text-sm font-medium text-gray-300 group-hover:text-white transition-colors">Room is Active</span>
                                    </label>
                                    <p class="text-xs text-gray-500 mt-2">Inactive rooms are hidden from availability and cannot be booked.</p>
                                </div>
                            </div>

                            <div class="pt-6 mt-6 border-t border-gray-800 flex items-center justify-end space-x-4">
                                <c:if test="${room == null}">
                                    <button type="reset" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                        Clear Form
                                    </button>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/room?action=list" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                    Cancel
                                </a>
                                <button type="submit" class="px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                                    ${room != null ? 'Update Room' : 'Save New Room'}
                                </button>
                            </div>

                        </form>
                    </div>
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
            <c:if test="${not empty errorMessage}">showToast(`${errorMessage}`);</c:if>
        });
    </script>
</body>
</html>