<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Order Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .confirmation-card {
            background-color: white;
            border-radius: 12px;
            padding: 32px;
            max-width: 650px;
            margin: 0 auto;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .success-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background-color: #d9f2db;
            color: var(--savora-success);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto 16px;
        }
        .receipt-box {
            background-color: var(--savora-cream-light);
            border: 1px dashed var(--savora-border);
            border-radius: 10px;
            padding: 20px;
            margin: 24px 0;
            text-align: left;
        }
        .receipt-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            margin-bottom: 8px;
            color: var(--savora-text-dark);
        }
        .receipt-row.header {
            font-weight: 700;
            color: var(--savora-brown-dark);
            border-bottom: 1px solid var(--savora-border);
            padding-bottom: 6px;
            margin-bottom: 12px;
        }
        .receipt-row.total {
            font-size: 1rem;
            font-weight: 700;
            color: var(--savora-brown-dark);
            border-top: 1px solid var(--savora-border);
            padding-top: 10px;
            margin-top: 12px;
        }
    </style>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<%@ include file="/topbar.jsp" %>

<div class="app-shell">
    <%@ include file="/sidebar.jsp" %>

    <div class="main-content">
        <div class="step-indicator">
            <div class="step complete"><div class="step-circle"><i class="fa-solid fa-check"></i></div><div class="step-label">Menu</div></div>
            <div class="step-line"></div>
            <div class="step complete"><div class="step-circle"><i class="fa-solid fa-check"></i></div><div class="step-label">Cart</div></div>
            <div class="step-line"></div>
            <div class="step complete"><div class="step-circle"><i class="fa-solid fa-check"></i></div><div class="step-label">Table</div></div>
            <div class="step-line"></div>
            <div class="step complete"><div class="step-circle"><i class="fa-solid fa-check"></i></div><div class="step-label">Checkout</div></div>
            <div class="step-line"></div>
            <div class="step active"><div class="step-circle"><i class="fa-solid fa-check"></i></div><div class="step-label">Done</div></div>
        </div>

        <div class="confirmation-card">
            <div class="success-icon">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            
            <h2 style="margin:0 0 6px; font-family: Georgia, serif; color: var(--savora-brown-dark);">
                Order Placed Successfully!
            </h2>
            <p style="color:#8a7a6a; margin:0; font-size:0.9rem;">
                Thank you for choosing Savora. Your order has been registered and confirmed.
            </p>
            
            <div class="receipt-box">
                <div class="receipt-row header">
                    <span>Order Details</span>
                    <span>Order #${order.orderId}</span>
                </div>
                
                <div class="receipt-row">
                    <span>Date & Time</span>
                    <span style="font-weight:600;">
                        ${order.formattedOrderDate}
                    </span>
                </div>
                
                <c:if test="${not empty order.bookingId}">
                    <div class="receipt-row">
                        <span>Table Reservation</span>
                        <span style="font-weight:600; color:var(--savora-accent);">Linked (Booking #${order.bookingId})</span>
                    </div>
                </c:if>
                
                <div class="receipt-row">
                    <span>Payment Method</span>
                    <span style="font-weight:600;">${order.paymentMethod}</span>
                </div>

                <div class="receipt-row">
                    <span>Order Status</span>
                    <span style="font-weight:600; color:var(--savora-success);">${order.orderStatus}</span>
                </div>

                <hr style="border-top:1px solid var(--savora-border); border-bottom:none; margin:14px 0;">

                <div style="font-size:0.8rem; font-weight:700; color:#8a7a6a; margin-bottom:8px; text-transform:uppercase; letter-spacing:0.5px;">Items Ordered</div>
                <c:forEach var="item" items="${order.items}">
                    <div class="receipt-row" style="margin-left: 4px;">
                        <span style="color:#555;">${item.itemName} &times; ${item.quantity} (${item.diningType})</span>
                        <span>RM<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/></span>
                    </div>
                </c:forEach>

                <div class="receipt-row total">
                    <span>Total Amount Paid</span>
                    <span>RM<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></span>
                </div>
            </div>

            <div style="display:flex; justify-content:center; gap:12px; margin-top:20px;">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Go to Dashboard</a>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline">Back to Menu</a>
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
