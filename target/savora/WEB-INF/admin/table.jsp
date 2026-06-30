<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Savora Admin - Manage Tables</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/style.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>

.table-header-bar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
}

.table-grid{
    display:grid;
    grid-template-columns:
    repeat(auto-fill,minmax(280px,1fr));
    gap:20px;
}

.table-card{
    background:white;
    border-radius:16px;
    padding:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
    transition:0.3s;
}

.table-card:hover{
    transform:translateY(-4px);
}

.table-number{
    font-size:1.3rem;
    font-weight:700;
    color:var(--savora-brown-dark);
}

.table-info{
    margin-top:15px;
}

.table-info p{
    margin:8px 0;
    color:#6f6255;
}

.status-badge{
    display:inline-block;
    padding:6px 12px;
    border-radius:20px;
    font-size:0.75rem;
    font-weight:600;
    margin-top:10px;
}

.available{
    background:#d4edda;
    color:#155724;
}

.reserved{
    background:#fff3cd;
    color:#856404;
}

.occupied{
    background:#f8d7da;
    color:#721c24;
}

/* Modal */

.modal-overlay{
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background-color:rgba(74,44,26,0.4);
    backdrop-filter:blur(4px);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:1000;
}

.modal-overlay.open{
    display:flex;
}

.modal-content-card{
    background:white;
    border-radius:16px;
    width:100%;
    max-width:500px;
    padding:24px;
    box-shadow:0 10px 25px rgba(0,0,0,0.15);
}

.modal-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:18px;
}

.modal-title{
    font-size:1.2rem;
    font-weight:700;
    color:var(--savora-brown-dark);
}

.modal-close-btn{
    background:none;
    border:none;
    cursor:pointer;
    font-size:1.2rem;
}

.form-group{
    margin-bottom:15px;
}

.form-group label{
    display:block;
    margin-bottom:6px;
    font-weight:600;
    color:var(--savora-brown-dark);
}

.form-input-field{
    width:100%;
    padding:10px;
    border:1px solid #ddd;
    border-radius:8px;
    box-sizing:border-box;
}

.modal-footer{
    display:flex;
    justify-content:flex-end;
    gap:10px;
    margin-top:20px;
}

.btn-modal{
    padding:10px 20px;
    border:none;
    border-radius:8px;
    cursor:pointer;
}

.btn-modal-cancel{
    background:#e5e5e5;
}

.btn-modal-save{
    background:var(--savora-brown-dark);
    color:white;
}

.action-buttons{
    display:flex;
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

<div class="table-header-bar">

<h1 class="text-3xl font-bold text-savora-dark mb-2">Manage Table</h1>

<button
class="btn btn-primary"
onclick="openAddModal()">

+ Add Table

</button>

</div>

<div class="table-grid">

<c:forEach var="t" items="${tables}">

<div class="table-card">

<div class="table-number">

<i class="fa-solid fa-chair"></i>

 ${t.tableNo}

</div>

<div class="table-info">

<p>
<b>Capacity:</b>
${t.capacity} Persons
</p>

<p>
<b>Location:</b>
${t.location}
</p>

</div>



<div class="action-buttons">

<button
class="btn btn-primary"
style="flex:1;"

onclick="openEditModal(this)"

data-id="${t.tableId}"
data-table="${t.tableNo}"
data-capacity="${t.capacity}"
data-location="${t.location}"
data-status="${t.tableStatus}">

Edit

</button>

<button
type="button"
class="btn btn-danger"
style="flex:1; text-align:center;"

onclick="openDeleteModal('${t.tableId}', '${t.tableNo}')">

Delete

</button>

</div>

</div>

</c:forEach>

</div>

</div>

</div>

<!-- MODAL -->

<div class="modal-overlay" id="tableModal">

<div class="modal-content-card">

<div class="modal-header">

<span class="modal-title"
id="modalTitle">

Add Table

</span>

<button
type="button"
class="modal-close-btn"
onclick="closeModal()">

<i class="fa-solid fa-xmark"></i>

</button>

</div>

<form
id="tableForm"
action="${pageContext.request.contextPath}/admin/table-add"
method="post">

<input
type="hidden"
name="tableId"
id="tableId">

<div class="form-group">

<label>Table Number</label>

<input
type="text"
name="tableNo"
id="tableNo"
class="form-input-field"
required>

</div>

<div class="form-group">

<label>Capacity</label>

<input
type="number"
name="capacity"
id="capacity"
class="form-input-field"
required>

</div>

<div class="form-group">

<label>Location</label>

<input
type="text"
name="location"
id="location"
class="form-input-field"
required>

</div>

<input
type="hidden"
name="status"
id="status">

<div class="modal-footer">

<button
type="button"
class="btn-modal btn-modal-cancel"
onclick="closeModal()">

Cancel

</button>

<button
type="submit"
class="btn-modal btn-modal-save">

Save

</button>

</div>

</form>

</div>

</div>

<!-- DELETE CONFIRM MODAL -->

<div class="modal-overlay" id="deleteModal">

<div class="modal-content-card" style="max-width:400px;">

<div class="modal-header">

<span class="modal-title"
id="deleteModalTitle">

Delete Table

</span>

<button
type="button"
class="modal-close-btn"
onclick="closeDeleteModal()">

<i class="fa-solid fa-xmark"></i>

</button>

</div>

<p style="color:#6f6255; margin:0 0 4px;" id="deleteModalMessage">

Are you sure you want to delete this table?

</p>

<p style="color:#a23b38; font-size:0.85rem; margin:0 0 10px;">

This action cannot be undone.

</p>

<div class="modal-footer">

<button
type="button"
class="btn-modal btn-modal-cancel"
onclick="closeDeleteModal()">

Cancel

</button>

<a
id="confirmDeleteLink"
href="#"
class="btn-modal"
style="background:var(--savora-danger); color:white; text-align:center; text-decoration:none; display:inline-block;">

Delete

</a>

</div>

</div>

</div>

<script>

function openAddModal(){

document.getElementById('modalTitle').innerText =
'Add Table';

document.getElementById('tableForm').action =
'${pageContext.request.contextPath}/admin/table-add';

document.getElementById('tableId').value='';
document.getElementById('tableNo').value='';
document.getElementById('capacity').value='';
document.getElementById('location').value='';
document.getElementById('status').value='Available';

document.getElementById('tableModal')
.classList.add('open');
}

function openEditModal(btn){

document.getElementById('modalTitle').innerText =
'Edit Table';

document.getElementById('tableForm').action =
'${pageContext.request.contextPath}/admin/table-update';

document.getElementById('tableId').value =
btn.dataset.id;

document.getElementById('tableNo').value =
btn.dataset.table;

document.getElementById('capacity').value =
btn.dataset.capacity;

document.getElementById('location').value =
btn.dataset.location;

document.getElementById('status').value =
btn.dataset.status;

document.getElementById('tableModal')
.classList.add('open');
}

function closeModal(){

document.getElementById('tableModal')
.classList.remove('open');
}

function openDeleteModal(tableId, tableNo){

document.getElementById('deleteModalMessage').innerText =
'Are you sure you want to delete ' + tableNo + '?';

document.getElementById('confirmDeleteLink').href =
'${pageContext.request.contextPath}/admin/table-delete?id=' + tableId;

document.getElementById('deleteModal')
.classList.add('open');
}

function closeDeleteModal(){

document.getElementById('deleteModal')
.classList.remove('open');
}

</script>

</body>
</html>