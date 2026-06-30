<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Checkout</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .payment-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px;
            border: 1px solid var(--savora-border);
            border-radius: 10px;
            margin-bottom: 10px;
            cursor: pointer;
        }
        .payment-option.selected {
            border-color: var(--savora-accent);
            background-color: #fbf3eb;
        }
        .payment-option i { font-size: 1.1rem; color: var(--savora-brown-dark); width: 22px; }
        .payment-option .p-name { font-weight: 600; font-size: 0.88rem; }
        .payment-option .p-meta { font-size: 0.72rem; color: #8a7a6a; }
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
            width: 360px; text-align: center;
        }
        .modal-box.warning-box {
            animation: popIn 0.2s ease;
        }
        @keyframes popIn {
            from { transform: scale(0.85); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
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
            <div class="step active"><div class="step-circle">4</div><div class="step-label">Checkout</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">5</div><div class="step-label">Done</div></div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error" style="max-width:700px;">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="layout-2col">
            <div>
                <div class="card" style="margin-bottom:18px;">
                    <h3 style="margin-top:0;color:var(--savora-brown-dark);">Contact Information</h3>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" class="form-control" value="${user.name}" readonly>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="text" class="form-control" value="${user.email}" readonly>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text"
                               name="phoneNumber"
                               class="form-control"
                               value="${user.phoneNumber}">
                    </div>
                </div>

                <c:if test="${not hasTableSelected}">
                    <div class="card" style="margin-bottom:18px;">
                        <h3 style="margin-top:0;color:var(--savora-brown-dark);">Takeaway Details</h3>
                        <div class="form-group">
                            <label>Pickup Date *</label>
                            <input type="date" name="takeawayDate" id="takeawayDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Pickup Time *</label>
                            <select name="takeawayTime" id="takeawayTime" class="form-control" required>
                                <option value="" disabled selected>-- Select a pickup time --</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="11:30">11:30 AM</option>
                                <option value="12:00">12:00 PM</option>
                                <option value="12:30">12:30 PM</option>
                                <option value="13:00">1:00 PM</option>
                                <option value="13:30">1:30 PM</option>
                                <option value="14:00">2:00 PM</option>
                                <option value="14:30">2:30 PM</option>
                                <option value="15:00">3:00 PM</option>
                                <option value="15:30">3:30 PM</option>
                                <option value="16:00">4:00 PM</option>
                                <option value="16:30">4:30 PM</option>
                                <option value="17:00">5:00 PM</option>
                                <option value="17:30">5:30 PM</option>
                                <option value="18:00">6:00 PM</option>
                                <option value="18:30">6:30 PM</option>
                                <option value="19:00">7:00 PM</option>
                                <option value="19:30">7:30 PM</option>
                                <option value="20:00">8:00 PM</option>
                                <option value="20:30">8:30 PM</option>
                                <option value="21:00">9:00 PM</option>
                                <option value="21:30">9:30 PM</option>
                                <option value="22:00">10:00 PM</option>
                            </select>
                        </div>
                    </div>
                </c:if>

                <div class="card">
                    <h3 style="margin-top:0;color:var(--savora-brown-dark);">Payment Method</h3>

                    <label class="payment-option" onclick="selectPayment(this,'Wallet')">
                        <i class="fa-solid fa-wallet"></i>
                        <div>
                            <div class="p-name">Wallet</div>
                            <div class="p-meta">Balance: RM<fmt:formatNumber value="${wallet.balance}" minFractionDigits="2"/></div>
                        </div>
                    </label>
                    <label class="payment-option" onclick="selectPayment(this,'Online Banking')">
                        <i class="fa-solid fa-building-columns"></i>
                        <div>
                            <div class="p-name">Online Banking</div>
                            <div class="p-meta">Pay via FPX / internet banking</div>
                        </div>
                    </label>
                    <label class="payment-option" onclick="selectPayment(this,'Debit Card')">
                        <i class="fa-solid fa-credit-card"></i>
                        <div>
                            <div class="p-name">Debit Card</div>
                            <div class="p-meta">Visa / Mastercard accepted</div>
                        </div>
                    </label>
                    <label class="payment-option" onclick="selectPayment(this,'Cash on Arrival')">
                        <i class="fa-solid fa-money-bill-wave"></i>
                        <div>
                            <div class="p-name">Cash on Arrival</div>
                            <div class="p-meta">Pay when you arrive at the restaurant</div>
                        </div>
                    </label>

                    <input type="hidden" name="paymentMethod" id="paymentMethodInput" required>
                </div>
            </div>

            <div class="card">
                <h3 style="margin-top:0;color:var(--savora-brown-dark);">Order Summary</h3>
                <c:forEach var="item" items="${cartItems}">
                    <div class="summary-row">
                        <span>${item.itemName}<c:if test="${not empty item.temperature}"> (${item.temperature})</c:if> &times;${item.quantity}</span>
                        <span>RM<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/></span>
                    </div>
                </c:forEach>
                <hr style="border-color:var(--savora-border);">
                <div class="summary-row"><span>Subtotal</span><span>RM<fmt:formatNumber value="${subtotal}" minFractionDigits="2"/></span></div>
                <div class="summary-row"><span>Tax (8%)</span><span>RM<fmt:formatNumber value="${tax}" minFractionDigits="2"/></span></div>
                <div class="summary-row total"><span>Total</span><span>RM<fmt:formatNumber value="${total}" minFractionDigits="2"/></span></div>

                <button type="submit" id="placeOrderBtn" class="btn btn-primary btn-block" style="margin-top:14px;" onclick="return handleSubmit(event)">
                    Place Order <i class="fa-solid fa-check"></i>
                </button>
            </div>
        </div>
        </form>
    </div>
</div>

<div class="modal-overlay" id="cashModal">
    <div class="modal-box">
        <i class="fa-solid fa-money-bill-wave" style="font-size:2rem;color:var(--savora-accent);margin-bottom:10px;"></i>
        <h3 style="margin:0 0 8px;">Confirm Cash on Arrival</h3>
        <p style="font-size:0.85rem;color:#8a7a6a;">You'll pay RM<fmt:formatNumber value="${total}" minFractionDigits="2"/> in cash when you arrive at the restaurant. Continue?</p>
        <div style="display:flex; gap:10px; margin-top:16px;">
            <button type="button" class="btn btn-outline btn-block" onclick="document.getElementById('cashModal').classList.remove('open')">Cancel</button>
            <button type="button" class="btn btn-primary btn-block" onclick="document.getElementById('checkoutForm').submit()">Confirm</button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="paymentWarningModal">
    <div class="modal-box warning-box">
        <i class="fa-solid fa-triangle-exclamation" style="font-size:2rem;color:#e67e22;margin-bottom:10px;"></i>
        <h3 style="margin:0 0 8px;color:var(--savora-brown-dark);">Payment Method Required</h3>
        <p style="font-size:0.85rem;color:#8a7a6a;margin:0 0 16px;">Please select a payment method before placing your order.</p>
        <button type="button" class="btn btn-primary btn-block" onclick="document.getElementById('paymentWarningModal').classList.remove('open')">OK</button>
    </div>
</div>

<script>
function selectPayment(el, method) {
    document.querySelectorAll('.payment-option').forEach(function(o) { o.classList.remove('selected'); });
    el.classList.add('selected');
    document.getElementById('paymentMethodInput').value = method;
}

function handleSubmit(e) {
    var method = document.getElementById('paymentMethodInput').value;
    if (!method) {
        e.preventDefault();
        document.getElementById('paymentWarningModal').classList.add('open');
        return false;
    }
    if (method === 'Cash on Arrival') {
        e.preventDefault();
        document.getElementById('cashModal').classList.add('open');
        return false;
    }
    return true;
}

document.addEventListener('DOMContentLoaded', function() {
    var takeawayDateInput = document.getElementById('takeawayDate');
    if (takeawayDateInput) {
        var today = new Date().toISOString().split('T')[0];
        takeawayDateInput.min = today;
        takeawayDateInput.value = today;
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
</body>
</html>
