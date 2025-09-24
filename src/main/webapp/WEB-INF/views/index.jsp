<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management System</title>
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
                <a class="nav-link" href="/categories">Categories</a>
                <a class="nav-link" href="/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">Hệ thống quản lý sản phẩm</h1>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Quản lý sản phẩm</h5>
                                <p class="card-text">Xem, thêm, sửa, xóa sản phẩm. Sắp xếp theo giá.</p>
                                <a href="/products" class="btn btn-primary">Quản lý sản phẩm</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Quản lý người dùng</h5>
                                <p class="card-text">Xem, thêm, sửa, xóa người dùng trong hệ thống.</p>
                                <a href="/users" class="btn btn-success">Quản lý người dùng</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Quản lý danh mục</h5>
                                <p class="card-text">Xem, thêm, sửa, xóa danh mục sản phẩm.</p>
                                <a href="/categories" class="btn btn-info">Quản lý danh mục</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">GraphQL API</h5>
                                <p class="card-text">
                                    Hệ thống sử dụng GraphQL API để quản lý dữ liệu. 
                                    Bạn có thể truy cập GraphiQL interface để test các query và mutation.
                                </p>
                                <a href="/graphiql" target="_blank" class="btn btn-warning">Mở GraphiQL</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-12">
                        <h3>Các tính năng chính:</h3>
                        <ul class="list-group">
                            <li class="list-group-item">✅ Hiển thị tất cả sản phẩm sắp xếp theo giá từ thấp đến cao</li>
                            <li class="list-group-item">✅ Lấy tất cả sản phẩm của một danh mục</li>
                            <li class="list-group-item">✅ CRUD operations cho User, Product, Category</li>
                            <li class="list-group-item">✅ GraphQL API với đầy đủ Query và Mutation</li>
                            <li class="list-group-item">✅ Frontend với AJAX và Bootstrap UI</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
