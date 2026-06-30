<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - My Profile</title>
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
        <h2 style="margin-top:0; font-family: Georgia, serif; color: var(--savora-brown-dark);">My Profile</h2>
        <p style="color:#8a7a6a; margin-top:-6px; margin-bottom:24px; font-size:0.9rem;">
            View and update your personal information.
        </p>

        <c:if test="${not empty success}">
            <div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 text-sm px-4 py-3 rounded-lg mb-4 max-w-xl">
                <i class="fa-solid fa-circle-check"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-lg mb-4 max-w-xl">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
            </div>
        </c:if>

        <div class="bg-white rounded-xl shadow-sm border border-savora-border max-w-xl p-6">
            <h3 class="font-serif text-lg text-savora-dark font-semibold border-b border-savora-border pb-3 mb-5">
                Personal Details
            </h3>

            <form action="${pageContext.request.contextPath}/profile" method="post" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                    <input type="text" value="${user.username}" readonly
                           class="w-full border border-savora-border rounded-lg px-4 py-2.5 text-sm bg-gray-100 text-gray-400 cursor-not-allowed">
                    <p class="text-xs text-gray-400 mt-1">Username cannot be changed.</p>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="name" value="<c:out value='${user.name}'/>" required
                           class="w-full border border-savora-border rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-savora-accent transition">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email Address <span class="text-red-500">*</span></label>
                    <input type="email" name="email" value="<c:out value='${user.email}'/>" required
                           class="w-full border border-savora-border rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-savora-accent transition">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                    <input type="text" name="phoneNumber" value="<c:out value='${user.phoneNumber}'/>"
                           class="w-full border border-savora-border rounded-lg px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-savora-accent transition">
                </div>
                <div class="flex gap-3 pt-2">
                    <button type="submit"
                            class="bg-savora-dark hover:bg-savora-brown text-white text-sm font-semibold px-6 py-2.5 rounded-lg transition">
                        Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="border border-savora-border text-savora-dark text-sm font-medium px-6 py-2.5 rounded-lg hover:bg-gray-50 transition">
                        Cancel
                    </a>
                </div>
            </form>
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
