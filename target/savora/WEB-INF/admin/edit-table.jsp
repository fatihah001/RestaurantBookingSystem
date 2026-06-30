<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>
    <title>Edit Table</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body>

<h2>Edit Table</h2>

<form action="${pageContext.request.contextPath}/admin/table-update"
      method="post">

<input type="hidden"
       name="tableId"
       value="${table.tableId}">

<br>

Table Number

<br>

<input type="text"
       name="tableNo"
       value="${table.tableNo}">

<br><br>

Capacity

<br>

<input type="number"
       name="capacity"
       value="${table.capacity}">

<br><br>

Location

<br>

<input type="text"
       name="location"
       value="${table.location}">

<br><br>

<input type="hidden" name="status" value="${table.tableStatus}">

<button type="submit">
Update Table
</button>

</form>

</body>
</html>