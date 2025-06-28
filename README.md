# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_management_system`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](library.jpg)
## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](EER Diagram.mwb)

- **Database Creation**: Created a database named `library_management_system`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Library Managment System Project 2
CREATE DATABASE library_Management_System;
USE library_Management_System

-- createing branch table
CREATE TABLE branch(
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(10)
);
ALTER TABLE branch
MODIFY COLUMN contact_no VARCHAR(20);

-- DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
emp_id	VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(25),
position VARCHAR(10),	
salary INT,	
branch_id VARCHAR(25)
);
-- DROP TABLE IF EXISTS books;
CREATE TABLE books (
isbn VARCHAR(20) PRIMARY KEY,	
book_title VARCHAR(75),	
category VARCHAR(10),
rental_price FLOAT,
status VARCHAR (15),
author VARCHAR(35),
publisher VARCHAR(50)
);

CREATE TABLE members (
member_id VARCHAR(10) PRIMARY KEY,
member_name	VARCHAR(30),
member_address	VARCHAR(70),
reg_date DATE
);

CREATE TABLE issued_status (
issued_id VARCHAR(10) PRIMARY KEY,-- fk
issued_member_id VARCHAR(10),
issued_book_name VARCHAR(75),	
issued_date	DATE,
issued_book_isbn VARCHAR(25),-- fk
issued_emp_id VARCHAR(15)-- fk
);
-- DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
return_book_name VARCHAR(75),
return_date	DATE,
return_book_isbn VARCHAR(20)
);
 -- FOREIGN KEY
 ALTER TABLE issued_status
 ADD CONSTRAINT fk_members
 FOREIGN KEY (issued_member_id)
 REFERENCES members(member_id);

 ALTER TABLE issued_status
 ADD CONSTRAINT fk_books
 FOREIGN KEY (issued_book_isbn)
 REFERENCES books(isbn);

 ALTER TABLE issued_status
 ADD CONSTRAINT fk_employees
 FOREIGN KEY (issued_emp_id)
 REFERENCES employees(emp_id);
 
 ALTER TABLE employees
 ADD CONSTRAINT fk_branch
 FOREIGN KEY (branch_id)
 REFERENCES branch(branch_id);
 
 ALTER TABLE return_status
 ADD CONSTRAINT fk_issued_status
 FOREIGN KEY (issued_id)
 REFERENCES issued_status(issued_id);
 
 select * from return_status

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES('978-1-06129-456-2', 'To Kill a Mockingbird', 'Classic',6.00, 'yes', 'Harper lee', 'J.B. Lippincott & Co');
select * from books;

```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
select * from members;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS107';
select * from issued_status;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT* FROM issued_status
WHERE issued_emp_id = 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT issued_emp_id, COUNT(issued_id) AS total_book_count
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issud_cnt 
AS
SELECT
b.isbn,
b.book_title,
COUNT(ist.issued_id) AS no_issued
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;
SELECT * FROM book_issud_cnt;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT b.category, SUM(b.rental_price),
COUNT(*)
FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn=b.isbn
GROUP BY 1;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY ;

INSERT members(member_id,member_name, member_address,reg_date)
VALUES 
('C120','Jyotirmay Das', '136 Main St','2025-02-25'),
('C121','Dev Das', '137 Main St','2025-01-25');
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
e1.*,
b.manager_id,
e2.emp_name as manager 
FROM employees as e1
JOIN branch as b
ON b.branch_id = e1.branch_id
JOIN employees as e2
ON b.manager_id = e2.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE book_with_rental_price
AS
SELECT * FROM books
WHERE rental_price > 7;
select * from book_with_rental_price;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

## Advanced SQL Operations

Task 13: **Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).Display the member's_id, member's name,
book title, issue date, and days overdue.**
```sql
SELECT 
ist.issued_member_id,
m.member_name,
b.book_title,
ist.issued_date,
-- rs.return_date,
CURDATE() - ist.issued_date AS over_dues_days
FROM issued_status as ist
JOIN 
members AS m
ON m.member_id = ist.issued_member_id
JOIN books AS b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id
WHERE 
rs.return_date IS NULL
AND
(CURDATE() - ist.issued_date) > 30
ORDER BY 1;
```
Task 14: **update Book Status on Return
 Write a query to update the status of books in the books table to "yes" when they are returned 
(based on entries in the return_status table).**
``` sql
SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM return_status
WHERE issued_id = 'IS120';
```
Task 15: **Branch Performance Report
Create a query that generates a perfromance report for each branch. Showing the nubmer of books issued, the number of
books returned, and the total revenue generated from book rentals.**
``` sql
USE library_management_system;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM return_status;

CREATE TABLE branch_reports AS
SELECT 
b.branch_id,
b.manager_id,
COUNT(ist.issued_id) as number_books_issued,
COUNT(r.return_id) as number_of_book_return,
SUM(bk.rental_price) as total_revenue
FROM issued_status AS ist
JOIN employees as e
ON e.emp_id = ist.issued_emp_id
JOIN branch as b
ON e.branch_id = b.branch_id
LEFT JOIN return_status as r
ON r.issued_id= ist.issued_id
JOIN books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2;
```

Task 16: **Create a Table of Active Memebers
Use the Crete table as (CTAS) statement to create a new table active_members 
cotaining members who have issued at least on book in the last 2 months.**
``` sql 
CREATE TABLE active_members AS
SELECT * FROM members
WHERE member_id IN
(
SELECT 
DISTINCT issued_member_id
FROM issued_status
WHERE issued_date >= DATE('2024-04-13') - INTERVAL 2 MONTH
);
```

Task 17: **Find the employees with Most Book Issues Processed
  Uae a queary to find the top 3 employees who have processed the most book issues.
  Display the employee name, number of books precessed , and their branch.**
``` sql 

SELECT * FROM employees;
SELECT e.emp_name,
b.*,
count(ist.issued_id) as no_book_issued
FROM issued_status as ist
join employees as e
on e.emp_id = ist.issued_emp_id
join branch as b
on e.branch_id = b.branch_id
GROUP BY 1,2;
``` 
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Author - Jyotirmay Das

Thank you for your interest in this project!
