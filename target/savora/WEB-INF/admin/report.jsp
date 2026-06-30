<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora Admin - Reports</title>
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

        <h1 class="text-3xl font-bold text-savora-dark mb-2">Generate Reports</h1>
        <p class="text-sm text-gray-400 mt-1 mb-6">Overview of bookings and users across the system.</p>

        <!-- Stats Grid -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <div class="flex items-center justify-between mb-3">
                    <p class="text-sm font-semibold text-gray-600">Total Bookings</p>
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white text-base" style="background:#8B5E3C;">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                </div>
                <p class="text-3xl font-bold text-savora-dark">${bookingCount}</p>
                <p class="text-xs text-gray-400 mt-1">Total booking records</p>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <div class="flex items-center justify-between mb-3">
                    <p class="text-sm font-semibold text-gray-600">Total Users</p>
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white text-base" style="background:#4F6F52;">
                        <i class="fa-solid fa-users"></i>
                    </div>
                </div>
                <p class="text-3xl font-bold text-savora-dark">${userCount}</p>
                <p class="text-xs text-gray-400 mt-1">Registered users</p>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <div class="flex items-center justify-between mb-3">
                    <p class="text-sm font-semibold text-gray-600">Confirmed</p>
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white text-base" style="background:#198754;">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                </div>
                <p class="text-3xl font-bold text-savora-dark">${confirmedCount}</p>
                <p class="text-xs text-gray-400 mt-1">Active bookings</p>
            </div>

            <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-5">
                <div class="flex items-center justify-between mb-3">
                    <p class="text-sm font-semibold text-gray-600">Completed</p>
                    <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white text-base" style="background:#0d6efd;">
                        <i class="fa-solid fa-check-double"></i>
                    </div>
                </div>
                <p class="text-3xl font-bold text-savora-dark">${completedCount}</p>
                <p class="text-xs text-gray-400 mt-1">Finished bookings</p>
            </div>

        </div>

        <!-- Report Summary Table + Buttons -->
        <div class="bg-white rounded-2xl border border-savora-border shadow-sm p-6">
            <h3 class="font-serif text-base font-semibold text-savora-dark mb-4">Report Summary</h3>

            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <tbody>
                        <tr class="border-b border-savora-border">
                            <td class="py-3 text-gray-500 w-1/2">Total Users</td>
                            <td class="py-3 font-bold text-savora-dark">${userCount}</td>
                        </tr>
                        <tr class="border-b border-savora-border">
                            <td class="py-3 text-gray-500">Admins</td>
                            <td class="py-3 font-bold text-savora-dark">${adminCount}</td>
                        </tr>
                        <tr class="border-b border-savora-border">
                            <td class="py-3 text-gray-500">Customers</td>
                            <td class="py-3 font-bold text-savora-dark">${customerCount}</td>
                        </tr>
                        <tr class="border-b border-savora-border">
                            <td class="py-3 text-gray-500">Confirmed Bookings</td>
                            <td class="py-3 font-bold text-savora-dark">${confirmedCount}</td>
                        </tr>
                        <tr class="border-b border-savora-border">
                            <td class="py-3 text-gray-500">Completed Bookings</td>
                            <td class="py-3 font-bold text-savora-dark">${completedCount}</td>
                        </tr>
                        <tr>
                            <td class="py-3 text-gray-500">Cancelled Bookings</td>
                            <td class="py-3 font-bold text-savora-dark">${cancelledCount}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Generate Buttons -->
            <div class="flex flex-wrap gap-3 mt-6">
                <button onclick="printBookingReport()"
                        class="flex items-center gap-2 bg-savora-dark hover:bg-savora-brown text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition">
                    <i class="fa-solid fa-file-lines"></i> Booking Report
                </button>
                <button onclick="printUserReport()"
                        class="flex items-center gap-2 bg-savora-dark hover:bg-savora-brown text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition">
                    <i class="fa-solid fa-users"></i> User Report
                </button>
                <button onclick="printSummaryReport()"
                        class="flex items-center gap-2 bg-savora-dark hover:bg-savora-brown text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition">
                    <i class="fa-solid fa-print"></i> Print Summary
                </button>
            </div>
        </div>

    </div>
</div>

<script>
var bCount    = '${bookingCount}';
var uCount    = '${userCount}';
var aCount    = '${adminCount}';
var cCount    = '${customerCount}';
var confirmed = '${confirmedCount}';
var completed = '${completedCount}';
var cancelled = '${cancelledCount}';

function openReport(title, tableHtml) {
    var w = window.open('', title, 'width=820,height=600');
    var s = '<style>';
    s += '* { box-sizing: border-box; margin: 0; padding: 0; }';
    s += 'body { font-family: Arial, sans-serif; padding: 40px; color: #333; }';
    s += 'h2 { text-align: center; color: #4a2c1a; font-size: 22px; margin-bottom: 6px; }';
    s += 'p.subtitle { text-align: center; color: #888; font-size: 13px; margin-bottom: 24px; }';
    s += 'table { width: 100%; border-collapse: collapse; margin-top: 10px; }';
    s += 'th, td { border: 1px solid #ddd; padding: 10px 14px; font-size: 13px; text-align: left; }';
    s += 'th { background: #f5ede3; color: #4a2c1a; font-weight: 600; }';
    s += 'tr:nth-child(even) td { background: #fdf8f3; }';
    s += '.footer { margin-top: 30px; text-align: center; font-size: 11px; color: #aaa; }';
    s += '</style>';
    w.document.write('<html><head><title>' + title + '</title>' + s + '</head><body>');
    w.document.write('<h2>Savora Restaurant</h2>');
    w.document.write('<p class="subtitle">' + title + ' &mdash; Generated on ' + new Date().toLocaleString() + '</p>');
    w.document.write(tableHtml);
    w.document.write('<div class="footer">Savora Restaurant Management System</div>');
    w.document.write('</body></html>');
    w.document.close();
    w.print();
}

function printBookingReport() {
    openReport('Booking Report',
        '<table>' +
        '<tr><th>Metric</th><th>Value</th></tr>' +
        '<tr><td>Total Bookings</td><td>' + bCount + '</td></tr>' +
        '<tr><td>Confirmed</td><td>' + confirmed + '</td></tr>' +
        '<tr><td>Completed</td><td>' + completed + '</td></tr>' +
        '<tr><td>Cancelled</td><td>' + cancelled + '</td></tr>' +
        '</table>'
    );
}

function printUserReport() {
    openReport('User Report',
        '<table>' +
        '<tr><th>Metric</th><th>Value</th></tr>' +
        '<tr><td>Total Users</td><td>' + uCount + '</td></tr>' +
        '<tr><td>Admins</td><td>' + aCount + '</td></tr>' +
        '<tr><td>Customers</td><td>' + cCount + '</td></tr>' +
        '</table>'
    );
}

function printSummaryReport() {
    openReport('Summary Report',
        '<table>' +
        '<tr><th>Metric</th><th>Value</th></tr>' +
        '<tr><td>Total Users</td><td>' + uCount + '</td></tr>' +
        '<tr><td>Admins</td><td>' + aCount + '</td></tr>' +
        '<tr><td>Customers</td><td>' + cCount + '</td></tr>' +
        '<tr><td>Confirmed Bookings</td><td>' + confirmed + '</td></tr>' +
        '<tr><td>Completed Bookings</td><td>' + completed + '</td></tr>' +
        '<tr><td>Cancelled Bookings</td><td>' + cancelled + '</td></tr>' +
        '</table>'
    );
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
