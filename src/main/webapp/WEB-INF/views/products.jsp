<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">Product Management</a>
            <div class="navbar-nav">
                <a class="nav-link" href="/">Home</a>
                <a class="nav-link active" href="/products">Products</a>
                <a class="nav-link" href="/users">Users</a>
                <a class="nav-link" href="/categories">Categories</a>
                <a class="nav-link" href="/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">Quản lý sản phẩm</h1>
                
                <!-- Filter Controls -->
                <div class="row mb-3">
                    <div class="col-md-4">
                        <button class="btn btn-primary" onclick="loadAllProducts()">Tất cả sản phẩm</button>
                        <button class="btn btn-success" onclick="loadProductsSortedByPrice()">Sắp xếp theo giá</button>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" id="categoryFilter" onchange="filterByCategory()">
                            <option value="">Chọn danh mục</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#productModal" onclick="openCreateModal()">
                            Thêm sản phẩm mới
                        </button>
                    </div>
                </div>
                
                <!-- Products Table -->
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Mô tả</th>
                                <th>Giá</th>
                                <th>Người tạo</th>
                                <th>Danh mục</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="productsTableBody">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Product Modal -->
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalTitle">Thêm sản phẩm mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="productForm">
                        <input type="hidden" id="productId">
                        <div class="mb-3">
                            <label for="productTitle" class="form-label">Tên sản phẩm</label>
                            <input type="text" class="form-control" id="productTitle" required>
                        </div>
                        <div class="mb-3">
                            <label for="productQuantity" class="form-label">Số lượng</label>
                            <input type="number" class="form-control" id="productQuantity" required>
                        </div>
                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="productDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="productPrice" class="form-label">Giá</label>
                            <input type="number" step="0.01" class="form-control" id="productPrice" required>
                        </div>
                        <div class="mb-3">
                            <label for="productUser" class="form-label">Người tạo</label>
                            <select class="form-select" id="productUser">
                                <option value="">Chọn người tạo</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="productCategories" class="form-label">Danh mục</label>
                            <select class="form-select" id="productCategories" multiple>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveProduct()">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let isEditMode = false;
        
        // GraphQL endpoint
        const GRAPHQL_URL = '/graphql';
        
        // Load initial data
        $(document).ready(function() {
            loadAllProducts();
            loadCategories();
            loadUsers();
        });
        
        // GraphQL query function
        async function graphqlQuery(query, variables = {}) {
            try {
                const response = await fetch(GRAPHQL_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        query: query,
                        variables: variables
                    })
                });
                
                const result = await response.json();
                if (result.errors) {
                    console.error('GraphQL errors:', result.errors);
                    alert('Có lỗi xảy ra: ' + result.errors[0].message);
                    return null;
                }
                return result.data;
            } catch (error) {
                console.error('Network error:', error);
                alert('Lỗi kết nối: ' + error.message);
                return null;
            }
        }
        
        // Load all products
        async function loadAllProducts() {
            const query = `
                query {
                    getAllProducts {
                        id
                        title
                        quantity
                        description
                        price
                        user {
                            id
                            fullname
                        }
                        categories {
                            id
                            name
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                displayProducts(data.getAllProducts);
            }
        }
        
        // Load products sorted by price
        async function loadProductsSortedByPrice() {
            const query = `
                query {
                    getProductsSortedByPrice {
                        id
                        title
                        quantity
                        description
                        price
                        user {
                            id
                            fullname
                        }
                        categories {
                            id
                            name
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                displayProducts(data.getProductsSortedByPrice);
            }
        }
        
        // Filter products by category
        async function filterByCategory() {
            const categoryId = document.getElementById('categoryFilter').value;
            if (!categoryId) {
                loadAllProducts();
                return;
            }
            
            const query = `
                query GetProductsByCategory($categoryId: ID!) {
                    getProductsByCategory(categoryId: $categoryId) {
                        id
                        title
                        quantity
                        description
                        price
                        user {
                            id
                            fullname
                        }
                        categories {
                            id
                            name
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query, { categoryId });
            if (data) {
                displayProducts(data.getProductsByCategory);
            }
        }
        
        // Display products in table
        function displayProducts(products) {
            const tbody = document.getElementById('productsTableBody');
            tbody.innerHTML = '';
            
            products.forEach(product => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${product.id}</td>
                    <td>${product.title}</td>
                    <td>${product.quantity}</td>
                    <td>${product.description || ''}</td>
                    <td>$${product.price}</td>
                    <td>${product.user ? product.user.fullname : 'N/A'}</td>
                    <td>${product.categories.map(cat => cat.name).join(', ')}</td>
                    <td>
                        <button class="btn btn-sm btn-warning" onclick="editProduct(${product.id})">Sửa</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteProduct(${product.id})">Xóa</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }
        
        // Load categories for filter and form
        async function loadCategories() {
            const query = `
                query {
                    getAllCategories {
                        id
                        name
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                // Populate filter dropdown
                const filterSelect = document.getElementById('categoryFilter');
                filterSelect.innerHTML = '<option value="">Chọn danh mục</option>';
                
                // Populate form dropdown
                const formSelect = document.getElementById('productCategories');
                formSelect.innerHTML = '';
                
                data.getAllCategories.forEach(category => {
                    const filterOption = document.createElement('option');
                    filterOption.value = category.id;
                    filterOption.textContent = category.name;
                    filterSelect.appendChild(filterOption);
                    
                    const formOption = document.createElement('option');
                    formOption.value = category.id;
                    formOption.textContent = category.name;
                    formSelect.appendChild(formOption);
                });
            }
        }
        
        // Load users for form
        async function loadUsers() {
            const query = `
                query {
                    getAllUsers {
                        id
                        fullname
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                const select = document.getElementById('productUser');
                select.innerHTML = '<option value="">Chọn người tạo</option>';
                
                data.getAllUsers.forEach(user => {
                    const option = document.createElement('option');
                    option.value = user.id;
                    option.textContent = user.fullname;
                    select.appendChild(option);
                });
            }
        }
        
        // Open create modal
        function openCreateModal() {
            isEditMode = false;
            document.getElementById('productModalTitle').textContent = 'Thêm sản phẩm mới';
            document.getElementById('productForm').reset();
            document.getElementById('productId').value = '';
        }
        
        // Edit product
        async function editProduct(id) {
            const query = `
                query GetProductById($id: ID!) {
                    getProductById(id: $id) {
                        id
                        title
                        quantity
                        description
                        price
                        user {
                            id
                        }
                        categories {
                            id
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query, { id: id.toString() });
            if (data && data.getProductById) {
                const product = data.getProductById;
                isEditMode = true;
                
                document.getElementById('productModalTitle').textContent = 'Sửa sản phẩm';
                document.getElementById('productId').value = product.id;
                document.getElementById('productTitle').value = product.title;
                document.getElementById('productQuantity').value = product.quantity;
                document.getElementById('productDescription').value = product.description || '';
                document.getElementById('productPrice').value = product.price;
                document.getElementById('productUser').value = product.user ? product.user.id : '';
                
                // Set selected categories
                const categorySelect = document.getElementById('productCategories');
                Array.from(categorySelect.options).forEach(option => {
                    option.selected = product.categories.some(cat => cat.id == option.value);
                });
                
                new bootstrap.Modal(document.getElementById('productModal')).show();
            }
        }
        
        // Save product
        async function saveProduct() {
            const id = document.getElementById('productId').value;
            const title = document.getElementById('productTitle').value;
            const quantity = parseInt(document.getElementById('productQuantity').value);
            const description = document.getElementById('productDescription').value;
            const price = parseFloat(document.getElementById('productPrice').value);
            const userId = document.getElementById('productUser').value;
            
            const categorySelect = document.getElementById('productCategories');
            const categoryIds = Array.from(categorySelect.selectedOptions).map(option => option.value);
            
            const input = {
                title,
                quantity,
                description,
                price,
                userId: userId || null,
                categoryIds
            };
            
            let query, variables;
            
            if (isEditMode) {
                query = `
                    mutation UpdateProduct($id: ID!, $input: ProductInput!) {
                        updateProduct(id: $id, input: $input) {
                            id
                            title
                        }
                    }
                `;
                variables = { id, input };
            } else {
                query = `
                    mutation CreateProduct($input: ProductInput!) {
                        createProduct(input: $input) {
                            id
                            title
                        }
                    }
                `;
                variables = { input };
            }
            
            const data = await graphqlQuery(query, variables);
            if (data) {
                bootstrap.Modal.getInstance(document.getElementById('productModal')).hide();
                loadAllProducts();
            }
        }
        
        // Delete product
        async function deleteProduct(id) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
                const query = `
                    mutation DeleteProduct($id: ID!) {
                        deleteProduct(id: $id)
                    }
                `;
                
                const data = await graphqlQuery(query, { id: id.toString() });
                if (data && data.deleteProduct) {
                    loadAllProducts();
                }
            }
        }
    </script>
</body>
</html>
