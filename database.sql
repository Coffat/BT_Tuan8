-- Tạo database
CREATE DATABASE IF NOT EXISTS product_management;
USE product_management;

-- Tạo bảng Category
CREATE TABLE category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    images TEXT
);

-- Tạo bảng User
CREATE TABLE user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

-- Tạo bảng Product
CREATE TABLE product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
);

-- Tạo bảng trung gian cho mối quan hệ nhiều-nhiều giữa Category và User
CREATE TABLE user_category (
    user_id BIGINT,
    category_id BIGINT,
    PRIMARY KEY (user_id, category_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
);

-- Tạo bảng trung gian cho mối quan hệ nhiều-nhiều giữa Product và Category
CREATE TABLE product_category (
    product_id BIGINT,
    category_id BIGINT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
);

-- Chèn dữ liệu mẫu cho bảng Category
INSERT INTO category (name, images) VALUES
('Electronics', 'electronics.jpg'),
('Clothing', 'clothing.jpg'),
('Books', 'books.jpg'),
('Home & Garden', 'home_garden.jpg'),
('Sports', 'sports.jpg');

-- Chèn dữ liệu mẫu cho bảng User
INSERT INTO user (fullname, email, password, phone) VALUES
('Nguyen Van A', 'nguyenvana@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0901234567'),
('Tran Thi B', 'tranthib@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0902345678'),
('Le Van C', 'levanc@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0903456789'),
('Pham Thi D', 'phamthid@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0904567890'),
('Hoang Van E', 'hoangvane@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0905678901');

-- Chèn dữ liệu mẫu cho bảng Product
INSERT INTO product (title, quantity, description, price, user_id) VALUES
('iPhone 15 Pro', 50, 'Latest iPhone with advanced camera system', 999.99, 1),
('Samsung Galaxy S24', 30, 'Flagship Android smartphone', 899.99, 1),
('MacBook Air M3', 20, 'Lightweight laptop with M3 chip', 1299.99, 2),
('Nike Air Max', 100, 'Comfortable running shoes', 129.99, 3),
('Adidas Ultraboost', 80, 'Premium running shoes', 179.99, 3),
('Java Programming Book', 200, 'Complete guide to Java programming', 49.99, 4),
('Spring Boot in Action', 150, 'Learn Spring Boot framework', 59.99, 4),
('Gaming Chair', 25, 'Ergonomic gaming chair', 299.99, 5),
('Wireless Headphones', 75, 'Noise-cancelling headphones', 199.99, 1),
('Smart Watch', 60, 'Fitness tracking smartwatch', 249.99, 2);

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
