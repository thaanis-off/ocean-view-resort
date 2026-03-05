<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Details — Ocean View Resort</title>
    
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
    <%-- Protect page --%>
    <c:if test="${empty sessionScope.loggedInStaff}">
        <c:redirect url="/login?status=sessionExpired"/>
    </c:if>
    
    <div class="flex h-screen overflow-hidden">
        
        <!-- Include Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
            <jsp:param name="activePage" value="payments" />
        </jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            
            <!-- Header -->
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <a href="${pageContext.request.contextPath}/payment?action=list" 
                           class="inline-flex items-center text-primary-400 hover:text-primary-300 transition-colors text-sm font-medium mb-2">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to Payments
                        </a>
                        <h1 class="text-2xl font-bold text-white">Payment Details</h1>
                        <p class="text-sm text-gray-400 mt-1">View payment receipt and transaction information</p>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <!-- Payment Receipt Header -->
				<div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
				    <div class="flex items-center gap-6 text-center md:text-left">
				        <div class="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center text-primary-100 shadow-inner flex-shrink-0 border border-white/20">
				            <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
				                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
				            </svg>
				        </div>
				        <div>
				            <h2 class="text-3xl font-bold text-white tracking-wide">Payment Receipt</h2>
				            <div class="mt-2 text-primary-100 text-sm flex items-center space-x-3">
				                <span class="font-medium">Transaction #${payment.id}</span>
				                <span class="text-white/40">•</span>
				                <span>${payment.formattedPaymentDate}</span>
				            </div>
				            <div class="mt-3 text-xl font-semibold text-white">
				                $<fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/> <span class="text-sm font-normal text-primary-200">paid</span>
				            </div>
				            <p class="text-primary-100/80 text-sm mt-2">
				                Reservation: <span class="font-semibold">${payment.reservationNumber}</span> • 
				                Guest: <span class="font-semibold">${payment.guestName}</span>
				            </p>
				        </div>
				    </div>
				
				    <div class="flex-shrink-0">
				        <span class="inline-flex items-center px-4 py-2 rounded-full text-sm font-bold bg-green-500 text-white shadow-md">
				            <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
				                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
				            </svg>
				            Completed
				        </span>
				    </div>
				</div>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6 pt-6">
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Amount Paid</p>
                        <h3 class="text-3xl font-bold text-blue-400 mt-2">$<fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></h3>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Payment Method</p>
                        <h3 class="text-xl font-bold text-white mt-2">${payment.paymentMethod}</h3>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Payment Type</p>
                        <h3 class="text-xl font-bold text-white mt-2">${payment.paymentType}</h3>
                    </div>
                </div>

                <!-- Details Card -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden mb-8">
                    
                    <!-- Payment Information -->
                    <div class="p-6 border-b border-gray-800">
                        <h3 class="text-lg font-semibold text-white mb-4 flex items-center">
                            <svg class="w-5 h-5 mr-2 text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                            </svg>
                            Payment Information
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Payment ID</p>
                                <p class="text-base text-white font-semibold">#${payment.id}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Payment Date</p>
                                <p class="text-base text-gray-300">${payment.formattedPaymentDate}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Amount</p>
                                <p class="text-base text-blue-400 font-bold">$<fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Payment Method</p>
                                <p class="text-base text-gray-300">
                                    <c:choose>
                                        <c:when test="${payment.paymentMethod == 'Cash'}">
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-green-500/10 text-green-400 border border-green-500/20">
                                                💵 Cash
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-blue-500/10 text-blue-400 border border-blue-500/20">
                                                💳 ${payment.paymentMethod}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Payment Type</p>
                                <p class="text-base text-gray-300">
                                    <c:choose>
                                        <c:when test="${payment.paymentType == 'Deposit'}">
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-yellow-500/10 text-yellow-400 border border-yellow-500/20">
                                                Deposit
                                            </span>
                                        </c:when>
                                        <c:when test="${payment.paymentType == 'Full Payment'}">
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-green-500/10 text-green-400 border border-green-500/20">
                                                Full Payment
                                            </span>
                                        </c:when>
                                        <c:when test="${payment.paymentType == 'Refund'}">
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-red-500/10 text-red-400 border border-red-500/20">
                                                Refund
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-blue-500/10 text-blue-400 border border-blue-500/20">
                                                ${payment.paymentType}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Reference Number</p>
                                <p class="text-base text-gray-300 font-mono">${not empty payment.referenceNumber ? payment.referenceNumber : '—'}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Reservation & Guest Details -->
                    <div class="p-6 border-b border-gray-800">
                        <h3 class="text-lg font-semibold text-white mb-4 flex items-center">
                            <svg class="w-5 h-5 mr-2 text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                            Reservation & Guest Details
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Reservation Number</p>
                                <p class="text-base text-white font-semibold">${payment.reservationNumber}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Guest Name</p>
                                <p class="text-base text-gray-300">${payment.guestName}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Room Number</p>
                                <p class="text-base text-gray-300">${payment.roomNumber}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">Received By</p>
                                <p class="text-base text-gray-300">${not empty payment.receivedByName ? payment.receivedByName : '—'}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Notes Section (if exists) -->
                    <c:if test="${not empty payment.notes}">
                        <div class="p-6">
                            <h3 class="text-lg font-semibold text-white mb-4 flex items-center">
                                <svg class="w-5 h-5 mr-2 text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                </svg>
                                Notes
                            </h3>
                            <div class="bg-gray-800/50 rounded-lg p-4">
                                <p class="text-gray-300 text-sm leading-relaxed">${payment.notes}</p>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Action Buttons -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                    <h3 class="text-lg font-semibold text-white mb-4">Actions</h3>
                    <div class="flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/payment?action=edit&id=${payment.id}" 
                           class="inline-flex items-center space-x-2 px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg transition-all">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                            <span>Edit Payment</span>
                        </a>
                        
                        <button onclick="confirmDelete(${payment.id}, '${payment.reservationNumber}')" 
                                class="inline-flex items-center space-x-2 px-5 py-2.5 bg-red-500/10 hover:bg-red-500/20 border border-red-500/30 text-red-400 hover:text-red-300 font-medium rounded-lg transition-all">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                            <span>Delete Payment</span>
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/payment?action=list" 
                           class="inline-flex items-center space-x-2 px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                            <span>Back to List</span>
                        </a>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <script>
        function confirmDelete(id, resNum) {
            if (confirm('Delete this payment for reservation ' + resNum + '?\n\nThis action cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/payment?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>