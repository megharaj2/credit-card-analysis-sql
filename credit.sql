CREATE database credit;
use credit;

-- Preview first 10 rows
SELECT * FROM credit_card_transactions LIMIT 10;

-- Count total transactions
SELECT COUNT(*) AS total_transactions FROM credit_card_transactions;

-- Total amount spent
SELECT SUM(Amount) AS total_amount_spent FROM credit_card_transactions;

-- Unique card types used
SELECT DISTINCT card_Type FROM credit_card_transactions;

-- Unique expense categories
SELECT DISTINCT exp_Type FROM credit_card_transactions;

-- Total spending by city
SELECT City, SUM(Amount) AS total_spending FROM credit_card_transactions
GROUP BY City ORDER BY total_spending DESC LIMIT 10;

-- Spending by card type
SELECT Card_Type, SUM(Amount) AS total_spending FROM credit_card_transactions
GROUP BY Card_Type ORDER BY total_spending DESC;

-- Spending per gender
SELECT Gender, SUM(Amount) AS total_spending FROM credit_card_transactions GROUP BY Gender;

-- High-Risk Transaction Identification(High risk = unusually high-spend)
-- Find transactions above ₹10,000
SELECT * FROM credit_card_transactions
WHERE Amount > 10000 ORDER BY Amount DESC LIMIT 10;

-- Monthly Spending Trend
SELECT 
    YEAR(STR_TO_DATE(Date, '%d-%b-%y')) AS year,
    MONTH(STR_TO_DATE(Date, '%d-%b-%y')) AS month,
    SUM(Amount) AS monthly_spending
FROM credit_card_transactions
GROUP BY 
    YEAR(STR_TO_DATE(Date, '%d-%b-%y')), 
    MONTH(STR_TO_DATE(Date, '%d-%b-%y'))
ORDER BY year, month LIMIT 10;

-- Category-wise Total & Average Spending. Using CTE to get summary statistics for each expense type
WITH exp_summary AS (
    SELECT	Exp_Type,
        SUM(Amount) AS total_spending,
        AVG(Amount) AS avg_spending,
        COUNT(*) AS transaction_count
    FROM credit_card_transactions
    GROUP BY Exp_Type
)
SELECT * FROM exp_summary ORDER BY total_spending DESC;

-- Find Top 5 Most Expensive Cities
WITH city_spending AS (
    SELECT City, SUM(Amount) AS total_spending FROM credit_card_transactions GROUP BY City
)
SELECT * FROM city_spending ORDER BY total_spending DESC
LIMIT 5;

-- Rank Cities by Spending. RANK() to find top spending cities without removing others
SELECT City,
    SUM(Amount) AS total_spending,
    RANK() OVER (ORDER BY SUM(Amount) DESC) AS spending_rank
FROM credit_card_transactions GROUP BY City LIMIT 10;

-- Running Total (Cumulative Spending Over Time) OR Running total of spending by date
SELECT Date, Amount,
    SUM(Amount) OVER (ORDER BY Date) AS running_total
FROM credit_card_transactions ORDER BY Date LIMIT 10;

-- Detect Outliers (Amount vs City Avg) OR Compare each transaction with city average spending
SELECT City, Amount,
    AVG(Amount) OVER (PARTITION BY City) AS city_avg,
    Amount - AVG(Amount) OVER (PARTITION BY City) AS deviation
FROM credit_card_transactions
LIMIT 10;

-- Print Top 5 Cities With Highest Spends And Their Percentage Contribution Of Total Credit Card Spends
WITH citysum AS (
    SELECT city, SUM(amount) AS total_spend FROM credit_card_transactions
    GROUP BY city
),
total_spent AS (
    SELECT SUM(amount) AS total_amount FROM credit_card_transactions
)
SELECT city, total_spend,
    ROUND((total_spend / total_amount) * 100, 2) AS pct_contribution
FROM citysum
CROSS JOIN total_spent ORDER BY total_spend DESC LIMIT 5;


-- Highest Amount Spent in a Month for Each Card Type
WITH m AS (
  SELECT card_type, YEAR(STR_TO_DATE(Date,'%d-%b-%y')) yr,
         MONTH(STR_TO_DATE(Date,'%d-%b-%y')) mn, SUM(amount) total_spent
  FROM credit_card_transactions GROUP BY card_type, yr, mn
)
SELECT card_type, yr, mn, total_spent
FROM (SELECT m.*, RANK() OVER(PARTITION BY card_type ORDER BY total_spent DESC) r FROM m) x
WHERE r = 1
LIMIT 5;


-- Percentage Spend Contribution by Females for Each Expense Type 
SELECT 
    exp_type,
    ROUND(SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) 
          / SUM(amount) * 100, 2) AS female_spent_percent
FROM credit_card_transactions
GROUP BY exp_type
ORDER BY female_spent_percent DESC;


-- Jan-2014 Month over Month growth
WITH m AS (
  SELECT card_type, exp_type, YEAR(STR_TO_DATE(Date,'%d-%b-%y')) yr,
         MONTH(STR_TO_DATE(Date,'%d-%b-%y')) mn, SUM(amount) total_spend
  FROM credit_card_transactions GROUP BY card_type, exp_type, yr, mn
),
g AS (
  SELECT t.card_type, t.exp_type, t.total_spend - p.total_spend AS mom_growth
  FROM m t JOIN m p ON t.card_type=p.card_type AND t.exp_type=p.exp_type
  WHERE t.yr=2014 AND t.mn=1 AND p.yr=2013 AND p.mn=12
)
SELECT * FROM g ORDER BY mom_growth DESC LIMIT 1;


-- Query to Find Which City Has Highest (Total Spend to Total No of Transactions) Ratio During Weekends
SELECT City,
    SUM(Amount) / COUNT(*) AS spend_per_txn
FROM credit_card_transactions
WHERE DAYOFWEEK(STR_TO_DATE(Date, '%d-%b-%y')) IN (1,7)
GROUP BY City ORDER BY spend_per_txn DESC
LIMIT 1;


-- Query to Find Which City Took Least Number of Days to Reach Its 500th Transaction After the First Transaction
WITH t AS (
  SELECT city, STR_TO_DATE(Date,'%d-%b-%y') AS dt,
         ROW_NUMBER() OVER(PARTITION BY city ORDER BY STR_TO_DATE(Date,'%d-%b-%y')) rn
  FROM credit_card_transactions
)
SELECT city,
       DATEDIFF(MAX(CASE WHEN rn=500 THEN dt END),
                MIN(dt)) AS days_to_500
FROM t
GROUP BY city HAVING COUNT(*) >= 500
ORDER BY days_to_500 ASC LIMIT 1;

