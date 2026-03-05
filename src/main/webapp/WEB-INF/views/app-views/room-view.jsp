<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room ${room.roomNumber} — Ocean View Resort</title>
    
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
             <jsp:param name="activePage" value="rooms" />
    		</jsp:include>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/room?action=list" class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white">Room Details</h1>
                            <p class="text-sm text-gray-400 mt-1">Status and management for Room ${room.roomNumber}</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-6xl mx-auto space-y-6">

                    <c:if test="${room.status == 'Occupied'}">
                        <div class="bg-blue-500/10 border border-blue-500/20 rounded-xl p-4 flex items-start">
                            <svg class="w-5 h-5 text-blue-400 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            <div>
                                <h4 class="text-sm font-medium text-blue-300">Room is Occupied</h4>
                                <p class="text-sm text-blue-400/80 mt-1">This room is currently occupied by a guest. You cannot delete this room until the status is changed.</p>
                            </div>
                        </div>
                    </c:if>

                    <div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
                        <div class="flex items-center gap-6 text-center md:text-left">
                            <div class="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center text-primary-100 shadow-inner flex-shrink-0 border border-white/20">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                            </div>
                            <div>
                                <h2 class="text-3xl font-bold text-white tracking-wide">Room ${room.roomNumber}</h2>
                                <div class="mt-2 text-primary-100 text-sm flex items-center space-x-3">
                                    <span class="font-medium">${room.roomTypeName}</span>
                                    <span class="text-white/40">•</span>
                                    <span>Floor ${room.floorNumber}</span>
                                </div>
                                <div class="mt-3 text-xl font-semibold text-white">
                                    $<fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0.00"/> <span class="text-sm font-normal text-primary-200">/ night</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex-shrink-0">
                            <c:choose>
                                <c:when test="${room.status == 'Available'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-green-500 text-white shadow-md">✓ Available</span>
                                </c:when>
                                <c:when test="${room.status == 'Occupied'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-red-500 text-white shadow-md">● Occupied</span>
                                </c:when>
                                <c:when test="${room.status == 'Maintenance'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-yellow-500 text-white shadow-md">⚠ Maintenance</span>
                                </c:when>
                                <c:when test="${room.status == 'Reserved'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-blue-500 text-white shadow-md">◆ Reserved</span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">${room.roomNumber}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Room Number</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">${room.floorNumber}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Floor</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">$<fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0"/></div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Price Per Night</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold mt-1 ${room.active ? 'text-green-500' : 'text-red-500'}">
                                ${room.active ? '✓ Yes' : '✗ No'}
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Active in System</div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Room Information</h3>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Room Number</label>
                                    <div class="text-sm text-gray-200 mt-1">${room.roomNumber}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Room Type</label>
                                    <div class="text-sm text-gray-200 mt-1">${room.roomTypeName}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Floor Number</label>
                                    <div class="text-sm text-gray-200 mt-1">Floor ${room.floorNumber}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">View Type</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty room.viewType ? room.viewType : '—'}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Current Status</label>
                                    <div class="text-sm text-gray-200 mt-1">${room.status}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Price Per Night</label>
                                    <div class="text-sm font-medium text-white mt-1">$<fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0.00"/></div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Quick Status Change</h3>
                            <p class="text-sm text-gray-400 mb-6">Instantly update the operational status of this room.</p>
                            
                            <div class="flex flex-col gap-3">
                                <c:if test="${room.status != 'Available'}">
                                    <button onclick="updateStatus(${room.id}, 'Available')" class="w-full flex justify-between items-center px-5 py-3.5 bg-green-500/10 hover:bg-green-500/20 border border-green-500/30 text-green-400 font-medium rounded-lg transition-colors">
                                        <div class="flex items-center"><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg> Mark as Available</div>
                                        <span class="text-xs opacity-70">Ready for guests</span>
                                    </button>
                                </c:if>
                                <c:if test="${room.status != 'Occupied'}">
                                    <button onclick="updateStatus(${room.id}, 'Occupied')" class="w-full flex justify-between items-center px-5 py-3.5 bg-red-500/10 hover:bg-red-500/20 border border-red-500/30 text-red-400 font-medium rounded-lg transition-colors">
                                        <div class="flex items-center"><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg> Mark as Occupied</div>
                                        <span class="text-xs opacity-70">Guest inside</span>
                                    </button>
                                </c:if>
                                <c:if test="${room.status != 'Reserved'}">
                                    <button onclick="updateStatus(${room.id}, 'Reserved')" class="w-full flex justify-between items-center px-5 py-3.5 bg-blue-500/10 hover:bg-blue-500/20 border border-blue-500/30 text-blue-400 font-medium rounded-lg transition-colors">
                                        <div class="flex items-center"><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg> Mark as Reserved</div>
                                        <span class="text-xs opacity-70">Held for check-in</span>
                                    </button>
                                </c:if>
                                <c:if test="${room.status != 'Maintenance'}">
                                    <button onclick="updateStatus(${room.id}, 'Maintenance')" class="w-full flex justify-between items-center px-5 py-3.5 bg-yellow-500/10 hover:bg-yellow-500/20 border border-yellow-500/30 text-yellow-400 font-medium rounded-lg transition-colors">
                                        <div class="flex items-center"><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg> Mark as Maintenance</div>
                                        <span class="text-xs opacity-70">Needs repairs/cleaning</span>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 flex flex-wrap items-center justify-end gap-4 mt-6 shadow-md">
                        <a href="${pageContext.request.contextPath}/room?action=list" class="px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors mr-auto">
                            ← Back to List
                        </a>

                        <a href="${pageContext.request.contextPath}/room?action=edit&id=${room.id}" class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                            Edit Room
                        </a>

                        <button onclick="confirmDelete(${room.id}, '${room.roomNumber}', '${room.status}')" class="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg shadow-md transition-colors flex items-center">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                            Delete
                        </button>
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
        // Custom iOS/Mac Style Toast Logic
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

        // Delete confirmation
        function confirmDelete(id, roomNumber, status) {
            if (status === 'Occupied') {
                showToast("Cannot delete Room " + roomNumber + ". Please change the status first.");
                return;
            }
            
            if (confirm('Permanently delete Room ' + roomNumber + '?\n\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/room?action=delete&id=' + id;
            }
        }
        
        // Status Update confirmation
        function updateStatus(id, status) {
            if (confirm('Change room status to: ' + status + '?')) {
                window.location = '${pageContext.request.contextPath}/room?action=updateStatus&id=' + id + '&status=' + status;
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            <c:if test="${param.success == 'statusupdated'}">showToast("Room status successfully updated");</c:if>
        });
    </script>

</body>
</html>