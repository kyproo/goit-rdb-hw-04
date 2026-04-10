-- Домашнє завдання 4. DDL та DML команди. Складні SQL вирази
-- GoIT RDB Course

-- ============================================================
-- Завдання 1: Створення бази даних та таблиць (DDL)
-- ============================================================

-- a) Створення схеми
CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

-- b) Таблиця authors
CREATE TABLE IF NOT EXISTS authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

-- c) Таблиця genres
CREATE TABLE IF NOT EXISTS genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

-- d) Таблиця books
CREATE TABLE IF NOT EXISTS books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- e) Таблиця users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- f) Таблиця borrowed_books
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

-- Додавання авторів
INSERT INTO authors (author_name) VALUES
('Тарас Шевченко'),
('Іван Франко');

-- Додавання жанрів
INSERT INTO genres (genre_name) VALUES
('Поезія'),
('Проза');

-- Додавання книг
INSERT INTO books (title, publication_year, author_id, genre_id) VALUES
('Кобзар', 1840, 1, 1),
('Захар Беркут', 1883, 2, 2);

-- Додавання користувачів
INSERT INTO users (username, email) VALUES
('olena_k', 'olena@example.com'),
('mykola_p', 'mykola@example.com');

-- Додавання записів про позичені книги
INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES
(1, 1, '2024-01-10', '2024-01-24'),
(2, 2, '2024-02-05', '2024-02-19');

-- ============================================================
-- Завдання 3: Запит з використанням SELECT та WHERE
-- ============================================================

-- Знайти всі книги, видані після 1850 року
SELECT b.book_id, b.title, b.publication_year, a.author_name, g.genre_name
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id
WHERE b.publication_year > 1850;

-- ============================================================
-- Завдання 4: Складні запити з JOIN
-- ============================================================

-- 4.1 Які книги зараз позичені (є в borrowed_books)?
SELECT b.title, u.username, bb.borrow_date, bb.return_date
FROM borrowed_books bb
JOIN books b ON bb.book_id = b.book_id
JOIN users u ON bb.user_id = u.user_id;

-- 4.2 Всі книги з іменем автора та жанром
SELECT b.title, a.author_name, g.genre_name, b.publication_year
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id;

-- 4.3 Користувачі, які коли-небудь брали книги
SELECT DISTINCT u.username, u.email
FROM users u
JOIN borrowed_books bb ON u.user_id = bb.user_id;

-- 4.4 Кількість книг по жанрах
SELECT g.genre_name, COUNT(b.book_id) AS books_count
FROM genres g
LEFT JOIN books b ON g.genre_id = b.genre_id
GROUP BY g.genre_name;

-- 4.5 Кількість книг по авторах
SELECT a.author_name, COUNT(b.book_id) AS books_count
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_name;

-- 4.6 Всі книги з інформацією чи вони зараз позичені
SELECT b.title, a.author_name,
       CASE WHEN bb.borrow_id IS NOT NULL THEN 'Позичена' ELSE 'Доступна' END AS status
FROM books b
JOIN authors a ON b.author_id = a.author_id
LEFT JOIN borrowed_books bb ON b.book_id = bb.book_id;

-- 4.7 Повна інформація про позичені книги (автор, жанр, користувач)
SELECT b.title, a.author_name, g.genre_name, u.username, bb.borrow_date, bb.return_date
FROM borrowed_books bb
JOIN books b ON bb.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id
JOIN users u ON bb.user_id = u.user_id;
