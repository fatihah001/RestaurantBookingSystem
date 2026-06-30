<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Booking History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .tbl-responsive {
            width: 100%;
            overflow-x: auto;
        }
        .savora-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.88rem;
            text-align: left;
        }
        .savora-table th {
            border-bottom: 2px solid var(--savora-border);
            padding: 14px 10px;
            font-weight: 600;
            color: var(--savora-brown-dark);
        }
        .savora-table td {
            border-bottom: 1px solid var(--savora-border);
            padding: 14px 10px;
            color: var(--savora-text-dark);
        }
        .savora-table tr:hover {
            background-color: rgba(245, 237, 225, 0.4);
        }
        .badge-status {
            font-size: 0.72rem;
            padding: 3px 8px;
            border-radius: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-status.confirmed { background-color: #fbe8d3; color: #a8632f; }
        .badge-status.completed { background-color: #d9f2db; color: #2c6e2f; }
        .badge-status.cancelled { background-color: #fbdedd; color: #a23b38; }
        .badge-status.in.preparation { background-color: #e0f2fe; color: #0369a1; }
        .view-btn {
            background: none;
            border: 1px solid var(--savora-border);
            color: var(--savora-brown-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .view-btn:hover {
            background-color: var(--savora-cream);
            border-color: var(--savora-accent);
        }
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.45);
            align-items: center; justify-content: center;
            z-index: 100;
        }
        .modal-overlay.open { display: flex; }
        .modal-box {
            background: white; border-radius: 14px; padding: 28px;
            width: 380px; max-width: 90vw;
        }
        .modal-box h3 {
            margin: 0 0 16px;
            font-family: Georgia, serif;
            color: var(--savora-brown-dark);
            display: flex; align-items: center; gap: 8px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.88rem;
            padding: 9px 0;
            border-bottom: 1px solid var(--savora-border);
        }
        .detail-row:last-of-type { border-bottom: none; }
        .detail-row span:first-child { color: #8a7a6a; }
        .detail-row span:last-child { font-weight: 600; color: var(--savora-text-dark); }
    </style>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<%@ include file="/topbar.jsp" %>

<div class="app-shell">
    <%@ include file="/sidebar.jsp" %>

    <div class="main-content">
        <h1 class="text-3xl font-bold text-savora-dark mb-2">History</h1>
        <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
            View details of all your previous and active bookings.
        </p>

        <div class="card">
            <div class="tbl-responsive">
                <c:choose>
                    <c:when test="${empty bookings}">
                        <div style="text-align:center; padding:50px 10px; color:#8a7a6a;">
                            <i class="fa-solid fa-clock-rotate-left" style="font-size:2.5rem; margin-bottom:14px; opacity:0.6;"></i>
                            <p style="margin:0; font-size:0.95rem;">You have not made any bookings yet.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" style="margin-top:16px;">Book a Table Now</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="savora-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Table No</th>
                                    <th>Reserved Date</th>
                                    <th>Reserved Time</th>
                                    <th>No. of Guests</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                     <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <tr>
                                        <td>#${b.bookingId}</td>
                                        <td><strong>${b.tableNo}</strong></td>
                                        <td>${b.formattedBookingDate}</td>
                                        <td>${b.formattedBookingTime}</td>
                                        <td>${b.noOfPeople}</td>
                                         <td>
                                             <span class="badge-status ${b.status.toLowerCase()}">
                                                 ${b.status}
                                             </span>
                                         </td>
                                        <td style="font-size:0.8rem; color:#666;">
                                            ${b.formattedCreatedAt}
                                        </td>
                                         <td>
                                             <c:choose>
                                                 <c:when test="${not empty b.orderId}">
                                                     <a href="${pageContext.request.contextPath}/order/view?orderId=${b.orderId}" class="view-btn" style="text-decoration: none;">
                                                         <i class="fa-solid fa-file-invoice-dollar"></i> View Receipt
                                                     </a>
                                                 </c:when>
                                                 <c:otherwise>
                                                     <span class="text-gray-400 italic">No Order Placed</span>
                                                 </c:otherwise>
                                             </c:choose>
                                         </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <h1 class="text-3xl font-bold text-savora-dark mb-2 mt-6">Takeaway Orders</h1>
        <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
            Orders placed for pickup without a table reservation.
        </p>

        <div class="card">
            <div class="tbl-responsive">
                <c:choose>
                    <c:when test="${empty takeawayOrders}">
                        <div style="text-align:center; padding:50px 10px; color:#8a7a6a;">
                            <i class="fa-solid fa-bag-shopping" style="font-size:2.5rem; margin-bottom:14px; opacity:0.6;"></i>
                            <p style="margin:0; font-size:0.95rem;">You have not placed any takeaway orders yet.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" style="margin-top:16px;">Order Takeaway</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="savora-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date & Time</th>
                                    <th>Payment Method</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${takeawayOrders}">
                                    <tr>
                                        <td>#${o.orderId}</td>
                                        <td>${o.formattedOrderDate}</td>
                                        <td>${o.paymentMethod}</td>
                                        <td>RM <fmt:formatNumber value="${o.totalAmount}" minFractionDigits="2" /></td>
                                        <td>
                                            <span class="badge-status ${o.orderStatus.toLowerCase()}">
                                                ${o.orderStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/order/view?orderId=${o.orderId}" class="view-btn" style="text-decoration: none;">
                                                <i class="fa-solid fa-file-invoice-dollar"></i> View Receipt
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // Topbar dropdown close click listener
    document.addEventListener('click', function(e) {
        var dropdown = document.getElementById('userDropdown');
        var trigger = document.querySelector('.user-info-text');
        if (dropdown && trigger && !trigger.contains(e.target)) {
            dropdown.classList.remove('open');
        }
    });
</script>
</body>
</html>
