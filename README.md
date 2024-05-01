This repository contains all of my code submissions for the #SQLChallenge!
- For my code submissions I used Mysql database.

# 🍜 Case Study #1 - Danny's Diner


![image](https://github.com/nancypriya1008/Danny-s-Dinner/assets/168542945/52ffcd63-6a9e-4c16-b8c0-7e199b63a97a)

## Introduction

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

## Business Task
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

## DATASET
Danny has shared with you 3 key datasets for this case study:
- sales
- menu
- members

### 1. What is the total amount each customer spent at the restaurant?
'''mysql
 Select sales.customer_id,sum(menu.price) as total_amount
 from sales left join menu on sales.product_id = menu.product_id
 group by sales.customer_id
 order by sales.customer_id Asc;
'''









