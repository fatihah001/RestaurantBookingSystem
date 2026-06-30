<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora Admin - Manage Menu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .menu-header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(74, 44, 26, 0.4);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .modal-overlay.open {
            display: flex;
        }
        .modal-content-card {
            background-color: white;
            border-radius: 16px;
            width: 100%;
            max-width: 480px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            position: relative;
            box-sizing: border-box;
            max-height: 85vh;
            overflow-y: auto;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            border-bottom: 1px solid var(--savora-border);
            padding-bottom: 10px;
        }
        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--savora-brown-dark);
        }
        .modal-close-btn {
            background: none;
            border: none;
            font-size: 1.2rem;
            color: #8a7a6a;
            cursor: pointer;
        }
        .modal-close-btn:hover {
            color: var(--savora-brown-dark);
        }
        .form-group {
            margin-bottom: 14px;
        }
        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--savora-brown-dark);
            margin-bottom: 6px;
        }
        .form-input-field {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--savora-border);
            border-radius: 8px;
            background-color: #faf6f0;
            color: var(--savora-text-dark);
            font-size: 0.9rem;
            box-sizing: border-box;
        }
        .form-input-field:focus {
            border-color: var(--savora-brown);
            outline: none;
        }
        
        /* Custom File Upload */
        .file-upload-container {
            position: relative;
            cursor: pointer;
        }
        .file-upload-wrapper {
            display: flex;
            align-items: center;
            border: 1px solid var(--savora-border);
            border-radius: 8px;
            background-color: #faf6f0;
            overflow: hidden;
            height: 38px;
            box-sizing: border-box;
        }
        .file-upload-btn {
            background-color: #eae0d3;
            border: none;
            border-right: 1px solid var(--savora-border);
            padding: 0 16px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--savora-brown-dark);
        }
        .file-name-label {
            padding: 0 12px;
            font-size: 0.8rem;
            color: var(--savora-text-dark);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex-grow: 1;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: var(--savora-text-dark);
            margin-top: 10px;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 20px;
        }
        .btn-modal {
            padding: 10px 24px;
            font-size: 0.88rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            border: none;
        }
        .btn-modal-cancel {
            background-color: white;
            border: 1px solid var(--savora-border);
            color: var(--savora-brown-dark);
        }
        .btn-modal-save {
            background-color: var(--savora-brown-dark);
            color: white;
        }
        .btn-modal-save:hover {
            background-color: #3b2214;
        }
        .btn-modal-cancel:hover {
            background-color: #faf6f0;
        }
        .btn-modal-delete {
            background-color: #c0392b;
            color: white;
        }
        .btn-modal-delete:hover {
            background-color: #a93226;
        }
        .delete-modal-box {
            animation: popIn 0.2s ease;
        }
        @keyframes popIn {
            from { transform: scale(0.85); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
        }
    </style>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<%@ include file="/topbar.jsp" %>

<div class="app-shell">
    <%@ include file="/sidebar.jsp" %>

    <div class="main-content">
        <div class="menu-header-bar">
            <h1 class="text-3xl font-bold text-savora-dark mb-2">Manage Menu</h1>
            <button class="btn btn-primary" onclick="openAddModal()" style="border-radius: 20px; padding: 8px 18px; font-weight: 600;">+ Add Menu</button>
        </div>

        <div class="category-tabs">
            <a href="${pageContext.request.contextPath}/admin/menu?category=All"
               class="category-tab ${selectedCategory == 'All' ? 'active' : ''}">All</a>
            <a href="${pageContext.request.contextPath}/admin/menu?category=Food"
               class="category-tab ${selectedCategory == 'Food' ? 'active' : ''}"><i class="fa-solid fa-drumstick-bite"></i> Food</a>
            <a href="${pageContext.request.contextPath}/admin/menu?category=Beverages"
               class="category-tab ${selectedCategory == 'Beverages' ? 'active' : ''}"><i class="fa-solid fa-mug-saucer"></i> Beverages</a>
            <a href="${pageContext.request.contextPath}/admin/menu?category=Desserts"
               class="category-tab ${selectedCategory == 'Desserts' ? 'active' : ''}"><i class="fa-solid fa-ice-cream"></i> Desserts</a>
        </div>

        <c:if test="${empty menuItems}">
            <div class="empty-state">
                <i class="fa-solid fa-utensils"></i>
                <p>No menu items found in this category.</p>
            </div>
        </c:if>

        <div class="menu-grid">
            <c:forEach var="item" items="${menuItems}">
                <div class="menu-card">
                    <div class="menu-img" style="background-image: url('${pageContext.request.contextPath}/${item.imageUrl}');">
                        <span class="badge-tag">${item.category}</span>
                    </div>
                    <div class="menu-body" style="padding: 16px; display: flex; flex-direction: column; gap: 8px;">
                        <div class="menu-name" style="font-weight: 700; font-size: 1.05rem; color: var(--savora-brown-dark);">${item.itemName}</div>
                        <div style="font-size: 0.78rem; color: #8a7a6a;">${item.category}</div>
                        <div style="font-weight: 600; color: var(--savora-accent); font-size: 1rem; margin-top: 4px;">
                            RM<fmt:formatNumber value="${item.itemPrice}" minFractionDigits="2"/>
                            <c:if test="${!item.available}">
                                <span class="stock-badge sold-out" style="margin-left: 8px; font-size: 0.7rem; padding: 2px 6px;">Unavailable</span>
                            </c:if>
                        </div>
                        
                        <div style="display: flex; gap: 10px; margin-top: 12px;">
                            <button type="button" class="btn btn-primary" style="flex: 1; padding: 8px; font-size: 0.8rem; border-radius: 6px;"
                                    onclick="openEditModal(this)"
                                    data-id="${item.menuId}"
                                    data-name="${item.itemName}"
                                    data-category="${item.category}"
                                    data-price="${item.itemPrice}"
                                    data-description="${item.description}"
                                    data-available="${item.available}"
                                    data-image="${item.imageUrl}">
                                Edit
                            </button>
                            <button type="button" class="btn btn-danger" style="flex: 1; padding: 8px; font-size: 0.8rem; border-radius: 6px; border:none; cursor:pointer;"
                                    onclick="openDeleteModal('${item.menuId}', '${item.itemName}')">
                                Delete
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Add / Edit Modal Overlay -->
<div class="modal-overlay" id="menuItemModal">
    <div class="modal-content-card">
        <div class="modal-header">
            <span class="modal-title" id="modalTitle">Add Menu Item</span>
            <button class="modal-close-btn" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/menu" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" id="modalAction" value="add">
            <input type="hidden" name="menuId" id="modalMenuId" value="">

            <div class="form-group">
                <label for="itemName">Item Name</label>
                <input type="text" name="itemName" id="itemName" class="form-input-field" required placeholder="e.g. Classic Caesar Salad">
            </div>

            <div class="form-group">
                <label for="category">Category</label>
                <select name="category" id="category" class="form-input-field" required>
                    <option value="Food">Food</option>
                    <option value="Beverages">Beverages</option>
                    <option value="Desserts">Desserts</option>
                </select>
            </div>

            <div class="form-group">
                <label for="price">Price (RM)</label>
                <input type="number" name="price" id="price" class="form-input-field" required step="0.01" min="0" placeholder="0.00">
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea name="description" id="description" class="form-input-field" rows="3" required placeholder="Describe the culinary creation..."></textarea>
            </div>

            <div class="form-group">
                <label>Upload Image</label>
                <div class="file-upload-container" onclick="document.getElementById('imageInput').click()">
                    <div class="file-upload-wrapper">
                        <div class="file-upload-btn"><i class="fa-solid fa-upload"></i> Choose File</div>
                        <div class="file-name-label" id="fileNameLabel">No file chosen</div>
                    </div>
                </div>
                <input type="file" name="image" id="imageInput" accept="image/*" style="display: none;" onchange="handleFileChange(this)">
                <small style="color: #8a7a6a; font-size: 0.72rem; margin-top: 4px; display: block;" id="uploadNotice">Choose a photo for the menu item.</small>
            </div>

            <!-- Dynamic Image Preview -->
            <div class="form-group" id="previewContainer" style="display: none; text-align: center;">
                <label style="text-align: left;">Selected Image Preview</label>
                <img id="imagePreview" src="" alt="Selected Preview" style="max-height: 120px; border-radius: 8px; border: 1px solid var(--savora-border); margin-top: 5px;">
            </div>

            <div class="checkbox-group">
                <input type="checkbox" name="available" id="available" value="true" checked>
                <label for="available" style="font-weight: 600; color: var(--savora-brown-dark); cursor: pointer;">Available</label>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-modal btn-modal-cancel" onclick="closeModal()">Cancel</button>
                <button type="submit" class="btn-modal btn-modal-save" id="modalSaveBtn">Save</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-content-card delete-modal-box" style="max-width: 400px; text-align: center;">
        <div style="margin-bottom: 14px;">
            <i class="fa-solid fa-trash-can" style="font-size: 2rem; color: #c0392b;"></i>
        </div>
        <h3 style="margin: 0 0 8px; font-size: 1.15rem; color: var(--savora-brown-dark);">Delete Menu Item?</h3>
        <p style="font-size: 0.85rem; color: #8a7a6a; margin: 0 0 20px;">
            You are about to delete <strong id="deleteItemName"></strong>. This action cannot be undone.
        </p>
        <div style="display: flex; gap: 10px;">
            <button type="button" class="btn-modal btn-modal-cancel" style="flex:1;" onclick="closeDeleteModal()">Cancel</button>
            <button type="button" class="btn-modal btn-modal-delete" style="flex:1;" onclick="confirmDelete()">Yes, Delete</button>
        </div>
    </div>
</div>

<!-- Hidden delete form submitted by JS -->
<form id="deleteForm" action="${pageContext.request.contextPath}/admin/menu" method="post" style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="menuId" id="deleteMenuId" value="">
</form>

<script>

function openDeleteModal(menuId, itemName) {
    document.getElementById('deleteMenuId').value = menuId;
    document.getElementById('deleteItemName').textContent = '"' + itemName + '"';
    document.getElementById('deleteModal').classList.add('open');
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.remove('open');
}

function confirmDelete() {
    document.getElementById('deleteForm').submit();
}

function openAddModal() {
    document.getElementById('modalTitle').textContent = 'Add Menu Item';
    document.getElementById('modalAction').value = 'add';
    document.getElementById('modalMenuId').value = '';
    
    
    document.getElementById('itemName').value = '';
    document.getElementById('category').value = 'Food';
    document.getElementById('price').value = '';
    document.getElementById('description').value = '';
    document.getElementById('imageInput').value = '';
    document.getElementById('fileNameLabel').textContent = 'No file chosen';
    document.getElementById('available').checked = true;
    
    
    document.getElementById('previewContainer').style.display = 'none';
    document.getElementById('imagePreview').src = '';
    
    document.getElementById('uploadNotice').textContent = 'Choose a photo for the menu item.';
    
    
    document.getElementById('menuItemModal').classList.add('open');
}


function openEditModal(btn) {
    document.getElementById('modalTitle').textContent = 'Edit Menu Item';
    document.getElementById('modalAction').value = 'edit';
    
    // Fetch values from data attributes
    const menuId = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const category = btn.getAttribute('data-category');
    const price = btn.getAttribute('data-price');
    const desc = btn.getAttribute('data-description');
    const available = btn.getAttribute('data-available') === 'true';
    const image = btn.getAttribute('data-image');
    
    document.getElementById('modalMenuId').value = menuId;
    document.getElementById('itemName').value = name;
    document.getElementById('category').value = category;
    document.getElementById('price').value = price;
    document.getElementById('description').value = desc;
    document.getElementById('imageInput').value = '';
    document.getElementById('available').checked = available;
    
    document.getElementById('uploadNotice').textContent = 'Leave empty to keep the current image.';
    
    if (image && image !== '') {
        const fullImagePath = '${pageContext.request.contextPath}/' + image;
        document.getElementById('imagePreview').src = fullImagePath;
        document.getElementById('previewContainer').style.display = 'block';
        document.getElementById('fileNameLabel').textContent = image.substring(image.lastIndexOf('/') + 1);
    } else {
        document.getElementById('previewContainer').style.display = 'none';
        document.getElementById('imagePreview').src = '';
        document.getElementById('fileNameLabel').textContent = 'No file chosen';
    }
    
    
    document.getElementById('menuItemModal').classList.add('open');
}


function closeModal() {
    document.getElementById('menuItemModal').classList.remove('open');
}


function handleFileChange(input) {
    const fileLabel = document.getElementById('fileNameLabel');
    const previewContainer = document.getElementById('previewContainer');
    const previewImg = document.getElementById('imagePreview');
    
    if (input.files && input.files[0]) {
        const file = input.files[0];
        fileLabel.textContent = file.name;
        
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewContainer.style.display = 'block';
        };
        reader.readAsDataURL(file);
    } else {
        fileLabel.textContent = 'No file chosen';
        
        const isEdit = document.getElementById('modalAction').value === 'edit';
        if (!isEdit) {
            previewContainer.style.display = 'none';
            previewImg.src = '';
        }
    }
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
