create database library;
use library;
create table authors(
author_id int primary key auto_increment,
author_name varchar(50) not null unique,
country varchar(40)
);
create table books(
book_id int primary key auto_increment,
title varchar(100) not null,
author_id int,
genre varchar(50),
published_year int check(published_year >1500),
copies int check(copies >= 0 ),
foreign key(author_id) references authors(author_id)
);
create table members(
members_id int primary key auto_increment,
member_name varchar(50) not null,
email varchar(50) unique,
join_date date not null
);
create table issued_books(
issued_id int primary key auto_increment,
book_id int,
members_id int,
issued_date date not null,
return_date date,
status varchar(15) check(status in('issued','returned','lost')),
foreign key (book_id) references books(book_id),
foreign key (members_id) references members(members_id)
);
insert into authors(author_name,country) values
('Chetan Bhagat','India'),
('J.K. Rowling','UK'),
('George Orwell','USA');
insert into books(title,author_id,genre,published_year,copies)values
('2 States',1,'Fiction',2009,5),
('Harry Potter',2,'Fantasy',1997,8),
('1984',3,'Dystopian',1949,4);
insert into members(member_name,email,join_date) values
('Priya','priya@mail.com','2025-01-10'),
('Amit','amit@mail.com','2025-02-12'),
('Riya','riya@mail.com','2025-03-05');
INSERT INTO issued_books(book_id, members_id, issued_date, status) VALUES
(1,1,'2025-12-01','Issued'),
(2,2,'2025-12-05','Issued'),
(3,3,'2025-11-20','Returned');
-- 1. List all books with author names (JOIN)
select b.title,a.author_name
from books b
join authors a on b.author_id=a.author_id;
-- 2. Find books currently issued
SELECT b.title, m.member_name, i.issued_date
FROM issued_books i
JOIN books b ON i.book_id = b.book_id
JOIN members m ON i.members_id = m.members_id
WHERE i.status = 'Issued';
-- 3. Total copies of books by each author
SELECT a.author_name, SUM(b.copies) AS total_copies
FROM authors a
JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_name;
-- 4. Member issue count
SELECT m.member_name, COUNT(i.issued_id) AS books_taken
FROM members m
LEFT JOIN issued_books i ON m.members_id = i.members_id
GROUP BY m.member_name;
-- 5. Find author who has most copies in library (Subquery)
SELECT author_name FROM authors
WHERE author_id = (
    SELECT author_id FROM books
    ORDER BY copies DESC LIMIT 1
);

-- 6. Mark a book as returned
UPDATE issued_books 
SET return_date = '2025-12-25', status = 'Returned'
WHERE issued_id = 1;

-- 7. Reduce copies when a book is lost
UPDATE books 
SET copies = copies - 1
WHERE book_id = 2 AND copies > 0;

-- 8. Books never issued (LEFT JOIN)
SELECT b.title FROM books b
LEFT JOIN issued_books i ON b.book_id = i.book_id
WHERE i.issued_id IS NULL;

-- 9. Get books issued in last 30 days
SELECT * FROM issued_books
WHERE issued_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 10. Add new column and update values
ALTER TABLE books ADD COLUMN rating FLOAT CHECK (rating BETWEEN 0 AND 5);
UPDATE books SET rating = 4.5 WHERE book_id = 2;

-- 11. Search book by partial name
SELECT * FROM books WHERE title LIKE '%Harry%';

-- 12. Delete rule simulation (first delete child then parent)
DELETE FROM issued_books WHERE book_id = 3;
DELETE FROM books WHERE book_id = 3;





