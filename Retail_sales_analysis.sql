-- Create and use retail_sales database
CREATE DATABASE retail_sales; 
USE retail_sales;

-- Dropping Table
Drop Table if exists Orders;
Drop Table if exists products;
Drop Table if exists customers;

-- Create Customer table
Create table customers( 
	customer_id INT Primary Key auto_increment,
    customer_name Varchar(100),
    city Varchar(50),
    email Varchar(100));
  
 -- Create product table 
Create table products( 
	product_id INT Primary Key auto_increment,
    product_name Varchar(100),
    category Varchar(50),
    price decimal(6,2));    
  
 -- Create Orders table
  Create table orders( 
	order_id INT Primary Key auto_increment,
    customer_id int, -- foreign key
    product_id INT, -- foreign key
    Quantity int,
    order_date date); 
    
 -- Inserting data in customer table   
 Insert into customers (customer_name, city, email)
  Values ('Raj', 'Karachi', 'abc@gmail.com'), 
		('Akash', 'Pano_Akil', 'aaka@outlook.com'),
		('kapil', 'Pano_Akil', 'Kapu@yahoo.com'),
        ('Nitesh', 'Sukkur', 'nite@gmail.com');
  
   -- Inserting data in products table  
  Insert into products(product_name, category, price)
  Values ('Table', 'Furniture', 80),
		('Chair', 'Furniture', 100), 
        ('Desk', 'Steel', 30),
        ('Bolt', 'Plumbing', 0.55),
        ('Pipe', 'Plumbing', 10.50);

-- Inserting data in orders table  
Insert into orders(customer_id, product_id, Quantity, order_date)
Values (1, 2, 3, '2024-01-15'),
		(2, 1, 1, '2024-01-22'),
        (3, 5, 4, '2024-02-10'), 
		(1, 3, 2, '2024-02-18'),
		(4, 4, 10, '2024-03-05'),
		(2, 2, 2, '2024-03-17'),
		(3, 1, 1, '2024-04-02'),
		(4, 5, 6, '2024-04-20'),
		(1, 4, 20, '2024-05-11'),
		(2, 3, 3, '2024-05-28');
    
-- What are the total sales per product?  
 select product_name, Sum(orders.quantity * products.price) AS Revenue from products
	join orders ON products.product_id = Orders.product_id
	GROUP BY product_name
    ORDER BY Revenue DESC;
    
-- Which month had the highest revenue?  
Select monthname(order_date) As Month, Sum(orders.quantity * products.price) AS Revenue from orders
	join products ON Orders.product_id = products.product_id 
	GROUP BY monthname(order_date)
    ORDER BY Revenue DESC;
    
 -- Who are the top customers by spending?
Select customer_name, Sum(Orders.Quantity * products.price) As Total_Spent from customers
	Join Orders On customers.customer_id = orders.customer_id
    Join products On Orders.product_id = products.product_id 
    group by  customer_name
    Order By Total_Spent Desc;
    
-- What is the best-selling category?
Select category, Sum(quantity) As total_quantity from products
	join Orders On products.product_id = orders.product_id
	group by category 
	Order by total_quantity Desc; 
    
--  What is the average order value?
Select Avg(price*quantity) As Avg_Order_Value from products
	join Orders On products.product_id = orders.product_id;
    
-- Which city has the most customers?
Select count(customer_id) As Count, city from customers
	group by city
    order by Count Desc;
    
--  How many orders were placed each month?
Select monthname(order_date) As Month, count(order_id) As Order_Quantity from orders
	group by Month
    order by Order_Quantity Desc;
    
-- Which product has been ordered the most times?
Select product_name, count(order_id) As Count from products
	join orders On products.product_id = orders.product_id
	group by product_name 
    order by Count Desc;
    
-- Which products have never been ordered?
Select product_name, order_id from products
	Left Join orders On products.product_id = orders.product_id
    Where orders.order_id is null
    
-- What percentage of total revenue does each product contribute?
SELECT product_name,
       SUM(quantity * price) AS Revenue,
       SUM(quantity * price) / (SELECT SUM(quantity * price) FROM orders JOIN products ON orders.product_id = products.product_id) * 100 AS Percentage
FROM products
JOIN orders ON products.product_id = orders.product_id
GROUP BY product_name;
    
-- What percentage of total orders does each customer contribute?
Select customer_name, 
		count(order_id) As Total_Orders,
        count(order_id) / (Select count(order_id) from orders) * 100
		from customers join orders On customers.customer_id = orders.order_id
        GROUP BY customer_name;
        
-- Categorize customers as High, Medium or Low Spender
SELECT customer_name,
       SUM(orders.quantity * products.price) AS Total_Spent,
       CASE
           WHEN SUM(orders.quantity * products.price) > 500 THEN 'High Spender'
           WHEN SUM(orders.quantity * products.price) BETWEEN 200 AND 500 THEN 'Medium Spender'
           ELSE 'Low Spender'
       END AS Spender_Category
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN products ON orders.product_id = products.product_id
GROUP BY customer_name
ORDER BY Total_Spent DESC;
