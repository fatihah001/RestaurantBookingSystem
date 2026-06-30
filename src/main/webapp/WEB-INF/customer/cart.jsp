<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
            <div class="step active"><div class="step-circle">2</div><div class="step-label">Cart</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">3</div><div class="step-label">Table</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">4</div><div class="step-label">Checkout</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">5</div><div class="step-label">Done</div></div>
        </div>

        <c:if test="${empty cartItems}">
            <div class="empty-state">
                <i class="fa-solid fa-cart-shopping"></i>
                <p>Your cart is empty.</p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Browse Menu</a>
            </div>
        </c:if>

        <c:if test="${not empty cartItems}">
        <div class="layout-2col">
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                    <strong>Select All (${itemCount} items)</strong>
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="clear">
              
                    </form>
                </div>

                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-row">
                        <div class="cart-thumb" style="background-image:url('${pageContext.request.contextPath}/${item.imageUrl}');background-size:cover;background-position:center;"></div>
                        <div class="cart-info">
                            <div class="cart-name">${item.itemName}</div>
                            <div class="cart-meta">
                                ${item.category} &middot; ${item.diningType}
                                <c:if test="${not empty item.temperature}"> &middot; ${item.temperature}</c:if>
                            </div>
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top:6px; display:flex; align-items:center; gap:10px;">
                                <input type="hidden" name="action" value="updateQuantity">
                                <input type="hidden" name="menuId" value="${item.menuId}">
                                <input type="hidden" name="diningType" value="${item.diningType}">
                                <input type="hidden" name="temperature" value="${item.temperature}">
                                <input type="hidden" name="redirect" value="cart">
                                <div class="qty-control">
                                    <button type="submit" name="quantity" value="${item.quantity - 1}">-</button>
                                    <span>${item.quantity}</span>
                                    <button type="submit" name="quantity" value="${item.quantity + 1}">+</button>
                                </div>
                            </form>
                        </div>
                        <div class="cart-price">RM<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/></div>
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="menuId" value="${item.menuId}">
                            <input type="hidden" name="redirect" value="cart">
                            <button type="submit" style="background:none;border:none;color:#999;cursor:pointer;">&times;</button>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <div class="card">
                <h3 style="margin-top:0;color:var(--savora-brown-dark);">Order Summary</h3>
                <div class="summary-row"><span>Items in cart</span><span>${itemCount}</span></div>
                <div class="summary-row"><span>Cart total</span><span>RM<fmt:formatNumber value="${cartTotal}" minFractionDigits="2"/></span></div>
                <div class="summary-row total"><span>Selected Total</span><span>RM<fmt:formatNumber value="${cartTotal}" minFractionDigits="2"/></span></div>
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-primary btn-block">&rarr; Proceed to Table Selection</a>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-outline btn-block" style="margin-top:10px;">
                    <i class="fa-solid fa-bag-shopping"></i> Checkout
                </a>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-block" style="margin-top:10px;">+ Add More Items</a>
                <p style="font-size:0.72rem;color:#8a7a6a;margin-top:14px;">
                    <i class="fa-regular fa-circle-question"></i> Dine-in? Pick a table next. Ordering takeaway only? Skip straight to checkout — no table booking required.
                </p>
            </div>
        </div>
        </c:if>
    </div>
</div>

<script>
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
