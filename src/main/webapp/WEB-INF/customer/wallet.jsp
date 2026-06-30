<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - My Wallet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .wallet-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .wallet-layout {
                grid-template-columns: 1fr;
            }
        }
        .balance-card {
            background: linear-gradient(135deg, var(--savora-brown-dark) 0%, var(--savora-brown) 100%);
            color: var(--savora-text-light);
            border-radius: 14px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .balance-card::after {
            content: '';
            position: absolute;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.03);
            border-radius: 50%;
            top: -50px; right: -50px;
        }
        .balance-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            opacity: 0.85;
            display: block;
        }
        .balance-val {
            font-size: 2.4rem;
            font-weight: 700;
            display: block;
            margin: 10px 0;
            font-family: Georgia, serif;
            color: var(--savora-accent);
        }
        .topup-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            border: 1px solid var(--savora-border);
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            background: var(--savora-cream-light);
            transition: all 0.2s ease;
        }
        .topup-option.selected {
            border-color: var(--savora-accent);
            background-color: #fbf3eb;
        }
        .topup-option i { font-size: 1rem; color: var(--savora-brown-dark); width: 20px; }
        .topup-option span { font-size: 0.85rem; font-weight: 600; }

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
            padding: 12px 10px;
            font-weight: 600;
            color: var(--savora-brown-dark);
        }
        .savora-table td {
            border-bottom: 1px solid var(--savora-border);
            padding: 12px 10px;
            color: var(--savora-text-dark);
        }
        .savora-table tr:hover {
            background-color: rgba(245, 237, 225, 0.4);
        }
        .tx-amount {
            font-weight: 700;
            font-size: 0.9rem;
        }
        .tx-amount.credit { color: var(--savora-success); }
        .tx-amount.debit { color: var(--savora-danger); }
        
        .badge-type {
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
        }
        .badge-type.topup { background-color: #d9f2db; color: #2c6e2f; }
        .badge-type.payment { background-color: #fbe8d3; color: #a8632f; }
        .badge-type.refund { background-color: #e3f2fd; color: #1565c0; }
    </style>
</head>
<body>
<%@ include file="/topbar.jsp" %>

<div class="app-shell">
    <%@ include file="/sidebar.jsp" %>

    <div class="main-content">
        <h2 style="margin-top:0; font-family: Georgia, serif; color: var(--savora-brown-dark);">My Wallet</h2>
        <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
            Top up your funds and view payment transactions.
        </p>

        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success" style="max-width:700px;">
                <i class="fa-solid fa-circle-check"></i> Wallet topped up successfully!
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error" style="max-width:700px;">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
            </div>
        </c:if>

        <div class="wallet-layout">
            <!-- Left Column: Balance & Top-up Card -->
            <div>
                <div class="balance-card">
                    <span class="balance-label">Total Balance</span>
                    <span class="balance-val">RM<fmt:formatNumber value="${wallet.balance}" minFractionDigits="2"/></span>
                </div>

                <div class="card">
                    <h3 style="margin-top:0; font-family: Georgia, serif; color: var(--savora-brown-dark);">Top Up Wallet</h3>
                    <form action="${pageContext.request.contextPath}/wallet/topup" method="post" id="topupForm" onsubmit="return validateTopup(event)">
                        <div class="form-group">
                            <label>Amount (RM) *</label>
                            <input type="number" name="amount" class="form-control" placeholder="0.00" min="5" max="1000" step="0.01" required>
                            <small style="font-size:0.7rem; color:#8a7a6a; display:block; margin-top:4px;">Minimum RM5.00, Maximum RM1000.00</small>
                        </div>

                        <div class="form-group">
                            <label>Payment Method *</label>
                            
                            <label class="topup-option" onclick="selectTopup(this, 'Online Banking')">
                                <i class="fa-solid fa-building-columns"></i>
                                <span>Online Banking</span>
                            </label>
                            
                            <label class="topup-option" onclick="selectTopup(this, 'Debit Card')">
                                <i class="fa-solid fa-credit-card"></i>
                                <span>Debit Card</span>
                            </label>
                            
                            <input type="hidden" name="topupMethod" id="topupMethodInput" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            Confirm Top Up &rarr;
                        </button>
                    </form>
                </div>
            </div>

            <!-- Right Column: Transaction History -->
            <div class="card">
                <h3 style="margin-top:0; font-family: Georgia, serif; color: var(--savora-brown-dark); margin-bottom:18px;">Transaction History</h3>
                
                <div class="tbl-responsive">
                    <c:choose>
                        <c:when test="${empty transactions}">
                            <div style="text-align:center; padding:40px 10px; color:#8a7a6a;">
                                <i class="fa-solid fa-clock-rotate-left" style="font-size:2.2rem; margin-bottom:12px; opacity:0.6;"></i>
                                <p style="margin:0; font-size:0.88rem;">No transactions recorded yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="savora-table">
                                <thead>
                                    <tr>
                                        <th>Date & Time</th>
                                        <th>Type</th>
                                        <th>Description</th>
                                        <th style="text-align:right;">Amount (RM)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tx" items="${transactions}">
                                        <tr>
                                            <td style="font-size:0.8rem; color:#666;">
                                                ${tx.formattedTransactionDate}
                                            </td>
                                            <td>
                                                <span class="badge-type ${tx.transactionType.toLowerCase()}">
                                                    ${tx.transactionType}
                                                </span>
                                            </td>
                                            <td style="font-size:0.82rem; color:#555;">${tx.description}</td>
                                            <td style="text-align:right;" class="tx-amount ${tx.credit ? 'credit' : 'debit'}">
                                                ${tx.credit ? '+' : '-'} <fmt:formatNumber value="${tx.amount}" minFractionDigits="2"/>
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
</div>

<script>
function selectTopup(el, method) {
    document.querySelectorAll('.topup-option').forEach(function(o) { o.classList.remove('selected'); });
    el.classList.add('selected');
    document.getElementById('topupMethodInput').value = method;
}

function validateTopup(e) {
    var method = document.getElementById('topupMethodInput').value;
    if (!method) {
        alert('Please select a payment method for top up.');
        e.preventDefault();
        return false;
    }
    return true;
}

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
