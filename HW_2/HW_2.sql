create table customer_HW_2 (
customer_id int4,
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
)

create table transactions_HW_2 (
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
list_price float8,
standard_cost float8
);

select distinct brand
from transactions_hw_2 th 
where standard_cost > 1500;

 select distinct transaction_date
   from transactions_hw_2;
 
select *
from transactions_hw_2 th 
where th.order_status = 'Approved'
and transaction_date between '01.04.2017' and '09.04.2017';

select *
from customer_hw_2 ch 
where (ch.job_industry_category = 'IT' or ch.job_industry_category = 'Financial Services') 
and ch.job_title like 'Senior%';

select job_title 
from customer_hw_2 ch
where job_title like 'Senior%' 
  and job_industry_category in ('IT', 'Financial Services');

select distinct th.brand
from customer_hw_2 ch 
join transactions_hw_2 th on ch.customer_id = th.customer_id
where ch.job_industry_category ='Financial Services';

select distinct online_order
from transactions_hw_2 th 

select distinct ch.customer_id, ch.first_name, ch.last_name, ch.gender
from customer_hw_2 ch 
join transactions_hw_2 th on ch.customer_id = th.customer_id
where th.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
and th.online_order = 'True'
limit 10;

select ch.customer_id, ch.first_name, ch.last_name, ch.gender, ch.dob, ch.job_title
from customer_hw_2 ch 
left join transactions_hw_2 th on ch.customer_id = th.customer_id
where th.transaction_id is null;

select ch.customer_id, ch.first_name, ch.last_name
from customer_hw_2 ch
join transactions_hw_2 th on ch.customer_id = th.customer_id
where ch.job_industry_category  = 'IT'
and th.standard_cost = (select MAX(th.standard_cost) from transactions_hw_2 th);

select distinct th.order_status 
from transactions_hw_2 th 

select distinct ch.customer_id, ch.first_name, ch.last_name
from customer_hw_2 ch 
join transactions_hw_2 th on ch.customer_id = th.customer_id
where (ch.job_industry_category  = 'IT' or ch.job_industry_category  ='Health')
and th.transaction_date > '07.07.2017' 
and th.transaction_date < '17.07.2017'
and th.order_status = 'Approved';
