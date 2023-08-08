create database indian_stock_analysis;

use indian_stock_analysis;

select * from combined_stock;

# 1. Calculate daily percentage returns for each stock:

select Symbol, Date, `Prev Close`, round(((`Close Price`-`Prev Close`)*100)/`Prev Close`,2) as daily_percent_return
from combined_stock
order by Symbol, Date;

select Symbol, Date, `Prev Close`, round(((`Close Price`-`Prev Close`)*100)/`Prev Close`,2) as daily_percent_return
from combined_stock
order by daily_percent_return desc;

select Symbol, Date, `Prev Close`, round(((`Close Price`-`Prev Close`)*100)/`Prev Close`,2) as daily_percent_return
from combined_stock
where symbol = 'CANBK'
order by daily_percent_return desc;

# 2. Calculate the return or loss if I started intraday with CANBK daily with algorithm trading means buying at opening price and selling at closing price.
select Symbol, Date, `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return
from combined_stock
where symbol = 'CANBK'
order by DATE_FORMAT(Date, '%m-%Y') asc;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'CANBK'
ORDER BY Date;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'ASHOKLEY'
ORDER BY Date DESC Limit 1;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'YESBANK'
ORDER BY Date DESC Limit 1;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'EMAMILTD'
ORDER BY Date DESC Limit 1;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'WIPRO'
ORDER BY Date DESC Limit 1;

SELECT 
    Symbol, Date,
    `Prev Close`, round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) as daily_percent_return,
    @investment := @investment * (1 + round(((`Last Price`-`Open Price`)*100)/`Open Price`,2) / 100) AS current_investment
FROM combined_stock, (SELECT @investment := 10000) init
where symbol = 'RAYMOND'
ORDER BY Date DESC Limit 1;

#3. Calculate 50-day simple moving average for a YESBANK company's stock:

SELECT 
    date,
    Symbol,
    `Close Price`,
    AVG(`Close Price`) OVER (PARTITION BY Symbol ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_average_50
FROM combined_stock
WHERE Symbol = 'YESBANK'
ORDER BY Symbol, date;


select temp.Date, temp.Symbol, temp.`Close Price`, temp.moving_average_50
from (
SELECT 
    Date,
    Symbol,
    `Close Price`,
    CASE 
        WHEN COUNT(*) OVER (PARTITION BY Symbol ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) >= 50 
        THEN AVG(`Close Price`) OVER (PARTITION BY Symbol ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
        ELSE NULL 
    END AS moving_average_50
FROM combined_stock
WHERE Symbol = 'YESBANK'
) as temp
where temp.moving_average_50 is not null
ORDER BY temp.Symbol, temp.Date;

#4. Top Performing Stocks: Identify the top-performing stocks based on their daily percent returns.

SELECT 
    Symbol,
    MAX(`Close Price`) AS max_close_price,
    MIN(`Close Price`) AS min_close_price,
    AVG(`Close Price`) AS avg_close_price,
    (MAX(`Close Price`) - MIN(`Close Price`)) / MIN(`Close Price`) * 100 AS price_range_percent
FROM combined_stock
GROUP BY Symbol
ORDER BY price_range_percent DESC
LIMIT 3;

# Worst Performing Stocks: Identify the worst-performing stocks based on their daily percent returns.

SELECT 
    Symbol,
    MAX(`Close Price`) AS max_close_price,
    MIN(`Close Price`) AS min_close_price,
    AVG(`Close Price`) AS avg_close_price,
    (MAX(`Close Price`) - MIN(`Close Price`)) / MIN(`Close Price`) * 100 AS price_range_percent
FROM combined_stock
GROUP BY Symbol
ORDER BY price_range_percent ASC
LIMIT 3;

# 5. Find the most volatile stock.

select Symbol, date, round((`High Price`-`Low Price`)*100/`Open Price`,2) as daily_percent_variation
from combined_stock
ORDER BY daily_percent_variation DESC LIMIT 10;

#Identifying Trends: Identify trends in stock prices using a moving average.

SELECT 
    Symbol,
    Date,
    `Close Price`,
    AVG(`Close Price`) OVER (PARTITION BY Symbol ORDER BY Date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS moving_avg_5_days
FROM combined_stock
ORDER BY Symbol, Date;

WITH RK AS (
    SELECT 
        Symbol,
        Date,
        `Close Price`,
        AVG(`Close Price`) OVER (PARTITION BY Symbol ORDER BY Date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS moving_avg_5_days,
        ROW_NUMBER() OVER (PARTITION BY Symbol ORDER BY `Close Price` DESC) AS row_num
    FROM combined_stock
)
SELECT 
    Symbol,
    Date,
    `Close Price`,
    moving_avg_5_days
FROM RK
WHERE row_num <= 5
ORDER BY Symbol, Date;

SELECT 
    Symbol,
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    AVG(`High Price` - `Low Price`) AS avg_monthly_volatility
FROM combined_stock
GROUP BY Symbol, YEAR(Date), MONTH(Date)
ORDER BY year, month;






