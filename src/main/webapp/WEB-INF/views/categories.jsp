<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục</title>
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
                <a class="nav-link" href="/products">Products</a>
                <a class="nav-link" href="/users">Users</a>
                <a class="nav-link active" href="/categories">Categories</a>
                <a class="nav-link" href="/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">Quản lý danh mục</h1>
                
                <div class="row mb-3">
                    <div class="col-md-8">
                        <button class="btn btn-primary" onclick="loadAllCategories()">Tải lại danh sách</button>
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#categoryModal" onclick="openCreateModal()">
                            Thêm danh mục mới
                        </button>
                    </div>
                </div>
                
                <!-- Categories Table -->
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên danh mục</th>
                                <th>Hình ảnh</th>
                                <th>Số sản phẩm</th>
                                <th>Số người dùng</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="categoriesTableBody">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Category Modal -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="categoryModalTitle">Thêm danh mục mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="categoryForm">
                        <input type="hidden" id="categoryId">
                        <div class="mb-3">
                            <label for="categoryName" class="form-label">Tên danh mục</label>
                            <input type="text" class="form-control" id="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label for="categoryImages" class="form-label">Hình ảnh</label>
                            <input type="text" class="form-control" id="categoryImages" placeholder="Đường dẫn hình ảnh">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveCategory()">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let isEditMode = false;
        const GRAPHQL_URL = '/graphql';
        
        $(document).ready(function() {
            loadAllCategories();
        });
        
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
        
        async function loadAllCategories() {
            const query = `
                query {
                    getAllCategories {
                        id
                        name
                        images
                        products {
                            id
                        }
                        users {
                            id
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                displayCategories(data.getAllCategories);
            }
        }
        
        function displayCategories(categories) {
            const tbody = document.getElementById('categoriesTableBody');
            tbody.innerHTML = '';
            
            categories.forEach(category => {
                const row = document.createElement('tr');
                
                // Format data
                const images = category.images || 'N/A';
                
                row.innerHTML = 
                    '<td>' + category.id + '</td>' +
                    '<td>' + category.name + '</td>' +
                    '<td>' + images + '</td>' +
                    '<td>' + category.products.length + '</td>' +
                    '<td>' + category.users.length + '</td>' +
                    '<td>' +
                        '<button class="btn btn-sm btn-warning" onclick="editCategory(' + category.id + ')">Sửa</button> ' +
                        '<button class="btn btn-sm btn-danger" onclick="deleteCategory(' + category.id + ')">Xóa</button>' +
                    '</td>';
                
                tbody.appendChild(row);
            });
        }
        
        function openCreateModal() {
            isEditMode = false;
            document.getElementById('categoryModalTitle').textContent = 'Thêm danh mục mới';
            document.getElementById('categoryForm').reset();
            document.getElementById('categoryId').value = '';
        }
        
        async function editCategory(id) {
            const query = `
                query GetCategoryById($id: ID!) {
                    getCategoryById(id: $id) {
                        id
                        name
                        images
                    }
                }
            `;
            
            const data = await graphqlQuery(query, { id: id.toString() });
            if (data && data.getCategoryById) {
                const category = data.getCategoryById;
                isEditMode = true;
                
                document.getElementById('categoryModalTitle').textContent = 'Sửa danh mục';
                document.getElementById('categoryId').value = category.id;
                document.getElementById('categoryName').value = category.name;
                document.getElementById('categoryImages').value = category.images || '';
                
                new bootstrap.Modal(document.getElementById('categoryModal')).show();
            }
        }
        
        async function saveCategory() {
            const id = document.getElementById('categoryId').value;
            const name = document.getElementById('categoryName').value;
            const images = document.getElementById('categoryImages').value;
            
            const input = {
                name,
                images
            };
            
            let query, variables;
            
            if (isEditMode) {
                query = `
                    mutation UpdateCategory($id: ID!, $input: CategoryInput!) {
                        updateCategory(id: $id, input: $input) {
                            id
                            name
                        }
                    }
                `;
                variables = { id, input };
            } else {
                query = `
                    mutation CreateCategory($input: CategoryInput!) {
                        createCategory(input: $input) {
                            id
                            name
                        }
                    }
                `;
                variables = { input };
            }
            
            const data = await graphqlQuery(query, variables);
            if (data) {
                bootstrap.Modal.getInstance(document.getElementById('categoryModal')).hide();
                loadAllCategories();
            }
        }
        
        async function deleteCategory(id) {
            if (confirm('Bạn có chắc chắn muốn xóa danh mục này?')) {
                const query = `
                    mutation DeleteCategory($id: ID!) {
                        deleteCategory(id: $id)
                    }
                `;
                
                const data = await graphqlQuery(query, { id: id.toString() });
                if (data && data.deleteCategory) {
                    loadAllCategories();
                }
            }
        }
    </script>
</body>
</html>
