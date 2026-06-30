<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Cancel Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
        <h1 class="text-3xl font-bold text-savora-dark mb-2">Cancel Booking</h1>
        <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
            Cancel your active reservations. Funds paid via Wallet will be refunded automatically.
        </p>

        <c:if test="${param.success == 'true'}">
            <div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 text-sm px-4 py-3 rounded-lg mb-4 max-w-4xl">
                <i class="fa-solid fa-circle-check"></i> Booking cancelled and refunded successfully.
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-lg mb-4 max-w-4xl">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
            </div>
        </c:if>

        <div class="bg-white rounded-xl shadow-sm border border-savora-border overflow-hidden">
            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="flex flex-col items-center justify-center py-16 text-gray-400">
                        <i class="fa-solid fa-ban text-4xl mb-4 opacity-50"></i>
                        <p class="text-sm mb-4">You have no active confirmed reservations to cancel.</p>
                        <a href="${pageContext.request.contextPath}/dashboard"
                           class="bg-savora-dark text-white text-sm px-5 py-2 rounded-lg hover:bg-savora-brown transition">
                            Back to Dashboard
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left">
                            <thead>
                                <tr class="border-b-2 border-savora-border">
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Booking ID</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Table No</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Reserved Date</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Reserved Time</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Guests</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark">Status</th>
                                    <th class="px-4 py-3 font-semibold text-savora-dark text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <tr class="border-b border-savora-border hover:bg-orange-50 transition">
                                        <td class="px-4 py-3 text-gray-600">#${b.bookingId}</td>
                                        <td class="px-4 py-3 font-semibold text-savora-dark">${b.tableNo}</td>
                                        <td class="px-4 py-3 text-gray-600">${b.bookingDate}</td>
                                        <td class="px-4 py-3 text-gray-600">${b.bookingTime}</td>
                                        <td class="px-4 py-3 text-gray-600">${b.noOfPeople}</td>
                                        <td class="px-4 py-3">
                                            <span class="inline-block text-xs font-semibold px-2.5 py-1 rounded-full bg-orange-100 text-orange-700">
                                                ${b.status}
                                            </span>
                                        </td>
                                        <td class="px-4 py-3 text-right">
                                            <button type="button"
                                                    onclick="confirmCancellation(${b.bookingId}, '${b.tableNo}', '${b.bookingDate}')"
                                                    class="text-xs font-semibold px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white rounded-lg transition">
                                                Cancel
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Cancellation Confirmation Modal -->
<div id="cancelModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center px-4">
    <div class="bg-white rounded-2xl p-8 w-full max-w-sm text-center shadow-xl">
        <i class="fa-solid fa-triangle-exclamation text-red-500 text-3xl mb-3"></i>
        <h3 class="font-serif text-xl text-savora-dark font-semibold mb-2">Confirm Cancellation</h3>
        <p class="text-sm text-gray-500 mb-1" id="modalText">Are you sure you want to cancel this booking?</p>
        <p class="text-xs text-red-500 font-semibold mb-5">
            * If you paid with your wallet, a full refund will be credited instantly.
        </p>
        <form action="${pageContext.request.contextPath}/booking/cancel" method="post">
            <input type="hidden" name="bookingId" id="cancelBookingId">
            <div class="flex gap-3">
                <button type="button" onclick="closeModal()"
                        class="flex-1 border border-savora-border text-savora-dark text-sm font-medium py-2.5 rounded-lg hover:bg-gray-50 transition">
                    Keep Booking
                </button>
                <button type="submit"
                        class="flex-1 bg-red-500 hover:bg-red-600 text-white text-sm font-semibold py-2.5 rounded-lg transition">
                    Yes, Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function confirmCancellation(bookingId, tableNo, date) {
    document.getElementById('cancelBookingId').value = bookingId;
    document.getElementById('modalText').innerHTML =
        'Cancel reservation for <strong>' + tableNo + '</strong> on <strong>' + date + '</strong>?';
    document.getElementById('cancelModal').classList.remove('hidden');
}
function closeModal() {
    document.getElementById('cancelModal').classList.add('hidden');
}
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
