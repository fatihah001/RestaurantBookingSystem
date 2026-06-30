<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Savora - Track Order Status</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <style>
                    .track-container {
                        max-width: 800px;
                        margin: 0 auto;
                    }

                    /* Stepper Style */
                    .stepper {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        position: relative;
                        margin: 40px 0;
                        padding: 0 10px;
                    }

                    .stepper::before {
                        content: '';
                        position: absolute;
                        top: 25px;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background-color: var(--savora-border);
                        z-index: 1;
                    }

                    .stepper-progress {
                        position: absolute;
                        top: 25px;
                        left: 0;
                        height: 4px;
                        background-color: var(--savora-accent);
                        z-index: 2;
                        transition: width 0.6s ease;
                        width: 0%;
                    }

                    .step {
                        position: relative;
                        z-index: 3;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        text-align: center;
                        flex: 1;
                    }

                    .step-icon {
                        width: 54px;
                        height: 54px;
                        border-radius: 50%;
                        background-color: white;
                        border: 3px solid var(--savora-border);
                        color: #8a7a6a;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.25rem;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                        transition: all 0.4s ease;
                    }

                    .step.completed .step-icon {
                        background-color: var(--savora-accent);
                        border-color: var(--savora-accent);
                        color: white;
                    }

                    .step.active .step-icon {
                        background-color: var(--savora-brown-dark);
                        border-color: var(--savora-accent);
                        color: var(--savora-accent);
                        animation: pulse-border 1.8s infinite;
                    }

                    .step-label {
                        margin-top: 12px;
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: #8a7a6a;
                        transition: color 0.4s ease;
                    }

                    .step.completed .step-label,
                    .step.active .step-label {
                        color: var(--savora-brown-dark);
                        font-weight: 700;
                    }

                    @keyframes pulse-border {
                        0% {
                            box-shadow: 0 0 0 0 rgba(193, 122, 74, 0.4);
                        }

                        70% {
                            box-shadow: 0 0 0 10px rgba(193, 122, 74, 0);
                        }

                        100% {
                            box-shadow: 0 0 0 0 rgba(193, 122, 74, 0);
                        }
                    }

                    .select-style {
                        padding: 10px 16px;
                        border-radius: 8px;
                        border: 1px solid var(--savora-border);
                        font-family: inherit;
                        font-size: 0.9rem;
                        color: var(--savora-brown-dark);
                        background-color: white;
                        cursor: pointer;
                        outline: none;
                        width: 100%;
                        max-width: 450px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
                        transition: border-color 0.2s;
                    }

                    .select-style:focus {
                        border-color: var(--savora-accent);
                    }

                    .order-card {
                        background-color: white;
                        border-radius: 12px;
                        padding: 24px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
                        border: 1px solid var(--savora-border);
                    }

                    .receipt-list {
                        background-color: var(--savora-cream-light);
                        border-radius: 8px;
                        padding: 16px;
                        margin-top: 16px;
                    }

                    .receipt-row {
                        display: flex;
                        justify-content: space-between;
                        font-size: 0.88rem;
                        padding: 8px 0;
                        border-bottom: 1px dashed var(--savora-border);
                    }

                    .receipt-row:last-child {
                        border-bottom: none;
                        font-weight: 700;
                        font-size: 0.95rem;
                        color: var(--savora-brown-dark);
                        padding-top: 12px;
                    }

                    .pulse-text {
                        animation: pulse-opacity 1.5s infinite;
                    }

                    @keyframes pulse-opacity {
                        0% {
                            opacity: 0.6;
                        }

                        50% {
                            opacity: 1;
                        }

                        100% {
                            opacity: 0.6;
                        }
                    }
                </style>
                <script src="https://cdn.tailwindcss.com"></script>
</head>

            <body>
                <%@ include file="/topbar.jsp" %>

                    <div class="app-shell">
                        <%@ include file="/sidebar.jsp" %>

                            <div class="main-content">
                                <div class="track-container">
                                    <h1 class="text-3xl font-bold text-savora-dark mb-2">Track Order Status</h1>
                                    <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
                                        Select your reservation to monitor the preparation status of your culinary
                                        request in real-time.
                                    </p>

                                    <c:choose>
                                        <c:when test="${empty bookings && empty takeawayOrders}">
                                            <!-- No Reservations At All -->
                                            <div class="card"
                                                style="text-align:center; padding:48px 20px; color:#8a7a6a;">
                                                <i class="fa-solid fa-calendar-xmark"
                                                    style="font-size:3rem; color:var(--savora-accent); margin-bottom:18px;"></i>
                                                <h3
                                                    style="font-family: Georgia, serif; color: var(--savora-brown-dark); margin-top:0;">
                                                    No Active Reservations</h3>
                                                <p style="font-size:0.92rem; max-width:400px; margin:0 auto 20px;">You
                                                    must have a table reservation or a takeaway order to track food orders.</p>
                                                <a href="${pageContext.request.contextPath}/booking"
                                                    class="btn btn-primary">Book a Table Now</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Booking / Takeaway Selection -->
                                            <div class="card" style="margin-bottom:24px; padding:20px;">
                                                <form action="${pageContext.request.contextPath}/order/track"
                                                    method="get">
                                                    <div style="display:flex; flex-direction:column; gap:8px;">
                                                        <label for="trackId"
                                                            style="font-weight:600; color:var(--savora-brown-dark); font-size:0.9rem;">Select
                                                            Reservation or Takeaway Order:</label>
                                                        <select id="trackId" name="trackId"
                                                            onchange="this.form.submit()" class="select-style">
                                                            <c:forEach var="b" items="${bookings}">
                                                                <option value="B${b.bookingId}"
                                                                    ${not empty selectedBooking && b.bookingId==selectedBooking.bookingId
                                                                    ? 'selected' : '' }>
                                                                    Reservation #${b.bookingId} &middot;
                                                                    ${b.tableNo} (${b.bookingDate}  ${b.bookingTime})
                                                                </option>
                                                            </c:forEach>
                                                            <c:forEach var="o" items="${takeawayOrders}">
                                                                <option value="O${o.orderId}"
                                                                    ${not empty selectedTakeawayOrder && o.orderId==selectedTakeawayOrder.orderId
                                                                    ? 'selected' : '' }>
                                                                    Takeaway Order #${o.orderId} &middot;
                                                                    ${o.formattedOrderDate}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Order Details Panel -->
                                            <c:choose>
                                                <c:when test="${not empty selectedOrder}">
                                                    <!-- Linked Order Found -->
                                                    <div class="order-card">
                                                        <div
                                                            style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--savora-border); padding-bottom:14px; margin-bottom:20px;">
                                                            <div>
                                                                <span
                                                                    style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px; color:#8a7a6a; font-weight:700;">Order
                                                                    Confirmation</span>
                                                                <h3
                                                                    style="margin:2px 0 0; font-family: Georgia, serif; color: var(--savora-brown-dark);">
                                                                    Order #${selectedOrder.orderId}</h3>
                                                                <c:if test="${not empty selectedBooking}">
                                                                    <span style="font-size:0.85rem; color:#8a7a6a;">
                                                                        Reservation #${selectedBooking.bookingId}
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                            <div style="text-align:right;">
                                                                <span
                                                                    style="font-size:0.75rem; color:#8a7a6a; display:block;">Dining
                                                                    Type</span>
                                                                <span
                                                                    style="font-weight:700; color:var(--savora-accent);">
                                                                    <c:choose>
                                                                        <c:when test="${not empty selectedOrder.tableNo}">${selectedOrder.tableNo}</c:when>
                                                                        <c:otherwise><i class="fa-solid fa-bag-shopping"></i> Takeaway</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                        </div>

                                                        <!-- Progress Stepper -->
                                                        <div class="stepper" id="visualStepper">
                                                            <div class="stepper-progress" id="stepperProgress"
                                                                style="width: 0%;"></div>

                                                            <!-- Step 1: Confirmed -->
                                                            <div class="step" id="step-Confirmed">
                                                                <div class="step-icon"><i
                                                                        class="fa-solid fa-clipboard-check"></i></div>
                                                                <div class="step-label">Confirmed</div>
                                                            </div>

                                                            <!-- Step 2: In Preparation -->
                                                            <div class="step" id="step-InPrep">
                                                                <div class="step-icon"><i
                                                                        class="fa-solid fa-fire-burner"></i></div>
                                                                <div class="step-label">Preparing</div>
                                                            </div>

                                                            <!-- Step 3: Served / Ready -->
                                                            <div class="step" id="step-Completed">
                                                                <div class="step-icon">
                                                                    <c:choose>
                                                                        <c:when test="${empty selectedOrder.bookingId}">
                                                                            <i class="fa-solid fa-bag-shopping"></i>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="fa-solid fa-utensils"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="step-label">
                                                                    <c:choose>
                                                                        <c:when test="${empty selectedOrder.bookingId}">
                                                                            Ready for Pickup
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Served
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div id="liveAlert" class="pulse-text"
                                                            style="text-align:center; font-size:0.85rem; font-weight:600; color:var(--savora-accent); margin-bottom:24px;">
                                                            <i class="fa-solid fa-spinner fa-spin"></i> Live status
                                                            monitoring active...
                                                        </div>

                                                        <!-- Items ordered -->
                                                        <h4
                                                            style="font-family: Georgia, serif; margin: 24px 0 10px; color: var(--savora-brown-dark);">
                                                            Ordered Items</h4>
                                                        <div class="receipt-list">
                                                            <c:forEach var="item" items="${selectedOrder.items}">
                                                                <div class="receipt-row">
                                                                    <span><strong>${item.itemName}</strong> &times;
                                                                        ${item.quantity}</span>
                                                                    <span>RM
                                                                        <fmt:formatNumber value="${item.subtotal}"
                                                                            minFractionDigits="2" />
                                                                    </span>
                                                                </div>
                                                            </c:forEach>
                                                            <div class="receipt-row">
                                                                <span>Total Amount Paid</span>
                                                                <span>RM
                                                                    <fmt:formatNumber
                                                                        value="${selectedOrder.totalAmount}"
                                                                        minFractionDigits="2" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- No Order Linked to this Reservation -->
                                                    <div class="card"
                                                        style="text-align:center; padding:40px 20px; color:#8a7a6a;">
                                                        <i class="fa-solid fa-bowl-food"
                                                            style="font-size:2.8rem; color:#dcd3c9; margin-bottom:16px;"></i>
                                                        <h3
                                                            style="font-family: Georgia, serif; color: var(--savora-brown-dark); margin-top:0;">
                                                            No Food Ordered Yet</h3>
                                                        <p
                                                            style="font-size:0.9rem; max-width:420px; margin:0 auto 20px;">
                                                            You haven't ordered any meals or beverages for Reservation
                                                            #${selectedBooking.bookingId} (Table
                                                            ${selectedBooking.tableNo}) yet.</p>
                                                        <div style="display:flex; justify-content:center; gap:12px;">
                                                            <a href="${pageContext.request.contextPath}/menu"
                                                                class="btn btn-primary">Browse Menu & Order</a>
                                                            <a href="${pageContext.request.contextPath}/dashboard"
                                                                class="btn btn-outline">Go to Dashboard</a>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                    </div>

                    <script>
                        <c:if test="${not empty selectedOrder}">
                            var orderId = ${selectedOrder.orderId};
                            var currentStatus = '${selectedOrder.orderStatus}';
                            var isTakeaway = ${empty selectedOrder.bookingId};

                            function updateVisualStepper(status) {
        var progress = document.getElementById("stepperProgress");
                            var stepConfirmed = document.getElementById("step-Confirmed");
                            var stepInPrep = document.getElementById("step-InPrep");
                            var stepCompleted = document.getElementById("step-Completed");
                            var liveAlert = document.getElementById("liveAlert");

                            // Clear classes
                            [stepConfirmed, stepInPrep, stepCompleted].forEach(function(s) {
                                s.classList.remove("completed", "active");
        });

                            if (status === 'Confirmed') {
                                stepConfirmed.classList.add("active");
                            progress.style.width = "0%";
                            liveAlert.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Kitchen has confirmed your order. Waiting to start preparation...';
        } else if (status === 'In Preparation') {
                                stepConfirmed.classList.add("completed");
                            stepInPrep.classList.add("active");
                            progress.style.width = "50%";
                            liveAlert.innerHTML = '<i class="fa-solid fa-fire-burner fa-spin"></i> Culinary chefs are actively preparing your food items...';
        } else if (status === 'Completed') {
                                stepConfirmed.classList.add("completed");
                            stepInPrep.classList.add("completed");
                            stepCompleted.classList.add("completed");
                            progress.style.width = "100%";
                            if (isTakeaway) {
                                liveAlert.innerHTML = '<i class="fa-solid fa-check-circle" style="color:var(--savora-success);"></i> Your takeaway order is ready for pickup! Please collect it at the counter.';
                            } else {
                                liveAlert.innerHTML = '<i class="fa-solid fa-check-circle" style="color:var(--savora-success);"></i> Your food has been freshly served! Enjoy your meal.';
                            }
                            liveAlert.classList.remove("pulse-text");
        } else if (status === 'Cancelled') {
                                stepConfirmed.classList.add("completed");
                            liveAlert.innerHTML = '<i class="fa-solid fa-ban" style="color:var(--savora-danger);"></i> Order was cancelled.';
                            liveAlert.classList.remove("pulse-text");
        }
    }

                            function pollOrderStatus() {
                                fetch('${pageContext.request.contextPath}/order/view?orderId=' + orderId + '&ajax=true')
                                    .then(function (response) { return response.json(); })
                                    .then(function (data) {
                                        if (data.orderStatus && data.orderStatus !== currentStatus) {
                                            currentStatus = data.orderStatus;
                                            updateVisualStepper(currentStatus);
                                        }
                                    })
                                    .catch(function (err) { console.error("Error polling order status:", err); });
    }

                            // Initialize visual state on load
                            updateVisualStepper(currentStatus);

                            // Set polling interval only if order is not completed/cancelled
                            if (currentStatus !== 'Completed' && currentStatus !== 'Cancelled') {
                                setInterval(pollOrderStatus, 8000); // Poll status every 8 seconds
    }
                        </c:if>

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