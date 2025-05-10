-- Создание аналитической схемы для petshop

drop table if exists sales_fact cascade;
drop table if exists customer_dim cascade;
drop table if exists seller_dim cascade;
drop table if exists product_dim cascade;
drop table if exists store_dim cascade;
drop table if exists supplier_dim cascade;
drop table if exists pet_dim cascade;
drop table if exists date_dim cascade;

-- Измерение покупателей
create table customer_dim (
    customer_id serial primary key,
    first_name text,
    last_name text,
    age int,
    email text,
    country text,
    postal_code text,
    unique(email)
);

-- Измерение продавцов
create table seller_dim (
    seller_id serial primary key,
    first_name text,
    last_name text,
    email text,
    country text,
    unique(email)
);

-- Измерение товаров
create table product_dim (
    product_id serial primary key,
    title text,
    group_name text,
    cost numeric(12,2),
    unique(title, group_name)
);

-- Измерение магазинов
create table store_dim (
    store_id serial primary key,
    title text,
    country text
);

-- Измерение поставщиков
create table supplier_dim (
    supplier_id serial primary key,
    title text,
    email text,
    country text,
    unique(email)
);

-- Измерение питомцев
create table pet_dim (
    pet_id serial primary key,
    kind text,
    nickname text,
    breed text,
    unique(kind, nickname, breed)
);

-- Измерение дат
create table date_dim (
    date_id serial primary key,
    full_date date unique,
    year int,
    month int,
    day int,
    weekday int
);

-- Фактовая таблица продаж
create table sales_fact (
    sale_id serial primary key,
    date_id int references date_dim(date_id),
    customer_id int references customer_dim(customer_id),
    seller_id int references seller_dim(seller_id),
    product_id int references product_dim(product_id),
    store_id int references store_dim(store_id),
    supplier_id int references supplier_dim(supplier_id),
    pet_id int references pet_dim(pet_id),
    quantity int,
    total_cost numeric(12,2)
); 