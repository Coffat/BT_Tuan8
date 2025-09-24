-- SQL Server Version of database.sql
-- Tạo database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'product_management')
BEGIN
    CREATE DATABASE product_management;
END
GO

USE product_management;
GO

-- Tạo bảng Category
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'category')
BEGIN
    CREATE TABLE category (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        images NVARCHAR(MAX)
    );
END
GO

-- Tạo bảng User (đổi tên thành [user] vì USER là reserved keyword)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user')
BEGIN
    CREATE TABLE [user] (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        fullname NVARCHAR(255) NOT NULL,
        email NVARCHAR(255) UNIQUE NOT NULL,
        password NVARCHAR(255) NOT NULL,
        phone NVARCHAR(20)
    );
END
GO

-- Tạo bảng Product
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'product')
BEGIN
    CREATE TABLE product (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(255) NOT NULL,
        quantity INT NOT NULL DEFAULT 0,
        description NVARCHAR(MAX),
        price DECIMAL(10,2) NOT NULL,
        user_id BIGINT,
        FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE SET NULL
    );
END
GO

-- Tạo bảng trung gian cho mối quan hệ nhiều-nhiều giữa Category và User
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user_category')
BEGIN
    CREATE TABLE user_category (
        user_id BIGINT,
        category_id BIGINT,
        PRIMARY KEY (user_id, category_id),
        FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
    );
END
GO

-- Tạo bảng trung gian cho mối quan hệ nhiều-nhiều giữa Product và Category
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'product_category')
BEGIN
    CREATE TABLE product_category (
        product_id BIGINT,
        category_id BIGINT,
        PRIMARY KEY (product_id, category_id),
        FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
    );
END
GO

-- Chèn dữ liệu mẫu cho bảng Category
SET IDENTITY_INSERT category ON;
INSERT INTO category (id, name, images) VALUES
(1, 'Electronics', 'electronics.jpg'),
(2, 'Clothing', 'clothing.jpg'),
(3, 'Books', 'books.jpg'),
(4, 'Home & Garden', 'home_garden.jpg'),
(5, 'Sports', 'sports.jpg');
SET IDENTITY_INSERT category OFF;
GO

-- Chèn dữ liệu mẫu cho bảng User
SET IDENTITY_INSERT [user] ON;
INSERT INTO [user] (id, fullname, email, password, phone) VALUES
(1, 'Nguyen Van A', 'nguyenvana@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0901234567'),
(2, 'Tran Thi B', 'tranthib@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0902345678'),
(3, 'Le Van C', 'levanc@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0903456789'),
(4, 'Pham Thi D', 'phamthid@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0904567890'),
(5, 'Hoang Van E', 'hoangvane@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0905678901');
SET IDENTITY_INSERT [user] OFF;
GO

-- Chèn dữ liệu mẫu cho bảng Product
SET IDENTITY_INSERT product ON;
INSERT INTO product (id, title, quantity, description, price, user_id) VALUES
(1, 'iPhone 15 Pro', 50, 'Latest iPhone with advanced camera system', 999.99, 1),
(2, 'Samsung Galaxy S24', 30, 'Flagship Android smartphone', 899.99, 1),
(3, 'MacBook Air M3', 20, 'Lightweight laptop with M3 chip', 1299.99, 2),
(4, 'Nike Air Max', 100, 'Comfortable running shoes', 129.99, 3),
(5, 'Adidas Ultraboost', 80, 'Premium running shoes', 179.99, 3),
(6, 'Java Programming Book', 200, 'Complete guide to Java programming', 49.99, 4),
(7, 'Spring Boot in Action', 150, 'Learn Spring Boot framework', 59.99, 4),
(8, 'Gaming Chair', 25, 'Ergonomic gaming chair', 299.99, 5),
(9, 'Wireless Headphones', 75, 'Noise-cancelling headphones', 199.99, 1),
(10, 'Smart Watch', 60, 'Fitness tracking smartwatch', 249.99, 2);
SET IDENTITY_INSERT product OFF;
GO

-- Chèn dữ liệu mẫu cho bảng user_category (mối quan hệ nhiều-nhiều)
INSERT INTO user_category (user_id, category_id) VALUES
(1, 1), -- Nguyen Van A - Electronics
(1, 5), -- Nguyen Van A - Sports
(2, 1), -- Tran Thi B - Electronics
(2, 4), -- Tran Thi B - Home & Garden
(3, 2), -- Le Van C - Clothing
(3, 5), -- Le Van C - Sports
(4, 3), -- Pham Thi D - Books
(4, 1), -- Pham Thi D - Electronics
(5, 4), -- Hoang Van E - Home & Garden
(5, 1); -- Hoang Van E - Electronics
GO

-- Chèn dữ liệu mẫu cho bảng product_category (mối quan hệ nhiều-nhiều)
INSERT INTO product_category (product_id, category_id) VALUES
(1, 1), -- iPhone 15 Pro - Electronics
(2, 1), -- Samsung Galaxy S24 - Electronics
(3, 1), -- MacBook Air M3 - Electronics
(4, 2), -- Nike Air Max - Clothing
(4, 5), -- Nike Air Max - Sports
(5, 2), -- Adidas Ultraboost - Clothing
(5, 5), -- Adidas Ultraboost - Sports
(6, 3), -- Java Programming Book - Books
(7, 3), -- Spring Boot in Action - Books
(8, 4), -- Gaming Chair - Home & Garden
(9, 1), -- Wireless Headphones - Electronics
(10, 1), -- Smart Watch - Electronics
(10, 5); -- Smart Watch - Sports
GO

PRINT 'Database setup completed successfully!';
GO
