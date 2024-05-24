create database data_bank;
use data_bank;




## 1.How many different nodes make uo the data Bank network?

select count(distinct node_id) as unique_nodes
from customer_nodes;

## 2. How many nodes are there in each region?
select r.region_id,count(c.node_id) as node_count
from customer_nodes c
join regions r
on r.region_id = c.region_id
group by region_id;


## 3. How many customes are divided among the regions?
select region_id,region_name,count(distinct customer_id) as count_customer
from regions
join customer_nodes
using(region_id)
group by region_id,region_name;

## 4. Determine the total amount of transactions for each region name.
select region_name,sum(txn_amount) as "total amount"
from regions,customer_nodes,customer_transactions 
where regions.region_id  = customer_nodes.region_id and
customer_nodes.customer_id = customer_transactions.customer_id
group by region_name;



## 5.How long does it take on an average to move clients to a new node?

select round(avg(datediff(end_date,start_date)),2) as avg_days
	from customer_nodes
    where end_date != '9999-12-31';
    

## 6.What is the unique count and total amount for each transations type?
select txn_type,count(*) as unique_count,
	 sum(txn_amount) as total_amount
    from customer_transactions
    group by txn_type;

## 7. what is the average number and size of past deposits across all customers?
select round(count(customer_id)/(select count(distinct customer_id)
from customer_transactions))
 as average_deposits_count
from customer_transactions 
where txn_type = 'Deposit';


 
## 8.  For each month - how many data bank customers make more than 1 deposit
## and at least either 1 purchase or 1 withdrawal in a single month? ##

with transation_per_month_cte as 
(select customer_id,month(txn_date) as txn_month,   
sum(if(txn_type = 'deposit',1,0)) as deposit_count,
sum(if(txn_type = 'withdrawal',1,0)) as withdrawal_count,
sum(if(txn_type = 'purchase',1,0)) as purchase_count
from customer_transactions
group by customer_id,month(txn_month_date))

select txn_month,count(distinct customer_id) as customer_count
	from transation_per_month_cte
    where deposit_count > 1 and 
    withdrawal_cont = 0 or  purchase_count = 0 
    group by txn_month ;



with tranasaction_count_per_month_cte as
(select customer_id,month(txn_date) as txn_month,
sum(if(txn_type ='deposit',1,0)) as deposit_count,
sum(if(txn_type='withdrawal',1,0)) as withdrawal_count,
sum(if(txn_type ='purchase',1,0)) as purchase_count
from customer_transactions
group by customer_id,month(txn_date))

select txn_month,count(distinct customer_id) as customer_count
from tranasaction_count_per_month_cte
where deposit_count  > 1 and 
withdrawal_count = 1 or purchase_count = 1
group by txn_month;


select * from customer_transactions ; 

































