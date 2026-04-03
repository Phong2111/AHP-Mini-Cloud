CREATE DATABASE minicloud;
USE minicloud;

CREATE TABLE students(
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100)
);

INSERT INTO students(name) VALUES ('Phong'),('An'),('Hao');