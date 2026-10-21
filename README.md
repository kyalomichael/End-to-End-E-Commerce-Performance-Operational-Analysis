# End-to-End E-Commerce Performance & Operational Analysis

A 4-page Power BI dashboard analysing one year (2023) of sales for a Kenyan online grocery shop. The goal: help a shop owner understand whether the business is healthy, what drives revenue, who the best customers are, and where orders are being lost.

**Tools:** Power BI (DAX, star-schema model), SQL, Python (pandas)

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
3. Who are the best customers?
4. Where are orders being lost to cancellations?

---

## Key Findings

**Scale:** Ksh 220.78K revenue from about 1,500 orders and 299 unique customers across 8 Nairobi-area locations in 2023.

**1. Revenue is heavily concentrated in the first four months.**
January to April generated roughly Ksh 187K, about 85% of annual revenue. From May to December, monthly revenue fell to around Ksh 4-5K, with roughly 30 orders a month. The cause is not visible in the data (possible reasons: stock, pricing, marketing, or a gap in the records) and is the first thing I would investigate.

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

<!-- ADD AFTER FIXING THE CANCELLATION MEASURE:
**5. Cancellations.** Overall rate, and which products / locations / customer types / months have the highest rate.
-->

---

## Recommendations

These are hypotheses to test, based on the patterns above.

- **Find out what happened after April.** Check stock, pricing and marketing for May to December, and contact customers who ordered in the first four months to bring them back.
- **Protect and promote the top three products.** Make sure they are always in stock, and review price or bundling for the four low-value products.
- **Grow the weaker locations.** Test delivery offers in Ruaka, Rongai and Umoja, and check whether delivery coverage is the limiting factor.
- **Retain Premium customers and lift Regular ones.** Premium customers spend the most per head, so a loyalty perk is worth testing. Regular customers spend the least per head, so bundles could raise their basket size.

---

## Data Model

Star schema centred on `fact_sales`:

- `fact_sales` to `dim_customers` (many-to-one on `CustomerID`)
- `fact_sales` to `dim_products` (many-to-one on `StockCode`)
- `fact_sales` to `dim_date` (many-to-one on `Date`)

The cleaned tables are included as CSV files in this repo (`clean_fact_sales.csv`, `clean_dim_customers.csv`, `clean_dim_products.csv`, `clean_dim_date.csv`), along with the raw `kenyan_online_shop_data.csv`.

### Core DAX Measures

```
Total Revenue = SUM(fact_sales[TotalPrice])

Total Orders = DISTINCTCOUNT(fact_sales[InvoiceNo])
```

<!-- ADD AFTER FIXING THE CANCELLATION MEASURE:
Cancelled Orders = CALCULATE(DISTINCTCOUNT(fact_sales[InvoiceNo]), fact_sales[OrderStatus] = "Cancelled")
Cancellation Rate = DIVIDE([Cancelled Orders], [Total Orders], 0)
-->

---

## Files

- `End-to-End E-Commerce Performance & Operational Analysis.pbix`: the Power BI report (open with Power BI Desktop)
- `*.png`: dashboard page screenshots
- `kenyan_online_shop_data.csv`: raw data
- `cleaned_kenyan_ecom_dataset.csv`, `clean_*.csv`: cleaned data and star-schema tables
