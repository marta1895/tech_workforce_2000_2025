# Tech Workforce & Market Performance Analysis (2000–2025)

An end-to-end data analytics project exploring how workforce decisions — hiring, attrition, and headcount changes — relate to revenue efficiency and stock market performance across three major tech company groups.

---

## Overview

This project analyzes 25 years of workforce and financial data across 25 major tech companies, grouped into:

- **FAANG** — Meta, Apple, Amazon, Netflix, Alphabet
- **Established Tech** — Microsoft, Intel, Oracle, SAP, Adobe, NVIDIA, AMD, PayPal, Salesforce, LinkedIn
- **Newer / Gig Economy** — Airbnb, Block, Lyft, Pinterest, Shopify, Snap, Stripe, Uber, X (Twitter), Tesla

The goal was to uncover whether workforce metrics are meaningful signals of company performance — or just noise.

---

## Key Findings

1. **Attrition doesn't matter** — attrition rates are flat across every stock performance category, suggesting it has no predictive value for market outcomes.
2. **Hiring rate is a warning sign, not a strength** — Newer/Gig Economy companies hired most aggressively right before their worst stock years.
3. **Revenue per employee is the real predictor** — higher efficiency consistently correlates with better stock outcomes. FAANG leads at $1M–$1.9M per employee vs Established Tech at $450K–$850K.

---

## Tools & Stack

| Stage | Tool |
|---|---|
| Data Source | [Kaggle – Tech Hiring and Layoffs Workforce Data 2000–2025](https://www.kaggle.com/datasets/aryanmdev/tech-hiring-and-layoffs-workforce-data-20002025) |
| Storage & Analysis | Snowflake (SQL) |
| Visualization | Tableau |

---

## SQL Analysis

The analysis was structured around 7 key business questions, using CTEs in Snowflake to:

- Classify companies into groups
- Calculate year-over-year revenue changes and revenue per employee
- Lag workforce metrics by one year to measure their impact on future stock performance
- Categorize stock outcomes (Explosive Growth → Crash) for comparison

---

## Dashboard

The Tableau dashboard covers:

- **Total Historical Revenue** by company group (2001–2025)
- **Net Employee Change** across major economic cycles (Dot-Com → AI Expansion)
- **Revenue per Employee vs Stock Change** scatter plot with trend lines per group
- **Hiring Rate & Attrition Rate vs Stock Performance** comparison tables

![Dashboard Preview](dashboard.png)

---

## Repository Structure

```
├── README.md
├── queries/          # SQL scripts for each of the 7 analysis questions
├── dashboard.png     # Final Tableau dashboard screenshot
```
