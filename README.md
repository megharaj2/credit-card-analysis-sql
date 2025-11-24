# Credit Card Analysis Using SQL (India)

This project analyzes credit card transactions across major Indian cities using **MySQL**.  
It includes complete SQL scripts, insights, and output explanations to help understand customer spending behavior, city trends, card performance, and advanced analytics like MoM growth and outlier detection.

---

## 📁 Repository Structure

```

📦 credit-card-analysis-sql
├── 📄 Credit card transactions - India - Simple.csv   # Dataset
├── 📄 credit.sql                                      # All SQL queries
└── 📄 credit_mysql.pdf                                # PDF result / documentation

```

---

## 📌 Project Objectives

This SQL project explores:

### ✔ Basic Data Exploration  
- Previewing the dataset  
- Total transactions  
- Total spending  
- Unique card types  
- Unique expense categories  

### ✔ Spending Insights  
- City-wise spending  
- Card type spending  
- Gender-wise contribution  
- Category-level spend statistics  

### ✔ Time-Series Analysis  
- Monthly spending trend  
- Running cumulative spending  
- Highest spending month per card type  

### ✔ Outlier & Risk Analysis  
- High-risk (> ₹10,000) transactions  
- Outliers compared to city averages  
- Weekend spend-to-transaction ratio  

### ✔ Advanced SQL Insights  
- Month-over-Month growth (Jan 2014 vs Dec 2013)  
- Top 5 expensive cities  
- % contribution of top cities to total spend  
- Fastest city to reach 500 transactions  

---

## 🗂 SQL File Description — **credit.sql**

All major SQL techniques used:

### 🔹 **1. Aggregate Functions**
`SUM()`, `COUNT()`, `AVG()`

### 🔹 **2. Window Functions**
`RANK()`, `ROW_NUMBER()`, running totals, partitioned averages

### 🔹 **3. Common Table Expressions (CTEs)**
Used for monthly summaries, city summaries, MoM growth

### 🔹 **4. Date Functions**
`STR_TO_DATE()`, `YEAR()`, `MONTH()`, `DAYOFWEEK()`

### 🔹 **5. Analytical Queries**
- MoM growth  
- Outlier detection  
- Spend ratios  
- Ranking cities  

---

## 🧠 Key Insights You Can Derive

- Which cities spend the most?  
- Which card type drives highest revenue?  
- Which expense categories are most popular?  
- How does spending vary month to month?  
- Which cities have unusual (high-risk) transactions?  
- Which card and expense type showed the highest MoM growth in Jan 2014?  

---

## 🛠 Tools Used

- **MySQL 8+**
- **VS Code / MySQL Workbench**
- **Excel / CSV viewer**
- (Optional) Tableau or Power BI for visuals  

---

## 📄 Documentation

See **credit_mysql.pdf** for a formatted version of the analysis.

---

## 📬 Contact

https://www.linkedin.com/in/megha-rajeev-p-b56a2a237/
Feel free to reach out if you want to improve this project further or add dashboards!

---

