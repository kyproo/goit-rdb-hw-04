-- ============================================================
-- Завдання 3: INNER JOIN всіх таблиць з теми 3
-- ============================================================

USE northwind; -- або та схема де завантажені дані з теми 3

SELECT 
    od.order_id,
    od.product_id,
    od.quantity,
    od.price,
    o.customer_id,
    o.employee_id,
    o.order_date,
    o.shipper_id,
    c.customer_name,
    c.country,
    p.product_name,
    p.supplier_id,
    p.category_id,
    p.price AS product_price,
    cat.category_name,
    e.first_name,
    e.last_name,
    sh.shipper_name,
    sup.supplier_name,
    sup.country AS supplier_country
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.shipper_id
INNER JOIN suppliers sup ON p.supplier_id = sup.supplier_id;

-- ============================================================
-- Завдання 4.1: Кількість рядків (COUNT)
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

-- ============================================================
-- Завдання 4.2: Зміна INNER на LEFT/RIGHT
-- ============================================================

-- LEFT JOIN (більше рядків — включає записи без відповідності справа)
SELECT COUNT(*) AS total_rows_left
FROM order_details od
LEFT JOIN orders o ON od.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN products p ON od.product_id = p.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN shippers sh ON o.shipper_id = sh.shipper_id
LEFT JOIN suppliers sup ON p.supplier_id = sup.supplier_id;

-- ============================================================
-- Завдання 4.3: Фільтр employee_id > 3 та <= 10
-- ============================================================

SELECT 
    od.order_id,
    od.quantity,
    o.employee_id,
    e.first_name,
    e.last_name,
    cat.category_name,
    p.product_name
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
-- Завдання 4.4: Групування за категорією + кількість + середня кількість
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
-- Завдання 4.5: Фільтр HAVING avg_quantity > 21
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
-- Завдання 4.6: Сортування за спаданням кількості рядків
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
-- Відповідь на питання 4.2
-- ============================================================
-- INNER JOIN повертає тільки рядки, де є збіг в обох таблицях.
-- LEFT JOIN повертає всі рядки з лівої таблиці + збіги з правої
-- (де немає збігу — NULL). Тому кількість рядків може збільшитись.
-- RIGHT JOIN — навпаки, всі рядки з правої таблиці.
-- В нашому датасеті Northwind всі зв'язки цілісні, тому 
-- різниця між INNER та LEFT/RIGHT може бути мінімальною.
