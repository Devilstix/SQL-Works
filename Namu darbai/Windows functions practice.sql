-- 1. Calculate Running Total of Sales: Use the SUM() window func<on to calculate a
-- running total of sales for each year.

SELECT
    YEAR(OrderDate) AS Metai,
    OrderDate,
    SalesOrderID,
    TotalDue,
	ROUND(SUM(TotalDue) OVER (
        PARTITION BY YEAR(OrderDate)
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS running_total_year
FROM sales_salesorderheader
ORDER BY Metai, OrderDate;
	
-- 2. Rank Sales by Year: Use the RANK() window func<on to rank sales by the total
-- amount each year within each product category.
SELECT
	YEAR(soh.OrderDate) AS Metai
    , c.Name AS Kategorija
    , ROUND(SUM(sod.LineTotal), 2) AS Suma
    , RANK () OVER (
		PARTITION BY YEAR(soh.OrderDate)
        ORDER BY SUM(sod.LineTotal) DESC) AS Rankas
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product pp ON sod.ProductID = pp.ProductID
JOIN production_productsubcategory psc ON pp.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_productcategory c ON psc.ProductCategoryID = c.ProductCategoryID
GROUP BY Metai, Kategorija
ORDER BY Metai ASC, Suma DESC, Rankas DESC;

-- 3. Find the Top 3 Products by Sales in Each Category: Use the ROW_NUMBER() window
-- func<on to iden<fy the top 3 products by sales amount within each category.

SELECT
	pp.Name AS Produktas
    , c.Name AS Kategorija
    , ROUND(SUM(sod.LineTotal), 2) AS Suma
    , ROW_NUMBER() OVER (
		PARTITION BY c.Name
        ORDER BY SUM(sod.LineTotal) DESC) AS Eile
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product pp ON sod.ProductID = pp.ProductID
JOIN production_productsubcategory psc ON pp.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_productcategory c ON psc.ProductCategoryID = c.ProductCategoryID
WHERE Eile <= 3
GROUP BY Produktas, Kategorija
ORDER BY Eile DESC;


-- chatgpt

SELECT
    CategoryName,
    ProductName,
    total_sales
FROM (
    SELECT
        pc.Name AS CategoryName,
        p.Name  AS ProductName,
        SUM(sod.LineTotal) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY pc.Name
            ORDER BY SUM(sod.LineTotal) DESC
        ) AS rn
    FROM sales_salesorderdetail sod
    JOIN production_product p
        ON sod.ProductID = p.ProductID
    JOIN production_productsubcategory psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN production_productcategory pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        pc.Name,
        p.Name
) ranked
WHERE rn <= 3
ORDER BY CategoryName, total_sales DESC;

-- 4. Calculate the Moving Average of Monthly Sales: Use the AVG() window func<on to
-- calculate a 3-month moving average of sales.


-- 5. Compare Individual Sales to Average Sales: Use the AVG() window func<on to
-- compare individual sales amounts to the average sales of the respec<ve year.
-- 6. Par<<on Sales by Territory and Rank: Use the DENSE_RANK() window func<on to
-- rank sales orders by amount within each sales territory.
-- 7. Calculate Percen<le Sales: Use the PERCENT_RANK() window func<on to calculate
-- the percen<le rank of sales orders by amount within each year.
-- 8. Iden<fy First and Last Sale Date for Each Product: Use the FIRST_VALUE() and
-- LAST_VALUE() window func<ons to find the first and last sale date for each product.
-- 9. Calculate Cumula<ve Quan<ty Sold: Use the SUM() window func<on to calculate the
-- cumula<ve quan<ty sold for each product over <me.
-- 10. Compare Sales Growth by Quarter: Use the LAG() window func<on to compare sales
-- amounts between consecu<ve quarters to calculate quarter-over-quarter growth.
-- 11. Determine Employee Ranking by Sales: Use the RANK() window func<on to rank
-- employees by the total sales they generated.
-- 12. Segment Customers Based on Total Purchases: Use the NTILE() window func<on to
-- divide customers into quar<les based on their total purchase amount.
-- 13. Calculate YTD (Year-to-Date) Sales: Use the SUM() window func<on with a specific
-- range to calculate year-to-date sales for each product.
-- 14. Analyze Variance in Monthly Sales: Use the STDDEV() window func<on to calculate
-- the standard devia<on of sales amounts for each month to analyze vola<lity.