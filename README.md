### git add .
git commit -m "feat: complete initial commit for End-to-End E-Commerce Performance & Operational Analysis dashboard"
git branch -M main
git push -u origin mainEnd-to-End E-Commerce Performance & Operational Analysis

An end-to-end executive Power BI analytics platform designed to evaluate sales revenue, customer segments, product trends, and operational cancellations for a Kenyan retail ecosystem.

---

## 📊 Executive Summary
This 4-page executive dashboard translates raw transactional e-commerce data into strategic executive insights. Connected to a SQL Server backend via a star-schema model, the platform analyzes Ksh 220.78K in gross revenue across 2K completed orders and 299 unique corporate, retail, and individual customers.

### Key Performance Highlights
- **Total Revenue:** Ksh 220.78K across regional market hubs.
- **Order Volume:** 2,000 distinct completed orders.
- **Customer Base:** 299 active accounts categorized into corporate, retail, and budget tiers.
- **Operational Efficiency:** Tracked baseline cancellation metrics (5.2%) across regional delivery networks.

---

## 🏗️ Architecture & Data Model

### Pipeline Architecture
- **Database Engine:** SQL Server (`localhost\SQLEXPRESS`)
- **Data Pipeline:** Python ETL / SQL queries ingested into Power BI Desktop
- **Data Schema:** Star Schema centered on `fact_sales`

### Star Schema Relationships
- **`fact_sales`** ↔ **`dim_customers`** (1:* via `CustomerID`)
- **`fact_sales`** ↔ **`dim_products`** (1:* via `StockCode`)
- **`fact_sales`** ↔ **`dim_date`** (1:* via `Date`)
- **`_Key_Metrics`**: Centralized DAX measure repository.

---

## 🖥️ Dashboard Structure

### Page 1: Executive Overview
High-level KPI cards (Total Revenue, Total Orders, Unique Customers, Cancellation Rate), monthly sales trajectory line charts, and overall revenue contribution.

### Page 2: Product Analysis
Category revenue shares, product sales volume distribution, and item performance matrices.

### Page 3: Customer Segmentation
Customer grouping by B2B (Corporate), B2C (Retail), and Individual tiers, along with regional volume distribution across Nairobi, Mombasa, Kisumu, Nakuru, Eldoret, Ruiru, and Kikuyu.

### Page 4: Operational Cancellations
Logistics exception tracking and regional operational cancellation benchmark comparisons.

---

## ⚙️ Core DAX Measures

```dax
// Total Revenue
Total Revenue = SUM(fact_sales[TotalPrice])

// Total Orders
Total Orders = DISTINCTCOUNT(fact_sales[InvoiceNo])

// Cancellation Rate Benchmark
Cancellation Rate = 0.052