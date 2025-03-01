create table customer_id_HW_3 (
customer_id int,
first_name varchar,
last_name varchar,
gender varchar,
DOB varchar,
job_title varchar,
job_industry_category varchar,
wealth_segment varchar,
deceased_indicator varchar,
owns_car varchar,
address varchar,
postcode varchar,
state varchar,
country varchar,
property_valuation int
);

create table transaction_HW_3 (
transaction_id int,
product_id int,
customer_id int,
transaction_date varchar,
online_order varchar,
order_status varchar,
brand varchar,
product_line varchar,
product_class varchar,
product_size varchar,
list_price float4,
standard_cost float4
);

select job_industry_category, COUNT(customer_id) AS customer_count
from customer_id_HW_3
group by job_industry_category
order by customer_count desc;

select
	to_char(to_date(th.transaction_date, 'DD-MM-YYYY'), 'MM-YYYY') as transaction_month,
	ch.job_industry_category, 
	sum(th.list_price) as total_transactions
from transaction_hw_3 th join customer_id_hw_3 ch 
on th.customer_id = ch.customer_id
group by transaction_month, ch.job_industry_category
order by transaction_month, ch.job_industry_category


select 
	th.brand,
	count(th.transaction_id) as online_order_count
from transaction_hw_3 th join customer_id_hw_3 ch on th.customer_id = ch.customer_id 
where 
	th.online_order = 'True' and th.order_status = 'Approved' and ch.job_industry_category = 'IT'
group by th.brand
order by th.brand

select
	ch.customer_id,
	sum(th.list_price) as total_transaction_sum,
	count(th.transaction_id) as transaction_count,
	min(th.list_price) as min_transaction,
	max(th.list_price) as max_transaction
from customer_id_hw_3 ch join transaction_hw_3 th on ch.customer_id = th.customer_id
group by ch.customer_id
order by total_transaction_sum desc, 
transaction_count desc;

with transaction_summary as (
    select
        c.customer_id,
        sum(t.list_price) over (partition by c.customer_id) as total_transaction_sum,
        count(t.transaction_id) over (partition by c.customer_id) as transaction_count,
        min(t.list_price) over (partition by c.customer_id) as min_transaction,
        max(t.list_price) over (partition by c.customer_id) as max_transaction
    from 
        customer_id_hw_3 c
    join 
        transaction_hw_3 t on c.customer_id = t.customer_id
)
select distinct
    customer_id,
    total_transaction_sum,
    transaction_count,
    min_transaction,
    max_transaction
from 
    transaction_summary
order by 
    total_transaction_sum desc, 
    transaction_count desc;

with transaction_total_min as (
    select
        customer_id,
        sum(list_price) as total_sum
    from
        transaction_HW_3
    group by
        customer_id
    having
        sum(list_price) is not null
),
min_transaction as (
    select
        min(total_sum) as min_sum
    from
        transaction_total_min
)
select
    c.first_name,
    c.last_name
from
    customer_id_HW_3 c
join
    transaction_total_min t on c.customer_id = t.customer_id
where
    t.total_sum = (select min_sum from min_transaction);

with transaction_total_max as (
    select
        customer_id,
        sum(list_price) as total_sum
    from
        transaction_HW_3
    group by
        customer_id
    having
        sum(list_price) is not null
),
max_transaction as (
    select
        max(total_sum) as max_sum
    from
        transaction_total_max
)
select
    c.first_name,
    c.last_name
from
    customer_id_HW_3 c
join
    transaction_total_max t on c.customer_id = t.customer_id
where
    t.total_sum = (select max_sum from max_transaction);

select
    c.customer_id,
    c.first_name,
    c.last_name,
    t.transaction_id,
    t.transaction_date,
    t.list_price
from
    customer_id_HW_3 c
join (
    select
        transaction_id,
        customer_id,
        transaction_date,
        list_price,
        row_number() over (partition by customer_id order by to_date(transaction_date, 'DD-MM-YYYY')) as rn
    from
        transaction_HW_3
) t on c.customer_id = t.customer_id
where
    t.rn = 1;

with transaction_intervals as (
    select
        t.customer_id,
        t.transaction_date,
        lag(t.transaction_date) over (partition by t.customer_id order by t.transaction_date) as prev_transaction_date,
        (to_date(t.transaction_date, 'DD-MM-YYYY') - to_date(lag(t.transaction_date) over (partition by t.customer_id order by t.transaction_date), 'DD-MM-YYYY')) as interval_days
    from
        transaction_hw_3 t
),
max_intervals as (
    select
        customer_id,
        max(interval_days) as max_interval
    from
        transaction_intervals
    group by
        customer_id
)
select
    c.first_name,
    c.last_name,
    c.job_title
from
    customer_id_hw_3 c
join
    max_intervals mi
on
    c.customer_id = mi.customer_id
order by
    mi.max_interval desc
limit 1;