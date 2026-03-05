<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${payment != null ? 'Edit' : 'Add'} Payment — Ocean View Resort</title>
    
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
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="payments" />
    		</jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-white">${payment != null ? 'Edit' : 'Record'} Payment</h1>
                        <p class="text-sm text-gray-400 mt-1">Fill in payment details. Fields marked * are required.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/payment?action=list" class="text-primary-400 hover:text-primary-300 transition-colors text-sm font-medium">
                        ← Back to Payments
                    </a>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-900/20 border border-red-500/50 text-red-400 px-4 py-3 rounded-lg mb-6">
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Reservation Info -->
                <c:if test="${not empty selectedReservation}">
                    <div class="bg-primary-500/10 border border-primary-500/30 rounded-lg p-4 mb-6">
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                            <div>
                                <span class="text-gray-400">Reservation:</span>
                                <div class="text-white font-semibold">${selectedReservation.reservationNumber}</div>
                            </div>
                            <div>
                                <span class="text-gray-400">Guest:</span>
                                <div class="text-white font-semibold">${selectedReservation.guestName}</div>
                            </div>
                            <div>
                                <span class="text-gray-400">Total:</span>
                                <div class="text-white font-semibold">$${selectedReservation.totalAmount}</div>
                            </div>
                            <div>
                                <span class="text-gray-400">Balance Due:</span>
                                <div class="text-green-400 font-semibold">$${balanceDue}</div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/payment" method="post" class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                    <input type="hidden" name="action" value="${payment != null ? 'update' : 'create'}">
                    <c:if test="${payment != null}">
                        <input type="hidden" name="id" value="${payment.id}">
                    </c:if>

                    <!-- Payment Information -->
                    <div class="mb-8">
                        <h3 class="text-lg font-semibold text-white mb-4 pb-2 border-b border-gray-800">Payment Information</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Reservation -->
                            <div>
                                <label class="block text-sm font-medium text-gray-300 mb-2">
                                    Reservation <span class="text-red-500">*</span>
                                </label>
                                <select name="reservationId" required ${not empty selectedReservation ? 'disabled' : ''}
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                    <option value="">-- Select Reservation --</option>
                                    <c:forEach var="res" items="${reservations}">
                                        <option value="${res.id}" ${(payment != null && payment.reservationId == res.id) || (selectedReservation != null && selectedReservation.id == res.id) ? 'selected' : ''}>
                                            ${res.reservationNumber} - ${res.guestName} (Room ${res.roomNumber})
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty selectedReservation}">
                                    <input type="hidden" name="reservationId" value="${selectedReservation.id}">
                                </c:if>
                            </div>

                            <!-- Amount -->
                            <div>
                                <label class="block text-sm font-medium text-gray-300 mb-2">
                                    Amount <span class="text-red-500">*</span>
                                </label>
                                <input type="number" name="amount" step="0.01" min="0" 
                                    value="${payment != null ? payment.amount : balanceDue}" 
                                    placeholder="0.00" required
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                            </div>

                            <!-- Payment Method -->
                            <div>
                                <label class="block text-sm font-medium text-gray-300 mb-2">
                                    Payment Method <span class="text-red-500">*</span>
                                </label>
                                <select name="paymentMethod" required
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                    <option value="">-- Select Method --</option>
                                    <option value="Cash" ${payment != null && payment.paymentMethod == 'Cash' ? 'selected' : ''}>Cash</option>
                                    <option value="Credit Card" ${payment != null && payment.paymentMethod == 'Credit Card' ? 'selected' : ''}>Credit Card</option>
                                    <option value="Debit Card" ${payment != null && payment.paymentMethod == 'Debit Card' ? 'selected' : ''}>Debit Card</option>
                                    <option value="Bank Transfer" ${payment != null && payment.paymentMethod == 'Bank Transfer' ? 'selected' : ''}>Bank Transfer</option>
                                    <option value="Online" ${payment != null && payment.paymentMethod == 'Online' ? 'selected' : ''}>Online</option>
                                </select>
                            </div>

                            <!-- Payment Type -->
                            <div>
                                <label class="block text-sm font-medium text-gray-300 mb-2">
                                    Payment Type <span class="text-red-500">*</span>
                                </label>
                                <select name="paymentType" required
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                    <option value="">-- Select Type --</option>
                                    <option value="Deposit" ${payment != null && payment.paymentType == 'Deposit' ? 'selected' : ''}>Deposit</option>
                                    <option value="Full Payment" ${payment != null && payment.paymentType == 'Full Payment' ? 'selected' : ''}>Full Payment</option>
                                    <option value="Balance" ${payment != null && payment.paymentType == 'Balance' ? 'selected' : ''}>Balance</option>
                                    <option value="Refund" ${payment != null && payment.paymentType == 'Refund' ? 'selected' : ''}>Refund</option>
                                </select>
                            </div>

                            <!-- Reference Number -->
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-gray-300 mb-2">Reference Number</label>
                                <input type="text" name="referenceNumber" value="${payment != null ? payment.referenceNumber : ''}" 
                                    placeholder="Transaction/Receipt number"
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                <p class="text-xs text-gray-500 mt-1">Optional: Card transaction ID or receipt number</p>
                            </div>

                            <!-- Notes -->
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-gray-300 mb-2">Notes</label>
                                <textarea name="notes" rows="3" placeholder="Any additional notes..."
                                    class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none resize-none">${payment != null ? payment.notes : ''}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="flex items-center gap-4 pt-4 border-t border-gray-800">
                        <button type="submit" 
                            class="px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg transition-all">
                            ${payment != null ? 'Update Payment' : 'Record Payment'}
                        </button>
                        <c:if test="${payment == null}">
                            <button type="reset" 
                                class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                Clear Form
                            </button>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/payment?action=list" 
                            class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                            Cancel
                        </a>
                    </div>
                </form>
            </main>
        </div>
    </div>
</body>
</html>