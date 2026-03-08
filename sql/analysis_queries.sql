USE ecommerce_analytics;

------------------------------------------------ Total Revenue
-- How much revenue did the store generate?

SELECT SUM(purchase_amount) AS total_revenue
FROM purchases;

---------------------------------------------- Revenue by Category
-- Which categories generate the most revenue?

SELECT category, SUM(purchase_amount) revenue
FROM purchases p
JOIN products pr ON p.product_id = pr.product_id
GROUP BY category
ORDER BY revenue DESC;

SELECT pr.category,
SUM(p.purchase_amount) revenue
FROM purchases p
JOIN products pr
ON p.product_id = pr.product_id
GROUP BY pr.category
ORDER BY revenue DESC;

-------------------------------------------------- Top Spending Customers
SELECT customer_id,
SUM(purchase_amount) total_spent
FROM purchases
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

---------------------------------------------------- Average Purchase Value by Gender
SELECT c.gender,
AVG(p.purchase_amount) avg_purchase
FROM purchases p
JOIN customers c
ON p.customer_id = c.customer_id
GROUP BY c.gender;

--------------------------------------------- Payment Method Distribution
SELECT payment_method,
COUNT(*) total_orders
FROM purchases
GROUP BY payment_method
ORDER BY total_orders DESC;

------------------------------------------------ Seasonal Revenue Trends
SELECT season,
SUM(purchase_amount) revenue
FROM purchases
GROUP BY season
ORDER BY revenue DESC;

---------------------------------------------- Discount Impact on Spending
SELECT discount_applied,
AVG(purchase_amount) avg_spend
FROM purchases
GROUP BY discount_applied;

--------------------------------------------- Top Products by Revenue
SELECT pr.item_purchased,
SUM(p.purchase_amount) revenue
FROM purchases p
JOIN products pr
ON p.product_id = pr.product_id
GROUP BY pr.item_purchased
ORDER BY revenue DESC
LIMIT 10;

------------------------------------------------ Customer Lifetime Value
SELECT customer_id,
SUM(purchase_amount) lifetime_value
FROM purchases
GROUP BY customer_id
ORDER BY lifetime_value DESC;


SELECT
customer_id,
SUM(purchase_amount) total_spent,
RANK() OVER (ORDER BY SUM(purchase_amount) DESC) customer_rank
FROM purchases
GROUP BY customer_id;