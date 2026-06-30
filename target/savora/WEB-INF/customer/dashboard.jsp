<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Dashboard</title>

    <%-- External resources --%>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <script>
        /* Extend Tailwind with the Savora brand tokens so JSP/JSTL output
           can still reference Tailwind classes that match the design system. */
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'savora-dark':   '#2c1a0e',
                        'savora-brown':  '#6b3f1f',
                        'savora-accent': '#d4842a',
                        'savora-cream':  '#f5ede1',
                        'savora-border': '#e8d9c5',
                        'savora-muted':  '#8a7a6a',
                    },
                    fontFamily: {
                        serif: ['Georgia', 'serif'],
                    }
                }
            }
        }
    </script>

    <style>
        /* CSS-variable bridge – keeps sidebar/topbar tokens working */
        :root {
            --savora-brown-dark:  #4a2c1a;
            --savora-accent:      #d4842a;
            --savora-text-light:  #fdf6ee;
            --savora-text-dark:   #2c1a0e;
            --savora-cream-light: #fdf6ee;
            --savora-border:      #e8d9c5;
        }
    </style>
</head>
<body class="bg-savora-cream min-h-screen">

<%@ include file="/topbar.jsp" %>

<div class="app-shell flex">
    <%@ include file="/sidebar.jsp" %>

    <%-- ═══════════════════════════════════════════════
         MAIN CONTENT
    ═══════════════════════════════════════════════ --%>
    <main class="main-content flex-1 p-6 lg:p-8 overflow-y-auto">

        <%-- ── Page heading ── --%>
        <h1 class="text-3xl font-bold text-savora-dark">
            Welcome back, <c:out value="${user.name}"/>!
        </h1>
        <p class="text-savora-muted text-sm mt-1 mb-6">
            Here's an overview of your bookings
        </p>

        <%-- ══════════════════════════════════════════
             STATS GRID  (4 stat cards)
             JavaBeans: upcomingCount, completedCount,
                        cancelledCount, totalSpent
        ══════════════════════════════════════════ --%>
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-6">

            <%-- Upcoming --%>
            <div class="stat-card bg-white rounded-2xl shadow-sm border border-savora-border
                        flex items-center gap-4 p-5">
                <div class="stat-icon icon-bg-amber flex items-center justify-center
                            w-12 h-12 rounded-xl bg-amber-100 text-amber-600 text-xl shrink-0">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>
                <div>
                    <div class="text-2xl font-bold text-savora-dark">${upcomingCount}</div>
                    <div class="text-xs text-savora-muted uppercase tracking-wide">Upcoming</div>
                </div>
            </div>

            <%-- Completed --%>
            <div class="stat-card bg-white rounded-2xl shadow-sm border border-savora-border
                        flex items-center gap-4 p-5">
                <div class="stat-icon icon-bg-green flex items-center justify-center
                            w-12 h-12 rounded-xl bg-green-100 text-green-600 text-xl shrink-0">
                    <i class="fa-solid fa-check-double"></i>
                </div>
                <div>
                    <div class="text-2xl font-bold text-savora-dark">${completedCount}</div>
                    <div class="text-xs text-savora-muted uppercase tracking-wide">Completed</div>
                </div>
            </div>

            <%-- Cancelled --%>
            <div class="stat-card bg-white rounded-2xl shadow-sm border border-savora-border
                        flex items-center gap-4 p-5">
                <div class="stat-icon icon-bg-red flex items-center justify-center
                            w-12 h-12 rounded-xl bg-red-100 text-red-500 text-xl shrink-0">
                    <i class="fa-solid fa-ban"></i>
                </div>
                <div>
                    <div class="text-2xl font-bold text-savora-dark">${cancelledCount}</div>
                    <div class="text-xs text-savora-muted uppercase tracking-wide">Cancelled</div>
                </div>
            </div>

            <%-- Total Spent – JavaBean: totalSpent (BigDecimal / Double) --%>
            <div class="stat-card bg-white rounded-2xl shadow-sm border border-savora-border
                        flex items-center gap-4 p-5">
                <div class="stat-icon icon-bg-brown flex items-center justify-center
                            w-12 h-12 rounded-xl bg-amber-50 text-savora-brown text-xl shrink-0">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <div class="text-2xl font-bold text-savora-dark">
                        RM<fmt:formatNumber value="${totalSpent != null ? totalSpent : 0.00}"
                                           minFractionDigits="2"/>
                    </div>
                    <div class="text-xs text-savora-muted uppercase tracking-wide">Total Spent</div>
                </div>
            </div>

        </div><%-- /stats grid --%>

        <%-- ══════════════════════════════════════════
             NEXT RESERVATION COUNTDOWN BANNER
             JavaBean: nextBooking (tableNo, noOfPeople,
                       bookingDate, bookingTime)
             Scoped vars: countdownDays, countdownHours,
                          countdownMinutes, countdownSeconds
        ══════════════════════════════════════════ --%>
        <c:if test="${not empty nextBooking}">
            <div class="rounded-2xl p-6 mb-6 shadow-md flex flex-col sm:flex-row
                        items-start sm:items-center justify-between gap-6"
                 style="background-color: var(--savora-brown-dark); color: var(--savora-text-light);">

                <%-- Left: label + reservation info --%>
                <div class="flex-1">
                    <span class="text-1xl font-bold uppercase tracking-widest text-savora-accent">
                        Next Reservation Countdown
                    </span>
                    <h3 class="font-serif text-xl font-semibold mt-1 mb-2">
                        <c:out value="${nextBooking.tableNo}"/>
                        &nbsp;&mdash;&nbsp;
                        <c:out value="${nextBooking.noOfPeople}"/> guests
                    </h3>
                    <p class="text-sm opacity-90">
                        <i class="fa-regular fa-calendar mr-1"></i>
                        <c:out value="${nextBooking.bookingDate}"/>
                        &middot;
                        <i class="fa-regular fa-clock mx-1"></i>
                        <c:out value="${nextBooking.bookingTime}"/>
                    </p>
                </div>

                <%-- Right: countdown boxes --%>
                <div class="flex gap-3 shrink-0"
                     id="timerContainer"
                     data-target="${nextBooking.bookingDate}T${nextBooking.bookingTime}">

                    <c:forEach var="unit" items="${[
                        ['daysVal',  countdownDays,    'Days'],
                        ['hoursVal', countdownHours,   'Hrs'],
                        ['minVal',   countdownMinutes, 'Min'],
                        ['secVal',   countdownSeconds, 'Sec']
                    ]}">
                        <%-- NOTE: c:forEach over a literal list isn't available in all JSTL
                             implementations; the four boxes are written explicitly below. --%>
                    </c:forEach>

                    <%-- Days --%>
                    <div class="flex flex-col items-center justify-center rounded-xl px-4 py-3 min-w-[62px]"
                         style="background:rgba(255,255,255,.10); border:1px solid rgba(255,255,255,.15);">
                        <span class="text-2xl font-bold text-savora-accent" id="daysVal">${countdownDays}</span>
                        <span class="text-[0.6rem] uppercase tracking-wider opacity-80 mt-0.5">Days</span>
                    </div>
                    <%-- Hours --%>
                    <div class="flex flex-col items-center justify-center rounded-xl px-4 py-3 min-w-[62px]"
                         style="background:rgba(255,255,255,.10); border:1px solid rgba(255,255,255,.15);">
                        <span class="text-2xl font-bold text-savora-accent" id="hoursVal">${countdownHours}</span>
                        <span class="text-[0.6rem] uppercase tracking-wider opacity-80 mt-0.5">Hrs</span>
                    </div>
                    <%-- Minutes --%>
                    <div class="flex flex-col items-center justify-center rounded-xl px-4 py-3 min-w-[62px]"
                         style="background:rgba(255,255,255,.10); border:1px solid rgba(255,255,255,.15);">
                        <span class="text-2xl font-bold text-savora-accent" id="minVal">${countdownMinutes}</span>
                        <span class="text-[0.6rem] uppercase tracking-wider opacity-80 mt-0.5">Min</span>
                    </div>
                    <%-- Seconds --%>
                    <div class="flex flex-col items-center justify-center rounded-xl px-4 py-3 min-w-[62px]"
                         style="background:rgba(255,255,255,.10); border:1px solid rgba(255,255,255,.15);">
                        <span class="text-2xl font-bold text-savora-accent" id="secVal">${countdownSeconds}</span>
                        <span class="text-[0.6rem] uppercase tracking-wider opacity-80 mt-0.5">Sec</span>
                    </div>

                </div>
            </div>
        </c:if><%-- /countdown banner --%>

        <%-- ══════════════════════════════════════════
             MAIN TWO-COLUMN LAYOUT
        ══════════════════════════════════════════ --%>
        <div class="grid grid-cols-1 lg:grid-cols-[1fr_320px] gap-6">

            <%-- ── LEFT: Upcoming Reservations table ── --%>
            <div class="bg-white rounded-2xl shadow-sm border border-savora-border p-6">

                <div class="flex items-center justify-between mb-5">
                    <h2 class="text-xl font-bold text-savora-dark">Upcoming Reservations</h2>
                    <a href="${pageContext.request.contextPath}/booking"
                       class="text-xs font-semibold text-savora-accent border border-savora-accent
                              rounded-lg px-3 py-1.5 hover:bg-savora-accent hover:text-white
                              transition-colors duration-150">
                        + New Booking
                    </a>
                </div>

                <%-- JSTL conditional: empty state vs table --%>
                <c:choose>
                    <c:when test="${empty upcomingBookings}">
                        <div class="flex flex-col items-center justify-center py-12 text-savora-muted">
                            <i class="fa-regular fa-calendar text-4xl opacity-40 mb-3"></i>
                            <p class="text-sm">You have no upcoming confirmed reservations.</p>
                            <a href="${pageContext.request.contextPath}/menu"
                               class="mt-4 text-sm font-semibold bg-savora-accent text-white
                                      rounded-lg px-4 py-2 hover:bg-savora-brown transition-colors">
                                Browse Menu to Book
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left">
                                <thead>
                                    <tr class="border-b-2 border-savora-border">
                                        <th class="pb-3 pr-4 font-semibold text-savora-dark">ID</th>
                                        <th class="pb-3 pr-4 font-semibold text-savora-dark">Table</th>
                                        <th class="pb-3 pr-4 font-semibold text-savora-dark">Date</th>
                                        <th class="pb-3 pr-4 font-semibold text-savora-dark">Time</th>
                                        <th class="pb-3 pr-4 font-semibold text-savora-dark">Guests</th>
                                        <th class="pb-3 font-semibold text-savora-dark">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- JSTL forEach over upcomingBookings JavaBean list --%>
                                    <c:forEach var="b" items="${upcomingBookings}">
                                        <tr class="border-b border-savora-border hover:bg-savora-cream
                                                   transition-colors duration-100">
                                            <td class="py-3 pr-4 text-savora-muted">
                                                #<c:out value="${b.bookingId}"/>
                                            </td>
                                            <td class="py-3 pr-4 font-semibold text-savora-dark">
                                                <c:out value="${b.tableNo}"/>
                                            </td>
                                            <td class="py-3 pr-4 text-savora-dark">
                                                <c:out value="${b.bookingDate}"/>
                                            </td>
                                            <td class="py-3 pr-4 text-savora-dark">
                                                <c:out value="${b.bookingTime}"/>
                                            </td>
                                            <td class="py-3 pr-4 text-savora-dark">
                                                <c:out value="${b.noOfPeople}"/>
                                            </td>
                                            <td class="py-3">
                                                <%-- Dynamic badge colour per status using JSTL choose --%>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'Confirmed'}">
                                                        <span class="inline-block text-[0.7rem] font-semibold
                                                                     px-2.5 py-0.5 rounded-full
                                                                     bg-amber-100 text-amber-700">
                                                            <c:out value="${b.status}"/>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'Completed'}">
                                                        <span class="inline-block text-[0.7rem] font-semibold
                                                                     px-2.5 py-0.5 rounded-full
                                                                     bg-green-100 text-green-700">
                                                            <c:out value="${b.status}"/>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'Cancelled'}">
                                                        <span class="inline-block text-[0.7rem] font-semibold
                                                                     px-2.5 py-0.5 rounded-full
                                                                     bg-red-100 text-red-600">
                                                            <c:out value="${b.status}"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-block text-[0.7rem] font-semibold
                                                                     px-2.5 py-0.5 rounded-full
                                                                     bg-gray-100 text-gray-600">
                                                            <c:out value="${b.status}"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div><%-- /upcoming reservations card --%>

            <%-- ── RIGHT: Savora Wallet card ──
                 JavaBean: wallet (balance)
            --%>
            <div class="bg-white rounded-2xl shadow-sm border border-savora-border p-6
                        flex flex-col justify-between">

                <div>
                    <h3 class="text-xl font-bold text-savora-dark">My Savora Wallet</h3>
                    <p class="text-xs text-savora-muted mt-0.5 mb-5">
                        Pay for reservations and menu orders seamlessly.
                    </p>

                    <%-- Balance display --%>
                    <div class="rounded-xl border border-savora-border bg-[#fdf6ee]
                                p-5 text-center">
                        <span class="block text-[0.7rem] uppercase tracking-widest text-savora-muted mb-1">
                            Available Balance
                        </span>
                        <span class="block text-3xl font-bold text-savora-dark">
                            RM<fmt:formatNumber value="${wallet.balance}" minFractionDigits="2"/>
                        </span>
                    </div>
                </div>

                <%-- CTA buttons --%>
                <div class="flex flex-col gap-3 mt-6">
                    <a href="${pageContext.request.contextPath}/wallet"
                       class="flex items-center justify-center gap-2 rounded-xl py-2.5
                              bg-savora-brown text-white font-semibold text-sm
                              hover:bg-savora-dark transition-colors duration-150">
                        <i class="fa-solid fa-wallet"></i>
                        Manage Wallet &amp; Top Up
                    </a>
                    <a href="${pageContext.request.contextPath}/history"
                       class="flex items-center justify-center gap-2 rounded-xl py-2.5
                              border border-savora-accent text-savora-accent font-semibold text-sm
                              hover:bg-savora-dark hover:text-white transition-colors duration-150">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        View Full History
                    </a>
                </div>

            </div><%-- /wallet card --%>

        </div><%-- /two-column layout --%>

    </main><%-- /main-content --%>
</div><%-- /app-shell --%>

<%-- ══════════════════════════════════════════
     JAVASCRIPT
     - Live countdown timer
     - Topbar dropdown close handler
══════════════════════════════════════════ --%>
<script>
    /* ── Live countdown ── */
    document.addEventListener("DOMContentLoaded", function () {
        var timerContainer = document.getElementById("timerContainer");
        if (!timerContainer) return;

        var targetStr  = timerContainer.getAttribute("data-target");
        var targetDate = new Date(targetStr).getTime();

        var daysEl  = document.getElementById("daysVal");
        var hoursEl = document.getElementById("hoursVal");
        var minEl   = document.getElementById("minVal");
        var secEl   = document.getElementById("secVal");

        function pad(n) { return n < 10 ? "0" + n : n; }

        function tick() {
            var distance = targetDate - Date.now();
            if (distance < 0) {
                clearInterval(timer);
                location.reload();   // refresh so JSP re-evaluates booking status
                return;
            }
            daysEl.textContent  = Math.floor(distance / 86400000);
            hoursEl.textContent = pad(Math.floor((distance % 86400000) / 3600000));
            minEl.textContent   = pad(Math.floor((distance % 3600000)  / 60000));
            secEl.textContent   = pad(Math.floor((distance % 60000)    / 1000));
        }

        var timer = setInterval(tick, 1000);
        tick(); // run immediately so there's no 1-second blank flash
    });

    /* ── Topbar user-dropdown close on outside click ── */
    document.addEventListener("click", function (e) {
        var dropdown = document.getElementById("userDropdown");
        var trigger  = document.querySelector(".user-info-text");
        if (dropdown && trigger && !trigger.contains(e.target)) {
            dropdown.classList.remove("open");
        }
    });
</script>

</body>
</html>
