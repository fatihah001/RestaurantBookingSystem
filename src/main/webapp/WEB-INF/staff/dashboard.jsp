<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora Staff - Operations Dashboard</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        savora: {
                            brown: '#6b3e26',
                            dark: '#4a2c1a',
                            light: '#8b5a3c',
                            accent: '#c17a4a',
                            cream: '#f5ede1',
                            creamLight: '#faf6ef'
                        }
                    }
                }
            }
        }
    </script>
    <!-- Style.css and FontAwesome -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .app-shell {
            display: flex;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            padding: 40px;
            background-color: #fdfaf5; 
        }
    </style>
</head>
<body class="bg-savora-creamLight">
    <%@ include file="/topbar.jsp" %>
    <div class="app-shell">
        <%@ include file="/sidebar.jsp" %>

        <div class="main-content">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-savora-dark mb-2">Staff Operation Dashboard</h1>
                <p class="text-gray-500">Monitor active orders queue, daily schedules, and overall culinary preparation trends.</p>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <!-- Active Orders Card -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-orange-100 flex items-center hover:-translate-y-1 transition duration-300">
                    <div class="w-12 h-12 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center text-xl mr-4">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">${activeOrders}</h2>
                        <p class="text-xs text-gray-400 font-semibold tracking-wider uppercase">Active Prep Queue</p>
                    </div>
                </div>

                <!-- Weekly Sales Card -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-emerald-100 flex items-center hover:-translate-y-1 transition duration-300">
                    <div class="w-12 h-12 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-xl mr-4">
                        <i class="fa-solid fa-circle-dollar-to-slot"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">RM <fmt:formatNumber value="${weeklySales}" minFractionDigits="2"/></h2>
                        <p class="text-xs text-gray-400 font-semibold tracking-wider uppercase">Weekly Completed Sales</p>
                    </div>
                </div>

                <!-- Today's Reservations Card -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-pink-100 flex items-center hover:-translate-y-1 transition duration-300">
                    <div class="w-12 h-12 rounded-xl bg-pink-50 text-pink-600 flex items-center justify-center text-xl mr-4">
                        <i class="fa-solid fa-calendar-day"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">${todaysBookings}</h2>
                        <p class="text-xs text-gray-400 font-semibold tracking-wider uppercase">Today's Bookings</p>
                    </div>
                </div>

                <!-- Pending Bookings Card -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-blue-100 flex items-center hover:-translate-y-1 transition duration-300">
                    <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center text-xl mr-4">
                        <i class="fa-solid fa-chair"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">${pendingBookings}</h2>
                        <p class="text-xs text-gray-400 font-semibold tracking-wider uppercase">Confirmed Bookings</p>
                    </div>
                </div>
            </div>
            <!-- Live Operations Queue Section -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-8">
                <!-- Active Kitchen Queue -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-serif font-bold text-savora-dark">Active Kitchen Queue</h3>
                        <a href="${pageContext.request.contextPath}/staff/orders" class="text-xs font-semibold text-savora-accent hover:underline">Manage Orders &rarr;</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr class="border-b border-gray-100 text-gray-400 font-semibold">
                                    <th class="py-3 px-2">Order ID</th>
                                    <th class="py-3 px-2">Table / Dining</th>
                                    <th class="py-3 px-2">Items Count</th>
                                    <th class="py-3 px-2">Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50">
                                <c:choose>
                                    <c:when test="${empty activeQueue}">
                                        <tr>
                                            <td colspan="4" class="py-6 text-center text-gray-400">
                                                <i class="fa-solid fa-check-double text-2xl mb-2 block opacity-55"></i>
                                                No pending orders in the kitchen.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="o" items="${activeQueue}">
                                            <tr class="hover:bg-gray-50 transition duration-150">
                                                <td class="py-3 px-2 font-semibold">#${o.orderId}</td>
                                                <td class="py-3 px-2">
                                                    <c:choose>
                                                        <c:when test="${not empty o.tableNo}">
                                                            <span class="text-savora-accent font-semibold"> ${o.tableNo}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400 italic">Takeaway</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="py-3 px-2 text-gray-500">
                                                    ${o.items.size()} items
                                                </td>
                                                <td class="py-3 px-2">
                                                    <c:choose>
                                                        <c:when test="${o.orderStatus == 'Confirmed'}">
                                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-orange-100 text-orange-700">Confirmed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-amber-100 text-amber-800 animate-pulse">In Prep</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Today's Booking Schedule -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-serif font-bold text-savora-dark">Today's Reservation Schedule</h3>
                        <a href="${pageContext.request.contextPath}/admin/bookings" class="text-xs font-semibold text-savora-accent hover:underline">Manage Bookings &rarr;</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr class="border-b border-gray-100 text-gray-400 font-semibold">
                                    <th class="py-3 px-2">Time</th>
                                    <th class="py-3 px-2">Customer</th>
                                    <th class="py-3 px-2">Table</th>
                                    <th class="py-3 px-2">Guests</th>
                                    <th class="py-3 px-2">Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50">
                                <c:choose>
                                    <c:when test="${empty todaysSchedule}">
                                        <tr>
                                            <td colspan="5" class="py-6 text-center text-gray-400">
                                                <i class="fa-regular fa-calendar-xmark text-2xl mb-2 block opacity-55"></i>
                                                No reservations scheduled for today.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="b" items="${todaysSchedule}">
                                            <tr class="hover:bg-gray-50 transition duration-150">
                                                <td class="py-3 px-2 font-semibold text-savora-brown">${b.bookingTime}</td>
                                                <td class="py-3 px-2 font-medium text-gray-700">${b.customerName}</td>
                                                <td class="py-3 px-2 font-semibold text-gray-800"> ${b.tableNo}</td>
                                                <td class="py-3 px-2 text-gray-500">${b.noOfPeople} guests</td>
                                                <td class="py-3 px-2">
                                                    <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-700">${b.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
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
