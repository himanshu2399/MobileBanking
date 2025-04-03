CREATE DATABASE test_db;
USE test_db;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

INSERT INTO employees (name, department, salary, hire_date) VALUES
('John Doe', 'Engineering', 75000.00, '2023-01-15'),
('Jane Smith', 'HR', 60000.00, '2022-09-23');

SELECT * FROM employees;
