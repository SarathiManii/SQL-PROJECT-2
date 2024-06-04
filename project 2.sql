create database project2;
use project2;
select * from order_sts;
select * from date_wise_report;

-- task 1
 select order_id,count(order_type) as order_count from order_sts where order_type='Stock' group by order_id ;
 select order_id,count(order_type) as order_count from order_sts where order_type='Work_order' group by order_id ;
 
 
 
 
 select order_id,count(if(order_type='stock','yes',null)) as stock_count ,
 count(if(order_type='work_order','no',null))as work_order_count from order_sts group by order_id;
 
 
 -- task 2
 
 select order_id,count(if(order_type='stock','yes',null))as stock_count ,
 count(if(order_type='work_order','yes',null))as work_order_count,
(count(if(order_type='stock','yes',null))-count(if(order_type='work_order','yes',null))) 
 as work_pending_sts
 from order_sts
 group by order_id ;
 
 


create table count_table select order_id,count(if(order_type='stock','yes',null))as stock_count ,
 count(if(order_type='work_order','yes',null))as work_order_count
 from order_sts
 group by order_id ;
 
select * from count_table;
 
 create table work_order_pending select *,(stock_count-work_order_count) as work_order_pending_sts from count_table;
 
 drop table work_order_pending;
 
 select * from work_order_pending;
 
 -- task 3
 
 create table order_pending_sts select *,
 case when work_order_pending_sts<0 then 'Order closed'
 else 'Order pending' 
 end as worked_order_closed_or_not from work_order_pending;
 
 select * from order_pending_sts; 

 -- task 5
 
 select* from order_sts;
 select * from date_wise_report;

create table order_supplier_report select o.Trans,o.order_type,o.Assembly_supplier,O.order_id,o.sale_id,
d.sale_date,d.qty,d.Item_type,d.job_status,d.Buyer_name,d.preferred_supplier,d.Pre_plt,d.post_plt,d.lt,d.run_total
from order_sts as o inner join date_wise_report as d
on  o.sale_id=d.sale_id;

select*from order_supplier_report;


-- task 6

select sale_date,count(qty) as date_wise_qty,count(order_id) as order_id_count from order_supplier_report group by sale_date;


select * from date_wise_report;


delimiter $$
create procedure order_details()
begin
select order_id,count(if(order_type='stock','yes',null)) as stock_count ,
 count(if(order_type='work_order','no',null))as work_order_count from order_sts group by order_id;
 
 select * from work_order_pending;
 
 select * from order_pending_sts; 

select*from order_supplier_report;

select sale_date,count(qty) as date_wise_qty,count(order_id) as order_id_count from order_supplier_report group by sale_date;

end $$
delimiter ;

call order_details();
