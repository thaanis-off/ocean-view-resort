<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${reservation != null ? 'Edit' : 'Add'} Reservation — Ocean View Resort</title>
    
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

    <c:if test="${empty sessionScope.loggedInStaff}">
        <c:redirect url="/login?status=sessionExpired"/>
    </c:if>

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
                            <h1 class="text-2xl font-bold text-white flex items-center">
                                ${reservation != null ? 'Edit Reservation' : 'New Reservation'}
                                <span class="ml-3 px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-500/20 text-primary-400 border border-primary-500/30">
                                    ${reservation != null ? 'Update Record' : 'Create Booking'}
                                </span>
                            </h1>
                            <p class="text-sm text-gray-400 mt-1">Fill in the booking details below. Fields marked <span class="text-red-500">*</span> are required.</p>
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
                        <form action="${pageContext.request.contextPath}/reservation" method="post" class="space-y-8">
                            <input type="hidden" name="action" value="${reservation != null ? 'update' : 'create'}">
                            <c:if test="${reservation != null}">
                                <input type="hidden" name="id" value="${reservation.id}">
                            </c:if>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Guest & Room Information</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Guest <span class="text-red-500">*</span></label>
                                        <select name="guestId" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="" class="bg-gray-900">-- Select Guest --</option>
                                            <c:forEach var="guest" items="${guests}">
                                                <option value="${guest.id}" ${(reservation != null && reservation.guestId == guest.id) || param.guestId == guest.id ? 'selected' : ''} class="bg-gray-900">
                                                    ${guest.fullName} (${guest.guestCode})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Room <span class="text-red-500">*</span></label>
                                        <select name="roomId" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="" class="bg-gray-900">-- Select Room --</option>
                                            <c:forEach var="room" items="${rooms}">
                                                <option value="${room.id}" ${(reservation != null && reservation.roomId == room.id) || param.roomId == room.id ? 'selected' : ''} class="bg-gray-900">
                                                    ${room.roomNumber} - ${room.roomTypeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Stay Dates</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Check-In Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="checkInDate" value="${reservation != null ? reservation.checkInDate : param.checkInDate}" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors [color-scheme:dark]">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Check-Out Date <span class="text-red-500">*</span></label>
                                        <input type="date" name="checkOutDate" value="${reservation != null ? reservation.checkOutDate : param.checkOutDate}" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors [color-scheme:dark]">
                                    </div>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Occupancy</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Number of Adults <span class="text-red-500">*</span></label>
                                        <input type="number" name="numAdults" min="1" max="10" value="${reservation != null ? reservation.numAdults : param.numAdults != null ? param.numAdults : 1}" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Number of Children</label>
                                        <input type="number" name="numChildren" min="0" max="10" value="${reservation != null ? reservation.numChildren : param.numChildren != null ? param.numChildren : 0}"
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Booking Details</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Status <span class="text-red-500">*</span></label>
                                        <select name="status" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="Pending" ${(reservation == null || reservation.status == 'Pending') || param.status == 'Pending' ? 'selected' : ''} class="bg-gray-900">Pending</option>
                                            <option value="Confirmed" ${(reservation != null && reservation.status == 'Confirmed') || param.status == 'Confirmed' ? 'selected' : ''} class="bg-gray-900">Confirmed</option>
                                            <option value="CheckedIn" ${(reservation != null && reservation.status == 'CheckedIn') || param.status == 'CheckedIn' ? 'selected' : ''} class="bg-gray-900">Checked In</option>
                                            <option value="CheckedOut" ${(reservation != null && reservation.status == 'CheckedOut') || param.status == 'CheckedOut' ? 'selected' : ''} class="bg-gray-900">Checked Out</option>
                                            <option value="Cancelled" ${(reservation != null && reservation.status == 'Cancelled') || param.status == 'Cancelled' ? 'selected' : ''} class="bg-gray-900">Cancelled</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Total Amount (LKR) <span class="text-red-500">*</span></label>
                                        <input type="number" name="totalAmount" step="0.01" min="0" value="${reservation != null ? reservation.totalAmount : param.totalAmount != null ? param.totalAmount : '0.00'}" placeholder="0.00" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                        <p class="text-xs text-gray-500 mt-1.5 text-primary-400/80">System will automatically recalculate this based on seasonal rates upon saving.</p>
                                    </div>
                                </div>

                                <div class="mb-6">
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Booking Source</label>
                                    <select name="source" class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                        <option value="Walk-In" ${(reservation == null || reservation.source == 'Walk-In') || param.source == 'Walk-In' ? 'selected' : ''} class="bg-gray-900">Walk-In</option>
                                        <option value="Phone" ${(reservation != null && reservation.source == 'Phone') || param.source == 'Phone' ? 'selected' : ''} class="bg-gray-900">Phone</option>
                                        <option value="Website" ${(reservation != null && reservation.source == 'Website') || param.source == 'Website' ? 'selected' : ''} class="bg-gray-900">Website</option>
                                        <option value="OTA" ${(reservation != null && reservation.source == 'OTA') || param.source == 'OTA' ? 'selected' : ''} class="bg-gray-900">OTA (Booking.com, Agoda)</option>
                                    </select>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Special Requests</label>
                                    <textarea name="specialRequests" placeholder="Any special requests, early check-in, dietary requirements..." rows="3"
                                        class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-3 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors resize-y">${reservation != null ? reservation.specialRequests : param.specialRequests}</textarea>
                                </div>
                            </div>

                            <div class="pt-6 mt-6 border-t border-gray-800 flex items-center justify-end space-x-4">
                                <c:if test="${reservation == null}">
                                    <button type="reset" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                        Clear Form
                                    </button>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/reservation?action=list" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                    Cancel
                                </a>
                                <button type="submit" class="px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
                                    ${reservation != null ? 'Update Reservation' : 'Save Reservation'}
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