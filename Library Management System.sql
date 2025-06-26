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
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(10),
issued_book_name VARCHAR(75),	
issued_date	DATE,
issued_book_isbn VARCHAR(25),
issued_emp_id VARCHAR(15)
);
-- DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
return_book_name VARCHAR(75),
return_date	DATE,
return_book_isbn VARCHAR(20)
);





