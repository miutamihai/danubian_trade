defmodule DanubianTrade.Repo.Migrations.AddOrderProcedure do
  use Ecto.Migration

  def change do
    execute """
      create or replace procedure add_order(
    order_number_input varchar(255),
    cart_id_input int
    )
    begin
    declare customer_id int;
    declare order_id int;
    declare order_total_price decimal;
    start transaction;
    select user_id into customer_id from carts where id = cart_id_input and deleted = 0;
    insert into orders(number, user_id, inserted_at, updated_at) values (order_number_input, customer_id, now(), now());
    select id into order_id from orders where number = order_number_input;
    insert into order_products (order_id, product_id, inserted_at, updated_at)
    select order_id, product_id, now(), now()
    from cart_products
    where cart_id = cart_id_input;
    select sum(products.price * cp.quantity) into order_total_price
    from order_products
             inner join products on order_products.product_id = products.id
             inner join cart_products cp on products.id = cp.product_id
    where order_id = order_id;

    update orders set total_price = order_total_price where id = order_id;
    commit;
    end;
    """
  end
end
