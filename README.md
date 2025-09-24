# Product Management System với GraphQL và Spring Boot

## Mô tả
Hệ thống quản lý sản phẩm được xây dựng bằng Spring Boot 3, GraphQL, MySQL và JSP. Hệ thống cung cấp các tính năng CRUD cho User, Product, Category với giao diện web sử dụng AJAX.

## Cấu trúc Database
- **Category**: id, name, images
- **User**: id, fullname, email, password, phone  
- **Product**: id, title, quantity, description, price, user_id
- **Mối quan hệ nhiều-nhiều**: User ↔ Category, Product ↔ Category

## Tính năng chính
1. ✅ Hiển thị tất cả sản phẩm sắp xếp theo giá từ thấp đến cao
2. ✅ Lấy tất cả sản phẩm của một danh mục
3. ✅ CRUD operations cho User, Product, Category
4. ✅ GraphQL API với đầy đủ Query và Mutation
5. ✅ Frontend với AJAX và Bootstrap UI

## Cài đặt và Chạy

### 1. Chuẩn bị Database
```sql
-- Tạo database MySQL
CREATE DATABASE product_management;

-- Import dữ liệu từ file database.sql
mysql -u root -p product_management < database.sql
```

### 2. Cấu hình Database
Chỉnh sửa file `src/main/resources/application.properties`:
```properties
spring.datasource.username=root
spring.datasource.password=your_password
```

### 3. Build và chạy ứng dụng
```bash
# Build project
./mvnw clean install

# Chạy ứng dụng
./mvnw spring-boot:run
```

### 4. Truy cập ứng dụng
- **Trang chủ**: http://localhost:8080/
- **Quản lý sản phẩm**: http://localhost:8080/products
- **Quản lý người dùng**: http://localhost:8080/users
- **Quản lý danh mục**: http://localhost:8080/categories
- **GraphiQL Interface**: http://localhost:8080/graphiql

## REST API Examples

### Product API

#### Lấy tất cả sản phẩm sắp xếp theo giá
```bash
GET /api/products/sorted-by-price
```

#### Lấy sản phẩm theo danh mục
```bash
GET /api/products/by-category/1
```

#### Tạo sản phẩm mới
```bash
POST /api/products
Content-Type: application/json

{
  "title": "iPhone 16",
  "quantity": 10,
  "description": "Latest iPhone",
  "price": 999.99,
  "userId": "1",
  "categoryIds": ["1"]
}
```

### User API

#### Lấy tất cả người dùng
```bash
GET /api/users
```

#### Tạo người dùng mới
```bash
POST /api/users
Content-Type: application/json

{
  "fullname": "Nguyen Van Test",
  "email": "test@example.com",
  "password": "password123",
  "phone": "0123456789",
  "categoryIds": ["1", "2"]
}
```

### Category API

#### Lấy tất cả danh mục
```bash
GET /api/categories
```

#### Tạo danh mục mới
```bash
POST /api/categories
Content-Type: application/json

{
  "name": "New Category",
  "images": "category.jpg"
}
```

## GraphQL API (Tùy chọn)
*Lưu ý: GraphQL API đã được implement nhưng có thể cần cấu hình thêm dependencies*

## Công nghệ sử dụng
- **Backend**: Spring Boot 3.5.6, Spring Data JPA, Spring Security
- **GraphQL**: Spring GraphQL
- **Database**: MySQL 8.0
- **Frontend**: JSP, Bootstrap 5, jQuery, AJAX
- **Build Tool**: Maven

## Cấu trúc thư mục
```
src/
├── main/
│   ├── java/com/login/baitap8/
│   │   ├── entity/          # Entity classes
│   │   ├── repository/      # Repository interfaces  
│   │   ├── resolver/        # GraphQL resolvers
│   │   └── controller/      # Web controllers
│   ├── resources/
│   │   ├── graphql/         # GraphQL schema
│   │   └── application.properties
│   └── webapp/WEB-INF/views/ # JSP files
└── test/
```

## Lưu ý
- Đảm bảo MySQL server đang chạy
- Cấu hình đúng thông tin database trong application.properties
- Sử dụng Java 17 trở lên
- Port mặc định: 8080
