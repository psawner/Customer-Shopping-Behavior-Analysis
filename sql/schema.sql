CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
age INT,
gender VARCHAR(10),
location VARCHAR(100),
subscription_status VARCHAR(20)
);

CREATE TABLE products (
product_id INT AUTO_INCREMENT PRIMARY KEY,
item_purchased VARCHAR(100),
category VARCHAR(50),
size VARCHAR(10),
color VARCHAR(20)
);

CREATE TABLE purchases (
purchase_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
product_id INT,
purchase_amount DECIMAL(10,2),
season VARCHAR(20),
payment_method VARCHAR(50),
shipping_type VARCHAR(50),
discount_applied VARCHAR(10),
previous_purchases INT,
review_rating FLOAT,
frequency_of_purchases VARCHAR(50),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
