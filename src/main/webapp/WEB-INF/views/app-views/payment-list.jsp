<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payments — Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: { extend: { fontFamily: { sans: ['Inter', 'sans-serif'] }, colors: { primary: { 50: '#f0f4ff', 100: '#e8f0fb', 500: '#1B4F8A', 600: '#163d6e', 700: '#0f2a4d' } } } }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100">
    <c:if test="${empty sessionScope.loggedInStaff}"><c:redirect url="/login?status=sessionExpired"/></c:if>
    
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="payments" />
    		</jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-white">Payment Management</h1>
                        <p class="text-sm text-gray-400 mt-1">Track and manage all payment transactions</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/payment?action=new" class="inline-flex items-center space-x-2 px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg transition-all">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                        <span>Record Payment</span>
                    </a>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <!-- Stats -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
                        <div class="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary-600 to-blue-400"></div>
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Total Payments</p>
                        <h3 class="text-2xl font-bold text-white mt-1">${totalPayments}</h3>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Today's Revenue</p>
                        <h3 class="text-2xl font-bold text-green-400 mt-1">$<fmt:formatNumber value="${stats.totalReceived}" pattern="#,##0.00"/></h3>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Cash Payments</p>
                        <h3 class="text-2xl font-bold text-white mt-1">$<fmt:formatNumber value="${stats.cashPayments}" pattern="#,##0.00"/></h3>
                    </div>
                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">Card Payments</p>
                        <h3 class="text-2xl font-bold text-white mt-1">$<fmt:formatNumber value="${stats.cardPayments}" pattern="#,##0.00"/></h3>
                    </div>
                </div>

                
                <!--search -->
                <div class="bg-gray-900 border border-gray-800 p-4 rounded-xl mb-6 flex flex-col md:flex-row gap-4 items-center">
                    <div class="flex-1 relative w-full">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </div>
                        <input type="text" id="searchInput" placeholder="Search rooms by number, type, or view..." value="${keyword}" onkeyup="liveSearch()" 
                            class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-10 pr-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                    </div>
                    
                    <div class="w-full md:w-auto">
                        <select onchange="filterBy(this.value)" class="bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5">
                        <option value="">Filter...</option>
                        <optgroup label="By Method">
                            <option value="method:Cash">Cash</option>
                            <option value="method:Credit Card">Credit Card</option>
                        </optgroup>
                        <optgroup label="By Type">
                            <option value="type:Deposit">Deposit</option>
                            <option value="type:Full Payment">Full Payment</option>
                        </optgroup>
                    </select>
                    </div>

                    <div class="flex space-x-3 w-full md:w-auto">
                        <button onclick="window.location='${pageContext.request.contextPath}/payment?action=search&keyword='+document.getElementById('searchInput').value" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300 text-center">
                            Search
                        </button>
                        <a href="${pageContext.request.contextPath}/payment?action=list" 
                            class="flex-1 md:flex-none px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors text-center">
                            Clear
                        </a>
                    </div>
                </div>

                <!-- Table -->
                <div class="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
                    <c:choose>
                        <c:when test="${empty paymentList}">
                            <div class="text-center py-16">
                                <svg class="mx-auto h-12 w-12 text-gray-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                                <h3 class="text-lg font-medium text-gray-300">No payments found</h3>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="w-full">
                                <thead class="bg-gray-900 border-b border-gray-800">
                                    <tr class="text-xs font-medium text-gray-400 uppercase tracking-wider">
                                        <th class="px-6 py-4 text-left">Date</th>
                                        <th class="px-6 py-4 text-left">Reservation</th>
                                        <th class="px-6 py-4 text-left">Guest</th>
                                        <th class="px-6 py-4 text-left">Amount</th>
                                        <th class="px-6 py-4 text-left">Method</th>
                                        <th class="px-6 py-4 text-left">Type</th>
                                        <th class="px-6 py-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-800">
                                    <c:forEach var="pay" items="${paymentList}">
                                        <tr class="hover:bg-gray-800/50 transition-colors">
                                            <td class="px-6 py-4 text-sm text-gray-300">${pay.formattedPaymentDate}</td>
                                            <td class="px-6 py-4 text-sm text-white font-medium">${pay.reservationNumber}</td>
                                            <td class="px-6 py-4 text-sm text-gray-300">${pay.guestName}</td>
                                            <td class="px-6 py-4 text-sm font-bold text-green-400">$<fmt:formatNumber value="${pay.amount}" pattern="#,##0.00"/></td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${pay.paymentMethod == 'Cash'}"><span class="px-2.5 py-1 text-xs rounded-full bg-green-500/10 text-green-400 border border-green-500/20">Cash</span></c:when>
                                                    <c:otherwise><span class="px-2.5 py-1 text-xs rounded-full bg-blue-500/10 text-blue-400 border border-blue-500/20">${pay.paymentMethod}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${pay.paymentType == 'Deposit'}"><span class="px-2.5 py-1 text-xs rounded-full bg-yellow-500/10 text-yellow-400">Deposit</span></c:when>
                                                    <c:when test="${pay.paymentType == 'Full Payment'}"><span class="px-2.5 py-1 text-xs rounded-full bg-green-500/10 text-green-400">Full</span></c:when>
                                                    <c:when test="${pay.paymentType == 'Refund'}"><span class="px-2.5 py-1 text-xs rounded-full bg-red-500/10 text-red-400">Refund</span></c:when>
                                                    <c:otherwise><span class="px-2.5 py-1 text-xs rounded-full bg-blue-500/10 text-blue-400">${pay.paymentType}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-right">
                                                <div class="flex justify-end space-x-3">
                                                    <a href="${pageContext.request.contextPath}/payment?action=view&id=${pay.id}" class="text-blue-400 hover:text-blue-300">View</a>
                                                    <a href="${pageContext.request.contextPath}/payment?action=edit&id=${pay.id}" class="text-yellow-500 hover:text-yellow-400">Edit</a>
                                                    <button onclick="confirmDelete(${pay.id}, '${pay.reservationNumber}')" class="text-red-500 hover:text-red-400">Delete</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <!-- Toast -->
    <div id="toast" class="fixed bottom-6 right-6 z-50 transition-all duration-400 transform translate-y-8 opacity-0 pointer-events-none">
        <div class="bg-gradient-to-br from-primary-600 to-gray-900 border border-primary-500/30 rounded-2xl shadow-[0_10px_40px_rgba(0,0,0,0.5)] p-4 flex items-center gap-4 min-w-[360px]">
            <span id="toast-msg" class="text-white font-semibold"></span>
            <button onclick="hideToast()" class="bg-white hover:bg-gray-100 text-primary-700 text-sm font-semibold px-4 py-1.5 rounded-lg">Dismiss</button>
        </div>
    </div>

    <script>
        function searchPayments() {
            window.location = '${pageContext.request.contextPath}/payment?action=search&keyword=' + document.getElementById('searchInput').value;
        }
        function filterBy(val) {
            if (val) {
                const [type, v] = val.split(':');
                window.location = '${pageContext.request.contextPath}/payment?action=filter&filterType=' + type + '&filterValue=' + v;
            }
        }
        function confirmDelete(id, resNum) {
            if (confirm('Delete payment for ' + resNum + '?\n\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/payment?action=delete&id=' + id;
            }
        }
        function showToast(msg) {
            const toast = document.getElementById('toast');
            document.getElementById('toast-msg').textContent = msg;
            toast.classList.remove('translate-y-8', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');
            setTimeout(hideToast, 4000);
        }
        function hideToast() {
            const toast = document.getElementById('toast');
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-8', 'opacity-0');
        }
        <c:if test="${param.success == 'added'}">showToast("Payment recorded successfully");</c:if>
        <c:if test="${param.success == 'updated'}">showToast("Payment updated successfully");</c:if>
        <c:if test="${param.success == 'deleted'}">showToast("Payment deleted successfully");</c:if>
    </script>
</body>
</html>