CREATE TABLE `schema_migrations` (`version` bigint, `inserted_at` datetime);

CREATE TABLE `users` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `email` varchar(255),
    `hashed_password` varchar(255),
    `confirmed_at` datetime,
    `inserted_at` datetime,
    `updated_at` datetime
);

CREATE TABLE `user_tokens` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `user_id` int,
    `token` blob,
    `context` varchar(255),
    `sent_to` varchar(255),
    `inserted_at` datetime
);

CREATE TABLE `products` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `name` varchar(255),
    `description` varchar(255),
    `price` decimal,
    `inserted_at` datetime,
    `updated_at` datetime,
    `image` text,
    `creator_id` int,
    `quantity` int
);

CREATE TABLE `carts` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `inserted_at` datetime,
    `updated_at` datetime,
    `user_id` int,
    `deleted` tinyint
);

CREATE TABLE `cart_products` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `cart_id` int,
    `product_id` int,
    `quantity` int
);

CREATE TABLE `orders` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `number` varchar(255),
    `inserted_at` datetime,
    `updated_at` datetime,
    `user_id` int,
    `total_price` decimal
);

CREATE TABLE `order_products` (
    `id` int PRIMARY KEY AUTO_INCREMENT,
    `order_id` int,
    `product_id` int,
    `inserted_at` datetime,
    `updated_at` datetime
);

ALTER TABLE
    `users`
ADD
    FOREIGN KEY (`id`) REFERENCES `user_tokens` (`user_id`);

ALTER TABLE
    `products`
ADD
    FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`);

ALTER TABLE
    `carts`
ADD
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE
    `cart_products`
ADD
    FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`);

ALTER TABLE
    `cart_products`
ADD
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE
    `orders`
ADD
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE
    `order_products`
ADD
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE
    `order_products`
ADD
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

create
or replace procedure add_cart(
    user_id_input int,
    product_id_input int,
    quantity_input int
) begin declare cart_id int;

declare cart_products_id int;

start transaction;

select
    id into cart_id
from
    carts
where
    user_id = user_id_input
    and deleted = 0;

if cart_id is null then
insert into
    carts (user_id, updated_at, inserted_at)
values
    (user_id_input, now(), now());

select
    id into cart_id
from
    carts
where
    user_id = user_id_input
    and deleted = 0;

end if;

select
    id into cart_products_id
from
    cart_products
where
    cart_id = cart_id
    and product_id = product_id_input;

if cart_products_id is null then
insert into
    cart_products (cart_id, product_id, quantity)
values
    (cart_id, product_id_input, quantity_input);

else
update
    cart_products
set
    quantity = quantity_input + cart_products.quantity
where
    id = cart_products_id;

end if;

commit;

end;

create
or replace procedure remove_from_cart(
    product_id_input integer,
    user_id_input integer
) begin declare cart_id integer;

start transaction;

select
    id into cart_id
from
    carts
where
    user_id = user_id_input;

delete from
    cart_products
where
    cart_id = cart_id
    and product_id = product_id_input;

commit;

end;

create
or replace trigger decrement_quantity_insert
after
update
    on cart_products for each row
update
    products
set
    quantity = quantity - (new.quantity - old.quantity)
where
    id = new.product_id;

create
or replace trigger reimburse_quantity_on_cart_removal before delete on cart_products for each row
update
    products
set
    quantity = quantity + old.quantity
where
    id = old.product_id;

create
or replace procedure add_order(
    order_number_input varchar(255),
    cart_id_input int
) begin declare customer_id int;

declare order_id int;

declare order_total_price decimal;

start transaction;

select
    user_id into customer_id
from
    carts
where
    id = cart_id_input
    and deleted = 0;

insert into
    orders(number, user_id, inserted_at, updated_at)
values
    (order_number_input, customer_id, now(), now());

select
    id into order_id
from
    orders
where
    number = order_number_input;

insert into
    order_products (order_id, product_id, inserted_at, updated_at)
select
    order_id,
    product_id,
    now(),
    now()
from
    cart_products
where
    cart_id = cart_id_input;

select
    sum(products.price * cp.quantity) into order_total_price
from
    order_products
    inner join products on order_products.product_id = products.id
    inner join cart_products cp on products.id = cp.product_id
where
    order_id = order_id;

update
    orders
set
    total_price = order_total_price
where
    id = order_id;

commit;

end;

create
or replace function get_user_cart_id(user_id_input integer) returns integer begin return (
    select
        id
    from
        carts
    where
        user_id = user_id_input
        and deleted = 0
);

end;

create
or replace trigger clear_user_cart
after
update
    on orders for each row begin
update
    carts
set
    deleted = 1
where
    user_id = new.user_id;

end;