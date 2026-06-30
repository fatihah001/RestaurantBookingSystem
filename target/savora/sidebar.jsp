<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String currentPage = request.getServletPath();
    com.savora.model.User sidebarUser = (com.savora.model.User) session.getAttribute("user");
%>
<div class="sidebar">
    <div class="sidebar-menu">
    <% if (sidebarUser != null && "Admin".equals(sidebarUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item <%= currentPage.contains("/admin/dashboard") ? "active" : "" %>">
            <i class="fa-solid fa-gauge"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/menu" class="menu-item <%= currentPage.contains("/admin/menu") ? "active" : "" %>">
            <i class="fa-solid fa-utensils"></i> Manage Menu
        </a>
        <a href="${pageContext.request.contextPath}/admin/tables" class="menu-item <%= currentPage.contains("/admin/tables") ? "active" : "" %>">
            <i class="fa-solid fa-chair"></i> Manage Tables
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="menu-item <%= currentPage.contains("/admin/bookings") ? "active" : "" %>">
            <i class="fa-solid fa-calendar-check"></i> View Bookings
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="menu-item <%= currentPage.contains("/admin/users") ? "active" : "" %>">
            <i class="fa-solid fa-users"></i> Manage Users
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item <%= currentPage.contains("/admin/reports") ? "active" : "" %>">
            <i class="fa-solid fa-chart-pie"></i> Generate Reports
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="menu-item">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    <% } else if (sidebarUser != null && "Staff".equals(sidebarUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/staff/dashboard" class="menu-item <%= currentPage.contains("/staff/dashboard") ? "active" : "" %>">
            <i class="fa-solid fa-gauge"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/staff/orders" class="menu-item <%= currentPage.contains("/staff/orders") ? "active" : "" %>">
            <i class="fa-solid fa-receipt"></i> Manage Orders
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="menu-item <%= currentPage.contains("/admin/bookings") ? "active" : "" %>">
            <i class="fa-solid fa-calendar-check"></i> View Bookings
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="menu-item">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/dashboard" class="menu-item <%= currentPage.endsWith("/dashboard.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-gauge"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/menu" class="menu-item <%= currentPage.endsWith("/menu.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-utensils"></i> Menu
        </a>
        <a href="${pageContext.request.contextPath}/booking" class="menu-item <%= currentPage.endsWith("/booking.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-calendar-days"></i> Book a Table
        </a>
        <a href="${pageContext.request.contextPath}/history" class="menu-item <%= currentPage.endsWith("/history.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-clock-rotate-left"></i> History
        </a>
        <a href="${pageContext.request.contextPath}/booking/cancel" class="menu-item <%= currentPage.endsWith("/cancel_booking.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-ban"></i> Cancel Booking
        </a>
        <a href="${pageContext.request.contextPath}/order/track" class="menu-item <%= currentPage.contains("/track_order") || currentPage.contains("/order/track") ? "active" : "" %>">
            <i class="fa-solid fa-bowl-food"></i> Order Status
        </a>
        <a href="${pageContext.request.contextPath}/wallet" class="menu-item <%= currentPage.endsWith("/wallet.jsp") ? "active" : "" %>">
            <i class="fa-solid fa-wallet"></i> Wallet
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="menu-item">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    <% } %>
    </div>
</div>
