-- ============================================================
-- Домашнє завдання 4. DDL, DML та складні SQL вирази
-- GoIT RDB Course
-- ============================================================

-- ============================================================
-- Завдання 1: Створення бази даних LibraryManagement (DDL)
-- ============================================================

CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

CREATE TABLE IF NOT EXISTS authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ============================================================
-- Завдання 2: Заповнення тестовими даними (DML)
-- ============================================================

INSERT INTO authors (author_name) VALUES ('Тарас Шевченко'), ('Іван Франко');
INSERT INTO genres (genre_name) VALUES ('Поезія'), ('Проза');
INSERT INTO books (title, publication_year, author_id, genre_id) VALUES
    ('Кобзар', 1840, 1, 1), ('Захар Беркут', 1883, 2, 2);
INSERT INTO users (username, email) VALUES
    ('olena_k', 'olena@example.com'), ('mykola_p', 'mykola@example.com');
INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES
    (1, 1, '2024-01-10', '2024-01-24'), (2, 2, '2024-02-05', '2024-02-19');

-- ============================================================
-- Завдання 3: INNER JOIN всіх 8 таблиць (база northwind)
-- ============================================================

USE northwind;

SELECT 
    od.order_detail_id,
    od.quantity,
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name,
    p.price AS product_price,
    cat.category_name,
    e.first_name,
    e.last_name,
    sh.shipper_name,
    sup.supplier_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id;

-- ============================================================
-- Завдання 4.1: COUNT рядків (результат: 518)
-- ============================================================

SELECT COUNT(*) AS total_rows
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id;
-- Результат: 518

-- ============================================================
-- Завдання 4.2: LEFT JOIN (результат: 518 — однаковий)
-- ============================================================

SELECT COUNT(*) AS total_rows_left
FROM order_details od
LEFT JOIN orders o ON od.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN products p ON od.product_id = p.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN shippers sh ON o.shipper_id = sh.shipper_id
LEFT JOIN suppliers sup ON p.supplier_id = sup.supplier_id;
-- Результат: 518

-- ============================================================
-- Завдання 4.3: WHERE employee_id > 3 AND <= 10 (317 рядків)
-- ============================================================

SELECT 
    od.order_detail_id, od.quantity,
    o.order_id, o.employee_id,
    e.first_name, e.last_name,
    cat.category_name, p.product_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
WHERE o.employee_id > 3 AND o.employee_id <= 10;

-- ============================================================
-- Завдання 4.4: GROUP BY category_name + COUNT + AVG quantity
-- ============================================================

SELECT 
    cat.category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.category_name;

-- ============================================================
-- Завдання 4.5: HAVING avg_quantity > 21
-- ============================================================

SELECT 
    cat.category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.category_name
HAVING AVG(od.quantity) > 21;

-- ============================================================
-- Завдання 4.6: ORDER BY row_count DESC
-- ============================================================

SELECT 
    cat.category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.category_name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC;

-- ============================================================
-- Завдання 4.7: LIMIT 4 OFFSET 1 (пропустити перший рядок)
-- ============================================================

SELECT 
    cat.category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id
WHERE o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.category_name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;

-- ============================================================
-- Відповідь на питання 4.2: INNER vs LEFT/RIGHT JOIN
-- ============================================================
-- INNER JOIN повертає тільки рядки де є збіг в ОБОХ таблицях.
-- LEFT JOIN повертає ВСІ рядки з лівої таблиці + збіги з правої
--   (де немає збігу -- NULL у правій частині).
-- RIGHT JOIN -- навпаки: всі рядки з правої таблиці.
-- 
-- У нашому датасеті Northwind всі foreign key зв'язки цілісні,
-- тому INNER та LEFT JOIN дають однаковий результат (518 рядків).
-- Якби були записи без відповідності (напр. order без customer),
-- LEFT JOIN показав би більше рядків ніж INNER JOIN.
