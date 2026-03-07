<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice ${bill.reservationNumber} - Ocean View Resort</title>
    <style>
        @media print {
            @page {
                size: A4;
                margin: 0;
            }
            body {
                margin: 0;
                padding: 20mm;
            }
            .no-print {
                display: none !important;
            }
            .page-break {
                page-break-after: always;
            }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
            color: #000;
            line-height: 1.6;
            padding: 40px;
        }

        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border: 2px solid #1B4F8A;
        }

        /* HEADER */
        .invoice-header {
            background: linear-gradient(135deg, #1B4F8A 0%, #2c7dc7 100%);
            color: white;
            padding: 30px;
            position: relative;
            overflow: hidden;
        }

        .invoice-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .company-info {
            position: relative;
            z-index: 1;
        }

        .company-name {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .company-details {
            font-size: 13px;
            opacity: 0.95;
            line-height: 1.8;
        }

        .invoice-title {
            position: absolute;
            top: 30px;
            right: 30px;
            text-align: right;
            z-index: 1;
        }

        .invoice-title h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .invoice-title .invoice-number {
            font-size: 14px;
            opacity: 0.9;
        }

        /* INFO SECTION */
        .invoice-info {
            padding: 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            border-bottom: 2px solid #e0e0e0;
        }

        .info-block h3 {
            font-size: 11px;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            margin-bottom: 12px;
            letter-spacing: 1px;
            border-bottom: 2px solid #1B4F8A;
            padding-bottom: 5px;
        }

        .info-block p {
            margin: 5px 0;
            font-size: 13px;
            color: #333;
        }

        .info-block .strong {
            font-weight: 600;
            color: #000;
            font-size: 14px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 4px 0;
        }

        .info-row .label {
            color: #666;
            font-size: 12px;
        }

        .info-row .value {
            font-weight: 600;
            color: #000;
            font-size: 13px;
        }

        /* CHARGES TABLE */
        .charges-section {
            padding: 30px;
        }

        .section-title {
            font-size: 16px;
            font-weight: bold;
            color: #1B4F8A;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #1B4F8A;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        thead {
            background: #f5f5f5;
        }

        thead th {
            padding: 12px 10px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            letter-spacing: 0.5px;
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
            padding: 12px 10px;
            font-size: 13px;
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
            padding: 3px 10px;
            background: #e8f4fd;
            color: #1B4F8A;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        /* TOTALS */
        .totals-section {
            padding: 0 30px 30px;
        }

        .totals-table {
            margin-left: auto;
            width: 350px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 14px;
        }

        .total-row.subtotal {
            color: #666;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }

        .total-row.tax {
            color: #666;
        }

        .total-row.grand-total {
            border-top: 2px solid #1B4F8A;
            border-bottom: 2px solid #1B4F8A;
            padding: 15px 0;
            font-size: 18px;
            font-weight: bold;
            color: #1B4F8A;
        }

        .total-row.paid {
            color: #27ae60;
            font-weight: 600;
        }

        .total-row.balance {
            border-top: 2px solid #e74c3c;
            padding-top: 15px;
            font-size: 18px;
            font-weight: bold;
            color: #e74c3c;
        }

        .total-row.balance.paid-full {
            color: #27ae60;
        }

        /* PAYMENT HISTORY */
        .payment-section {
            padding: 0 30px 30px;
        }

        .payment-badge {
            display: inline-block;
            padding: 3px 10px;
            background: #e3f2fd;
            color: #1976d2;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        /* FOOTER */
        .invoice-footer {
            padding: 25px 30px;
            background: #f9f9f9;
            border-top: 2px solid #e0e0e0;
            text-align: center;
        }

        .footer-note {
            font-size: 12px;
            color: #666;
            margin-bottom: 10px;
        }

        .footer-legal {
            font-size: 10px;
            color: #999;
            font-style: italic;
        }

        /* STATUS BADGE */
        .status-badge {
            position: absolute;
            top: 80px;
            right: 30px;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
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

        /* PRINT BUTTON */
        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 30px;
            background: #1B4F8A;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s;
        }

        .print-button:hover {
            background: #163d6e;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }

        .print-button:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <!-- PRINT BUTTON -->
    <button onclick="window.print()" class="print-button no-print">🖨️ Print Invoice</button>

    <div class="invoice-container">
        
        <!-- HEADER -->
        <div class="invoice-header">
            <div class="company-info">
                <div class="company-name">OCEAN VIEW RESORT</div>
                <div class="company-details">
                    123 Beach Road, Negombo<br>
                    Western Province, Sri Lanka<br>
                    Tel: +94 31 222 3456 | Email: info@oceanviewresort.lk
                </div>
            </div>
            <div class="invoice-title">
                <h2>INVOICE</h2>
                <div class="invoice-number">#${bill.reservationNumber}</div>
            </div>
            <c:choose>
                <c:when test="${bill.status == 'Paid'}">
                    <div class="status-badge status-paid">✓ PAID</div>
                </c:when>
                <c:when test="${bill.status == 'Partial'}">
                    <div class="status-badge status-partial">⚠ PARTIAL</div>
                </c:when>
                <c:otherwise>
                    <div class="status-badge status-unpaid">● UNPAID</div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- INFO SECTION -->
        <div class="invoice-info">
            <div class="info-block">
                <h3>Bill To</h3>
                <p class="strong">${bill.guestName}</p>
                <p>${bill.guestEmail}</p>
                <p>${bill.guestPhone}</p>
                <c:if test="${not empty bill.guestAddress}">
                    <p style="margin-top: 8px;">${bill.guestAddress}</p>
                </c:if>
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
                            <th>Service Description</th>
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
                    <span>Tax (${bill.taxRate}% VAT):</span>
                    <span>LKR <fmt:formatNumber value="${bill.taxAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row grand-total">
                    <span>TOTAL AMOUNT:</span>
                    <span>LKR <fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row paid">
                    <span>Amount Paid:</span>
                    <span>LKR <fmt:formatNumber value="${bill.paidAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="total-row balance ${bill.balanceDue <= 0 ? 'paid-full' : ''}">
                    <span>BALANCE DUE:</span>
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
                            <th>Payment Method</th>
                            <th class="text-center">Type</th>
                            <th>Reference</th>
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
                                <td>${payment.referenceNumber != null ? payment.referenceNumber : '—'}</td>
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
                <strong>Thank you for choosing Ocean View Resort!</strong><br>
                We hope you enjoyed your stay with us.
            </p>
            <p class="footer-legal">
                This is a computer-generated invoice and does not require a signature.<br>
                For any queries, please contact us at +94 31 222 3456 or info@oceanviewresort.lk
            </p>
        </div>

    </div>

    <script>
        // Auto-print dialog on load (optional)
        // window.onload = function() { window.print(); }
    </script>

</body>
</html>