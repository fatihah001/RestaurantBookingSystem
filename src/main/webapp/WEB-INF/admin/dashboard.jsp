<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    com.savora.model.User user = (com.savora.model.User) session.getAttribute("user");
    String userName = (user != null) ? user.getName().toUpperCase() : "SYSTEM ADMIN";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        savora: {
                            brown: '#6b3f1f',
                            dark: '#4a2c1a',
                            cream: '#fdf6ee',
                            accent: '#c9824a',
                            border: '#e8ddd0'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body>
<%@ include file="/topbar.jsp" %>
<div class="app-shell">
    <%@ include file="/sidebar.jsp" %>

    <div class="main-content">

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-savora-dark mb-2">
                Welcome back, <c:out value="${user.name}"/>!
            </h1>
            <p class="text-sm text-gray-400 mt-1">Manage the restaurant's daily operations from this panel.</p>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-8">

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5 flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-orange-100 text-orange-500 flex items-center justify-center text-xl flex-shrink-0">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-gray-800">${totalOrders}</p>
                    <p class="text-sm text-gray-400">Total Orders</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5 flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-green-100 text-green-600 flex items-center justify-center text-xl flex-shrink-0">
                    <i class="fa-solid fa-wallet"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-gray-800">RM ${totalSales}</p>
                    <p class="text-sm text-gray-400">Total Sales</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5 flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-pink-100 text-pink-600 flex items-center justify-center text-xl flex-shrink-0">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-gray-800">${totalReservations}</p>
                    <p class="text-sm text-gray-400">Reservations</p>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-5">

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <h3 class="font-serif text-base font-semibold text-savora-dark mb-4">Daily Sales (Last 7 Days)</h3>
                <div class="relative h-72">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <h3 class="font-serif text-base font-semibold text-savora-dark mb-4">Reservations by Status</h3>
                <div class="relative h-72">
                    <canvas id="bookingsChart"></canvas>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
var salesData = [];
var bookingData = {};
try { salesData = JSON.parse('${salesJson}'); } catch(e) {}
try { bookingData = JSON.parse('${bookingJson}'); } catch(e) {}

var ctxSales = document.getElementById('salesChart').getContext('2d');
new Chart(ctxSales, {
    type: 'line',
    data: {
        labels: salesData.map(function(i){ return i.date; }),
        datasets: [{
            label: 'Sales (RM)',
            data: salesData.map(function(i){ return i.sales; }),
            borderColor: '#c9824a',
            backgroundColor: 'rgba(201,130,74,0.1)',
            borderWidth: 3, fill: true, tension: 0.3
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
            x: { grid: { display: false } }
        }
    }
});

var ctxBookings = document.getElementById('bookingsChart').getContext('2d');
new Chart(ctxBookings, {
    type: 'doughnut',
    data: {
        labels: Object.keys(bookingData),
        datasets: [{ data: Object.values(bookingData),
            backgroundColor: ['#c9824a','#4caf50','#d9534f','#e0a040'], borderWidth: 1 }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, padding: 15 } } }
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
