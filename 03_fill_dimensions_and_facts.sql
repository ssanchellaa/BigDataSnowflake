-- Заполнение измерений и фактов

-- Покупатели
insert into customer_dim (first_name, last_name, age, email, country, postal_code)
select distinct
    cust_fname, cust_lname, cust_age, cust_email, cust_country, cust_postal
from petshop_raw
where cust_email is not null;

-- Продавцы
insert into seller_dim (first_name, last_name, email, country)
select distinct
    seller_fname, seller_lname, seller_email, seller_country
from petshop_raw
where seller_email is not null;

-- Товары
insert into product_dim (title, group_name, cost)
select distinct
    product_title, product_group, product_cost
from petshop_raw
where product_title is not null and product_group is not null;

-- Магазины
insert into store_dim (title, country)
select distinct
    store_title, cust_country
from petshop_raw
where store_title is not null;

-- Поставщики
insert into supplier_dim (title, email, country)
select distinct
    supplier_title, supplier_email, supplier_country
from petshop_raw
where supplier_email is not null;

-- Питомцы
insert into pet_dim (kind, nickname, breed)
select distinct
    pet_kind, pet_nickname, pet_breed
from petshop_raw
where pet_kind is not null and pet_nickname is not null and pet_breed is not null;

-- Даты
insert into date_dim (full_date, year, month, day, weekday)
select distinct
    sale_dt,
    extract(year from sale_dt),
    extract(month from sale_dt),
    extract(day from sale_dt),
    extract(dow from sale_dt)
from petshop_raw
where sale_dt is not null;

-- Фактовая таблица продаж
insert into sales_fact (
    date_id, customer_id, seller_id, product_id, store_id, supplier_id, pet_id, quantity, total_cost
)
select
    d.date_id,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sup.supplier_id,
    pet.pet_id,
    r.product_qty,
    r.product_cost * r.product_qty
from petshop_raw r
join customer_dim c on r.cust_email = c.email
join pet_dim pet on r.pet_kind = pet.kind and r.pet_nickname = pet.nickname and r.pet_breed = pet.breed
join seller_dim s on r.seller_email = s.email
join product_dim p on r.product_title = p.title and r.product_group = p.group_name
join store_dim st on r.store_title = st.title
join supplier_dim sup on r.supplier_email = sup.email
join date_dim d on r.sale_dt = d.full_date; 