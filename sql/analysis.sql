# Insights of Amazon_sales Project

# KPI's 
# Total Orders
select count(*) as total_orders
from fact_amazon_sales;

# Shipped Orders Status
# Total Shipped 
select count(*) as total_orders
from fact_amazon_sales f
join dim_status d on d.status_id = f.status_id
where order_status like 'shipped%';

# Only Delivered shipped
select count(*) as total_delivered
from fact_amazon_sales f
join dim_status d on d.status_id = f.status_id
where order_status = 'Shipped - Delivered to Buyer';

# Only Returned to Seller 
select count(*) as total_returned_order
from fact_amazon_sales f
join dim_status d on d.status_id = f.status_id
where order_status = 'Shipped - Returned to Seller';

# Total Cancelled orders
select count(*) as total_cancelled_orders
from fact_amazon_sales f
join dim_status d on d.status_id = f.status_id
where order_status = 'Cancelled';

# Total Revenue 
select 
	concat(format(sum(amount)/1000000,2),' INR Millon') as total_revenue
from fact_amazon_sales;
    
 # Average Order values
select 
	sum(amount)/count(distinct or_id) as AOV
from fact_amazon_sales;

# Sales Trend Analysis
# Weekly Sales Trend
select 
	dayname(d.order_date) as weekdays,
    count(*) as weekly_orders
from fact_amazon_sales f
join dim_date d on d.date_id = f.date_id
group by dayname(d.order_date)
order by count(*) desc;

# Monthly Sales Trend
select 
	monthname(d.order_date) as month_name,
    count(*) as monthly_orders
from fact_amazon_sales f
join dim_date d on d.date_id = f.date_id
group by monthname(d.order_date)
order by count(*) desc;

# Quarterly Sales Trand
select
	quarter,
    count(*) as quarterly_count
from fact_amazon_sales f
join dim_date d on d.date_id = f.date_id
group by quarter
order by count(*) desc;

# Yearly Sales Trend
select 
	year,
	count(*) as yearly_orders
from fact_amazon_sales f
join dim_date d on d.date_id = f.date_id
group by year
order by count(*) desc;
 
# location-wise Performance
# State-wise Performance
# Top 10 states by revenue
select 
	l.ship_state, 
    sum(f.amount) as state_revenue,
    concat(format(sum(f.amount)/1000000,2),' INR Millon') as revenue_million
from fact_amazon_sales f
join dim_location l on l.location_id = f.location_id
group by l.ship_state
order by sum(f.amount)  desc
limit 10;
 
# State-wise level
select 
	l.ship_state,
	case 
    when s.ship_service_level = 'Standard' then 'Normal delivery'
	when s.ship_service_level = 'Expedited' then 'Fast delivery' 
    else 'others'
    end as delivery_type,
	count(*) as total_orders
from fact_amazon_sales f
join dim_service s on s.service_id = f.service_id
join dim_location l on l.location_id =  f.location_id
group by delivery_type,
	     l.ship_state
order by count(s.ship_service_level) desc;

# total fulfillment
select 
	fulfillment,
    count(*) as fulfillment_orders
from fact_amazon_sales f
join dim_service s on s.service_id = f.service_id
group by fulfillment
order by count(*) desc;

# total sales_channel revenue
select 
	s.sales_channel,
    sum(f.amount) as total_channel_revenue
from fact_amazon_sales f
join dim_service s on s.service_id = f.service_id
group by s.sales_channel
order by total_channel_revenue desc;

# Top Product by Month
select 
	monthname(d.order_date) as month_name,
	p.category,
	p.style,
    p.size,
    count(f.qty) as order_qty
from fact_amazon_sales f
join dim_product p on p.product_id = f.product_id
join dim_date d on d.date_id = f.date_id
group by 
		monthname(d.order_date),
		p.category,
        p.style,
		p.size
order by order_qty desc
limit 10;
    
# Top Category by service orders
select 
	s.ship_service_level,
    p.category,
    count(f.qty) as order_by_category
from fact_amazon_sales f
join dim_service s on s.service_id = f.service_id 
join dim_product p on p.product_id = f.product_id
group by s.ship_service_level,
		 p.category
order by order_by_category desc
limit 10;
 
# courier_status by state
select 
	l.ship_state,
    sum(case when c.courier_status = 'shipped' then 1 else 0 end) as shipped_orders,
	sum(case when c.courier_status = 'Cancelled' then 1 else 0 end) as cancelled_orders,
	sum(case when c.courier_status = 'Unshipped' then 1 else 0 end) as unshipped_orders,
    sum(case when c.courier_status in ('shipped','Cancelled','Unshipped') then 1 else 0 end) as total_orders
from fact_amazon_sales f
join dim_courier_status c on c.courier_status_id = f.courier_status_id
join dim_location l on l.location_id = f.location_id
group by l.ship_state
order by shipped_orders desc
limit 10;

# Top 10 locations by order volume
select 
	l.ship_state,
    count(distinct o.or_id) as orders_volume
from fact_amazon_sales f
join dim_location l on l.location_id = f.location_id
join dim_order o on o.or_id = f.or_id
group by l.ship_state
order by orders_volume desc
limit 10;


select *from dim_product;
select 
	p.size,
    sum(f.amount) as size_sales
from fact_amazon_sales f
join dim_product p on p.product_id = f.product_id
group by p.size
order by size_sales desc;

select 
	p.category,
    sum(f.amount) as total_sales,
    sum(f.qty) as total_qty
from fact_amazon_sales f
join dim_product p on p.product_id = f.product_id
group by p.category
order by total_sales desc;
