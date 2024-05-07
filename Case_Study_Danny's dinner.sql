CREATE database dannys_diner;
use dannys_diner;
Create table sales (
Customer_id varchar(1),
order_date date,
product_id int
);
INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);
INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);
INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

---   -- Case Study Questions --

 --1. What is the total amount each customer spent at the restaurant?
 
 Select sales.customer_id,sum(menu.price) as total_amount
 from sales left join menu on sales.product_id = menu.product_id
 group by sales.customer_id
 order by sales.customer_id Asc;
 
 --2. How many days has each customer visited the restaurant?
 
 select customer_id,count(distinct(order_date)) as visiting_day
 from sales
 group by customer_id;
 
 --3.What was the first item from the menu purchased by each customer?
 
 with first_item As (
 select s.customer_id,s.order_date,m.product_name,
 dense_rank() OVER(partition by s.customer_id order by s.order_date) as item
 from sales s left join menu m on s.product_id = m.product_id )
 select customer_id,product_name 
 from first_item
 where item = 1
 group by customer_id,product_name;
 
 --4.What is the most purchased item on the menu and how many times was it purchased by all customers?
 select menu.product_name , count(sales.product_id) as most_purchased
 from sales  left join menu  on sales.product_id = menu. product_id
 group by menu.product_name
 order by most_purchased desc
 limit 1;

 --5.Which item was the most popular for each customer?
with order_count as(
select s.customer_id,m.product_name,count(*) as order_count
from sales s left join menu m on m.product_id = s.product_id
group by 1,2),
popular_count as(
select * ,
dense_rank() over(partition by customer_id order by order_count desc) as ranking
from order_count)
select * from popular_count
where ranking = 1;

--6. Which item was purchased first by the customer after they became a member?
with cte as(
select s.customer_id,s.order_date,m.product_name,meb.join_date
from sales s left join menu m on  s.product_id = m.product_id
join members meb on s.customer_id = meb.customer_id
where order_date >join_date),
rslt as(
select * ,
row_number() over(partition by s.customer_id order by join_date) as ranking
from cte)
select * from rslt
where ranking =1;

--8.What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(s.product_id)as total_item,sum(m.price)as amnt
from sales s join menu m on s.product_id = m.product_id
left join members meb on s.customer_id = meb.customer_id
where order_date < join_date
group by 1
order by customer_id;

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?
 with point_cte as(
 select menu.product_id,
   case
	  when product_id =1 then price*20
      else price*10 end as points
      from menu)
     select s.customer_id,sum(point_cte.points) as total_point
     from sales s left join point_cte on s.product_id = point_cte.product_id
     group by 1
     order by customer_id;
     
     --10. In the first week after a customer joins the program (including their join date)
     --they earn 2x points on all items, not just sushi — how many points do customer A and B
     --have at the end of January?
     
     with points as(
     select s.customer_id,m.product_name,m.price,s.order_date,
     (s.order_date - meb.join_date) as first_week
     from sales s join menu m on s.product_id = m.product_id
     join members meb on s.customer_id = meb.customer_id),
     price as(
     select customer_id,
     order_date, 
			  case
			    when first_week between 0 and 7 then price*20
                when (first_week > 7 or first_week < 0 )  and product_name = "sushi" then price * 20
                  when (first_week > 7 or first_week < 0 )  and product_name != "sushi" then price * 10
            end as total_points from points )
              select customer_id ,sum(price.total_points) as points
     from price
            where extract(month from order_date) = 1
            group by 1
            order by 1;
            
        
 
	 
 
 