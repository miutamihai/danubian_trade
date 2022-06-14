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
        start transaction;
        select id into cart_id from carts where user_id = user_id_input;

        if cart_id is null then
            insert into carts (user_id, updated_at, inserted_at) values (user_id_input, now(), now());
            select id into cart_id from carts where user_id = user_id_input;
        end if;

        insert into cart_products (cart_id, product_id, quantity) values (cart_id, product_id_input, quantity_input);
      commit;
    end;
  """
  end
end
