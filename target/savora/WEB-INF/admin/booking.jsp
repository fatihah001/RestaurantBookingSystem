<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>

<title>Savora Admin - View Booking</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/style.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
.search-container{
    position:relative;
    margin-bottom:20px;
    width:350px;
}

.search-container input{
    width:100%;
    padding:12px 40px 12px 15px;
    border:1px solid #ddd;
    border-radius:10px;
    font-size:14px;
}

.search-container i{
    position:absolute;
    right:15px;
    top:14px;
    color:#999;
}

.booking-table-container{
    background:white;
    border-radius:16px;
    padding:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
    overflow-x:auto;
}

.booking-table{
    width:100%;
    border-collapse:collapse;
    min-width:1100px;
}

.booking-table th{
    background:#f8f5f0;
    color:var(--savora-brown-dark);
    padding:15px;
    font-weight:700;
    text-align:left;
    border-bottom:2px solid #e6ddd2;
}

.booking-table td{
    padding:15px;
    border-bottom:1px solid #eee;
    vertical-align:middle;
}

.booking-table tr:hover{
    background:#faf6f0;
}

.status{
    display:inline-flex;
    align-items:center;
    gap:6px;

    padding:7px 14px;
    border-radius:20px;

    font-size:12px;
    font-weight:600;
}

.confirmed{
    background:#d4edda;
    color:#155724;
}

.completed{
    background:#cce5ff;
    color:#004085;
}

.cancelled{
    background:#f8d7da;
    color:#721c24;
}

.stats-row{
    display:flex;
    gap:20px;
    margin-bottom:20px;
}

.stat-card{
    background:white;
    padding:20px;
    border-radius:16px;
    min-width:220px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
}

.stat-card h3{
    margin:0;
    color:var(--savora-brown-dark);
    font-size:2rem;
}

.stat-card p{
    margin-top:8px;
    color:#8a7a6a;
}

/* ACTION AREA */

.action-container{
    display:flex;
    align-items:center;
    gap:8px;
    flex-wrap:wrap;
}

.action-container select{
    padding:8px;
    border:1px solid #ddd;
    border-radius:8px;
    min-width:120px;
}

.btn-save{
    background:#5c3b2e;
    color:white;
    border:none;
    padding:8px 14px;
    border-radius:8px;
    cursor:pointer;
    font-size:13px;
}

.btn-save:hover{
    background:#40261a;
}

.btn-delete{
    background:#dc3545;
    color:white;
    text-decoration:none;
    padding:8px 14px;
    border-radius:8px;
    font-size:13px;
    display:inline-block;
}

.btn-delete:hover{
    background:#bb2d3b;
}

</style>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body>

<%@ include file="/topbar.jsp" %>

<div class="app-shell">

<%@ include file="/sidebar.jsp" %>

<div class="main-content">
<h1 class="text-3xl font-bold text-savora-dark mb-2">View Booking</h1>
<div class="stats-row">

    <div class="stat-card">
        <h3>${bookings.size()}</h3>
        <p>Total Bookings</p>
    </div>

</div>
<div class="search-container">
    <input type="text"
           id="searchInput"
           placeholder="Search..."
           onkeyup="searchTable()">

    <i class="fa-solid fa-magnifying-glass"></i>
</div>
<div class="booking-table-container">

<table class="booking-table">

<thead>

<tr>
    <th>ID</th>
    <th>Customer</th>
    <th>Table</th>
    <th>Date</th>
    <th>Time</th>
    <th>Guests</th>
    <th>Status</th>
</tr>

</thead>

<tbody>

<c:forEach var="b" items="${bookings}">

<tr>

<td>${b.bookingId}</td>
<td>${b.customerName}</td>
<td>${b.tableNo}</td>
<td>${b.bookingDate}</td>
<td>${b.bookingTime}</td>
<td>${b.noOfPeople}</td>

<td>

<c:choose>

<c:when test="${b.status=='Confirmed'}">
    <span class="status confirmed">
        <i class="fa-solid fa-circle-check"></i>
        Confirmed
    </span>
</c:when>

<c:when test="${b.status=='Completed'}">
    <span class="status completed">
        <i class="fa-solid fa-flag-checkered"></i>
        Completed
    </span>
</c:when>

<c:otherwise>
    <span class="status cancelled">
        <i class="fa-solid fa-circle-xmark"></i>
        Cancelled
    </span>
</c:otherwise>

</c:choose>

</td>



</tr>

</c:forEach>

</tbody>

</table>

</div>
</div>
        <script>

function searchTable(){

let input =
document.getElementById("searchInput");

let filter =
input.value.toUpperCase();

let table =
document.querySelector("table");

let tr =
table.getElementsByTagName("tr");

for(let i=1;i<tr.length;i++){

let txtValue =
tr[i].textContent ||
tr[i].innerText;

tr[i].style.display =
txtValue.toUpperCase().indexOf(filter)>-1
? ""
: "none";

}

}

</script>
</body>

</html>