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
    <jsp:include page="/WEB-INF/includes/sidebar.jsp">
        <jsp:param name="activePage" value="roomtypes" />
	</jsp:include>

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
