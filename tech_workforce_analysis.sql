-- Project: Tech Workforce & Market Performance Analysis (2000–2025)
-- Description: An end-to-end data analytics project exploring how workforce decisions — hiring, attrition, 
-- and headcount changes — relate to revenue efficiency and stock market performance across three major tech company groups
-- Date: March 10, 2026


-- 1. Total historical revenue per company group
-- Companies are divided into three main groups based on their business model:
-- FAANG, Established Tech, and Newer / Gig Economy.
-- This makes the further analysis clearer and easier to compare.

WITH company_totals AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        company,
        SUM(revenue_billions_usd) AS revenue
    FROM tech_wf
    GROUP BY 1, 2
)
	
SELECT
    company_group,
    ROUND(SUM(revenue) / 1000, 2) AS total_revenue_trillions_usd --converted the revenue outputs from billions to trillions for better readability
FROM company_totals
WHERE company_group IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- 2. As the AI Expansion changed market dynamics, I analyzed total revenue per company group before and after the AI Expansion period

WITH company_totals AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        CASE 
            WHEN year BETWEEN 2019 AND 2021 THEN 'Before AI expansion (2019-2021)'
            WHEN year BETWEEN 2022 AND 2025 THEN 'After AI expansion (2022-2025)'
        END AS years,
        company,
        SUM(revenue_billions_usd) AS total_rev_per_company_period
    FROM tech_wf
    GROUP BY 1, 2, 3
)

SELECT
    company_group,
    years,
    ROUND(AVG(total_rev_per_company_period), 2) AS avg_revenue
FROM company_totals
WHERE years IS NOT NULL
GROUP BY 1, 2
ORDER BY 1; -- Conclusion: The comparison shows that total revenue more than doubled in the period after the AI Expansion


--3. Year-over-year net employee change by company group (2001–2025) 

WITH company_totals AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        year,
        SUM(net_change) AS total_net_change
    FROM tech_wf
    GROUP BY 1, 2
)
	
SELECT 
    company_group,
    year,
    total_net_change
FROM company_totals
ORDER BY 1, 2; -- Conclusion: Tech workforce growth followed a synchronized hyper-expansion during the pandemic, 
               -- led by FAANG, followed by a sharp industry-wide correction beginning in 2022


-- 4. Changes in hiring rate, attrition rate and GDP growth (US) based on company group during major economic periods

WITH company_group_creation AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        year,
        hiring_rate_pct,
        attrition_rate_pct,
        gdp_growth_us_pct
    FROM tech_wf
),

economic_periods_creation AS (
    SELECT
        company_group,
        year,
        hiring_rate_pct,
        attrition_rate_pct,
        gdp_growth_us_pct,
        CASE
            WHEN year BETWEEN 2000 AND 2004 THEN 'The Dot-Com Correction'
            WHEN year BETWEEN 2005 AND 2009 THEN 'Financial Crisis & Mobile Pivot'
            WHEN year BETWEEN 2010 AND 2019 THEN 'The Cloud & SaaS Bull Market'
            WHEN year BETWEEN 2020 AND 2022 THEN 'Pandemic Hyper-Growth'
            WHEN year BETWEEN 2023 AND 2025 THEN 'The AI Expansion'
        END AS economic_period
    FROM company_group_creation
)

SELECT
    company_group,
    economic_period,
    ROUND(AVG(hiring_rate_pct), 2) AS avg_hiring_rate_pct,
    ROUND(AVG(attrition_rate_pct), 2) AS avg_attrition_rate_pct,
    ROUND(AVG(gdp_growth_us_pct), 2) AS avg_gdp_growth_us_pct
FROM economic_periods_creation
WHERE economic_period IS NOT NULL
GROUP BY 1, 2
ORDER BY
    CASE economic_period
        WHEN 'The Dot-Com Correction' THEN 1
        WHEN 'Financial Crisis & Mobile Pivot' THEN 2
        WHEN 'The Cloud & SaaS Bull Market' THEN 3
        WHEN 'Pandemic Hyper-Growth' THEN 4
        WHEN 'The AI Expansion' THEN 5
    END,
    1; -- Conclusion: Hiring peaked during the early digital expansion cycles, while the pandemic period further accelerated workforce growth across all groups; 
                   -- The AI expansion represents a structural shift, with tech sector growth now driven more by productivity than by headcount


-- 5. Changes in total company revenue and weighted average revenue per employee based on the company group during major economic periods

WITH company_group_creation AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        year,
        revenue_billions_usd,
        employees_end
    FROM tech_wf
),

economic_periods_creation AS (
    SELECT
        company_group,
        year,
        revenue_billions_usd,
        employees_end,
        CASE
            WHEN year BETWEEN 2000 AND 2004 THEN 'The Dot-Com Correction'
            WHEN year BETWEEN 2005 AND 2009 THEN 'Financial Crisis & Mobile Pivot'
            WHEN year BETWEEN 2010 AND 2019 THEN 'The Cloud & SaaS Bull Market'
            WHEN year BETWEEN 2020 AND 2022 THEN 'Pandemic Hyper-Growth'
            WHEN year BETWEEN 2023 AND 2025 THEN 'The AI Expansion'
        END AS economic_period
    FROM company_group_creation
)

SELECT
    company_group,
    economic_period,
    ROUND(AVG(revenue_billions_usd), 2) AS avg_revenue,
    ROUND(SUM(revenue_billions_usd * 1000000000) / SUM(employees_end), 0) 
        AS weighted_avg_revenue_per_employee
FROM economic_periods_creation
WHERE economic_period IS NOT NULL
GROUP BY 1, 2
ORDER BY
    CASE economic_period
        WHEN 'The Dot-Com Correction' THEN 1
        WHEN 'Financial Crisis & Mobile Pivot' THEN 2
        WHEN 'The Cloud & SaaS Bull Market' THEN 3
        WHEN 'Pandemic Hyper-Growth' THEN 4
        WHEN 'The AI Expansion' THEN 5
    END,
    1; -- Conclusion: Tech companies are generating record revenue per employee during the AI Expansion period, 
                   -- signaling a shift from workforce-driven growth to productivity-driven growth


-- 6. How does the market react to workforce changes?
-- Finding how the changes in the workforce affect company revenue, revenue per employee and stock price per company group

WITH company_groups AS (
    SELECT 
        company,
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        year,
        attrition_rate_pct,
        hiring_rate_pct,
        revenue_billions_usd,
        employees_end,
        stock_price_change_pct
    FROM tech_wf
),
	
next_year_metrics AS (
    SELECT
        t1.company,
        t1.company_group,
        t1.year AS workforce_year,
        t1.attrition_rate_pct,
        t1.hiring_rate_pct,
        ROUND((t2.revenue_billions_usd - t1.revenue_billions_usd), 2) AS next_year_revenue_change,
        ROUND((t2.revenue_billions_usd * 1000000000 / t2.employees_end), 0) AS next_year_revenue_per_employee,
        t2.stock_price_change_pct AS next_year_stock_change
    FROM company_groups t1
    JOIN company_groups t2 
        ON t1.company = t2.company
        AND t2.year = t1.year + 1
),
	
stock_categorized AS (
    SELECT
        company,
        company_group,
        workforce_year,
        attrition_rate_pct,
        hiring_rate_pct,
        next_year_revenue_change,
        next_year_revenue_per_employee,
        next_year_stock_change,
        CASE
            WHEN next_year_stock_change >= 50 THEN 'Explosive Growth'
            WHEN next_year_stock_change >= 25 THEN 'High Growth'
            WHEN next_year_stock_change >= 10 THEN 'Moderate Growth'
            WHEN next_year_stock_change > -10 THEN 'Stable / Sideways'
            WHEN next_year_stock_change > -20 THEN 'Pullback'
            WHEN next_year_stock_change > -30 THEN 'Correction'
            WHEN next_year_stock_change > -50 THEN 'Severe Drawdown'
            ELSE 'Crash'
        END AS stock_performance_category
    FROM next_year_metrics
)
SELECT
    stock_performance_category,
    company_group,
    COUNT(*) AS case_count,
    ROUND(AVG(attrition_rate_pct), 2) AS avg_attrition_rate,
    ROUND(AVG(hiring_rate_pct), 2) AS avg_hiring_rate,
    ROUND(AVG(next_year_revenue_change), 2) AS avg_revenue_change,
    ROUND(AVG(next_year_revenue_per_employee), 0) AS avg_rev_per_employee,
    ROUND(AVG(next_year_stock_change), 1) AS avg_stock_change
FROM stock_categorized
GROUP BY 1, 2
ORDER BY 
    CASE stock_performance_category
        WHEN 'Explosive Growth' THEN 1
        WHEN 'High Growth' THEN 2
        WHEN 'Moderate Growth' THEN 3
        WHEN 'Stable / Sideways' THEN 4
        WHEN 'Pullback' THEN 5
        WHEN 'Correction' THEN 6
        WHEN 'Severe Drawdown' THEN 7
        WHEN 'Crash' THEN 8
    END,
    2 -- Conclusion: Attrition doesn't matter, it's flat across every category. Hiring rate is actually a warning sign, not a strength; 
                  -- Newer/Gig Economy companies hired most aggressively right before their worst stock years. 
                  -- Revenue per employee is the real predictor: higher efficiency consistently correlates with better stock outcomes, 
	              -- with FAANG leading at $1M–$1.9M per employee vs Established Tech at $450K–$850K

    
-- 7. How the Workforce Volatility was changing in different Tech Groups Across Economic Cycles
-- Note: Volatility metrics for the Newer/Gig Economy group prior to 2005 are unavailable/zero
-- due to the limited number of companies established in that sector at the time
	
WITH company_group_creation AS (
    SELECT 
        CASE
            WHEN company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        year,
        hiring_rate_pct,
        attrition_rate_pct
    FROM tech_wf
),

economic_periods_creation AS (
    SELECT
        company_group,
        year,
        hiring_rate_pct,
        attrition_rate_pct,
        CASE
            WHEN year BETWEEN 2000 AND 2004 THEN 'The Dot-Com Correction'
            WHEN year BETWEEN 2005 AND 2009 THEN 'Financial Crisis & Mobile Pivot'
            WHEN year BETWEEN 2010 AND 2019 THEN 'The Cloud & SaaS Bull Market'
            WHEN year BETWEEN 2020 AND 2022 THEN 'Pandemic Hyper-Growth'
            WHEN year BETWEEN 2023 AND 2025 THEN 'The AI Expansion'
        END AS economic_period
    FROM company_group_creation
)

SELECT
    company_group,
    economic_period,
    ROUND(AVG(hiring_rate_pct), 2) AS avg_hiring_rate_pct,
    ROUND(COALESCE(STDDEV(hiring_rate_pct), 0), 2) AS hiring_volatility,
    ROUND(AVG(attrition_rate_pct), 2) AS avg_attrition_rate_pct,
    ROUND(COALESCE(STDDEV(attrition_rate_pct), 0), 2) AS attrition_volatility
FROM economic_periods_creation
WHERE economic_period IS NOT NULL
GROUP BY 1, 2
ORDER BY
    CASE economic_period
        WHEN 'The Dot-Com Correction' THEN 1
        WHEN 'Financial Crisis & Mobile Pivot' THEN 2
        WHEN 'The Cloud & SaaS Bull Market' THEN 3
        WHEN 'Pandemic Hyper-Growth' THEN 4
        WHEN 'The AI Expansion' THEN 5
    END,
    1; -- Conclusion: Newer companies chase growth, but established giants provide stability. 
                   -- Since 2023, the entire industry has shifted its focus: it’s no longer about how many people you hire, but how much revenue each person generates
 
    
    
-- Additional drill-down on Question 6: Investigating the FAANG outlier from the scatter plot
-- FAANG showed unusually high revenue per employee (~$1.85M) during severe stock downturns
-- This query identifies which companies and years drove that result 

WITH b1 AS (
    SELECT
        t1.company as company_t1,
        CASE
            WHEN t1.company IN ('Meta', 'Apple', 'Amazon', 'Netflix', 'Alphabet') THEN 'FAANG'
            WHEN t1.company IN ('Microsoft', 'Intel', 'Oracle', 'SAP', 'Adobe', 'NVIDIA', 'AMD', 'PayPal', 'Salesforce', 'LinkedIn') THEN 'Established Tech'
            WHEN t1.company IN ('Airbnb', 'Block', 'Lyft', 'Pinterest', 'Shopify', 'Snap', 'Stripe', 'Uber', 'X (Twitter)', 'Tesla') THEN 'Newer / Gig Economy'
        END AS company_group,
        t1.year AS workforce_year,
        CASE
            WHEN t1.year BETWEEN 2000 AND 2004 THEN 'The Dot-Com Correction'
            WHEN t1.year BETWEEN 2005 AND 2009 THEN 'Financial Crisis & Mobile Pivot'
            WHEN t1.year BETWEEN 2010 AND 2019 THEN 'The Cloud & SaaS Bull Market'
            WHEN t1.year BETWEEN 2020 AND 2022 THEN 'Pandemic Hyper-Growth'
            WHEN t1.year BETWEEN 2023 AND 2025 THEN 'The AI Expansion'
        END AS economic_period,
        ROUND((t2.revenue_billions_usd * 1000000000 / t2.employees_end), 0) AS next_year_revenue_per_employee,
        t2.stock_price_change_pct AS next_year_stock_change
    FROM tech_wf t1
    JOIN tech_wf t2
        ON t1.company = t2.company
        AND t2.year = t1.year + 1 
	ORDER BY 6 ASC, 5 DESC
 ),
 
 b2 AS (
 	SELECT
	  company_t1,
	  company_group,
	  workforce_year, 
	  economic_period, 
	  next_year_revenue_per_employee,
	  next_year_stock_change,
	  CASE
            WHEN next_year_stock_change >= 50 THEN 'Explosive Growth'
            WHEN next_year_stock_change >= 25 THEN 'High Growth'
            WHEN next_year_stock_change >= 10 THEN 'Moderate Growth'
            WHEN next_year_stock_change > -10 THEN 'Stable / Sideways'
            WHEN next_year_stock_change > -20 THEN 'Pullback'
            WHEN next_year_stock_change > -30 THEN 'Correction'
            WHEN next_year_stock_change > -50 THEN 'Severe Drawdown'
            ELSE 'Crash'
      END AS stock_performance_category
 	FROM b1
)

SELECT 
	company_t1,
	company_group,
	workforce_year, 
	economic_period, 
	next_year_revenue_per_employee,
	next_year_stock_change,
  	stock_performance_category
FROM b2
WHERE company_group = 'FAANG'
	AND
	stock_performance_category = 'Severe Drawdown';

