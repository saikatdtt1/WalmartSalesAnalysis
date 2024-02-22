use walmart;

#----------- Importing data from csv file

ALTER TABLE `walmart`.`salesdata` 
ADD COLUMN `Day time` VARCHAR(45) NOT NULL AFTER `Rating`,
ADD COLUMN `Day name` VARCHAR(45) NOT NULL AFTER `Day time`,
ADD COLUMN `Month name` VARCHAR(45) NOT NULL AFTER `Day name`;

ALTER TABLE `walmart`.`salesdata` 
CHANGE COLUMN `Day time` `Day_time` VARCHAR(45) NOT NULL ,
CHANGE COLUMN `Day name` `Day_name` VARCHAR(45) NOT NULL ,
CHANGE COLUMN `Month name` `Month_name` VARCHAR(45) NOT NULL ;

select * from salesdata;

#------------- Updating new columns

UPDATE salesdata
SET Day_time = (
	CASE
		WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
select * from salesdata;
UPDATE salesdata
SET Day_name = (dayname(Date));
UPDATE salesdata
SET Month_name = (monthname(Date));
select * from salesdata;

# ---- DATA ANALYSIS ------

## How many unique cities does the data have?

select distinct city from salesdata;

## In which city is each branch?

select distinct city, branch from salesdata;

## How many unique product lines does the data have?

select distinct Product_line from salesdata;

## What is the most selling product line?

select Product_line, sum(Quantity) as total_quantity from salesdata group by Product_line Order by total_quantity desc;

## What is the total revenue by month?

Select Month_name,
	round(sum(Total),2) as Revenue
from salesdata group by Month_name Order by Revenue desc;

## What month had the largest COGS?

Select Month_name,
	round(sum(cogs),2) as total_cogs
from salesdata group by Month_name Order by total_cogs desc;

## What product line had the largest revenue?

select Product_line, round(sum(Total),2) as total_revenue_by_product from salesdata group by Product_line Order by total_revenue_by_product desc;

## What is the city with the largest revenue?

select City, round(sum(Total),2) as total_revenue_by_city from salesdata group by City Order by total_revenue_by_city desc;

## What product line had the largest VAT?

select Product_line, max(Vat) as Vat_by_product from salesdata group by Product_line Order by Vat_by_product desc;

## Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

Select round(avg(Quantity),2) from salesdata;
Select Product_line,
	case 
		when avg(Quantity) > round(avg(Quantity),2) then "Good"
        else "Bad"
    end as Performance
from salesdata
group by Product_line;

## Which branch sold more products than average product sold?

Select round(avg(Quantity),2) from salesdata;
Select Branch
from salesdata
group by Branch having sum(Quantity) > avg(Quantity);

## What is the most common product line by gender?

select Product_line,
	Gender,
    count(Gender) as total_count
from salesdata
group by Product_line, Gender
order by total_count desc;

## What is the average rating of each product line?

select Product_line,
	round(avg(Rating),1) as Avg_rating
from salesdata
group by Product_line
order by Avg_rating desc;

## How many unique customer types does the data have?

select distinct Customer_type from salesdata;

## How many unique payment methods does the data have?

select distinct Payment from salesdata;

## What is the most common customer type?

select Customer_type, count(Customer_type) as count from salesdata group by Customer_type;

## What is the gender of most of the customers?

select Gender, count(Gender) as count from salesdata group by Gender;

## What is the gender distribution per branch?

select Branch, Gender, count(Gender) as count from salesdata group by Branch, Gender order by Branch;

## Which time of the day do customers give most ratings?

select Day_time, count(Rating) as count from salesdata group by Day_time order by count desc;

## Which time of the day do customers give most ratings per branch?

select Branch, Day_time, count(Rating) as count from salesdata group by Branch, Day_time order by Branch;

## Which day of the week has the best avg ratings?

select Day_name, round(avg(Rating),2) as avg_rating from salesdata group by Day_name order by avg_rating desc;

## Which day of the week has the best average ratings per branch?

select Day_name, Branch, round(avg(Rating),2) as avg_rating from salesdata group by Day_name, Branch order by avg_rating desc;

## Number of sales made in each time of the day per weekday?

select Day_name, Day_time, count(*) as count from salesdata group by Day_name, Day_time having Day_name != "Sunday" order by count desc;

## Which of the customer types brings the most revenue?

select Customer_type, round(sum(Total),2) as revenue from salesdata group by Customer_type;

## Which customer type pays the most in VAT?

select Customer_type, round(avg(Vat),2) as vat_count from salesdata group by Customer_type;

## Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT city, ROUND(AVG(Vat), 2) AS avg_vat FROM salesdata GROUP BY city ORDER BY avg_vat DESC;

