<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty sessionScope.loggedInStaff}">
    <c:redirect url="/login?status=sessionExpired"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice ${bill.reservationNumber} - Ocean View Resort</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        @media print {
            @page {
                size: A4;
                margin: 15mm;
            }
            body {
                margin: 0;
                padding: 0;
            }
            .no-print {
                display: none !important;
            }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: #f5f5f5;
            color: #000;
            line-height: 1.5;
            padding: 20px;
        }

        .invoice-container {
            max-width: 210mm; /* A4 width */
            margin: 0 auto;
            background: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* HEADER - Compact */
        .invoice-header {
            background: linear-gradient(135deg, #1B4F8A 0%, #2c7dc7 100%);
            color: white;
            padding: 20px 30px;
            position: relative;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .company-info h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .company-info p {
            font-size: 11px;
            opacity: 0.95;
            line-height: 1.6;
        }

        .invoice-title {
            text-align: right;
        }

        .invoice-title h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .invoice-title .invoice-number {
            font-size: 13px;
            opacity: 0.9;
        }

        /* STATUS BADGE - Compact */
        .status-badge {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 6px 16px;
            border-radius: 16px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-paid {
            background: rgba(39, 174, 96, 0.2);
            color: #27ae60;
            border: 2px solid #27ae60;
        }

        .status-partial {
            background: rgba(241, 196, 15, 0.2);
            color: #f39c12;
            border: 2px solid #f39c12;
        }

        .status-unpaid {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
            border: 2px solid #e74c3c;
        }

        /* INFO SECTION - Compact */
        .invoice-info {
            padding: 20px 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .info-block h3 {
            font-size: 10px;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #1B4F8A;
            padding-bottom: 4px;
        }

        .info-block p {
            margin: 3px 0;
            font-size: 12px;
            color: #333;
        }

        .info-block .strong {
            font-weight: 600;
            color: #000;
            font-size: 13px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 2px 0;
        }

        .info-row .label {
            color: #666;
            font-size: 11px;
        }

        .info-row .value {
            font-weight: 600;
            color: #000;
            font-size: 12px;
        }

        /* TABLES - Compact */
        .charges-section {
            padding: 20px 30px;
        }

        .section-title {
            font-size: 14px;
            font-weight: 700;
            color: #1B4F8A;
            margin-bottom: 10px;
            padding-bottom: 6px;
            border-bottom: 2px solid #1B4F8A;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        thead {
            background: #f5f5f5;
        }

        thead th {
            padding: 8px;
            text-align: left;
            font-size: 10px;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            border-bottom: 2px solid #ddd;
        }

        thead th.text-center {
            text-align: center;
        }

        thead th.text-right {
            text-align: right;
        }

        tbody tr {
            border-bottom: 1px solid #e0e0e0;
        }

        tbody td {
            padding: 8px;
            font-size: 12px;
            color: #333;
        }

        tbody td.text-center {
            text-align: center;
        }

        tbody td.text-right {
            text-align: right;
        }

        tbody td.font-semibold {
            font-weight: 600;
            color: #000;
        }

        .category-badge {
            display: inline-block;
            padding: 2px 8px;
            background: #e8f4fd;
            color: #1B4F8A;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 600;
        }

        /* TOTALS - Compact */
        .totals-section {
            padding: 0 30px 20px;
        }

        .totals-table {
            margin-left: auto;
            width: 350px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            font-size: 13px;
        }

        .total-row.subtotal {
            color: #666;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }

        .total-row.tax {
            color: #666;
        }

        .total-row.grand-total {
            border-top: 2px solid #1B4F8A;
            border-bottom: 2px solid #1B4F8A;
            padding: 10px 0;
            font-size: 16px;
            font-weight: 700;
            color: #1B4F8A;
        }

        .total-row.paid {
            color: #27ae60;
            font-weight: 600;
        }

        .total-row.balance {
            border-top: 2px solid #e74c3c;
            padding-top: 10px;
            font-size: 16px;
            font-weight: 700;
            color: #e74c3c;
        }

        .total-row.balance.paid-full {
            color: #27ae60;
        }

        /* PAYMENT SECTION - Compact */
        .payment-section {
            padding: 0 30px 20px;
        }

        .payment-badge {
            display: inline-block;
            padding: 2px 8px;
            background: #e3f2fd;
            color: #1976d2;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 600;
        }

        /* FOOTER - Compact */
        .invoice-footer {
            padding: 15px 30px;
            background: #f9f9f9;
            border-top: 1px solid #e0e0e0;
            text-align: center;
        }

        .footer-note {
            font-size: 11px;
            color: #666;
            margin-bottom: 8px;
        }

        .footer-legal {
            font-size: 9px;
            color: #999;
            font-style: italic;
        }

        /* PRINT BUTTONS */
        .action-buttons {
            position: fixed;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
            z-index: 1000;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-print {
            background: #1B4F8A;
            color: white;
        }

        .btn-print:hover {
            background: #163d6e;
            transform: translateY(-2px);
        }

        .btn-back {
            background: #6c757d;
            color: white;
        }

        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <!-- ACTION BUTTONS -->
    <div class="action-buttons no-print">
        <button onclick="history.back()" class="btn btn-back">
            ← Back
        </button>
        <button onclick="window.print()" class="btn btn-print">
            🖨️ Print
        </button>
    </div>

    <div class="invoice-container">
        
        <!-- HEADER -->
        <div class="invoice-header">
            <c:choose>
                <c:when test="${bill.balanceDue <= 0}">
                    <div class="status-badge status-paid">✓ PAID</div>
                </c:when>
                <c:when test="${bill.paidAmount > 0 && bill.balanceDue > 0}">
                    <div class="status-badge status-partial">⚠ PARTIAL</div>
                </c:when>
                <c:otherwise>
                    <div class="status-badge status-unpaid">● UNPAID</div>
                </c:otherwise>
            </c:choose>
            
            <div class="header-content">
                <div class="company-info">
                    <h1>OCEAN VIEW RESORT</h1>
                    <p>
                        123 Beach Road, Galle, Sri Lanka<br>
                        Tel: +94 91 222 3456 | info@oceanviewresort.lk
                    </p>
                </div>
                <div class="invoice-title">
                    <h2>INVOICE</h2>
                    <div class="invoice-number">#${bill.reservationNumber}</div>
                </div>
            </div>
        </div>

        <!-- INFO SECTION -->
        <div class="invoice-info">
            <div class="info-block">
                <h3>Bill To</h3>
                <p class="strong">${bill.guestName}</p>
                <p>${bill.guestEmail}</p>
                <p>${bill.guestPhone}</p>
            </div>

            <div class="info-block">
                <h3>Reservation Details</h3>
                <div class="info-row">
                    <span class="label">Room:</span>
                    <span class="value">${bill.roomNumber} - ${bill.roomTypeName}</span>
                </div>
                <div class="info-row">
                    <span class="label">Check-In:</span>
                    <span class="value">${bill.checkInDate}</span>
                </div>
                <div class="info-row">
                    <span class="label">Check-Out:</span>
                    <span class="value">${bill.checkOutDate}</span>
                </div>
                <div class="info-row">
                    <span class="label">Nights:</span>
                    <span class="value">${bill.numNights}</span>
                </div>
                <div class="info-row">
                    <span class="label">Guests:</span>
                    <span class="value">${bill.numAdults} Adult(s), ${bill.numChildren} Child(ren)</span>
                </div>
            </div>
        </div>

        <!-- ROOM CHARGES -->
        <div class="charges-section">
            <div class="section-title">Room Charges</div>
            <table>
                <thead>
                    <tr>
                        <th>Description</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-right">Rate (LKR)</th>
                        <th class="text-right">Amount (LKR)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>${bill.roomTypeName} - Room ${bill.roomNumber}</td>
                        <td class="text-center">${bill.numNights} night(s)</td>
                        <td class="text-right"><fmt:formatNumber value="${bill.pricePerNight}" pattern="#,##0.00"/></td>
                        <td class="text-right font-semibold"><fmt:formatNumber value="${bill.roomCharges}" pattern="#,##0.00"/></td>
                    </tr>
                </tbody>
            </table>

            <!-- EXTRA CHARGES -->
            <c:if test="${not empty bill.extraChargesList}">
                <div class="section-title">Additional Services</div>
                <table>
                    <thead>
                        <tr>
                            <th>Service</th>
                            <th class="text-center">Category</th>
                            <th class="text-center">Date</th>
                            <th class="text-right">Amount (LKR)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="charge" items="${bill.extraChargesList}">
                            <tr>
                                <td>${charge.description}</td>
                                <td class="text-center">
                                    <span class="category-badge">${charge.category}</span>
                                </td>
                                <td class="text-center">${charge.chargeDate}</td>
                                <td class="text-right font-semibold"><fmt:formatNumber value="${charge.amount}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <!-- TOTALS -->
        <div class="totals-section">
            <div class="totals-table">
                <div class="total-row subtotal">
                    <span>Subtotal:</span>
                    <span>LKR <fmt:formatNumber value="${bill.subtotal}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row tax">
                    <span>Tax (10% VAT):</span>
                    <span>LKR <fmt:formatNumber value="${bill.taxAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row grand-total">
                    <span>TOTAL:</span>
                    <span>LKR <fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row paid">
                    <span>Paid:</span>
                    <span>LKR <fmt:formatNumber value="${bill.paidAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row balance ${bill.balanceDue <= 0 ? 'paid-full' : ''}">
                    <span>BALANCE:</span>
                    <span>LKR <fmt:formatNumber value="${bill.balanceDue}" pattern="#,##0.00"/></span>
                </div>
            </div>
        </div>

        <!-- PAYMENT HISTORY -->
        <c:if test="${not empty bill.paymentsList}">
            <div class="payment-section">
                <div class="section-title">Payment History</div>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Method</th>
                            <th class="text-center">Type</th>
                            <th class="text-right">Amount (LKR)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="payment" items="${bill.paymentsList}">
                            <tr>
                                <td>${payment.paymentDate}</td>
                                <td>${payment.paymentMethod}</td>
                                <td class="text-center">
                                    <span class="payment-badge">${payment.paymentType}</span>
                                </td>
                                <td class="text-right font-semibold"><fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <!-- FOOTER -->
        <div class="invoice-footer">
            <p class="footer-note">
                <strong>Thank you for choosing Ocean View Resort!</strong>
            </p>
            <p class="footer-legal">
                Computer-generated invoice. For queries: +94 91 222 3456
            </p>
        </div>

    </div>

</body>
</html>