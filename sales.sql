# The purpose of this SQL script is to perform basic analysis on a dataset 
# for sales data from a cycling equipment company

CREATE DATABASE IF NOT EXISTS sales;

USE sales;

SELECT 
    *
FROM
    sales
LIMIT 10;

DESCRIBE sales;
SELECT DISTINCT
    (Column1)
FROM
    sales;

SELECT 
    COUNT(DISTINCT (Column1))
FROM
    sales;

SELECT 
    COUNT(*)
FROM
    sales;

SELECT 
    SUM(IF(Column1 IS NOT NULL, 1, 0))
FROM
    sales;

SELECT 
    IF(Column1 = '', 1, 0)
FROM
    sales
LIMIT 10;

SELECT DISTINCT
    (`Product Category`)
FROM
    sales;

SELECT DISTINCT
    (`Sub Category`)
FROM
    sales;

UPDATE sales 
SET 
    Column1 = CASE
        WHEN Column1 = '' THEN NULL
        ELSE Column1
    END;

ALTER TABLE sales
MODIFY Column1 INT;

SELECT 
    COUNT(*)
FROM
    sales;

SELECT 
    Country, COUNT(*) AS num_transaction
FROM
    sales
GROUP BY country
ORDER BY num_transaction DESC;

# First thing we need to investigate is if there's any influence on the country and the  
# distribution of items purchased.
SELECT *
FROM
(
SELECT *,
# Using window function to only get the 5 best selling product categories
RANK() OVER (PARTITION BY Country ORDER BY quantity DESC) AS quantity_order
FROM
(
SELECT Country, `Sub Category`,
SUM(Quantity) AS quantity
FROM sales
GROUP BY Country, `Sub Category`
ORDER BY quantity DESC) inter
) inter2
WHERE quantity_order < 5;

SELECT DISTINCT
    (`Customer Gender`)
FROM
    sales;
SELECT 
    `Customer Gender`, COUNT(*)
FROM
    sales
GROUP BY `Customer Gender`;
SELECT 
    SUM(Revenue)
FROM
    sales
GROUP BY `Customer Gender`;
SELECT 
    *
FROM
    sales
LIMIT 10;


# Let's investigate if difference age group had different spending habit.
WITH age_group AS 
(
SELECT `Customer Age`,
SUM(Revenue) AS total_revenue,
COUNT(*) AS num_transaction
FROM sales
GROUP BY `Customer Age`
)
SELECT *,
REPEAT('*',20*total_revenue DIV (SELECT MAX(total_revenue) FROM age_group)) AS revenue_hist
FROM age_group
ORDER BY `Customer Age`;

/*
'17', '292854', '714', '***'
'18', '454580', '902', '****'
'19', '583518', '1210', '******'
'20', '494688', '1192', '*****'
'21', '595618', '1380', '******'
'22', '744202', '1444', '*******'
'23', '759284', '1620', '*******'
'24', '1163600', '1852', '************'
'25', '1193800', '1838', '************'
'26', '1195676', '2032', '************'
'27', '1352126', '2068', '**************'
'28', '1924088', '2554', '********************'
'29', '1757418', '2468', '******************'
'30', '1585590', '2408', '****************'
'31', '1870040', '2614', '*******************'
'32', '1540418', '2398', '****************'
'33', '1491582', '2312', '***************'
'34', '1776960', '2520', '******************'
'35', '1562586', '2278', '****************'
'36', '1357790', '2108', '**************'
'37', '1438244', '2140', '**************'
'38', '1316064', '1908', '*************'
'39', '1432996', '1966', '**************'
'40', '1562596', '2256', '****************'
'41', '1384864', '1998', '**************'
'42', '1375752', '1864', '**************'
'43', '1276670', '1810', '*************'
'44', '1231088', '1822', '************'
'45', '1074088', '1504', '***********'
'46', '928692', '1446', '*********'
'47', '722040', '1218', '*******'
'48', '710782', '1072', '*******'
'49', '693842', '1234', '*******'
'50', '606788', '1046', '******'
'51', '753314', '1092', '*******'
'52', '703044', '1088', '*******'
'53', '738588', '992', '*******'
'54', '466658', '768', '****'
'55', '421558', '752', '****'
'56', '367064', '592', '***'
'57', '320980', '544', '***'
'58', '241044', '370', '**'
'59', '187628', '372', '*'
'60', '169354', '358', '*'
'61', '223640', '344', '**'
'62', '172894', '284', '*'
'63', '117524', '234', '*'
'64', '110416', '210', '*'
'65', '54722', '100', ''
'66', '19870', '46', ''
'67', '22030', '44', ''
'68', '16518', '58', ''
'69', '20554', '38', ''
'70', '16772', '48', ''
'71', '8826', '28', ''
'72', '19922', '20', ''
'73', '6392', '8', ''
'74', '3884', '4', ''
'75', '14290', '20', ''
'76', '636', '4', ''
'77', '6724', '16', ''
'78', '5436', '22', ''
'79', '1826', '10', ''
'80', '1728', '6', ''
'81', '4764', '12', ''
'82', '1948', '4', ''
'84', '3696', '18', ''
'85', '4206', '16', ''
'86', '8766', '8', ''
'87', '1012', '6', ''

From the simplified histogram above, we can see that the revenue generated by age group is roughly 
a normal distribution, with the mean centered around 28-34
It shows that in this age group, people are either more interested in cycling, and/or have the 
financial freedom to invested in cycling gears.
*/

SELECT 
    *
FROM
    sales
LIMIT 10;

SELECT @@sql_mode;
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ALLOW_INVALID_DATES');

WITH month_revenue AS
(
SELECT Month, SUM(Revenue) AS total_revenue
FROM sales
GROUP BY Month
)
SELECT 
REPEAT('*', 10*total_revenue DIV (SELECT MAX(total_revenue) FROM month_revenue)) AS revenue_hist,
month_revenue.*
FROM month_revenue
ORDER BY MONTH(str_to_date(Month, '%M'));
/*
'*******', 'January', '3901242'
'*******', 'February', '3988466'
'*******', 'March', '4270672'
'********', 'April', '4400980'
'*********', 'May', '5251640'
'**********', 'June', '5363970'
'****', 'July', '2561332'
'****', 'August', '2496370'
'****', 'September', '2590492'
'*****', 'October', '2753938'
'*****', 'November', '2877856'
'*******', 'December', '4232194'

Here we are seeing an interesting pattern, at the start of the year, the revenue has a steady increase
up until June, where the revenue of July was half of June, and again the revenue started increasing.alter
*/

SELECT 
    *
FROM
    sales
LIMIT 10;

SELECT 
    COUNT(*)
FROM
    sales;

SELECT 
    Year, Month
FROM
    sales
GROUP BY Year , Month
ORDER BY Year , MONTH(STR_TO_DATE(Month, '%M'));
/*
'2015', 'January'
'2015', 'February'
'2015', 'March'
'2015', 'April'
'2015', 'May'
'2015', 'June'
'2015', 'July'
'2015', 'August'
'2015', 'September'
'2015', 'October'
'2015', 'November'
'2015', 'December'
'2016', 'January'
'2016', 'February'
'2016', 'March'
'2016', 'April'
'2016', 'May'
'2016', 'June'
'2016', 'July'

After investigation we can see that the last entry of the data is on 2016 July, which is reason why
there is a drop in revenue after June. 
*/

# To make the analysis consistent, we will only be using the data from 2015 to determine if there
# was a trend in sales across the year.

WITH 2015_month_revenue AS
(
SELECT Month, sum(revenue) AS total_revenue
FROM sales
WHERE Year = 2015
GROUP BY Month
Order BY Month(str_to_date(Month, '%M'))
)
SELECT 
REPEAT('*', 10*total_revenue DIV (SELECT MAX(total_revenue) FROM 2015_month_revenue)),
2015_month_revenue.*
FROM 2015_month_revenue;
/*
'*', 'January', '461098'
'*', 'February', '519714'
'*', 'March', '500716'
'*', 'April', '568286'
'*', 'May', '641258'
'*', 'June', '675512'
'***', 'July', '1578108'
'*****', 'August', '2496370'
'******', 'September', '2590492'
'******', 'October', '2753938'
'******', 'November', '2877856'
'**********', 'December', '4232194'

Interestingly, the above histogram showed that the highest month of revenue is at December, with almost
10 folds of the lowest month (January). 
This behaviour could be argued with the holiday season (Christmas, Boxing Day etc)
To support the claim, let's look at the countries where data were colelcted.
*/

SELECT DISTINCT
    (Country)
FROM
    sales;
/*
'United States'
'France'
'United Kingdom'
'Germany'

We see that indeed these are the countries where holiday season were in December, however, the data
doesn't support the claim since there were no increase in revenue during the summer season, 
where the weather is better and is a cycling season

More data is needed to investigate the trend.
Instead, since we onlt have 1.5 years worth of data, let's visualize the revenue without trying to find a 
seasonality specifically in 2015
*/

WITH month_revenue AS
(
SELECT Year, Month, SUM(Revenue) AS total_revenue
FROM sales
GROUP BY Year, Month
)
SELECT 
REPEAT('*', 15*total_revenue DIV (SELECT MAX(total_revenue) FROM month_revenue)) AS revenue_hist,
month_revenue.*
FROM month_revenue
ORDER BY Year, MONTH(str_to_date(Month, '%M'));
/*
'*', '2015', 'January', '461098'
'*', '2015', 'February', '519714'
'*', '2015', 'March', '500716'
'*', '2015', 'April', '568286'
'**', '2015', 'May', '641258'
'**', '2015', 'June', '675512'
'*****', '2015', 'July', '1578108'
'*******', '2015', 'August', '2496370'
'********', '2015', 'September', '2590492'
'********', '2015', 'October', '2753938'
'*********', '2015', 'November', '2877856'
'*************', '2015', 'December', '4232194'
'***********', '2016', 'January', '3440144'
'***********', '2016', 'February', '3468752'
'************', '2016', 'March', '3769956'
'************', '2016', 'April', '3832694'
'**************', '2016', 'May', '4610382'
'***************', '2016', 'June', '4688458'
'***', '2016', 'July', '983224'

The data above suggested that the increase in revenue is not a seasonality trend, 
instead, the revenue had been steadily increase across the years.

Indeed, there was a small 'bump' in revenue in December comparing to neighbouring months,
however, the reason was not justofied.
*/

SELECT 
    *
FROM
    sales
LIMIT 10;

SELECT 
    *,
    DAY(STR_TO_DATE(Date, '%m/%d/%Y')) AS Day,
    MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) AS Month_numeric
FROM
    sales
LIMIT 10;

DROP TABLE IF EXISTS sales_cleaned;
CREATE TABLE sales_cleaned SELECT *,
    DAY(STR_TO_DATE(Date, '%m/%d/%Y')) AS Day,
    MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) AS Month_numeric FROM
    sales;

SELECT 
    *
FROM
    sales_cleaned
LIMIT 10;

ALTER TABLE sales_cleaned 
DROP COlumn1;

SELECT 
    *
FROM
    sales_cleaned;

# We are interested in the net profit generated by each transaction
# and if there was any difference in profit generated for each product categories

# Let's create a new column calculating the profit

# Create a procedure to drop the net_profit column if it exists
DELIMITER ';;'
CREATE PROCEDURE drop_if_exists(
tname VARCHAR(50),
cname VARCHAR(50)
)
BEGIN
IF EXISTS (SELECT * FROM information_schema.columns WHERE TABLE_SCHEMA = schema() 
AND TABLE_NAME = tname AND COLUMN_NAME = cname)
THEN ALTER TABLE sales_cleaned
DROP COLUMN net_profit;
END IF;
END;;

DELIMITER ;

# Dropping net_profit column
CALL drop_if_exists('sales_cleaned', 'net_profit');

ALTER TABLE sales_cleaned
ADD COLUMN net_profit INT AFTER Revenue;

UPDATE sales_cleaned
SET net_profit = revenue - cost;

SELECT * FROM sales_cleaned
LIMIT 10;

SELECT MAX(net_profit) AS max_profit,
MIN(net_profit) AS min_profit,
AVG(net_profit) AS average_profit
FROM sales_cleaned;
/*
'1842', '-937', '64.8655'

It's interesting that the worst transaction resulted in $937 loss
*/

SELECT `Sub Category`,
AVG(net_profit) AS mean_profit
FROM sales_cleaned
GROUP BY `Sub Category`
ORDER BY mean_profit;

/*
'Bottles and Cages', '24.4697'
'Socks', '26.2115'
'Cleaners', '26.9064'
'Caps', '28.7475'
'Road Bikes', '32.4838'
'Tires and Tubes', '46.0875'
'Mountain Bikes', '52.8414'
'Touring Bikes', '71.0705'
'Fenders', '93.7047'
'Gloves', '95.4521'
'Helmets', '124.1559'
'Jerseys', '150.4380'
'Shorts', '153.7880'
'Bike Stands', '174.4897'
'Hydration Packs', '182.6793'
'Vests', '187.0000'
'Bike Racks', '338.7767'


Surprisingly, selling bikes didn't generate much profit at all, on average
selling a road bikes only generated $32.5, and the highest among bikes were
touring bikes, with $71 on average.
*/

SELECT * FROM sales_cleaned LIMIT 10;

SELECT COUNT(*) FROM sales_cleaned;
