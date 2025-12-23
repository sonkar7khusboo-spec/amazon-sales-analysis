# sql/data_cleaning

# create file & load data
create table amazon_sales(
	    id INT,
    order_id VARCHAR(50),
    order_date DATE,
    Order_status VARCHAR(255),
    fulfillment VARCHAR(255),
    sales_channel VARCHAR(255),
    ship_service_level VARCHAR(255),
    style VARCHAR(255),
    sku VARCHAR(255),
    category VARCHAR(255),
    size VARCHAR(255),
    asin VARCHAR(255),
    courier_status VARCHAR(255),
    qty INT,
    currency VARCHAR(50),
    amount DECIMAL(10,2),
    ship_state VARCHAR(255),
    ship_postal_code varchar(30),
    ship_country VARCHAR(255), 
    promotion_ids text,
    b2b VARCHAR(10),
    fulfilled_by VARCHAR(255),
    other_info VARCHAR(255)
);

load data infile  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Amazon Sale Report.csv'
into table amazon_sales
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
    id,
    Order_ID,
    @Order_Date,
    Order_status,
    fulfillment,
    Sales_Channel,
    ship_service_level,
    Style,
    SKU,
    Category,
    Size,
    ASIN,
    Courier_Status,
    Qty,
    currency,
    @amount,
    ship_state,
    ship_postal_code,
    ship_country,
    promotion_ids,
    B2B,
    fulfilled_by,
    other_info
)
set order_date = str_to_date(@order_date, '%d-%m-%Y'),
	    amount = NULLIF(@amount, '');

# Drop Unnecessary Columns
alter table amazon_sales drop column other_info;
alter table amazon_sales drop column fulfilled_by;
alter table amazon_sales drop column promotion_ids;
alter table amazon_sales drop column currency;

# # Check Null Values in Data
select
	  sum(case when id is null then 1 else 0 end) as null_id,
	  sum(case when order_id is null then 1 else 0 end) as null_order_id,
    sum(case when order_status is null then 1 else 0 end) as null_order_status,
    sum(case when fulfillment is null then 1 else 0 end) as null_Fulfilment,
    sum(case when Sales_Channel is null then 1 else 0 end) as null_Sales_Channel,
    sum(case when ship_service_level is null then 1 else 0 end) as null_ship_service_level,
    sum(case when Style is null then 1 else 0 end) as null_Style,
    sum(case when sku is null then 1 else 0 end) as null_sku,
    sum(case when Category is null then 1 else 0 end) as null_Category,
    sum(case when Size is null then 1 else 0 end) as null_Size,
    sum(case when ASIN is null then 1 else 0 end) as null_ASIN,
    sum(case when Courier_Status is null then 1 else 0 end) as null_Courier_Status,
    sum(case when Qty is null then 1 else 0 end) as null_Qty,
    sum(case when Amount is null then 1 else 0 end) as null_Amount,
    sum(case when ship_state is null then 1 else 0 end) as null_ship_state,
    sum(case when ship_postal_code is null then 1 else 0 end) as null_ship_postal_code,
    sum(case when ship_country is null then 1 else 0 end) as null_ship_country,
    sum(case when b2b is null then 1 else 0 end) as null_b2b
from amazon_sales;

# Fill null values
update amazon_sales
set amount = 0
where amount is null;

# Blank & Empty String 
select
    sum(case when order_status = '' then 1 else 0 end) as blank_status,
    sum(case when fulfillment = '' then 1 else 0 end) as blank_fulfilment,
    sum(case when sales_channel = '' then 1 else 0 end) as blank_sales_channel,
    sum(case when ship_service_level = '' then 1 else 0 end) as blank_ship_service_level,
    sum(case when style = '' then 1 else 0 end) as blank_style,
    sum(case when sku = '' then 1 else 0 end) as blank_sku,
    sum(case when category = '' then 1 else 0 end) as blank_category,
    sum(case when size = '' then 1 else 0 end) as blank_size,
    sum(case when asin = '' then 1 else 0 end) as blank_asin,
    sum(case when courier_status = '' then 1 else 0 end) as blank_courier_status,
    sum(case when ship_state = '' then 1 else 0 end) as blank_ship_state,
    sum(case when ship_postal_code = '' then 1 else 0 end) as blank_ship_postal_code,
    sum(case when ship_country = '' then 1 else 0 end) as blank_ship_country,
    sum(case when b2b = '' then 1 else 0 end) as blank_b2b
from amazon_sales;

# check Formats in data
select* from  amazon_sales;
select distinct fulfillment from amazon_sales;
select distinct order_status from amazon_sales;
select distinct sales_channel from amazon_sales;
select distinct ship_service_level from amazon_sales;
select distinct style from amazon_sales;
select distinct category from amazon_sales;
select distinct size from amazon_sales;
select distinct asin from amazon_sales;
select distinct courier_status from amazon_sales;
select distinct ship_state from amazon_sales;
select distinct ship_postal_code from amazon_sales;
select distinct ship_country from amazon_sales;
select distinct b2b from amazon_sales;

update amazon_sales
set ship_state = 
	case 
    when ship_state = 'NL' then 'NAGALAND'
	when ship_state = 'RJ' then 'RAJASTHAN'
    when ship_state = 'rajsthan' then 'RAJASTHAN'
    when ship_state = 'Rajshthan' then 'RAJASTHAN'
    when ship_state = 'PB' then 'PUNJAB'
    when ship_state = 'Punjab/Mohali/Zirakpur' then 'PUNJAB'
    when ship_state = 'orissa' then 'ODISHA'
    when ship_state = 'AR' then 'ARUNACHAL PRADESH'
    when ship_state = 'APO' then 'ODISHA'
    when ship_state = 'Pondicherry' then 'PUDUCHERRY'
end 
where ship_state in(
'NL', 'RJ', 'rajsthan', 'Rajshthan',
    'PB', 'Punjab/Mohali/Zirakpur',
    'orissa', 'AR','APO','Pondicherry');

update amazon_sales
	set ship_state = concat(upper(left(ship_state, 1)),lower(substring(ship_state,2)))
where ship_state = upper(ship_state);

# Fill Blanks Data
select courier_status, count(*) 
from amazon_sales
group by courier_status
order by count(*) desc;

update amazon_sales
set courier_status = 'Shipped'
where courier_status is null
or	  courier_status = '';

update amazon_sales
set ship_state = 'Unknown'
where ship_state is null
or ship_state = '';

update amazon_sales
set ship_postal_code = '000000'
where ship_postal_code is null
or ship_postal_code = '';

update amazon_sales
set ship_country = 'Unknown'
where ship_country is null
or ship_country = '';

update amazon_sales 
set ship_country = 'India'
where ship_country = 'IN';

# Diduct Duplicated Values
select 
	order_id, order_date, order_status, fulfillment, sales_channel, ship_service_level, style, sku, category, size, asin, courier_status, qty, amount,
	ship_state,	ship_postal_code, ship_country, b2b, count(*) as dup_cnt
from amazon_sales
group by 
	order_id, order_date, order_status, fulfillment, sales_channel, ship_service_level, style, sku, category, size, asin, courier_status, qty, amount,
	ship_state,	ship_postal_code, ship_country, b2b
having count(*)>1;

# check from order_id it is result true or false 
SELECT 
    order_id, sku, qty, amount
FROM amazon_sales
GROUP BY order_id, sku, qty, amount
HAVING COUNT(*) > 1;

select *  from amazon_sales
where order_id = '408-0373839-4433120'
order by sku,qty,amount;

# Delete Duplicated Records 
with cte as(
	select*,
		row_number() over(partition by order_id, order_date, order_status, fulfillment, sales_channel, ship_service_level, style, sku, 
        category, size, asin, courier_status, qty, amount,
		ship_state,	ship_postal_code, ship_country, b2b order by id) as rn from amazon_sales)
delete from amazon_sales
where id in (select id from cte where rn > 1);




