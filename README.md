# End-to-End E-Commerce Performance & Operational Analysis

A 4-page Power BI dashboard, backed by a Python and SQL analysis, of one year (2023) of sales for a Kenyan online grocery shop. The goal: help a shop owner understand whether the business is healthy, what drives revenue, who the best customers are, and where orders are being lost.

**Tools:** Power BI (DAX, star-schema model), SQL (SQLite), Python (pandas)

---

## Dashboard Preview

![Executive Overview](Executive%20Overview.png)
![Product Analysis](Product%20Analysis.png)
![Customer Segmentation](Customer%20Segmentation.png)
![Operational Cancellations](Operational%20Cancellation.png)

---

## Business Questions

1. Is the business healthy, and which way is it trending?
2. What drives value: which products, locations and customer segments?
3. Who are the best customers, and who is at risk?
4. Where are orders being lost to cancellations?

---

## Key Findings

**Scale:** Ksh 220,783 revenue from 1,500 orders (1,422 completed, 78 cancelled) and 299 unique customers across 8 Nairobi-area locations in 2023.

**1. Revenue is heavily concentrated in the first four months.**
January to April brought in 1,261 of the 1,500 orders (84%) and roughly 85% of revenue. From May to December, the shop averaged about 30 orders and Ksh 4-5K a month. The cause is not visible in the data (possible reasons: stock, pricing, marketing, or a gap in the records) and is the first thing I would investigate.

**2. Three products drive most of the revenue.**
Eggs (Tray) is the top product at roughly Ksh 59K (about 27% of revenue). Together with Cooking Oil (1L) and Sanitary Towels (Pack), the top three bring in about 60%. Soap, Milk, Bread and Tea Leaves together contribute only about 14%.

**3. Nairobi is the anchor location.**
Nairobi accounts for about a third of revenue (roughly Ksh 72K). Thika, Ruiru, Kitengela and Roysambu form a middle tier, while Rongai, Ruaka and Umoja are the weakest (Umoja is lowest at roughly Ksh 6-7K).

**4. Budget customers carry the volume, Premium customers are the most valuable per head.**

| Segment | Share of customers | Share of revenue | Approx. revenue per customer |
|---|---|---|---|
| Budget | 58.9% | 61.1% | Ksh 770 |
| Regular | 31.4% | 27.5% | Ksh 650 |
| Premium | 9.7% | 11.4% | Ksh 870 |

**5. About 5% of orders are cancelled, and the rate is steady through the year.**
78 of 1,500 orders (5.2%) were cancelled. The rate was 5.2% in January-April and 5.0% in May-December, so cancellations do not explain the drop in orders after April.

| Cut | Highest cancellation rate | Lowest cancellation rate |
|---|---|---|
| Product | Milk 8.3%, Bread 7.8% | Eggs 3.3%, Cooking Oil 3.9% |
| Location | Ruaka 7.8%, Ruiru 7.3%, Roysambu 6.8% | Kitengela 2.7%, Thika 3.7% |
| Customer type | Premium 6.3% | Regular 4.9% (Budget 5.2%) |

Nairobi has 24 of the 78 cancellations (31%) simply because it has the most orders, but its rate (4.9%) is below average. The counts behind these rates are small (for example, Ruaka has 6 cancellations), so treat the differences as patterns to watch, not firm conclusions.

---

## Recommendations

These are hypotheses to test, based on the patterns above.

- **Find out what happened after April.** Check stock, pricing and marketing for May to December, and contact customers who ordered in the first four months to bring them back.
- **Protect and promote the top three products.** Make sure they are always in stock, and review price or bundling for the four low-value products.
- **Look into Milk and Bread cancellations.** They have the highest cancellation rates of any product, so check stock availability and delivery times for them.
- **Check delivery in Ruaka, Ruiru and Roysambu.** Their cancellation rates are above average, and Kitengela (2.7%) could show what works.
- **Grow the weaker locations.** Test delivery offers in Ruaka, Rongai and Umoja, and check whether delivery coverage is the limiting factor.
- **Retain Premium customers and lift Regular ones.** Premium customers spend the most per head, so a loyalty perk is worth testing. Regular customers spend the least per head, so bundles could raise their basket size.

---

## Method

1. **Clean (Python, pandas):** standardise text, parse dates, validate values, and add date features. Orders with a quantity of 0 are cancellations, so they are kept and flagged in an `OrderStatus` column instead of being deleted.
2. **Analyse (SQL):** the cleaned data is loaded into SQLite and queried to answer each business question.
3. **Visualise (Power BI):** a star-schema model with DAX measures, shown across four dashboard pages.

---

## Data Model

Star schema centred on `fact_sales`:

- `fact_sales` to `dim_customers` (many-to-one on `CustomerID`)
- `fact_sales` to `dim_products` (many-to-one on `StockCode`)
- `fact_sales` to `dim_date` (many-to-one on `Date`)

### Core DAX Measures

```
Total Revenue = SUM(fact_sales[TotalPrice])

Total Orders = DISTINCTCOUNT(fact_sales[InvoiceNo])

Cancelled Orders =
CALCULATE(DISTINCTCOUNT(fact_sales[InvoiceNo]), fact_sales[Quantity] = 0)

Cancellation Rate = DIVIDE([Cancelled Orders], [Total Orders], 0)
```

---

## Files

- `notebooks/01_cleaning_and_sql_analysis.ipynb`: data cleaning and SQL analysis, with results shown
- `sql/analysis_queries.sql`: all SQL queries used in the analysis
- `End-to-End E-Commerce Performance & Operational Analysis.pbix`: the Power BI report (open with Power BI Desktop)
- `*.png`: dashboard page screenshots
- `kenyan_online_shop_data.csv`: raw data
- `cleaned_kenyan_ecom_dataset.csv`, `clean_*.csv`: cleaned data and star-schema tables

### How to reproduce

Put `kenyan_online_shop_data.csv` and the notebook in the same folder (or keep the repo layout), install pandas (`pip install pandas`), and run the notebook top to bottom. It creates a local SQLite database and runs every query.


---

## About Me

I'm Michael Kyalo, an aspiring data analyst who enjoys turning raw transaction data into clear answers for business owners. This project combines SQL, Python and Power BI, and I'm looking for a data analyst role where I can do the same with real business data.

**Tools:** SQL, Python (pandas), Power BI (DAX)

**Connect:** [linkedin.com/in/kyalo-michael-7548483b5] | [Email: mikekyalo.c@gmail.com]
