-- 顧客
-- alter table customer alter column customer_id type text;

create table customer
(
    customer_id text primary key,
    name        text not null unique,
    phone       text,
    mail        text
);

insert into customer (customer_id, name, phone, mail)
values ('C-101', '山田太郎', '045-xxx-1234','yamada@test.com'),
       ('C-102', '鈴木次郎', '045-xxx-2345','suzuki@test.com'),
       ('C-103', '佐藤三郎', '045-xxx-3456','sato@test.com'),
       ('C-104', 'マイケルジャクソン', '045-xxx-4567','mike@test.com'),
       ('C-105', 'カニエウェスト', '045-xxx-5678', 'kanye@test.com');

select * from customer;

-- 注文
create table pizza_order
(
    order_id text primary key,
    customer_id text references customer(customer_id),
    date text
);

insert into pizza_order (order_id, customer_id, date)
values ('O-101', 'C-101','2020-01-11'),
       ('O-102', 'C-102','2020-01-13'),
       ('O-103', 'C-103','2020-02-02'),
       ('O-104', 'C-104','2020-02-04');

select * from pizza_order;
select * from pizza_order p join customer c using (customer_id) order by p.order_id;

-- product(商品)
create table product
(
    product_id text primary key,
    title      text    not null unique,
    price      integer not null
);

insert into product(product_id, title, price);
values ('P-101', 'マルゲリータ', 800),
       ('P-102', 'バジルトマト', 900),
       ('P-103', 'ミートソース', 1000),
       ('P-104', 'アンチョビ・シーフード', 1000),
       ('P-105', 'クアトロフォルマッジ', 1300);

select * from product;

-- 注文明細
insert into order_line (order_id, product_id, amount)
values ('O-101', 'P-101',1),
       ('O-102', 'P-101',2),
       ('O-102', 'P-102',2),
       ('O-102', 'P-105',1),
       ('O-103', 'P-103',4),
       ('O-103', 'P-101',2),
       ('O-104', 'P-103',5);

-- すべてのテーブルを結合
select *
from pizza_order p
         join order_line ol on p.order_id = ol.order_id
         join product pr on ol.product_id = pr.product_id
         join customer c on p.customer_id = c.customer_id
order by p.order_id;
/*
 order_id | customer_id |    date    | order_id | product_id | amount | product_id |        title         | price | customer_id |        name        |    phone     |      mail
----------+-------------+------------+----------+------------+--------+------------+----------------------+-------+-------------+--------------------+--------------+-----------------
 O-101    | C-101       | 2020-01-11 | O-101    | P-101      |      1 | P-101      | マルゲリータ         |   800 | C-101       | 山田太郎           | 045-xxx-1234 | yamada@test.com
 O-102    | C-102       | 2020-01-13 | O-102    | P-101      |      2 | P-101      | マルゲリータ         |   800 | C-102       | 鈴木次郎           | 045-xxx-2345 | suzuki@test.com
 O-102    | C-102       | 2020-01-13 | O-102    | P-102      |      2 | P-102      | バジルトマト         |   900 | C-102       | 鈴木次郎           | 045-xxx-2345 | suzuki@test.com
 O-102    | C-102       | 2020-01-13 | O-102    | P-105      |      1 | P-105      | クアトロフォルマッジ |  1300 | C-102       | 鈴木次郎           | 045-xxx-2345 | suzuki@test.com
 O-103    | C-103       | 2020-02-02 | O-103    | P-103      |      4 | P-103      | ミートソース         |  1000 | C-103       | 佐藤三郎           | 045-xxx-3456 | sato@test.com
 O-103    | C-103       | 2020-02-02 | O-103    | P-101      |      2 | P-101      | マルゲリータ         |   800 | C-103       | 佐藤三郎           | 045-xxx-3456 | sato@test.com
 O-104    | C-104       | 2020-02-04 | O-104    | P-103      |      5 | P-103      | ミートソース         |  1000 | C-104       | マイケルジャクソン | 045-xxx-4567 | mike@test.com
(7 rows)
*/

-- 注文数の多い人気のピザ
select p.product_id, p.title, sum(amount) as 合計
from product p
         join order_line ol using (product_id)
group by product_id
order by 合計 desc, p.product_id;

/*
 product_id |        title         | 合計
------------+----------------------+------
 P-103      | ミートソース         |    9
 P-101      | マルゲリータ         |    5
 P-102      | バジルトマト         |    2
 P-105      | クアトロフォルマッジ |    1
(4 rows)
*/
