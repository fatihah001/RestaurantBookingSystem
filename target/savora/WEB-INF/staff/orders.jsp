<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora Staff - Manage Orders</title>
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
            <div class="mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <h1 class="text-3xl font-bold text-savora-dark mb-2">Order Preparation & Service</h1>
                    <p class="text-gray-500">Track and prepare incoming customer dining and takeaway orders.</p>
                </div>
                <!-- Today / All toggle -->
                <div class="inline-flex rounded-lg border border-gray-200 bg-white p-1 shadow-sm">
                    <a href="${pageContext.request.contextPath}/staff/orders?filter=today" 
                       class="inline-block rounded-md px-4 py-2 text-sm font-semibold transition ${filter == 'today' ? 'bg-savora-brown text-white' : 'text-gray-500 hover:text-gray-700'}">
                        Today's Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/orders?filter=all" 
                       class="inline-block rounded-md px-4 py-2 text-sm font-semibold transition ${filter == 'all' ? 'bg-savora-brown text-white' : 'text-gray-500 hover:text-gray-700'}">
                        All Orders
                    </a>
                </div>
            </div>

            <!-- Filters Bar -->
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mb-8">
                <form action="${pageContext.request.contextPath}/staff/orders" method="get" class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <input type="hidden" name="filter" value="${filter}">
                    
                    <!-- Table filter -->
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Filter by Table</label>
                        <select name="tableId" onchange="this.form.submit()" class="w-full rounded-xl border border-gray-200 p-3 text-sm focus:outline-none focus:border-savora-accent">
                            <option value="">-- All Tables & Takeaway --</option>
                            <c:forEach var="t" items="${tables}">
                                <option value="${t.tableId}" ${selectedTableId == t.tableId ? 'selected' : ''}>
                                    ${t.tableNo} (${t.location})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Status filter -->
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Filter by Status</label>
                        <select name="status" onchange="this.form.submit()" class="w-full rounded-xl border border-gray-200 p-3 text-sm focus:outline-none focus:border-savora-accent">
                            <option value="">-- All Status --</option>
                            <option value="Confirmed" ${selectedStatus == 'Confirmed' ? 'selected' : ''}>Confirmed (To Prepare)</option>
                            <option value="In Preparation" ${selectedStatus == 'In Preparation' ? 'selected' : ''}>In Preparation</option>
                            <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed (Served)</option>
                            <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>

                    <!-- Date filter (only shown in All view) -->
                    <c:if test="${filter == 'all'}">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Filter by Date</label>
                            <input type="date" name="date" value="${selectedDate}" onchange="this.form.submit()"
                                   class="w-full rounded-xl border border-gray-200 p-3 text-sm focus:outline-none focus:border-savora-accent">
                        </div>
                    </c:if>

                    <!-- Clear Filters Link -->
                    <div class="flex items-end justify-start">
                        <c:if test="${not empty selectedTableId || not empty selectedStatus || not empty selectedDate}">
                            <a href="${pageContext.request.contextPath}/staff/orders?filter=${filter}" class="text-sm font-semibold text-savora-accent hover:text-savora-dark flex items-center gap-2 mb-3">
                                <i class="fa-solid fa-filter-circle-xmark"></i> Clear Active Filters
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- Orders Grid -->
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="bg-white rounded-2xl p-16 text-center shadow-sm border border-gray-100">
                        <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-400 text-3xl">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                        <h3 class="text-lg font-bold text-savora-dark font-serif mb-1">No Orders Found</h3>
                        <p class="text-sm text-gray-400">Try adjusting your filters or search options.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
                        <c:forEach var="o" items="${orders}">
                            <!-- Order Card -->
                            <div class="bg-white rounded-2xl shadow-sm border border-gray-150 flex flex-col justify-between overflow-hidden">
                                <!-- Card Header -->
                                <div class="p-6 pb-4 border-b border-gray-100">
                                    <div class="flex items-center justify-between mb-3">
                                        <span class="text-sm font-mono font-bold text-gray-500">#${o.orderId}</span>
                                        <!-- Status Badge -->
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 'Confirmed'}">
                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-700">Confirmed</span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'In Preparation'}">
                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-blue-50 text-blue-700 animate-pulse">In Prep</span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'Completed'}">
                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700">Served</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-50 text-red-700">Cancelled</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h3 class="font-serif font-bold text-lg text-savora-dark mb-1">${o.customerName}</h3>
                                    <div class="flex items-center gap-2 text-xs text-gray-400">
                                        <i class="fa-regular fa-clock"></i> ${o.formattedOrderDate}
                                    </div>
                                </div>

                                <!-- Card Body: Grouped Menu Items -->
                                <div class="p-6 py-4 flex-1">
                                    <!-- Table / Takeaway indicator -->
                                    <div class="mb-4 bg-savora-cream/30 border border-savora-cream rounded-xl p-3 flex justify-between items-center text-xs">
                                        <span class="font-bold text-savora-dark uppercase tracking-wider">Service Type</span>
                                        <c:choose>
                                            <c:when test="${not empty o.tableNo}">
                                                <span class="font-bold text-savora-accent"><i class="fa-solid fa-chair"></i> Dine-In (${o.tableNo})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="font-bold text-gray-500"><i class="fa-solid fa-bag-shopping"></i> Takeaway</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="space-y-4">
                                        <!-- APPETIZERS -->
                                        <c:set var="hasApp" value="false"/>
                                        <c:forEach var="item" items="${o.items}">
                                            <c:if test="${item.category == 'Appetizer' || item.category == 'Appetizers'}">
                                                <c:set var="hasApp" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasApp}">
                                            <div>
                                                <div class="text-[10px] font-bold text-savora-accent uppercase tracking-widest border-b border-orange-100 pb-1 mb-2">Appetizers</div>
                                                <ul class="space-y-1.5">
                                                    <c:forEach var="item" items="${o.items}">
                                                        <c:if test="${item.category == 'Appetizer' || item.category == 'Appetizers'}">
                                                            <li class="text-sm font-semibold text-gray-700 flex justify-between">
                                                                <span>${item.itemName} <c:if test="${not empty item.temperature}"><span class="text-xs text-gray-400 font-normal">(${item.temperature})</span></c:if></span>
                                                                <span class="text-gray-500">&times; ${item.quantity}</span>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>

                                        <!-- MAIN COURSE -->
                                        <c:set var="hasMain" value="false"/>
                                        <c:forEach var="item" items="${o.items}">
                                            <c:if test="${item.category == 'Main' || item.category == 'Main Course'}">
                                                <c:set var="hasMain" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasMain}">
                                            <div>
                                                <div class="text-[10px] font-bold text-savora-accent uppercase tracking-widest border-b border-orange-100 pb-1 mb-2">Main Courses</div>
                                                <ul class="space-y-1.5">
                                                    <c:forEach var="item" items="${o.items}">
                                                        <c:if test="${item.category == 'Main' || item.category == 'Main Course'}">
                                                            <li class="text-sm font-semibold text-gray-700 flex justify-between">
                                                                <span>${item.itemName} <c:if test="${not empty item.temperature}"><span class="text-xs text-gray-400 font-normal">(${item.temperature})</span></c:if></span>
                                                                <span class="text-gray-500">&times; ${item.quantity}</span>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>

                                        <!-- DESSERTS -->
                                        <c:set var="hasDes" value="false"/>
                                        <c:forEach var="item" items="${o.items}">
                                            <c:if test="${item.category == 'Dessert' || item.category == 'Desserts'}">
                                                <c:set var="hasDes" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasDes}">
                                            <div>
                                                <div class="text-[10px] font-bold text-savora-accent uppercase tracking-widest border-b border-orange-100 pb-1 mb-2">Desserts</div>
                                                <ul class="space-y-1.5">
                                                    <c:forEach var="item" items="${o.items}">
                                                        <c:if test="${item.category == 'Dessert' || item.category == 'Desserts'}">
                                                            <li class="text-sm font-semibold text-gray-700 flex justify-between">
                                                                <span>${item.itemName} <c:if test="${not empty item.temperature}"><span class="text-xs text-gray-400 font-normal">(${item.temperature})</span></c:if></span>
                                                                <span class="text-gray-500">&times; ${item.quantity}</span>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>

                                        <!-- DRINKS -->
                                        <c:set var="hasBeverage" value="false"/>
                                        <c:forEach var="item" items="${o.items}">
                                            <c:if test="${item.category == 'Beverage' || item.category == 'Beverages' || item.category == 'Drinks'}">
                                                <c:set var="hasBeverage" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasBeverage}">
                                            <div>
                                                <div class="text-[10px] font-bold text-savora-accent uppercase tracking-widest border-b border-orange-100 pb-1 mb-2">Beverages</div>
                                                <ul class="space-y-1.5">
                                                    <c:forEach var="item" items="${o.items}">
                                                        <c:if test="${item.category == 'Beverage' || item.category == 'Beverages' || item.category == 'Drinks'}">
                                                            <li class="text-sm font-semibold text-gray-700 flex justify-between">
                                                                <span>${item.itemName} <c:if test="${not empty item.temperature}"><span class="text-xs text-gray-400 font-normal">(${item.temperature})</span></c:if></span>
                                                                <span class="text-gray-500">&times; ${item.quantity}</span>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>

                                        <!-- OTHERS -->
                                        <c:set var="hasOther" value="false"/>
                                        <c:forEach var="item" items="${o.items}">
                                            <c:if test="${item.category != 'Appetizer' && item.category != 'Appetizers' && item.category != 'Main' && item.category != 'Main Course' && item.category != 'Dessert' && item.category != 'Desserts' && item.category != 'Beverage' && item.category != 'Beverages' && item.category != 'Drinks'}">
                                                <c:set var="hasOther" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${hasOther}">
                                            <div>
                                                <div class="text-[10px] font-bold text-savora-accent uppercase tracking-widest border-b border-orange-100 pb-1 mb-2">Others</div>
                                                <ul class="space-y-1.5">
                                                    <c:forEach var="item" items="${o.items}">
                                                        <c:if test="${item.category != 'Appetizer' && item.category != 'Appetizers' && item.category != 'Main' && item.category != 'Main Course' && item.category != 'Dessert' && item.category != 'Desserts' && item.category != 'Beverage' && item.category != 'Beverages' && item.category != 'Drinks'}">
                                                            <li class="text-sm font-semibold text-gray-700 flex justify-between">
                                                                <span>${item.itemName} <c:if test="${not empty item.temperature}"><span class="text-xs text-gray-400 font-normal">(${item.temperature})</span></c:if></span>
                                                                <span class="text-gray-500">&times; ${item.quantity}</span>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Card Footer: Actions -->
                                <div class="p-6 pt-4 border-t border-gray-100 bg-gray-50/50 flex flex-col gap-2">
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 'Confirmed'}">
                                            <form action="${pageContext.request.contextPath}/staff/order-update" method="post" class="w-full">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <input type="hidden" name="status" value="In Preparation">
                                                <input type="hidden" name="filter" value="${filter}">
                                                <input type="hidden" name="tableId" value="${selectedTableId}">
                                                <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                                <input type="hidden" name="date" value="${selectedDate}">
                                                <button type="submit" class="w-full py-2.5 bg-savora-accent hover:bg-savora-brown text-white font-bold text-sm rounded-xl shadow-sm transition duration-200">
                                                    <i class="fa-solid fa-play"></i> Start Preparing
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.orderStatus == 'In Preparation'}">
                                            <form action="${pageContext.request.contextPath}/staff/order-update" method="post" class="w-full">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <input type="hidden" name="status" value="Completed">
                                                <input type="hidden" name="filter" value="${filter}">
                                                <input type="hidden" name="tableId" value="${selectedTableId}">
                                                <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                                <input type="hidden" name="date" value="${selectedDate}">
                                                <button type="submit" class="w-full py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm rounded-xl shadow-sm transition duration-200">
                                                    <i class="fa-solid fa-circle-check"></i> Mark as Served
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.orderStatus == 'Completed'}">
                                            <div class="py-2.5 text-center text-emerald-600 font-bold text-sm bg-emerald-50 border border-emerald-100 rounded-xl">
                                                <i class="fa-solid fa-check-double"></i> Served & Completed
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-2.5 text-center text-red-600 font-bold text-sm bg-red-50 border border-red-100 rounded-xl">
                                                <i class="fa-solid fa-circle-xmark"></i> Cancelled
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Option to cancel order if it is not completed yet -->
                                    <c:if test="${o.orderStatus == 'Confirmed' || o.orderStatus == 'In Preparation'}">
                                        <form action="${pageContext.request.contextPath}/staff/order-update" method="post" class="w-full">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <input type="hidden" name="status" value="Cancelled">
                                            <input type="hidden" name="filter" value="${filter}">
                                            <input type="hidden" name="tableId" value="${selectedTableId}">
                                            <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                                <input type="hidden" name="date" value="${selectedDate}">
                                            <button type="submit" onclick="return confirm('Cancel this order? This will cancel payment or flag for refund.')" 
                                                    class="w-full py-2 border border-red-200 hover:bg-red-50 text-red-600 font-bold text-xs rounded-xl transition duration-200">
                                                Cancel Order
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
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
