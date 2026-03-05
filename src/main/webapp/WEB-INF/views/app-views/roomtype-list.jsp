<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Types — Ocean View Resort</title>
    
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
                <div>
                    <h1 class="text-2xl font-bold text-white">Room Type Management</h1>
                    <p class="text-sm text-gray-400 mt-1">Manage room categories, pricing, and amenities</p>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/roomtype?action=new" class="inline-flex items-center justify-center space-x-2 px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        <span>Add Room Type</span>
                    </a>
                </div>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto bg-gray-950 p-8">

            <!-- Stat card -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 md:gap-6 mb-8">
                <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                    <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary-600 to-blue-400"></div>
                    <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Total Room Types</p>
                    <h3 class="text-2xl font-bold text-white mt-1">${totalRoomTypes}</h3>
                </div>
            </div>

            <!-- Search bar -->
            <div class="bg-gray-900 border border-gray-800 p-4 rounded-xl mb-6 flex flex-col md:flex-row gap-4 items-center">
                <div class="flex-1 relative w-full">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search by name, description, or amenities..." value="${keyword}" onkeyup="liveSearch()"
                        class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                </div>
                <div class="flex space-x-3 w-full md:w-auto">
                    <button onclick="window.location='${pageContext.request.contextPath}/roomtype?action=search&keyword='+document.getElementById('searchInput').value"
                        class="flex-1 md:flex-none px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300 text-center">
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/roomtype?action=list"
                        class="flex-1 md:flex-none px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors text-center">
                        Clear
                    </a>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden shadow-lg">
                <c:choose>
                    <c:when test="${empty roomTypeList}">
                        <div class="text-center py-16">
                            <svg class="mx-auto h-12 w-12 text-gray-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                            <h3 class="text-lg font-medium text-gray-300">No room types found</h3>
                            <p class="mt-1 text-sm text-gray-500">Add your first room type to get started.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table id="roomTypesTable" class="w-full text-left">
                                <thead>
                                    <tr class="bg-gray-900 border-b border-gray-800 text-xs font-medium text-gray-400 uppercase tracking-wider">
                                        <th class="px-6 py-4">Type Name</th>
                                        <th class="px-6 py-4">Base Price</th>
                                        <th class="px-6 py-4">Max Occupancy</th>
                                        <th class="px-6 py-4">Amenities</th>
                                        <th class="px-6 py-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-800 bg-gray-900">
                                    <c:forEach var="rt" items="${roomTypeList}">
                                        <tr class="hover:bg-gray-800/50 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-base font-bold text-white">${rt.typeName}</div>
                                                <c:if test="${not empty rt.description}">
                                                    <div class="text-xs text-gray-500 mt-0.5 max-w-xs truncate">${rt.description}</div>
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md text-sm font-semibold bg-primary-500/10 text-primary-400 border border-primary-500/20">
                                                    $<fmt:formatNumber value="${rt.basePrice}" pattern="#,##0.00"/>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-800 text-gray-300 border border-gray-700">
                                                    👥 ${rt.maxOccupancy} guests
                                                </span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-gray-400 max-w-xs truncate">${rt.amenities}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                <div class="flex justify-end space-x-3">
                                                    <a href="${pageContext.request.contextPath}/roomtype?action=view&id=${rt.id}" class="text-blue-400 hover:text-blue-300 transition-colors">View</a>
                                                    <a href="${pageContext.request.contextPath}/roomtype?action=edit&id=${rt.id}" class="text-yellow-500 hover:text-yellow-400 transition-colors">Edit</a>
                                                    <button onclick="confirmDelete(${rt.id}, '${rt.typeName}')" class="text-red-500 hover:text-red-400 transition-colors">Delete</button>
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
    function liveSearch() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const rows  = document.querySelectorAll('#roomTypesTable tbody tr');
        rows.forEach(row => { row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none'; });
    }

    function confirmDelete(id, typeName) {
        if (confirm('Are you sure you want to delete room type: ' + typeName + '?\n\nThis cannot be undone.')) {
            window.location = '${pageContext.request.contextPath}/roomtype?action=delete&id=' + id;
        }
    }

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

    document.addEventListener("DOMContentLoaded", function () {
        <c:if test="${param.success == 'added'}">showToast("Room type added successfully");</c:if>
        <c:if test="${param.success == 'updated'}">showToast("Room type updated successfully");</c:if>
        <c:if test="${param.success == 'deleted'}">showToast("Room type removed from the system");</c:if>
        <c:if test="${param.error == 'notfound'}">showToast("Warning: Room type not found");</c:if>
        <c:if test="${param.error == 'cannotdelete'}">showToast("Cannot delete room type. Rooms are using it.");</c:if>
    });
</script>
</body>
</html>