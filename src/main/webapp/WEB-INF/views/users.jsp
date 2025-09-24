<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
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
                <a class="nav-link active" href="/users">Users</a>
                <a class="nav-link" href="/categories">Categories</a>
                <a class="nav-link" href="/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">Quản lý người dùng</h1>
                
                <div class="row mb-3">
                    <div class="col-md-8">
                        <button class="btn btn-primary" onclick="loadAllUsers()">Tải lại danh sách</button>
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#userModal" onclick="openCreateModal()">
                            Thêm người dùng mới
                        </button>
                    </div>
                </div>
                
                <!-- Users Table -->
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Danh mục</th>
                                <th>Số sản phẩm</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- User Modal -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalTitle">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId">
                        <div class="mb-3">
                            <label for="userFullname" class="form-label">Họ tên</label>
                            <input type="text" class="form-control" id="userFullname" required>
                        </div>
                        <div class="mb-3">
                            <label for="userEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="userEmail" required>
                        </div>
                        <div class="mb-3">
                            <label for="userPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="userPassword" required>
                            <div class="form-text">Để trống nếu không muốn thay đổi mật khẩu (chỉ khi sửa)</div>
                        </div>
                        <div class="mb-3">
                            <label for="userPhone" class="form-label">Điện thoại</label>
                            <input type="tel" class="form-control" id="userPhone">
                        </div>
                        <div class="mb-3">
                            <label for="userCategories" class="form-label">Danh mục quan tâm</label>
                            <select class="form-select" id="userCategories" multiple>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveUser()">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let isEditMode = false;
        const GRAPHQL_URL = '/graphql';
        
        $(document).ready(function() {
            loadAllUsers();
            loadCategories();
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
        
        async function loadAllUsers() {
            const query = `
                query {
                    getAllUsers {
                        id
                        fullname
                        email
                        phone
                        categories {
                            id
                            name
                        }
                        products {
                            id
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query);
            if (data) {
                displayUsers(data.getAllUsers);
            }
        }
        
        function displayUsers(users) {
            const tbody = document.getElementById('usersTableBody');
            tbody.innerHTML = '';
            
            users.forEach(user => {
                const row = document.createElement('tr');
                
                // Format data
                const categoryNames = user.categories.map(cat => cat.name).join(', ');
                const phone = user.phone || 'N/A';
                
                row.innerHTML = 
                    '<td>' + user.id + '</td>' +
                    '<td>' + user.fullname + '</td>' +
                    '<td>' + user.email + '</td>' +
                    '<td>' + phone + '</td>' +
                    '<td>' + categoryNames + '</td>' +
                    '<td>' + user.products.length + '</td>' +
                    '<td>' +
                        '<button class="btn btn-sm btn-warning" onclick="editUser(' + user.id + ')">Sửa</button> ' +
                        '<button class="btn btn-sm btn-danger" onclick="deleteUser(' + user.id + ')">Xóa</button>' +
                    '</td>';
                
                tbody.appendChild(row);
            });
        }
        
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
                const select = document.getElementById('userCategories');
                select.innerHTML = '';
                
                data.getAllCategories.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.id;
                    option.textContent = category.name;
                    select.appendChild(option);
                });
            }
        }
        
        function openCreateModal() {
            isEditMode = false;
            document.getElementById('userModalTitle').textContent = 'Thêm người dùng mới';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('userPassword').required = true;
        }
        
        async function editUser(id) {
            const query = `
                query GetUserById($id: ID!) {
                    getUserById(id: $id) {
                        id
                        fullname
                        email
                        phone
                        categories {
                            id
                        }
                    }
                }
            `;
            
            const data = await graphqlQuery(query, { id: id.toString() });
            if (data && data.getUserById) {
                const user = data.getUserById;
                isEditMode = true;
                
                document.getElementById('userModalTitle').textContent = 'Sửa người dùng';
                document.getElementById('userId').value = user.id;
                document.getElementById('userFullname').value = user.fullname;
                document.getElementById('userEmail').value = user.email;
                document.getElementById('userPhone').value = user.phone || '';
                document.getElementById('userPassword').value = '';
                document.getElementById('userPassword').required = false;
                
                const categorySelect = document.getElementById('userCategories');
                Array.from(categorySelect.options).forEach(option => {
                    option.selected = user.categories.some(cat => cat.id == option.value);
                });
                
                new bootstrap.Modal(document.getElementById('userModal')).show();
            }
        }
        
        async function saveUser() {
            const id = document.getElementById('userId').value;
            const fullname = document.getElementById('userFullname').value;
            const email = document.getElementById('userEmail').value;
            const password = document.getElementById('userPassword').value;
            const phone = document.getElementById('userPhone').value;
            
            const categorySelect = document.getElementById('userCategories');
            const categoryIds = Array.from(categorySelect.selectedOptions).map(option => option.value);
            
            const input = {
                fullname,
                email,
                phone,
                categoryIds
            };
            
            // Only include password if it's provided
            if (password) {
                input.password = password;
            }
            
            let query, variables;
            
            if (isEditMode) {
                query = `
                    mutation UpdateUser($id: ID!, $input: UserInput!) {
                        updateUser(id: $id, input: $input) {
                            id
                            fullname
                        }
                    }
                `;
                variables = { id, input };
            } else {
                if (!password) {
                    alert('Mật khẩu là bắt buộc khi tạo người dùng mới');
                    return;
                }
                query = `
                    mutation CreateUser($input: UserInput!) {
                        createUser(input: $input) {
                            id
                            fullname
                        }
                    }
                `;
                variables = { input };
            }
            
            const data = await graphqlQuery(query, variables);
            if (data) {
                bootstrap.Modal.getInstance(document.getElementById('userModal')).hide();
                loadAllUsers();
            }
        }
        
        async function deleteUser(id) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
                const query = `
                    mutation DeleteUser($id: ID!) {
                        deleteUser(id: $id)
                    }
                `;
                
                const data = await graphqlQuery(query, { id: id.toString() });
                if (data && data.deleteUser) {
                    loadAllUsers();
                }
            }
        }
    </script>
</body>
</html>
