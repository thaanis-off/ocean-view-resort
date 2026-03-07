<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill ${bill.reservationNumber} — Ocean View Resort</title>
    
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
<body class="bg-gray-950 text-gray-100">

<c:if test="${empty sessionScope.loggedInStaff}">
    <c:redirect url="/login?status=sessionExpired"/>
</c:if>
    <div class="flex h-screen overflow-hidden">
        
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
            <jsp:param name="activePage" value="reservations" />
        </jsp:include>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <!-- HEADER -->
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/reservation?action=view&id=${bill.reservationId}" 
                           class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white">Bill / Invoice</h1>
                            <p class="text-sm text-gray-400 mt-1">Reservation ${bill.reservationNumber}</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-3">
                        <a href="${pageContext.request.contextPath}/bill?action=print&reservationId=${bill.reservationId}" 
                           target="_blank"
                           class="flex items-center space-x-2 px-4 py-2 bg-primary-600 hover:bg-primary-500 text-white rounded-lg transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
                            </svg>
                            <span>Print Bill</span>
                        </a>
                    </div>
                </div>
            </header>

            <!-- CONTENT -->
            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-4xl mx-auto space-y-6">

                    <!-- PAYMENT STATUS BADGE -->
                    <div class="flex justify-end">
                        <c:choose>
                            <c:when test="${bill.status == 'Paid'}">
                                <span class="px-4 py-2 bg-green-500/10 border border-green-500/20 text-green-400 rounded-full text-sm font-bold">
                                    ✓ Paid in Full
                                </span>
                            </c:when>
                            <c:when test="${bill.status == 'Partial'}">
                                <span class="px-4 py-2 bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 rounded-full text-sm font-bold">
                                    ⚠ Partially Paid
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="px-4 py-2 bg-red-500/10 border border-red-500/20 text-red-400 rounded-full text-sm font-bold">
                                    ● Unpaid
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- INVOICE HEADER -->
                    <div class="bg-gray-900 border border-gray-800 rounded-2xl p-8">
                        <div class="flex justify-between items-start mb-8">
                            <div>
                                <h2 class="text-3xl font-bold text-white mb-2">Ocean View Resort</h2>
                                <p class="text-gray-400 text-sm">123 Beach Road, Negombo</p>
                                <p class="text-gray-400 text-sm">Western Province, Sri Lanka</p>
                                <p class="text-gray-400 text-sm">Tel: +94 31 222 3456</p>
                            </div>
                            <div class="text-right">
                                <h3 class="text-2xl font-bold text-primary-400">INVOICE</h3>
                                <p class="text-gray-400 text-sm mt-2">Bill Date: ${bill.billDate != null ? bill.billDate : 'N/A'}</p>
                                <p class="text-white font-semibold mt-1">${bill.reservationNumber}</p>
                            </div>
                        </div>

                        <div class="border-t border-gray-800 pt-6">
                            <div class="grid grid-cols-2 gap-8">
                                <div>
                                    <h4 class="text-xs font-bold text-gray-500 uppercase mb-3">Bill To:</h4>
                                    <p class="text-white font-semibold">${bill.guestName}</p>
                                    <p class="text-gray-400 text-sm mt-1">${bill.guestEmail}</p>
                                    <p class="text-gray-400 text-sm">${bill.guestPhone}</p>
                                    <c:if test="${not empty bill.guestAddress}">
                                        <p class="text-gray-400 text-sm mt-2">${bill.guestAddress}</p>
                                    </c:if>
                                </div>
                                <div>
                                    <h4 class="text-xs font-bold text-gray-500 uppercase mb-3">Reservation Details:</h4>
                                    <div class="space-y-2">
                                        <div class="flex justify-between">
                                            <span class="text-gray-400 text-sm">Room:</span>
                                            <span class="text-white text-sm">${bill.roomNumber} - ${bill.roomTypeName}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-400 text-sm">Check-In:</span>
                                            <span class="text-white text-sm">${bill.checkInDate}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-400 text-sm">Check-Out:</span>
                                            <span class="text-white text-sm">${bill.checkOutDate}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-400 text-sm">Guests:</span>
                                            <span class="text-white text-sm">${bill.numAdults} Adult(s), ${bill.numChildren} Child(ren)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- CHARGES BREAKDOWN -->
                    <div class="bg-gray-900 border border-gray-800 rounded-2xl overflow-hidden">
                        <div class="p-6">
                            <h3 class="text-lg font-bold text-white mb-4">Charges Breakdown</h3>
                            
                            <!-- Room Charges -->
                            <table class="w-full mb-6">
                                <thead class="border-b border-gray-800">
                                    <tr class="text-left text-xs font-semibold text-gray-400 uppercase">
                                        <th class="pb-3">Description</th>
                                        <th class="pb-3 text-center">Quantity</th>
                                        <th class="pb-3 text-right">Rate</th>
                                        <th class="pb-3 text-right">Amount</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-800">
                                    <tr>
                                        <td class="py-4 text-white">Room Charges - ${bill.roomTypeName}</td>
                                        <td class="py-4 text-center text-gray-300">${bill.numNights} night(s)</td>
                                        <td class="py-4 text-right text-gray-300">LKR <fmt:formatNumber value="${bill.pricePerNight}" pattern="#,##0.00"/></td>
                                        <td class="py-4 text-right font-semibold text-white">LKR <fmt:formatNumber value="${bill.roomCharges}" pattern="#,##0.00"/></td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- Extra Charges -->
                            <c:if test="${not empty bill.extraChargesList}">
                                <h4 class="text-md font-semibold text-white mb-3">Additional Services</h4>
                                <table class="w-full mb-6">
                                    <thead class="border-b border-gray-800">
                                        <tr class="text-left text-xs font-semibold text-gray-400 uppercase">
                                            <th class="pb-3">Service</th>
                                            <th class="pb-3 text-center">Category</th>
                                            <th class="pb-3 text-center">Date</th>
                                            <th class="pb-3 text-right">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-gray-800">
                                        <c:forEach var="charge" items="${bill.extraChargesList}">
                                            <tr>
                                                <td class="py-3 text-gray-300">${charge.description}</td>
                                                <td class="py-3 text-center">
                                                    <span class="px-2 py-1 bg-primary-500/10 text-primary-400 rounded text-xs">
                                                        ${charge.category}
                                                    </span>
                                                </td>
                                                <td class="py-3 text-center text-gray-400 text-sm">${charge.chargeDate}</td>
                                                <td class="py-3 text-right text-gray-300">LKR <fmt:formatNumber value="${charge.amount}" pattern="#,##0.00"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:if>

                            <!-- Totals -->
                            <div class="border-t-2 border-gray-700 pt-6">
                                <div class="space-y-3 max-w-md ml-auto">
                                    <div class="flex justify-between text-gray-300">
                                        <span>Subtotal:</span>
                                        <span class="font-semibold">LKR <fmt:formatNumber value="${bill.subtotal}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="flex justify-between text-gray-300">
                                        <span>Tax (${bill.taxRate}% VAT):</span>
                                        <span class="font-semibold">LKR <fmt:formatNumber value="${bill.taxAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="flex justify-between text-xl font-bold text-white border-t border-gray-700 pt-3">
                                        <span>Total Amount:</span>
                                        <span>LKR <fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="flex justify-between text-green-400">
                                        <span>Paid:</span>
                                        <span class="font-semibold">LKR <fmt:formatNumber value="${bill.paidAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="flex justify-between text-xl font-bold ${bill.balanceDue > 0 ? 'text-red-400' : 'text-green-400'} border-t border-gray-700 pt-3">
                                        <span>Balance Due:</span>
                                        <span>LKR <fmt:formatNumber value="${bill.balanceDue}" pattern="#,##0.00"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- PAYMENT HISTORY -->
                    <c:if test="${not empty bill.paymentsList}">
                        <div class="bg-gray-900 border border-gray-800 rounded-2xl p-6">
                            <h3 class="text-lg font-bold text-white mb-4">Payment History</h3>
                            <table class="w-full">
                                <thead class="border-b border-gray-800">
                                    <tr class="text-left text-xs font-semibold text-gray-400 uppercase">
                                        <th class="pb-3">Date</th>
                                        <th class="pb-3">Method</th>
                                        <th class="pb-3">Type</th>
                                        <th class="pb-3">Reference</th>
                                        <th class="pb-3 text-right">Amount</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-800">
                                    <c:forEach var="payment" items="${bill.paymentsList}">
                                        <tr>
                                            <td class="py-3 text-gray-300">${payment.paymentDate}</td>
                                            <td class="py-3 text-gray-300">${payment.paymentMethod}</td>
                                            <td class="py-3">
                                                <span class="px-2 py-1 bg-blue-500/10 text-blue-400 rounded text-xs">
                                                    ${payment.paymentType}
                                                </span>
                                            </td>
                                            <td class="py-3 text-gray-400 text-sm">${payment.referenceNumber != null ? payment.referenceNumber : '—'}</td>
                                            <td class="py-3 text-right font-semibold text-white">LKR <fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- ACTION BUTTONS -->
                    <div class="flex justify-between items-center pt-6">
                        <a href="${pageContext.request.contextPath}/reservation?action=view&id=${bill.reservationId}"
                           class="px-6 py-3 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded-lg transition-colors">
                            ← Back to Reservation
                        </a>
                        <div class="flex space-x-3">
                            <c:if test="${bill.balanceDue > 0}">
                                <a href="${pageContext.request.contextPath}/payment?action=new&reservationId=${bill.reservationId}"
                                   class="px-6 py-3 bg-green-600 hover:bg-green-500 text-white rounded-lg transition-colors">
                                    💳 Record Payment
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/bill?action=print&reservationId=${bill.reservationId}"
                               target="_blank"
                               class="px-6 py-3 bg-primary-600 hover:bg-primary-500 text-white rounded-lg transition-colors">
                                🖨️ Print Bill
                            </a>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>
</body>
</html>