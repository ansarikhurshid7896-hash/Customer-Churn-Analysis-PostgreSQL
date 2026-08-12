CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(20),
    date_of_birth DATE,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    occupation VARCHAR(50),
    income_band VARCHAR(30),
    has_partner VARCHAR(10),
    has_dependents VARCHAR(10),
    registration_date DATE
);

CREATE TABLE subscriptions (
    subscription_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    plan_id VARCHAR(30),
    contract_type VARCHAR(30),
    start_date DATE,
    end_date DATE,
    monthly_charge NUMERIC(10,2),
    discount_percentage NUMERIC(5,2),
    payment_method VARCHAR(50),
    paperless_billing VARCHAR(10),
    status VARCHAR(30)
);

CREATE TABLE services (
    service_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    internet_service VARCHAR(30),
    phone_service VARCHAR(10),
    multiple_lines VARCHAR(10),
    online_security VARCHAR(10),
    online_backup VARCHAR(10),
    device_protection VARCHAR(10),
    tech_support VARCHAR(10),
    streaming_tv VARCHAR(10),
    streaming_movies VARCHAR(10)
);

CREATE TABLE customer_usage (
    customer_id BIGINT NOT NULL,
    usage_month DATE NOT NULL,
    calls_made INTEGER,
    call_minutes INTEGER,
    sms_sent INTEGER,
    data_used_gb NUMERIC(10,2),
    login_count INTEGER,
    active_days INTEGER
);

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    payment_date DATE,
    amount NUMERIC(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    late_payment_days INTEGER
);

CREATE TABLE support_tickets (
    ticket_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    ticket_date DATE,
    issue_type VARCHAR(50),
    priority VARCHAR(20),
    resolution_time_hours NUMERIC(10,1),
    satisfaction_score INTEGER,
    resolved VARCHAR(10)
);

CREATE TABLE churn_events (
    churn_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    churn_date DATE,
    churn_reason VARCHAR(100),
    churn_category VARCHAR(50),
    competitor VARCHAR(50),
    days_since_last_activity INTEGER
);


COPY customers
FROM 'C:/sqlprojectdataset/customers.csv'
WITH (FORMAT csv, HEADER true);

--rest data i added manually through right click table -> import/export -> then browse csv ->
-- header on,delimiter ',' -> OK


-- 1.What is the total number of customers?
select count(*) as customer_count from customers;



-- 2.What is the customer distribution by region?
select region,count(customer_id) as total_customer,
round(count(customer_id) * 100.0/sum(count(customer_id)) over(),2) as percentage from customers
group by region;



-- 3.How many customers are subscribed to each plan?
select plan_id , count(*) as total_customers from subscriptions group by plan_id;



-- 4.What is the average monthly charge by plan?
select plan_id , round(avg(monthly_charge),2) as avg_monthly from subscriptions group by plan_id;



-- 5.What are the most common contract types?
select contract_type , count(*) as total from subscriptions group by 
contract_type order by total desc limit 1;



-- 6.How many customers have churned?
select count(distinct customer_id)as total_churned_customers from churn_events;



-- 7.What is the overall churn rate?
select round(count(s.*)*100.0/count(c.*),2) as overall_churn_rate
from customers c left join churn_events s on c.customer_id = s.customer_id;



-- 8.Which subscription plan has the highest churn rate?
select s.plan_id as plan , count(*) total_customer ,count(ce.customer_id) as churned_customer, round(
count(ce.customer_id)*100.0/count(*),2) as churn_rate
from subscriptions s left join churn_events ce on s.customer_id = ce.customer_id
group by plan order by churn_rate desc limit 1;




-- 9.What are the top churn reasons?
select churn_reason,count(*) as Count_of_churn_reason from churn_events 
group by churn_reason order by Count_of_churn_reason desc limit 1;




-- 10.Which contract type has the highest churn rate?
select s.contract_type , count(*) as total_customer ,count(ce.customer_id) as churned_customer,
round(count(ce.customer_id)*100.0/count(*),2)as churn_rate from subscriptions s left join churn_events ce 
on s.customer_id = ce.customer_id group by s.contract_type order by churn_rate desc limit 1;




-- 11.Which region has the highest churn rate?
select c.region ,count(*) as total_customer , count(ce.customer_id) as churned_customer,
round(count(ce.customer_id)*100.0/count(*),2) as churn_rate from customers c left join churn_events ce
on c.customer_id = ce.customer_id group by c.region order by churn_rate desc limit 1;




-- 12.Which payment method has the highest churn rate?
select s.payment_method , count(*) as total_customer ,count(ce.customer_id) as churned_customer,
round(count(ce.customer_id)*100.0/count(*),2)as churn_rate from subscriptions s left join churn_events ce 
on s.customer_id = ce.customer_id group by s.payment_method order by churn_rate desc limit 1;




select *from payments;
-- 13.Do customers with late payments have a higher churn rate?
with inds as (select customer_id , case
when count(*) filter (where payment_status = 'Late') >0
then 'Late'
else 'no late payment' end as payment_status
from payments group by customer_id)
select i.payment_status , count(*) as total_customers , count(ce.customer_id ) as churned_customers,
round(count(ce.customer_id)*100.0/count(*),2) as churn_rate from 
inds i left join churn_events ce on i.customer_id = ce.customer_id
group by i.payment_status order by churn_rate desc;



-- 14.Does having technical support affect churn?
select s.tech_support ,count(*) as total_customers , count(ce.customer_id) as churned_customers,
round(count(ce.customer_id)*100.0/count(*),2) as churn_Rate from services s left join churn_events ce
on s.customer_id = ce.customer_id group by s.tech_support order by churn_rate desc ;




-- 15.Does online security affect churn?
select s.online_security ,count(*) as total_customers , count(ce.customer_id) as churned_customers,
round(count(ce.customer_id)*100.0/count(*),2) as churn_Rate from services s left join churn_events ce
on s.customer_id = ce.customer_id group by s.online_security order by churn_rate desc ;




-- 16.Does customer satisfaction relate to churn?
with sc as (
select customer_id , round(avg(satisfaction_score),0) as satisfaction_score from support_tickets group by customer_id)
select s.satisfaction_score , count(c.customer_id)as total_customer , count(ce.customer_id) as churned_customer,round(
count(ce.customer_id)*100.0/count(c.*),2) as churn_rate from customers c left join sc s on c.customer_id = s.customer_id
left join churn_events ce on c.customer_id = ce.customer_id group by s.satisfaction_score order by churn_rate desc;





-- 17.Do customers with more support tickets have a higher churn rate?
with tc as (select customer_id , case
when count(ticket_id) between 1 and 3 then 'few'
when count(ticket_id) between 4 and 6 then 'some'
when count(ticket_id) between 7 and 10 then 'many'
when count(ticket_id) > 10 then 'Too many' end as ticket_count from support_tickets group by customer_id)
select coalesce(t.ticket_count,'No Tickets')as ticket_count , count(c.customer_id) as total_customer , 
count(ce.customer_id)as churned_customer,round
(count(ce.customer_id)*100.0/count(c.customer_id),2) as churn_rate from customers c left join tc t 
on c.customer_id = t.customer_id left join churn_events ce on c.customer_id = ce.customer_id 
group by t.ticket_count order by churn_rate desc;





-- 18.Find each customer's latest payment using ROW_NUMBER().
select customer_id , payment_date from (select customer_id , payment_date,
row_number() over(partition by customer_id order by payment_date desc)
as rnk from payments)t where rnk = 1;




-- 19.Calculate month-over-month usage change using LAG().
with used as (select date_trunc('month',usage_month)as month_date , sum(active_days) as active_days 
from customer_usage group by month_date),
usage_month as (select month_date ,active_days ,lag(Active_Days) over(order by month_date) as pre_month_usage from
used )
select to_char(month_date,'FMMonth YYYY') as month , active_days ,pre_month_usage, round(
(active_days - pre_month_usage) *100.0 /nullif(pre_month_usage,0),2
)  as m_o_m_usage from usage_month ;






-- 20.Find customers whose usage declined for consecutive months.
with used as (select customer_id , date_trunc('month',usage_month) as month_date, sum(active_days) as active_days
from customer_usage group by customer_id,month_date),
usage_change as (select customer_id, month_date,active_days , 
lag(active_days) over(partition by customer_id order by month_Date)
as pre_month_use,lag(active_days,2) over(partition by customer_id order by month_date)as last_2_month_use from
used)
select distinct customer_id from usage_change where 
active_days < pre_month_use and pre_month_use < last_2_month_use;



-- 21.Find the top 10 high-value customers who churned.
with churned as (select distinct customer_id from churn_events),
top as (select ce.customer_id as cid , sum(p.amount) as total_amount
from payments p join churned ce on p.customer_id = ce.customer_id group by ce.customer_id )
select cid , total_amount from(select cid, total_amount ,dense_rank() over (order by total_amount desc)as rnk 
from top)t where rnk <=10;





-- 22.Rank states by churn rate using a window function.
with ranking as (select c.state as state, count(*)as total_customers ,
count(ce.customer_id) as churned_customers , round(
count(ce.customer_id) *100.0/count(*),2
) as churn_Rate from customers c left join churn_events ce on c.customer_id = ce.customer_id 
group by c.state)
select state ,total_customers,churned_customers,
churn_rate, dense_rank() over(order by churn_rate desc)as state_rank from ranking ;





-- 23.Identify the customer segments with the highest churn rate.
select s.plan_id , s.contract_type ,count(*) as total_customer , count(ce.customer_id) as churned_customers,
round(count(ce.customer_id)*100.0/count(*),2) as churn_rate from subscriptions s left join churn_events ce on
s.customer_id = ce.customer_id group by s.plan_id ,s.contract_type having count(*)>=10000 order by churn_rate desc;





-- 24.Identify high-risk customers based on multiple churn indicators.
with risk_indicator as (select customer_id , 'Late_Payment' as indicator
from payments where payment_status='Late'

union all

select customer_id ,'low_Satisfaction' as indicator
from support_tickets where satisfaction_score <=2

union all

select customer_id , 'High_tickets' as indicator
from support_tickets group by customer_id having count(ticket_id) >6

union all

select customer_id ,'Tech_support' as indicator
from services where tech_support = 'Yes')
select customer_id , count(*) as risk_indicator,
case when count(*)>=3 then 'High Risk'
when count(*) =2 then 'Medium Risk'
else 'Low Risk' end as risk_level
from risk_indicator group by customer_id;












