defmodule DanubianTrade.Repo.Migrations.AddCartCreationProcedure do
  use Ecto.Migration

  def change do
    execute """
    create or replace procedure add_cart(
      user_id_input int,
      product_id_input int,
      quantity_input int
    )
    begin
      declare cart_id int;
      declare cart_products_id int;
      start transaction;
      select id into cart_id from carts where user_id = user_id_input and deleted = 0;

      if cart_id is null then
          insert into carts (user_id, updated_at, inserted_at) values (user_id_input, now(), now());
          select id into cart_id from carts where user_id = user_id_input and deleted = 0;
      end if;

      select id into cart_products_id from cart_products where cart_id = cart_id and product_id = product_id_input;

      if cart_products_id is null then
          insert into cart_products (cart_id, product_id, quantity) values (cart_id, product_id_input, quantity_input);
      else
          update cart_products set quantity = quantity_input + cart_products.quantity where id = cart_products_id;
      end if;

      commit;
    end;
  """
  end
end
