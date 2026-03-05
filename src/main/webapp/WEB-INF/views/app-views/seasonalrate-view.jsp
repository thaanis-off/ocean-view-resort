<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seasonal Rate: ${rate.seasonName} — Ocean View Resort</title>
    
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
        
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
            <jsp:param name="activePage" value="seasonalRates" />
        </jsp:include>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <!-- HEADER -->
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/seasonalRates?action=list" 
                           class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white">Seasonal Rate Details</h1>
                            <p class="text-sm text-gray-400 mt-1">View and manage pricing strategy</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <!-- MAIN CONTENT -->
            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-6xl mx-auto space-y-6">

                    <!-- STATUS ALERT -->
                    <c:if test="${!rate.active}">
                        <div class="bg-red-500/10 border border-red-500/20 rounded-xl p-4 flex items-start">
                            <svg class="w-5 h-5 text-red-400 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                            <div>
                                <h4 class="text-sm font-medium text-red-300">Rate is Disabled</h4>
                                <p class="text-sm text-red-400/80 mt-1">This seasonal rate is currently disabled and will not be applied to reservations.</p>
                            </div>
                        </div>
                    </c:if>

                    <!-- HERO CARD -->
                    <div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
                        <div class="flex items-center gap-6 text-center md:text-left">
                            <div class="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center text-primary-100 shadow-inner flex-shrink-0 border border-white/20">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            </div>
                            <div>
                                <h2 class="text-3xl font-bold text-white tracking-wide">${rate.seasonName}</h2>
                                <div class="mt-2 text-primary-100 text-sm flex items-center space-x-3">
                                    <span class="font-medium">${rate.roomTypeName}</span>
                                    <span class="text-white/40">•</span>
                                    <span>${rate.startDate} - ${rate.endDate}</span>
                                </div>
                                <div class="mt-3 text-xl font-semibold text-white">
                                    $<fmt:formatNumber value="${rate.pricePerNight}" pattern="#,##0.00"/> 
                                    <span class="text-sm font-normal text-primary-200">/ night</span>
                                    <c:if test="${rate.discountPct > 0}">
                                        <span class="ml-3 px-2 py-1 bg-green-500/20 text-green-300 text-xs font-bold rounded-full">
                                            ${rate.discountPct}% OFF
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- STATUS BADGE -->
                        <div class="flex-shrink-0">
                            <c:choose>
                                <c:when test="${!rate.active}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-red-500 text-white shadow-md">
                                        ● Disabled
                                    </span>
                                </c:when>
                                <c:when test="${rate.currentlyActive}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-green-500 text-white shadow-md">
                                        ✓ Ongoing
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-blue-500 text-white shadow-md">
                                        ◆ Scheduled
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- QUICK STATS -->
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">
                                $<fmt:formatNumber value="${rate.pricePerNight}" pattern="#,##0"/>
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Price Per Night</div>
                        </div>

                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">
                                <c:choose>
                                    <c:when test="${rate.discountPct > 0}">
                                        ${rate.discountPct}%
                                    </c:when>
                                    <c:otherwise>
                                        —
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Discount</div>
                        </div>

                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">
                               <!-- ✅ USE THIS -->
								<c:set var="duration" value="${rate.endDate.toEpochDay() - rate.startDate.toEpochDay() + 1}"/>
								${duration}
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Duration (Days)</div>
                        </div>

                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold mt-1 ${rate.active ? 'text-green-500' : 'text-red-500'}">
                                ${rate.active ? '✓ Yes' : '✗ No'}
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Active Status</div>
                        </div>
                    </div>

                    <!-- DETAILS GRID -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        
                        <!-- RATE INFORMATION -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">
                                Rate Information
                            </h3>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Season Name</label>
                                    <div class="text-sm text-gray-200 mt-1">${rate.seasonName}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Room Type</label>
                                    <div class="text-sm text-gray-200 mt-1">${rate.roomTypeName}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Start Date</label>
                                    <div class="text-sm text-gray-200 mt-1">
                                        ${rate.startDate}
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">End Date</label>
                                    <div class="text-sm text-gray-200 mt-1">
                                       ${rate.endDate}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PRICING BREAKDOWN -->
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">
                                Pricing Breakdown
                            </h3>
                            <div class="space-y-4">
                                <div class="flex justify-between items-center py-3 border-b border-gray-800">
                                    <span class="text-sm text-gray-400">Base Rate</span>
                                    <span class="text-lg font-semibold text-white">
                                        $<fmt:formatNumber value="${rate.pricePerNight}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                                <div class="flex justify-between items-center py-3 border-b border-gray-800">
                                    <span class="text-sm text-gray-400">Discount</span>
                                    <span class="text-lg font-semibold ${rate.discountPct > 0 ? 'text-green-400' : 'text-gray-500'}">
                                        <c:choose>
                                            <c:when test="${rate.discountPct > 0}">
                                                -${rate.discountPct}%
                                            </c:when>
                                            <c:otherwise>
                                                None
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${rate.discountPct > 0}">
                                    <div class="flex justify-between items-center py-3 bg-green-500/10 rounded-lg px-4">
                                        <span class="text-sm font-semibold text-green-300">Final Rate</span>
                                        <span class="text-xl font-bold text-green-400">
                                            $<fmt:formatNumber value="${rate.pricePerNight * (1 - rate.discountPct / 100)}" pattern="#,##0.00"/>
                                        </span>
                                    </div>
                                </c:if>
                                <div class="pt-4">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase mb-2">Status</label>
                                    <div class="flex items-center space-x-2">
                                        <div class="w-3 h-3 rounded-full ${rate.active ? 'bg-green-500' : 'bg-red-500'}"></div>
                                        <span class="text-sm ${rate.active ? 'text-green-400' : 'text-red-400'}">
                                            ${rate.active ? 'Active & Enabled' : 'Disabled'}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ACTIONS BAR -->
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 flex flex-wrap items-center justify-end gap-4 mt-6 shadow-md">
                        <a href="${pageContext.request.contextPath}/seasonalRates?action=list" 
                           class="px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors mr-auto">
                            ← Back to List
                        </a>

                        <a href="${pageContext.request.contextPath}/seasonalRates?action=edit&id=${rate.id}" 
                           class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/>
                            </svg>
                            Edit Rate
                        </a>

                        <button onclick="confirmDelete(${rate.id}, '${rate.seasonName}')" 
                                class="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg shadow-md transition-colors flex items-center">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                            Delete
                        </button>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <!-- TOAST NOTIFICATION -->
    <div id="custom-toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
        <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center justify-between gap-8 min-w-[360px] pointer-events-auto">
            <div class="flex flex-col">
                <span id="toast-title" class="text-white font-semibold text-[15px] tracking-wide">Action completed</span>
                <span id="toast-subtitle" class="text-primary-100 opacity-80 text-[13px] mt-0.5">Just now</span>
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
            
            const now = new Date();
            const formattedDate = new Intl.DateTimeFormat('en-US', {
                weekday: 'long', month: 'long', day: '2-digit', year: 'numeric', 
                hour: 'numeric', minute: '2-digit', hour12: true
            }).format(now);
            
            document.getElementById('toast-subtitle').textContent = formattedDate;

            toast.classList.remove('translate-y-8', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');

            clearTimeout(toastTimeout);
            toastTimeout = setTimeout(() => hideToast(), 4500);
        }

        function hideToast() {
            const toast = document.getElementById('custom-toast');
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-8', 'opacity-0');
        }

        function confirmDelete(id, seasonName) {
            if (confirm('Permanently delete seasonal rate "' + seasonName + '"?\n\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/seasonalRates?action=delete&id=' + id;
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            <c:if test="${param.success == 'updated'}">showToast("Seasonal rate successfully updated");</c:if>
        });
    </script>

</body>
</html>