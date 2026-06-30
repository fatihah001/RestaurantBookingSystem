<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Savora - View Order</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <style>
                    .view-card {
                        background-color: white;
                        border-radius: 12px;
                        padding: 32px;
                        max-width: 650px;
                        margin: 0 auto;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    }

                    .receipt-box {
                        background-color: var(--savora-cream-light);
                        border: 1px dashed var(--savora-border);
                        border-radius: 10px;
                        padding: 20px;
                        margin: 20px 0;
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
                </style>
                <script src="https://cdn.tailwindcss.com"></script>
</head>

            <body>
                <%@ include file="/topbar.jsp" %>

                    <div class="app-shell">
                        <%@ include file="/sidebar.jsp" %>

                            <div class="main-content">
                                <h1 class="text-3xl font-bold text-savora-dark mb-2">
                                    Order Details</h1>
                                <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
                                    Detailed receipt and status of order #${order.orderId}.
                                </p>

                                <div class="view-card">
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
                                                <span style="font-weight:600; color:var(--savora-accent);">Linked
                                                    (Booking #${order.bookingId})</span>
                                            </div>
                                        </c:if>

                                        <div class="receipt-row">
                                            <span>Payment Method</span>
                                            <span style="font-weight:600;">${order.paymentMethod}</span>
                                        </div>

                                        

                                        <hr
                                            style="border-top:1px solid var(--savora-border); border-bottom:none; margin:14px 0;">

                                        <div
                                            style="font-size:0.8rem; font-weight:700; color:#8a7a6a; margin-bottom:8px; text-transform:uppercase; letter-spacing:0.5px;">
                                            Items Ordered</div>
                                        <c:forEach var="item" items="${order.items}">
                                            <div class="receipt-row" style="margin-left: 4px;">
                                                <span style="color:#555;">${item.itemName} &times; ${item.quantity}
                                                    (${item.diningType})</span>
                                                <span>RM
                                                    <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" />
                                                </span>
                                            </div>
                                        </c:forEach>

                                        <div class="receipt-row total">
                                            <span>Total Amount Paid</span>
                                            <span>RM
                                                <fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" />
                                            </span>
                                        </div>
                                    </div>

                                    <div style="display:flex; justify-content:center; gap:12px; margin-top:20px;">
                                        <a href="${pageContext.request.contextPath}/dashboard"
                                            class="btn btn-primary">Go to Dashboard</a>
                                        <a href="${pageContext.request.contextPath}/history"
                                            class="btn btn-outline">Booking History</a>
                                    </div>
                                </div>
                            </div>
                    </div>

                    <script>
                        // Topbar dropdown close click listener
                        document.addEventListener('click', function (e) {
                            var dropdown = document.getElementById('userDropdown');
                            var trigger = document.querySelector('.user-info-text');
                            if (dropdown && trigger && !trigger.contains(e.target)) {
                                dropdown.classList.remove('open');
                            }
                        });
                    </script>
            </body>

            </html>