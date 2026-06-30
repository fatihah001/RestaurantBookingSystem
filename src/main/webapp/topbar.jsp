<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.savora.model.User currentUser = (com.savora.model.User) session.getAttribute("user");
    Integer cartBadgeCount = (Integer) request.getAttribute("itemsInCart");
    if (cartBadgeCount == null) {
        cartBadgeCount = (Integer) session.getAttribute("itemsInCart");
    }
    if (cartBadgeCount == null) {
        cartBadgeCount = 0;
    }
    pageContext.setAttribute("cartBadgeCount", cartBadgeCount);
%>
<div class="topbar">
    <div class="brand">
        <span class="logo-box">S</span> Savora
    </div>
    <div class="topbar-right">
        <% if (currentUser == null || (!"Admin".equals(currentUser.getRole()) && !"Staff".equals(currentUser.getRole()))) { %>
            <a href="${pageContext.request.contextPath}/cart" class="cart-icon">
                <i class="fa-solid fa-cart-shopping"></i>
                <c:if test="${cartBadgeCount > 0}">
                    <span class="cart-badge">${cartBadgeCount}</span>
                </c:if>
            </a>
        <% } %>
        <div class="user-info-text" onclick="document.getElementById('userDropdown').classList.toggle('open')">
            <span class="user-avatar"><%= currentUser != null ? currentUser.getInitial() : "?" %></span>
            <div class="user-meta">
                <span class="uname"><%= currentUser != null ? currentUser.getName().toUpperCase() : "" %></span>
                <span class="urole"><%= currentUser != null ? currentUser.getRole() : "" %></span>
            </div>
            <i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i>

            <div class="user-dropdown" id="userDropdown">
                <div class="dropdown-header">
                    <div class="dname"><%= currentUser != null ? currentUser.getName() : "" %></div>
                    <div class="demail"><%= currentUser != null ? currentUser.getEmail() : "" %></div>
                    <span class="drole"><%= currentUser != null ? currentUser.getRole() : "" %></span>
                </div>
            </div>
        </div>
    </div>
</div>
