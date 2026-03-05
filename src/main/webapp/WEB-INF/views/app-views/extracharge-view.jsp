<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Charge Details — Ocean View Resort</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 30px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
.page-header h1 { font-size: 24px; color: #1B4F8A; }
.btn-back { color: #1B4F8A; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 4px; }
.btn-back:hover { text-decoration: underline; }
.profile-header { background: linear-gradient(135deg, #e67e22 0%, #d35400 100%); border-radius: 8px 8px 0 0; padding: 30px; color: white; }
.profile-header h2 { font-size: 32px; margin-bottom: 8px; }
.profile-header p { font-size: 15px; opacity: 0.9; }
.card { background: #fff; border-radius: 0 0 8px 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); padding: 30px; margin-bottom: 20px; }
.section-title { font-size: 14px; font-weight: bold; color: #1B4F8A; border-bottom: 2px solid #e8f0fb; padding-bottom: 8px; margin-bottom: 20px; margin-top: 28px; }
.section-title:first-of-type { margin-top: 0; }
.detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.detail-item label { font-size: 12px; color: #888; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 4px; }
.detail-item span { font-size: 15px; color: #333; }
.detail-item.full { grid-column: 1 / -1; }
.action-bar { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 24px; }
.btn-danger { background-color: #c0392b; color: white; padding: 10px 22px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; }
.btn-secondary { background-color: #fff; color: #555; border: 1px solid #ccc; padding: 10px 22px; border-radius: 4px; font-size: 14px; cursor: pointer; text-decoration: none; }
.btn-danger:hover { background-color: #a93226; }
.btn-secondary:hover { background-color: #f4f4f4; }
</style>
</head>
<body>

 <%-- Protect page — if not logged in, redirect to login --%>
    <c:if test="${empty sessionScope.loggedInStaff}">
        <c:redirect url="/login?status=sessionExpired"/>
    </c:if>

<div class="page-header">
<div>
<a href="${pageContext.request.contextPath}/reservation?action=view&id=${charge.reservationId}" class="btn-back">← Back to Reservation</a>
<h1 style="margin-top:8px;">Charge Details</h1>
</div>
</div>

<div class="profile-header">
<h2>📋 ${charge.category} Charge</h2>
<p>Amount: $<fmt:formatNumber value="${charge.amount}" pattern="#,##0.00"/></p>
<p style="margin-top:4px;">Reservation: ${charge.reservationNumber}</p>
</div>

<div class="card">
<div class="section-title">Charge Information</div>
<div class="detail-grid">
<div class="detail-item"><label>Charge ID</label><span>#${charge.id}</span></div>
<div class="detail-item"><label>Date</label><span>${charge.chargeDate}</span></div>
<div class="detail-item"><label>Category</label><span>${charge.category}</span></div>
<div class="detail-item"><label>Amount</label><span>$<fmt:formatNumber value="${charge.amount}" pattern="#,##0.00"/></span></div>
<div class="detail-item full"><label>Description</label><span>${charge.description}</span></div>
</div>

<div class="section-title">Record Details</div>
<div class="detail-grid">
<div class="detail-item"><label>Added By (Staff)</label><span>${not empty charge.addedByName ? charge.addedByName : '—'}</span></div>
</div>

<div class="action-bar">
<button class="btn-danger" onclick="confirmDelete(${charge.id}, '${charge.reservationNumber}', ${charge.reservationId})">🗑️ Remove Charge</button>
<a href="${pageContext.request.contextPath}/reservation?action=view&id=${charge.reservationId}" class="btn-secondary">Return to Reservation</a>
</div>
</div>

<script>
function confirmDelete(id, resNum, resId) {
if (confirm('Remove this charge from reservation ' + resNum + '?\n\nThis cannot be undone.')) {
window.location = '${pageContext.request.contextPath}/extraCharge?action=delete&id=' + id + '&reservationId=' + resId;
}
}
</script>
</body>
</html>