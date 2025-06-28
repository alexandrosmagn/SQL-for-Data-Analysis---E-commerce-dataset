/*SQL-for-Data-Analysis---E-commerce-dataset*/


/*Before you run these queries, make sure to create Brazilian_E-Commerce_Public_Dataset Database and import the related data first*/


--How many orders have at least 3 in review score
SELECT COUNT(review_score)
FROM [Brazilian_E-Commerce_Public_Dataset].dbo.olist_order_reviews_dataset
WHERE review_score >= 3


--Which date last order was sent?
SELECT MAX(a.order_delivered_carrier_date)
FROM [Brazilian_E-Commerce_Public_Dataset].dbo.olist_orders_dataset a


--How many products have the word fashion in them?
SELECT COUNT(*)
FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_products_dataset] 
WHERE product_category_name LIKE 'fashion%'


--Which seller ids are from sao paulo and curitiba?
SELECT a.seller_id
FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_sellers_dataset] a
WHERE a.seller_city IN ('sao paulo','curitiba')


--Products with weight between 2000 and 6000
SELECT a.product_id,a.product_weight_g
FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_products_dataset] a
WHERE a.product_weight_g BETWEEN 2000 AND 6000


--Which orders have a total of payment value greater than 10000?
SELECT order_id,SUM(payment_value)
FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_order_payments_dataset]
GROUP BY order_id
HAVING SUM(payment_value) > 10000


--Categorizing orders by review score
SELECT  a.review_id,a.review_score,
		CASE
			WHEN a.review_score <= 2 THEN 'Bad'
			WHEN a.review_score <= 4 THEN 'Good'
			ELSE 'Perfect'
		END AS review_category
FROM [Brazilian_E-Commerce_Public_Dataset].dbo.olist_order_reviews_dataset a


--Which are the 10 most ordered product categories?
SELECT TOP 10 a.product_category_name,COUNT(b.product_id) times_ordered
  FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_products_dataset] a
  JOIN [Brazilian_E-Commerce_Public_Dataset].dbo.[olist_order_items_dataset] b
  ON a.product_id = b.product_id
  GROUP BY a.product_category_name
  ORDER BY 2 DESC
   

--What is the difference from the average price for each product?
SELECT [order_id]
      ,[order_item_id]
      ,[product_id]
      ,[seller_id]
      ,[shipping_limit_date]
      ,[price]
	  ,AvgPriceDiff = price - (SELECT AVG(price) FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_order_items_dataset])
  FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_order_items_dataset]



--Cities with customers with the most orders ranked
SELECT  c.customer_city,
		No_of_orders = COUNT(DISTINCT(o.customer_id)),
		[City Rank] = RANK() OVER(ORDER BY COUNT(DISTINCT(o.customer_id)) DESC)
FROM [Brazilian_E-Commerce_Public_Dataset].[dbo].[olist_customers_dataset] c
JOIN [Brazilian_E-Commerce_Public_Dataset].dbo.olist_orders_dataset o
ON c.customer_id = o.customer_id
GROUP BY C.customer_city
ORDER BY 2 DESC