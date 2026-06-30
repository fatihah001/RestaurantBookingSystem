<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>

<title>Savora Admin - Manage Users</title>

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

.user-table-container{
    background:white;
    border-radius:16px;
    padding:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
    overflow-x:auto;
}

.user-table{
    width:100%;
    border-collapse:collapse;
    min-width:1000px;
}

.user-table th{
    background:#f8f5f0;
    color:var(--savora-brown-dark);
    padding:15px;
    text-align:left;
    font-weight:700;
    border-bottom:2px solid #e6ddd2;
}

.user-table td{
    padding:15px;
    border-bottom:1px solid #eee;
    vertical-align:middle;
}

.user-table tr:hover{
    background:#faf6f0;
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

.role-admin{
    background:#d4edda;
    color:#155724;
    padding:6px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
}

.role-customer{
    background:#cce5ff;
    color:#004085;
    padding:6px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
}

.action-container{
    display:flex;
    gap:8px;
    align-items:center;
}

.btn-edit{
    background:#5c3b2e;
    color:white;
    border:none;
    padding:8px 14px;
    border-radius:8px;
    cursor:pointer;
    text-decoration:none;
}

.btn-edit:hover{
    background:#40261a;
}

.btn-delete{
    background:#dc3545;
    color:white;
    text-decoration:none;
    padding:8px 14px;
    border-radius:8px;
}

.btn-delete:hover{
    background:#bb2d3b;
}

.page-title{
    color:var(--savora-brown-dark);
    margin-bottom:20px;
}

.modal-overlay{
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.4);
    display:none;
    justify-content:center;
    align-items:center;
    z-index:999;
}

.modal-overlay.open{
    display:flex;
}

.modal-card{
    background:white;
    width:450px;
    padding:25px;
    border-radius:16px;
    box-shadow:0 10px 30px rgba(0,0,0,0.15);
}

.modal-card h3{
    margin-top:0;
    color:var(--savora-brown-dark);
}

.form-group{
    margin-bottom:15px;
}

.form-group label{
    display:block;
    margin-bottom:6px;
    font-weight:600;
}

.form-group input{
    width:100%;
    padding:10px;
    border:1px solid #ddd;
    border-radius:8px;
    box-sizing:border-box;
}

.modal-actions{
    display:flex;
    justify-content:flex-end;
    gap:10px;
    margin-top:15px;
}
</style>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body>

<%@ include file="/topbar.jsp" %>

<div class="app-shell">

<%@ include file="/sidebar.jsp" %>

<div class="main-content">

<h1 class="text-3xl font-bold text-savora-dark mb-2">Manage Users</h1>

<div class="stats-row">

    <div class="stat-card">
        <h3>${users.size()}</h3>
        <p>Total Users</p>
    </div>

    <div class="stat-card">
        <h3>${adminCount}</h3>
        <p>Admins</p>
    </div>

    <div class="stat-card">
        <h3>${staffCount != null ? staffCount : 0}</h3>
        <p>Staff</p>
    </div>

    <div class="stat-card">
        <h3>${customerCount}</h3>
        <p>Customers</p>
    </div>

</div>
<div class="search-container">
    <input type="text"
           id="searchInput"
           placeholder="Search..."
           onkeyup="searchTable()">

    <i class="fa-solid fa-magnifying-glass"></i>
</div>
        
<div class="user-table-container">

<table class="user-table" id="userTable">

<thead>

<tr>

<th>ID</th>
<th>Name</th>
<th>Username</th>
<th>Email</th>
<th>Phone</th>
<th>Role</th>
<th>Action</th>

</tr>

</thead>

<tbody>

<c:forEach var="u" items="${users}">

<tr>

<td>${u.userId}</td>

<td>${u.name}</td>

<td>${u.username}</td>

<td>${u.email}</td>

<td>${u.phoneNumber}</td>

<td>

<c:choose>

<c:when test="${u.role == 'Admin'}">

<span class="role-admin">
Admin
</span>

</c:when>

<c:when test="${u.role == 'Staff'}">

<span class="role-staff" style="background:#fff3cd; color:#856404; padding:6px 12px; border-radius:20px; font-size:12px; font-weight:600; display:inline-block;">
Staff
</span>

</c:when>

<c:otherwise>

<span class="role-customer">
Customer
</span>

</c:otherwise>

</c:choose>

</td>

<td>

<div class="action-container">

<button
class="btn-edit"
onclick="openEditModal(
'${u.userId}',
'${u.name}',
'${u.email}',
'${u.phoneNumber}',
'${u.role}'
)">

<i class="fa-solid fa-pen"></i>
Edit

</button>

<a
href="${pageContext.request.contextPath}/admin/user-delete?id=${u.userId}"
class="btn-delete"
onclick="return confirm('Delete this user?')">

<i class="fa-solid fa-trash"></i>
Delete

</a>

</div>

</td>

</tr>

</c:forEach>

</tbody>

</table>

</div>

</div>

</div>
<div class="modal-overlay" id="editModal">

<div class="modal-card">

<h3>Edit User</h3>

<form
action="${pageContext.request.contextPath}/admin/user-update"
method="post">

<input
type="hidden"
name="userId"
id="editUserId">

<div class="form-group">
<label>Name</label>

<input
type="text"
name="name"
id="editName"
required>
</div>

<div class="form-group">
<label>Email</label>

<input
type="email"
name="email"
id="editEmail"
required>
</div>

<div class="form-group">
<label>Phone Number</label>

<input
type="text"
name="phone"
id="editPhone"
required>
</div>

<div class="form-group">
<label>Role</label>
<select name="role" id="editRole" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; box-sizing:border-box;">
    <option value="Customer">Customer</option>
    <option value="Staff">Staff</option>
    <option value="Admin">Admin</option>
</select>
</div>

<div class="modal-actions">

<button
type="button"
class="btn-delete"
onclick="closeModal()">

Cancel

</button>

<button
type="submit"
class="btn-edit">

Save Changes

</button>

</div>

</form>

</div>

</div>
<script>

function searchUsers(){

    let input =
    document.getElementById("searchUser")
    .value.toLowerCase();

    let table =
    document.getElementById("userTable");

    let rows =
    table.getElementsByTagName("tr");

    for(let i=1;i<rows.length;i++){

        let text =
        rows[i].textContent.toLowerCase();

        rows[i].style.display =
            text.includes(input)
            ? ""
            : "none";
    }
}

function openEditModal(
    id,
    name,
    email,
    phone,
    role
){

    document.getElementById(
        "editUserId").value=id;

    document.getElementById(
        "editName").value=name;

    document.getElementById(
        "editEmail").value=email;

    document.getElementById(
        "editPhone").value=phone;

    document.getElementById(
        "editRole").value=role;

    document.getElementById(
        "editModal")
        .classList.add("open");
}

function closeModal(){

    document.getElementById(
        "editModal")
        .classList.remove("open");
}

</script>
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
