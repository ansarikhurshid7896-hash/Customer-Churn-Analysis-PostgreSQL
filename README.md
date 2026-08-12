# 📊 Customer Churn Analysis — PostgreSQL

A comprehensive **Customer Churn Analysis project built using PostgreSQL** to identify customer behavior, churn patterns, payment issues, service usage, support interactions, and factors associated with customer churn.

The project uses SQL for data exploration, customer segmentation, churn analysis, behavioral analysis, and advanced analytical queries using **CTEs, aggregate functions, subqueries, CASE statements, `ROW_NUMBER()`, `LAG()`, and `UNION ALL`**.

---

## 🎯 Project Overview

Customer churn is an important business problem because losing existing customers can directly affect revenue and long-term growth.

This project analyzes a customer dataset to understand:

- Overall customer churn
- Churn rate
- Churn by subscription plan
- Churn reasons
- Payment behavior
- Late payments
- Customer usage patterns
- Customer satisfaction
- Support ticket activity
- Online security and technical support
- Contract types
- Customer risk indicators
- Month-over-month usage changes

The goal is to use SQL to transform raw customer data into meaningful business insights.

---

## 🏢 Business Problem

A telecommunications/business organization wants to understand why customers are leaving and which customers are more likely to churn.

The analysis attempts to answer questions such as:

- What percentage of customers have churned?
- Which subscription plans have the highest churn?
- What are the most common reasons for churn?
- Are customers with late payments more likely to churn?
- Does customer satisfaction affect churn?
- Does technical support affect churn?
- Does online security affect churn?
- How does customer usage change over time?
- Which customers show multiple indicators of potential churn risk?

---

## 🗂️ Dataset

The project uses multiple CSV files representing different areas of customer information.

### Dataset Tables

| Table | Description |
|---|---|
| `customers` | Customer demographic and basic customer information |
| `subscriptions` | Customer subscription and plan information |
| `services` | Services used by customers |
| `payments` | Customer payment records and payment status |
| `customer_usage` | Customer usage information over time |
| `support_tickets` | Customer support interactions |
| `churn_events` | Customer churn information and churn reasons |

---

## 🏗️ Database Structure

The project uses `customer_id` as the main customer identifier connecting the different tables.

```text
                         customers
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
       subscriptions     services       payments
              │              │              │
              └──────────────┼──────────────┘
                             │
                             ▼
                     customer_usage
                             │
                             ▼
                    support_tickets
                             │
                             ▼
                      churn_events
```

---

## 🛠️ Tools & Technologies

| Technology | Purpose |
|---|---|
| **PostgreSQL** | Database management and SQL analysis |
| **SQL** | Data querying and analysis |
| **CTEs** | Building multi-step analytical queries |
| **Window Functions** | Customer-level and time-based analysis |
| **Aggregate Functions** | KPI and statistical calculations |
| **CASE Statements** | Customer classification and segmentation |
| **Git & GitHub** | Version control and project hosting |

---

## 🔍 Analysis Performed

### Phase 1 — Basic Customer Analysis

The initial analysis focuses on understanding the customer base.

Examples include:

- Total number of customers
- Customer distribution by region
- Customers subscribed to different plans
- Average monthly charge
- Most common contract types
- Customer and subscription distribution

---

### Phase 2 — Churn Analysis

The second phase focuses on identifying churn patterns.

Analysis includes:

- Overall churn rate
- Churn by subscription plan
- Most common churn reasons
- Late payment vs churn
- Technical support vs churn
- Online security vs churn
- Customer satisfaction vs churn
- Support ticket count vs churn

---

## 📈 Churn Rate

The overall churn rate is calculated by comparing the number of churned customers with the total number of customers.

Conceptually:

```text
Churn Rate =
Number of Churned Customers
----------------------------
Total Number of Customers
× 100
```

This provides a high-level measurement of customer retention performance.

---

## 💳 Payment Behavior Analysis

Payment behavior is analyzed to understand whether payment issues are associated with customer churn.

The analysis examines:

- Payment status
- Late payments
- Customer payment history
- Relationship between late payments and churn

This helps identify whether customers experiencing payment issues represent a higher-risk customer segment.

---

## 🎧 Support Ticket Analysis

Customer support interactions are analyzed to understand whether frequent support activity is associated with churn.

Customers are grouped based on support ticket activity and compared with their churn status.

This can help identify whether repeated support issues may indicate customer dissatisfaction.

---

## ⭐ Customer Satisfaction Analysis

Customer satisfaction is analyzed against churn behavior.

This helps determine whether customers with lower satisfaction levels show higher churn tendencies.

---

## 🔐 Service Analysis

The project analyzes services such as:

- Technical Support
- Online Security

Their relationship with customer churn is examined to understand whether service availability or usage is associated with retention.

---

## 📅 Time-Based Usage Analysis

Customer usage is analyzed over time to identify changes in customer activity.

A SQL window function such as `LAG()` is used to compare a customer's current usage with their previous recorded usage.

Conceptually:

```text
Current Usage
      ↓
Previous Usage
      ↓
Month-over-Month Change
```

This helps identify customers whose usage is increasing or decreasing over time.

---

## 🧮 Advanced SQL Techniques

This project demonstrates several intermediate and advanced SQL concepts.

### Common Table Expressions (CTEs)

CTEs are used to break complex analytical problems into smaller, readable steps.

```sql
WITH example AS (
    SELECT ...
)
SELECT *
FROM example;
```

---

### Window Functions

Window functions are used for customer-level ranking and time-based analysis.

Examples include:

```sql
ROW_NUMBER()
LAG()
```

---

### `ROW_NUMBER()`

`ROW_NUMBER()` is used for tasks such as identifying the latest payment record for each customer.

Example concept:

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY payment_date DESC
)
```

---

### `LAG()`

`LAG()` is used to compare a customer's current record with a previous record.

Example concept:

```sql
LAG(usage_value) OVER (
    PARTITION BY customer_id
    ORDER BY usage_date
)
```

---

### `CASE`

`CASE` statements are used for classification and segmentation.

For example, customers can be grouped based on:

- Usage
- Support tickets
- Payment behavior
- Risk indicators

---

### `UNION ALL`

`UNION ALL` can be used to combine multiple churn-risk indicators into a single analytical dataset.

For example:

```text
Late Payment
      +
High Support Activity
      +
Low Satisfaction
      +
Usage Decline
      ↓
Customer Risk Indicators
```

---

## 🚨 Customer Risk Analysis

One of the advanced analyses identifies customers showing multiple potential churn indicators.

Potential indicators include:

- Late payment
- High support activity
- Low satisfaction
- Declining usage
- Other available churn-related indicators

The purpose is not to predict churn using machine learning, but to use SQL-based business rules to identify potentially high-risk customers.

---

## 📁 Project Structure

```text
Customer-Churn-Analysis/
│
├── Customer_churn_analysis_project.sql
│
├── customers.csv
├── subscriptions.csv
├── services.csv
├── support_tickets.csv
├── churn_events.csv
│
└── README.md

payments.csv and customer_usage.csv are excluded from the repository because
their file sizes exceed GitHub's individual file-size limit.
```

---

## ▶️ How to Use

### 1. Install PostgreSQL

Install PostgreSQL and open **pgAdmin** or another PostgreSQL client.

### 2. Create the Database

Create a database for the project.

Example:

```sql
CREATE DATABASE customer_churn_db;
```

### 3. Create the Tables

Create the required tables for:

```text
customers
subscriptions
services
payments
customer_usage
support_tickets
churn_events
```

### 4. Import the CSV Files

Import the corresponding CSV files into their respective PostgreSQL tables.

### 5. Run the SQL Project

Open:

```text
Customer_churn_analysis_project.sql
```

Execute the queries phase by phase.

---

## 📊 Project Workflow

```text
Raw CSV Data
     │
     ▼
PostgreSQL Database
     │
     ▼
Data Exploration
     │
     ▼
Customer Analysis
     │
     ▼
Churn Analysis
     │
     ▼
Behavioral Analysis
     │
     ▼
Advanced SQL Analysis
     │
     ▼
Customer Risk Indicators
     │
     ▼
Business Insights
```

---

## 💡 Key Business Insights

The analysis is designed to help businesses understand:

- Overall customer retention performance
- Which plans experience greater churn
- Common reasons customers leave
- Whether late payments are associated with churn
- Whether customer satisfaction affects retention
- Whether support activity is associated with churn
- How customer usage changes over time
- Which customers show multiple potential churn indicators

---

## 📚 SQL Skills Demonstrated

This project demonstrates practical experience with:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- `JOIN`
- `LEFT JOIN`
- `UNION ALL`
- `CASE`
- Aggregate Functions
- Subqueries
- Common Table Expressions (CTEs)
- `ROW_NUMBER()`
- `LAG()`
- `PARTITION BY`
- Date and time analysis
- Customer segmentation
- Churn rate calculations
- Business KPI analysis
- Risk indicator analysis

---

## 🎓 Project Learning Outcomes

Through this project, I practiced applying SQL to a realistic business analytics problem.

The project helped strengthen my understanding of:

- Relational databases
- Multi-table analysis
- Customer analytics
- Churn analysis
- Window functions
- CTEs
- Time-based analysis
- Business-oriented SQL
- Data-driven decision making

---

## ⚠️ Project Limitations

- The analysis is based on the available dataset.
- Churn-risk indicators are rule-based rather than machine-learning predictions.
- Results depend on data quality and completeness.
- The project focuses primarily on SQL-based analysis.

---

## 🔮 Future Improvements

Possible future improvements include:

- Building a Power BI churn dashboard
- Creating automated churn reports
- Adding customer segmentation
- Developing a machine-learning churn prediction model
- Creating a churn-risk scoring system
- Adding automated SQL data validation
- Performing cohort and retention analysis
- Building interactive visualizations

---

## 👨‍💻 Author

**Ansari Khurshid**

BSc Computer Science Graduate | Aspiring Data & AI Professional

This project was developed as a practical SQL analytics project focused on customer churn, retention analysis, database querying, and business intelligence.

---

## ⭐ Project

If you find this project useful, feel free to explore the repository and the SQL analysis.
