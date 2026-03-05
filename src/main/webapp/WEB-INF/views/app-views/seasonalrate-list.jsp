<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seasonal Rates — Ocean View Resort</title>
    
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
<body class="bg-gray-950 text-gray-100">
    <c:if test="${empty sessionScope.loggedInStaff}">
        <c:redirect url="/login?status=sessionExpired"/>
    </c:if>
    
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="seasonalrates" />
    		</jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-white">Seasonal Rates Management</h1>
                        <p class="text-sm text-gray-400 mt-1">Configure dynamic pricing for peak and off-peak seasons</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seasonalRates?action=new" 
                        class="inline-flex items-center space-x-2 px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg transition-all">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        <span>Add Season Rate</span>
                    </a>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <!-- Stats Card -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary-600 to-blue-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Total Rates</p>
                        <h3 class="text-2xl font-bold text-white mt-1">${rates.size()}</h3>
                    </div>
                    
                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-green-600 to-green-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Active Rates</p>
                        <h3 class="text-2xl font-bold text-green-500 mt-1">
                        <c:set var="activeCount" value="0"/>
                            <c:forEach var="rate" items="${rates}">
                                <c:if test="${rate.active}"><c:set var="activeCount" value="${activeCount + 1}"/></c:if>
                            </c:forEach>
                            ${activeCount}
                        </h3>
                    </div>
                    
                    
                    
                    <div class="relative bg-gray-900 border border-gray-800 rounded-xl p-5 shadow-lg overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-blue-600 to-blue-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Currently Running</p>
                        <h3 class="text-2xl font-bold text-blue-500 mt-1">
                        <c:set var="ongoingCount" value="0"/>
                            <c:forEach var="rate" items="${rates}">
                                <c:if test="${rate.currentlyActive}"><c:set var="ongoingCount" value="${ongoingCount + 1}"/></c:if>
                            </c:forEach>
                            ${ongoingCount}
                        </h3>
                    </div>
                </div>
				
				<!-- Search container start -->
				<div class="bg-gray-900 border border-gray-800 p-4 rounded-xl mb-6 flex flex-col md:flex-row gap-4 items-center">
                    <div class="flex-1 relative w-full">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </div>
                        <input type="text" id="searchInput" placeholder="Search by season name or room type..." value="${keyword}" onkeyup="liveSearch()" 
                            class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                    </div>
                    
                    <div class="w-full md:w-auto">
                        <select onchange="filterSeasonalRates(this.value)" class="w-full md:w-48 bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                            <option value="" class="bg-gray-900">All Statuses</option>
                            <option value="Active" ${filterValue == 'Active' ? 'selected' : ''} class="bg-gray-900">Active</option>
                            <option value="Ongoing" ${filterValue == 'Ongoing' ? 'selected' : ''} class="bg-gray-900">Ongoing</option>
                            <option value="Disabled" ${filterValue == 'Disabled' ? 'Disabled' : ''} class="bg-gray-900">Disabled</option>
                        </select>
                    </div>

                    <div class="flex space-x-3 w-full md:w-auto">
                        <button onclick="window.location='${pageContext.request.contextPath}/seasonalRates?action=search&keyword='+document.getElementById('searchInput').value" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300 text-center">
                            Search
                        </button>
                        <a href="${pageContext.request.contextPath}/seasonalRates?action=list" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors text-center">
                            Clear
                        </a>
                    </div>
                </div>
                
                <c:if test="${not empty filterType}">
                    <div class="mb-4 inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-500/20 text-primary-300 border border-primary-500/30">
                        Filtered by Status: ${filterValue}
                        <a href="${pageContext.request.contextPath}/seasonalRates?action=list" class="ml-2 hover:text-white">✕</a>
                    </div>
                </c:if>
                <!-- Search container end -->
                
                <!-- Table -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden shadow-lg">
                    <c:choose>
                        <c:when test="${empty rates}">
                            <div class="text-center py-16">
                                <svg class="mx-auto h-12 w-12 text-gray-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <h3 class="text-lg font-medium text-gray-300">No seasonal rates configured</h3>
                                <p class="mt-1 text-sm text-gray-500">Create your first seasonal rate to optimize pricing</p>
                                <a href="${pageContext.request.contextPath}/seasonalRates?action=new" 
                                    class="inline-block mt-4 px-6 py-2.5 bg-primary-600 hover:bg-primary-500 text-white font-medium rounded-lg transition-colors">
                                    Add First Rate
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto">
                                <table  id="seasonalRatesTable" class="w-full text-left">
                                    <thead>
                                        <tr class="bg-gray-900 border-b border-gray-800 text-xs font-medium text-gray-400 uppercase tracking-wider">
                                            <th class="px-6 py-4">Season Name</th>
                                            <th class="px-6 py-4">Room Type</th>
                                            <th class="px-6 py-4">Date Range</th>
                                            <th class="px-6 py-4">Price/Night</th>
                                            <th class="px-6 py-4">Status</th>
                                            <th class="px-6 py-4 text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-gray-800 bg-gray-900">
                                        <c:forEach var="rate" items="${rates}">
                                            <tr class="hover:bg-gray-800/50 transition-colors">
                                                <td class="px-6 py-4">
                                                    <div class="text-base font-bold text-white">${rate.seasonName}</div>
                                                    <c:if test="${rate.discountPct > 0}">
                                                        <div class="text-xs text-green-400 mt-1">
                                                            <fmt:formatNumber value="${rate.discountPct}" pattern="#,##0.##"/>% discount
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td class="px-6 py-4 text-sm text-gray-300">${rate.roomTypeName}</td>
                                                <td class="px-6 py-4 text-sm text-gray-300 whitespace-nowrap">
                                                    <div class="flex items-center space-x-2">
                                                        <span>${rate.startDate}</span>
                                                        <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                                                        </svg>
                                                        <span>${rate.endDate}</span>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-md text-sm font-semibold bg-primary-500/10 text-primary-400 border border-primary-500/20">
                                                        $<fmt:formatNumber value="${rate.pricePerNight}" pattern="#,##0.00"/>
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${!rate.active}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-500/10 text-orange-400 border border-orange-500/20">
                                                                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                                    <path fill-rule="evenodd" d="M13.477 14.89A6 6 0 015.11 6.524l8.367 8.368zm1.414-1.414L6.524 5.11a6 6 0 018.367 8.367zM18 10a8 8 0 11-16 0 8 8 0 0116 0z" clip-rule="evenodd"/>
                                                                </svg>
                                                                Disabled
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${rate.currentlyActive}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-500/10 text-blue-400 border border-blue-500/20 animate-pulse">
                                                                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
                                                                </svg>
                                                                Ongoing Now
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-500/10 text-green-400 border border-green-500/20">
                                                                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                                                </svg>
                                                                Active (Scheduled)
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                    <div class="flex justify-end space-x-3">
                                                        <a href="${pageContext.request.contextPath}/seasonalRates?action=view&id=${rate.id}" 
                                                            class="text-blue-400 hover:text-blue-300 transition-colors">View</a>
                                                        <a href="${pageContext.request.contextPath}/seasonalRates?action=edit&id=${rate.id}" 
                                                            class="text-yellow-500 hover:text-yellow-400 transition-colors">Edit</a>
                                                        <button onclick="confirmDelete(${rate.id}, '${rate.seasonName}')" 
                                                            class="text-red-500 hover:text-red-400 transition-colors">Delete</button>
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
    <div id="toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
        <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
            <div class="flex flex-col">
                <span id="toast-msg" class="text-white font-semibold text-[15px]"></span>
                <span class="text-primary-100 opacity-80 text-[13px] mt-0.5" id="toast-time"></span>
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
        const rows   = document.querySelectorAll('#seasonalRatesTable tbody tr');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? '' : 'none';
        });
    }

    // Filter Dropdown action
    function filterSeasonalRates(status) {
        window.location = '${pageContext.request.contextPath}/seasonalRates?action=filter&filterType=status&filterValue=' + status;
    }
    
      function confirmDelete(id, seasonName) {
          if (confirm('Are you sure you want to delete the seasonal rate: ' + seasonName + '?\n\nThis action cannot be undone.')) {
              window.location = '${pageContext.request.contextPath}/seasonalRates?action=delete&id=' + id;
          }
      }

      function showToast(msg) {
          const toast = document.getElementById('toast');
          document.getElementById('toast-msg').textContent = msg;
          document.getElementById('toast-time').textContent = new Date().toLocaleString('en-US', {
              weekday: 'long', month: 'long', day: '2-digit', year: 'numeric',
              hour: 'numeric', minute: '2-digit', hour12: true
          });
          toast.classList.remove('translate-y-8', 'opacity-0');
          toast.classList.add('translate-y-0', 'opacity-100');
          setTimeout(hideToast, 4000);
      }

      function hideToast() {
          const toast = document.getElementById('toast');
          toast.classList.remove('translate-y-0', 'opacity-100');
          toast.classList.add('translate-y-8', 'opacity-0');
      }

      document.addEventListener("DOMContentLoaded", function() {
          <c:if test="${param.success == 'added'}">showToast("Seasonal rate added successfully");</c:if>
          <c:if test="${param.success == 'updated'}">showToast("Seasonal rate updated successfully");</c:if>
          <c:if test="${param.success == 'deleted'}">showToast("Seasonal rate deleted successfully");</c:if>
          <c:if test="${param.error == 'notfound'}">showToast("Warning: Seasonal rate not found");</c:if>
          
      });

    </script>
</body>
</html>