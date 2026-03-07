<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation ${reservation.reservationNumber} — Ocean View Resort</title>
    
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
                    colors: { primary: { 50: '#f0f4ff', 100: '#e8f0fb', 500: '#1B4F8A', 600: '#163d6e', 700: '#0f2a4d' } }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100 relative">
    <div class="flex h-screen overflow-hidden">
        
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="reservations" />
    		</jsp:include>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/reservation?action=list" class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white">Reservation Details</h1>
                            <p class="text-sm text-gray-400 mt-1">Manage booking ${reservation.reservationNumber}</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-6xl mx-auto space-y-6">

                    <div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
                        <div class="flex items-center gap-6 text-center md:text-left">
                            <div class="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center text-primary-100 shadow-inner flex-shrink-0 border border-white/20">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            </div>
                            <div>
                                <h2 class="text-3xl font-bold text-white tracking-wide">${reservation.reservationNumber}</h2>
                                <div class="mt-2 text-primary-100 text-sm flex items-center justify-center md:justify-start space-x-3">
                                    <span class="font-medium">${reservation.guestName}</span>
                                    <span class="text-white/40">•</span>
                                    <span>Room ${reservation.roomNumber}</span>
                                </div>
                                <div class="mt-3 text-sm text-primary-200">
                                    <span class="font-semibold text-white">Check-in:</span> ${reservation.checkInDate} 
                                    <span class="mx-2 text-primary-400">|</span> 
                                    <span class="font-semibold text-white">Check-out:</span> ${reservation.checkOutDate}
                                </div>
                            </div>
                        </div>

                        <div class="flex-shrink-0">
                            <c:choose>
                                <c:when test="${reservation.status == 'Pending'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-yellow-500 text-white shadow-md">⏳ Pending</span>
                                </c:when>
                                <c:when test="${reservation.status == 'Confirmed'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-blue-500 text-white shadow-md">📅 Confirmed</span>
                                </c:when>
                                <c:when test="${reservation.status == 'CheckedIn'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-green-500 text-white shadow-md">✓ Checked In</span>
                                </c:when>
                                <c:when test="${reservation.status == 'CheckedOut'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-gray-600 text-white shadow-md">🚪 Checked Out</span>
                                </c:when>
                                <c:when test="${reservation.status == 'Cancelled'}">
                                    <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-red-500 text-white shadow-md">🚫 Cancelled</span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">${reservation.numNights}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Nights</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">${reservation.numAdults}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Adults</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-primary-400">${reservation.numChildren}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Children</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center shadow-md">
                            <div class="text-3xl font-bold text-green-500">$<fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00"/></div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Total Amount</div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md h-full">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Guest & Room Info</h3>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Guest Name</label>
                                    <div class="text-sm text-gray-200 mt-1">${reservation.guestName}</div>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Email</label>
                                        <div class="text-sm text-gray-200 mt-1">${reservation.guestEmail}</div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Phone</label>
                                        <div class="text-sm text-gray-200 mt-1">${reservation.guestPhone}</div>
                                    </div>
                                </div>
                                <div class="pt-4 border-t border-gray-800">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Room Assignment</label>
                                    <div class="text-sm text-gray-200 mt-1">Room ${reservation.roomNumber} <span class="text-gray-500 ml-1">(${reservation.roomTypeName})</span></div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md h-full">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Booking Details</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Source</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty reservation.source ? reservation.source : '—'}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Booked By</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty reservation.bookedByName ? reservation.bookedByName : 'Online / Self-Service'}</div>
                                </div>
                                <div class="col-span-2">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Created At</label>
                                    <div class="text-sm text-gray-200 mt-1">${reservation.createdAt}</div>
                                </div>
                                <c:if test="${not empty reservation.specialRequests}">
                                    <div class="col-span-2 pt-2">
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Special Requests</label>
                                        <div class="text-sm text-yellow-400/90 mt-1 bg-yellow-500/10 p-3 rounded-lg border border-yellow-500/20">
                                            ${reservation.specialRequests}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden shadow-md">
                        <div class="p-6 border-b border-gray-800 flex items-center justify-between">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider">Incidental Charges</h3>
                            <c:choose>
							    <c:when test="${reservation.status == 'CheckedIn'}">
							        <a href="${pageContext.request.contextPath}/extracharge?action=new&reservationId=${reservation.id}"
							           class="inline-flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-500 text-white text-xs font-medium rounded-lg transition-colors shadow-sm">
							            + Add Charge
							        </a>
							    </c:when>
							    <c:otherwise>
							        <button disabled 
							                class="inline-flex items-center px-4 py-2 bg-gray-700 text-gray-500 text-xs font-medium rounded-lg cursor-not-allowed opacity-50">
							            + Add Charge
							        </button>
							    </c:otherwise>
							</c:choose>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty extraCharges}">
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left">
                                        <thead>
                                            <tr class="bg-gray-950 text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <th class="px-6 py-3">Date</th>
                                                <th class="px-6 py-3">Category</th>
                                                <th class="px-6 py-3">Description</th>
                                                <th class="px-6 py-3">Amount</th>
                                                <th class="px-6 py-3 text-right">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-800">
                                            <c:forEach var="charge" items="${extraCharges}">
                                                <tr class="hover:bg-gray-800/30 transition-colors text-sm text-gray-300">
                                                    <td class="px-6 py-4 whitespace-nowrap">${charge.chargeDate}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap font-semibold text-white">${charge.category}</td>
                                                    <td class="px-6 py-4">${charge.description}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-primary-400 font-medium">$<fmt:formatNumber value="${charge.amount}" pattern="#,##0.00"/></td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-right">
                                                        <button onclick="if(confirm('Delete this charge?')) window.location='${pageContext.request.contextPath}/extracharge?action=delete&id=${charge.id}&reservationId=${reservation.id}'" 
                                                                class="text-red-500 hover:text-red-400 transition-colors font-medium">✕</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot class="bg-gray-950/50 border-t border-gray-800">
                                            <tr>
                                                <td colspan="3" class="px-6 py-4 text-right text-sm font-bold text-gray-400 uppercase">Total Extra Charges:</td>
                                                <td colspan="2" class="px-6 py-4 text-lg font-bold text-white">$<fmt:formatNumber value="${totalExtraCharges}" pattern="#,##0.00"/></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-8 text-center text-gray-500 text-sm">
                                    No incidental charges have been added to this reservation yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 shadow-md">
                        <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Reservation Workflow</h3>
                        
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                            <c:if test="${reservation.status == 'Pending'}">
                                <button onclick="confirmAction(${reservation.id}, 'confirm')" class="w-full flex flex-col items-center justify-center p-4 bg-blue-500/10 hover:bg-blue-500/20 border border-blue-500/30 text-blue-400 font-medium rounded-lg transition-colors">
                                    <svg class="w-6 h-6 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                                    Confirm Booking
                                </button>
                            </c:if>
                            
                            <c:if test="${reservation.status == 'Confirmed'}">
                                <button onclick="confirmAction(${reservation.id}, 'checkIn')" class="w-full flex flex-col items-center justify-center p-4 bg-green-500/10 hover:bg-green-500/20 border border-green-500/30 text-green-400 font-medium rounded-lg transition-colors">
                                    <svg class="w-6 h-6 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
                                    Check In Guest
                                </button>
                            </c:if>

                            <c:if test="${reservation.status == 'CheckedIn'}">
                                <button onclick="confirmAction(${reservation.id}, 'checkOut')" class="w-full flex flex-col items-center justify-center p-4 bg-primary-500/10 hover:bg-primary-500/20 border border-primary-500/30 text-primary-400 font-medium rounded-lg transition-colors">
                                    <svg class="w-6 h-6 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                                    Check Out Guest
                                </button>
                            </c:if>

                            <c:if test="${reservation.status != 'Cancelled' && reservation.status != 'CheckedOut'}">
                                <button onclick="confirmAction(${reservation.id}, 'cancel')" class="w-full flex flex-col items-center justify-center p-4 bg-red-500/10 hover:bg-red-500/20 border border-red-500/30 text-red-400 font-medium rounded-lg transition-colors">
                                    <svg class="w-6 h-6 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                    Cancel Booking
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 flex flex-wrap items-center justify-end gap-4 mt-6 shadow-md">
                        <a href="${pageContext.request.contextPath}/reservation?action=list" class="px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors mr-auto">
                            ← Back to List
                        </a>
						
						 <a href="${pageContext.request.contextPath}/bill?action=view&reservationId=${reservation.id}"
						   class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-green-600 to-green-700 hover:from-green-500 hover:to-green-600 border border-green-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
						    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
						    </svg>
						    View Bill
						</a>
						
                        <a href="${pageContext.request.contextPath}/reservation?action=edit&id=${reservation.id}" class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                            Edit
                        </a>

                        <button onclick="confirmDelete(${reservation.id}, '${reservation.reservationNumber}', '${reservation.status}')" class="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg shadow-md transition-colors flex items-center">
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
            
            const now = new Date();
            const formattedDate = new Intl.DateTimeFormat('en-US', {
                weekday: 'long', month: 'long', day: '2-digit', year: 'numeric', 
                hour: 'numeric', minute: '2-digit', hour12: true
            }).format(now).replace(' at ', ' at '); 
            
            document.getElementById('toast-subtitle').textContent = formattedDate;

            toast.classList.remove('translate-y-8', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');

            clearTimeout(toastTimeout);
            toastTimeout = setTimeout(() => { hideToast(); }, 4500);
        }

        function hideToast() {
            const toast = document.getElementById('custom-toast');
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-8', 'opacity-0');
        }

        // Action confirmation
        function confirmAction(id, action) {
            const messages = {
                'confirm': 'Confirm this reservation?',
                'checkIn': 'Check in guest now?',
                'checkOut': 'Check out guest now?',
                'cancel': 'Cancel this reservation?\n\nThis will free up the room.'
            };
            if (confirm(messages[action])) {
                window.location = '${pageContext.request.contextPath}/reservation?action=' + action + '&id=' + id;
            }
        }

        // Delete confirmation
        function confirmDelete(id, resNum, status) {
            if (status === 'CheckedIn' || status === 'Confirmed') {
                showToast("Cannot delete active reservation. Please cancel or check out first.");
                return;
            }
            if (confirm('Permanently delete reservation ' + resNum + '?\n\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/reservation?action=delete&id=' + id;
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            <c:if test="${param.success == 'checkedin'}">showToast("Guest successfully checked in");</c:if>
            <c:if test="${param.success == 'checkedout'}">showToast("Guest successfully checked out");</c:if>
            <c:if test="${param.success == 'cancelled'}">showToast("Reservation cancelled successfully");</c:if>
            <c:if test="${param.success == 'confirmed'}">showToast("Reservation confirmed successfully");</c:if>
            
            <c:if test="${param.success == 'charge_added'}">showToast("Extra charges addedd successfully");</c:if>
            <c:if test="${param.success == 'charge_updated'}">showToast("Extra charges updated successfully");</c:if>
            <c:if test="${param.success == 'charge_deleted'}">showToast("Extra charges deleted successfully");</c:if>
        });
    </script>
</body>
</html>