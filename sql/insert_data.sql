USE ecommerce_analytics;

INSERT INTO customers (customer_id, age, gender, location, subscription_status)
SELECT DISTINCT
Customer_ID,
Age,
Gender,
Location,
Subscription_Status
FROM raw_data;


INSERT INTO products (item_purchased, category, size, color)
SELECT DISTINCT
Item_Purchased,
Category,
Size,
Color
FROM raw_data;

INSERT INTO purchases (
customer_id,
product_id,
purchase_amount,
season,
payment_method,
shipping_type,
discount_applied,
previous_purchases,
review_rating,
frequency_of_purchases
)
SELECT
r.Customer_ID,
p.product_id,
r.Purchase_Amount,
r.Season,
r.Payment_Method,
r.Shipping_Type,
r.Discount_Applied,
r.Previous_Purchases,
r.Review_Rating,
r.Frequency_of_Purchases
FROM raw_data r
JOIN products p
ON r.Item_Purchased = p.item_purchased
AND r.Category = p.category
AND r.Size = p.size
AND r.Color = p.color;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM purchases;