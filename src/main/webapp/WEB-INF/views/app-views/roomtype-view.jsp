<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${roomType.typeName} — Ocean View Resort</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'sans-serif'] },
                    colors: {
                        primary: {
                            50: '#f0f4ff', 100: '#e8f0fb',
                            500: '#1B4F8A', 600: '#163d6e', 700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100 relative">
<div class="flex h-screen overflow-hidden">

    <!-- Sidebar -->
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
            <a href="${pageContext.request.contextPath}/room?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-gray-300 hover:bg-gray-800 hover:text-white rounded-lg transition-colors">
                <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                Rooms
            </a>
            <a href="${pageContext.request.contextPath}/roomtype?action=list" class="flex items-center px-4 py-3 text-sm font-medium text-white bg-gray-800 rounded-lg transition-colors">
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

    <!-- Main -->
    <div class="flex-1 flex flex-col overflow-hidden">

        <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/roomtype?action=list" class="text-gray-400 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                    </a>
                    <div>
                        <h1 class="text-2xl font-bold text-white">Room Type Details</h1>
                        <p class="text-sm text-gray-400 mt-1">Details and management for ${roomType.typeName}</p>
                    </div>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                </div>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
            <div class="max-w-6xl mx-auto space-y-6">

                <!-- Warning if rooms use this type -->
                <c:if test="${roomCount > 0}">
                    <div class="bg-yellow-500/10 border border-yellow-500/20 rounded-xl p-4 flex items-start">
                        <svg class="w-5 h-5 text-yellow-400 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
                        <div>
                            <h4 class="text-sm font-medium text-yellow-300">Room Type In Use</h4>
                            <p class="text-sm text-yellow-400/80 mt-1">This type is used by ${roomCount} room(s). Reassign or delete those rooms before deleting this type.</p>
                        </div>
                    </div>
                </c:if>

                <!-- Hero banner -->
                <div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
                    <div class="flex items-center gap-6 text-center md:text-left">
                        <div class="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center text-primary-100 shadow-inner flex-shrink-0 border border-white/20">
                            <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                        </div>
                        <div>
                            <h2 class="text-3xl font-bold text-white tracking-wide">${roomType.typeName}</h2>
                            <div class="mt-2 text-primary-100 text-sm flex items-center space-x-3">
                                <span class="font-medium">Up to ${roomType.maxOccupancy} guests</span>
                                <span class="text-white/40">•</span>
                                <span>${roomCount} active room(s)</span>
                            </div>
                            <div class="mt-3 text-xl font-semibold text-white">
                                $<fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0.00"/> <span class="text-sm font-normal text-primary-200">/ night</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex-shrink-0">
                        <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-white/10 text-white border border-white/20">
                            Type #${roomType.id}
                        </span>
                    </div>
                </div>

                <!-- Stat cards -->
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4 md:gap-6">
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                        <div class="text-3xl font-bold text-primary-400">$<fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0"/></div>
                        <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Base Price / Night</div>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                        <div class="text-3xl font-bold text-primary-400">${roomType.maxOccupancy}</div>
                        <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Max Occupancy</div>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                        <div class="text-3xl font-bold text-primary-400">${roomCount}</div>
                        <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Rooms Using This Type</div>
                    </div>
                </div>

                <!-- Details & Amenities -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

                    <!-- Info panel -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                        <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Room Type Information</h3>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase">Type Name</label>
                                <div class="text-sm text-gray-200 mt-1">${roomType.typeName}</div>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase">Type ID</label>
                                <div class="text-sm text-gray-200 mt-1">#${roomType.id}</div>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase">Base Price Per Night</label>
                                <div class="text-sm font-medium text-white mt-1">$<fmt:formatNumber value="${roomType.basePrice}" pattern="#,##0.00"/></div>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase">Maximum Occupancy</label>
                                <div class="text-sm text-gray-200 mt-1">${roomType.maxOccupancy} guests</div>
                            </div>
                            <c:if test="${not empty roomType.description}">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Description</label>
                                    <div class="text-sm text-gray-200 mt-1 leading-relaxed">${roomType.description}</div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Amenities panel -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                        <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Amenities</h3>
                        <c:choose>
                            <c:when test="${not empty roomType.amenities}">
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="amenity" items="${roomType.amenities.split(',')}">
                                        <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-primary-500/10 text-primary-400 border border-primary-500/20">
                                            ✓ ${amenity.trim()}
                                        </span>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-sm text-gray-500">No amenities listed for this room type.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Action bar -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 flex flex-wrap items-center justify-end gap-4 shadow-md">
                    <a href="${pageContext.request.contextPath}/roomtype?action=list" class="px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors mr-auto">
                        ← Back to List
                    </a>
                    <a href="${pageContext.request.contextPath}/roomtype?action=edit&id=${roomType.id}" class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                        Edit Room Type
                    </a>
                    <button onclick="confirmDelete(${roomType.id}, '${roomType.typeName}', ${roomCount})" class="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg shadow-md transition-colors flex items-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                        Delete
                    </button>
                </div>

            </div>
        </main>
    </div>
</div>

<!-- Toast -->
<div id="custom-toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
    <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
        <div class="flex flex-col">
            <span id="toast-title" class="text-white font-semibold text-[15px] tracking-wide"></span>
            <span id="toast-subtitle" class="text-primary-100 opacity-80 text-[13px] mt-0.5"></span>
        </div>
        <button onclick="hideToast()" class="bg-white hover:bg-gray-100 text-primary-700 text-[14px] font-semibold px-4 py-1.5 rounded-lg transition-colors focus:outline-none shadow-sm">
            Dismiss
        </button>
    </div>
</div>

<script>
    let toastTimeout;
    function showToast(title) {
        const toast = document.getElementById('custom-toast');
        document.getElementById('toast-title').textContent = title;
        document.getElementById('toast-subtitle').textContent = new Intl.DateTimeFormat('en-US', {
            weekday: 'long', month: 'long', day: '2-digit', year: 'numeric',
            hour: 'numeric', minute: '2-digit', hour12: true
        }).format(new Date());
        toast.classList.remove('translate-y-8', 'opacity-0');
        toast.classList.add('translate-y-0', 'opacity-100');
        clearTimeout(toastTimeout);
        toastTimeout = setTimeout(hideToast, 4500);
    }
    function hideToast() {
        const toast = document.getElementById('custom-toast');
        toast.classList.remove('translate-y-0', 'opacity-100');
        toast.classList.add('translate-y-8', 'opacity-0');
    }

    function confirmDelete(id, typeName, roomCount) {
        if (roomCount > 0) {
            showToast('Cannot delete "' + typeName + '". It is used by ' + roomCount + ' room(s).');
            return;
        }
        if (confirm('Permanently delete room type: ' + typeName + '?\n\nThis cannot be undone.')) {
            window.location = '${pageContext.request.contextPath}/roomtype?action=delete&id=' + id;
        }
    }
</script>
</body>
</html>
