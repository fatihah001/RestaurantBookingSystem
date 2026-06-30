<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Book a Table</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Glassmorphic overlay for empty cart */
        .cart-alert-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(74, 44, 26, 0.45);
            backdrop-filter: blur(8px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        .cart-alert-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 35px 30px;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: scaleIn 0.3s ease-out;
        }
        @keyframes scaleIn {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .cart-alert-card i {
            font-size: 3rem;
            color: #e67e22;
            margin-bottom: 20px;
        }
        .cart-alert-card h3 {
            margin: 0 0 15px;
            color: #432818;
            font-family: Georgia, serif;
            font-size: 1.4rem;
        }
        .cart-alert-card p {
            color: #6f6255;
            font-size: 1rem;
            line-height: 1.5;
            margin-bottom: 25px;
        }
        .cart-alert-btn {
            display: inline-block;
            background: #5c3b2e;
            color: white;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: 0.2s;
            box-shadow: 0 4px 10px rgba(92, 59, 46, 0.3);
        }
        .cart-alert-btn:hover {
            background: #40261a;
            transform: translateY(-2px);
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
            <div class="step active"><div class="step-circle">3</div><div class="step-label">Table</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">4</div><div class="step-label">Checkout</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">5</div><div class="step-label">Done</div></div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error" style="max-width:600px;">${error}</div>
        </c:if>

        <p style="font-size:0.85rem;color:#8a7a6a;">Choose a table for your dine-in items. Each table will be reserved for 2 hours.</p>

        <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm">
        <div class="layout-2col">
            <div>
                <div class="legend-row">
                    <span><span class="legend-dot" style="background:var(--savora-cream-light);border:1px solid var(--savora-border);"></span>Available</span>
                    <span><span class="legend-dot" style="background:#f0ebe3;"></span>Reserved</span>
                    <span><span class="legend-dot" style="background:var(--savora-brown-dark);"></span>Selected</span>
                </div>

                <h4 style="margin-bottom:8px;">Indoor Dining Area</h4>
                <div class="table-layout-grid">
                    <c:forEach var="t" items="${indoorTables}">
                        <div class="table-box ${t.tableStatus != 'Available' ? 'occupied' : ''}"
                             data-table-id="${t.tableId}" data-status="${t.tableStatus}" onclick="selectTable(this, ${t.tableId})">
                            <div class="t-no">${t.tableNo}</div>
                            <div class="t-cap">${t.capacity} seats</div>
                            <c:if test="${t.tableStatus != 'Available'}"><div class="t-cap t-status">${t.tableStatus}</div></c:if>
                        </div>
                    </c:forEach>
                </div>

                <h4 style="margin:18px 0 8px;">Outdoor Dining Area</h4>
                <div class="table-layout-grid">
                    <c:forEach var="t" items="${outdoorTables}">
                        <div class="table-box ${t.tableStatus != 'Available' ? 'occupied' : ''}"
                             data-table-id="${t.tableId}" data-status="${t.tableStatus}" onclick="selectTable(this, ${t.tableId})">
                            <div class="t-no">${t.tableNo}</div>
                            <div class="t-cap">${t.capacity} seats</div>
                            <c:if test="${t.tableStatus != 'Available'}"><div class="t-cap t-status">${t.tableStatus}</div></c:if>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="card">
                <h3 style="margin-top:0;color:var(--savora-brown-dark);">Reservation Details</h3>
                <div class="form-group">
                    <label>Date *</label>
                    <input type="date" name="bookingDate" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Time Slot *</label>
                    <select name="bookingTime" id="bookingTime" class="form-control" required>
                        <option value="" disabled selected>-- Select a time slot --</option>
                        <option value="11:00">11:00 AM – 1:00 PM</option>
                        <option value="13:30">1:30 PM – 3:30 PM</option>
                        <option value="16:00">4:00 PM – 6:00 PM</option>
                        <option value="18:30">6:30 PM – 8:30 PM</option>
                        <option value="21:00">9:00 PM – 11:00 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Number of Guests</label>
                    <input type="number" name="numGuests" class="form-control" value="2" min="1" max="20">
                </div>
                <div class="form-group">
                    <label>Selected Table</label>
                    <input type="text" id="selectedTableLabel" class="form-control" value="Click a table on the layout to select" readonly>
                    <input type="hidden" name="tableId" id="tableIdInput">
                </div>
                <button type="submit" class="btn btn-primary btn-block">&rarr; Proceed to Checkout</button>
            </div>
        </div>
        </form>
    </div>
</div>

<script>
function selectTable(el, tableId) {
    var status = el.getAttribute('data-status') || 'Available';
    if (status !== 'Available') { return; }
    document.querySelectorAll('.table-box').forEach(function(box) {
        box.classList.remove('selected');
    });
    el.classList.add('selected');
    document.getElementById('tableIdInput').value = tableId;
    var tableNo = el.querySelector('.t-no').innerText;
    document.getElementById('selectedTableLabel').value = tableNo + ' selected';
}

document.addEventListener('DOMContentLoaded', function() {
    var dateInput = document.querySelector('input[name="bookingDate"]');
    var timeInput = document.getElementById('bookingTime');

    // Set min date to today's date
    var today = new Date().toISOString().split('T')[0];
    dateInput.min = today;
    dateInput.value = today;
    timeInput.value = "18:30";

    function checkAvailability() {
        var date = dateInput.value;
        var time = timeInput.value;
        if (!date || !time) return;

        var url = '${pageContext.request.contextPath}/booking/availability?date=' + encodeURIComponent(date) + '&time=' + encodeURIComponent(time);
        fetch(url)
            .then(response => response.json())
            .then(tables => {
                var selectedTableId = document.getElementById('tableIdInput').value;
                var selectedTableStillAvailable = true;

                tables.forEach(table => {
                    var box = document.querySelector('.table-box[data-table-id="' + table.tableId + '"]');
                    if (box) {
                        box.setAttribute('data-status', table.tableStatus);
                        
                        if (table.tableStatus !== 'Available') {
                            box.classList.add('occupied');
                            if (selectedTableId == table.tableId) {
                                box.classList.remove('selected');
                                selectedTableStillAvailable = false;
                            }
                            
                            var statusDiv = box.querySelector('.t-status');
                            if (!statusDiv) {
                                statusDiv = document.createElement('div');
                                statusDiv.className = 't-cap t-status';
                                box.appendChild(statusDiv);
                            }
                            statusDiv.innerText = table.tableStatus;
                        } else {
                            box.classList.remove('occupied');
                            var statusDiv = box.querySelector('.t-status');
                            if (statusDiv) {
                                statusDiv.remove();
                            }
                        }
                    }
                });

                if (!selectedTableStillAvailable) {
                    document.getElementById('tableIdInput').value = '';
                    document.getElementById('selectedTableLabel').value = 'Click a table on the layout to select';
                }
            })
            .catch(err => console.error('Error fetching table availability:', err));
    }

    checkAvailability();

    dateInput.addEventListener('change', checkAvailability);
    timeInput.addEventListener('change', checkAvailability);

    var form = document.getElementById('bookingForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            var tableId = document.getElementById('tableIdInput').value;
            if (!tableId) {
                alert('Please select a table on the layout before proceeding.');
                e.preventDefault();
            }
        });
    }
});

document.addEventListener('click', function(e) {
    var dropdown = document.getElementById('userDropdown');
    var trigger = document.querySelector('.user-info-text');
    if (dropdown && trigger && !trigger.contains(e.target)) {
        dropdown.classList.remove('open');
    }
});
</script>
<c:if test="${emptyCart}">
    <div class="cart-alert-overlay">
        <div class="cart-alert-card">
            <i class="fa-solid fa-cart-shopping"></i>
            <h3>Cart is Empty</h3>
            <p>Please add at least one food item to your cart before booking a table.</p>
            <a href="${pageContext.request.contextPath}/menu" class="cart-alert-btn">Go to Menu</a>
        </div>
    </div>
</c:if>
</body>
</html>
