#                                   SOME IMPORTANT CODES BEFORE WE START OUR PROJECT

use pizza_project ;
select * from pizza_sales ;

#                                     LET'S START OUR PRJECT WITH KPI  

# total_revenue,    avg_order_value,    total_pizza_sold,    total_orders,    avg_pizza_per_order

select  cast(sum(total_price) as decimal(10,2)) as Total_Revenue from pizza_sales ;

select cast(sum(total_price)/count(distinct order_id) as decimal(10,2)) as Avg_Order_Value from pizza_sales ;

select sum(quantity) as Total_Pizza_Sold from pizza_sales ;

select count(distinct order_id) as Total_Orders from pizza_sales ;

select cast(count(order_id)/count(distinct order_id) as decimal(10,2)) as Avg_Pizza_Per_Order from pizza_sales ;





#                             NOW WE HAVE ALL KIP LET'S MOVE FURTHER FOR INFO  

# we are having result issue, to solve this we need to convert order_date column type from 'int' to 'date' let's do it 

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales MODIFY COLUMN order_date DATE;


# daily trend for total orders 

select DAYNAME(order_date) as week_days, count(distinct order_id) as Total_Orders from pizza_sales 
group by  week_days
order by  Total_Orders ;



# monthly trend for total orders 

select monthname(order_date) as week_days, count(distinct order_id) as Total_Orders from pizza_sales 
group by  week_days
order by Total_Orders ;



# pizza category vs sales of pizza in PR%

select pizza_category,  cast((sum(total_price)*100)/(select sum(total_price) from pizza_sales) as decimal(10,2)) as PR_Sales 
from pizza_sales
group by pizza_category ;



# pizza size vs sales of pizza in PR%

select pizza_size,  cast((sum(total_price)*100)/(select sum(total_price) from pizza_sales) as decimal(10,2)) as PR_Sales 
from pizza_sales
group by pizza_size ;



# pizza category vs pizza sold 

select pizza_category, count(quantity) as Total_Pizza_Sold from pizza_sales
group by pizza_category ;



# Top 5 Best seller pizza 

select * from 
(
select *,
rank () over( order by a.Total_Revenue desc) as Top_Rank
from 
(
select pizaa_name as Pizza_Name, cast(sum(total_price) as decimal(10,2)) as Total_Revenue, sum(quantity) as Total_pizza_sold,
count(distinct order_id) as Total_Orders 
 from pizza_sales 
group by pizaa_name 
) as a 
) as b 
where Top_Rank <= 5;



# bottom 5 worst seller pizza 

select * from 
(
select *,
rank () over( order by a.Total_Revenue) as Bottom_Rank
from 
(
select pizaa_name as Pizza_Name, cast(sum(total_price) as decimal(10,2)) as Total_Revenue, sum(quantity) as Total_pizza_sold,
count(distinct order_id) as Total_Orders 
 from pizza_sales 
group by pizaa_name 
) as a 
) as b 
where Bottom_Rank <= 5;
