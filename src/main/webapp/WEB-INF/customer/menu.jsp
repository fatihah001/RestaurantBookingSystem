<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Menu</title>
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
            <div class="step active"><div class="step-circle">1</div><div class="step-label">Menu</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">2</div><div class="step-label">Cart</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">3</div><div class="step-label">Table</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">4</div><div class="step-label">Checkout</div></div>
            <div class="step-line"></div>
            <div class="step"><div class="step-circle">5</div><div class="step-label">Done</div></div>
        </div>

        <div class="category-tabs">
            <a href="${pageContext.request.contextPath}/menu?category=All"
               class="category-tab ${selectedCategory == 'All' ? 'active' : ''}">All</a>
            <a href="${pageContext.request.contextPath}/menu?category=Food"
               class="category-tab ${selectedCategory == 'Food' ? 'active' : ''}"><i class="fa-solid fa-drumstick-bite"></i> Food</a>
            <a href="${pageContext.request.contextPath}/menu?category=Beverages"
               class="category-tab ${selectedCategory == 'Beverages' ? 'active' : ''}"><i class="fa-solid fa-mug-saucer"></i> Beverages</a>
            <a href="${pageContext.request.contextPath}/menu?category=Desserts"
               class="category-tab ${selectedCategory == 'Desserts' ? 'active' : ''}"><i class="fa-solid fa-ice-cream"></i> Desserts</a>
        </div>

        <c:if test="${empty menuItems}">
            <div class="empty-state">
                <i class="fa-solid fa-utensils"></i>
                <p>No menu items found in this category.</p>
            </div>
        </c:if>

        <div class="menu-grid">
            <c:forEach var="item" items="${menuItems}">
                <div class="menu-card">
                    <div class="menu-img" style="background-image: url('${pageContext.request.contextPath}/${item.imageUrl}');">
                        <span class="badge-tag">${item.category}</span>
                    </div>
                    <div class="menu-body">
                        <div class="menu-name">${item.itemName}</div>
                        <div class="menu-desc">${item.description}</div>
                        <div class="menu-footer">
                            <span class="menu-price">RM<fmt:formatNumber value="${item.itemPrice}" minFractionDigits="2"/></span>
                            <c:if test="${!item.available}">
                                <span class="stock-badge sold-out">Sold Out</span>
                            </c:if>
                        </div>

                        <c:if test="${item.available}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top:6px;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="menuId" value="${item.menuId}">
                                <input type="hidden" name="redirect" value="menu">
                                <div style="display:flex; align-items:center; justify-content:space-between; gap:8px; flex-wrap:wrap;">
                                    <select name="diningType" class="form-control" style="padding:6px;font-size:0.75rem;">
                                        <option value="Dine In">Dine In</option>
                                        <option value="Takeaway">Takeaway</option>
                                    </select>
                                    <c:if test="${item.category == 'Beverages'}">
                                        <select name="temperature" class="form-control" style="padding:6px;font-size:0.75rem;">
                                            <option value="Hot">Hot</option>
                                            <option value="Cold">Cold</option>
                                        </select>
                                    </c:if>
                                    <input type="number" name="quantity" value="1" min="1" max="20"
                                           class="form-control" style="width:55px;padding:6px;font-size:0.75rem;">
                                    <button type="submit" class="btn btn-accent" style="padding:6px 14px;font-size:0.75rem;">+ Add</button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
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
