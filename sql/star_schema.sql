# Creating Star Sechma

# Creta Dimentions 
# Dim_order
create table dim_order(
	or_id int auto_increment primary key,
    order_id varchar(30));

# dim_date
create table dim_date(
	date_id int auto_increment primary key,
	order_date date,
	year int,
    month int,
    month_name varchar(20),
    quarter int,
    day int,
    week int);

# dim_status
create table dim_status(
	status_id int auto_increment primary key,
	order_status varchar(100));
    
# dim_Service
create table dim_service(
	service_id int auto_increment primary key,
	fulfillment varchar(50),
    sales_channel varchar(50),
    ship_service_level varchar(50));
    
# dim_Product
create table dim_product(
	product_id int auto_increment primary key,
    style varchar(100),
    sku varchar(100),
    category varchar(100),
    size varchar(100),
    asin varchar(100));

# dim_courier_status
create table dim_courier_status(
	courier_status_id int auto_increment primary key,
    courier_status varchar(100),
    b2b varchar(50));
  
# dim_location
create table dim_location(
	location_id int auto_increment primary key,
	ship_state VARCHAR(100),
    ship_postal_code varchar(30),
    ship_country VARCHAR(100));

# Create Fact Table
create table fact_amazon_sales(
	fact_id int auto_increment primary key,
    
    or_id int,
    qty int,
    amount decimal(10,2),
    
    date_id int,
    status_id int,
    service_id int,
    product_id int,
    courier_status_id int,
    location_id int,
    
	foreign key (or_id) references dim_order(or_id),
	foreign key (date_id) references dim_date(date_id),
	foreign key (status_id) references dim_status(status_id),
	foreign key (service_id) references dim_service(service_id),
	foreign key (product_id) references dim_product(product_id),
	foreign key (courier_status_id) references dim_courier_status(courier_status_id),
	foreign key (location_id) references dim_location(location_id));

# data insert into deimensions
# dim_order
insert into dim_order(order_id)
select distinct
	order_id
from amazon_sales
where order_id is not null;

# dim_date
insert into dim_date(order_date,year,month,month_name,quarter,day,week)
select distinct
	order_date,
    year(order_date),
    month(order_date),
    monthname(order_date),
	quarter(order_date),
    day(order_date),
    week(order_date)
from amazon_sales 
where order_date is not null;

# dim_status
insert into dim_status(order_status)
select distinct
	nullif(trim(order_status),'')
from amazon_sales
where nullif(trim(order_status),'') is not null;

# dim_service
insert into dim_service(fulfillment,sales_channel,ship_service_level)
select distinct
	nullif(trim(fulfillment),''),
	nullif(trim(sales_channel),''),
	nullif(trim(ship_service_level),'')
from amazon_sales
where
	nullif(trim(fulfillment),'') is not null
and	nullif(trim(sales_channel),'') is not null 
and	nullif(trim(ship_service_level),'') is not null;

# dim_product
insert into dim_product(style,sku,category,size,asin)
select distinct
	nullif(trim(style),''),
    nullif(trim(sku),''),
    nullif(trim(category),''),
    nullif(trim(size),''),
    nullif(trim(asin), '')
from amazon_sales
where 
	nullif(trim(style),'') is not null
and	nullif(trim(sku),'') is not null
and nullif(trim(category),'') is not null
and nullif(trim(size),'') is not null
and nullif(trim(asin), '') is not null;

# dim_courier_status
insert into dim_courier_status(courier_status,b2b)
select distinct
	nullif(trim(courier_status),''),
    nullif(trim(b2b), '')
from amazon_sales
where
	nullif(trim(courier_status),'') is not null
and nullif(trim(b2b), '') is not null;

# dim_location
insert into dim_location(ship_state,ship_postal_code,ship_country)
select distinct 
	nullif(trim(ship_state),''),
    nullif(trim(ship_postal_code),''),
    nullif(trim(ship_country),'')
from amazon_sales
where 
	nullif(trim(ship_state),'')  is not null
and nullif(trim(ship_postal_code),'') is not null
and nullif(trim(ship_country),'') is not null;

# Data insert into fact table
insert into fact_amazon_sales(
	or_id,
    qty,
    amount,
    
    date_id,
    status_id,
    service_id,
    product_id,
    courier_status_id,
    location_id)	
    
select
    o.or_id,
    cast(nullif(trim(qty),'') as signed),
    cast(nullif(trim(amount),'')as decimal(10,2)),
    
    d.date_id,
    s.status_id,
    sr.service_id,
    p.product_id,
    c.courier_status_id,
    l.location_id
from amazon_sales a

left join dim_order o 
	on  o.order_id = a.order_id

left join dim_date d
	on d.order_date = date(a.order_date)

left join dim_status s
  on s.order_status = NULLIF(TRIM(a.order_status), '')
  
left join dim_service sr
	on sr.fulfillment = nullif(trim(a.fulfillment),'')
    and sr.sales_channel = nullif(trim(a.sales_channel),'')
    and sr.ship_service_level = nullif(trim(a.ship_service_level),'')

left join dim_product p
	on p.style = nullif(trim(a.style),'')
    and p.sku = nullif(trim(a.sku),'')
    and p.category = nullif(trim(a.category),'')
    and p.size = nullif(trim(a.size),'')
    and p.asin = nullif(trim(a.asin),'')
    
left join dim_courier_status c
	on c.courier_status = nullif(trim(a.courier_status),'')
    and c.b2b = nullif(trim(a.b2b),'')

left join dim_location l
	on l.ship_state = nullif(trim(a.ship_state),'')
	and l.ship_postal_code = nullif(trim(a.ship_postal_code),'')
    and l.ship_country = nullif(trim(a.ship_country),'');

select * from 
	fact_amazon_sales f
	join dim_order o on o.or_id = f.or_id
    join dim_date d on d.date_id = f.date_id
    join dim_status s on s.status_id = f.status_id
    join dim_service sr on sr.service_id = f.service_id
    join dim_product p on p.product_id = f.product_id
    join dim_courier_status c on c.courier_status_id = f.courier_status_id
    join dim_location l on l.location_id = f.location_id;
